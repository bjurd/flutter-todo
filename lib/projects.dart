import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/project.dart';

List projects = [
  Project.fromMap({
    "name": "UX Design",
    "numOfTasks": 2
  }),

  Project.fromMap({
    "name": "BCCB Bot",
    "numOfTasks": 2
  }),

  Project.fromMap({
    "name": "Multivendor project",
    "numOfTasks": 13
  }),

  Project.fromMap({
    "name": "PS5",
    "numOfTasks": 58
  }),
];

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
                                  print("_formKey.currentState is null");
                                  return;
                                }

                                // Fails validation
                                if (!_formKey.currentState!.validate())
                                {
                                  print("Failed validation");

                                  _formKey.currentState!.save();

                                  return;
                                }

                                // Succcess -- add to list of projects
                                projects.add(Project.fromMap({
                                  "name": _controllerProjectName.text,
                                  "numOfTasks": 0
                                }));

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
                child: ListView.builder(
                  itemCount: projects.length,

                  itemBuilder: (BuildContext context, int i)
                  {
                    return Padding(
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
                            projects[i].name,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),

                          trailing: Text(
                            projects[i].numOfTasks.toString(),

                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ) ,
        ),
      ),
    );
  }
}