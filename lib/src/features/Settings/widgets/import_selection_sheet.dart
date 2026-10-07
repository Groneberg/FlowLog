import 'package:flutter/material.dart';

enum ImportMode { csv, json }

class ImportSelectionSheet extends StatelessWidget {
  const ImportSelectionSheet({super.key, required this.onSelect});

  final void Function(ImportMode mode) onSelect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 48, child: Divider(thickness: 2)),
            const SizedBox(height: 8),
            const Text(
              'Import auswählen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ImportOption(
              icon: Icons.merge_outlined,
              title: 'Messwerte zusammenführen (CSV)',
              subtitle:
                  'Bestehende Einträge bleiben erhalten, neue werden ergänzt',
              mode: ImportMode.csv,
              onSelect: onSelect,
            ),
            const SizedBox(height: 12),
            _ImportOption(
              icon: Icons.backup_outlined,
              title: 'Vollständiges Backup (JSON)',
              subtitle:
                  'Ersetzt alle bestehenden Daten vollständig (Disaster Recovery)',
              mode: ImportMode.json,
              onSelect: onSelect,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportOption extends StatelessWidget {
  const _ImportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.mode,
    required this.onSelect,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ImportMode mode;
  final void Function(ImportMode mode) onSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () => onSelect(mode),
    );
  }
}
