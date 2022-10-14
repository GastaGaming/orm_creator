import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kSupportedFileformats = ["jpg", "png", "tga", "bmp"];
const kAlbedoSuffixList = [
  "_BaseColor",
  "_Albedo",
  "_Diffuse",
  "_AlbedoMap",
  "_BaseColorMap",
  "_DiffuseMap",
  "_AlbedoTexture",
  "_BaseColorTexture",
  "_DiffuseTexture"
];

const kRoughnessSuffixList = [
  "_Roughness",
  "_RoughnessMap",
  "_RoughnessTexture"
];

const kMetallicSuffixList = ["_Metallic", "_MetallicMap", "_MetallicTexture"];

const kAmbientOcclusionSuffixList = [
  "_AmbientOcclusion",
  "_AmbientOcclusionMap",
  "_AmbientOcclusionTexture"
];

const kDefaultPadding = EdgeInsets.all(20.0);

const kColorMainDarkBg = Color(0xff01161e);
const kColorMainLightBg = Color(0xfffeaeae);
const kColorHiqhlight = Color(0xffff3366);
const kColorLogoBlue = Color(0xff3379ff);
const kColorOldMainLogo = Color(0xff449dd1);
const kColorTextColor = Color(0xff000000);
const kColorTextLight = Color(0xfffffffa);

Map<int, Color> getSwatch(Color color) {
  final hslCoolor = HSLColor.fromColor(color);
  final lightness = hslCoolor.lightness;
  const lowDivisor = 6;
  const hiqhDivisor = 5;
  final lowStep = (1.0 - lightness) / lowDivisor;
  final hiqhStep = lightness / hiqhDivisor;
  return {
    50: (hslCoolor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslCoolor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslCoolor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslCoolor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslCoolor.withLightness(lightness + lowStep)).toColor(),
    500: (hslCoolor.withLightness(lightness)).toColor(),
    600: (hslCoolor.withLightness(lightness - hiqhStep)).toColor(),
    700: (hslCoolor.withLightness(lightness - (hiqhStep * 2))).toColor(),
    800: (hslCoolor.withLightness(lightness - (hiqhStep * 3))).toColor(),
    900: (hslCoolor.withLightness(lightness - (hiqhStep * 4))).toColor(),
  };
}

MaterialColor kPolygonOasisDarkMaterial =
    MaterialColor(kColorMainDarkBg.value, getSwatch(kColorMainDarkBg));

MaterialColor kPolygonOasisLightMaterial =
    MaterialColor(kColorMainLightBg.value, getSwatch(kColorMainLightBg));

MaterialColor kPolygonOasisHighlightMaterial =
    MaterialColor(kColorHiqhlight.value, getSwatch(kColorHiqhlight));

MaterialColor kPolygonOasisBlueMaterial =
    MaterialColor(kColorLogoBlue.value, getSwatch(kColorLogoBlue));

final ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20, color: Colors.white));

ThemeData cPolygonOasisTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,

  textTheme: TextTheme(
    headline1: const TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline6: const TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
    bodyText2: TextStyle(
      fontSize: 14.0,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),
  ),
  //iconTheme: IconThemeData(color: Colors.white),
  primarySwatch: kPolygonOasisBlueMaterial,
  brightness: Brightness.dark,

  //Dark appbar theme
  appBarTheme: const AppBarTheme(
    color: kColorMainDarkBg,
    brightness: Brightness.dark,
    elevation: 0,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: kColorTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
);

class KLogo extends StatelessWidget {
  const KLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Polygon ',
          style: TextStyle(
            fontFamily: GoogleFonts.audiowide().fontFamily,
            fontSize: 24,
            color: kColorTextLight,
          ),
        ),
        Text(
          'Oasis',
          style: TextStyle(
            fontFamily: GoogleFonts.audiowide().fontFamily,
            fontSize: 24,
            color: kColorLogoBlue,
          ),
        ),
      ],
    );
  }
}

// Widget that contains text "ORM Creator" and logo, "ORM" writen in hiqhligh color and "Creator" on white
class KLogoAndText extends StatelessWidget {
  const KLogoAndText({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'ORM',
          style: TextStyle(
            fontFamily: GoogleFonts.audiowide().fontFamily,
            fontSize: 24,
            color: kColorHiqhlight,
          ),
        ),
        Text(
          ' Creator |',
          style: TextStyle(
            fontFamily: GoogleFonts.audiowide().fontFamily,
            fontSize: 24,
            color: kColorTextLight,
          ),
        ),
        const SizedBox(width: 10),
        KLogo(),
      ],
    );
  }
}
