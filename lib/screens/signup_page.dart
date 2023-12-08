import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart';
import 'login_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _email = '';
  String _username = '';
  String _password = '';
  String _name = '';
  String _contactNo = '';
  String _address = '';
  String _height = '';
  String _weight = '';
  String _shirtsize  = '';
  String _pantsize = '';
  String? _selectedGender; // Add this line


  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Check if the email already exists
        final existingUser = await _firestore
            .collection('users')
            .where('email', isEqualTo: _email)
            .get();

        if (existingUser.docs.isNotEmpty) {
          // Email already exists, show an error
          showErrorDialog('Email already exists. Please use a different email.');
          return;
        }

        // Proceed with signup if email doesn't exist
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        final user = userCredential.user;

        await _firestore.collection('users').doc(user!.uid).set({
          'name': _name,
          'contactNo': _contactNo,
          'address': _address,
          'height': _height,
          'weight': _weight,
          'shirtsize': _shirtsize,
          'pantsize': _pantsize,
          'email': _email,
          'password': _password,
          'username': _username,
          'selectedgender': _selectedGender,
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Signup Successful'),
              content: const Text('You have successfully signed up. \n Press OK to continue'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Signup Error'),
              content: const Text('An error occurred while signing up. Please try again.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
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
        backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   title: const Text('Sign Up'),
      //   automaticallyImplyLeading: false, // Remove back button
      //
      // ),
      // resizeToAvoidBottomInset: false,
        // Prevents resizing when the keyboard is displayed
      body: Stack(
        children: [
        // Background Image
        Image.asset(
        'images/5248.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      // Dark Overlay
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0),
      ),
      // Blurred Background
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Center(
            child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/My Enrobe-logos_black.png',
                                height: 120.0,
                                width: 600,
                                fit: BoxFit.fitWidth,
                              ),
                      const SizedBox(height: 20.0),
                      // Email Text Field

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.white,
                          filled: true,
                          // border: OutlineInputBorder(),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          // ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                      ),
                              const SizedBox(height: 14.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  fillColor: Colors.white,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  // ),
                                ),                                    validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _username = value!;
                                },
                              ),
                              const SizedBox(height: 14.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  fillColor: Colors.white,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  // ),
                                ),                                      obscureText: true,
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
                              const SizedBox(height: 14.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  fillColor: Colors.white,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  // ),
                                ),                                      validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _name = value!;
                                },
                              ),
                              const SizedBox(height: 14.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Contact no',
                                  fillColor: Colors.white,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  // ),
                                ),                                      keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your contact number';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _contactNo = value!;
                                },
                              ),
                              const SizedBox(height: 14.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  fillColor: Colors.white,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  // ),
                                ),                                      validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _address = value!;
                                },
                              ),
                              const SizedBox(height: 14.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Height (in cm)',
                                  fillColor: Colors.white,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  // ),
                                ),                                      validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Height (in cm)';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _height = value!;
                                },
                              ), const SizedBox(height: 14.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Weight (in kg)',
                                  fillColor: Colors.white,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  // ),
                                ),                                      validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Weight (in Kg)';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _weight = value!;
                                },
                              ), const SizedBox(height: 14.0),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Shirt Size (S,M,L..)',
                          fillColor: Colors.white,
                          filled: true,
                          // border: OutlineInputBorder(),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          // ),
                        ),                                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Weight (in Kg)';
                        }
                        return null;
                      },
                        onSaved: (value) {
                          _shirtsize = value!;
                        },
                      ),
                      const SizedBox(height: 14.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Pant Size (28,30,32..)',
                          fillColor: Colors.white,
                          filled: true,
                          // border: OutlineInputBorder(),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          // ),
                        ),                                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Weight (in Kg)';
                        }
                        return null;
                      },
                        onSaved: (value) {
                          _pantsize = value!;
                        },
                      ),
                      const SizedBox(height: 14.0),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        items: ['Male', 'Female', 'Other'].map((String option) {
                          return DropdownMenuItem<String>(
                            value: 'gender_$option', // Add a prefix to make values unique
                            child: Text(option),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your Gender';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14.0),
                              const SizedBox(height: 15.0),
                              ElevatedButton(
                                onPressed: _signUp,
                                child: const Text('Sign Up'),
                              ),
                              ElevatedButton(
                                child: const Text('Already have an account? Login'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  const LoginScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
              )
                      ),
                    ),
                  ),
                ),

      ]
            )
    );

  }
}

