part of query_stack;

@immutable
class QueryStreamBuilder<T> extends StatelessWidget {
  const QueryStreamBuilder({
    this.initialData,
    this.onError,
    this.errorBuilder,
    this.onWaiting,
    this.waitingBuilder,
    this.onEmpty,
    this.emptyBuilder,
    this.onData,
    required this.dataBuilder,
    required this.stream,
    super.key,
  });

  final Stream<T?> stream;
  final T? initialData;
  final void Function(BuildContext context, Object error)? onError;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final void Function(BuildContext context)? onWaiting;
  final Widget Function(BuildContext context)? waitingBuilder;
  final void Function(BuildContext context)? onEmpty;
  final Widget Function(BuildContext context)? emptyBuilder;
  final void Function(BuildContext context, T data)? onData;
  final Widget Function(BuildContext context, T data) dataBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
      initialData: initialData,
      stream: stream,
      builder: _snapshotBuilder,
    );
  }

  Widget _snapshotBuilder(BuildContext context, AsyncSnapshot<T?> snapshot) {
    if (snapshot.hasError) {
      final error = snapshot.error!;

      log(
        "\x1B[31m${runtimeType} throws ${error}\x1B[0m",
        name: "QueryStreamBuilder<${T}>",
      );

      if (kDebugMode) {
        log(
          "\x1B[33m${error}\x1B[0m",
          name: "QueryStreamBuilder<${T}>",
        );
      }

      if (onError != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => onError!(context, error));
      }

      return errorBuilder == null ? ErrorWidget(error) : errorBuilder!(context, error);
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      log(
        "\x1B[36m${runtimeType} waiting\x1B[0m",
        name: "QueryStreamBuilder<${T}>",
      );

      if (onWaiting != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => onWaiting!(context));
      }

      return waitingBuilder == null ? const Center(child: CircularProgressIndicator.adaptive()) : waitingBuilder!(context);
    }

    if (snapshot.data == null || (snapshot.data is Iterable && (snapshot.data as Iterable).isEmpty)) {
      log(
        "\x1B[33m${runtimeType} is empty\x1B[0m",
        name: "QueryStreamBuilder<${T}>",
      );

      if (onEmpty != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => onEmpty!(context));
      }

      return emptyBuilder == null ? const SizedBox() : emptyBuilder!(context);
    }

    final data = snapshot.data as T;

    log(
      "\x1B[32m${runtimeType} has data\x1B[0m",
      name: "QueryStreamBuilder<${T}>",
    );

    if (kDebugMode) {
      log(
        "\x1B[37m${data}\x1B[0m",
        name: "QueryStreamBuilder<${T}>",
      );
    }

    if (onData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onData!(context, data));
    }

    return dataBuilder(context, data);
  }
}
