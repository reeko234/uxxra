import 'package:firebase_auth/firebase_auth.dart';
import 'package:uxxrapp/src/utils/strings.dart';

class AuthService {
  static final fbInstance = FirebaseAuth.instance;

  static dynamic phoneVerification(
    String phone,
    void Function(PhoneAuthCredential) verificationCompleted,
    void Function(FirebaseAuthException) verificationFailed,
    void Function(String, int?) onCodeSent,
    void Function(String) codeTimeOut,
  ) async {
    try {
      await fbInstance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: onCodeSent,
          codeAutoRetrievalTimeout: codeTimeOut);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> sendEmailLink(String email) async {
    ActionCodeSettings actionCodeSettings = ActionCodeSettings(
      url: Strings.deepLinkUrl,
      iOSBundleId: Strings.appBundle,
      androidPackageName: Strings.appBundle,
      dynamicLinkDomain: Strings.dynamicLinkDomain,
      androidInstallApp: true,
      handleCodeInApp: true,
    );
    await fbInstance
        .sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: actionCodeSettings,
        )
        .catchError((e) => throw e);
  }

  static Future<dynamic> signInWithPhoneCredential(
      String? smsCode, String? verificationId) async {
    if (smsCode != null && verificationId != null) {
      var credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      try {
        var res = await fbInstance.signInWithCredential(credential);
        return res;
      } catch (e) {
        rethrow;
      }
    }
  }
}
