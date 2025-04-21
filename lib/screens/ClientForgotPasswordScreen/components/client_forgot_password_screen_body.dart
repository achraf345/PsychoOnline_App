import 'package:flutter/material.dart';

class ClientForgotPasswordScreen extends StatefulWidget {
  const ClientForgotPasswordScreen({super.key});

  @override
  State<ClientForgotPasswordScreen> createState() =>
      _ClientForgotPasswordScreenState();
}

class _ClientForgotPasswordScreenState
    extends State<ClientForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      size: 80,
                      color: Color(0xFF1565C0),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Reset Your Password",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    _buildField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Email is required";
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // First Name
                    _buildField(
                      controller: _firstNameController,
                      label: "First Name",
                      icon: Icons.person,
                      validator: (v) =>
                          v == null || v.isEmpty ? "First name is required" : null,
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    _buildField(
                      controller: _lastNameController,
                      label: "Last Name",
                      icon: Icons.person_outline,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Last name is required" : null,
                    ),
                    const SizedBox(height: 16),

                    // New Password
                    _buildPasswordField(
                      controller: _newPasswordController,
                      label: "New Password",
                      obscure: _obscureNew,
                      toggle: () => setState(() => _obscureNew = !_obscureNew),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Password required";
                        if (v.length < 6) return "Min 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      obscure: _obscureConfirm,
                      toggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Confirm your password";
                        if (v != _newPasswordController.text) return "Passwords do not match";
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password reset successfully!"),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: const Text(
                        "Reset Password",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: const Color(0xFF1565C0)),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: IconButton(
          icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF1565C0)),
          onPressed: toggle,
        ),
      ),
    );
  }
}
