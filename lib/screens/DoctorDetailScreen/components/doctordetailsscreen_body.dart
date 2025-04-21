import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awa/screens/PaymentScreen/components/payementscreen_body.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String doctorName;
  final int doctorAge;
  final int yearsOfExperience;
  final String description;

  const DoctorDetailScreen({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 249, 249),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5A8DEE), Color(0xFF906EF5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Doctor Details', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧑‍⚕️ Doctor Info Card
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEDEAFF), Color(0xFFDEE9FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.doctorName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('👨‍⚕️ Age: ${widget.doctorAge}'),
                  Text('🏆 Experience: ${widget.yearsOfExperience} years'),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 💬 Payment Explanation Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF0FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                '💳 Full Payment: Access to complete therapy services including multiple sessions and follow-ups.\n\n'
                '📅 Meet Payment: Access to a single introductory session with the doctor.',
                style: TextStyle(fontSize: 14, color: Color(0xFF333366)),
              ),
            ),
            const SizedBox(height: 30),

            // 🧠 Mental Health Description Field
            TextFormField(
              controller: _problemController,
              decoration: InputDecoration(
                labelText: 'Describe your mental health concern',
                labelStyle: const TextStyle(color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 30),

            // 📆 Date Picker
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Meeting Date',
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('yMMMMd').format(_selectedDate!)
                        : 'Tap to choose a date',
                    style: TextStyle(
                      color: _selectedDate != null ? Colors.black : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🟣 Payment Buttons
Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () => _submit('Full Payment'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF5A8DEE), // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF5A8DEE)),
          ),
          elevation: 3,
        ),
        child: const Text('Full Payment', style: TextStyle(fontSize: 16)),
      ),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: ElevatedButton(
        onPressed: () => _submit('Meet Payment'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: const Color(0xFFE0ECFF),
          foregroundColor: const Color(0xFF444C74),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        child: const Text('Meet Payment', style: TextStyle(fontSize: 16)),
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF5A8DEE),
            colorScheme: const ColorScheme.light(primary: Color(0xFF5A8DEE)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit(String paymentType) {
    if (_problemController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(paymentType: paymentType),
      ),
    );
  }
}
