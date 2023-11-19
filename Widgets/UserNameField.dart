import 'package:flutter/material.dart';

class UserNameField extends StatelessWidget {
  TextEditingController namcontroller = TextEditingController();

  final hinttext;
  final inputtype;
  final inputaction;

  UserNameField(
      {super.key,
      required this.namcontroller,
      this.hinttext,
      this.inputaction,
      this.inputtype});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '* Required';
          }
        },
        controller: namcontroller,
        decoration: InputDecoration(
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
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          hintText: hinttext,
          prefixIcon: const Icon(
            Icons.person,
            size: 25,
            color: Colors.blueGrey,
          ),
        ),
        cursorColor: Colors.blueGrey,
        keyboardType: inputtype,
        textInputAction: inputaction,
      ),
    );
  }
}
