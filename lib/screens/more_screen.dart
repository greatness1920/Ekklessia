import 'package:flutter/material.dart';
import 'about_us_screen.dart';
import 'admin_screen.dart';

class MoreScreen extends StatelessWidget {
  // Admin is hidden behind a passcode to simulate admin-only access
  static const String adminPasscode = '1234';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          ListTile(
            title: Text('About Us'),
            subtitle: Text('Church history, leadership & service times'),
            leading: Icon(Icons.info),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUsScreen())),
          ),
          ListTile(
            title: Text('Settings & Profile'),
            leading: Icon(Icons.settings),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Settings (demo)')));
            },
          ),
          ListTile(
            title: Text('Admin (hidden)'),
            subtitle: Text('Tap and enter passcode'),
            leading: Icon(Icons.lock),
            onTap: () => _openAdmin(context),
          ),
        ],
      ),
    );
  }

  void _openAdmin(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Admin Passcode'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter passcode'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  final value = controller.text.trim();
                  Navigator.pop(context);
                  if (value == adminPasscode) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminScreen()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong passcode')));
                  }
                },
                child: Text('Enter')),
          ],
        );
      },
    );
  }
}
