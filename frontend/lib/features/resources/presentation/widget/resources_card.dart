import 'package:flutter/material.dart';

import '../function/diagnostic_resource.dart';
import 'resources_header.dart'; // kGreen, kGreenLight, kGreenMid
import 'pdf_viewer_page.dart';

class ResourceCard extends StatelessWidget {
  final DiagnosticResource resource;

  const ResourceCard({super.key, required this.resource});

  static const _typeColors = {
    ResourceType.diagnostics: (Color(0xFF1565C0), Color(0xFFE3F2FD)),
    ResourceType.treatment:   (Color(0xFF6A1B9A), Color(0xFFF3E5F5)),
    ResourceType.guidelines:  (kGreen,             kGreenLight),
    ResourceType.all:         (kGreen,             kGreenLight),
  };

  @override
  Widget build(BuildContext context) {
    final colors  = _typeColors[resource.type]!;
    final color   = colors.$1;
    final bgColor = colors.$2;

    return Material(
      color: Colors.white, // Fond blanc
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openPdf(context, resource),
        splashColor: Colors.grey.shade100, // Splash blanc/gris clair
        highlightColor: Colors.grey.shade50, // Highlight blanc/gris très clair
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // S'assurer que le container est aussi blanc
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEEEEEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _CardIcon(emoji: resource.iconEmoji, bgColor: bgColor),
              const SizedBox(width: 14),
              Expanded(
                child: _CardContent(resource: resource, color: color, bgColor: bgColor),
              ),
              const SizedBox(width: 8),
              _CardArrow(color: color, bgColor: bgColor),
            ],
          ),
        ),
      ),
    );
  }

  void _openPdf(BuildContext context, DiagnosticResource resource) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(resource: resource),
      ),
    );
  }
}

// ── Icon ──────────────────────────────────────────────────────────────────────

class _CardIcon extends StatelessWidget {
  final String emoji;
  final Color bgColor;
  const _CardIcon({required this.emoji, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
    );
  }
}

// ── Content ───────────────────────────────────────────────────────────────────

class _CardContent extends StatelessWidget {
  final DiagnosticResource resource;
  final Color color;
  final Color bgColor;
  const _CardContent({required this.resource, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            resource.category,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          resource.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          resource.subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.4),
        ),
      ],
    );
  }
}

// ── Arrow ─────────────────────────────────────────────────────────────────────

class _CardArrow extends StatelessWidget {
  final Color color;
  final Color bgColor;
  const _CardArrow({required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
    );
  }
}