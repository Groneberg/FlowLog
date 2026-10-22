import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../language/language_service.dart';

enum ImportMode { csv, json }

class ImportSelectionSheet extends StatelessWidget {
  const ImportSelectionSheet({super.key, required this.onSelect});

  final void Function(ImportMode mode) onSelect;

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LanguageService>().importSelectionStrings;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 48, child: Divider(thickness: 2)),
            const SizedBox(height: 8),
            Text(
              strings.sheetTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ImportOption(
              icon: Icons.merge_outlined,
                title: strings.csvOptionTitle,
                subtitle: strings.csvOptionSubtitle,
              mode: ImportMode.csv,
              onSelect: onSelect,
            ),
            const SizedBox(height: 12),
            _ImportOption(
              icon: Icons.backup_outlined,
                title: strings.jsonOptionTitle,
                subtitle: strings.jsonOptionSubtitle,
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
