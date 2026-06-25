# 📊 EnergyFlow

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

* **Resource Tracking:** Dedicated, modular tracking for electricity (kWh), gas (m³), and water (m³)[cite: 2].
* **Hybrid Analysis:** Real-time comparison to previous entries alongside automated projections for day, week, month, and year[cite: 2].
* **Smart Conversion:** Automatic conversion of gas volumes (m³) into billing-relevant kWh using user-defined calorific values and state numbers[cite: 2].
* **Full CRUD Operations:** Flexible creation, reading, editing, and deletion with precise back-dating support[cite: 2].
* **Reactive & Smart UI:** Smooth swipe-to-delete behavior with undo function and reactive list updates via streams[cite: 2].

---

### 🎨 UI Design & Color Palette

To provide intuitive differentiation between energy sources, the app uses a clear, high-contrast color scheme:

| Visual Accent | Color Name | Hex Code | Purpose & Application |
| :--- | :--- | :--- | :--- |
| ⚡ **Electricity** | Electric Gold | `#FFC107` | Symbolizes energy and light for electrical metrics. |
| 🔥 **Gas** | Gas Orange | `#FF9800` | Symbolizes heat and combustion for the gas module. |
| 💧 **Water** | Water Blue | `#2196F3` | Clear, refreshing representation for water resources. |
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
flutter pub run build_runner build --delete-conflicting-outputs
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

* [ ] **Contract & Cost Profiles:** Input of unit prices, base fees, and monthly payments for exact budget forecasting.
* [ ] **OCR Camera Scan:** Automated meter reading recognition using the device camera.
* [ ] **Dashboard Widgets:** Key performance indicators and target/actual status directly on the launch screen.
* [ ] **Export Function:** CSV and PDF generation for landlord or utility provider settlement.
* [ ] **Visual Trends:** Implementation of charts and graphs for long-term consumption analysis.

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

* **Ressourcen-Tracking:** Separate Module für Strom (kWh), Gas (m³) und Wasser (m³)[cite: 2].
* **Hybride Analyse:** Direkter Vergleich zum letzten Eintrag sowie Hochrechnungen für Tag, Woche, Monat und Jahr[cite: 2].
* **Smarte Umrechnung:** Automatische Berechnung von Gas (m³) in abrechnungsrelevante kWh mittels Brennwert und Zustandszahl[cite: 2].
* **CRUD-Operationen:** Vollständiges Erstellen, Lesen, Bearbeiten und Löschen von Einträgen mit flexibler Datumswahl für präzises Nachtragen[cite: 2].
* **Smart UI:** Swipe-to-Delete mit Undo-Funktion und reaktive Listen-Updates via Streams[cite: 2].

---

### 🎨 UI-Design & Farbpalette

Die Anwendung nutzt ein klares Farbschema zur intuitiven Unterscheidung der Energiequellen:

| Visueller Akzent | Farbname | Hex-Code | Funktion & Anwendung |
| :--- | :--- | :--- | :--- |
| ⚡ **Strom** | Electric Gold | `#FFC107` | Fokus auf Energie und Licht für den Strom-Bereich. |
| 🔥 **Gas** | Gas Orange | `#FF9800` | Symbolisiert Wärme und Verbrennung für das Gas-Modul. |
| 💧 **Wasser** | Water Blue | `#2196F3` | Klare Darstellung für die Wasser-Ressourcen. |
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
flutter pub run build_runner build --delete-conflicting-outputs
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

* [ ] **Vertrags- & Kostenprofile:** Hinterlegen von Arbeitspreis, Grundgebühr und monatlichen Abschlägen zur exakten Budgetberechnung.
* [ ] **OCR-Kamera-Scan:** Automatische Zählerstandserkennung per Smartphone-Kamera zur Fehlervermeidung.
* [ ] **Dashboard-Widgets:** Die wichtigsten Durchschnitte und der Soll-Ist-Status direkt auf dem Startbildschirm.
* [ ] **Export-Funktion:** CSV- und PDF-Export für die Nebenkostenabrechnung oder den Vermieter.
* [ ] **Visuelle Trends:** Implementierung von Diagrammen und Graphen für langfristige Analysen.

---
*Entwickelt als Flutter Showcase Projekt.*