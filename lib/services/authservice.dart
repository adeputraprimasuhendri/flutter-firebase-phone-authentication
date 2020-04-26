import 'package:app/pages/dashboard.dart';
import 'package:app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {

  HandleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          return Dashboard();
        }else{
          return Login();
        }
      });
  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential){
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  signInWithOTP(smsCode, verId){
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId,
        smsCode: smsCode);
    signIn(authCredential);
  }
}