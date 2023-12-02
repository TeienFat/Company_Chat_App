import 'package:company_chat_app_demo/screens/auth/auth.dart';
import 'package:company_chat_app_demo/screens/main_screen.dart';
import 'package:company_chat_app_demo/screens/splash/splash_screen.dart';
import 'package:company_chat_app_demo/screens/splash/waitting_auth.dart';
import 'package:company_chat_app_demo/screens/splash/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:company_chat_app_demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 207, 46, 46));
var kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 207, 46, 46));
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kColorScheme.onSecondaryContainer,
              ),
            ),
      ),
      // home: const MyHomePage(title: "Chat"),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Auth': (BuildContext context) => new StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Authenticating();
                }
                if (snapshot.hasData) {
                  return const MainScreen();
                }
                return const AuthScreen();
              },
            ),
        '/Login': (BuildContext context) => new AuthScreen(),
        '/Welcome': (BuildContext context) => new WelcomeScreen(),
      },
    );
  }
}
