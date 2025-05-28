import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GenerateMeetLinkScreen extends StatefulWidget {
  final Map<String, String> client;

  const GenerateMeetLinkScreen({super.key, required this.client});

  @override
  State<GenerateMeetLinkScreen> createState() => _GenerateMeetLinkScreenState();
}

class _GenerateMeetLinkScreenState extends State<GenerateMeetLinkScreen> {
  bool _isLoading = false;

  Future<void> _generateMeetLink() async {
    try {
      setState(() => _isLoading = true);

      final doctorId = FirebaseAuth.instance.currentUser?.uid;
      if (doctorId == null) throw Exception("Doctor not logged in");

      final String googleMeetLink = "https://meet.google.com/${DateTime.now().millisecondsSinceEpoch}";

      await FirebaseFirestore.instance.collection('meetingLinks').add({
        'clientName': widget.client['clientName'],
        'problemDescription': widget.client['problemDescription'],
        'paymentType': widget.client['paymentType'],
        'meetingDate': widget.client['meetingDate'],
        'selectedPeriod': widget.client['selectedPeriod'],
        'googleMeetLink': googleMeetLink,
        'doctorId': doctorId,
        'createdAt': Timestamp.now(),
      });

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('paidDemands')
          .where('clientName', isEqualTo: widget.client['clientName'])
          .where('problemDescription', isEqualTo: widget.client['problemDescription'])
          .where('paymentType', isEqualTo: widget.client['paymentType'])
          .where('meetingDate', isEqualTo: widget.client['meetingDate'])
          .where('selectedPeriod', isEqualTo: widget.client['selectedPeriod'])
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 48),
              const SizedBox(height: 12),
              const Text(
                "Success!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Google Meet link generated, saved, and paid demand removed.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF388E3C),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.client;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Generate Meet Link',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 6,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              color: Colors.white,
              shadowColor: Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📝 Client Demand Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow("👤 Client Name:", c['clientName']),
                    _buildInfoRow("🧠 Problem:", c['problemDescription']),
                    _buildInfoRow("💳 Payment Type:", c['paymentType']),
                    _buildInfoRow("📅 Meeting Date:", c['meetingDate']),
                    _buildInfoRow("⏰ Time Slot:", c['selectedPeriod']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _generateMeetLink,
                    icon: const Icon(Icons.video_call, color: Colors.white),
                    label: const Text("Generate Google Meet Link", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
