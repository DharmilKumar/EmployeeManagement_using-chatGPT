import 'package:flutter/material.dart';
import 'employee_details_screen.dart';

class EmployeesListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> employees;

  EmployeesListScreen({required this.employees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees List'),
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          final name = employee['name'] ?? 'Unknown Employee';
          final designation = employee['designation'] ?? 'Unknown Designation';
          final id = employee['id'];

          return ListTile(
            title: Text(name),
            subtitle: Text(designation),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeDetailsScreen(employeeId: id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
