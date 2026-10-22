import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/services/export_service.dart';
import '../../../language/language_service.dart';

class ExportSelectionSheet extends StatelessWidget {
  const ExportSelectionSheet({super.key, required this.onSelect});

  final void Function(ExportStrategy strategy) onSelect;

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LanguageService>().exportSelectionStrings;

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
            _ExportOption(
              icon: Icons.table_chart_outlined,
              title: strings.csvOptionTitle,
              subtitle: strings.csvOptionSubtitle,
              strategy: CsvExportStrategy(),
              onSelect: onSelect,
            ),
            const SizedBox(height: 12),
            _ExportOption(
              icon: Icons.backup_outlined,
              title: strings.jsonOptionTitle,
              subtitle: strings.jsonOptionSubtitle,
              strategy: JsonExportStrategy(),
              onSelect: onSelect,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  const _ExportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.strategy,
    required this.onSelect,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ExportStrategy strategy;
  final void Function(ExportStrategy strategy) onSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () => onSelect(strategy),
    );
  }
}
