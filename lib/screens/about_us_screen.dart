import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/content_card.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final items = state.itemsForModule('about');
      return Scaffold(
        appBar: AppBar(title: Text('About Us')),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Our Story', style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: 8),
            ...items.map((it) => ContentCard(item: it)),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No about content yet. Add a timeline or leadership profile via Admin.'),
              ),
          ],
        ),
      );
    });
  }
}
