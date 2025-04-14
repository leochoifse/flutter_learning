import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      //bottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static ThemeData get darkTheme {
    //bottomSheet
    return ThemeData.dark().copyWith(
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
