library query_stack;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({required this.header, super.key});

  final Widget header;

  @override
  State<WaitingPage> createState() => WaitingPageState();
}

class WaitingPageState extends State<WaitingPage> {
  late ThemeData currentTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentTheme = Theme.of(context);
  }

  @override
  void dispose() {
    final platformBrightness = ThemeData.estimateBrightnessForColor(currentTheme.scaffoldBackgroundColor);
    final inverseBrightness = platformBrightness == Brightness.light ? Brightness.dark : Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: currentTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: inverseBrightness,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: inverseBrightness,
        statusBarBrightness: inverseBrightness,
        statusBarColor: Colors.transparent,
      ),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platformBrightness = ThemeData.estimateBrightnessForColor(theme.primaryColor);
    final inverseBrightness = platformBrightness == Brightness.light ? Brightness.dark : Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: theme.primaryColor,
        systemNavigationBarIconBrightness: inverseBrightness,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: inverseBrightness,
        statusBarBrightness: inverseBrightness,
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            widget.header,
            const Spacer(),
            const Center(child: CircularProgressIndicator.adaptive()),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
