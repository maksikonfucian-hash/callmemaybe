import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:core/core.dart';
import 'package:contacts/contacts.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  void _showContactMenu(User user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Позвонить'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Navigate to active call screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${user.name}')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Удалить из друзей'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmation(user);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Вы уверены, что хотите удалить ${user.name}?'),
          content: const Text('Это действие нельзя отменить.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Remove from list
                final provider = context.read<ContactsProvider>();
                provider.removeContact(user);
                // Show banner
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${user.name} удалён(а) из списка друзей'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('Удалить'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    // Load contacts on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactsProvider>().loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        if (provider.contacts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Начните с приглашения друзей',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'После добавления друзей можно звонить и общаться без ограничений.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Share.share(
                      'Присоединяйся к Call Me Maybe! Скачай приложение: [ссылка на скачивание]',
                      subject: 'Приглашение в Call Me Maybe',
                    );
                  },
                  child: const Text('Пригласить друзей'),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Друзья'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // TODO: Add friend
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add friend')),
                  );
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: provider.contacts.length,
            itemBuilder: (context, index) {
              final user = provider.contacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                  child: user.photoUrl == null ? Text(user.name[0]) : null,
                ),
                title: Text(user.name),
                subtitle: Text(user.isOnline ? 'Online' : 'Offline'),
                trailing: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () => _showContactMenu(user),
                ),
                onTap: () => _showContactMenu(user),
              );
            },
          ),
        );
      },
    );
  }
}