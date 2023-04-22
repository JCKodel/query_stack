part of query_stack_environment;

typedef GetDelegate = TInterface Function<TInterface extends BaseService>();

typedef InjectorDelegate<TInterface extends BaseService> = TInterface Function(
  GetDelegate get,
);

typedef RegisterDependenciesDelegate = void Function<TInterface extends BaseService>(
  InjectorDelegate<TInterface> constructor,
);

@immutable
abstract class Environment {
  const Environment();

  static final _dependencies = <Type, BaseService Function(GetDelegate get)>{};
  static final _instances = <Type, BaseService>{};
  static PlatformInfo get platformInfo => PlatformInfo.current;

  @protected
  void registerDependencies(RegisterDependenciesDelegate when, PlatformInfo platformInfo);

  @protected
  Future<void> initializeAsync(GetDelegate get);

  static TInterface get<TInterface extends BaseService>() {
    final instance = _instances[TInterface];

    if (instance != null) {
      return instance as TInterface;
    }

    final constructor = _dependencies[TInterface];

    if (constructor == null) {
      throw Exception("There is no dependency registered for ${TInterface}");
    }

    return _instances[TInterface] = constructor(get) as TInterface;
  }

  static void _when<TInterface extends BaseService>(InjectorDelegate<TInterface> constructor) {
    log("\x1B[37mRegistering\x1B[0m ${TInterface}", name: "Environment");
    _dependencies[TInterface] = constructor;
  }

  static Future<void> use(Environment env) async {
    WidgetsFlutterBinding.ensureInitialized();
    env.registerDependencies(Environment._when, platformInfo);
    await env.initializeAsync(Environment.get);

    for (final dependency in _dependencies.entries) {
      final service = _instances[dependency.key] = dependency.value(get);

      log("\x1B[32mInitializing\x1B[0m ${service.runtimeType}", name: "Environment");
      service.initialize();
      await service.initializeAsync();
    }
  }
}
