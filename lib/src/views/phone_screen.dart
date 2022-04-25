import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:uxxrapp/src/components/app_button.dart';
import 'package:uxxrapp/src/components/app_textfformfield.dart';
import 'package:uxxrapp/src/components/sys_app_bar.dart';
import 'package:uxxrapp/src/prefs/email_pref.dart';
import 'package:uxxrapp/src/services/auth_services.dart';
import 'package:uxxrapp/src/services/email_handler.dart';
import 'package:uxxrapp/src/utils/app_alert.dart';
import 'package:uxxrapp/src/utils/app_colors.dart';
import 'package:uxxrapp/src/utils/app_dimens.dart';
import 'package:uxxrapp/src/utils/app_styles.dart';
import 'package:uxxrapp/src/utils/constants.dart';
import 'package:uxxrapp/src/utils/strings.dart';
import 'package:uxxrapp/src/utils/validators.dart';
import 'package:uxxrapp/src/views/email_sent_screen.dart';
import 'package:uxxrapp/src/views/home_screen.dart';
import 'package:uxxrapp/src/views/otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  static const String routeName = "phone-screen";
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController phoneEmailCtrl = TextEditingController();
  bool loading = false;
  final FirebaseDynamicLinks _firebaseDynamicLinks =
      FirebaseDynamicLinks.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _setDeepLinkClickHandler(FirebaseEmailLinkHandler handler) async {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      setState(() {
        loading = false;
      });
      showAppSnackBar(context, "User already signed in");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    }
    final email = await EmailPref().getEmail();
    if (email == null) {
      setState(() {
        loading = false;
      });
      log("No email set");
      return;
    }
    var checkLinkData = await handler.getClickedDynamicData();

    if (checkLinkData == null || checkLinkData == false) {
      setState(() {
        loading = false;
      });
      return;
    }

    handler.getDynamicData().then((deepLink) async {
      if (deepLink != null) {
        log("Email click link $deepLink");
        if (_firebaseAuth.isSignInWithEmailLink(deepLink.toString())) {
          var res = await _firebaseAuth.signInWithEmailLink(
              email: email, emailLink: deepLink.toString());
          setState(() {
            loading = false;
          });
          Navigator.pushReplacementNamed(context, HomeScreen.routeName,
              arguments: res);
          return;
        } else {
          setState(() {
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  void initState() {
    FirebaseEmailLinkHandler handler = FirebaseEmailLinkHandler();
    _setDeepLinkClickHandler(handler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void onSubmit() async {
      setState(() {
        loading = true;
      });

      if (phoneEmailCtrl.text.isEmpty) {
        setState(() {
          loading = false;
        });
        showAppSnackBar(context, "Enter Phone number or Email");
        return;
      }

      if (!Validators.checkIfIsEmail(phoneEmailCtrl.text)) {
        AuthService.sendEmailLink(phoneEmailCtrl.text.trim())
            .onError((error, stackTrace) =>
                showAppSnackBar(context, error.toString()))
            .whenComplete(() {
          setState(() {
            loading = false;
          });
          Navigator.of(context).pushNamed(EmailSentScreen.routeName,
              arguments: phoneEmailCtrl.text);
        });
      } else {
        if (!phoneEmailCtrl.text.contains("@")) {
          setState(() {
            loading = false;
          });
          showAppSnackBar(context, "Include country code to phone number");
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              phone: phoneEmailCtrl.text,
            ),
          ),
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: Dimens.marginSmall, right: Dimens.marginSmall),
            child: Stack(
              children: [
                const SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SysAppBar(
                      showBackArrow: true,
                      title: Strings.appTitle,
                    ),
                  ),
                ),
                Positioned(
                    top: size.height * 0.14,
                    child: Text(
                      "We’ll send you a confirmation code",
                      style: AppStyles.textBodyDefault.copyWith(fontSize: 16),
                    )),
                Positioned(
                  top: size.height * 0.50,
                  width: size.width * 1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        child: SizedBox(
                          width: size.width * 0.94,
                          child: AppTextFormField(
                            borderColor: AppColors.greyBorder,
                            textController: phoneEmailCtrl,
                            label: Strings.formfieldLabel,
                            prefixIcon: flagWidget(),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimens.marginMedium),
                      AppButton(
                        width: size.width * 1.0,
                        height: size.height * 0.08,
                        buttonColor: AppColors.primaryGreen,
                        textColor: AppColors.black,
                        onPressed: onSubmit,
                        buttonText: Strings.buttonText,
                      ),
                      const SizedBox(height: Dimens.marginMedium),
                      SizedBox(
                        width: size.width * 0.95,
                        child: const Text.rich(
                          TextSpan(
                              text: "By signing up I agree to Zëdfi’s ",
                              style: AppStyles.textBodyDefault,
                              children: [
                                TextSpan(
                                    text: "Privacy Policy ",
                                    style: AppStyles.textBody1),
                                TextSpan(text: "and "),
                                TextSpan(
                                    text: "Terms of Use ",
                                    style: AppStyles.textBody1),
                                TextSpan(
                                    text:
                                        "and allow Zedfi to use your information for future "),
                                TextSpan(
                                    text: "Marketing purposes.",
                                    style: AppStyles.textBody1),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: loading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget flagWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(5.0, 0, 2.0, 0.0),
      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Image.asset(
        AppConstants.countryFlag,
        height: 10.0,
        width: 10.0,
        fit: BoxFit.contain,
      ),
    );
  }
}
