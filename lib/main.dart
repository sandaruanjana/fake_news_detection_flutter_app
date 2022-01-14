import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tnews/routes.dart';
import 'package:tnews/screens/home_screen.dart';
import 'package:tnews/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('auth');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TNews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Hive.box('auth').get('user_id') == null
          ? const LoginScreen()
          : const HomeScreen(),
      routes: routes,
    );
  }
}
