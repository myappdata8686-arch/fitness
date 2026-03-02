import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_data.dart';
import 'app_data_repository.dart';
import 'murshid_avatar_config.dart';
import 'murshid_service.dart';

class MurshidScreen extends StatefulWidget {
  const MurshidScreen({super.key});

  @override
  State<MurshidScreen> createState() => _MurshidScreenState();
}

class _MurshidScreenState extends State<MurshidScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  MurshidService? _service;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppData>();
    _service ??= MurshidService(repository: AppDataRepository(app));

    final avatar = avatarForPhase(app.journey.currentPhase);

    return Scaffold(
      appBar: AppBar(title: const Text('Murshid')),
      body: Column(
        children: [
          Container(
            height: 110,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white10,
              boxShadow: [BoxShadow(color: avatar.auraColor.withOpacity(0.45), blurRadius: 18)],
            ),
            child: Center(child: Text('Murshid • ${avatar.outfit}')),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: _messages.map((m) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(m))).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Ask Murshid...'),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    setState(() => _messages.add('You: $text'));
                    _controller.clear();
                    final response = await _service!.respond(text);
                    setState(() => _messages.add('Murshid: $response'));
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
