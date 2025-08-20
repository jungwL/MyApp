import 'package:flutter/foundation.dart';

class Userchangepassword {
  final String phoneNumber;
  final String newPassword;

  Userchangepassword({required this.phoneNumber, required this.newPassword});

  factory Userchangepassword.fromJson(Map<String, dynamic> json) {
    return Userchangepassword(
        phoneNumber: json['phoneNumber'],
        newPassword: json['newPassword'],
    );
  }


}