import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hikedex/pages/login/textfield.dart';
import 'package:hikedex/utils/textloader.dart';

class LoginPage extends StatefulWidget {
  final dynamic onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // sign user in
  void _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);
    }
    // catch different errors and show snackbars for each
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wrong username or password.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body should have a lock icon, a text field for username/email, and a text field for password. the background should be the theme's scaffoldBackgroundColor, the text fields should have the theme's textTheme.bodyText1 color, and the text field fill should be the theme's secondary color. textfields should take all available width.
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SvgPicture.asset(
            'assets/hd_icons/32.svg',
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.secondary, BlendMode.srcATop),
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          CustomTextField(
            controller: _usernameController,
            label: 'Username or Email',
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
          ),
          // secondary color button with text "Login". should take all available width.
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.secondary,
            ),
            // child: button
            child: TextButton(
              onPressed: () {
                _signIn();
              },
              child: Text(
                'Login',
                style: CustomText.apply(
                  style: Theme.of(context).textTheme.bodyLarge,
                  color: Theme.of(context).colorScheme.onSecondary,
                  weight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          // text below that allows user to register
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: CustomText.apply(
                  style: Theme.of(context).textTheme.bodyLarge,
                  color: Theme.of(context).colorScheme.onBackground,
                  weight: FontWeight.w900,
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onTap();
                },
                child: Text(
                  'Register',
                  style: CustomText.apply(
                    style: Theme.of(context).textTheme.bodyLarge,
                    color: Theme.of(context).colorScheme.primary,
                    weight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
