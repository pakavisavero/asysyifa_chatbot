import 'package:assyifa_chatbot/services/auth.dart';
import 'package:assyifa_chatbot/shared/custom_dialog.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:assyifa_chatbot/views/register.dart';
import 'package:assyifa_chatbot/shared/custom_button.dart';
import 'package:assyifa_chatbot/shared/custom_password_text_field.dart';
import 'package:assyifa_chatbot/shared/custom_text_field.dart';
import 'package:assyifa_chatbot/views/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  static String routeName = "/login";

  static const lightBlue = const Color(0xFFD0F3FC);
  static const mediumBlue = const Color(0xFF39A2DB);
  static const darkGray = const Color(0xFF707070);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String _emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Email tidak valid';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Login.lightBlue,
        body: isLoading
            ? Loading()
            : SafeArea(
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/welcome_vector.png',
                      width: double.infinity,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0))),
                        child: Form(
                          key: _formKey,
                          child: Wrap(
                            children: [
                              CustomTextField(
                                  'Email',
                                  TextInputType.emailAddress,
                                  _emailController,
                                  _emailValidator),
                              SizedBox(width: double.infinity, height: 15.0),
                              CustomPasswordTextField(
                                  'Password', _passwordController),
                              SizedBox(width: double.infinity, height: 15.0),
                              CustomButton(
                                'Masuk',
                                () {
                                  signInWithEmailAndPassword(context);
                                },
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                width: double.infinity,
                                child: Text('atau',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Login.darkGray)),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  signInWithGoogle(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Login.darkGray),
                                  minimumSize: Size(double.infinity, 40.0),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/google_icon.svg',
                                      height: 20.0,
                                      width: 20.0,
                                    ),
                                    Expanded(
                                      child: Text('Lanjutkan dengan Google',
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Login.darkGray)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: Divider(color: Login.darkGray),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Belum punya akun? '),
                                      Text(
                                        'Daftar',
                                        style: TextStyle(
                                            color: Login.mediumBlue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ));
  }

  void signInWithEmailAndPassword(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      try {
        var result = await _auth.signInWithEmailAndPassword(email, password);
        print(result.toString());
        if (result == null) {
          setState(() {
            showErrorDialog('Terjadi error saat login');
            isLoading = false;
          });
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Wrapper()));
        }
      } catch (err) {
        print(err);
        setState(() {
          showErrorDialog('Terjadi error saat login');
          isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
      }
    }
  }

  void signInWithGoogle(BuildContext context) async {
    setState(() => isLoading = true);
    try {
      var result = await _auth.signInWithGoogle();
      print(result.toString());
      if (result == null) {
        setState(() {
          showErrorDialog('Terjadi error saat login');
          isLoading = false;
        });
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
      }
    } catch (err) {
      print(err);
      setState(() {
        showErrorDialog('Terjadi error saat login');
        isLoading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Wrapper()));
    }
  }

  void showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(title: 'Error', content: error);
        });
  }
}
