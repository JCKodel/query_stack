part of query_stack;

@immutable
class Query<T> extends InheritedModel<String> {
  const Query({
    super.key,
    required String queryKey,
    required void Function([bool keepPreviousData]) refreshFn,
    required super.child,
  })  : _queryKey = queryKey,
        _refreshFn = refreshFn;

  final String _queryKey;
  final void Function([bool keepPreviousData]) _refreshFn;

  @override
  bool isSupportedAspect(Object aspect) => aspect is String && aspect == _queryKey;

  static Query<T>? maybeOf<T>(BuildContext context, String queryKey) {
    return InheritedModel.inheritFrom<Query<T>>(context, aspect: queryKey);
  }

  static Query<T> of<T>(BuildContext context, String queryKey) {
    final result = maybeOf<T>(context, queryKey);

    assert(result != null, "Unable to find an instance of Query in the widget tree");

    return result!;
  }

  void refresh([bool keepPreviousData = false]) {
    _refreshFn(keepPreviousData);
  }

  @override
  bool updateShouldNotify(Query<T> oldWidget) {
    return false;
  }

  @override
  bool updateShouldNotifyDependent(Query<T> oldWidget, Set<String> dependencies) {
    return false;
  }
}

@immutable
class QueryFutureBuilder<T> extends StatefulWidget {
  const QueryFutureBuilder({
    required this.queryKey,
    this.initialData,
    required this.future,
    this.onError,
    this.errorBuilder,
    this.onWaiting,
    this.waitingBuilder,
    this.onEmpty,
    this.emptyBuilder,
    this.onData,
    required this.dataBuilder,
    this.maxAttempts = kDebugMode ? 1 : 3,
    this.retryDelay = const Duration(milliseconds: 500),
    this.staleDuration = const Duration(seconds: 3),
    this.refetchInterval,
    this.refetchIntervalInBackground = false,
    this.refetchOnAppFocus = true,
    this.keepPreviousData = true,
    super.key,
  });

  final String queryKey;
  final Future<T?> Function() future;
  final T? initialData;
  final void Function(BuildContext context, Object error)? onError;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final void Function(BuildContext context)? onWaiting;
  final Widget Function(BuildContext context)? waitingBuilder;
  final void Function(BuildContext context)? onEmpty;
  final Widget Function(BuildContext context)? emptyBuilder;
  final void Function(BuildContext context, T data)? onData;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final int maxAttempts;
  final Duration retryDelay;
  final Duration staleDuration;
  final Duration? refetchInterval;
  final bool refetchIntervalInBackground;
  final bool refetchOnAppFocus;
  final bool keepPreviousData;

  @override
  State<QueryFutureBuilder<T>> createState() => _QueryFutureBuilderState<T>();
}

class _QueryFutureBuilderState<T> extends State<QueryFutureBuilder<T>> with WidgetsBindingObserver implements RouteAware {
  final _streamController = BehaviorSubject<QueryResult<T>>();
  Timer? _refreshTimer;
  bool _isAlive = true;
  DateTime? _lastFetch;
  int _attempts = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    QueryFutureBuilderRouteObserver.instance.subscribe(this, ModalRoute.of(context)!);

    final observers = ModalRoute.of(context)?.navigator?.widget.observers;

