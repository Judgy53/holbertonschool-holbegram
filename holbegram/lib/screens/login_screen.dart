import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/home.dart';
import 'package:holbegram/screens/signup_screen.dart';
import 'package:holbegram/widgets/text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late bool _passwordVisible;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  void _openSignUpPage() {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (BuildContext context) => const SignUpScreen()
      )
    );
  }

  void _tryLogin() async {
    String message = await AuthMethods.login(email: emailController.text, password: passwordController.text);

    if (!mounted) return;

    var snackBar = SnackBar(content: Text("Login: $message"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (message == "Success") {
      Provider.of<UserProvider>(context, listen: false).refreshUser();
      Navigator.push(context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Home()
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),
              const Text(style: TextStyle(fontFamily: "Billabong", fontSize: 50), "Holbegram"),
              Image.asset("assets/images/logo.webp", width: 80, height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    TextFieldInput(
                      controller: emailController,
                      isPassword: false,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 24),
                    TextFieldInput(
                      controller: passwordController,
                      isPassword: !_passwordVisible,
                      hintText: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        alignment: Alignment.center,
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(255, 228, 70, 50)
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        }
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(const Color.fromARGB(218, 226, 37, 24)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                        ),
                        onPressed: _tryLogin,
                        child: const Text("Log in", style: TextStyle(color: Colors.white))
                      )
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Forgot your login details? "),
                        Text("Get help loggging in", style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    Flexible(flex: 0, child: Container()),
                    const SizedBox(height: 24),
                    const Divider(thickness: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account"),
                          TextButton(
                            onPressed: _openSignUpPage,
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(218, 226, 37, 24)
                              )
                            )
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                    const Row(children: [
                      Flexible(child: Divider(thickness: 2)),
                      Text(" OR "),
                      Flexible(child: Divider(thickness: 2))
                    ]),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          width: 40,
                          height: 40,
                          "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png"
                        ),
                        const Text("Sign in with Google")
                      ],
                    )
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }
}
