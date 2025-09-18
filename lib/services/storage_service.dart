import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/content_item.dart';

class StorageService {
  static const String _kContentKey = 'app_content_items_v1';
  final Uuid _uuid = Uuid();

  Future<Directory> _appDocDir() async {
    return await getApplicationDocumentsDirectory();
  }

  Future<List<ContentItem>> loadAllContent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kContentKey);
    if (raw == null) return [];
    final list = json.decode(raw) as List;
    return list.map((m) => ContentItem.fromMap(Map<String, dynamic>.from(m))).toList();
  }

  Future<void> _saveAllContent(List<ContentItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((i) => i.toMap()).toList());
    await prefs.setString(_kContentKey, jsonString);
  }

  Future<ContentItem> saveContent(ContentItem item, {List<int>? imageBytes}) async {
    String? imagePath = item.imagePath;
    if (imageBytes != null) {
      final dir = await _appDocDir();
      final id = item.id.isNotEmpty ? item.id : _uuid.v4();
      final file = File('${dir.path}/image_$id.png');
      await file.writeAsBytes(imageBytes);
      imagePath = file.path;
    }

    final finalItem = ContentItem(
      id: item.id.isNotEmpty ? item.id : _uuid.v4(),
      title: item.title,
      description: item.description,
      targetModule: item.targetModule,
      imagePath: imagePath,
      createdAt: item.createdAt,
    );

    final current = await loadAllContent();
    current.add(finalItem);
    await _saveAllContent(current);
    return finalItem;
  }

  Future<void> updateContent(ContentItem updated) async {
    final current = await loadAllContent();
    final idx = current.indexWhere((i) => i.id == updated.id);
    if (idx != -1) {
      current[idx] = updated;
      await _saveAllContent(current);
    }
  }

  Future<void> deleteContent(String id) async {
    final current = await loadAllContent();
    final removed = current.where((i) => i.id == id).toList();
    for (final r in removed) {
      if (r.imagePath != null) {
        final f = File(r.imagePath!);
        if (await f.exists()) await f.delete();
      }
    }
    current.removeWhere((i) => i.id == id);
    await _saveAllContent(current);
  }
}
