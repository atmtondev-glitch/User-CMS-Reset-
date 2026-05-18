import 'package:cms_pwd_reset/models/user_cms_model.dart';
import 'package:cms_pwd_reset/screens/reset_password_screen.dart';
import 'package:cms_pwd_reset/services/api_service.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService _apiService = ApiService();
  List<UserCms> _users = [];
  List<UserCms> _displayedUsers = [];
  bool _isLoading = true;
  String? _error;
  int _rowsPerPage = 5;
  int _currentPage = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final users = await _apiService.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
        _updateDisplayedUsers();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _updateDisplayedUsers() {
    final filtered = _filteredUsers;
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    setState(() {
      _displayedUsers = filtered.sublist(
        start,
        end > filtered.length ? filtered.length : end,
      );
    });
  }

  Future<void> _resetPassword(UserCms user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(
          userId: user.userId,
          userIdForUpdate: user.id.toString(),
        ),
      ),
    );
    
    if (result == true) {
      _loadUsers();
    }
  }

  List<UserCms> get _filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    return _users.where((user) =>
      user.userId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user.branch.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void _onRowsPerPageChanged(int? value) {
    if (value != null) {
      final newPage = ((_currentPage * _rowsPerPage) / value).floor();
      setState(() {
        _rowsPerPage = value;
        _currentPage = newPage;
      });
      _updateDisplayedUsers();
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _updateDisplayedUsers();
  }

  int get _totalPages => (_filteredUsers.length / _rowsPerPage).ceil();
  
  String get _pageInfo {
    final start = _currentPage * _rowsPerPage + 1;
    final end = (_currentPage + 1) * _rowsPerPage > _filteredUsers.length 
        ? _filteredUsers.length 
        : (_currentPage + 1) * _rowsPerPage;
    return '$start-$end of ${_filteredUsers.length}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User CMS Reset',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
            tooltip: 'Refresh',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາຕາມ User ID ຫຼື Branch...',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _currentPage = 0;
                });
                _updateDisplayedUsers();
              },
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('ລອງໃໝ່ອີກຄັ້ງ'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // ຫົວຂໍ້ດ້ານເທິງ
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue.shade50,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_reset, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Please enter new password cms',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'CONFIRM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // ຕາຕະລາງຂໍ້ມູນ
                    Expanded(
                      child: _filteredUsers.isEmpty
                          ? const Center(child: Text('ບໍ່ພົບຂໍ້ມູນ'))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DataTable(
                                    columnSpacing: 16,
                                    horizontalMargin: 12,
                                    headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
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
                                    rows: _displayedUsers.map((user) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(user.userId, style: const TextStyle(fontWeight: FontWeight.w500))),
                                          DataCell(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: user.type == 'Done' ? Colors.green : Colors.red,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                user.type == 'Done' ? 'Done' : 'Pending',
                                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(user.system)),
                                          DataCell(
                                            SizedBox(
                                              width: 220,
                                              child: Text(
                                                user.status,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                user.responseNewpass.isNotEmpty ? user.responseNewpass : '-',
                                                style: TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown.shade800,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width: 180,
                                              child: Text(
                                                user.branch,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                            user.tel != 'null' && user.tel.isNotEmpty ? user.tel : '-', 
                                            style: const TextStyle(fontSize: 12)
                                          )),
                                          DataCell(Text(user.uploadBy, style: const TextStyle(fontSize: 12))),
                                          DataCell(
                                            IconButton(
                                              onPressed: () => _resetPassword(user),
                                              icon: const Icon(Icons.lock_reset, color: Colors.blue, size: 20),
                                              tooltip: 'Reset Password',
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    
                    // ແຖວລຸ່ມສຸດ - Pagination
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // TextButton(
                          //   onPressed: () {
                          //     if (Navigator.canPop(context)) {
                          //       Navigator.of(context).pop();
                          //     }
                          //   },
                          //   child: const Text('CLOSE', style: TextStyle(color: Colors.red)),
                          // ),
                          Row(
                            children: [
                              const Text('Rows per page: '),
                              DropdownButton<int>(
                                value: _rowsPerPage,
                                items: const [
                                  DropdownMenuItem(value: 5, child: Text('5')),
                                  DropdownMenuItem(value: 10, child: Text('10')),
                                  DropdownMenuItem(value: 25, child: Text('25')),
                                  DropdownMenuItem(value: 50, child: Text('50')),
                                ],
                                onChanged: _onRowsPerPageChanged,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: _currentPage > 0 
                                    ? () => _onPageChanged(_currentPage - 1)
                                    : null,
                              ),
                              Text(_pageInfo),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: _currentPage < _totalPages - 1
                                    ? () => _onPageChanged(_currentPage + 1)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
