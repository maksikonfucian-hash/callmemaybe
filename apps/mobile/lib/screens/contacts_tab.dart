import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/core.dart';
import 'package:contacts/contacts.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
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

        return Scaffold(
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
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    // TODO: Start call
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Call ${user.name}')),
                    );
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Show add contact dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add friend')),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}