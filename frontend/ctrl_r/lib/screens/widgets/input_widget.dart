import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputWidget extends StatefulWidget {
  TextEditingController controller;
  String placeholder, error;
  bool isPassword;
  int line;
  InputWidget(
      {super.key,
      required this.controller,
      required this.placeholder,
      required this.error,
      required this.isPassword,this.line = 1});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.line,
      controller: widget.controller,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: context.heightPercent(2),
            horizontal: context.widthPercent(3)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: widget.placeholder,
        labelStyle: TextStyle(color: Colors.black87, fontSize: context.t3),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return widget.error;
        }
        return null;
      },
    );
  }
}
