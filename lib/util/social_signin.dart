import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_base/util/common_api_class.dart';
import 'package:flutter_base/util/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialSignIn {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: Platform.isIOS ? AppConstants.FIREBASE_GOOGLE_CLIENT_ID_IOS : AppConstants.FIREBASE_GOOGLE_CLIENT_ID_ANDROID, scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ]);
  
  get SignInWithApple => null;


  Future<User?> signInWithGoogle() async {

    await signOut();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      return null;
    }
  }

  Future<bool> isUserGoogleSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<void> signOutWithGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      CommonApiClass().normalPrintJson(e.toString());
    }
  }

  Future<String?> getFcmToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }

  Future<User?> signInWithFacebook() async {
    try {

       // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
 
      // Check if login was successful
      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.tokenString);

        // Once signed in, return the UserCredential
        UserCredential userCredential =
        await _auth.signInWithCredential(facebookAuthCredential);
        User? user = userCredential.user;

        debugPrint("User from Facebook: $user");
        return user;
      } else {
        debugPrint("Facebook login failed: ${loginResult.status}");
        return null;
      }
    } catch (e) {
      debugPrint("Error signing in with Facebook: $e");
      return null;
    }
  }

  Future<bool> isUserFacebookSignedIn() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    return accessToken != null;
  }

  Future<void> signOutWithFacebook() async {
    try {
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
      debugPrint('User signed out from Facebook');
    } catch (e) {
      debugPrint('Error signing out from Facebook: $e');
    }
  }


  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
      User? user = userCredential.user;

      return user;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint("SignInWithAppleAuthorizationException: Code: ${e.code}, Message: ${e.message}, Details: ${e.message}");
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint("User canceled the sign-in process.");
      }
      return null;
    } catch (e) {
      debugPrint("General error signing in with Apple: $e");
      return null;
    }
  }

}
