import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tnews/screens/register_screen.dart';

import '../api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  var apiService = ApiService();

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back!",
                style: GoogleFonts.poppins(
                    fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                " Sign in to your account",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
              const SizedBox(
                height: 48,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Email is Required';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        fillColor: const Color(0xfff3f3f4),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      obscureText: !passwordVisible,
                      controller: _passwordController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is Required';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        fillColor: const Color(0xfff3f3f4),
                        filled: true,
                        suffixIcon: IconButton(
                          // color: textGrey,
                          splashRadius: 1,
                          icon: Icon(passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: togglePassword,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Spacer(),
              Material(
                borderRadius: BorderRadius.circular(14.0),
                elevation: 0,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(24, 95, 239, 10),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          apiService.login(_emailController.text.trim(),
                              _passwordController.text.trim(), (data) {
                            setState(() {
                              isLoading = false;
                            });
                            var box = Hive.box('auth');
                            box.put('user_id', data['data']);
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName);
                          }, (e) {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: e,
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.poppins(),
                    ),
                    TextButton(
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness != Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(context).pushReplacementNamed(
                                  RegisterScreen.routeName);
                            },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
