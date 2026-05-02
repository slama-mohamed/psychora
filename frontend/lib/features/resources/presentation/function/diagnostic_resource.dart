// ─── Filter Tab Enum ──────────────────────────────────────────────────────────

enum ResourceType { all, diagnostics, treatment, guidelines }

// ─── Model ────────────────────────────────────────────────────────────────────

class DiagnosticResource {
  final String id;
  final String title;
  final String subtitle;
  final String assetPath;
  final String category;      // label displayed, e.g., "DSM-5"
  final String iconEmoji;
  final ResourceType type;    // for filtering

  const DiagnosticResource({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.category,
    required this.iconEmoji,
    required this.type,
  });
}

// ─── Static Data ──────────────────────────────────────────────────────────────

class DiagnosticResourceData {
  DiagnosticResourceData._();

  static const List<DiagnosticResource> items = [
    // ── Diagnostics ──────────────────────────────────────────────────────────
    DiagnosticResource(
      id: 'dsm5_bipolar',
      title: 'Bipolar Disorder',
      subtitle: 'DSM-5 diagnostic criteria — Manic, hypomanic, and depressive episodes',
      assetPath: 'assets/pdf/dsm5_bipolar.pdf',
      category: 'DSM-5',
      iconEmoji: '🔄',
      type: ResourceType.diagnostics,
    ),
    DiagnosticResource(
      id: 'dsm5_personality',
      title: 'Personality Disorders',
      subtitle: 'DSM-5 diagnostic criteria — Cluster A, B, and C',
      assetPath: 'assets/pdf/dsm5_personality (1).pdf',
      category: 'DSM-5',
      iconEmoji: '🧩',
      type: ResourceType.diagnostics,
    ),
    DiagnosticResource(
      id: 'dsm5_schizophrenia',
      title: 'Schizophrenia',
      subtitle: 'DSM-5 diagnostic criteria — Schizophrenia spectrum',
      assetPath: 'assets/pdf/dsm5_schizophrenia.pdf',
      category: 'DSM-5',
      iconEmoji: '🧠',
      type: ResourceType.diagnostics,
    ),
    // ── Treatment ────────────────────────────────────────────────────────────
    DiagnosticResource(
      id: 'nih_bipolar',
      title: 'Bipolar Disorder',
      subtitle: 'National Institute of Mental Health – Clinical Guide',
      assetPath: 'assets/pdf/nih-bipolar-disorder.pdf',
      category: 'NIH Treatment',
      iconEmoji: '💊',
      type: ResourceType.treatment,
    ),
    DiagnosticResource(
      id: 'nih_schizophrenia',
      title: 'Schizophrenia',
      subtitle: 'National Institute of Mental Health – Clinical Guide',
      assetPath: 'assets/pdf/schizophrenia.pdf',
      category: 'NIH Treatment',
      iconEmoji: '🧠',
      type: ResourceType.treatment,
    ),
    DiagnosticResource(
      id: 'nice_bpd',
      title: 'Borderline Personality Disorder',
      subtitle: 'National Institute for Health and Care Excellence – Clinical Guide',
      assetPath: 'assets/pdf/BPDTRETMENT.pdf',
      category: 'NICE Treatment',
      iconEmoji: '🫀',
      type: ResourceType.treatment,
    ),
    // ── Guidelines ───────────────────────────────────────────────────────────
    DiagnosticResource(
      id: 'nice_guidelines_bipolar',
      title: 'Bipolar Disorder',
      subtitle: 'National Institute for Health and Care Excellence – Mental Health',
      assetPath: 'assets/pdf/guidebipolaire.pdf',
      category: 'NICE Guidelines',
      iconEmoji: '📋',
      type: ResourceType.guidelines,
    ),
    DiagnosticResource(
      id: 'nice_guidelines_schizophrenia',
      title: 'Schizophrenia',
      subtitle: 'National Institute for Health and Care Excellence – Mental Health',
      assetPath: 'assets/pdf/guideschizo.pdf',
      category: 'NICE Guidelines',
      iconEmoji: '📋',
      type: ResourceType.guidelines,
    ),
    DiagnosticResource(
      id: 'nice_guidelines_personality',
      title: 'Personality Disorders',
      subtitle: 'National Institute for Health and Care Excellence – Mental Health',
      assetPath: 'assets/pdf/guideBPD.pdf',
      category: 'NICE Guidelines',
      iconEmoji: '📋',
      type: ResourceType.guidelines,
    ),
    DiagnosticResource(
      id: 'who_mental_health_guidelines',
      title: 'WHO – Mental Health',
      subtitle: 'World Health Organization – Severe Mental Disorders',
      assetPath: 'assets/pdf/WHO.pdf',
      category: 'Guidelines',
      iconEmoji: '🌍',
      type: ResourceType.guidelines,
    ),
  ];
}