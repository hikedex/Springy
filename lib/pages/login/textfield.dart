import 'package:flutter/material.dart';
import 'package:hikedex/utils/textloader.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    this.controller,
    this.label,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: CustomText.apply(
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.onSecondary,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
