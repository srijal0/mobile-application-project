import 'package:flutter/material.dart';
import 'trendora_snackbar.dart';

void showMySnackBar({
  required BuildContext context,
  required String message,
  Color? color,
  int durationSeconds = 2,
}) {
  showTrendoraSnackBar(
    context: context,
    message: message,
    color: color,
    durationSeconds: durationSeconds,
  );
}
