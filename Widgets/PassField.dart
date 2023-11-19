// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PassField extends StatefulWidget {
  TextEditingController passcontroller = TextEditingController();

  final hinttext;
  final inputtype;
  final inputaction;

  PassField(
      {super.key,
      required this.passcontroller,
      this.hinttext,
      this.inputaction,
      this.inputtype});

  @override
  State<PassField> createState() => _PassFieldState();
}

class _PassFieldState extends State<PassField> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "* Required";
          } else if (value.length < 6) {
            return "Password should be atleast 6 characters";
          } else if (value.length > 15) {
            return "Password should not be greater than 15 characters";
          } else {
            return null;
          }
        },
        obscureText: visible,
        controller: widget.passcontroller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  if (visible == true) {
                    visible = false;
                  } else {
                    visible = true;
                  }
                });
              },
              icon: Icon(visible ? Icons.visibility : Icons.visibility_off,
                  size: 25, color: Colors.blueGrey)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          hintText: widget.hinttext,
          prefixIcon: const Icon(
            Icons.password_outlined,
            size: 25,
            color: Colors.blueGrey,
          ),
        ),
        cursorColor: Colors.blueGrey,
        keyboardType: widget.inputtype,
        textInputAction: widget.inputaction,
      ),
    );
  }
}
