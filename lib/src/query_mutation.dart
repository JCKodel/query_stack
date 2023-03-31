part of query_stack;

abstract class BaseQueryMutation<T> implements IEquatable {
  const BaseQueryMutation({
    required QueryKey queryKey,
    T? data,
    DateTime? dataUpdatedAt,
    Object? error,
    DateTime? errorUpdatedAt,
    required int failureCount,
    required int maxAttempts,
    required Duration retryDelay,
    required bool isError,
    required bool isBusy,
    required bool isRunning,
    required bool hasRun,
    required bool isSuccess,
  })  : _queryKey = queryKey,
        _data = data,
        _dataUpdatedAt = dataUpdatedAt,
        _error = error,
        _errorUpdatedAt = errorUpdatedAt,
        _failureCount = failureCount,
        _maxAttempts = maxAttempts,
        _retryDelay = retryDelay,
        _isError = isError,
        _isBusy = isBusy,
        _isRunning = isRunning,
        _hasRun = hasRun,
        _isSuccess = isSuccess;

  final QueryKey _queryKey;
  QueryKey get queryKey => _queryKey;

  final T? _data;
  T? get data => _data;

  final DateTime? _dataUpdatedAt;
  DateTime? get dataUpdatedAt => _dataUpdatedAt;

  final Object? _error;
  Object? get error => _error;

  final DateTime? _errorUpdatedAt;
  DateTime? get errorUpdatedAt => _errorUpdatedAt;

  final int _failureCount;
  int get failureCount => _failureCount;

  final int _maxAttempts;
  int get maxAttempts => _maxAttempts;

  final Duration _retryDelay;
  Duration get retryDelay => _retryDelay;

  final bool _isError;
  bool get isError => _isError;

  final bool _isBusy;
  bool get isBusy => _isBusy;

  final bool _isRunning;
  bool get isRunning => _isRunning;

  final bool _hasRun;
  bool get hasRun => _hasRun;

  final bool _isSuccess;
  bool get isSuccess => _isSuccess;

  List<Object?> get _props => [
        queryKey,
        data,
        dataUpdatedAt,
        error,
        errorUpdatedAt,
        failureCount,
        maxAttempts,
        retryDelay,
        isError,
        isBusy,
        isRunning,
        hasRun,
        isSuccess,
      ];

  @override
  bool operator ==(Object other) => identical(this, other) || other is BaseQueryMutation<T> && runtimeType == other.runtimeType && equals(_props, other._props);

  @override
  int get hashCode => runtimeType.hashCode ^ _finish(_props.fold(0, _combine));

  static const _equality = DeepCollectionEquality();

  static bool equals(List<Object?> list1, List<Object?> list2) {
    if (identical(list1, list2)) {
      return true;
    }

    final length = list1.length;

    if (length != list2.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      final dynamic unit1 = list1[i];
      final dynamic unit2 = list2[i];

      if (unit1 is IEquatable && unit2 is IEquatable) {
        if (unit1 != unit2) {
          return false;
        }
      } else if (unit1 is Iterable || unit1 is Map) {
        if (!_equality.equals(unit1, unit2)) {
          return false;
        }
      } else if (unit1?.runtimeType != unit2?.runtimeType) {
        return false;
      } else if (unit1 != unit2) {
        return false;
      }
    }

    return true;
  }

  static int _combine(int hash, dynamic object) {
    if (object is Map) {
      object.keys.sorted((dynamic a, dynamic b) => a.hashCode - b.hashCode).forEach((dynamic key) {
        hash = hash ^ _combine(hash, <dynamic>[key, object[key]]);
      });

      return hash;
    }

    if (object is Set) {
      object = object.sorted((dynamic a, dynamic b) => a.hashCode - b.hashCode);
    }

    if (object is Iterable) {
      for (final value in object) {
        hash = hash ^ _combine(hash, value);
      }

      return hash ^ object.length;
    }

    hash = 0x1fffffff & (hash + object.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));

    return hash ^ (hash >> 6);
  }

  static int _finish(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);

    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef FetchDelegate<T> = FutureOr<T?> Function(UseDelegate use);

enum QueryStatus {
  empty,
  error,
  idle,
  loading,
  success,
}

class Query<T> extends BaseQueryMutation<T> {
  const Query({
    required super.queryKey,
    super.data,
    super.dataUpdatedAt,
    super.error,
    super.errorUpdatedAt,
    required super.failureCount,
    required super.maxAttempts,
    required super.retryDelay,
    required super.isError,
    required super.isBusy,
    required super.isRunning,
    required super.hasRun,
    required super.isSuccess,
    required bool isPreviousData,
    required FetchDelegate<T> refetch,
    required Duration staleDuration,
  })  : _isPreviousData = isPreviousData,
        _refetch = refetch,
        _staleDuration = staleDuration;

  final bool _isPreviousData;
  bool get isPreviousData => _isPreviousData;

