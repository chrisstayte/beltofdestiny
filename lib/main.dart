import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:beltofdestiny/router.dart';

import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Flame.device.fullScreen();

  usePathUrlStrategy();

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
    return MultiProvider(
      providers: [
        Provider(create: (context) => SettingsProvider()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: flutterNesTheme().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: GoogleFonts.pressStart2pTextTheme().apply(),
        ),
        routerConfig: router,
        // routeInformationParser: router.routeInformationParser,
        // routerDelegate: router.routerDelegate,
        // routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
