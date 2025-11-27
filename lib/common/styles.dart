import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colorExadecimal.dart';

final Color color = HexColor.fromHex('#262f69');
Color kPrimaryColor = const Color.fromARGB(255, 8, 87, 234);
Color kBackgroundColor = color;
Color kShadowColor = const Color(0xFFC0C0C0);

TextStyle kDefaultFont = GoogleFonts.poppins();

TextStyle kTitleTextStyle = GoogleFonts.poppins().copyWith(
  fontSize: 40,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

TextStyle kSubtitleTextStyle = kDefaultFont.copyWith(
  fontSize: 13,
  color: Colors.white,
  fontWeight: FontWeight.w300,
);

TextStyle kBoxSearchTextStyle = kDefaultFont.copyWith(
  fontSize: 14,
  color: kPrimaryColor,
  fontWeight: FontWeight.bold,
);

TextStyle kSectionTitleTextStyle = kDefaultFont.copyWith(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

TextStyle kMoreDetailsTextStyle = kDefaultFont.copyWith(
  fontSize: 16,
  color: kPrimaryColor,
  decoration: TextDecoration.underline,
);

TextStyle kSmallCardTextStyle = kDefaultFont.copyWith(
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

InputDecoration kDefaultInput = const InputDecoration(
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
);

var kCardShadow = [
  BoxShadow(
    offset: const Offset(4, 4),
    blurRadius: 4,
    color: kShadowColor,
  ),
  BoxShadow(
    offset: const Offset(-1, 0),
    color: kShadowColor,
  )
];

BoxDecoration kCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(15),
  boxShadow: kCardShadow,
);
