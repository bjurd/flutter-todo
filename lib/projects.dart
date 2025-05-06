import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:todo/tasks.dart';

class Projects extends StatefulWidget
{
  const Projects({super.key});

  @override
  ProjectsState createState() => ProjectsState();
}

class ProjectsState extends State<Projects>
{
  final _formKey = GlobalKey<FormState>();

  final _controllerProjectName = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Projects",

          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.logout),

            onPressed: ()
            {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          showDialog(
            context: context,

            builder: (context)
            {
              return Dialog(
                child: Padding(
                  padding: EdgeInsets.all(20),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      spacing: 10,

                      children: [
                        // Project name input
                        TextFormField(
                          controller: _controllerProjectName,

                          decoration: InputDecoration(
                            hintText: "Enter the project name",
                          ),

                          validator: (value)
                          {
                            if (value == null || value.isEmpty)
                            {
                              return "Please enter a project name";
                            }

                            return null;
                          },
                        ),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          spacing: 10,

                          children: [
                            // Cancel button
                            ElevatedButton(
                              onPressed: ()
                              {
                                // Clear form
                                _formKey.currentState?.reset();

                                // Remove popup
                                Navigator.pop(context);
                              },

                              child: Text("Cancel"),
                            ),

                            // Add button
                            ElevatedButton(
                              onPressed: ()
                              {
                                if (_formKey.currentState == null)
                                {
                                  return;
                                }

                                // Fails validation
                                if (!_formKey.currentState!.validate())
                                {
                                  _formKey.currentState!.save();
                                  return;
                                }

                                // Success -- add to list of projects
                                FirebaseFirestore.instance
                                    .collection("projects")
                                    .add({
                                      "name": _controllerProjectName.text,
                                      "userId": FirebaseAuth.instance.currentUser!.uid
                                    });

                                // Clear form
                                _formKey.currentState?.reset();

                                setState(() {});

                                // Remove popup
                                Navigator.pop(context);
                              },

                              child: Text("Add")
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        },

        shape: CircleBorder(),

        child: Icon(
          Icons.add,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            spacing: 10,

            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                    .collection("projects")
                    .where(
                      "userId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid
                    ).snapshots(),

                  builder: (context, snapshot)
                  {
                    if (!snapshot.hasData)
                      return Text("FUCUUUUUUUU");

                    List<Widget> shit = [];

                    for (DocumentSnapshot project in snapshot.data!.docs)
                    {
                      shit.add(GestureDetector(
                        onTap: ()
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context)
                              {
                                return Tasks(project);
                              }
                            )
                          );
                        },

                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 10,
                          ),

                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.orange,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: ListTile(
                              title: Text(
                                project["name"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              // Action buttons
                              trailing: Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  spacing: 5,

                                  children: [
                                    // Edit button
                                    Icon(
                                      Icons.edit,
                                    ),

                                    // Delete button
                                    Icon(
                                      Icons.delete
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ));
                    }

                    return ListView(
                      children: shit
                    );
                  }
                )
              ),
            ],
          ) ,
        ),
      ),
    );
  }
}
