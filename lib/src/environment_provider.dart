part of query_stack;

/// Initializes an `Environment` and all QueryStack
/// CQRS and Dependency Injection mechanisms.
class EnvironmentProvider extends StatefulWidget {
  const EnvironmentProvider({
    required this.environment,
    required this.child,
    this.onInitialized,
    super.key,
  });

  /// The `Environment` class of your app.
  final Environment environment;

  /// Your `MaterialApp` or `CupertinoApp`.
  final Widget child;

  /// Called after the environment is initialized
  /// (a good place to hide the splash screen).
  final void Function()? onInitialized;

  @override
  State<EnvironmentProvider> createState() => _EnvironmentProviderState();

  /// Gets a reference to the current `Environment` provided by the
  /// `EnvironmentProvider` used in `main`.
  static Environment of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_EnvironmentStateProvider>()!.environment;
  }
}

class _EnvironmentProviderState extends State<EnvironmentProvider> {
  late final Future<void> _environmentFuture;

  @override
  void initState() {
    super.initState();
    _environmentFuture = _initializeEnvironment();
  }

  Future<void> _initializeEnvironment() async {
    widget.environment.registerDependencies(Environment._when, Environment._platformInfo);
    await widget.environment.initializeAsync(Environment._use);

    if (widget.onInitialized != null) {
      widget.onInitialized!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _environmentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        return _EnvironmentStateProvider(
          environment: widget.environment,
          child: widget.child,
        );
      },
    );
  }
}

@immutable
class _EnvironmentStateProvider extends InheritedWidget {
  const _EnvironmentStateProvider({
    required this.environment,
    required super.child,
  });

  final Environment environment;

  @override
  bool updateShouldNotify(_EnvironmentStateProvider oldWidget) {
    return environment != oldWidget.environment;
  }
}
