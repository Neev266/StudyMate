import 'package:flutter/material.dart' ;
import 'package:lottie/lottie.dart';
import 'dart:async';

// class Welcome extends StatefulWidget {
//   const Welcome({super.key});

//   @override
//   State<Welcome> createState() => _WelcomeState();
// }

// class _WelcomeState extends State<Welcome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(100,30,0,0),
//           child: Text(
//             "StudyMate",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 30,
//             ),
//             ),
//         )
//       ),
//     );
//   }
// }




class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool showFirst = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Toggle animation every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          showFirst = !showFirst; // switch between true & false
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // cleanup timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show one animation at a time
                  SizedBox(
                    height: 200,
                    child: showFirst
                        ? Lottie.asset("assets/images/doodle1.json",
                        
                        )
                        : Lottie.asset("assets/images/doodle2.json",
                        
                        ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome to Study Notes",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Organize your notes and study smarter!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Continue button at bottom right
            Positioned(
              bottom: 20,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text(
                  "Continue →",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

