import 'package:cms_pwd_reset/models/user_cms_model.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final UserCms user;
  final VoidCallback onResetPressed;

  const UserCard({
    super.key,
    required this.user,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: DataTable(
          columnSpacing: 12,
          horizontalMargin: 12,
          columns: const [
            DataColumn(label: Text('USER ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('SYSTEM', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('NOTED', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('NEW PASSWORD', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('BRANCH', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('TEL', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('UPLOAD BY', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(Text(user.userId)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: user.type == 'Done' ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.type == 'Done' ? 'Done' : 'Pending',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
                DataCell(Text(user.system)),
                DataCell(Text(user.status, maxLines: 2, overflow: TextOverflow.ellipsis)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      user.responseNewpass.isNotEmpty ? user.responseNewpass : '-',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(user.branch, maxLines: 1, overflow: TextOverflow.ellipsis)),
                DataCell(Text(user.tel != 'null' ? user.tel : '-')),
                DataCell(Text(user.uploadBy)),
                DataCell(
                  IconButton(
                    onPressed: onResetPressed,
                    icon: const Icon(Icons.lock_reset, color: Colors.blue),
                    tooltip: 'Reset Password',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}