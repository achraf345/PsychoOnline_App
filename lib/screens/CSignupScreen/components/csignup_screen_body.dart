import 'package:flutter/material.dart';
import 'package:awa/screens/CloginScreen/clogin_screen.dart';

class CSignupscreen extends StatelessWidget {
  const CSignupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CSignupscreenBody(),
      ),
    );
  }
}

class CSignupscreenBody extends StatefulWidget {
  const CSignupscreenBody({super.key});

  @override
  _CSignupscreenBodyState createState() => _CSignupscreenBodyState();
}

class _CSignupscreenBodyState extends State<CSignupscreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _formValid = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_checkForm);
    _lastNameController.addListener(_checkForm);
    _birthdayController.addListener(_checkForm);
    _cityController.addListener(_checkForm);
    _emailController.addListener(_checkForm);
    _passwordController.addListener(_checkForm);
    _confirmController.addListener(_checkForm);
  }

  void _checkForm() {
    final valid = _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _birthdayController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmController.text == _passwordController.text;
    if (_formValid != valid) {
      setState(() => _formValid = valid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt_1_rounded, size: 80, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              'Client Sign Up',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(controller: _firstNameController, label: 'First Name', icon: Icons.person),
                      const SizedBox(height: 16),
                      _buildField(controller: _lastNameController, label: 'Last Name', icon: Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildField(controller: _birthdayController, label: 'Birthday (dd/mm/yyyy)', icon: Icons.cake),
                      const SizedBox(height: 16),
                      _buildField(controller: _cityController, label: 'City', icon: Icons.location_city),
                      const SizedBox(height: 16),
                      _buildField(controller: _emailController, label: 'Email', icon: Icons.email, keyboard: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _passwordController,
                        label: 'Password',
                        obscure: _obscurePassword,
                        icon: Icons.lock,
                        toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _confirmController,
                        label: 'Confirm Password',
                        obscure: _obscureConfirm,
                        icon: Icons.lock_outline,
                        toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _formValid
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CLoginScreen()),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1565C0),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CLoginScreen()),
                        ),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Color.fromARGB(255, 64, 129, 204),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (val) => val == null || val.isEmpty ? '$label required' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required IconData icon,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (val) => val == null || val.isEmpty ? '$label required' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          color: const Color(0xFF1565C0),
          onPressed: toggle,
        ),
      ),
    );
  }
}
