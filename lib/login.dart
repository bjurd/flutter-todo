import 'package:flutter/material.dart';

import 'package:todo/forms.dart';

class Login extends StatelessWidget
{
  const Login({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 00),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            spacing: 28,

            children: [
              // Header
              Text(
                "Login to Your Account",

                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500
                ),
              ),

              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}