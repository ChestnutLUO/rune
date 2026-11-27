import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rune/utils/shortcut_label.dart';

void main() {
  const ctrlLeft = SingleActivator(LogicalKeyboardKey.arrowLeft, control: true);
  const altN = SingleActivator(LogicalKeyboardKey.keyN, alt: true);
  const ctrlAltS = SingleActivator(
    LogicalKeyboardKey.keyS,
    control: true,
    alt: true,
  );
  const f11 = SingleActivator(LogicalKeyboardKey.f11);

  test('iOS and macOS use the Apple symbols, with no Alt or Ctrl', () {
    for (final platform in [TargetPlatform.iOS, TargetPlatform.macOS]) {
      expect(shortcutLabel(altN, platform: platform), '⌥N');
      expect(shortcutLabel(ctrlLeft, platform: platform), '⌃←');
      expect(shortcutLabel(ctrlAltS, platform: platform), '⌃⌥S');
      expect(shortcutLabel(f11, platform: platform), 'F11');
    }
  });

  test('Apple order is control, option, shift, command', () {
    const all = SingleActivator(
      LogicalKeyboardKey.keyK,
      control: true,
      alt: true,
      shift: true,
      meta: true,
    );
    expect(shortcutLabel(all, platform: TargetPlatform.iOS), '⌃⌥⇧⌘K');
  });

  test('other platforms spell the modifiers out', () {
    for (final platform in [
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.android,
    ]) {
      expect(shortcutLabel(altN, platform: platform), 'Alt+N');
      expect(shortcutLabel(ctrlLeft, platform: platform), 'Ctrl+←');
      expect(shortcutLabel(ctrlAltS, platform: platform), 'Ctrl+Alt+S');
      expect(shortcutLabel(f11, platform: platform), 'F11');
    }
  });

  test('follows the running platform when none is given', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    expect(shortcutLabel(altN), '⌥N');
  });
}
