import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String id;
  final String name;
  final String email;

  const UserCard({super.key, required this.id, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(email),
      ),
    );
  }
}
