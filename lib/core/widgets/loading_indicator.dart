import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Centered circular progress indicator using the brand primary colour.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
