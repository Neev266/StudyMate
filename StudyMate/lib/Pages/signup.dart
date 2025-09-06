import 'package:flutter/material.dart' ;
import 'package:flutter_app/Pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}
String? _errorMessage;

class _SignupState extends State<Signup> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>(); 
  
  Future<void> Signin() async{
    try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim());
  setState(() {
    _errorMessage=null;
  });

  }
  
  on FirebaseAuthException catch(e){
    setState(() {
      if(e.code == 'weak-password'){
      _errorMessage='The password provided is too weak.';
    } else if(e.code == 'email-already-in-use'){
      _errorMessage='The account already exists for that email.';
    }else if(e.code == 'invalid-email'){
      _errorMessage='The email address is invalid.';
    }else {
      _errorMessage='Signup failed: ${e.message}';
    }
    });
    
  } catch(e){
    setState(() {
      _errorMessage='An unexpected error occurred: $e';
    });
    
  }

  Future.delayed(Duration(seconds: 3),(){
    setState(() {
      _errorMessage=null;
    });
    
  });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(50.0,75,50.0,0.0),
          child: Center(
             child:Form(
              key: _formkey,
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  
                children: [
                  Text(
                        'StudyMate',
                         style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                         ),
                        ),
                   SizedBox(height: 50),
                  Text(
                        'Sign In Page',
                         style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                         ),
                        ),
                   SizedBox(height: 50),
                  TextFormField(
                    maxLength: 50,
                      controller: _email,
                      
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email,color: Colors.black,),
                        label: Text('Email Id'),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(200),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(200),
                        borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return 'Please Enter an Email Id';
                      }
                      if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
                        return 'Please Enter a Valid Email Adress';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20 ),
                  TextFormField(
                    maxLength: 50,
                    controller: _password,
                    
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password,color: Colors.black,),
                      label: Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(200),
                        borderSide: BorderSide(
                        color: Colors.black87,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(200),
                        borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if(value==null || value.isEmpty){
                        return 'Enter a Password';
                      }
                      if(value.length<5){
                        return 'Enter a password with minimum 5 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_formkey.currentState!.validate()){
                            
                          await Signin();
                          
                          if(_errorMessage==null){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Home()),
                           );
                        }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[400],
                      ), 
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          
                        ),
                        ) ,
                    ),
                    
                  ),
                  
                  
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
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
      )
    );
  }
}