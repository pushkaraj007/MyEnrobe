// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:trier/screens/reset.dart';
// import 'package:trier/screens/signup_page.dart';
// import '../utils/animationlogin.dart';
// import '../utils/button.dart';
// import 'dashboard.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   bool _isLoading = false;
//   bool _loginSuccess = false;
//
//   String _username = '';
//   String _password = '';
//   String _errorMessage = '';
//
//   void _login() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       try {
//         final userQuerySnapshot = await _firestore
//             .collection('users')
//             .where('username', isEqualTo: _username)
//             .limit(1)
//             .get();
//
//         if (userQuerySnapshot.docs.isNotEmpty) {
//           final userDocument = userQuerySnapshot.docs.first;
//           final userEmail = userDocument['email'];
//
//           final userCredential = await _auth.signInWithEmailAndPassword(
//             email: userEmail,
//             password: _password,
//           );
//
//           if (userCredential != null) {
//             // Login successful
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DashboardScreen()),
//             );
//             setState(() {
//               _loginSuccess = true;
//             });
//           }
//         } else {
//           showErrorDialog('User not found. Please enter a valid username.');
//         }
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'wrong-password') {
//           // Password is incorrect
//           showErrorDialog('Username or Password is incorrect');
//         } else {
//           // Handle other authentication errors
//           showErrorDialog('Username or Password is incorrect');
//         }
//       } catch (e) {
//         // Handle other exceptions
//         showErrorDialog('An unexpected error occurred');
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   void showErrorDialog(String errorMessage) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(errorMessage),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: PreferredSize(
//       //   preferredSize: Size.fromHeight(50.0),
//       //   child: AppBar(
//       //     title: Text(
//       //       '                                Login',
//       //       style: TextStyle(
//       //         color: Colors.white,
//       //         fontSize: 20.0,
//       //         fontWeight: FontWeight.w600,
//       //       ),
//       //     ),
//       //     backgroundColor: Color(0xFF4BAE4F),
//       //     elevation: 0,
//       //   ),
//       // ),
//       resizeToAvoidBottomInset: false, // Prevents resizing when the keyboard is displayed
//       body: Stack(
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('images/bgbg.png'),
//                   fit: BoxFit.cover,
//                   // colorFilter: ColorFilter.mode(
//                   //   Colors.black.withOpacity(1),  // Adjust the opacity (0.0 - 1.0)
//                   //   BlendMode.dstATop,
//                   // ),
//                 ),
//               ),
//               child: Center(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       // color: Colors.black.withOpacity(0.1),
//                     ),
//                     child: Center(
//                       child: SingleChildScrollView(
//
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(16,10, 16, 10),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Text(
//                               //   'Welcome to StyleStream',
//                               //   style: TextStyle(
//                               //     fontSize: 26,
//                               //     fontWeight: FontWeight.bold,
//                               //   ),
//                               // ),
//                               // SizedBox(height: 16),
//                               // Text(
//                               //   'Kindly Log in to continue our app',
//                               //   style: TextStyle(
//                               //     fontSize: 22,
//                               //   ),
//                               // ),
//                               Image.asset(
//                                 'images/My Enrobe-logos_black.png',
//                                 height: 160.0,
//                                 width: 3000,
//                                 fit: BoxFit.fitWidth,
//                               ),
//                               const SizedBox(height: 0),
//                               Form(
//                                 key: _formKey,
//                                 child: Padding(
//                                   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                                   child: Column(
//                                     children: [
//                                       TextFormField(
//                                         decoration: const InputDecoration(
//                                           labelText: 'Username',
//                                           border: OutlineInputBorder(),
//                                           labelStyle: TextStyle( // Set labelStyle to make the label bold
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                           contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0), // Adjust the padding
//
//                                         ),
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return 'Please enter your username';
//                                           }
//                                           return null;
//                                         },
//                                         onSaved: (value) {
//                                           _username = value!;
//                                         },
//                                       ),
//                                       const SizedBox(height: 16),
//                                       TextFormField(
//                                         decoration: const InputDecoration(
//                                           labelText: 'Password',
//                                           border: OutlineInputBorder(),
//                                           labelStyle: TextStyle( // Set labelStyle to make the label bold
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         obscureText: true,
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return 'Please enter your password';
//                                           }
//                                           return null;
//                                         },
//                                         onSaved: (value) {
//                                           _password = value!;
//                                         },
//                                       ),
//                                       const SizedBox(height: 25.0),
//                                       AnimatedLoginButton(
//                                         onPressed: _login,
//                                         shouldAnimate: _loginSuccess,
//                                       ),
//                                       // AnimatedLoginButton(),
//
//                                       const SizedBox(height:15),
//
//                                       const SizedBox(height: 30),
//                                       CustomButton(
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
//                                           );
//                                         },
//                                         text: 'Forgot Password?',
//                                         width: 200.0, // Set the width for the "Forgot Password?" button
//                                         height: 35.0, // Set the height for the "Forgot Password?" button
//                                       ),
//                                       const SizedBox(height: 16),
//                                       CustomButton(
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => const SignupScreen()),
//                                           );
//                                         },
//                                         text: "Don't have an account? Sign Up!",
//                                         width: 350.0, // Set the width for the "Don't have an account?" button
//                                         height: 40.0, // Set the height for the "Don't have an account?" button
//                                       ),
//
//                                       if (_errorMessage.isNotEmpty)
//                                         Text(
//                                           _errorMessage,
//                                           style: const TextStyle(
//                                             color: Colors.red,
//                                             fontSize: 16.0,
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:trier/login&signin/reset.dart';
import 'package:trier/login&signin/signup_page.dart';
import '../utils/animationlogin.dart';
import '../utils/button.dart';
import '../screens/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  // final _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  bool _loginSuccess = false;

  String _username = '';
  String _password = '';
  String _errorMessage = '';

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final userQuerySnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: _username)
            .limit(1)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          final userDocument = userQuerySnapshot.docs.first;
          final userEmail = userDocument['email'];

          final userCredential = await _auth.signInWithEmailAndPassword(
            email: userEmail,
            password: _password,
          );

          if (userCredential != null) {
            // Login successful
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
            setState(() {
              _loginSuccess = true;
            });
          }
        } else {
          showErrorDialog('User not found. Please enter a valid username.');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          // Password is incorrect
          showErrorDialog('Username or Password is incorrect');
        } else {
          // Handle other authentication errors
          showErrorDialog('Username or Password is incorrect');
        }
      } catch (e) {
        // Handle other exceptions
        showErrorDialog('An unexpected error occurred');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // void _loginWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //
  //     if (googleUser == null) {
  //       // The user canceled the sign-in process
  //       return;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth =
  //     await googleUser.authentication;
  //
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final UserCredential userCredential =
  //     await _auth.signInWithCredential(credential);
  //
  //     if (userCredential.user != null) {
  //       // Google login successful
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => DashboardScreen()),
  //       );
  //       setState(() {
  //         _loginSuccess = true;
  //       });
  //     }
  //   } catch (e) {
  //     // Handle Google Sign-In errors
  //     print('Error during Google Sign-In: $e');
  //   }
  // }

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/5247.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Container(
                        decoration: const BoxDecoration(
                            // color: Colors.black.withOpacity(0.1),
                            ),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/My Enrobe-logos_black.png',
                                      height: 160.0,
                                      width: 3000,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(height: 0),
                                    Form(
                                      key: _formKey,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors
                                                  .white60, // Set your desired background color
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Username',
                                                  border: OutlineInputBorder(),
                                                  labelStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 18.0,
                                                          horizontal: 16.0),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter your username';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _username = value!;
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Container(
                                              color: Colors.white60,
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Password',
                                                  border: OutlineInputBorder(),
                                                  labelStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                obscureText: true,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter your password';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _password = value!;
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 25.0),
                                            AnimatedLoginButton(
                                              onPressed: _login,
                                              shouldAnimate: _loginSuccess,
                                            ),
                                            const SizedBox(height: 15),
                                            ElevatedButton(
                                              onPressed: _login,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .white, // Change to the desired color
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'images/google.png',
                                                    height: 20.0,
                                                    width: 20.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Text(
                                                      'Sign in with Google'),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    16), // Add spacing between Google and Forgot Password

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.white,
                                                      elevation: 0,
                                                    ),
                                                    child: Text(
                                                      'Forgot Password?',
                                                      style: TextStyle(fontSize: 13, color: Colors.black),
                                                      overflow: TextOverflow.ellipsis,

                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.white,
                                                      elevation: 0,
                                                    ),
                                                    child: Text(
                                                      'Sign Up!',
                                                      style: TextStyle(fontSize: 16, color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            if (_errorMessage.isNotEmpty)
                                              Text(
                                                _errorMessage,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
