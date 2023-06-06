import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wagwan/views/auth/login_view.dart';
import 'package:wagwan/views/auth/register_view.dart';
import 'package:wagwan/views/content/main_view.dart';
import 'package:wagwan/views/splash_view.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const Splash(),
      routes: {
        "/login": (context) => const LoginView(),
        "/register": (context) => const RegisterView(),
        "/main": (context) => const MainView(),
      },
    );
  }
}
