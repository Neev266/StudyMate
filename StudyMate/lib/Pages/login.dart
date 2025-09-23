// import 'package:flutter/material.dart' ;
// import 'package:flutter_app/Pages/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_app/Pages/signup.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }
// String? _errorMessage;
// class _LoginState extends State<Login> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   final _formkey = GlobalKey<FormState>(); 
  
//   Future<void> Login() async{
//     await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _password.text);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(50.0,50.0,50.0,0.0),
//           child: Center(
//             child:Form(
//               key: _formkey,
//                child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
                  
//                 children: [
//                   Text(
//                         'StudyMate',
//                          style: TextStyle(
//                           fontSize: 45,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                          ),
//                         ),
//                    SizedBox(height: 50),
                  
//                   TextFormField(
//                     maxLength: 50,
//                       controller: _email,
//                       keyboardType: TextInputType.emailAddress,
//                       style: TextStyle(
//                         color: Colors.black
//                       ),
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(
//                           Icons.email,
//                           color: Colors.black,
//                         ),
//                         label: Text(
//                           'Email Id',
//                             style: TextStyle(
//                           color: Colors.grey,
//                          ),
//                           ),
//                         border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(200),
//                         borderSide: BorderSide(
//                           color: Colors.black,
//                        )
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(200),
//                         borderSide: BorderSide(
//                         color: Colors.black,
//                         width: 2,
//                       ),
//                     ),
//                     ),
//                     validator: (value){
//                       if(value==null || value.isEmpty){
//                         return 'Please Enter an Email Id';
//                       }
//                       if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
//                         return 'Please Enter a Valid Email Adress';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20 ),
//                   TextFormField(
//                     maxLength: 50,
//                     controller: _password,
//                     keyboardType: TextInputType.visiblePassword,
//                     style: TextStyle(
//                       color: Colors.black
//                     ),
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.password,
//                       color: Colors.black,
//                       ),
//                       label: Text('Password',
//                       style: TextStyle(
//                           color: Colors.grey,
//                          ),
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(200),
//                         borderSide: BorderSide(
//                           color: Colors.black87,
//                         )
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(200),
//                         borderSide: BorderSide(
//                           color: Colors.black,
//                           width: 2,
//                         ),
//                       ),
                      
//                     ),
//                     obscureText: true,
//                     validator: (value) {
//                       if(value==null || value.isEmpty){
//                         return 'Enter a Password';
//                       }
//                       if(value.length<5){
//                         return 'Enter a password with minimum 5 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 50),
//                   SizedBox(
//                     width: 200,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if(_formkey.currentState!.validate()){
//                           try{
//                           await Login();
                          
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const Home()),
                            
//                           );
//                           }
//                           catch(e){
//                             _errorMessage='Login Failed: ${e.toString()}';
//                           }
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.teal[400],
//                       ), 
//                       child: Text(
//                         'Log In',
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                         ),
//                         ) ,
//                     ),
                    
//                   ),
        
//                   SizedBox(height: 10),
        
//                   Text('OR',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   ),
//                   SizedBox(height: 10),
        
//                   SizedBox(
//                     width: 200,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if(_errorMessage==null){
//                         Navigator.push(
//                           context, 
//                           MaterialPageRoute(builder: (context) => Signup()),
//                         );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.teal[400],
//                         ), 
//                         child: Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
                            
//                           ),
//                           )
//                       ),
//                   ),
//                   // Only show this widget if there is an error
//                     if (_errorMessage != null)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           _errorMessage!,
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),

//                 ],
//               ),
//              ),
            
//           ),
//         ),
//       )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Pages/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

String? _errorMessage;

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> Login() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // clean background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon
                  Image.asset(
                    'assets/images/SplashScreen.png',
                    width: 300,
                    height: 250,
                  ),
                  
                  TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black, 
                          fontSize: 16,        
                          fontWeight: FontWeight.w500, 
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email Id',
                          hintStyle: TextStyle(
                            color: Colors.grey, 
                          ),
                          prefixIcon: Icon(Icons.email, color: Colors.teal[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter an Email Id';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please Enter a Valid Email Address';
                          }
                          return null;
                        },
                      ),

                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    style: TextStyle(
                          color: Colors.black, 
                          fontSize: 16,        
                          fontWeight: FontWeight.w500, 
                        ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                            color: Colors.grey, 
                          ),
                      prefixIcon: Icon(Icons.lock, color: Colors.teal[400]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a Password';
                      }
                      if (value.length < 5) {
                        return 'Password must be at least 5 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          try {
                            await Login();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                            );
                          } catch (e) {
                            setState(() {
                              _errorMessage = 'Login Failed: ${e.toString()}';
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[400],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign Up Text Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black87, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.teal[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Error Message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
