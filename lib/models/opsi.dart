import 'package:flutter/material.dart';

class Opsi {
  String value;
  String label;
  String label2;
  IconData? icon;
  Map<String, dynamic>? data;

  Opsi({
    required this.value,
    required this.label,
    this.label2 = "",
    this.icon,
    this.data,
  });
}