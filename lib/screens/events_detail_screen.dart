import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../widgets/content_card.dart';

class EventDetailScreen extends StatelessWidget {
  final ContentItem item;
  const EventDetailScreen({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ContentCard(item: item),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              // For demo: pretend to register
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered (demo)')));
            },
            icon: Icon(Icons.check),
            label: Text('Register'),
          )
        ],
      ),
    );
  }
}
