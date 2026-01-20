import 'package:flutter/material.dart';

class CallsTab extends StatelessWidget {
  const CallsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = [
      {'name': 'Robert Fox', 'time': '18.09.2022 от 19:30', 'type': 'incoming'},
      {'name': 'Robert Fox', 'time': '18.09.2022 от 19:30', 'type': 'outgoing'},
      {'name': 'Robert Fox', 'time': '18.09.2022 от 19:30', 'type': 'incoming'},
      {'name': 'Robert Fox', 'time': '18.09.2022 от 19:30', 'type': 'incoming'},
      {'name': 'Annette Black', 'time': '18.09.2022 от 19:30', 'type': 'missed'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Звонки'),
      ),
      body: ListView.builder(
        itemCount: calls.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final call = calls[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(call['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(
                call['time']!,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              trailing: const Icon(Icons.call_outlined, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
