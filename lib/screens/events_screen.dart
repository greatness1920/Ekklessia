import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/content_card.dart';
import 'events_detail_screen.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final items = state.itemsForModule('events');
      return Scaffold(
        appBar: AppBar(title: Text('Events')),
        body: RefreshIndicator(
          onRefresh: () async => await state.init(),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No events found. Admin can add events via Admin screen.'),
                ),
              ...items.map((it) => ContentCard(
                item: it,
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => EventDetailScreen(item: it))),
              )),
            ],
          ),
        ),
      );
    });
  }
}
