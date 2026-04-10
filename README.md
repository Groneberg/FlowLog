# 📊 EnergyFlow

[English](#english) | [Deutsch](#deutsch)

---

## English

A modern, private and performant consumption tracker and budget controller, developed with **Flutter** and **Drift DB**.  
This app allows users to quickly capture, analyze and control costs for electricity, gas and water meter readings. The focus is on privacy (offline-first), exact mathematical calculations and a clear budget overview.

### 🧘 Design Philosophy: "Transparency creates Awareness"

The development follows strict principles to optimally support the user in controlling their utility costs:

* **Precision over Estimation:** Exact daily averages based on real time intervals instead of inaccurate monthly estimates.
* **Financial Control:** Direct target/actual comparison between advance payments and real consumption to avoid back-payments.
* **Neutrality instead of Cloud-Force:** The app works 100% offline. No account registration and no shared consumption data.
* **Speed before Complexity:** Every meter reading is entered in seconds. The interface is optimized for fast logging.

### ✨ Features (MVP)

* **Resource Tracking:** Separate modules for electricity (kWh), gas (m³) and water (m³).
* **Hybrid Analysis:** Direct comparison to the last entry as well as projections for day, week, month and year.
* **Smart Conversion:** Automatic calculation of gas (m³) into billing-relevant kWh using calorific value and state number.
* **CRUD Operations:** Complete creating, reading, editing and deleting of entries with flexible date selection for precise back-dating.
* **Smart UI:** Swipe-to-delete with undo function and reactive list updates via streams.

### 🎨 Design & Colors

The application uses a clear color scheme to intuitively differentiate between energy sources:

* **Electric Gold** (`#FFC107`): Focus on energy and light for the electricity area.
* **Gas Orange** (`#FF9800`): Symbolizes heat and combustion for the gas module.
* **Water Blue** (`#2196F3`): Clear representation for water resources.
* **Background** (`#121212`): A modern, clean dark theme with card layouts for maximum overview.

### 🛠 Technology-Stack

* **Framework:** Flutter
* **Database:** [Drift Database](https://drift.simonbinder.eu/)
* **State Management:** Provider & Streams for reactive UI updates.
* **Code Generation:** Build Runner for type-safe database queries.

### 🚀 Installation & Setup

1.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

2.  **Generate database models:**
    Since Drift uses code generation, the build runner must be executed:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

### 🔮 Roadmap

* [ ] **Contract & Cost Profiles:** Input of unit price, base fee and monthly payments for exact budget calculation.
* [ ] **OCR Camera Scan:** Automatic meter reading recognition via smartphone camera to avoid errors.
* [ ] **Dashboard Widgets:** The most important averages and the target/actual status directly on the start screen.
* [ ] **Export Function:** CSV and PDF export for the service charge settlement or the landlord.
* [ ] **Visual Trends:** Implementation of charts and graphs for long-term analysis.

---

*Developed as a Flutter Showcase Project.*

---

## Deutsch

Ein moderner, privater und performanter Verbrauchs-Tracker und Budget-Controller, entwickelt mit **Flutter** und der **Drift DB**.  
Diese App ermöglicht es Nutzern, ihre Zählerstände für Strom, Gas und Wasser schnell zu erfassen, zu analysieren und Kosten zu kontrollieren. Der Fokus liegt auf Datenschutz (Offline-First), exakten mathematischen Berechnungen und einer klaren Budget-Übersicht.

### 🧘 Design-Philosophie: "Transparenz schafft Bewusstsein"

Die Entwicklung folgt strengen Prinzipien, um den Nutzer optimal bei der Kontrolle seiner Nebenkosten zu unterstützen:

* **Präzision vor Schätzung:** Exakte Tagesdurchschnitte basierend auf realen Zeitintervallen anstatt ungenauer Monatsschätzungen.
* **Finanzielle Kontrolle:** Direkter Soll-Ist-Abgleich zwischen Abschlagszahlungen und tatsächlichem Verbrauch, um Nachzahlungen zu vermeiden.
* **Neutralität statt Cloud-Zwang:** Die App funktioniert 100 % offline. Es gibt keine Kontoregistrierung und keine geteilten Verbrauchsdaten.
* **Geschwindigkeit vor Komplexität:** Jeder Zählerstand ist in Sekunden eingetragen. Das Interface ist auf schnelles Logging optimiert.

### ✨ Features (MVP)

* **Ressourcen-Tracking:** Separate Module für Strom (kWh), Gas (m³) und Wasser (m³).
* **Hybride Analyse:** Direkter Vergleich zum letzten Eintrag sowie Hochrechnungen für Tag, Woche, Monat und Jahr.
* **Smarte Umrechnung:** Automatische Berechnung von Gas (m³) in abrechnungsrelevante kWh mittels Brennwert und Zustandszahl.
* **CRUD-Operationen:** Vollständiges Erstellen, Lesen, Bearbeiten und Löschen von Einträgen mit flexibler Datumswahl für präzises Nachtragen.
* **Smart UI:** Swipe-to-Delete mit Undo-Funktion und reaktive Listen-Updates via Streams.

### 🎨 Design & Farben

Die Anwendung nutzt ein klares Farbschema zur intuitiven Unterscheidung der Energiequellen:

* **Electric Gold** (`#FFC107`): Fokus auf Energie und Licht für den Strom-Bereich.
* **Gas Orange** (`#FF9800`): Symbolisiert Wärme und Verbrennung für das Gas-Modul.
* **Water Blue** (`#2196F3`): Klare Darstellung für die Wasser-Ressourcen.
* **Background** (`#121212`): Ein modernes, cleanes Dark-Theme mit Card-Layouts für maximale Übersicht.

### 🛠 Technologie-Stack

* **Framework:** Flutter
* **Datenbank:** [Drift Database](https://drift.simonbinder.eu/)
* **State Management:** Provider & Streams für reaktive UI-Updates.
* **Code Generation:** Build Runner für typsichere Datenbankabfragen.

### 🚀 Installation & Setup

1.  **Abhängigkeiten installieren:**
    ```bash
    flutter pub get
    ```

2.  **Datenbank-Modelle generieren:**
    Da Drift Code-Generierung nutzt, muss der Build-Runner ausgeführt werden:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

3.  **App starten:**
    ```bash
    flutter run
    ```

### 🔮 Roadmap

* [ ] **Vertrags- & Kostenprofile:** Hinterlegen von Arbeitspreis, Grundgebühr und monatlichen Abschlägen zur exakten Budgetberechnung.
* [ ] **OCR-Kamera-Scan:** Automatische Zählerstandserkennung per Smartphone-Kamera zur Fehlervermeidung.
* [ ] **Dashboard-Widgets:** Die wichtigsten Durchschnitte und der Soll-Ist-Status direkt auf dem Startbildschirm.
* [ ] **Export-Funktion:** CSV- und PDF-Export für die Nebenkostenabrechnung oder den Vermieter.
* [ ] **Visuelle Trends:** Implementierung von Diagrammen und Graphen für langfristige Analysen.

---
*Entwickelt als Flutter Showcase Projekt.*