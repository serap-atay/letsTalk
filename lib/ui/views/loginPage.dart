// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/enums/enums.dart';
import 'package:letstalk/ui/cubit/authCubit.dart';
import 'package:letstalk/ui/widget/customCardWidget.dart';
import 'package:letstalk/ui/widget/messageBox.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";
  final _formkey = GlobalKey<FormState>();

  FormType _formType = FormType.Login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 160),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Form(
                key: _formkey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        style: const TextStyle(fontSize: 10),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            //errorText: userViewModel.emailErrorText,
                            label: const Text(
                              "E-mail",
                            ),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade900),
                                borderRadius: BorderRadius.circular(20)),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                            )),
                        onSaved: (email) {
                          if (email != null) {
                            _email = email;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 10),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            //errorText: userViewModel.passwordErrorText,
                            label: const Text(
                              "Password",
                            ),
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade900),
                                borderRadius: BorderRadius.circular(20)),
                            prefixIcon: const Icon(
                              Icons.password,
                            )),
                        onSaved: (password) {
                          if (password != null) {
                            _password = password;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: CustomCard(
                          onPress: () {
                            _formSubmit(_email, _password);
                          },
                          title: _formType == FormType.Register
                              ? "Sig Up"
                              : "Login",
                          color: Colors.white10,
                          textSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _changeFormType();
                        },
                        child: Text(
                            _formType == FormType.Login
                                ? "Don't have an account? Sign Up"
                                : "Do you have an account? Login",
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue[900])),
                      ),
                    ]),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Or",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              CustomCard(
                path: "images/icons8-facebook-48.png",
                onPress: () {
                  onSignInWithFacebook();
                },
                title: "Connect with Facebook",
                isImageVisible: true,
                color: Colors.blue.shade900,
                textColor: Colors.white,
              ),
              CustomCard(
                path: "images/icons8-google-plus-circled-48.png",
                onPress: () {
                  onSignInWithGoogle();
                },
                title: "Connect with Google",
                isImageVisible: true,
                color: Colors.red.shade900,
                textColor: Colors.white,
              ),
              /* TextButton(
                child: const Text("Continue without membership",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
                onPressed: () {
                  onSignIn(context);
                },
              )*/
            ],
          ),
        ),
      ),
    );
  }

  void _changeFormType() {
    setState(() {
      _formType =
          _formType == FormType.Register ? FormType.Login : FormType.Register;
    });
  }

  void _formSubmit(String email, String password) async {
    _formkey.currentState!.save();
    if (email != "" && password != "") {
      if (_formType == FormType.Register) {
        try {
          await context.read<AuthCubit>().register(email, password);
        } on PlatformException catch (e) {
          MessageBox(
              content: e.code, icon: Icons.error, title: "An Error Occurred");
        }
      } else {
        try {
          await context.read<AuthCubit>().login(email, password);
        } on PlatformException catch (e) {
          MessageBox(
              content: e.code, icon: Icons.error, title: "An Error Occurred");
        }
      }
    } else {
      const MessageBox(
          content: "Email or password is incorrect",
          icon: Icons.error_outline_rounded,
          title: "Warning").show(context);
    }
  }

  void onSignInWithGoogle() async {
    try {
      await context.read<AuthCubit>().signInWitGoogle();
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
    }
  }

  void onSignInWithFacebook() async {
    try {
      await context.read<AuthCubit>().signInWitFacebook();
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
    }
  }
}
