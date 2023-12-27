import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? timestamp;
  const MyListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(title),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              if (timestamp != null) ...[
                Text(
                  timestamp.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
