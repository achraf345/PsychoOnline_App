import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awa/screens/CloginScreen/clogin_screen.dart';
import 'package:awa/screens/DLoginScreen/dlogin_screen.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: const HomescreenBody(),
    );
  }
}

class HomescreenBody extends StatelessWidget {
  const HomescreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Title
            Text(
              'PsychOnline',
              style: GoogleFonts.poppins(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E7D7E),
              ),
            ),
            const SizedBox(height: 12),
            // App Description
            Text(
              'Your mental wellness journey starts here.\nBook therapy, attend video sessions,\nand connect with professionals — anytime, anywhere.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            // Client Space
            _buildRoleCard(
              context,
              label: 'Client Space',
              gradientColors: [Color(0xFF74EBD5), Color(0xFF9FACE6)],
              icon: Icons.self_improvement_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CLoginScreen()),
              ),
            ),
            const SizedBox(height: 28),
            // Doctor Space
            _buildRoleCard(
              context,
              label: 'Doctor Space',
              gradientColors: [Color(0xFF76D9A1), Color(0xFF56BBAF)],
              icon: Icons.psychology_alt_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dloginscreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String label,
    required List<Color> gradientColors,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 140,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
