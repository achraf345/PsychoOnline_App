import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AcceptClientScreenBody extends StatefulWidget {
  final Map<String, dynamic> clientData;
  final String docId;

  const AcceptClientScreenBody({
    super.key,
    required this.clientData,
    required this.docId,
  });

  @override
  State<AcceptClientScreenBody> createState() => _AcceptClientScreenBodyState();
}

class _AcceptClientScreenBodyState extends State<AcceptClientScreenBody> {
  bool isLoading = false;
  String? selectedPeriod;
  String? selectedTimeSlot;

  Future<void> _validateAndPushData() async {
    if (selectedPeriod == null || selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both period and time slot.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ignore: unused_local_variable
      final validatedDemandRef = await FirebaseFirestore.instance.collection('validatedDemands').add({
        'clientFirstName': widget.clientData['clientFirstName'] ?? '',
        'clientLastName': widget.clientData['clientLastName'] ?? '',
        'clientEmail': widget.clientData['clientEmail'] ?? '',
        'doctorId': widget.clientData['doctorId'] ?? '',
        'doctorName': widget.clientData['doctorName'] ?? '',
        'problemDescription': widget.clientData['problemDescription'] ?? '',
        'paymentType': widget.clientData['paymentType'] ?? '',
        'meetingDate': widget.clientData['meetingDate'],
        'selectedPeriod': selectedPeriod,
        'selectedTimeSlot': selectedTimeSlot,
        'validatedBy': widget.clientData['doctorId'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('messages').add({
        'clientEmail': widget.clientData['clientEmail'] ?? '',
        'title': 'Demand Validated',
        'message': 'Dear ${widget.clientData['clientFirstName'] ?? ''} ${widget.clientData['clientLastName'] ?? ''}, your demand has been validated by Dr. ${widget.clientData['doctorName'] ?? ''}.\\n'
            'Problem Description: ${widget.clientData['problemDescription'] ?? ''}\\n'
            'Payment Type: ${widget.clientData['paymentType'] ?? ''}\\n'
            'Meeting Date: ${widget.clientData['meetingDate'] != null ? (widget.clientData['meetingDate'] as Timestamp).toDate().toString().split(" ")[0] : 'N/A'}\\n'
            'Meeting Period: $selectedPeriod\\n'
            'Meeting Time Slot: $selectedTimeSlot',
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
      await FirebaseFirestore.instance
          .collection('demands')
          .doc(widget.docId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session validated, pushed & removed successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildChoiceChip(String label, String? selected, void Function() onTap) {
    final bool isSelected = selected == label;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[700] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.shade700, width: 1.5),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.green[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = widget.clientData;
    final clientName = '${client['clientFirstName'] ?? ''} ${client['clientLastName'] ?? ''}';
    final clientEmail = client['clientEmail'] ?? 'N/A';
    final payment = client['paymentType'] ?? 'N/A';
    final description = client['problemDescription'] ?? '';
    final doctor = client['doctorName'] ?? '';

    String meetingDateFormatted = 'N/A';
    if (client['meetingDate'] is Timestamp) {
      final meetingDate = (client['meetingDate'] as Timestamp).toDate();
      meetingDateFormatted = DateFormat('yyyy-MM-dd').format(meetingDate);
    }

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              elevation: 6,
              shadowColor: Colors.green.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.green, size: 28),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Client: $clientName',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(clientEmail, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.local_hospital, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Doctor: $doctor', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.payment, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Payment: $payment', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Meeting: $meetingDateFormatted',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Description:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    Text(description, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select Meeting Period:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: [
                _buildChoiceChip('Morning', selectedPeriod, () {
                  setState(() => selectedPeriod = 'Morning');
                }),
                _buildChoiceChip('Evening', selectedPeriod, () {
                  setState(() => selectedPeriod = 'Evening');
                }),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Select Time Slot:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: [
                _buildChoiceChip('8:00 - 9:00', selectedTimeSlot, () {
                  setState(() => selectedTimeSlot = '8:00 - 9:00');
                }),
                _buildChoiceChip('9:00 - 10:00', selectedTimeSlot, () {
                  setState(() => selectedTimeSlot = '9:00 - 10:00');
                }),
                _buildChoiceChip('10:00 - 11:00', selectedTimeSlot, () {
                  setState(() => selectedTimeSlot = '10:00 - 11:00');
                }),
                _buildChoiceChip('11:00 - 12:00', selectedTimeSlot, () {
                  setState(() => selectedTimeSlot = '11:00 - 12:00');
                }),
                _buildChoiceChip('14:00 - 15:00', selectedTimeSlot, () {
                  setState(() => selectedTimeSlot = '14:00 - 15:00');
                }),
                _buildChoiceChip('15:00 - 16:00', selectedTimeSlot, () {
                  setState(() => selectedTimeSlot = '15:00 - 16:00');
                }),
                _buildChoiceChip('16:00 - 17:00', selectedTimeSlot, () {
                  setState(() => selectedTimeSlot = '16:00 - 17:00');
                }),
                _buildChoiceChip('17:00 - 18:00', selectedTimeSlot, () {
                  setState(() => selectedTimeSlot = '17:00 - 18:00');
                }),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _validateAndPushData,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Validate & Push',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}