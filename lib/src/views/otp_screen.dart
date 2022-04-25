import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:uxxrapp/src/components/app_button.dart';
import 'package:uxxrapp/src/components/sys_app_bar.dart';
import 'package:uxxrapp/src/services/auth_services.dart';
import 'package:uxxrapp/src/utils/app_alert.dart';
import 'package:uxxrapp/src/utils/app_colors.dart';
import 'package:uxxrapp/src/utils/app_dimens.dart';
import 'package:uxxrapp/src/utils/app_styles.dart';
import 'package:uxxrapp/src/utils/strings.dart';
import 'package:uxxrapp/src/views/home_screen.dart';
import 'package:uxxrapp/src/views/phone_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.phone}) : super(key: key);
  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _pinCtrl = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsCode = '';
  String? verificationId;
  bool enableResend = false;
  int secondRemaining = 60;
  Timer? timer;
  String _countDownTime = "60";

  String constructTime(int seconds) {
    _countDownTime = seconds.toString();
    return _countDownTime;
  }

  void _startTimer(int startTime) {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      constructTime(startTime);
      if (startTime == 0) {
        setState(() {
          timer.cancel();
          enableResend = true;
        });
      } else {
        setState(() {
          startTime--;
          constructTime(startTime);
        });
      }
    });
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    log("Verification Completed ${authCredential.smsCode}");
    User? user = _auth.currentUser;
    setState(() {
      smsCode = authCredential.smsCode ?? "";
    });

    if (authCredential.smsCode != null) {
      try {
        UserCredential credential =
            await user!.linkWithCredential(authCredential);
        setState(() {
          user = credential.user;
        });
        log("user from login ${credential.user}");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provide-already-linked') {
          await _auth.signInWithCredential(authCredential);
          timer?.cancel();
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        }
      }

      timer?.cancel();
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == "invalid-phone-number") {
      showAppSnackBar(context, "phone number is invalid");
      Navigator.of(context).pushNamed(PhoneScreen.routeName);
    }
  }

  _onCodeSent(String verificationId, int? forceResendToken) {
    setState(() {
      verificationId = verificationId;
    });

    log(forceResendToken.toString());
  }

  _codeTimeOut(String timeout) {
    log(timeout);
    setState(() {
      enableResend = true;
    });
    return;
  }

  _sendVerificationCode() async {
    await AuthService.phoneVerification(
      widget.phone,
      _onVerificationCompleted,
      _onVerificationFailed,
      _onCodeSent,
      _codeTimeOut,
    );
  }

  @override
  void initState() {
    _sendVerificationCode();
    _startTimer(60);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(
            left: Dimens.marginSmall, right: Dimens.marginSmall),
        child: Stack(
          children: [
            const SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: SysAppBar(
                  showBackArrow: false,
                  title: Strings.otpPageTitle,
                  // fontSize: 24,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.14,
              child: const Text(
                "Enter the confirmation code below",
                style: AppStyles.textBodyDefault,
              ),
            ),
            Positioned(
              top: size.height * 0.35,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: PinCodeTextField(
                  autofocus: true,
                  controller: _pinCtrl,
                  hideCharacter: false,
                  highlight: false,
                  defaultBorderColor: AppColors.greyBorder,
                  hasTextBorderColor: AppColors.primaryGreen,
                  highlightPinBoxColor: AppColors.pinBoxColor,
                  maxLength: 6,
                  hasError: false,
                  maskCharacter: "*",
                  pinBoxWidth: 50,
                  pinBoxHeight: 70,
                  hasUnderline: false,
                  wrapAlignment: WrapAlignment.spaceAround,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinBoxRadius: 15,
                  pinTextStyle: const TextStyle(fontSize: 20.0),
                  keyboardType: TextInputType.number,
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration:
                      const Duration(milliseconds: 300),
                  highlightAnimationBeginColor: AppColors.primaryGreen,
                  highlightAnimationEndColor: AppColors.white,
                  onDone: (text) async {
                    log(text);
                  },
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.45,
              child: Row(
                children: [
                  const Text(
                    "Didn’t recieve a code?",
                    style: AppStyles.textBodyDefault,
                  ),
                  TextButton(
                    onPressed: enableResend ? _sendVerificationCode : null,
                    child: Text(
                      enableResend
                          ? "Resend code"
                          : "Wait for $secondRemaining sec",
                      style: AppStyles.textBody1.copyWith(
                        color: enableResend ? AppColors.blue : AppColors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.60,
              child: AppButton(
                width: size.width * 1.0,
                height: size.height * 0.08,
                buttonColor: AppColors.primaryGreen,
                textColor: AppColors.black,
                onPressed: () async {
                  if (_pinCtrl.text.length == 6) {
                    // sign user in with phone credentials
                    AuthService.signInWithPhoneCredential(
                            _pinCtrl.text, verificationId)
                        .then((credentials) {
                      if (credentials != null) {
                        Navigator.of(context).pushReplacementNamed(
                            HomeScreen.routeName,
                            arguments: credentials);
                      }
                    }).onError(
                      (error, stackTrace) => showAppSnackBar(
                        context,
                        error.toString(),
                      ),
                    );
                  }
                },
                buttonText: Strings.buttonText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
