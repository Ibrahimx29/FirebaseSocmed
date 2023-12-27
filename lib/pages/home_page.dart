import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_socmed/components/my_drawer.dart';
import 'package:minimal_socmed/components/my_list_tile.dart';
import 'package:minimal_socmed/components/my_post_button.dart';
import 'package:minimal_socmed/components/my_textfield.dart';
import 'package:minimal_socmed/database/firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller
  final TextEditingController newPostController = TextEditingController();

  // post the message
  void postMessage() {
    // only post the message if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("W A L L"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // textfield box for user to type
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextField(
                    hintText: "Say something...",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                // post button
                PostButton(onTap: postMessage)
              ],
            ),
          ),

          // posts
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get all posts
              final posts = snapshot.data!.docs;

              // no data?
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No posts.. Post something!"),
                  ),
                );
              }

              // return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];

                    // get data from each post
                    String message = post["PostMessage"];
                    String userEmail = post["UserEmail"];
                    Timestamp timestamp = post["Timestamp"];

                    // format the timestamp to date
                    DateTime now = DateTime.now();
                    DateTime dateTime = timestamp.toDate();
                    DateTime today = DateTime(now.year, now.month, now.day);
                    DateTime yesterday =
                        DateTime(now.year, now.month, now.day - 1);
                    String date;
                    String dateFormat =
                        DateFormat('dd MMMM yyyy').format(dateTime);
                    String timeFormat = DateFormat('HH:mm').format(dateTime);

                    if (dateTime.year == today.year &&
                        dateTime.month == today.month &&
                        dateTime.day == today.day) {
                      date = 'Today $timeFormat';
                    } else if (dateTime.year == yesterday.year &&
                        dateTime.month == yesterday.month &&
                        dateTime.day == yesterday.day) {
                      date = 'Yesterday $timeFormat';
                    } else {
                      date = "$dateFormat $timeFormat";
                    }
                    // return as list tile
                    return MyListTile(
                        title: message, subtitle: userEmail, timestamp: date);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
