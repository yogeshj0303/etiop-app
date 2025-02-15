import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4288938020),
      surfaceTint: Color(4290643500),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4292815168),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4288952895),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294938769),
      onSecondaryContainer: Color(4283564045),
      tertiary: Color(4286333184),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4289879808),
      onTertiaryContainer: Color(4294967295),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294965495),
      onSurface: Color(4280817431),
      onSurfaceVariant: Color(4284235839),
      outline: Color(4287655790),
      outlineVariant: Color(4293180860),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282264619),
      inversePrimary: Color(4294947762),
      primaryFixed: Color(4294957785),
      onPrimaryFixed: Color(4282449928),
      primaryFixedDim: Color(4294947762),
      onPrimaryFixedVariant: Color(4287758367),
      secondaryFixed: Color(4294957785),
      onSecondaryFixed: Color(4282449928),
      secondaryFixedDim: Color(4294947762),
      onSecondaryFixedVariant: Color(4286849578),
      tertiaryFixed: Color(4294958275),
      onTertiaryFixed: Color(4281275648),
      tertiaryFixedDim: Color(4294948735),
      onTertiaryFixedVariant: Color(4285413632),
      surfaceDim: Color(4294038482),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963439),
      surfaceContainer: Color(4294961640),
      surfaceContainerHigh: Color(4294959584),
      surfaceContainerHighest: Color(4294630362),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4287299613),
      surfaceTint: Color(4290643500),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4292815168),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4286520870),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4290858835),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4285084928),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4289879808),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965495),
      onSurface: Color(4280817431),
      onSurfaceVariant: Color(4283907131),
      outline: Color(4285945687),
      outlineVariant: Color(4287918962),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282264619),
      inversePrimary: Color(4294947762),
      primaryFixed: Color(4292815168),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4290379818),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4290858835),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4288755517),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4289879808),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4287515136),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4294038482),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963439),
      surfaceContainer: Color(4294961640),
      surfaceContainerHigh: Color(4294959584),
      surfaceContainerHighest: Color(4294630362),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4283236363),
      surfaceTint: Color(4290643500),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287299613),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4283236363),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4286520870),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281932288),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285084928),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965495),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4281671197),
      outline: Color(4283907131),
      outlineVariant: Color(4283907131),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282264619),
      inversePrimary: Color(4294960869),
      primaryFixed: Color(4287299613),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284547089),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4286520870),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284417042),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285084928),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282917632),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4294038482),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963439),
      surfaceContainer: Color(4294961640),
      surfaceContainerHigh: Color(4294959584),
      surfaceContainerHighest: Color(4294630362),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294947762),
      surfaceTint: Color(4294947762),
      onPrimary: Color(4285005843),
      primaryContainer: Color(4292683839),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4294947762),
      onSecondary: Color(4284811286),
      secondaryContainer: Color(4286257955),
      onSecondaryContainer: Color(4294952902),
      tertiary: Color(4294948735),
      onTertiary: Color(4283311616),
      tertiaryContainer: Color(4289682688),
      onTertiaryContainer: Color(4294967295),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4280160015),
      onSurface: Color(4294630362),
      onSurfaceVariant: Color(4293180860),
      outline: Color(4289431687),
      outlineVariant: Color(4284235839),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294630362),
      inversePrimary: Color(4290643500),
      primaryFixed: Color(4294957785),
      onPrimaryFixed: Color(4282449928),
      primaryFixedDim: Color(4294947762),
      onPrimaryFixedVariant: Color(4287758367),
      secondaryFixed: Color(4294957785),
      onSecondaryFixed: Color(4282449928),
      secondaryFixedDim: Color(4294947762),
      onSecondaryFixedVariant: Color(4286849578),
      tertiaryFixed: Color(4294958275),
      onTertiaryFixed: Color(4281275648),
      tertiaryFixedDim: Color(4294948735),
      onTertiaryFixedVariant: Color(4285413632),
      surfaceDim: Color(4280160015),
      surfaceBright: Color(4282922036),
      surfaceContainerLowest: Color(4279831050),
      surfaceContainerLow: Color(4280817431),
      surfaceContainer: Color(4281080603),
      surfaceContainerHigh: Color(4281804069),
      surfaceContainerHighest: Color(4282593328),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294949304),
      surfaceTint: Color(4294947762),
      onPrimary: Color(4281794566),
      primaryContainer: Color(4294922845),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294949304),
      onSecondary: Color(4281794566),
      secondaryContainer: Color(4293225069),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294950282),
      onTertiary: Color(4280750080),
      tertiaryContainer: Color(4292311325),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4280160015),
      onSurface: Color(4294965753),
      onSurfaceVariant: Color(4293509568),
      outline: Color(4290747033),
      outlineVariant: Color(4288510842),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294630362),
      inversePrimary: Color(4287954976),
      primaryFixed: Color(4294957785),
      onPrimaryFixed: Color(4281139204),
      primaryFixedDim: Color(4294947762),
      onPrimaryFixedVariant: Color(4285726742),
      secondaryFixed: Color(4294957785),
      onSecondaryFixed: Color(4281139204),
      secondaryFixedDim: Color(4294947762),
      onSecondaryFixedVariant: Color(4285337627),
      tertiaryFixed: Color(4294958275),
      onTertiaryFixed: Color(4280290304),
      tertiaryFixedDim: Color(4294948735),
      onTertiaryFixedVariant: Color(4283837184),
      surfaceDim: Color(4280160015),
      surfaceBright: Color(4282922036),
      surfaceContainerLowest: Color(4279831050),
      surfaceContainerLow: Color(4280817431),
      surfaceContainer: Color(4281080603),
      surfaceContainerHigh: Color(4281804069),
      surfaceContainerHighest: Color(4282593328),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294965753),
      surfaceTint: Color(4294947762),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294949304),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965753),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294949304),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294966008),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294950282),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4280160015),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965753),
      outline: Color(4293509568),
      outlineVariant: Color(4293509568),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294630362),
      inversePrimary: Color(4284219408),
      primaryFixed: Color(4294959326),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294949304),
      onPrimaryFixedVariant: Color(4281794566),
      secondaryFixed: Color(4294959326),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4294949304),
      onSecondaryFixedVariant: Color(4281794566),
      tertiaryFixed: Color(4294959565),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294950282),
      onTertiaryFixedVariant: Color(4280750080),
      surfaceDim: Color(4280160015),
      surfaceBright: Color(4282922036),
      surfaceContainerLowest: Color(4279831050),
      surfaceContainerLow: Color(4280817431),
      surfaceContainer: Color(4281080603),
      surfaceContainerHigh: Color(4281804069),
      surfaceContainerHighest: Color(4282593328),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
