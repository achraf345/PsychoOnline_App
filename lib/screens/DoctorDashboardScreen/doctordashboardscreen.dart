import 'package:flutter/material.dart';
// ignore: unused_import
import 'components/doctordashboardscreen_body.dart';

class DoctorDashboardScreen extends StatelessWidget {
  final String doctorEmail; // Save doctorEmail properly

  const DoctorDashboardScreen({
    super.key,
    required this.doctorEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
      ),
      body: DoctorDashboardScreenBody(doctorEmail: doctorEmail), // Pass it
    );
  }
}
