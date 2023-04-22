part of query_stack;

@immutable
abstract class QueryResult<T> {
  const QueryResult();
}

@immutable
class WaitingResult<T> extends QueryResult<T> {
  const WaitingResult();
}

@immutable
class EmptyResult<T> extends QueryResult<T> {
  const EmptyResult();
}

@immutable
class DataResult<T> extends QueryResult<T> {
  const DataResult(this.data);

  final T data;
}
