import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _isLoading = false;

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
        _passwordController.text.length >= 6 &&
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
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
                      _buildDatePickerField(context, _birthdayController, 'Birthday', Icons.cake),
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
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _formValid ? _handleSignup : null,
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
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CLoginScreen())),
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

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await FirebaseFirestore.instance.collection('clients').doc(userCredential.user!.uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'birthday': _birthdayController.text.trim(),
          'city': _cityController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signup successful!")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CLoginScreen()));
      } on FirebaseAuthException catch (e) {
        String errorMsg = 'Signup failed';
        if (e.code == 'email-already-in-use') {
          errorMsg = 'This email is already in use.';
        } else if (e.code == 'weak-password') {
          errorMsg = 'The password is too weak.';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
      } finally {
        setState(() => _isLoading = false);
      }
    }
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

  Widget _buildDatePickerField(
    BuildContext context,
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
          controller.text = formattedDate;
        }
      },
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
      validator: (val) {
        if (val == null || val.isEmpty) return '$label required';
        if (label == 'Password' && val.length < 6) return 'Password must be at least 6 characters';
        if (label == 'Confirm Password' && val != _passwordController.text) return 'Passwords do not match';
        return null;
      },
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
