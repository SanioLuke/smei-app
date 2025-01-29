import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smei_workspace/main.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Loginscreen> {
  late final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.translate(offset: Offset(0, MediaQuery.sizeOf(context).height/4), child: Image.asset('images/login_bg.png'),),
          Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Image.asset(
                'images/strip.png',
                fit: BoxFit.fitWidth,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0x4C6A6A6A),
                      blurRadius: 20,
                      offset: Offset(-4, -4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontFamily: 'Comfortaa',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36),
                              ),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Phone Number',
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Comfortaa',
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        InkWell(
                          onTap: () async {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+91 81083 90487	'.trim(),
                              // phoneNumber: '+91 9004361376'.trim(),
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {
                                /// called when user was verified using external package
                                signInUser(credential);
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Error in generating OTP')),
                                );
                              },
                              codeSent: (String verificationId,
                                  int? resendToken) async {
                                log(verificationId);
                                Fluttertoast.showToast(msg: 'Code sent!');
                                Get.toNamed(Routes.loginOtp.routeName,
                                    arguments: verificationId);

                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) => FormExample()));
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                            // return;
                          },
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3FFF6565),
                                  blurRadius: 4,
                                  offset: Offset(4, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "images/arrow-right.png",
                                width: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 36,
              ),

              /// login
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          const Expanded(
                              child: SizedBox(
                                  height: 1,
                                  child: ColoredBox(color: Color(0xFFDADADA)))),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Sign In With',
                            style: GoogleFonts.comfortaa(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Expanded(
                              child: SizedBox(
                                  height: 1,
                                  child: ColoredBox(color: Color(0xFFDADADA)))),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await signInUser(await _signWithGoogle(googleSignIn));
                        },
                        icon: SizedBox.square(
                          dimension: 30,
                          child: SvgPicture.asset(
                            'images/google.svg',
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<OAuthCredential> _signWithGoogle(GoogleSignIn googleSignIn) async {
  // Sign out the current user (optional, consider if needed based on use case)
  await googleSignIn.signOut();

  // Start the sign-in process
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  // Wait for authentication object to be populated before accessing it
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  return GoogleAuthProvider.credential(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
}

Future<void> signInUser(AuthCredential credential) async {
  try {
    await FirebaseAuth.instance.signInWithCredential(credential);
    final SharedPreferences pref = Get.find();
    pref.setBool('loggedIn', true);
    Get.offAllNamed(Routes.home.routeName);
  } catch (e) {
    Fluttertoast.showToast(msg: 'Invalid Credentials');
  }
}
