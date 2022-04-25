import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_auth_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseDynamicLinks,
  PendingDynamicLinkData,
  ConfirmationResult,
  UserCredential,
  AuthCredential,
])
void main() {
  group("firebase authentication", () {
    test("throws exception if phone number is not entered", () async {
      final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
      when(mockFirebaseAuth.verifyPhoneNumber())
          .thenThrow(FirebaseAuthException(code: "invalid-phone-number"));

      expect(mockFirebaseAuth.verifyPhoneNumber(), throwsException);
    });

    test("send email link to user", () async {
      MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
      when(mockFirebaseAuth.sendSignInLinkToEmail())
          .thenAnswer((_) => Future<String>.value('test-email-link'));

      expect(mockFirebaseAuth.sendSignInLinkToEmail(), 'test-email-link');
    });

    test("throws error with incorrect email", () async {
      MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
      when(mockFirebaseAuth.sendSignInLinkToEmail())
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(mockFirebaseAuth.sendSignInLinkToEmail(), throwsException);
    });

    test("sign in user with phone credential", () async {
      MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
      when(mockFirebaseAuth.signInWithCredential(MockAuthCredential()))
          .thenAnswer((_) => Future.value(MockUserCredential()));

      verify(mockFirebaseAuth.signInWithCredential(MockAuthCredential()))
          .called(1);
      expect(mockFirebaseAuth.signInWithCredential(MockAuthCredential()),
          isA<MockUserCredential>());
    });
  });
}
