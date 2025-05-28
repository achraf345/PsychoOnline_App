import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsScreenBody extends StatelessWidget {
  const TermsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFAFAFA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); 
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black, 
                        size: 28,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Terms & Conditions",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black, 
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildSection(
                      title: "1. Booking Process",
                      content: [
                        "Select a psychologist from the list.",
                        "Choose Full Payment or Meet Payment.",
                        "Describe your mental health problem honestly.",
                        "Select your preferred meeting date.",
                        "Wait for validation and meeting time assignment.",
                        "Receive a confirmation email with session details and Google Meet link.",
                      ],
                    ),
                    _buildSection(
                      title: "2. Payment Terms",
                      content: [
                        "Full Payment: Access to multiple follow-up sessions.",
                        "Meet Payment: One-time session only.",
                        "Payments must be made before session validation.",
                        "Secure and encrypted payment gateways are used.",
                      ],
                    ),
                    _buildSection(
                      title: "3. Session Guidelines",
                      content: [
                        "Be on time. Lateness reduces your session time.",
                        "All sessions are held on Google Meet.",
                        "Ensure a quiet, private environment during the session.",
                        "Recording or sharing sessions is strictly forbidden.",
                        "Misconduct leads to account deactivation.",
                      ],
                    ),
                    _buildSection(
                      title: "4. Responsibilities",
                      content: [
                        "Clients must provide honest information and follow ethical conduct.",
                        "Psychologists are committed to ethical, timely, and private care.",
                        "Both parties must respect confidentiality and communication protocols.",
                      ],
                    ),
                    _buildSection(
                      title: "5. Cancellations & Refunds",
                      content: [
                        "Cancel at least 24 hours in advance to be eligible for a refund.",
                        "No refunds for late cancellations or no-shows.",
                        "In case of psychologist cancellation, refund or reschedule will be offered.",
                      ],
                    ),
                    _buildSection(
                      title: "6. Platform Rules",
                      content: [
                        "Use the platform responsibly and ethically.",
                        "This is not an emergency service platform.",
                        "Any form of harassment or rule violation will lead to permanent ban.",
                        "Terms may be updated, and users will be informed.",
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Thanks for helping us build a safe, respectful community.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.blueGrey.shade700,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<String> content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 12),
          ...content.map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "• $line",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
