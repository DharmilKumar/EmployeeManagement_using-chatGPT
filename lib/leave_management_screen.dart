import 'package:flutter/material.dart';
import 'package:employeemanagement/database_helper.dart'; // Import your database helper
import 'leaves_database_helper.dart';
class LeavesManagementScreen extends StatelessWidget {
  final Map<String, dynamic> employee;

  LeavesManagementScreen({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Leaves'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Fetch leave applications for the current employee
        future: LeavesDatabaseHelper.instance.getLeaveApplications(employee['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final leaveApplications = snapshot.data ?? [];
            return _buildLeaveApplicationsList(context, leaveApplications);
          }
        },
      ),
    );
  }

  Widget _buildLeaveApplicationsList(BuildContext context, List<Map<String, dynamic>> leaveApplications) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Employee: ${employee['name']}'),
          Text('Designation: ${employee['designation']}'),
          SizedBox(height: 16),
          Text(
            'Leave Applications:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (leaveApplications.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: leaveApplications.map((leave) {
                return ListTile(
                  title: Text('Start Date: ${leave['startDate']}'),
                  subtitle: Text('End Date: ${leave['endDate']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => _approveLeave(context, leave['id']),
                        child: Text('Approve'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _rejectLeave(context, leave['id']),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          if (leaveApplications.isEmpty)
            Text('No leave applications available.'),
        ],
      ),
    );
  }

  Future<void> _approveLeave(BuildContext context, int leaveId) async {
    await LeavesDatabaseHelper.instance.updateLeaveApproval(leaveId, 1); // Approve the leave
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Leave Approved')),
    );
  }

  Future<void> _rejectLeave(BuildContext context, int leaveId) async {
    await LeavesDatabaseHelper.instance.updateLeaveApproval(leaveId, 2); // Reject the leave
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Leave Rejected')),
    );
  }
}
