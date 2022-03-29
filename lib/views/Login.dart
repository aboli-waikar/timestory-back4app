import 'package:flutter/material.dart';
import 'package:timestory_back4app/views/SignUp.dart';

import '../util/Utilities.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String routeName = "/Login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = true;

  //The GlobalKey<FormState> object will be used for validating the user’s entered email and password, and both of the TextEditingControllers are used for tracking changes to those text fields. The last two attributes, _success and _userEmail, will be used to keep track of state for this screen.

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: _height,
              width: _width,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("images/background.jpeg"), fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Image(image: AssetImage("images/icon.png")),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
                          child: SizedBox(
                            width: _width / 5 < 400 ? 400 : _width / 5,
                            child: TextFormField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                              decoration: const InputDecoration(labelText: 'Username'),
                              validator: (String? value) {
                                debugPrint(_usernameController.text);
                                if (value == null || value.isEmpty) return 'Username required';
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: _width / 5 < 400 ? 400 : _width / 5,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: showPassword,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = false;
                                    });
                                  },
                                ),
                              ),
                              validator: (String? value) {
                                debugPrint(value);
                                if (value == null || value.isEmpty) return 'Please enter password';
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              child: const Text('Submit'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await signIn(context, _usernameController.text, _passwordController.text, null);
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                            child: Container(
                              height: 40,
                              width: 230,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(image: AssetImage('images/google.png'), fit: BoxFit.cover), shape: BoxShape.circle),
                                  ),
                                  Text('Sign In With Google', style: Theme.of(context).textTheme.bodyText1),
                                ],
                              ),
                            ),
                            onTap: () async {
                              await signInWithGoogle(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?   ", style: Theme.of(context).textTheme.bodyText1),
                              Text("                   ", style: Theme.of(context).textTheme.bodyText1),
                              ElevatedButton(
                                child: const Text("Sign Up"),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  clearForm() {
    //on Logout the login page is again displayed. This function clears the user input fields.
    _usernameController.text = '';
    _passwordController.text = '';
  }
}
