import 'package:flutter/material.dart';

class EmailSentScreen extends StatelessWidget {
  static const String routeName = "email-sent-screen";
  const EmailSentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      body: Center(
        child: Text("Email is sent to $email"),
      ),
    );
  }
}
