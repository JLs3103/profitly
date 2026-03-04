import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final dbHelper = DatabaseHelper();
    final users = await dbHelper.getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel - Data User', style: TextStyle(fontSize: 18)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text('Belum ada data user'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF1D7A42),
                          foregroundColor: Colors.white,
                          child: Text('${user['id']}'),
                        ),
                        title: Text(
                          user['username'] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama: ${user['full_name']}'),
                            Text('Email: ${user['email']}'),
                            Text('Password: ${user['password']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
