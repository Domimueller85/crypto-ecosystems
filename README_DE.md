# Crypto Ecosystems - Deutsche Anleitung

<h3 align="center">
<img width="300" alt="crypto_ecosystems" src="https://github.com/user-attachments/assets/3e0c7ee0-67c3-44a3-a575-6a1cb1824788" />
</h3>

Crypto Ecosystems ist eine Taxonomie von Open-Source-Blockchain-, Web3-, Kryptowährungs- und dezentralen Ökosystemen sowie deren Code-Repositories. Dieser Datensatz ist nicht vollständig und wird es hoffentlich nie sein, da jeden Tag neue Ökosysteme und Repositories erstellt werden.

## 📖 Was ist in diesem Projekt?

Dieses Projekt enthält:
- **Eine Taxonomie** von Krypto-Ökosystemen (Bitcoin, Ethereum, Solana, usw.)
- **Repository-Verknüpfungen** zu GitHub-Projekten in jedem Ökosystem
- **Hierarchische Beziehungen** zwischen Ökosystemen (z.B. Lightning als Sub-Ökosystem von Bitcoin)
- **Tags** zur Kategorisierung von Repositories (#protocol, #sdk, #developer-tool, usw.)
- **Eine zeitbasierte Migrations-Datenbank** zur Verfolgung von Änderungen über die Zeit

## 🚀 Wie benutze ich diese Taxonomie?

### 🖼️ GUI-Modus
Sie können den Taxonomie-Viewer unter [crypto-ecosystems.xyz](https://crypto-ecosystems.xyz) verwenden. Hier können Sie nach Ökosystemen und Repos suchen und alle Repos für bestimmte Ökosysteme exportieren.

<div align="center">
<img width="800" alt="image" src="https://github.com/user-attachments/assets/8003fa92-6874-42d8-a398-7b1741964498" />
</div>

### 💻 Kommandozeilen-Modus

#### Installation
Sie benötigen Zig (Version 0.11 oder höher) installiert auf Ihrem System.

#### Validierung
Um alle Migrationen zu validieren und Statistiken anzuzeigen:
```bash
./run.sh validate
```

Dies zeigt Ihnen:
- Anzahl der verarbeiteten Migrationen
- Anzahl der Ökosysteme
- Anzahl der Repositories
- Anzahl der Tags

#### Export aller Daten
Um die gesamte Taxonomie in ein JSON-Format zu exportieren:
```bash
./run.sh export exports.jsonl
```

#### Export eines einzelnen Ökosystems
Wenn Sie nur ein Ökosystem, seine Sub-Ökosysteme und seine Repositories exportieren möchten:
```bash
./run.sh export -e Bitcoin bitcoin.jsonl
```

#### Zeitbasierter Export
Um den Zustand der Taxonomie zu einem bestimmten Zeitpunkt zu sehen:
```bash
./run.sh export -m 2020-01-01 historic_export.jsonl
```

### 📊 Export-Format
Das Export-Format ist ein JSON-Objekt pro Zeile (JSON Lines):
```json
{"eco_name":"Bitcoin","branch":["Lightning"],"repo_url":"https://github.com/alexbosworth/balanceofsatoshis","tags":["#developer-tool"]}
{"eco_name":"Bitcoin","branch":["Lightning"],"repo_url":"https://github.com/bottlepay/lnd","tags":[]}
```

**Felder erklärt:**
- `eco_name`: Name des Haupt-Ökosystems
- `branch`: Hierarchischer Pfad (zeigt Sub-Ökosystem-Beziehungen)
- `repo_url`: GitHub-Repository-URL
- `tags`: Liste von Tags zur Kategorisierung

## 🛠️ Wie aktualisiere ich die Taxonomie?

### Domain Specific Language (DSL)
Es gibt eine domänenspezifische Sprache (DSL) mit Schlüsselwörtern, die Änderungen an der Taxonomie ermöglichen.

### Migrationsdateien
Migrationen werden in Dateien mit folgendem Format angegeben:
```
migrations/YYYY-MM-DDThhmmss_beschreibung_ihrer_migration
```

Das Datumsformat ist eine lockere ISO8601, jedoch ohne ':' Zeichen, um sie auf Windows gültig zu machen.

**Beispiel-Dateinamen:**
```
migrations/2009-01-03T181500_add_bitcoin
migrations/2015-07-30T152613_add_ethereum
migrations/2024-12-14T143000_meine_aenderung
```

### DSL-Befehle

#### `ecoadd` - Ökosystem hinzufügen
Fügt ein neues Ökosystem zur Taxonomie hinzu.
```lua
-- Zeilen können mit -- als Kommentar beginnen
ecoadd Lightning
```

#### `repadd` - Repository hinzufügen
Fügt ein Repository zu einem Ökosystem hinzu, optional mit Tags.
```lua
repadd Lightning https://github.com/lightningnetwork/lnd #protocol
repadd Lightning https://github.com/lightning/bolts #specification
```

**Verfügbare Tags:**
- `#protocol` - Kern-Protokoll-Implementierung
- `#sdk` - Software Development Kit
- `#developer-tool` - Entwickler-Werkzeug
- `#wallet` - Wallet-Software
- `#explorer` - Block-Explorer
- `#bridge` - Cross-Chain-Bridge
- Und viele mehr...

#### `ecocon` - Ökosysteme verbinden
Verbindet ein Ökosystem als Sub-Ökosystem eines anderen.
```lua
-- Macht Lightning zu einem Sub-Ökosystem von Bitcoin
ecocon Bitcoin Lightning
```

#### `ecodis` - Ökosysteme trennen
Trennt die Sub-Ökosystem-Beziehung.
```lua
ecodis Bitcoin Lightning
```

#### `ecomov` - Ökosystem umbenennen
Benennt ein Ökosystem um (nützlich bei Rebranding).
```lua
-- Elrond wurde zu MultiversX umbenannt
ecomov Elrond MultiversX
```

#### `ecorem` - Ökosystem entfernen
Entfernt ein Ökosystem vollständig.
```lua
ecorem AltesProjekt
```

#### `repmov` - Repository verschieben/umbenennen
Aktualisiert eine Repository-URL (wenn ein Projekt auf GitHub umzieht).
```lua
repmov https://github.com/alte/url https://github.com/neue/url
```

#### `reprem` - Repository entfernen
Entfernt ein Repository aus einem Ökosystem.
```lua
reprem Lightning https://github.com/some/old-repo
```

### Beispiel: Neues Ökosystem hinzufügen

1. Erstellen Sie eine neue Migrationsdatei:
```bash
migrations/2024-12-14T143000_add_polkadot
```

2. Fügen Sie Inhalt hinzu:
```lua
# Füge Polkadot-Ökosystem hinzu
ecoadd Polkadot

# Füge Haupt-Repositories hinzu
repadd Polkadot https://github.com/paritytech/polkadot #protocol
repadd Polkadot https://github.com/paritytech/substrate #framework
repadd Polkadot https://github.com/polkadot-js/apps #developer-tool

# Füge ein Sub-Ökosystem hinzu
ecoadd Kusama
ecocon Polkadot Kusama
repadd Kusama https://github.com/paritytech/polkadot #protocol
```

3. Validieren Sie Ihre Änderungen:
```bash
./run.sh validate
```

4. Wenn keine Fehler auftreten, committen Sie Ihre Migration!

## 🧪 Tests ausführen

Um die Unit-Tests auszuführen:
```bash
zig build test
```

## 📚 Funktions-Dokumentation

Für eine detaillierte Übersicht aller Funktionen im Code, siehe [FUNCTION_OVERVIEW.md](./FUNCTION_OVERVIEW.md).

Diese Datei erklärt **was in jeder Funktion ist** auf Deutsch und Englisch!

### Wichtige Funktionen kurz erklärt:

- **`Taxonomy.load()`** - Lädt alle Migrationsdateien
- **`Taxonomy.exportJson()`** - Exportiert Daten als JSON
- **`Taxonomy.eco()`** - Ruft Informationen über ein Ökosystem ab
- **`cmdValidate()`** - Validiert alle Migrationen
- **`cmdExport()`** - Exportiert die Taxonomie
- **`split()`** - Teilt Kommandozeilen-Strings in Token auf
- **`hasValidTimestamp()`** - Prüft Migrationsdatei-Zeitstempel

## 🤝 Wie Sie beitragen können

1. **Fork** das Repository
2. **Erstellen** Sie eine neue Migrationsdatei mit dem richtigen Zeitstempel-Format
3. **Fügen Sie** Ihre Änderungen mit DSL-Befehlen hinzu
4. **Testen** Sie mit `./run.sh validate`
5. **Committen** und erstellen Sie einen Pull Request

## 📝 Attribution

Dieses Repository ist unter der [MIT-Lizenz mit Attribution](LICENSE) lizenziert.

Um die Electric Capital Crypto Ecosystems Map in Ihrem Projekt zu verwenden, benötigen Sie eine Attribution mit 3 Komponenten:

1. **Quelle:** "Electric Capital Crypto Ecosystems"
2. **Link:** https://github.com/electric-capital/crypto-ecosystems
3. **Logo:** [Link zum Logo](static/electric_capital_logo_transparent.png)

**Beispiel-Attribution:**

Datenquelle: [Electric Capital Crypto Ecosystems](https://github.com/electric-capital/crypto-ecosystems)

Wenn Sie in Open-Source-Krypto arbeiten, reichen Sie Ihr Repository [hier](https://github.com/electric-capital/crypto-ecosystems) ein, um gezählt zu werden.

## 🔍 Häufig gestellte Fragen (FAQ)

### Was ist in dieser Funktion?
Siehe [FUNCTION_OVERVIEW.md](./FUNCTION_OVERVIEW.md) für eine detaillierte Erklärung aller Funktionen auf Deutsch und Englisch!

### Wie finde ich ein bestimmtes Ökosystem?
```bash
./run.sh export -e "Name des Ökosystems" output.jsonl
```

### Kann ich den Zustand von vor einem Jahr sehen?
Ja! Verwenden Sie die `--max-date` Option:
```bash
./run.sh export -m 2023-01-01 historic.jsonl
```

### Wie viele Ökosysteme gibt es?
Führen Sie aus:
```bash
./run.sh validate
```

### Welche Programmiersprache wird verwendet?
Das Projekt ist in [Zig](https://ziglang.org/) geschrieben, einer modernen Systemprogrammiersprache.

## 🎯 Projektstruktur

```
crypto-ecosystems/
├── src/
│   ├── main.zig          # Programm-Einstiegspunkt
│   ├── commands.zig      # CLI-Befehls-Handler
│   ├── taxonomy.zig      # Kern-Taxonomie-Logik
│   ├── shlex.zig         # String-Tokenizer
│   └── timestamp.zig     # Zeitstempel-Validierung
├── migrations/           # Alle Migrationsdateien
├── tests/               # Unit-Tests
├── build.zig            # Build-Konfiguration
├── run.sh              # Convenience-Script
├── README.md           # Englische README
├── README_DE.md        # Diese Datei (Deutsch)
└── FUNCTION_OVERVIEW.md # Funktions-Dokumentation
```

## 💡 Tipps & Tricks

1. **Kommentare verwenden:** Beginnen Sie Zeilen in Migrationen mit `#` für Kommentare
2. **Zeitstempel-Format:** YYYY-MM-DDTHHMMSS (ohne Doppelpunkte!)
3. **Strings mit Leerzeichen:** Verwenden Sie Anführungszeichen: `"Magic Eden Wallet"`
4. **Tags:** Beginnen Sie immer mit `#`: `#protocol` nicht `protocol`
5. **Validierung zuerst:** Führen Sie immer `validate` vor dem Export aus

## 🌟 Danke!

Vielen Dank, dass Sie zur Crypto-Ökosystem-Taxonomie beitragen! ❤️

Für weitere Fragen oder Hilfe, öffnen Sie bitte ein Issue auf GitHub.
