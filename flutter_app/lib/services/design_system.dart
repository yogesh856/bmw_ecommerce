import 'package:flutter/material.dart';

// ── DESIGN SYSTEM TOKENS (Kinetic Monolith) ──────────────
class DS {
  // Surface tiers
  static const bg           = Color(0xFF0E0E0E); // surface_container_lowest
  static const surface      = Color(0xFF131313); // primary canvas
  static const surfaceLow   = Color(0xFF1C1B1B); // secondary tier
  static const surfaceMid   = Color(0xFF201F1F); // content blocks
  static const surfaceHigh  = Color(0xFF2A2A2A); // cards / interactive
  static const surfaceTop   = Color(0xFF353534); // modals / elevated

  // Brand
  static const primary      = Color(0xFF0066BF);
  static const primaryGlow  = Color(0xFFA7C8FF);
  static const onSurface    = Color(0xFFE5E2E1);
  static const onSurfaceMid = Color(0xFF9D9B9A);
  static const onSurfaceDim = Color(0xFF555452);

  // Ghost border (15% outline_variant)
  static const outlineVariant = Color(0xFF414752);
  static BorderSide ghostBorder =
      BorderSide(color: outlineVariant.withOpacity(0.15));
}
