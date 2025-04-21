import 'package:awa/screens/PaymentSuccessScreen/paymentsuccessscreen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PaymentScreen extends StatelessWidget {
  final String paymentType;

  const PaymentScreen({super.key, required this.paymentType});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardNameController = TextEditingController();
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    // Automatically format the expiry date
    void onExpiryDateChanged(String value) {
      if (value.length == 2 && !value.contains('/')) {
        expiryDateController.text = '$value/';
        expiryDateController.selection = TextSelection.collapsed(offset: expiryDateController.text.length);
      } else if (value.length == 5 && value[2] != '/') {
        expiryDateController.text = '${value.substring(0, 2)}/${value.substring(3)}';
        expiryDateController.selection = TextSelection.collapsed(offset: expiryDateController.text.length);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Secure Payment'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFFB69DF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payment, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You selected: $paymentType',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // CARD FORM
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.shade100,
                    blurRadius: 10,
                    offset: const Offset(2, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    controller: cardNameController,
                    label: 'Cardholder Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: cardNumberController,
                    label: 'Card Number',
                    icon: Icons.credit_card,
                    inputType: TextInputType.number,
                    maxLength: 16,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: expiryDateController,
                          label: 'MM/YY',
                          icon: Icons.calendar_today_rounded,
                          inputType: TextInputType.number,
                          maxLength: 5,
                          onChanged: onExpiryDateChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          controller: cvvController,
                          label: 'CVV',
                          icon: LucideIcons.shieldCheck,
                          inputType: TextInputType.number,
                          maxLength: 3,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (cardNameController.text.isEmpty ||
                          cardNumberController.text.length != 16 ||
                          expiryDateController.text.length != 5 ||
                          cvvController.text.length != 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter valid card details')),
                        );
                        return;
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.lock_outline),
                    label: const Text('Pay Securely', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int? maxLength,
    bool obscureText = false,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
