import 'dart:async';
import 'package:employeemanagement/employee_dashboard.dart';
import 'package:employeemanagement/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';
var loggedin;
class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2),(){
      // ScreenNavigation();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Icon(Icons.person,size: 100,color: Colors.blue),
        ),
      ),
    );
  }

  // void ScreenNavigation() async{
  //   var pref = await SharedPreferences.getInstance();
  //   loggedin = pref.getBool("isloggedin");
  //   if(loggedin != null)
  //   {
  //     if(loggedin)
  //     {
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context)=>LoginPage()));
  //     }
  //     else
  //     {
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context)=>LoginPage()));
  //     }
  //   }
  //   else
  //   {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context)=>LoginPage()));
  //   }
  //
  // }
}

