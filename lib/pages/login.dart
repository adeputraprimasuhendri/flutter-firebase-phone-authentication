import 'package:app/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = new GlobalKey<FormState>();
  String _phoneNumber, _verificationId, _smsCode;
  bool _smsSent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _smsSent ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: 'Masukkan Kode OTP'
                ),
                onChanged: (val){
                  setState(() {
                    this._smsCode = val;
                  });
                },
              ),
            ): Container(),
            _smsSent ? Container() : Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: 'Masukkan Nomor Telepon'
                ),
                onChanged: (val){
                  setState(() {
                    this._phoneNumber = val;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                child: Center(
                  child: _smsSent ? Text('Verifikasi') : Text('Login'),
                ),
                onPressed: (){
                  _smsSent ? AuthService().signInWithOTP(_smsCode, _verificationId) : verifyPhone(_phoneNumber);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> verifyPhone(phoneNumber) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult){
      AuthService().signIn(authResult);
    };
    final PhoneVerificationFailed verificationFailed = (AuthException authException){
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]){
      this._verificationId = verId;
      setState(() {
        this._smsSent = true;
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId){
      this._verificationId = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