  bool get isStale {
    if (isError) {
      return true;
    }

    if (isSuccess) {
      return DateTime.now().difference(_dataUpdatedAt!) > staleDuration;
    }

    return !isBusy;
  }

  final FetchDelegate<T> _refetch;
  FetchDelegate<T> get refetch => _refetch;

  QueryStatus get status {
    if (isError) {
      return QueryStatus.error;
    }

    if (isSuccess) {
      if (data == null) {
        return QueryStatus.empty;
      }

      if (data is Iterable && (data as Iterable).isEmpty) {
        return QueryStatus.empty;
      }

      if (data is Map && (data as Map).isEmpty) {
        return QueryStatus.empty;
      }

      return QueryStatus.success;
    }

    if (isBusy) {
      return QueryStatus.loading;
    }

    return QueryStatus.idle;
  }

  final Duration _staleDuration;
  Duration get staleDuration => _staleDuration;

  @override
  String toString() {
    return {
      "data": data,
      "dataUpdatedAt": dataUpdatedAt,
      "error": error,
      "errorUpdatedAt": errorUpdatedAt,
      "failureCount": failureCount,
      "hasRun": hasRun,
      "isBusy": isBusy,
      "isError": isError,
      "isPreviousData": isPreviousData,
      "isRunning": isRunning,
      "isStale": isStale,
      "isSuccess": isSuccess,
      "maxAttempts": maxAttempts,
      "queryKey": queryKey,
      "retryDelay": retryDelay,
      "staleDuration": staleDuration,
      "status": status,
    }.toString();
  }

  Query<T> _setLoading(bool keepPreviousData) {
    Log.busy(Query<T>);

    return Query<T>(
      data: keepPreviousData ? data : null,
      dataUpdatedAt: keepPreviousData ? dataUpdatedAt : null,
      error: keepPreviousData ? error : null,
      errorUpdatedAt: keepPreviousData ? errorUpdatedAt : null,
      failureCount: failureCount,
      hasRun: hasRun,
      isBusy: keepPreviousData ? false : true,
      isError: isError,
      isPreviousData: isPreviousData,
      isRunning: true,
      isSuccess: isSuccess,
      maxAttempts: maxAttempts,
      queryKey: queryKey,
      refetch: refetch,
      retryDelay: retryDelay,
      staleDuration: staleDuration,
    );
  }

  Query<T> _setError(Object exception) {
    Log.error(Query<T>, exception);

    return Query<T>(
      data: data,
      dataUpdatedAt: dataUpdatedAt,
      error: exception,
      errorUpdatedAt: DateTime.now(),
      failureCount: failureCount + 1,
      hasRun: true,
      isBusy: false,
      isError: true,
      isPreviousData: isPreviousData,
      isRunning: false,
      isSuccess: false,
      maxAttempts: maxAttempts,
      queryKey: queryKey,
      refetch: refetch,
      retryDelay: retryDelay,
      staleDuration: staleDuration,
    );
  }

  Query<T> _setSuccess(T? data, T? oldData) {
    Log.success(Query<T>, data, data == oldData);

    return Query<T>(
      data: data,
      dataUpdatedAt: DateTime.now(),
      error: null,
      errorUpdatedAt: null,
      failureCount: 0,
      hasRun: true,
      isBusy: false,
      isError: false,
      isPreviousData: data == oldData,
      isRunning: false,
      isSuccess: true,
      maxAttempts: maxAttempts,
      queryKey: queryKey,
      refetch: refetch,
      retryDelay: retryDelay,
      staleDuration: staleDuration,
    );
  }

  Future<Query<T>> startFetching(bool keepPreviousData) async {
    final busyQuery = _setLoading(keepPreviousData);
    final queryStream = Environment._getQueryStream<T>(busyQuery.queryKey);

    try {
      final fetchedData = busyQuery.refetch(Environment._use);

      if (fetchedData is T?) {
        final successQuery = busyQuery._setSuccess(fetchedData, data);

        return _addQuery<T>(queryStream, successQuery);
      }

      _addQuery<T>(queryStream, busyQuery);

      final successQuery = busyQuery._setSuccess(await fetchedData, data);

      return _addQuery<T>(queryStream, successQuery);
    } catch (ex) {
      if (kDebugMode) {
        debugger(message: ex.toString());
      }

      final errorQuery = busyQuery._setError(ex);

      if (errorQuery.failureCount < errorQuery.maxAttempts) {
        await Future<void>.delayed(errorQuery.retryDelay);

        return errorQuery.startFetching(keepPreviousData);
      }

      return _addQuery<T>(queryStream, errorQuery);
    }
  }

  Query<TData> _addQuery<TData>(BehaviorSubject<Query<TData>> queryStream, Query<TData> query) {
    if (queryStream.hasValue == false || queryStream.value != query) {
      queryStream.add(query);
    }

    return query;
  }
}

