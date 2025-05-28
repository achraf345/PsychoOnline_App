import 'package:awa/screens/PaymentScreen/components/payementscreen_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentClientScreenBody extends StatelessWidget {
  const PaymentClientScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final String? clientEmail = FirebaseAuth.instance.currentUser?.email;
    if (clientEmail == null) {
      return const Center(child: Text('Not authenticated'));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 135, 237),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Payment Process',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 88, 185, 255), Color.fromARGB(255, 4, 107, 192)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('validatedDemands')
              .where('clientEmail', isEqualTo: clientEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No validated demands yet.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }

            final demands = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: demands.length,
              itemBuilder: (context, index) {
                final data = demands[index].data() as Map<String, dynamic>;

                final doctorName = data['doctorName'] ?? 'Unknown';
                final problem = data['problemDescription'] ?? '';
                final paymentType = data['paymentType'] ?? '';
                final meetingDate = data['meetingDate'] != null
                    ? (data['meetingDate'] as Timestamp).toDate().toString().split(" ")[0]
                    : 'N/A';
                final timeSlot = data['selectedTimeSlot'] ?? '';
                final period = data['selectedPeriod'] ?? '';

                int amount = 0;
                if (paymentType == 'Meet Payment') {
                  amount = 30;
                } else if (paymentType == 'Full Payment') {
                  amount = 180;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    shadowColor: Colors.blueGrey.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. $doctorName',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _infoText("Problem", problem),
                          _infoText("Payment Type", paymentType),
                          _infoText("Meeting Date", meetingDate),
                          _infoText("Time", '$period - $timeSlot'),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _showPaymentConfirmationDialog(context, data, amount),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Proceed to Payment',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _infoText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '$title: $value',
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }

  void _showPaymentConfirmationDialog(BuildContext context, Map<String, dynamic> demandData, int amount) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFf3faff),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Proceed to Payment?',
            style: TextStyle(color: Color(0xFF0D47A1), fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Would you like to continue to payment for this demand? Amount: \$$amount',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Proceed', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentScreen(
                      demandData: demandData,
                      amount: amount, 
                      paymentType: 'Full Payment', 
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
