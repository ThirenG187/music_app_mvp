import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isProtected;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isProtected = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: isProtected,
      validator: _validate,
    );
  }

  String? _validate(String? val) {
    if (val != null && val.trim().isEmpty) return "$hintText is missing";
    return null;
  }
}
