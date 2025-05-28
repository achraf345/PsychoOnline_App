import 'package:awa/screens/PaymentSuccessScreen/paymentsuccessscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String doctorEmail;
  final String doctorName;
  final int doctorAge;
  final int yearsOfExperience;
  final String description;

  const DoctorDetailScreen({
    super.key,
    required this.doctorEmail,
    required this.doctorName,
    required this.doctorAge,
    required this.yearsOfExperience,
    required this.description,
  });

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final TextEditingController _problemController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF5A8DEE),
        title: const Text(
          'Client Request',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF5A8DEE)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEDEAFF), Color(0xFFDEE9FF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.doctorName,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Age: ${widget.doctorAge}'),
                        Text('Experience: ${widget.yearsOfExperience} years'),
                        const SizedBox(height: 12),
                        Text(widget.description, style: TextStyle(color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF0FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '💳 Full Payment: Multiple sessions & follow-ups\n\n'
                      '📅 Meet Payment: Single introductory session',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _problemController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Describe your concern',
                      labelStyle: const TextStyle(color: Colors.deepPurple),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Meeting Date',
                        labelStyle: const TextStyle(color: Colors.deepPurple),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat.yMMMMd().format(_selectedDate!)
                              : 'Tap to choose a date',
                          style: TextStyle(
                            color: _selectedDate != null ? Colors.black : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _submit('Full Payment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF5A8DEE),
                            side: const BorderSide(color: Color(0xFF5A8DEE)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 3,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Full Payment'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _submit('Meet Payment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0ECFF),
                            foregroundColor: const Color(0xFF444C74),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 3,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Meet Payment'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF5A8DEE)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit(String paymentType) async {
    if (_problemController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please complete all fields')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final client = FirebaseAuth.instance.currentUser;
      if (client == null) throw Exception('Not signed in');

      final snap = await FirebaseFirestore.instance
          .collection('clients')
          .doc(client.uid)
          .get();

      if (!snap.exists) {
        throw Exception('Client data not found');
      }

      final data = snap.data()!;

      await FirebaseFirestore.instance.collection('demands').add({
        'clientEmail':        client.email,
        'clientFirstName':    data['firstName'],
        'clientLastName':     data['lastName'],
        'doctorEmail':        widget.doctorEmail,
        'doctorName':         widget.doctorName,
        'doctorAge':          widget.doctorAge,
        'doctorExperience':   widget.yearsOfExperience,
        'doctorDescription':  widget.description,
        'problemDescription': _problemController.text.trim(),
        'meetingDate':        _selectedDate,
        'paymentType':        paymentType,
        'createdAt':          FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(paymentType: paymentType),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
