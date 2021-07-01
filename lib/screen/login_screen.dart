import 'dart:async';
import 'dart:ui';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/controller/account_loging_controller.dart';
import 'package:point_of_sale/controller/local_currency_controller.dart';
import 'package:point_of_sale/modal/account_loging.dart';
import 'package:point_of_sale/modal/branch_modal.dart';
import 'package:point_of_sale/modal/return_from_server_login.dart';
import 'package:point_of_sale/screen/home_screen.dart';
import 'package:point_of_sale/widget/style_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _showPassword = false;
  bool _obscureText = true;
  bool _colorUsername = true;
  bool _colorBranch = true;
  bool _withBranch = true;
  bool _withUsername = true;
  bool _colorPass = true;
  bool _withPass = true;
  bool _valid = false;
  String two;
  int _selectedBranch;
  List<Branch> lsBranch = [];
  TextEditingController _username = new TextEditingController();
  TextEditingController _pass = new TextEditingController();

  Timer timer;
  double progress;

  Widget _builBranch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Branch',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFF689F38),
            border: Border.all(
              color: _colorBranch
                  ? Color(0xFF689F38)
                  : Colors.red, //                   <--- border color
              width: _withBranch ? 0.0 : 2.0,
            ),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 60.0,
          child: Stack(
            children: [
              DropdownButtonFormField(
                dropdownColor: Colors.white,
                elevation: 0,
                iconSize: 35,
                isExpanded: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                hint: Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Text(
                    "Select your branch",
                    style: kHintTextStyle,
                  ),
                ),
                value: _selectedBranch,
                onChanged: (value) {
                  setState(() {
                    _selectedBranch = value;
                  });
                },
                items: lsBranch.map((branch) {
                  return DropdownMenuItem(
                    value: branch.branId,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: Text(branch.branName),
                    ),
                  );
                }).toList(),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, left: 8.0),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        _colorBranch == false
            ? Text(
                "branch is required !",
                style: GoogleFonts.laila(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              )
            : Text("")
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          height: 50.0,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _colorUsername
                  ? Color(0xFF689F38)
                  : Colors.red, //  <--- border color
              width: _withUsername ? 0.0 : 1,
            ),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _username,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              hintText: 'Enter your username',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(height: 5),
        _colorUsername == false
            ? Text(
                "username is required !",
                style: GoogleFonts.laila(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              )
            : Text("")
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          height: 50.0,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _colorPass
                  ? Color(0xFF689F38)
                  : Colors.red, //                   <--- border color
              width: _withPass ? 0.0 : 1,
            ),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _pass,
            obscureText: _obscureText,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.remove_red_eye : Icons.visibility_off,
                  color: _showPassword ? Colors.green : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    if (_showPassword) {
                      _showPassword = false;
                    } else {
                      _showPassword = true;
                    }
                    if (_obscureText) {
                      _obscureText = false;
                    } else {
                      _obscureText = true;
                    }
                  });
                },
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(height: 5),
        _colorPass == false
            ? Text(
                "password is required !",
                style: GoogleFonts.laila(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              )
            : Text("")
      ],
    );
  }

  Widget _buildForgotPasswordBTN() {
    return Container(
      padding: EdgeInsets.only(right: 0.0),
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBTN() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: MaterialButton(
        elevation: 5.0,
        color: Colors.white,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.green,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        onPressed: () async {
          // if (_selectedBranch == null) {
          //   setState(() {
          //     _colorBranch = false;
          //     _withPass = false;
          //   });
          //   return;
          // } else {
          //   setState(() {
          //     _colorBranch = true;
          //     _withPass = true;
          //   });
          // }
          if (_username.text.trim() == "") {
            setState(() {
              _colorUsername = false;
              _withUsername = false;
            });
            return;
          } else {
            setState(() {
              _colorUsername = true;
              _withUsername = true;
            });
          }
          if (_pass.text.trim() == "") {
            setState(() {
              _colorPass = false;
              _withPass = false;
            });
            return;
          } else {
            setState(() {
              _colorPass = true;
              _withPass = true;
            });
          }
          showAlertDialog(context);
          await Future.delayed(Duration(seconds: 2));
          bool result = await DataConnectionChecker().hasConnection;
          if (result) {
            AccountLogin acc = new AccountLogin(
              //branchId: _selectedBranch,
              password: _pass.text.trim(),
              userName: _username.text.trim(),
            );
            ReturnFromServerLogin status = await LoginController().login(acc);
            if (status != null) {
              if (!status.statusLogin) {
                setState(() {
                  _valid = true;
                  two = 'U';
                });
                Navigator.pop(context);
              } else if (!status.permission) {
                setState(() {
                  _valid = true;
                  two = 'V';
                });
                Navigator.pop(context);
              } else if (status.permission && status.statusLogin) {
                var local =
                    await LocalCurrencyController.eachLocal(status.userId);
                print(local);
                FlutterSession().set("localCurr", local.rate);
                FlutterSession().set("systemType", 'krms');
                FlutterSession().set("userId", status.userId);
                FlutterSession().set("branchId", status.branchId);
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                  (route) => true,
                );
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No Internet Connection !')),
            );
          }
        },
      ),
    );
  }

  Widget _buildVilidPassEmail() {
    return Center(
      child: two == 'U'
          ? Text(
              "Username or password is valid !",
              style: GoogleFonts.laila(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            )
          : Text(
              "User is not permission",
              style: GoogleFonts.laila(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
    );
  }

  @override
  // ignore: must_call_super
  void initState() {
    // BranchController.eachBranch().then((value) {
    //   if (mounted) {
    //     setState(() {
    //       lsBranch = value;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF689F38),
                      Color(0xFF689F38),
                      Color(0xFF689F38),
                      Color(0xFF689F38),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 25),
                      Icon(
                        Icons.account_circle_rounded,
                        size: 130,
                        color: Colors.white,
                      ),
                      // Container(
                      //   height: 100,
                      //   width: 100,
                      //   child: Center(
                      //     child: Image.asset('images/poskernel.jpg',
                      //         fit: BoxFit.cover),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // Text(
                      //   'SIGN IN',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontFamily: 'OpenSans',
                      //     fontSize: 30.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      SizedBox(height: 45.0),
                      //_builBranch(),
                      _buildEmailTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTF(),
                      _buildForgotPasswordBTN(),
                      _buildRememberMeCheckbox(),
                      _buildLoginBTN(),
                      _valid ? _buildVilidPassEmail() : Text("")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Container(
          width: 130.0,
          height: 92.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(
                  "Loading...",
                  style: GoogleFonts.laila(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
