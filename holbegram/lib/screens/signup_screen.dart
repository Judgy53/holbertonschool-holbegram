import 'package:flutter/material.dart';
import 'package:holbegram/screens/login_screen.dart';
import 'package:holbegram/screens/upload_image_screen.dart';
import 'package:holbegram/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  late bool _passwordVisible;
  late bool _passwordConfirmVisible;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _passwordVisible = false;
    _passwordConfirmVisible = false;
    super.initState();
  }

  void _openLoginPage() {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen()
      )
    );
  }

  void _openAddPicturePage() {
    if (passwordController.value != passwordConfirmController.value) {
      var snackBar = const SnackBar(content: Text("Password confirmation doesn't match"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    Navigator.push(context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddPicture(
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 28),
            const Text(style: TextStyle(fontFamily: "Billabong", fontSize: 50), "Holbegram"),
            Image.asset("assets/images/logo.webp", width: 80, height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(height: 28),
                const Text(
                  "Sign up to see photos and videos\nfrom your friends.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  )
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  controller: emailController,
                  isPassword: false,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 24),
                TextFieldInput(
                  controller: usernameController,
                  isPassword: false,
                  hintText: "Full Name",
                  keyboardType: TextInputType.name),
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
                  )
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  controller: passwordConfirmController,
                  isPassword: !_passwordConfirmVisible,
                  hintText: "Confirm Password",
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    alignment: Alignment.center,
                    icon: Icon(
                      _passwordConfirmVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(255, 228, 70, 50)
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordConfirmVisible = !_passwordConfirmVisible;
                      });
                    }
                  )
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
                    onPressed: _openAddPicturePage,
                    child: const Text("Sign up", style: TextStyle(color: Colors.white))
                  )
                ),
              ])
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 2),
            Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an account?"),
                TextButton(
                  onPressed: _openLoginPage,
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(218, 226, 37, 24)
                    )
                  )
                ),
                const SizedBox(height: 10)
              ],
            )),
          ],
        )
      )),
    );
  }
}
