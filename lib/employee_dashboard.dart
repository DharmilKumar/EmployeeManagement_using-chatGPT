import 'package:flutter/material.dart';
import 'package:employeemanagement/leaves_database_helper.dart';

class EmployeeDashboard extends StatefulWidget {
  final int employeeId;
  EmployeeDashboard({required this.employeeId});
  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  List<Map<String, dynamic>> _leaveApplications = [];// List to store leave applications

  @override
  void initState() {
    super.initState();
    _fetchLeaveApplications(); // Fetch leave applications when the widget is created
  }

  Future<void> _fetchLeaveApplications() async {
    // Fetch both approved and pending leave applications
    final leaveApplications = await LeavesDatabaseHelper.instance
        .getLeaveApplications(widget.employeeId);
    setState(() {
      _leaveApplications = leaveApplications;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context, _selectedStartDate),
                child: Text('Select Start Date'),
              ),
              SizedBox(height: 16),
              Text(
                _selectedStartDate != null
                    ? 'Start Date: ${_selectedStartDate!.toLocal()}'
                        .split(' ')[0]
                    : 'Select a start date',
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _selectDate(context, _selectedEndDate),
                child: Text('Select End Date'),
              ),
              SizedBox(height: 16),
              Text(
                _selectedEndDate != null
                    ? 'End Date: ${_selectedEndDate!.toLocal()}'.split(' ')[0]
                    : 'Select an end date',
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: 'Reason'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter reason';
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitLeaveApplication,
                child: Text('Submit Leave Application'),
              ),
              SizedBox(height: 16),
              Text('Your Leave Applications:'),
              if (_leaveApplications.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _leaveApplications.map((leave) {
                    return ListTile(
                      title: Text('Start Date: ${leave['startDate']}'),
                      subtitle: Text('End Date: ${leave['endDate']}'),
                      trailing: Text(leave['isApproved'] == 0 ? 'Pending' : 'Approved'),
                      leading: Text('Reason: ${leave['reason']}'),// Display the reason for the leave
                      // The leave['reason'] should contain the reason data
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime? selectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (selectedDate == _selectedStartDate) {
          _selectedStartDate = picked;
          _startDateController.text = _selectedStartDate!.toLocal().toString().split(' ')[0];
        } else if (selectedDate == _selectedEndDate) {
          _selectedEndDate = picked;
          _endDateController.text = _selectedEndDate!.toLocal().toString().split(' ')[0];
        }
      });
    }
  }
  void _submitLeaveApplication() async {
    if (_formKey.currentState!.validate() && _selectedStartDate != null && _selectedEndDate != null) {
      final leaveData = {
        'employeeId': widget.employeeId,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'reason': _reasonController.text,
        'isApproved': 0,
      };

      final insertedId = await LeavesDatabaseHelper.instance.insertLeaveApplication(leaveData);

      if (insertedId != null) {
        _reasonController.clear();
        _selectedStartDate = null;
        _selectedEndDate = null;
        _startDateController.clear(); // Clear the date controllers as well
        _endDateController.clear();

        final snackBar = SnackBar(content: Text('Leave application submitted successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(content: Text('Error occurred while submitting leave application.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

}
