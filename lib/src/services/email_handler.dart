import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseEmailLinkHandler {
  Future<dynamic>? _deepLink;
  FirebaseDynamicLinks? _firebaseDynamicLinks;

  FirebaseEmailLinkHandler() {
    _firebaseDynamicLinks = FirebaseDynamicLinks.instance;
    initializeFirebaseEmailLinkOnClick();
  }

  Future<Uri?> getDynamicData() async {
    final PendingDynamicLinkData? linkData =
        await _firebaseDynamicLinks?.getInitialLink();
    return linkData?.link;
  }

  Future<dynamic> getClickedDynamicData() async {
    return _deepLink ?? Future.value(false);
  }

  void initializeFirebaseEmailLinkOnClick() {
    try {
      _firebaseDynamicLinks?.onLink.listen((event) {
        Uri? linkUri = event.link;
        _deepLink = Future.value(linkUri);
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
