import 'package:flutter/material.dart';
import 'package:employeemanagement/database_helper.dart';
import 'package:employeemanagement/registration_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  void _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      if (email == 'admin' && password == 'admin') {
        // Navigate to admin dashboard
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
        return;
      }

      final employee = await DatabaseHelper.instance.getEmployeeByEmail(email);

      if (employee != null &&
          employee['password'] == password &&
          employee['isApproved'] == 1) {
        var pref = await SharedPreferences.getInstance();
        pref.setBool("isloggedin", true);
        pref.setString("email", email);
        // Navigate to employee dashboard
        final int employeeId = employee['id']; // Extract the employeeId from the employee data
        Navigator.pushReplacementNamed(context, '/employee_dashboard', arguments: employeeId);
      } else {
        setState(() {
          _errorMessage = 'Invalid credentials or employee not approved.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email',prefixIcon: Icon(Icons.email)),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter email';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password',prefixIcon: Icon(Icons.password)),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter password';
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleLogin,
                child: Text('Login'),
              ),
              SizedBox(height: 8),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationForm()));
                },
                child: Text('Register New Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
