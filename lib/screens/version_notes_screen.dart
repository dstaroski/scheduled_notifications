import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scheduled_notifications/menu/custom_drawer.dart';

class VersionNotes extends StatefulWidget {
  const VersionNotes({super.key});

  @override
  State<VersionNotes> createState() => _VersionNotesState();
}

class _VersionNotesState extends State<VersionNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Version Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF55982F), Color(0xFF2E5919)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const CustomDrawer(selectedIndex: 1),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Lottie.asset('assets/animations/coding.json'),
          ),
          const Card(child: Text('Version 1.0.2 - Added some animations, improved project structure,'
            ' and added a description field for notifications.')),
          const Card(child: Text('Version 1.0.1 - Fixed a rendering warning in the drawer menu.')),
          const Card(child: Text('Version 1.0.0 - Initial version of the app.')),
        ],
      ),
    );
  }
}