import 'package:flutter/material.dart';
import 'package:employeemanagement/database_helper.dart';
import 'leave_management_screen.dart'; // Import the screen for managing leaves

class EmployeeDetailsScreen extends StatefulWidget {
  final int employeeId;
  EmployeeDetailsScreen({required this.employeeId});

  @override
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  late Map<String, dynamic> _employeeData;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    final employeeData = await DatabaseHelper.instance.getEmployeeById(widget.employeeId);
    setState(() {
      _employeeData = employeeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Employee Name: ${_employeeData['name']}'),
            SizedBox(height: 16),
            Text('Employee Designation: ${_employeeData['designation']}'),
            SizedBox(height: 16),
            Text('Employee Salary: \$${_employeeData['salary']}'),
            SizedBox(height: 16),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeavesManagementScreen(employee: _employeeData),
                    ),
                  ),
                  child: Text('Manage Leaves'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _updateSalary(_employeeData['salary'] + 100),
                  child: Text('Increase Salary'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _updateSalary(_employeeData['salary'] - 100),
                  child: Text('Decrease Salary'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateSalary(double newSalary) async {
    await DatabaseHelper.instance.updateEmployeeSalary(widget.employeeId, newSalary);
    await _loadEmployeeData();
  }
}
