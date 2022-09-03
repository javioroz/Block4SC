import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'homeTabs.dart';
import 'utils/theme.dart';

void main() async {
  // loading the environment variables to our app
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Block4SC',
      themeMode: ThemeMode.light,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      /*theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green[800],
        appBarTheme: AppBarTheme(
          //elevation: 0,
          backgroundColor: Colors.green[800],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green[800])),
        ),
      ),
      //darkTheme: ThemeData.dark(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[800],
        appBarTheme: AppBarTheme(
          //elevation: 0,
          backgroundColor: Colors.blueGrey[800],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey[800])),
        ),
      ),*/
      //------------------------------------------------------
      home: HomeTabs(),
    );
  }
}
