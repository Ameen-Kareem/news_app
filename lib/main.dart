import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_app/controller/home_screen_controller.dart';
import 'package:news_app/controller/user_validation_controller.dart';
import 'package:news_app/view/bookmark_screen/bookmark_screen.dart';
import 'package:news_app/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:news_app/view/home_screen/home_screen.dart';
import 'package:news_app/view/login_screen/login_screen.dart';
import 'package:news_app/view/preference_screen/preference_screen.dart';
import 'package:news_app/view/reset_password_screen/reset_password_screen.dart';
import 'package:news_app/view/register_screen/register_screen.dart';
import 'package:news_app/view/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserValidationController.initialiseDb();
  log("initialised");
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserValidationController(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeScreenController(),
        )
      ],
      child: MaterialApp(routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/nav_bar': (context) => BottomNavBar(),
        '/bookmark': (context) => BookmarkScreen(),
        '/reset_password': (context) => ResetPasswordScreen(),
        '/preference': (context) => PreferenceScreen(),
      }, debugShowCheckedModeBanner: false, home: SplashScreen()),
    );
  }
}
