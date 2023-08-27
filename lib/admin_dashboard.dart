import 'package:flutter/material.dart';
import 'package:employeemanagement/database_helper.dart';
import 'employee_details_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>> _registrationRequests = [];
  List<Map<String, dynamic>> _employeesWithDetails = [];

  @override
  void initState() {
    super.initState();
    _loadRegistrationRequests();
    _loadEmployeesWithDetails();
  }

  Future<void> _loadRegistrationRequests() async {
    final requests = await DatabaseHelper.instance.getPendingRegistrationRequests();
    setState(() {
      _registrationRequests = requests;
    });
  }

  Future<void> _loadEmployeesWithDetails() async {
    final employees = await DatabaseHelper.instance.getAllEmployees(); // Fetch all registered employees
    setState(() {
      _employeesWithDetails = employees;
    });
  }

  Future<void> _approveRequest(int id) async {
    await DatabaseHelper.instance.updateEmployeeApproval(id, true);
    await _loadRegistrationRequests();
  }

  Future<void> _rejectRequest(int id) async {
    await DatabaseHelper.instance.updateEmployeeApproval(id, false);
    await _loadRegistrationRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _registrationRequests.length,
        itemBuilder: (context, index) {
          final request = _registrationRequests[index];
          final name = request['name'] ?? 'Unknown Employee';
          final designation = request['designation'] ?? 'Unknown Designation';
          final id = request['id'];

          return ListTile(
            title: Text(name),
            subtitle: Text(designation),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => _approveRequest(id),
                  child: Text('Approve'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _rejectRequest(id),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Reject'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeDetailsScreen(employeeId: id),
                      ),
                    );
                  },
                  child: Text('Details'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_employeesWithDetails.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeesListScreen(employees: _employeesWithDetails),
              ),
            );
          } else {
            final snackBar = SnackBar(content: Text('No employees with details available.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Icon(Icons.details),
      ),
    );
  }
}

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
