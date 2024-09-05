// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabelItemsText extends StatelessWidget {
  String text;
  Color textColor;
  double fontsize;
  TabelItemsText(
      {super.key,
      required this.text,
      required this.textColor,
      required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Text(
        text,
        style: GoogleFonts.robotoFlex(
            color: textColor, fontSize: fontsize, fontWeight: FontWeight.w600),
      ),
    );
  }
}
