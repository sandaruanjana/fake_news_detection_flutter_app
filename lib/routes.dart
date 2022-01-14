import 'package:flutter/material.dart';
import 'package:tnews/screens/login_screen.dart';
import 'package:tnews/screens/register_screen.dart';
import 'package:tnews/screens/home_screen.dart';



import 'main.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
};
