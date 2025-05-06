
import "package:flutter/material.dart";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class Tasks extends StatefulWidget
{
  late DocumentSnapshot project;

  Tasks(DocumentSnapshot project)
  {
    this.project = project;
  }

  @override
  State<Tasks> createState() => TasksState(this.project);
}

class TasksState extends State<Tasks>
{
  final _formKey = GlobalKey<FormState>();

  final _controllerTaskName = TextEditingController();
  final _controllerTaskDescription = TextEditingController();
  final TextEditingController _controllerTaskDueDate = TextEditingController();

  DateTime selectedDueDate = DateTime.now();

  late DocumentSnapshot project;

  TasksState(DocumentSnapshot project)
  {
    this.project = project;
  }

  void dueDateSelector(context) async
  {
    // Set up date picker
    final DateTime? datePicked = await showDatePicker(
      context: context,

      initialDate: selectedDueDate,
      firstDate: DateTime(1901, 1),
      lastDate: DateTime(2100),
    );

    // Same date selected or null
    if (datePicked == null || datePicked == selectedDueDate)
    {
      return;
    }

    // Update due date
    selectedDueDate = datePicked;

    // Update controller value
    _controllerTaskDueDate.text = "${datePicked.month}/${datePicked.day}/${datePicked.year}";
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title:Text(project["name"]),
      ),

      // Add task button
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          showDialog(
            context: context,

            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: EdgeInsets.all(20),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      spacing: 10,

                      children: [
                        // Task name input
                        TextFormField(
                          controller: _controllerTaskName,

                          decoration: InputDecoration(
                            hintText: "Enter the task",

                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a task";
                            }

                            return null;
                          },
                        ),

                        // Task description input
                        TextFormField(
                          controller: _controllerTaskDescription,

                          decoration: InputDecoration(
                            hintText: "Enter the description for this task",
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a description for this task";
                            }

                            return null;
                          },
                        ),

                        // Due date selection
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _controllerTaskDueDate,

                                decoration: InputDecoration(
                                    hintText: "Select the due date"
                                ),

                                keyboardType: TextInputType.datetime,

                                // validator: (value) {},
                              ),
                            ),

                            // Select date button
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: ()
                              {
                                dueDateSelector(context);
                              },
                            ),
                          ],
                        ),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          spacing: 10,

                          children: [
                            // Cancel button
                            ElevatedButton(
                              onPressed: () {
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

                                  FirebaseFirestore.instance
                                      .collection("tasks")
                                      .add({
                                    "projectId": this.project.id,
                                    "name": _controllerTaskName.text,
                                    "description": _controllerTaskDescription.text,
                                    "date": _controllerTaskDueDate.text,
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
            },
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

          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("tasks")
                .where(
                  "userId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid
                ).where(
                  "projectId",
                  isEqualTo: this.project.id
                ).snapshots(),

            builder: (context, snapshot)
            {
              if (!snapshot.hasData)
                return Text("FUCUUUUUUUU");

              List<Widget> shit = [];

              for (DocumentSnapshot task in snapshot.data!.docs)
              {
                shit.add(
                    Padding(
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
                          leading: TaskCheckBox(),

                          title: Text(task["name"]),

                          subtitle: Text(task["date"]),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              // edit button
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit)
                              ),

                              // trash button
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete)
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                );
              }

              return ListView(
                  children: shit
              );
            }
          )
        ),
      ),
    );
  }
}

class TaskCheckBox extends StatefulWidget
{
  @override
  State<TaskCheckBox> createState() => _TaskCheckBoxState();
}

class _TaskCheckBoxState extends State<TaskCheckBox>
{
  bool _isChecked = false;

  @override
  Widget build(BuildContext context)
  {
    return Checkbox(
      value: _isChecked,

      activeColor: Colors.green,

      onChanged: (bool? value)
      {
        _isChecked = value!;

        setState(() {});
      },

      shape: CircleBorder(),
    );
  }
}