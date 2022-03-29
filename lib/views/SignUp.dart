import 'package:flutter/material.dart';
import '../util/Utilities.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = true;

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
                          padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 10.0),
                          child: SizedBox(
                            width: _width / 5 < 400 ? 400 : _width / 5,
                            child: TextFormField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              validator: (String? value) {
                                debugPrint(_usernameController.text);
                                if (value == null || value.isEmpty) {
                                  return 'Username required';
                                }
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
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                              validator: (String? value) {
                                debugPrint(_emailController.text);
                                if (value == null || value.isEmpty) {
                                  return 'Email required';
                                }
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              child: const Text('Register'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await signUp(context, _usernameController.text, _passwordController.text, _emailController.text);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
