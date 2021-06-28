import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/bloc_theme/bloc_theme.dart';
import 'package:point_of_sale/bloc_theme/bloc_theme_event.dart';
import 'package:point_of_sale/screen/home_screen.dart';
import 'package:point_of_sale/widget/globle_drawer_widget.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GlobleDrawerWidget(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.close, size: 32, color: Colors.white),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/setting');
            },
          ),
        ],
        title: Text(
          "Theme",
          style: GoogleFonts.laila(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              BlocProvider.of<BlocTheme>(context).add(EventTheme.green());
            },
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey,
              color: Color.fromRGBO(76, 175, 80, 1),
              child: ListTile(
                leading: Icon(
                  Icons.color_lens_sharp,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  "Green Theme",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<BlocTheme>(context).add(EventTheme.red());
            },
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey,
              color: Colors.red,
              child: ListTile(
                leading: Icon(
                  Icons.color_lens_sharp,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  "Red Theme",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<BlocTheme>(context).add(EventTheme.blue());
            },
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey,
              color: Colors.blue,
              child: ListTile(
                leading: Icon(
                  Icons.color_lens_sharp,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  "Blue Theme",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<BlocTheme>(context).add(EventTheme.black());
            },
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey,
              color: Colors.black,
              child: ListTile(
                leading: Icon(
                  Icons.color_lens_sharp,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text("Black Theme",
                    style: GoogleFonts.laila(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white))),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<BlocTheme>(context).add(EventTheme.teal());
            },
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey,
              color: Colors.teal,
              child: ListTile(
                leading: Icon(
                  Icons.color_lens_sharp,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  "Teal Theme",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<BlocTheme>(context).add(EventTheme.tor());
            },
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey,
              color: Color.fromRGBO(159, 122, 94, 1),
              child: ListTile(
                leading: Icon(
                  Icons.color_lens_sharp,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  "Tortilla Theme",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
