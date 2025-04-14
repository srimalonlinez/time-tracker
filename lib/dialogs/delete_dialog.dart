import 'package:flutter/material.dart';

Future<bool?> showDeleteDialog(BuildContext context, String itemType) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete $itemType'),
        content: Text('Are you sure you want to delete this $itemType?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}