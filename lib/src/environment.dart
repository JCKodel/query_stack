part of query_stack;

typedef UseDelegate = TInterface Function<TInterface extends Object>();
typedef InjectorDelegate<TInterface extends Object> = TInterface Function(UseDelegate use);
typedef RegisterDependenciesDelegate = void Function<TInterface extends Object>(InjectorDelegate<TInterface> constructor);

/// Inherit this class to build a (some) suitable environments
/// for your application.
@immutable
abstract class Environment {
  const Environment();

  static final _dependencies = <Type, Object Function(UseDelegate use)>{};
  static final _instances = <Type, Object>{};
  static final _routeObserver = EnvironmentProviderRouteObserver();
  static final _platformInfo = getCurrentPlatformInfo();
  static final _queryStreams = <Type, Map<QueryKey, dynamic>>{};
  static final _mutationStreams = <Type, Map<QueryKey, dynamic>>{};

  /// Is the app running in debug mode?
  bool get isDebug => kDebugMode;

  /// The `EnvironmentProviderRouteObserver` that need to be added
  /// to app's `navigatorObservers` so the `QueryBuilder`s works
  /// properly
  EnvironmentProviderRouteObserver get routeObserver => _routeObserver;

  /// Information regarding the current platform running your app
  PlatformInfo get platformInfo => _platformInfo;

  /// This method should register all your dependencies.
  @protected
  void registerDependencies(RegisterDependenciesDelegate when);

  /// This method will be called during the `EnvironmentProvider`
  /// initialization, after the `registerDependencies`, so you
  /// can initialize whatever you need to (that otherwise would
  /// be done in the `main`)
  @protected
  Future<void> initializeAsync(UseDelegate use);

  static TInterface _use<TInterface extends Object>() {
    final instance = _instances[TInterface];

    if (instance != null) {
      return instance as TInterface;
    }

    final constructor = _dependencies[TInterface];

    if (constructor == null) {
      throw Exception("There is no dependency registered for ${TInterface}");
    }

    return _instances[TInterface] = constructor(_use) as TInterface;
  }

  /// Use this method to retrieve a registered dependency.
  ///
  /// `TInterface` is the interface registered and it will
  /// return the concrete class, as registered in the
  /// `Environment.registerDependencies`
  TInterface use<TInterface extends Object>() {
    return _use<TInterface>();
  }

  static void _when<TInterface extends Object>(InjectorDelegate<TInterface> constructor) {
    _dependencies[TInterface] = constructor;
  }

  /// This is the same mechanism used in `QueryBuilder` to fetch a query.
  /// It will return the query state, it will retry for `maxAttempts` before
  /// returning an error, etc.
  ///
  /// `queryKey` is the unique key of your query (all `QueryBuilder` with the same
  /// key will be rebuilt)
  ///
  /// `queryFn` is the function that returns the data that will be given to all `QueryBuilder`s
  /// and be cached
  ///
  /// `maxAttempts` represents the max attempts of running the `queryFn` before it considers an error.
  /// When set to 3, it means it will fail on the first try, then two more before set `isError = true`.
  ///
  /// `retryDelay` is the delay before any new attempt.
  ///
  /// `staleDuration` is the period when the query will not be refetched automatically (i.e.: the cache
  /// duration). After the stale duration, any event that needs a refetch will be executed.
  Future<Query<T>> query<T>(
    QueryKey queryKey,
    FutureOr<T?> Function(UseDelegate use) queryFn, {
    int maxAttempts = 3,
    Duration retryDelay = const Duration(seconds: 1),
    Duration staleDuration = const Duration(seconds: 3),
  }) async {
    final queryStream = _getQueryStream<T>(queryKey);

    final query = queryStream.valueOrNull ??
        Query<T>(
          failureCount: 0,
          hasRun: false,
          data: null,
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
      return query.startFetching(false);
    }

    return query;
  }

  /// This is the same mechanism used in `MutationBuilder` to mutate a query.
  /// It will return the mutation state, it will retry for `maxAttempts` before
  /// returning an error, etc.
  ///
  /// `queryKey` is the unique key of your query (all `QueryBuilder` with the same
  /// key will be rebuilt)
  ///
  /// `mutateFn` is the function that returns the data that will be given to all `QueryBuilder`s
  /// and be cached
  ///
  /// `maxAttempts` represents the max attempts of running the `queryFn` before it considers an error.
  /// When set to 1, it means it will try only once before setting `isError = true`.
  ///
  /// `retryDelay` is the delay before any new attempt.
  Future<Mutation<T>> mutate<T>(
    QueryKey queryKey,
    FutureOr<T?> Function(UseDelegate use) mutateFn, {
    int maxAttempts = 1,
    Duration retryDelay = const Duration(seconds: 1),
  }) async {
    final mutationStream = _getMutationStream<T>(queryKey);

    final mutation = mutationStream.valueOrNull ??
        Mutation<T>(
          failureCount: 0,
          hasRun: false,
          data: null,
          isBusy: false,
          isError: false,
          isIdle: true,
          isRunning: false,
          isSuccess: false,
          maxAttempts: maxAttempts,
          queryKey: queryKey,
          retryDelay: retryDelay,
          dataUpdatedAt: null,
          error: null,
          errorUpdatedAt: null,
        );

    return mutation.mutate(mutateFn);
  }

