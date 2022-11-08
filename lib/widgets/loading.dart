import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubaline_ta/providers/loading_provier.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      child: child,
      builder: (context, value, child) {
        return Stack(
          children: [
            child!,
            if (value.isLoading)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (value.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}
