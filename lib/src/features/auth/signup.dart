import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/src/features/auth/controller/signup_controller.dart';
import 'package:chat_app/src/features/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  late double height, width;

  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<SignupProvider>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            const Positioned(
              top: 40,
              left: 20,
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_left,
                    size: 30,
                    color: Color.fromARGB(255, 71, 26, 160),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Back",
                    style: TextStyle(
                      color: Color.fromARGB(255, 71, 26, 160),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: height * 0.24,
              left: width * 0.15,
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Color.fromARGB(255, 151, 71, 255),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildTextField(
                namecontroller, "User name", Icons.person_outline, 0.3),
            _buildTextField(
                emailcontroller, "Email", Icons.email_outlined, 0.4),
            _buildTextField(passwordcontroller, "Enter your password",
                Icons.lock_outline, 0.5,
                isPassword: true),
            _buildTextField(phonecontroller, "Enter Phone Number",
                Icons.phone_outlined, 0.6,
                isPhone: true),
            Positioned(
              top: height * 0.7,
              left: width * 0.15,
              child: SizedBox(
                height: height * 0.06,
                width: width * 0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 187, 132, 232),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 151, 71, 255),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (namecontroller.text.isEmpty ||
                        emailcontroller.text.isEmpty ||
                        passwordcontroller.text.isEmpty ||
                        phonecontroller.text.isEmpty) {
                      Flushbar(
                        message: "Please fill all fields",
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        messageColor: Colors.white,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        margin: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(8),
                      ).show(context);
                      return;
                    }

                    await signupProvider.signup(
                      context: context,
                      name: namecontroller.text.trim(),
                      email: emailcontroller.text.trim(),
                      password: passwordcontroller.text.trim(),
                      phone: phonecontroller.text.trim(),
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: height * 0.78,
              left: width * 0.15,
              child: const Text(
                "Already have an account",
                style: TextStyle(
                  color: Color.fromARGB(255, 151, 71, 255),
                  fontSize: 14,
                ),
              ),
            ),
            Positioned(
              top: height * 0.76,
              left: width * 0.59,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SigninScreen()),
                  );
                },
                child: const Text(
                  "Sign in",
                  style: TextStyle(
                    color: Color.fromARGB(255, 151, 71, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (signupProvider.isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon, double topFraction,
      {bool isPassword = false, bool isPhone = false}) {
    return Positioned(
      top: height * topFraction,
      left: width * 0.15,
      child: SizedBox(
        height: height * 0.07,
        width: width * 0.7,
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType:
              isPhone ? TextInputType.phone : TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 36,
              color: const Color.fromARGB(255, 151, 71, 255),
            ),
            hintText: hint,
            contentPadding: const EdgeInsets.all(8),
            suffixIcon:
                isPassword ? const Icon(Icons.visibility_outlined) : null,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 151, 71, 255),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 151, 71, 255),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
