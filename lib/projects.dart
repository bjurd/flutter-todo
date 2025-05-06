import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import "package:todo/tasks.dart";

class Projects extends StatefulWidget
{
  const Projects({super.key});

  @override
  ProjectsState createState() => ProjectsState();
}

class ProjectsState extends State<Projects>
{
  final _formKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final _controllerProjectName = TextEditingController();
  final _controllerEditProjectName = TextEditingController();

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
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                            .collection("projects")
                            .where(
                              "userId",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                            )
                            .snapshots(),

                  builder: (context, snapshot)
                  {
                    if (!snapshot.hasData)
                      return Text("Loading projects...");

                    List<Widget> projectWidgets = [];

                    for (DocumentSnapshot project in snapshot.data!.docs) {
                      projectWidgets.add(
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                                    .collection("tasks")
                                    .where(
                                      "userId",
                                      isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                                    )
                                    .where(
                                      "projectId",
                                      isEqualTo: project.id
                                    )
                                    .count()
                                    .get(),

                          builder: (context, taskCountSnapshot) {
                            int? taskCount = 0;

                            if (taskCountSnapshot.hasData)
                              taskCount = taskCountSnapshot.data!.count;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Tasks(project);
                                    },
                                  ),
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

                                    subtitle: Text("Tasks: $taskCount"),

                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Edit button
                                        GestureDetector(
                                          onTap: ()
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (context)
                                              {
                                                _controllerEditProjectName.text = project["name"];

                                                return Dialog(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: Form(
                                                      key: _editFormKey,
                                                      child: Column(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: [
                                                          // Project name input
                                                          TextFormField(
                                                            controller: _controllerEditProjectName,

                                                            decoration: InputDecoration(
                                                              hintText: "Enter the new project name",
                                                            ),

                                                            validator: (value)
                                                            {
                                                              if (value == null || value.isEmpty)
                                                                return "Please enter the new project name";

                                                              return null;
                                                            },
                                                          ),

                                                          SizedBox(height: 10),

                                                          // Action buttons
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,

                                                            children: [
                                                              // Cancel button
                                                              ElevatedButton(
                                                                onPressed: ()
                                                                {
                                                                  _editFormKey.currentState?.reset();

                                                                  Navigator.pop(context);
                                                                },

                                                                child: Text("Cancel"),
                                                              ),

                                                              SizedBox(width: 10),

                                                              // Update button
                                                              ElevatedButton(
                                                                onPressed: ()
                                                                {
                                                                  if (_editFormKey.currentState == null)
                                                                    return;

                                                                  if (!_editFormKey.currentState!.validate())
                                                                  {
                                                                    _editFormKey.currentState!.save();
                                                                    return;
                                                                  }

                                                                  FirebaseFirestore.instance
                                                                      .collection("projects")
                                                                      .doc(project.id)
                                                                      .update({
                                                                        "name":
                                                                        _controllerEditProjectName.text,
                                                                      });

                                                                  _editFormKey.currentState?.reset();

                                                                  setState(() {});

                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text("Update"),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },

                                          child: Icon(
                                            Icons.edit,
                                          ),
                                        ),

                                        SizedBox(width: 5),
                                        // Delete button
                                        GestureDetector(
                                          onTap: ()
                                          {
                                            FirebaseFirestore.instance
                                                .collection("projects")
                                                .doc(project.id)
                                                .delete();
                                          },

                                          child: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return ListView(
                      children: projectWidgets,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}