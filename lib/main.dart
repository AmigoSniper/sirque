import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:salescheck/page/landingPage/landingPage.dart';

import 'page/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaler.clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.0,
        );
        final double scaleFactor = 1.0 / mediaQueryData.devicePixelRatio;
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: scale,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'geist'),
      home: const Scaffold(body: Splashscreen()),
    );
  }
}
