part of query_stack;

class MutationBuilder<TData> extends StatelessWidget {
  const MutationBuilder({
    required this.queryKey,
    required this.builder,
    this.onSuccess,
    this.onError,
    this.onSettled,
    this.maxAttempts = 1,
    this.retryDelay = const Duration(seconds: 1),
    super.key,
  });

  final QueryKey queryKey;
  final Widget Function(BuildContext context, Mutation<TData> mutation) builder;
  final void Function(Mutation<TData> mutation)? onSuccess;
  final void Function(Mutation<TData> mutation)? onError;
  final void Function(Mutation<TData> mutation)? onSettled;
  final int maxAttempts;
  final Duration retryDelay;

  static final _lastEmmitedMutations = <Type, dynamic>{};

  @override
  Widget build(BuildContext context) {
    final mutationStream = Environment._getMutationStream<TData>(queryKey);

    final mutation = mutationStream.valueOrNull ??
        Mutation<TData>(
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

    return StreamBuilder<Mutation<TData>>(
      initialData: mutation,
      stream: mutationStream.stream.where(
        (mutation) {
          final lastEmmitedMutation = _lastEmmitedMutations[TData] as Mutation<TData>?;

          if (lastEmmitedMutation == null) {
            _lastEmmitedMutations[TData] = mutation;
            return true;
          }

          if (lastEmmitedMutation == mutation) {
            return false;
          }

          _lastEmmitedMutations[TData] = mutation;
          return true;
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Log.error(MutationBuilder<TData>, snapshot.error!);
          throw snapshot.error!;
        } else {
          switch (snapshot.data!.status) {
            case MutationStatus.idle:
              Log.idle(MutationBuilder<TData>);
              break;
            case MutationStatus.mutating:
              Log.busy(MutationBuilder<TData>);
              break;
            case MutationStatus.error:
              Log.error(MutationBuilder<TData>, snapshot.data!.error!);

              if (onError != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onError!(snapshot.data!));
              }

              if (onSettled != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onSettled!(snapshot.data!));
              }
              break;
            case MutationStatus.success:
              Log.success(MutationBuilder<TData>, snapshot.data!.data);

              if (onSuccess != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onSuccess!(snapshot.data!));
              }

              if (onSettled != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onSettled!(snapshot.data!));
              }

              break;
          }
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}
