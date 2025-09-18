import 'package:flutter/foundation.dart';
import 'models/content_item.dart';
import 'services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<ContentItem> items = [];

  // call once at startup
  Future<void> init() async {
    items = await _storage.loadAllContent();
    notifyListeners();
  }

  List<ContentItem> itemsForModule(String moduleKey) {
    return items.where((it) => it.targetModule == moduleKey).toList();
  }

  Future<void> addContent(ContentItem item, {List<int>? imageBytes}) async {
    // StorageService will save the image (if provided) and return updated item with imagePath
    final saved = await _storage.saveContent(item, imageBytes: imageBytes);
    items.add(saved);
    notifyListeners();
  }

  Future<void> updateContent(ContentItem updated) async {
    await _storage.updateContent(updated);
    final idx = items.indexWhere((i) => i.id == updated.id);
    if (idx != -1) items[idx] = updated;
    notifyListeners();
  }

  Future<void> removeContent(String id) async {
    await _storage.deleteContent(id);
    items.removeWhere((i) => i.id == id);
    notifyListeners();
  }
}
