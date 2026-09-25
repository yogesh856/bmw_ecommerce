import 'package:flutter/material.dart';
import 'design_system.dart';

/// Shared utility functions across the BMW app.
class AppUtils {
  /// Format price to Indian format (Crore / Lakh / raw)
  static String formatPrice(dynamic price) {
    int p = (price as num).toInt();
    if (p >= 10000000) return '₹${(p / 10000000).toStringAsFixed(2)} Cr';
    if (p >= 100000)   return '₹${(p / 100000).toStringAsFixed(2)} L';
    return '₹$p';
  }

  /// Short format for cards
  static String formatPriceShort(dynamic price) {
    int p = (price as num).toInt();
    if (p >= 10000000) return '₹${(p / 10000000).toStringAsFixed(1)} Cr';
    if (p >= 100000)   return '₹${(p / 100000).toStringAsFixed(1)} L';
    return '₹$p';
  }

  /// Show standard BMW styled snackbar
  static void showSnack(BuildContext context, String message, {bool isError = false}) {
    if (!context.mounted) return;
    final color = isError ? Colors.redAccent : DS.primary;
    final icon  = isError ? Icons.warning_amber_rounded : Icons.info_outline;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        content: Container(
          decoration: BoxDecoration(
            color: DS.surfaceTop,
            border: Border.all(color: DS.outlineVariant.withOpacity(0.3), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: color),
                const SizedBox(width: 16),
                Center(child: Icon(icon, color: color, size: 20)),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      message.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
