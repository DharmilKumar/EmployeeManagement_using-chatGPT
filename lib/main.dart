import 'package:employeemanagement/splash.dart';
import 'package:flutter/material.dart';
import 'package:employeemanagement/login_page.dart';
import 'package:employeemanagement/registration_form.dart';
import 'package:employeemanagement/admin_dashboard.dart';
import 'package:employeemanagement/employee_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        if (settings.name == '/employee_dashboard') {
          final employeeId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => EmployeeDashboard(employeeId: employeeId),
          );
        }
      },
      routes: {
        '/splash':(context)=>splash(),
        '/': (context) => LoginPage(),
        '/registration_form': (context) => RegistrationForm(),
        '/admin_dashboard': (context) => AdminDashboard(),
      },
    );
  }
}