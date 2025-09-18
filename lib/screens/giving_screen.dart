import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/content_card.dart';

class GivingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final items = state.itemsForModule('giving');
      return Scaffold(
        appBar: AppBar(title: Text('Giving')),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Give', style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No donation options configured. Add via Admin screen.'),
              ),
            ...items.map((it) => ContentCard(item: it)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () {
                  // demo payment flow stub
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open payment (demo)')));
                },
                child: Text('Give Now (demo)'),
              ),
            )
          ],
        ),
      );
    });
  }
}
