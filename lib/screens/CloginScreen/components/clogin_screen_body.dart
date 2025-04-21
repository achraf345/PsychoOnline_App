import 'package:awa/screens/CDashbordScreen/clientdashbord.dart';
import 'package:awa/screens/CSignupScreen/csignup_screen.dart';
import 'package:awa/screens/ClientForgotPasswordScreen/components/client_forgot_password_screen_body.dart';
import 'package:flutter/material.dart';

class CLoginScreenBody extends StatefulWidget {
  const CLoginScreenBody({super.key});

  @override
  _CLoginScreenBodyState createState() => _CLoginScreenBodyState();
}

class _CLoginScreenBodyState extends State<CLoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _formValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;

    if (_formValid != isValid) {
      setState(() {
        _formValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF42A5F5),
            Color(0xFFB3E5FC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'Client Space',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                shadowColor: Colors.black.withOpacity(0.5),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField(
                          _emailController,
                          "Email",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        buildPasswordField(
                          controller: _passwordController,
                          label: "Password",
                          obscure: _obscurePassword,
                          toggle: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        // 🔐 Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ClientForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _formValid
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Cdashbordscreen()),
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _formValid ? Colors.blueAccent : Colors.grey,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CSignupscreen()),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: "Sign up",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 28, 110, 224),
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) return '$label is required';
        if (label == "Email" &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) =>
          value == null || value.isEmpty ? '$label is required' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
          color: Colors.black87,
        ),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
