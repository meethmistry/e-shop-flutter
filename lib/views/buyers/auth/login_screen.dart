import 'package:e_shop/controllers/auth_controllers.dart';
import 'package:e_shop/views/buyers/auth/registr_screen.dart';
import 'package:e_shop/views/buyers/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  late String password;

  bool _validateEmail(String email) {
    final RegExp emailValidatorRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+.com");
    return emailValidatorRegExp.hasMatch(email);
  }

  showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          msg,
          style: TextStyle(fontSize: 15),
        )));
  }

  bool _isLoading = false;

  loginUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const MainScreen();
        }));
      } else {
        setState(() {
          _isLoading = false;
          showSnack("Inccorect email or password");
        });
      }
    } else {
      _isLoading = false;
      showSnack("Login data are not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 180,
                  width: 180,
                  child: Image.asset('assets/images/logoimg.png'),
                ),
                const Text(
                  "Login To Customer's Account",
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Enter Email Address"),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (!_validateEmail(value)) {
                          return "Enter valid email";
                        }
                      } else {
                        return "Email can't be blank";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: "Enter Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password can't be blank";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    loginUser();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const BuyersRegistrationScreen();
                          }));
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(color: Colors.blue.shade500),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
