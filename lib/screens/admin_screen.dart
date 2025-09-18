import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../app_state.dart';
import '../models/content_item.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _targetModule = 'home';
  XFile? _pickedImage;

  final picker = ImagePicker();
  final uuid = Uuid();

  Future<void> _pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) setState(() => _pickedImage = file);
  }

  @override
  Widget build(BuildContext context) {
    final modules = [
      {'key': 'home', 'label': 'Home'},
      {'key': 'events', 'label': 'Events'},
      {'key': 'media', 'label': 'Media'},
      {'key': 'giving', 'label': 'Giving'},
      {'key': 'about', 'label': 'About Us'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Admin Upload')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _targetModule,
                items: modules
                    .map((m) => DropdownMenuItem(value: m['key'], child: Text(m['label']!)))
                    .toList(),
                onChanged: (v) => setState(() => _targetModule = v ?? 'home'),
                decoration: InputDecoration(labelText: 'Target Module'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.photo),
                    label: Text('Pick Image'),
                  ),
                  const SizedBox(width: 12),
                  if (_pickedImage != null) Text(File(_pickedImage!.path).uri.pathSegments.last),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Upload and Publish'),
              )
            ]),
          ),
          const SizedBox(height: 20),
          Divider(),
          const SizedBox(height: 8),
          Text('Existing Content', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Consumer<AppState>(builder: (context, state, _) {
            final items = state.items;
            if (items.isEmpty) return Text('No content yet.');
            return Column(
              children: items.map((it) {
                return ListTile(
                  leading: it.imagePath != null ? Image.file(File(it.imagePath!), width: 50, height: 50, fit: BoxFit.cover) : null,
                  title: Text(it.title),
                  subtitle: Text('${it.targetModule} • ${it.createdAt.toLocal()}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, it.id),
                  ),
                );
              }).toList(),
            );
          }),
        ]),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final id = uuid.v4();
    final item = ContentItem(
      id: id,
      title: title,
      description: desc,
      targetModule: _targetModule,
    );

    final bytes = _pickedImage != null ? await File(_pickedImage!.path).readAsBytes() : null;
    await Provider.of<AppState>(context, listen: false).addContent(item, imageBytes: bytes);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Content uploaded')));
    _titleCtrl.clear();
    _descCtrl.clear();
    setState(() {
      _pickedImage = null;
    });
  }

  void _confirmDelete(BuildContext ctx, String id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Delete'),
        content: Text('Delete this content?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          ElevatedButton(
              onPressed: () async {
                await Provider.of<AppState>(ctx, listen: false).removeContent(id);
                Navigator.pop(ctx);
              },
              child: Text('Delete')),
        ],
      ),
    );
  }
}
