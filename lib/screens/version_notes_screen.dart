import 'package:flutter/material.dart';
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
        children: const [
          Card(child: Text('Version 1.0.0 - Initial version of the app.')),
        ],
      ),
    );
  }
}