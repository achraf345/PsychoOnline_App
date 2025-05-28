
import 'package:flutter/material.dart';
import 'components/generate_meet_link_screen_body.dart';

class Generatemeetlinkscreen extends StatelessWidget {
  const Generatemeetlinkscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generatemeetlinkscreen'),
      ),
      body: GenerateMeetLinkScreen(client: {},),
    );
  }
}
    