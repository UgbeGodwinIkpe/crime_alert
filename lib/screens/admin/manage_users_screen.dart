import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() =>_ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List users = [];
  List filteredUsers = [];

  bool isLoading = true;

  final searchController = TextEditingController();

  Future<void> fetchUsers() async {

    try {

      final response = await http.get(
        Uri.parse(
          "http://localhost:5000/api/admin/users",
        ),
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        setState(() {

          users = data;
          filteredUsers = data;

          isLoading = false;
        });
      }

    } catch (e) {

      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  void searchUser(String query) {
    setState(() {

      filteredUsers = users.where((user) {

        final name =
            user["name"]
                .toString()
                .toLowerCase();

        final email =
            user["email"]
                .toString()
                .toLowerCase();

        return name.contains(
                  query.toLowerCase(),
              ) ||
              email.contains(
                  query.toLowerCase(),
              );

      }).toList();
    });
  }

  Future<void> deleteUser(
    String id,
  ) async {

    try {

      final response =
          await http.delete(

        Uri.parse(
          "http://localhost:5000/api/admin/users/$id",
        ),
      );

      if (response.statusCode == 200) {

        fetchUsers();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          const SnackBar(
            content: Text(
              "User deleted",
            ),
          ),
        );
      }

    } catch (e) {

      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F8FC),

      appBar: AppBar(
        title:
            const Text("Manage Users"),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(

              children: [

                Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: TextField(

                    controller:
                        searchController,

                    onChanged:
                        searchUser,

                    decoration:
                        InputDecoration(

                      hintText:
                          "Search users...",

                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          16,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(

                  child:
                      ListView.builder(

                    itemCount:
                        filteredUsers.length,

                    itemBuilder:
                        (context, index) {

                      final user =
                          filteredUsers[
                              index];

                      return Card(

                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              16,
                          vertical:
                              6,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),

                        child:
                            ListTile(

                          leading:
                              const CircleAvatar(
                            child: Icon(
                              Icons.person,
                            ),
                          ),

                          title: Text(
                            user["name"] ??
                                "",
                          ),

                          subtitle:
                              Text(
                            user["email"] ??
                                "",
                          ),

                          trailing:
                              IconButton(

                            icon:
                                const Icon(
                              Icons.delete,
                              color:
                                  Colors.red,
                            ),

                            onPressed:
                                () {

                              showDialog(

                                context:
                                    context,

                                builder:
                                    (_) =>
                                        AlertDialog(

                                  title:
                                      const Text(
                                    "Delete User",
                                  ),

                                  content:
                                      const Text(
                                    "Are you sure?",
                                  ),

                                  actions: [

                                    TextButton(

                                      onPressed:
                                          () {

                                        Navigator.pop(
                                          context,
                                        );
                                      },

                                      child:
                                          const Text(
                                        "Cancel",
                                      ),
                                    ),

                                    TextButton(

                                      onPressed:
                                          () {

                                        Navigator.pop(
                                          context,
                                        );

                                        deleteUser(
                                          user[
                                              "_id"],
                                        );
                                      },

                                      child:
                                          const Text(
                                        "Delete",
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}