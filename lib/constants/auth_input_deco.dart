import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/constants/common_size.dart';

InputDecoration textInputDeco(String hint) {
  return InputDecoration(
    border: InputBorder.none,
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[500]),
    enabledBorder: activeInputBorder(),
    focusedBorder: activeInputBorder(),
    errorBorder: errorInputBorder(),
    focusedErrorBorder: errorInputBorder(),
    filled: true,
    fillColor: Colors.grey[100],
  );
}

OutlineInputBorder errorInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
    borderRadius: BorderRadius.circular(common_s_gap),
  );
}

OutlineInputBorder activeInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey[300],
    ),
    borderRadius: BorderRadius.circular(common_s_gap),
  );
}