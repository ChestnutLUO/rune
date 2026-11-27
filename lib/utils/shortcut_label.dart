import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Whether [platform] writes shortcuts the Apple way: modifier symbols
/// (⌃ ⌥ ⇧ ⌘) run together with the key, as on a Mac or an iPad keyboard,
/// which have no keys printed "Ctrl" or "Alt".
bool usesAppleShortcutGlyphs(TargetPlatform platform) =>
    platform == TargetPlatform.macOS || platform == TargetPlatform.iOS;

/// The text a menu shows for [activator] on [platform] (the running one when
/// left out).
///
/// On macOS and iOS this follows Apple's order and symbols, so Ctrl+Alt+S
/// reads "⌃⌥S"; elsewhere modifiers are spelled out and joined with "+", as
/// in "Ctrl+Alt+S".
String shortcutLabel(SingleActivator activator, {TargetPlatform? platform}) {
  final target = platform ?? defaultTargetPlatform;
  final apple = usesAppleShortcutGlyphs(target);
  final key = _keyLabel(activator.trigger, apple: apple);

  if (apple) {
    return [
      if (activator.control) '⌃',
      if (activator.alt) '⌥',
      if (activator.shift) '⇧',
      if (activator.meta) '⌘',
      key,
    ].join();
  }

  return [
    if (activator.control) 'Ctrl',
    if (activator.alt) 'Alt',
    if (activator.shift) 'Shift',
    if (activator.meta) target == TargetPlatform.windows ? 'Win' : 'Meta',
    key,
  ].join('+');
}

String _keyLabel(LogicalKeyboardKey key, {required bool apple}) {
  if (key == LogicalKeyboardKey.arrowLeft) return '←';
  if (key == LogicalKeyboardKey.arrowRight) return '→';
  if (key == LogicalKeyboardKey.arrowUp) return '↑';
  if (key == LogicalKeyboardKey.arrowDown) return '↓';
  if (key == LogicalKeyboardKey.space) return 'Space';
  if (key == LogicalKeyboardKey.escape) return apple ? '⎋' : 'Esc';
  if (key == LogicalKeyboardKey.enter) return apple ? '↩' : 'Enter';
  if (key == LogicalKeyboardKey.backspace) return apple ? '⌫' : 'Backspace';
  if (key == LogicalKeyboardKey.tab) return apple ? '⇥' : 'Tab';
  return key.keyLabel.toUpperCase();
}
