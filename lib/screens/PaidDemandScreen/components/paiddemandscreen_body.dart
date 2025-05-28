import 'package:awa/screens/GenerateMeetlinksScreen/components/generate_meet_link_screen_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaidDemandScreenBody extends StatelessWidget {
  final String doctorName;
  const PaidDemandScreenBody({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('paidDemands')
            .where('doctorName', isEqualTo: doctorName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF388E3C)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud_off, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No paid demands yet.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            );
          }

          final demands = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 24),
            itemCount: demands.length,
            itemBuilder: (context, index) {
              final demand = demands[index];
              final clientFirstName = demand['clientFirstName'] ?? '';
              final clientLastName = demand['clientLastName'] ?? '';
              final amountPaid = demand['amountPaid'] ?? 0;
              final paymentType = demand['paymentType'] ?? '';
              final meetingDate =
                  (demand['meetingDate'] as Timestamp).toDate();
              final selectedPeriod = demand['selectedPeriod'] ?? '';
              final problemDescription = demand['problemDescription'] ?? '';
              final formattedDate =
                  DateFormat('MMMM dd, yyyy').format(meetingDate);

              return AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 600),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateMeetLinkScreen(
                          client: {
                            'clientName': '$clientFirstName $clientLastName',
                            'problemDescription': problemDescription,
                            'paymentType': paymentType,
                            'meetingDate': formattedDate,
                            'selectedPeriod': selectedPeriod,
                          },
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'card_$index',
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.green.shade200,
                                child: const Icon(Icons.person,
                                    color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '$clientFirstName $clientLastName',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF388E3C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(Icons.psychology_alt, "Problem",
                              problemDescription),
                          _buildDetailRow(Icons.payment, "Payment Type",
                              paymentType),
                          _buildDetailRow(Icons.attach_money, "Amount Paid",
                              '\$$amountPaid'),
                          _buildDetailRow(Icons.calendar_today, "Meeting Date",
                              formattedDate),
                          _buildDetailRow(Icons.schedule, "Time Period",
                              selectedPeriod),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Color(0xFF388E3C)),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF388E3C),
              fontSize: 15,
              fontFamily: 'Roboto',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.green.shade300,
          width: 1.2,
        ),
      ),
      child: child,
    );
  }
}
