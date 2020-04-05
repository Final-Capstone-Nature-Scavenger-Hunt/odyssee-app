import 'package:flutter/material.dart';
import 'package:odyssee/services/auth.dart';
import 'package:odyssee/shared/loading.dart';
import 'package:odyssee/shared/styles.dart';

class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String email = '';
  String displayName = '';
  String password = '';
  bool loading = false;
  String error = '';

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.appBarStyle,
        elevation : 0.0,
        title: Text('Create an Account on odyssee'),
      ),
    
    body: Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal:50.0),
      decoration: Styles.authBackgroundDecoration,

      child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            TextFormField(
                decoration: Styles.textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email': null,
                onChanged:(val){
                  setState(() => email = val);
                },
                ),

            SizedBox(height: 20.0),

            TextFormField(
                decoration: Styles.textInputDecoration.copyWith(hintText: 'Full Name'),
                validator: (val) => val.isEmpty || val.length < 3 ? 'Please enter a valid name': null,
                onChanged:(val){
                  setState(() => displayName = val);
                },
              ), 
            
            SizedBox(height: 20.0),

            TextFormField(
                decoration: Styles.textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter a value at least 6 characters long': null,
                onChanged:(val){
                  setState(() => password = val);
                },
              ), 
            
            SizedBox(height: 20.0),

            RaisedButton(
              color: Colors.teal[300], 
              child: Text(
                'Sign Up',
                style: TextStyle(color : Colors.white)
                ),
              onPressed: () async {
                print(email);
                print(password);

                if(_formkey.currentState.validate()){
                  setState(() => loading = true);
                  dynamic result = await _auth.registerWithEmailAndPassword(email, password, displayName);

                  if (result == null){
                    setState(() {
                      error = 'Please supply a valid email and password';
                      loading = false;
                    });
                  }
                }
              }, 
              ),

            SizedBox(height: 10.0),
            
            Text('Already have an account?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white),
            ),

            SizedBox(height: 10.0),

            RaisedButton(
              color: Colors.teal[300],
              child: Text(
                'Sign Into Your Account',
                style: TextStyle(color: Colors.white)
              ),
              onPressed: () async {
                widget.toggleView();
              },
            ),

            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle (color: Colors.red, fontSize: 14.0)
            )

          ],
        ),
      )
    )
    );
  }
}