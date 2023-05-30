library query_stack;

import 'package:flutter/material.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({required this.header, super.key});

  final Widget header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            header,
            const Spacer(),
            const Center(child: CircularProgressIndicator.adaptive()),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
