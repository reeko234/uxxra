import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uxxrapp/src/components/sys_app_bar.dart';
import 'package:uxxrapp/src/utils/strings.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var credentials =
        ModalRoute.of(context)?.settings.arguments as UserCredential;
    return Scaffold(
      body: Stack(
        children: [
          const SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: SysAppBar(
                showBackArrow: false,
                title: Strings.homeText,
                // fontSize: 24,
              ),
            ),
          ),
          Center(
            child: Text(
              "Welcome ${credentials.user?.email ?? credentials.user?.phoneNumber}",
            ),
          )
        ],
      ),
    );
  }
}
