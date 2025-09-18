import 'dart:io';
import 'package:flutter/material.dart';
import '../models/content_item.dart';

class SermonPlayerScreen extends StatelessWidget {
  final ContentItem item;
  const SermonPlayerScreen({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hasImage = item.imagePath != null;
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (hasImage)
            Image.file(File(item.imagePath!)),
          const SizedBox(height: 12),
          Text(item.description),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // demo: simulate download or play audio
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Play/download (demo)')));
            },
            icon: Icon(Icons.play_arrow),
            label: Text('Play'),
          )
        ],
      ),
    );
  }
}
