import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awa/screens/DLoginScreen/dlogin_screen.dart';

class DsignupscreenBody extends StatefulWidget {
  const DsignupscreenBody({super.key});

  @override
  _DsignupscreenBodyState createState() => _DsignupscreenBodyState();
}

class _DsignupscreenBodyState extends State<DsignupscreenBody> {
  final _formKey = GlobalKey<FormState>();

  final _matriculeController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _experienceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  /// Calculate age in years from [birthDate].
  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB2F7EF), Color(0xFFE0FBE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  "Welcome, Doctor!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Create your professional profile",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade100,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_matriculeController, 'Matricule/ID'),
                        const SizedBox(height: 15),
                        _buildTextField(_fullNameController, 'Full Name'),
                        const SizedBox(height: 15),
                        _buildDatePickerField(context),
                        const SizedBox(height: 15),
                        _buildTextField(
                            _experienceController, 'Years of Experience'),
                        const SizedBox(height: 15),
                        _buildTextField(
                            _descriptionController, 'Description about yourself'),
                        const SizedBox(height: 15),
                        _buildEmailField(),
                        const SizedBox(height: 15),
                        _buildPasswordField(_passwordController, 'Password',
                            _obscurePassword, () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        }),
                        const SizedBox(height: 15),
                        _buildPasswordField(_confirmPasswordController,
                            'Confirm Password', _obscureConfirmPassword, () {
                          setState(() =>
                              _obscureConfirmPassword = !_obscureConfirmPassword);
                        }),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            // parse birthday text dd/mm/yyyy
                            final parts = _birthdayController.text.split('/');
                            final day = int.parse(parts[0]);
                            final month = int.parse(parts[1]);
                            final year = int.parse(parts[2]);
                            final birthDate =
                                DateTime(year, month, day);
                            final age = _calculateAge(birthDate);

                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );

                              await FirebaseFirestore.instance
                                  .collection('doctors')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'matricule':
                                    _matriculeController.text.trim(),
                                'fullName':
                                    _fullNameController.text.trim(),
                                'birthday':
                                    _birthdayController.text.trim(),
                                'age': age,  // ← newly added field
                                'experience':
                                    _experienceController.text.trim(),
                                'description':
                                    _descriptionController.text.trim(),
                                'email': _emailController.text.trim(),
                                'uid': userCredential.user!.uid,
                                'createdAt': Timestamp.now(),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Signup successful!')),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Dloginscreen(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        e.message ?? 'Signup failed')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10,
                          ),
                          child: const Text('Sign Up',
                              style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Dloginscreen()),
                            );
                          },
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
          TextEditingController controller, String label) =>
      TextFormField(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? '$label is required' : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: Colors.green.shade400, width: 2),
          ),
        ),
      );

  Widget _buildDatePickerField(BuildContext context) => TextFormField(
        controller: _birthdayController,
        readOnly: true,
        validator: (value) =>
            value == null || value.isEmpty ? 'Birthday is required' : null,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(1990),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (ctx, child) => Theme(
              data: Theme.of(ctx).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                dialogTheme:
                    const DialogThemeData(backgroundColor: Colors.white),
              ),
              child: child!,
            ),
          );

          if (pickedDate != null) {
            final formatted =
                '${pickedDate.day.toString().padLeft(2,'0')}/'
                '${pickedDate.month.toString().padLeft(2,'0')}/'
                '${pickedDate.year}';
            _birthdayController.text = formatted;
          }
        },
        decoration: InputDecoration(
          labelText: 'Birthday (dd/mm/yyyy)',
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: Colors.green.shade400, width: 2),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      );

  Widget _buildEmailField() => TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
              .hasMatch(value)) {
            return 'Enter a valid email';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Email',
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: Colors.green.shade400, width: 2),
          ),
        ),
      );

  Widget _buildPasswordField(
          TextEditingController controller,
          String label,
          bool obscure,
          VoidCallback toggle) =>
      TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          if (label == 'Confirm Password' &&
              value != _passwordController.text) {
            return "Passwords do not match";
          }
          if (label == 'Password' && value.length < 6) {
            return "Password must be at least 6 characters";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: Colors.green.shade400, width: 2),
          ),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      );
}
