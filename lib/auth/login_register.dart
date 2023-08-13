import 'package:flutter/material.dart';
import 'package:hikedex/pages/login/login.dart';
import 'package:hikedex/pages/login/register.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool showLoginPage = true;
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: () {
        setState(() {
          showLoginPage = false;
        });
      });
    } else {
      return RegisterPage(onTap: () {
        setState(() {
          showLoginPage = true;
        });
      });
    }
  }
}