typedef MutateFnDelegate<TData> = FutureOr<TData?> Function(UseDelegate use);
typedef MutateDelegate<TData> = Future<void> Function(MutateFnDelegate<TData> mutateFn);

enum MutationStatus {
  idle,
  mutating,
  error,
  success,
}

class Mutation<T> extends BaseQueryMutation<T> {
  const Mutation({
    required super.queryKey,
    super.data,
    super.dataUpdatedAt,
    super.error,
    super.errorUpdatedAt,
    required super.failureCount,
    required super.maxAttempts,
    required super.retryDelay,
    required super.isError,
    required super.isBusy,
    required super.isRunning,
    required super.hasRun,
    required super.isSuccess,
    required bool isIdle,
  }) : _isIdle = isIdle;

  final bool _isIdle;
  bool get isIdle => _isIdle;

  MutationStatus get status {
    if (isBusy || isRunning) {
      return MutationStatus.mutating;
    }

    if (isError) {
      return MutationStatus.error;
    }

    if (isSuccess) {
      return MutationStatus.success;
    }

    return MutationStatus.idle;
  }

  @override
  String toString() {
    return {
      "data": data,
      "dataUpdatedAt": dataUpdatedAt,
      "error": error,
      "errorUpdatedAt": errorUpdatedAt,
      "failureCount": failureCount,
      "hasRun": hasRun,
      "isBusy": isBusy,
      "isError": isError,
      "isIdle": isIdle,
      "isRunning": isRunning,
      "isSuccess": isSuccess,
      "maxAttempts": maxAttempts,
      "queryKey": queryKey,
      "retryDelay": retryDelay,
      "status": status,
    }.toString();
  }

  Mutation<T> _setMutating() {
    Log.busy(Mutation<T>);

    return Mutation<T>(
      failureCount: failureCount,
      hasRun: hasRun,
      isBusy: true,
      isError: false,
      isIdle: false,
      isRunning: true,
      isSuccess: false,
      maxAttempts: maxAttempts,
      queryKey: queryKey,
      retryDelay: retryDelay,
      data: data,
      dataUpdatedAt: dataUpdatedAt,
      error: null,
      errorUpdatedAt: null,
    );
  }

  Mutation<T> _setError(Object exception) {
    Log.error(Mutation<T>, exception);

    return Mutation<T>(
      failureCount: failureCount + 1,
      hasRun: true,
      isBusy: false,
      isError: true,
      isIdle: false,
      isRunning: false,
      isSuccess: false,
      maxAttempts: maxAttempts,
      queryKey: queryKey,
      retryDelay: retryDelay,
      data: data,
      dataUpdatedAt: dataUpdatedAt,
      error: exception,
      errorUpdatedAt: DateTime.now(),
    );
  }

  Mutation<T> _setSuccess(T? data) {
    Log.success(Mutation<T>, data);

    return Mutation<T>(
      failureCount: 0,
      hasRun: true,
      isBusy: false,
      isError: false,
      isIdle: false,
      isRunning: false,
      isSuccess: true,
      maxAttempts: maxAttempts,
      queryKey: queryKey,
      retryDelay: retryDelay,
      data: data,
      dataUpdatedAt: dataUpdatedAt,
      error: null,
      errorUpdatedAt: null,
    );
  }

  Future<Mutation<T>> mutate(FutureOr<T?> Function(UseDelegate use) mutateFn) async {
    final busyMutation = _setMutating();
    final mutationStream = Environment._getMutationStream<T>(busyMutation.queryKey);

    try {
      final fetchedData = mutateFn(Environment._use);

      if (fetchedData is T?) {
        final successMutation = busyMutation._setSuccess(fetchedData);

        Environment._setCachedData<T>(successMutation.queryKey, fetchedData, false);

        return _addMutation<T>(mutationStream, successMutation);
      }

      _addMutation<T>(mutationStream, busyMutation);

      final awaitedFetchedData = await fetchedData;
      final successMutation = busyMutation._setSuccess(awaitedFetchedData);

      Environment._setCachedData<T>(successMutation.queryKey, awaitedFetchedData, false);

      return _addMutation<T>(mutationStream, successMutation);
    } catch (ex) {
      if (kDebugMode) {
        debugger(message: ex.toString());
      }

      final errorMutation = busyMutation._setError(ex);

      if (errorMutation.failureCount < errorMutation.maxAttempts) {
        await Future<void>.delayed(errorMutation.retryDelay);

        return errorMutation.mutate(mutateFn);
      }

      return _addMutation<T>(mutationStream, errorMutation);
    }
  }

  Mutation<TData> _addMutation<TData>(BehaviorSubject<Mutation<TData>> mutationStream, Mutation<TData> mutation) {
    if (mutationStream.hasValue == false || mutationStream.value != mutation) {
      mutationStream.add(mutation);
    }

    return mutation;
  }
}
