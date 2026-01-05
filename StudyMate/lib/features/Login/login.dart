// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_app/features/Home/home.dart';
// import 'package:flutter_app/features/Signin/signup.dart';

// import 'package:flutter_app/features/Login/bloc/login_bloc.dart';
// import 'package:flutter_app/features/Login/bloc/login_event.dart';
// import 'package:flutter_app/features/Login/bloc/login_state.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   final _formkey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => LoginBloc(),
//       child: BlocConsumer<LoginBloc, LoginState>(
//         listener: (context, state) {
//           if (state is LoginSuccess) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const Home()),
//             );
//           } else if (state is LoginFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: Colors.white,
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
//                 child: Form(
//                   key: _formkey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/SplashScreen.png',
//                         width: 300,
//                         height: 250,
//                       ),

//                       // Email
//                       TextFormField(
//                         controller: _email,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: _inputDecoration("Email Id", Icons.email),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please Enter an Email Id';
//                           }
//                           if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                               .hasMatch(value)) {
//                             return 'Please Enter a Valid Email Address';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 20),

//                       // Password
//                       TextFormField(
//                         controller: _password,
//                         obscureText: true,
//                         decoration: _inputDecoration("Password", Icons.lock),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Enter a Password';
//                           }
//                           if (value.length < 5) {
//                             return 'Password must be at least 5 characters';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 40),

//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: state is LoginLoading
//                               ? null
//                               : () {
//                                   if (_formkey.currentState!.validate()) {
//                                     context.read<LoginBloc>().add(
//                                           LoginButtonPressed(
//                                             _email.text,
//                                             _password.text,
//                                           ),
//                                         );
//                                   }
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.teal[400],
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: state is LoginLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   'Log In',
//                                   style: TextStyle(
//                                       fontSize: 18, color: Colors.white),
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "Don't have an account? ",
//                             style: TextStyle(
//                                 color: Colors.black87, fontSize: 15),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const Signup()),
//                               );
//                             },
//                             child: Text(
//                               "Sign up",
//                               style: TextStyle(
//                                 color: Colors.teal[400],
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Input Decoration
//   InputDecoration _inputDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, color: Colors.teal[400]),
//       filled: true,
//       fillColor: Colors.grey[100],
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
// }
