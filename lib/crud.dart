import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List users = [];

  Future<void> fatchUsers() async {
    final response =
    await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    // print(response.statusCode);
    if (response.statusCode == 200) {
      users = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fatchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User List",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purpleAccent,
                  child: Text(
                    user['name'][0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  user['name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'UserName ${user['username']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Email ${user['email']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Phone ${user['phone']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Website ${user['website']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
