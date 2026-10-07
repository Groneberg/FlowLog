import 'package:flow_log/src/features/ElectricityDetail/screen/electricity_detail_screen.dart';
import 'package:flow_log/src/features/GasDetail/screen/gas_detail_screen.dart';
import 'package:flow_log/src/features/HotWaterDetail/screen/hot_water_detail_screen.dart';
import 'package:flow_log/src/features/ColdWaterDetail/screen/cold_water_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/database_service.dart';
import '../../../data/services/export_service.dart';
import '../../../data/services/import_service.dart';
import '../widgets/big_menu_button.dart';

enum ImportMode { csv, json }

class SelectionSheet extends StatelessWidget {
  const SelectionSheet({super.key, required this.onSelect});

  final void Function(ExportStrategy strategy) onSelect;

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
              'Export auswählen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ExportOption(
              icon: Icons.table_chart_outlined,
              title: 'Tabellendaten (CSV)',
              subtitle: 'Für Excel, Tabellen und Auswertungen',
              strategy: CsvExportStrategy(),
              onSelect: onSelect,
            ),
            const SizedBox(height: 12),
            _ExportOption(
              icon: Icons.backup_outlined,
              title: 'Vollständiges Backup (JSON)',
              subtitle: 'Vollständige Datensicherung zur Wiederherstellung',
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleExport(BuildContext context) async {
    final strategy = await showModalBottomSheet<ExportStrategy>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SelectionSheet(
        onSelect: (selectedStrategy) {
          Navigator.of(context).pop(selectedStrategy);
        },
      ),
    );

    if (strategy == null || !context.mounted) return;

    final database = Provider.of<AppDatabase>(context, listen: false);
    final exportService = ExportService(database);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daten werden exportiert...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    try {
      await exportService.exportData(context: context, strategy: strategy);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleImport(BuildContext context) async {
    final mode = await showModalBottomSheet<ImportMode>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImportSelectionSheet(
        onSelect: (selectedMode) {
          Navigator.of(context).pop(selectedMode);
        },
      ),
    );

    if (mode == null || !context.mounted) return;

    final database = Provider.of<AppDatabase>(context, listen: false);
    final importService = ImportService(database);

    if (mode == ImportMode.json) {
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Datenbank überschreiben?'),
          content: const Text(
            'Achtung: Beim Wiederherstellen eines Backups werden alle aktuellen '
            'Zählerstände gelöscht und durch das Backup ersetzt. Dieser Vorgang '
            'kann nicht rückgängig gemacht werden.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.warning_rounded),
              label: const Text('Überschreiben & Wiederherstellen'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

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
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler beim Wiederherstellen: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      return;
    }

    try {
      final count = await importService.importDataFromCsv();
      if (context.mounted && count > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$count Einträge erfolgreich importiert!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Import: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlowLog'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Daten importieren',
            onPressed: () => _handleImport(context),
          ),
          Builder(
            builder: (buttonContext) => IconButton(
              icon: const Icon(Icons.file_upload_outlined),
              tooltip: 'Daten exportieren',
              onPressed: () => _handleExport(buttonContext),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BigMenuButton(
                  icon: const Icon(
                    Icons.bolt_rounded,
                    size: 52,
                    color: Colors.amber,
                  ),
                  label: 'Strom',
                  color: Colors.amber.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ElectricityDetailScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: const Icon(
                    Icons.local_fire_department_rounded,
                    size: 52,
                    color: Colors.orange,
                  ),
                  label: 'Gas',
                  color: Colors.orange.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GasDetailScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: const Icon(
                    Icons.water_drop_rounded,
                    size: 52,
                    color: Colors.blue,
                  ),
                  label: 'Kaltwasser',
                  color: Colors.blue.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ColdWaterDetailScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: const Icon(
                    Icons.waves_rounded,
                    size: 52,
                    color: Colors.redAccent,
                  ),
                  label: 'Warmwasser',
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HotWaterDetailScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
