import 'package:flutter/material.dart';
import 'package:tubaline_ta/screens/login/register.dart';
import 'package:tubaline_ta/services/service_user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final ServiceUser _serviceUser = ServiceUser();
  @override
  void initState() {
    super.initState();
  }

  void login() {
    _serviceUser.email = email.text;
    _serviceUser.password = password.text;
    _serviceUser.login(context);
  }

  Widget _buildTextField({
    required bool obscureText,
    Widget? prefixedIcon,
    String? title,
    required TextEditingController textEditingController,
  }) {
    return Material(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      elevation: 2,
      child: TextField(
        controller: textEditingController,
        cursorWidth: 2,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: title,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.blue),
              borderRadius: BorderRadius.circular(30.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black38),
              borderRadius: BorderRadius.circular(30.0)),
          prefixIcon: prefixedIcon,
          labelStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          login();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 60),
              child: Column(
                children: [
                  const Text(
                    'Tubaline',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                    obscureText: false,
                    prefixedIcon: const Icon(Icons.mail, color: Colors.black54),
                    title: 'Email',
                    textEditingController: email,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                    obscureText: true,
                    prefixedIcon: const Icon(Icons.lock, color: Colors.black54),
                    title: 'Password',
                    textEditingController: password,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildLoginButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '- OR -',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          decorationColor: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Register(),
                          )),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'PT-Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
