import 'package:flutter/material.dart';
import 'package:odyssee/services/auth.dart';
import 'package:odyssee/shared/loading.dart';
import 'package:odyssee/shared/styles.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String email = '';
  String password = '';
  bool loading = false;
  String error = '';

  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal:50.0),
          decoration: Styles.authBackgroundDecoration,
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Text("ODYSSEE",
                  style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: 'BOTW',
                  color: Color(0xFFE5D9A5),
//                  fontStyle: FontStyle.italic,
//                  fontWeight: FontWeight.bold,
                  ),
                 ),
                ),
                Expanded(child: SizedBox(height: 20.0)),

                TextFormField(
                      decoration: Styles.textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter an email': null,
                      onChanged:(val){
                        setState(() => email = val);
                      },
                      ),

                Expanded(child: SizedBox(height: 20.0)),

                TextFormField(
                    decoration: Styles.textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Enter a value at least 6 characters long': null,
                    onChanged:(val){
                      setState(() => password = val);
                    },
                  ), 
                
                Expanded(child: SizedBox(height: 20.0)),

                RaisedButton(
                  color: Color(0xEF615F5F),
                  child: Text(
                    'Log In',
                    style: TextStyle(color : Colors.white)
                    ),
                  onPressed: () async {
                    if(_formkey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                      if (result == null){
                        setState(() {
                          error = 'Please supply a valid email and password';
                          loading = false;
                        });
                      }
                    }
                  }, 
                  ),

                Expanded(child: SizedBox(height: 10.0)),
                
                Text('Don\'t have an account?',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white),
                ),

                SizedBox(height: 10.0),

                RaisedButton(
                  color: Color(0xEF615F5F),
                  child: Text(
                    'Create An Account',
                    style: TextStyle(color: Colors.white)
                  ),
                  onPressed: () async {
                    widget.toggleView();
                  },
                )
                  
              ],
            ),
          )
        )
        );
      }
      }