  static BehaviorSubject<Query<TData>> _getQueryStream<TData>(QueryKey queryKey) {
    final queryStreams = _queryStreams[TData] ?? _createQueryStreams<TData>(queryKey);
    final queryStream = queryStreams[queryKey] ?? _createQueryStream<TData>();

    return queryStream as BehaviorSubject<Query<TData>>;
  }

  static Map<QueryKey, dynamic> _createQueryStreams<TData>(QueryKey queryKey) {
    return _queryStreams[TData] = {queryKey: _createQueryStream<TData>()};
  }

  static BehaviorSubject<Query<TData>> _createQueryStream<TData>() {
    return BehaviorSubject<Query<TData>>();
  }

  static BehaviorSubject<Mutation<TData>> _getMutationStream<TData>(QueryKey queryKey) {
    final mutationStreams = _mutationStreams[TData] ?? _createMutationStreams<TData>(queryKey);
    final mutationStream = mutationStreams[queryKey] ?? _createMutationStream<TData>();

    return mutationStream as BehaviorSubject<Mutation<TData>>;
  }

  static Map<QueryKey, dynamic> _createMutationStreams<TData>(QueryKey queryKey) {
    return _mutationStreams[TData] = {queryKey: _createMutationStream<TData>()};
  }

  static BehaviorSubject<Mutation<TData>> _createMutationStream<TData>() {
    return BehaviorSubject<Mutation<TData>>();
  }

  /// This will replace the data inside the specified queryKey, rebuilding
  /// all `QueryBuilder` involved.
  ///
  /// `queryKey` is the key that will be affected by this data.
  ///
  /// `data` is the data to be added to the cache (and passed to all `QueryBuilder`s).
  ///
  /// `isSpecificKey` changes how the key is searched: by exact match or starting with,
  /// so when you specify `["authentication"]`, `true` will match only that key, while
  /// `false` (the default) will match keys such as `["authentication", "123"]` as well.
  ///
  /// Notice that `queryKey` must match also `T`! (i.e.: only `QueryBuilder<T>` will be
  /// updated)
  void setCachedData<T>({required QueryKey queryKey, required T? data, bool isSpecificKey = false}) {
    _setCachedData<T>(queryKey, data, isSpecificKey);
  }

  static void _setCachedData<T>(QueryKey queryKey, T? data, bool isSpecificKey) {
    final queryStreams = _queryStreams[T];

    if (queryStreams == null) {
      return;
    }

    final queryKeyString = queryKey.toString();

    for (final entry in queryStreams.entries) {
      final match = isSpecificKey ? entry.key.toString() == queryKeyString : entry.key.toString().startsWith(queryKeyString);

      if (match) {
        final queryStream = _getQueryStream<T>(entry.key);

        if (queryStream.hasValue) {
          final query = queryStream.value._setSuccess(data, queryStream.value.data);

          queryStream.add(query);
        }
      }
    }
  }

  /// This will refetch all queries with the specified queryKey, rebuilding
  /// all `QueryBuilder` involved.
  ///
  /// `queryKey` is the key that will be affected by this data.
  ///
  /// `data` is the data to be added to the cache (and passed to all `QueryBuilder`s).
  ///
  /// `isSpecificKey` changes how the key is searched: by exact match or starting with,
  /// so when you specify `["authentication"]`, `true` will match only that key, while
  /// `false` (the default) will match keys such as `["authentication", "123"]` as well.
  ///
  /// `isStaleOnly` will ignore queries that are not stale if is `true`. When `false` (
  /// the default value), all queries will be refreshed, no matter if they are stale or not
  ///
  /// `keepPreviousData` when `true` (the default value) will not set the query to
  /// loading state (so the UI won't show any progress UI), but the query will be fetched
  /// in the background. When `false`, the query will be set to loading before any
  /// fetch attempt.
  void refetch({required QueryKey queryKey, bool isStaleOnly = false, bool isSpecificKey = false, bool keepPreviousData = true}) {
    _refetch(queryKey, isStaleOnly, isSpecificKey, keepPreviousData);
  }

  static void _refetch(QueryKey queryKey, bool isStaleOnly, bool isSpecificKey, bool keepPreviousData) {
    final queryKeyString = queryKey.toString();

    for (final entry in _queryStreams.entries) {
      final match = isSpecificKey ? entry.key.toString() == queryKeyString : entry.key.toString().startsWith(queryKeyString);

      if (match) {
        final dynamic queryStream = entry.value;

        if (queryStream.hasValue == true) {
          final match = isStaleOnly ? queryStream.value.isStale == true : true;

          if (match) {
            queryStream.value.startFetching(keepPreviousData);
          }
        }
      }
    }
  }
}
