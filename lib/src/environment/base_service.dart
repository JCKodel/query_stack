part of query_stack_environment;

abstract class BaseService {
  const BaseService();

  Future<void> initializeAsync() async {}
  void initialize() {}
}
