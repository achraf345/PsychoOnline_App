import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorForgotPasswordScreen extends StatefulWidget {
  const DoctorForgotPasswordScreen({super.key});

  @override
  State<DoctorForgotPasswordScreen> createState() =>
      _DoctorForgotPasswordScreenState();
}

class _DoctorForgotPasswordScreenState
    extends State<DoctorForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _nameController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _obscureNewPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(Icons.lock_reset_rounded,
                  size: 80, color: Colors.green.shade700),
              const SizedBox(height: 20),
              Text(
                'Reset Your Password',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 30),

              // Matricule/ID
              _buildTextField(
                controller: _matriculeController,
                label: 'Matricule/ID',
                icon: Icons.badge,
              ),
              const SizedBox(height: 20),

              // Full Name
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),

              // New Password
              _buildPasswordField(),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Add your reset-logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Password reset successfully!',
                              style: GoogleFonts.poppins())),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.check_circle_outline,
                    color: Colors.white),
                label: const Text('Reset Password',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.green.shade800),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: _obscureNewPassword,
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon:
            Icon(Icons.lock_outline, color: Colors.green.shade700),
        labelText: 'New Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.green.shade700,
          ),
          onPressed: () =>
              setState(() => _obscureNewPassword = !_obscureNewPassword),
        ),
      ),
    );
  }
}
