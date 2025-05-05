import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:todo/buttons.dart';

class Welcome extends StatelessWidget
{
  const Welcome({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 50),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: 400),
              // Logo
              // Image.asset(
              //   "assets/logo.png",
              //   width: 400,
              //   height: 400,
              // ),

              // Middle text
              Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 12,

                    children: [
                      // Headline
                      Text(
                        "To-Do List",

                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      // Subtext
                      Text(
                        "Organize your life now",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,

                          color: Color.fromRGBO(120, 120, 120, 1),
                        ),

                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
              ),

              // Buttons
              Column(
                spacing: 10,
                children: [
                  // Sign up button
                  PrimaryButton(
                    text: "Get Started",
                    onPressed: ()
                    {
                      Navigator.pushNamed(context, "/signup");
                    },
                  ),

                  // Login section
                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",

                      style: TextStyle(fontSize: 18),

                      // Login link
                      children: [
                        TextSpan(
                          text: 'Login',

                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),

                          recognizer: TapGestureRecognizer()
                            ..onTap = ()
                            {
                              Navigator.pushNamed(context, '/login');
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}