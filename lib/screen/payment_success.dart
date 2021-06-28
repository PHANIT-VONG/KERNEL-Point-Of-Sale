import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/screen/sale_group_screen.dart';
import 'package:point_of_sale/screen/table_group_screen.dart';

class PaymentSuccess extends StatefulWidget {
  final String status;
  final String mess;
  PaymentSuccess(this.mess, this.status);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], borderRadius: BorderRadius.circular(10), color: Colors.white),
          width: 300,
          height: 300,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    widget.mess,
                    style: GoogleFonts.lato(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: widget.status == "T"
                        ? Colors.lightGreen
                        : Colors.white),
                child: widget.status == "T"
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 90,
                      )
                    : Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 130,
                      ),
              ),
              SizedBox(height: 50),
              Container(
                width: 85,
                height: 45,
                child: FlatButton(
                  color: Colors.lightGreen,
                  child: widget.status == "T"
                      ? Center(
                          child: Text(
                            "Done",
                            style: GoogleFonts.lato(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Center(
                          child: Text(
                            "OK",
                            style: GoogleFonts.lato(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ),
                  onPressed: () async {
                    dynamic sys = await FlutterSession().get('systemType');
                    if (widget.status == "T") {
                      if (sys == "krms") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TableGroupScreen(),
                            ),
                            (route) => false);
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SaleGroupScreen(type: "G1"),
                            ),
                            (route) => false);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
