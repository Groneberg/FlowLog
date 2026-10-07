import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/services/export_service.dart';
import '../../../data/services/import_service.dart';
import '../widgets/export_selection_sheet.dart';
import '../widgets/import_selection_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _showExportSelection(BuildContext context) async {
    final strategy = await showModalBottomSheet<ExportStrategy>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ExportSelectionSheet(
        onSelect: (selected) => Navigator.of(context).pop(selected),
      ),
    );

    if (strategy == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daten werden exportiert...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      await context.read<ExportService>().exportData(
        context: context,
        strategy: strategy,
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Export: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showImportSelection(BuildContext context) async {
    final mode = await showModalBottomSheet<ImportMode>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImportSelectionSheet(
        onSelect: (selectedMode) => Navigator.of(context).pop(selectedMode),
      ),
    );

    if (mode == null || !context.mounted) return;

    if (mode == ImportMode.csv) {
      await _importCsv(context);
      return;
    }

    await _restoreJson(context);
  }

  Future<void> _importCsv(BuildContext context) async {
    final importService = context.read<ImportService>();

    try {
      final count = await importService.importDataFromCsv();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              count > 0
                  ? '$count Einträge erfolgreich importiert!'
                  : 'Keine gültigen Einträge gefunden.',
            ),
            backgroundColor: count > 0 ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Import: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _restoreJson(BuildContext context) async {
    final decision = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Datenbank überschreiben?'),
        content: const Text(
          'Beim Wiederherstellen eines Backups werden alle aktuellen '
          'Zählerstände gelöscht und durch das Backup ersetzt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('cancel'),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('export'),
            child: const Text('Vorher sichern'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop('overwrite'),
            icon: const Icon(Icons.warning_rounded),
            label: const Text('Überschreiben & Wiederherstellen'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (decision == 'cancel') return;

    if (decision == 'export') {
      await _showExportSelection(context);
      return;
    }

    if (decision != 'overwrite') return;

    final importService = context.read<ImportService>();

    try {
      final count = await importService.restoreFromJson();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              count > 0
                  ? '$count Einträge erfolgreich wiederhergestellt!'
                  : 'Das Backup enthält keine Einträge.',
            ),
            backgroundColor: count > 0 ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Wiederherstellen: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'DATENVERWALTUNG'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: _SettingsAction(
                      icon: Icons.upload_file_outlined,
                      title: 'Exportieren',
                      onTap: () => _showExportSelection(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SettingsAction(
                      icon: Icons.download_for_offline_outlined,
                      title: 'Importieren',
                      onTap: () => _showImportSelection(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          _SectionHeader(title: 'ÜBER FLOWLOG'),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: const Text('FlowLog v1.0.0'),
              subtitle: const Text(
                '100% Offline & Local-First. Deine Verbrauchsdaten '
                'verlassen niemals dieses Gerät.',
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.grey,
      ),
    );
  }
}

class _SettingsAction extends StatelessWidget {
  const _SettingsAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(title),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
