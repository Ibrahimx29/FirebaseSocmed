import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_socmed/components/my_back_button.dart';
import 'package:minimal_socmed/components/my_list_tile.dart';
import 'package:minimal_socmed/helper/helper_functions.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          // any errors
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }

          // show loading circle
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // if data is null
          else if (snapshot.data == null) {
            return const Text("No Data");
          }

          // get all users
          final users = snapshot.data!.docs;

          return Column(
            children: [
              // back button
              const Padding(
                padding: EdgeInsets.only(left: 25, top: 50),
                child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // list of users of the app
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    // get individual user
                    final user = users[index];

                    // get data from each user
                    String username = user["username"];
                    String email = user["email"];

                    return MyListTile(title: username, subtitle: email);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
