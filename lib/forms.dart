import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:todo/buttons.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FormFieldLabel extends StatelessWidget
{
  final String labelText;

  const FormFieldLabel({
    super.key,
    required this.labelText
  });

  @override
  Widget build(BuildContext context)
  {
    return Text(
        labelText,

        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        )
    );
  }
}

class FormFieldInput extends StatefulWidget
{
  final String? hintText;
  final bool? obscureText;
  final Widget? suffixIcon;

  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  const FormFieldInput({
    super.key,
    this.hintText,
    this.obscureText,
    this.suffixIcon,

    this.validator,
    this.controller
  });

  @override
  FormFieldInputState createState() => FormFieldInputState();
}

class FormFieldInputState extends State<FormFieldInput>
{
  bool? _isObscured;

  @override
  void initState()
  {
    super.initState();
    _isObscured = widget.obscureText ?? false;
  }

  void _toggleVisibility()
  {
    setState( ()
    {
      _isObscured = ! _isObscured!;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Color.fromRGBO(235, 235, 235, 1),
      ),

      child: TextFormField(
        obscureText: _isObscured ?? false,

        validator: widget.validator,

        controller: widget.controller,

        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.black38,
          ),

          suffixIcon: widget.obscureText == true
              ? IconButton(
            icon: Icon(
              _isObscured! ? Icons.visibility : Icons.visibility_off,
            ),

            onPressed: _toggleVisibility,
          )
              : widget.suffixIcon,

          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          border: InputBorder.none,

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,

              width: 2,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget
{
  const SignUpForm({
    super.key
  });

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm>
{
  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerPasswordConfirm = TextEditingController();

  String _error = "";

  @override
  Widget build(BuildContext context)
  {
    return Form(
      key: _formKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        spacing: 20,

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              FormFieldLabel(labelText: "Email"),
              SizedBox(height: 4),
              FormFieldInput(
                hintText: "Enter your email address",

                controller: _controllerEmail,

                validator: (value)
                {
                  if (value == null || value.isEmpty)
                  {
                    return "Please enter an email address";
                  }

                  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                  RegExp regex = RegExp(pattern);

                  if (!regex.hasMatch(value))
                  {
                    return "Please enter a valid email";
                  }

                  return null;
                },
              ),
            ],
          ),

          // Password
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              FormFieldLabel(labelText: "Password"),
              SizedBox(height: 4),
              FormFieldInput(
                  hintText: "Enter your password",
                  obscureText: true,

                  controller: _controllerPassword,

                  validator: (value)
                  {
                    if (value == null || value.isEmpty)
                    {
                      return "Please enter your password";
                    }

                    if (value.length < 6)
                    {
                      return "Password must be at least 6 characters long";
                    }

                    return null;
                  }
              ),
            ],
          ),

          // Password confirmation
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              FormFieldLabel(labelText: "Confirm Password"),
              SizedBox(height: 4),
              FormFieldInput(
                  hintText: "Enter your password again",
                  obscureText: true,

                  controller: _controllerPasswordConfirm,

                  validator: (value)
                  {
                    if (value == null || value.isEmpty)
                    {
                      return "Please enter your password again";
                    }

                    if (value.length < 6)
                    {
                      return "Password must be at least 6 characters long";
                    }

                    return null;
                  }
              ),
            ],
          ),

          // Error Message
          Text(
            _error,

            style: TextStyle(
              color: Colors.red,
            ),
          ),

          // Submit
          PrimaryButton(
            text: "Sign Up",

            onPressed: () async
            {
              if (_formKey.currentState == null)
              {
                return;
              }

              if (!_formKey.currentState!.validate())
              {
                return;
              }

              // Validating password matches
              String password = _controllerPassword.text;
              String passwordConfirm = _controllerPasswordConfirm.text;

              if (password.compareTo(passwordConfirm) != 0)
              {
                _error += "Passwords do not match";

                setState(() {});

                _formKey.currentState!.save();

                return;
              }

              // Attempt to create account
              try
              {
                UserCredential creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _controllerEmail.text,
                    password: password
                );
              }
              on FirebaseAuthException catch (e)
              {
                showDialog(
                  context: context,

                  builder: (context)
                  {
                    return AlertDialog(
                      backgroundColor: Colors.white,

                      title: Center(
                        child: Text(
                          e.message ?? "There was an error with signing up"
                        ),
                      ),
                    );
                  }
                );

                return;
              }

              // Success
              Navigator.pushNamed(
                context,
                "/login",
              );
            },
          ),

          // Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text.rich(
                TextSpan(
                  text: "Already have an account? ",

                  style: TextStyle(
                    fontSize: 16,
                  ),

                  // Sign up link
                  children: [
                    TextSpan(
                      text: "Login",

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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget
{
  const LoginForm({
    super.key
  });

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm>
{
  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Form(
      key: _formKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        spacing: 20,

        children: [

          // Email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              FormFieldLabel(labelText: "Email"),
              SizedBox(height: 4),
              FormFieldInput(
                  hintText: "Enter your email",

                  controller: _controllerEmail,

                  validator: (value)
                  {
                    if (value == null || value.isEmpty)
                    {
                      return "Please enter your email";
                    }

                    return null;
                  }
              ),
            ],
          ),

          // Password
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Password field
              FormFieldLabel(labelText: "Password"),
              SizedBox(height: 4),
              FormFieldInput(
                  hintText: "Enter your password",
                  obscureText: true,

                  controller: _controllerPassword,

                  validator: (value)
                  {
                    if (value == null || value.isEmpty)
                    {
                      return "Please enter your password";
                    }

                    return null;
                  }
              ),

              // Forget Password
              Container(
                width: double.infinity,

                margin: EdgeInsets.only(top: 10.0),

                child: Text(
                  "Forget Password?",

                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),

          // Submit
          PrimaryButton(
            text: "Login",

            onPressed: () async
            {
              if (_formKey.currentState == null)
              {
                return;
              }

              // Fails validation
              if (!_formKey.currentState!.validate())
              {
                _formKey.currentState!.save();

                return;
              }

              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _controllerEmail.text,
                password: _controllerPassword.text
              );

              // Success
              // FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
              // Navigator.pushNamed(
              //     context,
              //     "/home"
              // );
            },
          ),

          // Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text.rich(
                TextSpan(
                  text: "Don't have an account? ",

                  style: TextStyle(
                    fontSize: 16,
                  ),

                  // Sign up link
                  children: [
                    TextSpan(
                      text: "Sign Up",

                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),

                      recognizer: TapGestureRecognizer()
                        ..onTap = ()
                        {
                          Navigator.pushNamed(context, '/signup');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}