    if (observers != null) {
      if (observers.contains(QueryFutureBuilderRouteObserver.instance) == false) {
        throw Exception(
          "When using QueryFutureBuilder, you NEED to add the QueryFutureBuilderRouteObserver"
          " in your app's navigationObservers.\n\n"
          "This can be done in your app class:\n\n"
          "...return MaterialApp( // or CupertinoApp\n"
          "  navigatorObservers: [QueryFutureBuilderRouteObserver.instance]",
        );
      }
    }
  }

  @override
  void didChangePlatformBrightness() {
    _refetchIfStale();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    _refetchIfStale();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    if (widget.refetchInterval != null) {
      _refreshTimer = Timer.periodic(
        widget.refetchInterval!,
        (_) {
          if (widget.refetchIntervalInBackground || _isAlive) {
            _refetchIfStale();
          }
        },
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _refetchIfStale());
  }

  @override
  void dispose() {
    if (_refreshTimer != null) {
      _refreshTimer!.cancel();
    }

    WidgetsBinding.instance.removeObserver(this);
    QueryFutureBuilderRouteObserver.instance.unsubscribe(this);
    super.dispose();
  }

  void _refetchIfStale() {
    if (_lastFetch != null && (widget.refetchInterval == null || widget.refetchIntervalInBackground == false)) {
      final isTopMost = ModalRoute.of(context)?.isCurrent ?? false;
      if (isTopMost == false || _isAlive == false) {
        log(
          "\x1B[35m${widget.runtimeType} is not top-most (${isTopMost}, ${_isAlive})\x1B[0m",
          name: "QueryFutureBuilder<${T}>",
        );

        return;
      }
    }

    if (_lastFetch != null) {
      final difference = DateTime.now().difference(_lastFetch!);

      if (difference.inMilliseconds <= widget.staleDuration.inMilliseconds) {
        log(
          "\x1B[35m${widget.runtimeType} is not stale\x1B[0m",
          name: "QueryFutureBuilder<${T}>",
        );

        return;
      }
    }

    _refetch();
  }

  void _refetch([bool? keepPreviousData]) {
    log(
      "\x1B[34mFetching...\x1B[0m",
      name: "QueryFutureBuilder<${T}>",
    );

    if (keepPreviousData ?? widget.keepPreviousData == false) {
      _streamController.add(WaitingResult<T>());
    }

    widget.future().then(
      (data) {
        _attempts = 0;
        _lastFetch = DateTime.now();

        if (data == null || (data is Iterable && data.isEmpty)) {
          _streamController.add(EmptyResult<T>());

          log(
            "\x1B[33m${widget.runtimeType} is empty\x1B[0m",
            name: "QueryFutureBuilder<${T}>",
          );
        } else {
          _streamController.add(DataResult<T>(data));

          log(
            "\x1B[32m${widget.runtimeType} has data\x1B[0m",
            name: "QueryFutureBuilder<${T}>",
          );

          if (kDebugMode) {
            log(
              "\x1B[37m${data}\x1B[0m",
              name: "QueryFutureBuilder<${T}>",
            );
          }
        }
      },
    ).onError(
      (error, stackTrace) {
        _attempts++;

        log(
          "\x1B[31m${widget.runtimeType} throws ${error.runtimeType} "
          "attempt ${_attempts}/${widget.maxAttempts}\x1B[0m",
          name: "QueryFutureBuilder<${T}>",
        );

        if (kDebugMode) {
          log(
            "\x1B[33m${error}\x1B[0m",
            name: "QueryStreamBuilder<${T}>",
          );
        }

        if (_attempts >= widget.maxAttempts) {
          _streamController.addError(error!, stackTrace);
        }

        Future<void>.delayed(widget.retryDelay).then(
          (_) => _refetchIfStale(),
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isAlive = true;

        if (widget.refetchOnAppFocus) {
          _refetchIfStale();
        }
        break;
      case AppLifecycleState.inactive:
        _isAlive = false;
        break;
      case AppLifecycleState.paused:
        _isAlive = false;
        break;
      case AppLifecycleState.detached:
        _isAlive = false;
        break;
    }
  }

  @override
  void didPop() {
    _isAlive = false;
  }

  @override
  void didPopNext() {
    _isAlive = true;
    _refetchIfStale();
  }

  @override
  void didPush() {}

  @override
  void didPushNext() {
    _isAlive = false;
  }

  @override
  Widget build(BuildContext context) {
    late final QueryResult<T> initialData;

    if (widget.initialData == null) {
      initialData = WaitingResult<T>();
    } else if (widget.initialData is Iterable && (widget.initialData as Iterable).isEmpty) {
      initialData = EmptyResult<T>();
    } else {
      initialData = DataResult<T>(widget.initialData as T);
    }

    return Query<T>(
      queryKey: widget.queryKey,
      refreshFn: _refetch,
      child: StreamBuilder<QueryResult<T>>(
        initialData: initialData,
        stream: _streamController.stream,
        builder: _snapshotBuilder,
      ),
    );
  }

  Widget _snapshotBuilder(BuildContext context, AsyncSnapshot<QueryResult<T>> snapshot) {
    if (snapshot.hasError) {
      final error = snapshot.error!;

      if (widget.onError != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => widget.onError!(context, error));
      }

      return widget.errorBuilder == null ? ErrorWidget(error) : widget.errorBuilder!(context, error);
    }

    if (snapshot.connectionState == ConnectionState.waiting || snapshot.data is WaitingResult<T>) {
      if (widget.onWaiting != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => widget.onWaiting!(context));
      }

      return widget.waitingBuilder == null ? const Center(child: CircularProgressIndicator.adaptive()) : widget.waitingBuilder!(context);
    }

    if (snapshot.data is EmptyResult<T>) {
      if (widget.onEmpty != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => widget.onEmpty!(context));
      }

      return widget.emptyBuilder == null ? const SizedBox() : widget.emptyBuilder!(context);
    }

    final result = snapshot.data as DataResult<T>;

    if (widget.onData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onData!(context, result.data));
    }

    return widget.dataBuilder(context, result.data);
  }
}
