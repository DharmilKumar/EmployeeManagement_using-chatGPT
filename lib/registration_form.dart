import 'package:employeemanagement/login_page.dart';
import 'package:flutter/material.dart';
import 'package:employeemanagement/database_helper.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form field values
  String _employeeNumber = '';
  String _employeeName = '';
  String _email = '';
  String _password = '';
  String _contactNumber = '';
  String _gender = '';
  String _selectedCity = 'Surat';
  DateTime _selectedDate = DateTime.now();
  String _selectedDesignation = 'Project Manager';
  double _salary = 0.0;

  // List of cities and designations
  List<String> _cities = ['Surat', 'Valsad', 'Vapi', 'Navsari', 'Bardoli'];
  List<String> _designations = [
    'Project Manager',
    'Assistant Manager',
    'Sr. Developer',
    'Jr. Developer',
  ];

  // Function to show a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // Function to submit the form
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form values

      final employeeData = {
        'employeeNumber': _employeeNumber,
        'name': _employeeName,
        'email': _email,
        'password': _password,
        'contactNumber': _contactNumber,
        'gender': _gender,
        'city': _selectedCity,
        'dateOfBirth': _selectedDate.toIso8601String(),
        'designation': _selectedDesignation,
        'salary': _salary,
        'isApproved': 0, // New employee registration is not approved by default
      };

      final insertedId = await DatabaseHelper.instance.insertEmployee(employeeData);

      if (insertedId != null) {
        // Data inserted successfully
        final snackBar = SnackBar(content: Text('Employee registered successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
      } else {
        // Error occurred during data insertion
        final snackBar = SnackBar(content: Text('Error occurred while registering employee.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Employee Number',prefixIcon: Icon(Icons.add_circle_outline)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter employee number';
                  }
                  return null;
                },
                onSaved: (value) => _employeeNumber = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Employee Name',prefixIcon: Icon(Icons.drive_file_rename_outline)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter employee name';
                  }
                  return null;
                },
                onSaved: (value) => _employeeName = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email',prefixIcon: Icon(Icons.email)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  // Add email validation if needed
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password',prefixIcon: Icon(Icons.password)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Number',prefixIcon: Icon(Icons.numbers)),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  // Add contact number validation if needed
                  return null;
                },
                onSaved: (value) => _contactNumber = value!,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Gender: '),
                  Radio(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value!;
                  });
                },
                items: _cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'City'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Date of Birth: '),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDesignation,
                onChanged: (value) {
                  setState(() {
                    _selectedDesignation = value!;
                  });
                },
                items: _designations.map((designation) {
                  return DropdownMenuItem<String>(
                    value: designation,
                    child: Text(designation),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Designation'),
              ),
              SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Salary'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter salary';
                  }
                  // Add salary validation if needed
                  return null;
                },
                onSaved: (value) => _salary = double.parse(value!),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
