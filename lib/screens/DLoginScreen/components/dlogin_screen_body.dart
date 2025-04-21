import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awa/screens/DoctorDashboardScreen/components/doctordashboardscreen_body.dart';
import 'package:awa/screens/DSignupScreen/dsignu_screen.dart';
import 'package:awa/screens/DoctorForgotPasswordScreen/doctorforgotpasswordscreen.dart';

class DloginscreenBody extends StatefulWidget {
  const DloginscreenBody({super.key});

  @override
  _DloginscreenBodyState createState() => _DloginscreenBodyState();
}

class _DloginscreenBodyState extends State<DloginscreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        elevation: 0,
        title: Text(
          'Doctor Login',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: const Icon(Icons.psychology_rounded, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade200, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.psychology_rounded,
                    size: 90, color: Colors.green.shade800),
                const SizedBox(height: 20),
                Text(
                  'Welcome Doctor, please login to continue',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Matricule / ID
                _buildTextField(
                  controller: _matriculeController,
                  label: 'Matricule/ID',
                  icon: Icons.badge,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Matricule/ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Full Name
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DoctorForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Login Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _isLoading = true);
                            Future.delayed(const Duration(seconds: 1), () {
                              setState(() => _isLoading = false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DoctorDashboardScreen(),
                                ),
                              );
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('Login',
                            style: TextStyle(fontSize: 16)),
                      ),
                const SizedBox(height: 20),

                // Sign Up Link
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Dsignupscreen()),
                    );
                  },
                  child: Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required FormFieldValidator<String> validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green.shade700),
          labelText: label,
          labelStyle: TextStyle(color: Colors.green.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required FormFieldValidator<String> validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: _obscurePassword,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.lock_outline, color: Colors.green.shade700),
          labelText: label,
          labelStyle: TextStyle(color: Colors.green.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.green.shade700,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
    );
  }
}
