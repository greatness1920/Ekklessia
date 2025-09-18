import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/content_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final items = state.itemsForModule('home');
      return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: RefreshIndicator(
          onRefresh: () async => await state.init(),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Welcome', style: Theme.of(context).textTheme.headlineSmall),
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No home content yet. Upload content from the More > Admin screen.'),
                ),
              ...items.map((it) => ContentCard(item: it)),
            ],
          ),
        ),
      );
    });
  }
}
