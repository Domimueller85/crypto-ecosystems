const std = @import("std");

/// Splits a command-line string into tokens, similar to shell parsing.
/// Handles quoted strings (both single and double quotes) and escape sequences.
///
/// This function tokenizes input similar to how a shell would parse command-line arguments:
/// - Whitespace separates tokens
/// - Quoted strings (with " or ') preserve spaces
/// - Backslash (\) escapes the next character
/// - Quotes within quotes can be escaped
///
/// Parameters:
///   - line: The input string to tokenize
///   - tokens: Output array to store parsed tokens (must be pre-allocated)
///
/// Returns:
///   The number of tokens parsed (may be less than tokens.len)
///
/// Errors:
///   - error.UnterminatedQuote: If a quoted string is not properly closed
///
/// Example:
///   ```
///   var tokens: [3]?[]const u8 = undefined;
///   const count = try split("hello \"world test\"", &tokens);
///   // tokens[0] = "hello", tokens[1] = "world test", count = 2
///   ```
///
/// DEUTSCH:
/// Teilt einen Kommandozeilen-String in Token auf, ähnlich wie Shell-Parsing.
/// Behandelt Strings in Anführungszeichen (einfach und doppelt) und Escape-Sequenzen.
///
/// Diese Funktion tokenisiert Eingaben ähnlich wie eine Shell Kommandozeilen-Argumente parsen würde:
/// - Leerzeichen trennen Token
/// - Strings in Anführungszeichen (mit " oder ') bewahren Leerzeichen
/// - Backslash (\) maskiert das nächste Zeichen
/// - Anführungszeichen innerhalb von Anführungszeichen können maskiert werden
///
/// Parameter:
///   - line: Der zu tokenisierende Eingabe-String
///   - tokens: Ausgabe-Array zum Speichern der geparsten Token (muss vorab allokiert sein)
///
/// Rückgabewert:
///   Die Anzahl der geparsten Token (kann kleiner als tokens.len sein)
///
/// Fehler:
///   - error.UnterminatedQuote: Wenn ein String in Anführungszeichen nicht ordentlich geschlossen wird
///
/// Beispiel:
///   ```
///   var tokens: [3]?[]const u8 = undefined;
///   const count = try split("hello \"world test\"", &tokens);
///   // tokens[0] = "hello", tokens[1] = "world test", count = 2
///   ```
pub fn split(line: []const u8, tokens: []?[]const u8) !usize {
    var token_count: usize = 0;
    var i: usize = 0;
    var start: usize = 0;

    while (i < line.len and token_count < tokens.len) : (i += 1) {
        while (i < line.len and std.ascii.isWhitespace(line[i])) {
            i += 1;
        }
        if (i >= line.len) break;

        if (line[i] == '"' or line[i] == '\'') {
            const quote = line[i];
            start = i;
            i += 1;

            while (i < line.len and line[i] != quote) {
                if (line[i] == '\\' and i + 1 < line.len) {
                    i += 1;
                }
                i += 1;
            }

            if (i >= line.len) return error.UnterminatedQuote;
            tokens[token_count] = stripEscapes(line[start + 1 .. i]);
            token_count += 1;
        } else {
            start = i;

            while (i < line.len and !std.ascii.isWhitespace(line[i])) {
                if (line[i] == '\\' and i + 1 < line.len) {
                    i += 1;
                }
                i += 1;
            }

            tokens[token_count] = stripEscapes(line[start..i]);
            token_count += 1;
            i -= 1;
        }
    }

    return token_count;
}

/// Removes escape sequences from a string by processing backslash-escaped characters.
/// If no escape sequences are found, returns the original string unchanged.
///
/// DEUTSCH:
/// Entfernt Escape-Sequenzen aus einem String durch Verarbeitung von Backslash-maskierten Zeichen.
/// Wenn keine Escape-Sequenzen gefunden werden, gibt den Original-String unverändert zurück.
fn stripEscapes(input: []const u8) []const u8 {
    var has_escapes = false;
    for (input, 0..) |c, idx| {
        if (c == '\\' and idx + 1 < input.len) {
            has_escapes = true;
            break;
        }
    }
    if (!has_escapes) return input;

    const allocator = std.heap.page_allocator;
    var result = allocator.alloc(u8, input.len) catch return input;
    var j: usize = 0;

    var i: usize = 0;
    while (i < input.len) : (i += 1) {
        if (input[i] == '\\' and i + 1 < input.len) {
            i += 1;
            result[j] = input[i];
            j += 1;
        } else {
            result[j] = input[i];
            j += 1;
        }
    }

    return result[0..j];
}

test "basic tokenization" {
    var line_buf = "hello world test".*;
    var tokens: [4]?[]const u8 = .{null} ** 4;
    const count = try split(&line_buf, &tokens);

    try std.testing.expectEqual(@as(usize, 3), count);
    try std.testing.expectEqualStrings("hello", tokens[0].?);
    try std.testing.expectEqualStrings("world", tokens[1].?);
    try std.testing.expectEqualStrings("test", tokens[2].?);
}

test "quoted strings" {
    var line_buf = "command \"quoted string\" 'single'".*;
    var tokens: [3]?[]const u8 = .{null} ** 3;
    const count = try split(&line_buf, &tokens);

    try std.testing.expectEqual(@as(usize, 3), count);
    try std.testing.expectEqualStrings("command", tokens[0].?);
    try std.testing.expectEqualStrings("quoted string", tokens[1].?);
    try std.testing.expectEqualStrings("single", tokens[2].?);
}

test "escaped characters" {
    var line_buf = "escaped\\ space \"quoted\\\"quote\"".*;
    var tokens: [2]?[]const u8 = .{null} ** 2;
    const count = try split(&line_buf, &tokens);

    try std.testing.expectEqual(@as(usize, 2), count);
    try std.testing.expectEqualStrings("escaped space", tokens[0].?);
    try std.testing.expectEqualStrings("quoted\"quote", tokens[1].?);
}

test "unterminated quote" {
    var line_buf = "\"unterminated".*;
    var tokens: [1]?[]const u8 = .{null} ** 1;
    try std.testing.expectError(error.UnterminatedQuote, split(&line_buf, &tokens));
}

test "internal quotes" {
    var line_buf = "repadd \"Mckee's Rocks\" https://blah.com".*;
    var tokens: [3]?[]const u8 = .{null} ** 3;
    const count = try split(&line_buf, &tokens);
    try std.testing.expectEqual(@as(usize, 3), count);
    try std.testing.expectEqualStrings("repadd", tokens[0].?);
    try std.testing.expectEqualStrings("Mckee's Rocks", tokens[1].?);
    try std.testing.expectEqualStrings("https://blah.com", tokens[2].?);
}
