import 'package:flutter/material.dart';

class Alert {
  Future show(BuildContext context, String message) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"))
          ],
          content: Text(message),
        );
      },
    );
  }
}
