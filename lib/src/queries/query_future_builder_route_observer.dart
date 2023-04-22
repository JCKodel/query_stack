part of query_stack;

@immutable
class QueryFutureBuilderRouteObserver extends RouteObserver {
  QueryFutureBuilderRouteObserver._();

  static final _instance = QueryFutureBuilderRouteObserver._();
  static QueryFutureBuilderRouteObserver get instance => _instance;
}
