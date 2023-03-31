part of query_stack;

class QueryBuilder<TData> extends StatefulWidget {
  const QueryBuilder({
    required this.queryKey,
    required this.queryFn,
    required this.builder,
    this.maxAttempts = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.staleDuration = const Duration(seconds: 3),
    this.refetchInterval,
    this.refetchIntervalInBackground = false,
    this.refetchOnAppFocus = true,
    this.onSuccess,
    this.onError,
    this.onSettled,
    this.keepPreviousData = false,
    this.placeholderData,
    super.key,
  });

  final QueryKey queryKey;
  final FetchDelegate<TData?> queryFn;
  final Widget Function(BuildContext context, Query<TData> result) builder;
  final int maxAttempts;
  final Duration retryDelay;
  final Duration staleDuration;
  final bool keepPreviousData;
  final TData? placeholderData;
  final void Function(TData? data)? onSuccess;
  final void Function(Object error)? onError;
  final void Function(Query<TData> result)? onSettled;

  final Duration? refetchInterval;
  final bool refetchIntervalInBackground;
  final bool refetchOnAppFocus;

  @override
  State<QueryBuilder<TData>> createState() => _QueryBuilderState<TData>();
}

class _QueryBuilderState<TData> extends State<QueryBuilder<TData>> with WidgetsBindingObserver implements RouteAware {
  Timer? _refreshTimer;
  bool _isAlive = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Environment._routeObserver.subscribe(this, ModalRoute.of(context)!);

    final observers = ModalRoute.of(context)?.navigator?.widget.observers;

    if (observers != null) {
      if (observers.contains(Environment._routeObserver) == false) {
        throw Exception(
          "When using QueryBuilder, you NEED to add the Environment route observer in your app's navigationObservers.\n\n"
          "This can be done in your app class:\n\n"
          "...return MaterialApp( // or CupertinoApp\n"
          "  navigatorObservers: [EnvironmentProvider.of(context).routeObserver]",
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
  }

  @override
  void dispose() {
    if (_refreshTimer != null) {
      _refreshTimer!.cancel();
    }

    WidgetsBinding.instance.removeObserver(this);
    Environment._routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _QueryBuilder(
      queryKey: widget.queryKey,
      queryFn: widget.queryFn,
      builder: widget.builder,
      maxAttempts: widget.maxAttempts,
      retryDelay: widget.retryDelay,
      staleDuration: widget.staleDuration,
      keepPreviousData: widget.keepPreviousData,
      placeholderData: widget.placeholderData,
      onSuccess: widget.onSuccess,
      onError: widget.onError,
      onSettled: widget.onSettled,
    );
  }

  void _refetchIfStale() {
    final queryStream = Environment._getQueryStream<TData>(widget.queryKey);

    if (queryStream.hasValue && queryStream.value.isStale) {
      queryStream.value.startFetching(widget.keepPreviousData);
    }
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
}

class _QueryBuilder<TData> extends StatelessWidget {
  const _QueryBuilder({
    required this.queryKey,
    required this.queryFn,
    required this.builder,
    required this.maxAttempts,
    required this.retryDelay,
    required this.staleDuration,
    this.onSuccess,
    this.onError,
    this.onSettled,
    required this.keepPreviousData,
    this.placeholderData,
    super.key,
  });

  final QueryKey queryKey;
  final FetchDelegate<TData?> queryFn;
  final Widget Function(BuildContext context, Query<TData> result) builder;
  final int maxAttempts;
  final Duration retryDelay;
  final Duration staleDuration;
  final void Function(TData? data)? onSuccess;
  final void Function(Object error)? onError;
  final void Function(Query<TData> result)? onSettled;
  final bool keepPreviousData;
  final TData? placeholderData;

  @override
  Widget build(BuildContext context) {
    final queryStream = Environment._getQueryStream<TData>(queryKey);

    final query = queryStream.valueOrNull ??
        Query<TData>(
          failureCount: 0,
          hasRun: false,
          data: placeholderData,
          isBusy: false,
          isError: false,
          isPreviousData: false,
          isRunning: false,
          isSuccess: false,
          maxAttempts: maxAttempts,
          queryKey: queryKey,
          refetch: queryFn,
          retryDelay: retryDelay,
          staleDuration: staleDuration,
          dataUpdatedAt: null,
          error: null,
          errorUpdatedAt: null,
        );

    if (query.isStale) {
      query.startFetching(keepPreviousData);
    }

    return StreamBuilder<Query<TData>>(
      initialData: query,
      stream: queryStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Log.error(QueryBuilder<TData>, snapshot.error!);
        } else {
          switch (snapshot.data!.status) {
            case QueryStatus.idle:
              Log.idle(QueryBuilder<TData>);
              break;
            case QueryStatus.loading:
              Log.busy(QueryBuilder<TData>);
              break;
            case QueryStatus.error:
              Log.error(QueryBuilder<TData>, snapshot.data!.error!);

              if (onError != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onError!(snapshot.data!.error!));
              }

              if (onSettled != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onSettled!(snapshot.data!));
              }
              break;
            case QueryStatus.empty:
            case QueryStatus.success:
              if (onSuccess != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onSuccess!(snapshot.data!.data));
              }

              if (onSettled != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onSettled!(snapshot.data!));
              }

              Log.success(QueryBuilder<TData>, snapshot.data!.data);
              break;
          }
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}
