import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PosListTile extends StatelessWidget {
  // final standard datatype
  final IconData leading;
  final String title;
  final String subTitle;
  final IconData trailing;
  final Function action;

  // {} optional paramater
  PosListTile({
    this.leading,
    this.title,
    this.subTitle,
    this.trailing,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leading,
        size: 28,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: GoogleFonts.laila(
          textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
      ),
      subtitle: Text(
        subTitle,
        style: GoogleFonts.laila(
          textStyle: TextStyle(fontSize: 15.0, color: Colors.grey[600]),
        ),
      ),
      trailing: Icon(
        trailing,
        size: 17,
      ),
      onTap: action,
    );
  }
}
