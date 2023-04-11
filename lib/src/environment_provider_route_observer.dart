part of query_stack;

/// This `RouteObserver` is responsible to inform the `QueryBuilder`
/// whenever it needs to refetch its query when a navigation pops
/// a route and re-renders the QueryBuilder
///
/// This NEEDS to be added to `MaterialApp.navigatorObservers`,
/// otherwise, your QueryBuilder will not update after a
/// navigation pop.
@immutable
class EnvironmentProviderRouteObserver extends RouteObserver {}
