import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tnews/screens/login_screen.dart';

import '../api_service.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int userId = 0;
  var apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _newsController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    var box = Hive.box('auth');
    userId = box.get('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find the truth'),
        actions: [
          ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await Hive.box('auth').clear();
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
              child: const Text('Logout'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _newsController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'News is Required';
                    }
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Enter news',
                    fillColor: const Color(0xfff3f3f4),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
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
                    onTap: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              apiService.prediction(
                                  _newsController.text.trim(), userId, (data) {
                                setState(() {
                                  isLoading = false;
                                });
                                Alert(
                                  context: context,
                                  type: data['data'] == 'Real News'
                                      ? AlertType.success
                                      : AlertType.error,
                                  title: "${data['data']}",
                                  desc: "This is ${data['data']}!",
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        _newsController.clear();
                                        Navigator.pop(context);
                                      },
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }, (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                print(e);
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
                              'Check',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
