import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/services/export_service.dart';
import '../../../data/services/import_service.dart';
import '../../../language/language_service.dart';
import '../widgets/export_selection_sheet.dart';
import '../widgets/import_selection_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _showExportSelection(BuildContext context) async {
    final strings = context.read<LanguageService>().settingsStrings;
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
      SnackBar(
        content: Text(strings.exportInProgress),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      await context.read<ExportService>().exportData(
        context: context,
        strategy: strategy,
      );
      if (!context.mounted) return;
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.exportError(error.toString())),
          backgroundColor: Colors.red,
        ),
      );
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
    final strings = context.read<LanguageService>().settingsStrings;
    final importService = context.read<ImportService>();

    try {
      final count = await importService.importDataFromCsv();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            count > 0
                ? strings.importCsvSuccess(count)
                : strings.importCsvEmpty,
          ),
          backgroundColor: count > 0 ? Colors.green : Colors.orange,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.importCsvError(error.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _restoreJson(BuildContext context) async {
    final strings = context.read<LanguageService>().settingsStrings;
    final decision = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.restoreDialogTitle),
        content: Text(strings.restoreDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('cancel'),
            child: Text(strings.restoreDialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('export'),
            child: Text(strings.restoreDialogBackupFirst),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop('overwrite'),
            icon: const Icon(Icons.warning_rounded),
            label: Text(strings.restoreDialogOverwrite),
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
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            count > 0 ? strings.restoreSuccess(count) : strings.restoreEmpty,
          ),
          backgroundColor: count > 0 ? Colors.green : Colors.orange,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.restoreError(error.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = context.watch<LanguageService>();
    final strings = languageService.settingsStrings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.settingsTitle), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: strings.sectionDataManagement),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: _SettingsAction(
                      icon: Icons.upload_file_outlined,
                      title: strings.actionExport,
                      onTap: () => _showExportSelection(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SettingsAction(
                      icon: Icons.download_for_offline_outlined,
                      title: strings.actionImport,
                      onTap: () => _showImportSelection(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          _SectionHeader(title: strings.sectionLanguage),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.8,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _LanguageTile(
                    code: 'de',
                    title: 'Deutsch',
                    isSelected: languageService.isGerman,
                    onTap: () => languageService.setLanguage('de'),
                  ),
                  _LanguageTile(
                    code: 'en',
                    title: 'English',
                    isSelected: languageService.isEnglish,
                    onTap: () => languageService.setLanguage('en'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          _SectionHeader(title: strings.sectionAbout),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: Text(strings.aboutTitle),
              subtitle: Text(strings.aboutSubtitle),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.code,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primaryContainer : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.check : Icons.language_outlined,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
