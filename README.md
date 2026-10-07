# 📊 FlowLog

[![Flutter Version](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Database: Drift](https://img.shields.io/badge/Database-Drift-%23414141.svg?style=for-the-badge)](https://drift.simonbinder.eu/)
[![Platform: Mobile](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

### Language Selection / Sprachauswahl
🌐 **[English Version](#english)** | 🌐 **[Deutsche Version](#deutsch)**

---

## English

A modern, private, and performant consumption tracker and budget controller, developed with **Flutter** and **Drift DB**. This app allows users to quickly capture, analyze, and control costs for electricity, gas, and water meter readings[cite: 2]. The architecture is strictly offline-first, ensuring data privacy and total control over your consumption records[cite: 2].

### 📌 Table of Contents
1. [🧘 Design Philosophy](#-design-philosophy-transparency-creates-awareness)
2. [✨ Features (MVP)](#-features-mvp)
3. [🎨 UI Design & Color Palette](#-ui-design--color-palette)
4. [🛠️ Tech Stack](#%EF%B8%8F-tech-stack)
5. [🚀 Installation & Setup](#-installation--setup)
6. [🔧 Troubleshooting](#-troubleshooting)
7. [🔮 Roadmap](#-roadmap)

---

### 🧘 Design Philosophy: "Transparency creates Awareness"

The development follows strict principles to optimally support the user in controlling utility costs[cite: 2]:

* **Precision over Estimation:** Exact daily averages based on real-time intervals instead of inaccurate monthly estimates[cite: 2].
* **Financial Control:** Direct target/actual comparison between advance payments and real consumption to proactively avoid back-payments[cite: 2].
* **Neutrality instead of Cloud-Force:** The app works 100% offline. No account registration, no data tracking, and no shared consumption logs[cite: 2].
* **Speed before Complexity:** Meter readings are logged in seconds. The interface is highly optimized for rapid, friction-free input[cite: 2].

---

### ✨ Features (MVP)

* **4-Resource Tracking:** Dedicated, modular tracking for Electricity (`kWh`), Gas (`m³`), Cold Water (`m³`), and Hot Water (`m³`).
* **Hybrid Analysis:** Real-time calculation of consumption since the last reading alongside projected averages for Day, Week, Month, and Year.
* **Two-Tier Validation ("The Guardian"):** Hard stop against entries lower than previous readings for the selected date, plus soft warnings for high consumption spikes.
* **Full CRUD & Smart UI:** Swipe-to-delete with undo action, tap-to-edit with date picker, and scrollable entry views preventing keyboard overflows.
* **Data Sovereignty (Settings Module):** Strategy-based CSV/JSON export and resilient import with transactional disaster recovery and safety confirmation dialog.
---

### 🎨 UI Design & Color Palette

To provide intuitive differentiation between energy sources, the app uses a clear, high-contrast color scheme:

| Visual Accent | Color Name | Hex Code | Purpose & Application |
| :--- | :--- | :--- | :--- |
| ⚡ **Electricity** | Electric Amber | `#FFC107` | Symbolizes energy and light for electrical metrics (`kWh`). |
| 🔥 **Gas** | Gas Orange | `#FF9800` | Symbolizes heat and combustion for the gas module (`m³`). |
| 💧 **Cold Water** | Water Blue | `#2196F3` | Clear representation for cold water resources (`m³`). |
| ♨️ **Hot Water** | Thermal Red | `#FF5252` | Distinct accent for hot water and thermal resources (`m³`). |
| 🌑 **Background** | Deep Black | `#121212` | Modern Dark Theme for high readability and focus. |
---

### 🛠️ Tech Stack

* **Framework:** Flutter (Native Cross-Platform UI)
* **Local Database:** [Drift Database](https://drift.simonbinder.eu/) (Reactive SQLite wrapper)
* **State Management:** Provider & Streams for high-performance UI synchronization
* **Code Generation:** Build Runner for type-safe database schemas

---

### 🚀 Installation & Setup

#### 1. Fetch Dependencies
```bash
flutter pub get
```

#### 2. Trigger Code Generation
Drift relies on code generation to maintain the reactive database layer[cite: 2].
```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 3. Launch the Application
```bash
flutter run
```

---

### 🔧 Troubleshooting

<details>
<summary><b>Issue: Code generation fails with <code>build_runner</code></b></summary>

If database changes conflict with existing code, run a fresh build:
```bash
flutter pub run build_runner clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```
</details>

<details>
<summary><b>Issue: Database access errors on startup</b></summary>

Drift uses native SQLite bindings. Ensure your `pubspec.yaml` contains the correct sqlite3 dependencies for your specific target platform (Android/iOS/Desktop).
</details>

---

### 🔮 Roadmap

* [ ] **Contract & Cost Profiles (Phase 2):** Input of unit prices, base fees, and monthly payments for exact budget forecasting.
* [ ] **Thermodynamic Gas Conversion:** Calculation of kWh from m³ via calorific value and state number (DVGW G 685).
* [ ] **Visual Trends & Charts (Phase 3):** Line and bar charts (`fl_chart`) for long-term consumption trends.
* [ ] **Basement UX & Accessibility:** Flashlight toggle in entry forms, haptics, and BFSG compliance.
* [ ] **OCR Camera Scan (Phase 4):** Automated meter reading recognition using on-device ML.
---

*Developed as a Flutter Showcase Project.*

---
---

## Deutsch

Ein moderner, privater und performanter Verbrauchs-Tracker und Budget-Controller, entwickelt mit **Flutter** und der **Drift DB**[cite: 2]. Diese App ermöglicht es Nutzern, ihre Zählerstände für Strom, Gas und Wasser schnell zu erfassen, zu analysieren und Kosten zu kontrollieren[cite: 2]. Der Fokus liegt auf Datenschutz (Offline-First), exakten mathematischen Berechnungen und einer klaren Budget-Übersicht[cite: 2].

### 📌 Inhaltsverzeichnis
1. [🧘 Design-Philosophie](#-design-philosophie-transparenz-schafft-bewusstsein)
2. [✨ Features (MVP)](#-features-mvp-1)
3. [🎨 UI-Design & Farbpalette](#-ui-design--farbpalette)
4. [🛠️ Technologie-Stack](#%EF%B8%8F-technologie-stack-1)
5. [🚀 Installation & Setup](#-installation--setup-1)
6. [🔧 Fehlerbehebung (Troubleshooting)](#-fehlerbehebung-troubleshooting)
7. [🔮 Roadmap](#-roadmap-1)

---

### 🧘 Design-Philosophie: "Transparenz schafft Bewusstsein"

Die Entwicklung folgt strengen Prinzipien, um den Nutzer optimal bei der Kontrolle seiner Nebenkosten zu unterstützen[cite: 2]:

* **Präzision vor Schätzung:** Exakte Tagesdurchschnitte basierend auf realen Zeitintervallen anstatt ungenauer Monatsschätzungen[cite: 2].
* **Finanzielle Kontrolle:** Direkter Soll-Ist-Abgleich zwischen Abschlagszahlungen und tatsächlichem Verbrauch, um teure Nachzahlungen zu vermeiden[cite: 2].
* **Neutralität statt Cloud-Zwang:** Die App funktioniert 100 % offline. Es gibt keine Kontoregistrierung und keine geteilten Verbrauchsdaten[cite: 2].
* **Geschwindigkeit vor Komplexität:** Jeder Zählerstand ist in Sekunden eingetragen. Das Interface ist auf schnelles Logging optimiert[cite: 2].

---

### ✨ Features (MVP)

* **4-Sparten-Tracking:** Eigenständige Module für Strom (`kWh`), Gas (`m³`), Kaltwasser (`m³`) und Warmwasser (`m³`).
* **Hybride Analyse:** Direkter Vergleich zum letzten Eintrag sowie Hochrechnungen für Tag, Woche, Monat und Jahr.
* **Zweistufige Validierung („The Guardian“):** Verhindert Zählerstandsrückgänge zum gewählten Messdatum und warnt vor extremen Verbrauchssprüngen.
* **Vollständige CRUD-Bedienung:** Swipe-to-Delete mit Undo-Funktion, Tap-to-Edit mit Datumswahl und tastatur-optimierte Scrollansichten.
* **Datensouveränität (Einstellungsmodul):** CSV- und JSON-Export via Strategy Pattern sowie fehlertoleranter Import mit transaktionalem Restore und Sicherheitsabfrage.
---

### 🎨 UI-Design & Farbpalette

Die Anwendung nutzt ein klares Farbschema zur intuitiven Unterscheidung der Energiequellen:

| Visueller Akzent | Farbname | Hex-Code | Funktion & Anwendung |
| :--- | :--- | :--- | :--- |
| ⚡ **Strom** | Electric Amber | `#FFC107` | Fokus auf Energie und Licht für den Strom-Bereich (`kWh`). |
| 🔥 **Gas** | Gas Orange | `#FF9800` | Symbolisiert Wärme und Verbrennung für das Gas-Modul (`m³`). |
| 💧 **Kaltwasser** | Water Blue | `#2196F3` | Klare Darstellung für die Kaltwasser-Ressourcen (`m³`). |
| ♨️ **Warmwasser** | Thermal Red | `#FF5252` | Eigenständiger Akzent für Warmwasser und thermische Energie (`m³`). |
| 🌑 **Hintergrund** | Deep Black | `#121212` | Modernes Dark-Theme für maximale Übersicht. |
---

### 🛠️ Technologie-Stack

* **Framework:** Flutter (Plattformübergreifende native App-Entwicklung)
* **Datenbank:** [Drift Database](https://drift.simonbinder.eu/) (Reaktive SQL-Lösung)
* **State Management:** Provider & Streams für reaktive UI-Updates
* **Code Generation:** Build Runner für typsichere Datenbankabfragen

---

### 🚀 Installation & Setup

Stelle sicher, dass das Flutter SDK auf deinem System einsatzbereit ist.

#### 1. Abhängigkeiten installieren
```bash
flutter pub get
```

#### 2. Datenbank-Modelle generieren
Da Drift Code-Generierung nutzt, muss der Build-Runner ausgeführt werden:
```bash
dart run build_runner --delete-conflicting-outputs
```

#### 3. Anwendung starten
```bash
flutter run
```

---

### 🔧 Fehlerbehebung (Troubleshooting)

<details>
<summary><b>Fehler: <code>build_runner</code> schlägt fehl</b></summary>

Sollte der Build-Prozess aufgrund veralteter oder konfligierender Dateien abbrechen, bereinige den Cache:
```bash
flutter pub run build_runner clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```
</details>

<details>
<summary><b>Fehler: Datenbank-Fehler beim App-Start</b></summary>

Prüfe, ob alle notwendigen `sqlite3`-Abhängigkeiten in deiner `pubspec.yaml` vorhanden sind, da Drift diese nativen Bibliotheken für den Datenbankzugriff benötigt.
</details>

---

### 🔮 Roadmap

* [ ] **Vertrags- & Kostenprofile (Phase 2):** Hinterlegen von Arbeitspreis, Grundgebühr und monatlichen Abschlägen zur Budgetberechnung.
* [ ] **Thermodynamische Gasumrechnung:** Automatische Berechnung von m³ in kWh mittels Brennwert und Zustandszahl (DVGW G 685).
* [ ] **Visuelle Trends (Phase 3):** Diagramme und Graphen (`fl_chart`) für langfristige Verbrauchsanalysen.
* [ ] **Keller-UX & Barrierefreiheit:** Integrierter Taschenlampen-Schalter, Haptik-Feedback und BFSG-Konformität.
* [ ] **OCR-Kamera-Scan (Phase 4):** Automatische Zählerstandserkennung per Smartphone-Kamera via On-Device-Erkennung.
---
*Entwickelt als Flutter Showcase Projekt.*