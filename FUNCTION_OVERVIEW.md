# Function Overview / Funktionsübersicht

> Part of the [Electric Capital Crypto Ecosystems](https://github.com/electric-capital/crypto-ecosystems) project.
> Licensed under MIT License. Copyright (c) 2019 Electric Capital.

This document provides an overview of all major functions in the crypto-ecosystems codebase.

Dieses Dokument bietet eine Übersicht über alle wichtigen Funktionen in der crypto-ecosystems Codebasis.

---

## Main Entry Points / Haupteinstiegspunkte

### `main.zig::main()`
**English:** The program entry point. Initializes memory allocator and calls cmdMain.

**Deutsch:** Der Programm-Einstiegspunkt. Initialisiert den Speicher-Allocator und ruft cmdMain auf.

### `commands.zig::cmdMain()`
**English:** Parses command-line arguments and routes to the appropriate command handler (validate, export, help, version).

**Deutsch:** Parst Kommandozeilen-Argumente und leitet zum entsprechenden Befehls-Handler weiter (validate, export, help, version).

---

## Command Functions / Befehlsfunktionen

### `commands.zig::cmdValidate()`
**English:** Validates all migration files and prints statistics:
- Number of migrations processed
- Number of ecosystems
- Number of repositories
- Number of tags

**Deutsch:** Validiert alle Migrationsdateien und gibt Statistiken aus:
- Anzahl verarbeiteter Migrationen
- Anzahl der Ökosysteme
- Anzahl der Repositories
- Anzahl der Tags

### `commands.zig::cmdExport()`
**English:** Exports the taxonomy to a JSON Lines file. Each line contains:
- Ecosystem name
- Branch path (hierarchy of sub-ecosystems)
- Repository URL
- Tags (like #protocol, #sdk, etc.)

**Deutsch:** Exportiert die Taxonomie in eine JSON Lines-Datei. Jede Zeile enthält:
- Ökosystem-Name
- Branch-Pfad (Hierarchie der Unter-Ökosysteme)
- Repository-URL
- Tags (wie #protocol, #sdk, usw.)

---

## Taxonomy Core Functions / Taxonomie-Kernfunktionen

### `taxonomy.zig::Taxonomy.init()`
**English:** Creates a new empty taxonomy with all data structures initialized.

**Deutsch:** Erstellt eine neue leere Taxonomie mit allen initialisierten Datenstrukturen.

### `taxonomy.zig::Taxonomy.deinit()`
**English:** Frees all memory used by the taxonomy. Must be called to prevent memory leaks.

**Deutsch:** Gibt allen von der Taxonomie verwendeten Speicher frei. Muss aufgerufen werden, um Speicherlecks zu vermeiden.

### `taxonomy.zig::Taxonomy.load()`
**English:** Loads all migration files from a directory. Supports filtering by date to see historical states.

**Deutsch:** Lädt alle Migrationsdateien aus einem Verzeichnis. Unterstützt Filterung nach Datum, um historische Zustände zu sehen.

### `taxonomy.zig::Taxonomy.loadFile()`
**English:** Processes a single migration file line by line, executing DSL commands.

**Deutsch:** Verarbeitet eine einzelne Migrationsdatei Zeile für Zeile und führt DSL-Befehle aus.

### `taxonomy.zig::Taxonomy.exportJson()`
**English:** Exports taxonomy data to JSON Lines format for data analysis.

**Deutsch:** Exportiert Taxonomie-Daten ins JSON Lines-Format für Datenanalyse.

### `taxonomy.zig::Taxonomy.eco()`
**English:** Retrieves detailed information about a specific ecosystem including its repositories and sub-ecosystems.

**Deutsch:** Ruft detaillierte Informationen über ein bestimmtes Ökosystem ab, einschließlich seiner Repositories und Unter-Ökosysteme.

### `taxonomy.zig::Taxonomy.stats()`
**English:** Returns statistics about the current taxonomy state.

**Deutsch:** Gibt Statistiken über den aktuellen Taxonomie-Zustand zurück.

---

## DSL Command Functions / DSL-Befehlsfunktionen

The Domain Specific Language (DSL) provides commands for modifying the taxonomy:

Die Domain Specific Language (DSL) bietet Befehle zum Ändern der Taxonomie:

### `ecoAdd()` - Add Ecosystem / Ökosystem hinzufügen
```
ecoadd <name>
```
**English:** Creates a new ecosystem in the taxonomy.

**Deutsch:** Erstellt ein neues Ökosystem in der Taxonomie.

**Example / Beispiel:** `ecoadd Bitcoin`

### `ecoCon()` - Connect Ecosystems / Ökosysteme verbinden
```
ecocon <parent> <child>
```
**English:** Creates a parent-child relationship between ecosystems. The child becomes a sub-ecosystem of the parent.

**Deutsch:** Erstellt eine Eltern-Kind-Beziehung zwischen Ökosystemen. Das Kind wird ein Unter-Ökosystem des Elternteils.

**Example / Beispiel:** `ecocon Bitcoin Lightning`

### `ecoDis()` - Disconnect Ecosystems / Ökosysteme trennen
```
ecodis <parent> <child>
```
**English:** Removes the parent-child relationship between ecosystems.

**Deutsch:** Entfernt die Eltern-Kind-Beziehung zwischen Ökosystemen.

**Example / Beispiel:** `ecodis Bitcoin Lightning`

### `ecoRem()` - Remove Ecosystem / Ökosystem entfernen
```
ecorem <name>
```
**English:** Completely removes an ecosystem from the taxonomy.

**Deutsch:** Entfernt ein Ökosystem vollständig aus der Taxonomie.

**Example / Beispiel:** `ecorem OldEcosystem`

### `ecoMov()` - Rename Ecosystem / Ökosystem umbenennen
```
ecomov <old_name> <new_name>
```
**English:** Renames an ecosystem (useful for rebranding). All relationships are preserved.

**Deutsch:** Benennt ein Ökosystem um (nützlich für Rebranding). Alle Beziehungen bleiben erhalten.

**Example / Beispiel:** `ecomov Elrond MultiversX`

### `repAdd()` - Add Repository / Repository hinzufügen
```
repadd <ecosystem> <repo_url> [#tag1] [#tag2] ...
```
**English:** Adds a repository to an ecosystem with optional tags.

**Deutsch:** Fügt ein Repository zu einem Ökosystem mit optionalen Tags hinzu.

**Example / Beispiel:** `repadd Bitcoin https://github.com/bitcoin/bitcoin #protocol`

### `repMov()` - Move/Rename Repository / Repository verschieben/umbenennen
```
repmov <old_url> <new_url>
```
**English:** Updates a repository URL (useful when repos move on GitHub).

**Deutsch:** Aktualisiert eine Repository-URL (nützlich wenn Repos auf GitHub umziehen).

**Example / Beispiel:** `repmov https://github.com/old/repo https://github.com/new/repo`

### `repRem()` - Remove Repository / Repository entfernen
```
reprem <ecosystem> <repo_url>
```
**English:** Removes a repository from a specific ecosystem.

**Deutsch:** Entfernt ein Repository aus einem bestimmten Ökosystem.

**Example / Beispiel:** `reprem Bitcoin https://github.com/some/repo`

---

## Utility Functions / Hilfsfunktionen

### `shlex.zig::split()`
**English:** Tokenizes command-line style input with support for:
- Quoted strings (preserves spaces)
- Escape sequences with backslash
- Both single and double quotes

**Deutsch:** Tokenisiert Eingaben im Kommandozeilen-Stil mit Unterstützung für:
- Strings in Anführungszeichen (behält Leerzeichen bei)
- Escape-Sequenzen mit Backslash
- Sowohl einfache als auch doppelte Anführungszeichen

### `shlex.zig::stripEscapes()`
**English:** Removes backslash escape sequences from strings.

**Deutsch:** Entfernt Backslash-Escape-Sequenzen aus Strings.

### `timestamp.zig::hasValidTimestamp()`
**English:** Validates that a filename starts with a valid ISO8601-like timestamp (YYYY-MM-DDTHHMMSS). Checks:
- Date format correctness
- Valid date ranges
- Leap year calculations
- Days per month validation

**Deutsch:** Validiert, dass ein Dateiname mit einem gültigen ISO8601-ähnlichen Zeitstempel beginnt (YYYY-MM-DDTHHMMSS). Prüft:
- Datumsformat-Korrektheit
- Gültige Datumsbereiche
- Schaltjahr-Berechnungen
- Tage-pro-Monat-Validierung

### `timestamp.zig::isLeapYear()`
**English:** Determines if a year is a leap year using Gregorian calendar rules.

**Deutsch:** Bestimmt, ob ein Jahr ein Schaltjahr nach den Regeln des Gregorianischen Kalenders ist.

---

## Data Structures / Datenstrukturen

### `Taxonomy`
**English:** The main data structure that holds:
- Ecosystem names and IDs
- Repository URLs and IDs
- Tag names and IDs
- Parent-child relationships between ecosystems
- Ecosystem-to-repository mappings
- Repository tags

**Deutsch:** Die Hauptdatenstruktur, die enthält:
- Ökosystem-Namen und IDs
- Repository-URLs und IDs
- Tag-Namen und IDs
- Eltern-Kind-Beziehungen zwischen Ökosystemen
- Ökosystem-zu-Repository-Zuordnungen
- Repository-Tags

### `Ecosystem`
**English:** Represents a single ecosystem with:
- ID and name
- List of repository URLs
- List of sub-ecosystem names

**Deutsch:** Repräsentiert ein einzelnes Ökosystem mit:
- ID und Name
- Liste der Repository-URLs
- Liste der Unter-Ökosystem-Namen

### `EcosystemRepoRowJson`
**English:** JSON export format containing:
- Ecosystem name
- Branch path (hierarchy)
- Repository URL
- Tags

**Deutsch:** JSON-Export-Format enthaltend:
- Ökosystem-Name
- Branch-Pfad (Hierarchie)
- Repository-URL
- Tags

---

## How Migration Files Work / Wie Migrationsdateien funktionieren

**English:**
Migration files are the heart of the system. They use a simple DSL to define changes to the taxonomy over time.

1. **File Naming:** Files must start with an ISO8601-like timestamp: `YYYY-MM-DDTHHMMSS_description`
   - Example: `2009-01-03T181500_add_bitcoin`

2. **File Format:** Each line contains either:
   - A comment starting with `#`
   - A DSL command (ecoadd, repadd, ecocon, etc.)
   - Blank lines (ignored)

3. **Processing Order:** Files are processed in chronological order based on their timestamp.

4. **Time Travel:** The `--max-date` option allows viewing the taxonomy state at any point in history.

**Deutsch:**
Migrationsdateien sind das Herzstück des Systems. Sie verwenden eine einfache DSL, um Änderungen an der Taxonomie über die Zeit zu definieren.

1. **Dateinamen:** Dateien müssen mit einem ISO8601-ähnlichen Zeitstempel beginnen: `YYYY-MM-DDTHHMMSS_beschreibung`
   - Beispiel: `2009-01-03T181500_add_bitcoin`

2. **Dateiformat:** Jede Zeile enthält entweder:
   - Einen Kommentar, der mit `#` beginnt
   - Einen DSL-Befehl (ecoadd, repadd, ecocon, usw.)
   - Leerzeilen (werden ignoriert)

3. **Verarbeitungsreihenfolge:** Dateien werden in chronologischer Reihenfolge basierend auf ihrem Zeitstempel verarbeitet.

4. **Zeitreisen:** Die `--max-date` Option erlaubt es, den Taxonomie-Zustand zu jedem Zeitpunkt in der Geschichte zu betrachten.

---

## Example Workflow / Beispiel-Arbeitsablauf

### English: Adding a New Ecosystem

1. Create a migration file: `migrations/2024-12-14T143000_add_myecosystem`

2. Add content:
```
# Add the new ecosystem
ecoadd MyEcosystem

# Add some repositories
repadd MyEcosystem https://github.com/myeco/core #protocol
repadd MyEcosystem https://github.com/myeco/sdk #sdk

# Connect to parent ecosystem
ecocon Ethereum MyEcosystem
```

3. Validate: `./run.sh validate`

4. Export: `./run.sh export output.jsonl`

### Deutsch: Hinzufügen eines neuen Ökosystems

1. Erstelle eine Migrationsdatei: `migrations/2024-12-14T143000_add_myecosystem`

2. Füge Inhalt hinzu:
```
# Füge das neue Ökosystem hinzu
ecoadd MyEcosystem

# Füge einige Repositories hinzu
repadd MyEcosystem https://github.com/myeco/core #protocol
repadd MyEcosystem https://github.com/myeco/sdk #sdk

# Verbinde mit Eltern-Ökosystem
ecocon Ethereum MyEcosystem
```

3. Validiere: `./run.sh validate`

4. Exportiere: `./run.sh export output.jsonl`

---

## Testing / Testen

**English:** The codebase includes comprehensive unit tests for all major functions. Run tests with:
```bash
zig build test
```

**Deutsch:** Die Codebasis enthält umfassende Unit-Tests für alle wichtigen Funktionen. Führe Tests aus mit:
```bash
zig build test
```

---

## Summary / Zusammenfassung

**English:**
This codebase provides a powerful system for tracking cryptocurrency and blockchain ecosystems over time. The DSL allows simple text-based changes, while the export function enables data analysis. The architecture uses efficient hash maps for fast lookups and supports time-based queries.

**Deutsch:**
Diese Codebasis bietet ein leistungsstarkes System zur Verfolgung von Kryptowährungs- und Blockchain-Ökosystemen über die Zeit. Die DSL ermöglicht einfache textbasierte Änderungen, während die Export-Funktion Datenanalyse ermöglicht. Die Architektur verwendet effiziente Hash-Maps für schnelle Lookups und unterstützt zeitbasierte Abfragen.
