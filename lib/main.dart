import 'package:beltofdestiny/firebase_options.dart';
import 'package:beltofdestiny/pallete.dart';
import 'package:beltofdestiny/providers/app_lifecycle.dart';
import 'package:beltofdestiny/providers/remote_config_provider.dart';
import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:beltofdestiny/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortraitUpOnly();

  usePathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '${record.loggerName} -- ${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider(create: (context) => Palette()),
          Provider(
            create: (context) => SettingsProvider(),
            lazy: false,
          ),
          Provider(
            create: (context) => RemoteConfigProvider(),
            lazy: false,
          )
        ],
        child: Builder(builder: (context) {
          final palette = context.read<Palette>();

          return MaterialApp.router(
            title: 'Belt of Destiny',
            theme: flutterNesTheme().copyWith(
                scaffoldBackgroundColor: Palette.hampton,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                textTheme: GoogleFonts.pressStart2pTextTheme().apply(),
                extensions: flutterNesTheme().extensions.values),
            routerConfig: router,
            // routeInformationParser: router.routeInformationParser,
            // routerDelegate: router.routerDelegate,
            // routeInformationProvider: router.routeInformationProvider,
          );
        }),
      ),
    );
  }
}
