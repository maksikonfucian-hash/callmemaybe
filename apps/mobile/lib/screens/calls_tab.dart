import 'package:flutter/material.dart';

/// Tab for call history.
class CallsTab extends StatelessWidget {
  const CallsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final calls = [
      {'name': 'Alice', 'time': '15.01.2024 в 14:30', 'type': 'incoming'},
      {'name': 'Bob', 'time': '14.01.2024 в 10:15', 'type': 'outgoing'},
      {'name': 'Charlie', 'time': '13.01.2024 в 16:45', 'type': 'missed'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Звонки'),
      ),
      body: ListView.builder(
        itemCount: calls.length,
        itemBuilder: (context, index) {
          final call = calls[index];
          final name = call['name']!;
          final time = call['time']!;
          final type = call['type']!;

          IconData typeIcon;
          switch (type) {
            case 'incoming':
              typeIcon = Icons.call_received;
              break;
            case 'outgoing':
              typeIcon = Icons.call_made;
              break;
            case 'missed':
              typeIcon = Icons.call_missed;
              break;
            default:
              typeIcon = Icons.call;
          }

          return ListTile(
            leading: CircleAvatar(
              child: Text(name[0]),
            ),
            title: Text(name),
            subtitle: Row(
              children: [
                Icon(typeIcon, size: 16),
                const SizedBox(width: 4),
                Text(time),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                // Immediate call
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling $name')),
                );
              },
            ),
            onTap: () {
              // Repeat call
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Repeat call to $name')),
              );
            },
          );
        },
      ),
    );
  }
}