import 'package:flutter_base/core/common_imports.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final String? imagePath;
  final VoidCallback? onRetry;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.imagePath,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(imagePath!, height: 150)
            else if (icon != null)
              Icon(icon, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            CustomText(
              text: title,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              align: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              CustomText(
                text: message!,
                fontSize: 14,
                textColor: Colors.grey,
                align: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: 'Retry',
                width: 150,
                height: 45,
                onSubmit: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
