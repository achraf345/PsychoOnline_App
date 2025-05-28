import 'package:awa/screens/PaymentDoneScreen/components/paymentonescreen_body.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> demandData;
  final int amount;
  final String paymentType;

  const PaymentScreen({
    required this.demandData,
    required this.amount,
    required this.paymentType,
    super.key,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final cardholderController = TextEditingController();
  bool isProcessing = false;

  bool _validateFields() {
    String cardNumber = cardNumberController.text.trim();
    String expiry = expiryController.text.trim();
    String cvv = cvvController.text.trim();

    if (cardholderController.text.trim().isEmpty) {
      _showError("Cardholder name is required.");
      return false;
    }

    if (cardNumber.length != 16 || int.tryParse(cardNumber) == null) {
      _showError("Card number must be 16 digits.");
      return false;
    }

    if (cvv.length != 3 || int.tryParse(cvv) == null) {
      _showError("CVV must be 3 digits.");
      return false;
    }

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) {
      _showError("Expiry must be in MM/YY format.");
      return false;
    }

    int expMonth = int.parse(expiry.split('/')[0]);
    int expYear = int.parse(expiry.split('/')[1]) + 2000;

    if (expMonth < 1 || expMonth > 12) {
      _showError("Invalid expiry month.");
      return false;
    }

    DateTime now = DateTime.now();
    DateTime expiryDate = DateTime(expYear, expMonth + 1);

    if (expiryDate.isBefore(now)) {
      _showError("Card is expired.");
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void handlePayment() async {
    if (!_validateFields()) return;

    setState(() => isProcessing = true);

    try {
      final demandData = widget.demandData;

      // Save to paidDemands
      await FirebaseFirestore.instance.collection('paidDemands').add({
        ...demandData,
        'amountPaid': widget.amount,
        'paymentType': widget.paymentType,
        'paymentDate': DateTime.now(),
        'paymentStatus': 'Completed',
      });

      // Delete from validatedDemands
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('validatedDemands')
          .where('doctorEmail', isEqualTo: demandData['doctorEmail'])
          .where('clientEmail', isEqualTo: demandData['clientEmail'])
          .where('meetingDate', isEqualTo: demandData['meetingDate'])
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() => isProcessing = false);

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentDoneScreen(amount: widget.amount),
        ),
      );
    } catch (e) {
      setState(() => isProcessing = false);
      _showError('Payment Failed: ${e.toString()}');
    }
  }

  Widget _buildInputField(
    IconData icon,
    String hint,
    TextEditingController controller,
    TextInputType keyboardType, {
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      obscureText: hint == "CVV",
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        counterText: "",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F51B5),
        elevation: 0,
        title: const Text("Secure Payment", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    "You selected: ${widget.paymentType}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Amount to Pay: \$${widget.amount}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(Icons.person, "Cardholder Name", cardholderController, TextInputType.text),
                  const SizedBox(height: 15),
                  _buildInputField(Icons.credit_card, "Card Number", cardNumberController, TextInputType.number, maxLength: 16),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(Icons.calendar_today, "MM/YY", expiryController, TextInputType.number, maxLength: 5),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(Icons.lock, "CVV", cvvController, TextInputType.number, maxLength: 3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  isProcessing
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F51B5),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: handlePayment,
                          child: const Text("Pay Now", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
