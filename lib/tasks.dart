
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

  final _editFormKey = GlobalKey<FormState>();
  final _controllerEditTaskName = TextEditingController();
  final _controllerEditTaskDescription = TextEditingController();
  final _controllerEditTaskDueDate = TextEditingController();

  DateTime selectedDueDate = DateTime.now();

  late DocumentSnapshot project;

  TasksState(DocumentSnapshot project)
  {
    this.project = project;
  }

  void dueDateSelector(context, TextEditingController controller) async
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
    controller.text = datePicked.toString();
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
                        // Task name input
                        TextFormField(
                          controller: _controllerTaskName,

                          decoration: InputDecoration(
                            hintText: "Enter the task",

                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),

                          validator: (value)
                          {
                            if (value == null || value.isEmpty)
                            {
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

                          validator: (value)
                          {
                            if (value == null || value.isEmpty)
                            {
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
                                dueDateSelector(context, _controllerTaskDueDate);
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

                                FirebaseFirestore.instance
                                    .collection("tasks")
                                    .add({
                                      "projectId": this.project.id,
                                      "name": _controllerTaskName.text,
                                      "description": _controllerTaskDescription.text,
                                      "date": _controllerTaskDueDate.text,
                                      "completed": false,
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
                        leading: TaskCheckBox(task: task),

                        title: Text(task["name"]),

                        subtitle: Text(task["date"]),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            // edit button
                            IconButton(
                              onPressed: ()
                              {
                                showDialog(
                                  context: context,

                                  builder: (context)
                                  {
                                    _controllerEditTaskName.text = task["name"];
                                    _controllerEditTaskDescription.text = task["description"];
                                    _controllerEditTaskDueDate.text = task["date"];

                                    return Dialog(
                                      child: Padding(
                                        padding: EdgeInsets.all(20),

                                        child: Form(
                                          key: _editFormKey,

                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            spacing: 10,

                                            children: [
                                              // Task name input
                                              TextFormField(
                                                controller: _controllerEditTaskName,

                                                decoration: InputDecoration(
                                                  hintText: "Enter the new task name",
                                                ),

                                                validator: (value)
                                                {
                                                  if (value == null || value.isEmpty)
                                                  {
                                                    return "Please enter the new task name";
                                                  }

                                                  return null;
                                                },
                                              ),

                                              // Task description input
                                              TextFormField(
                                                controller: _controllerEditTaskDescription,

                                                decoration: InputDecoration(
                                                  hintText: "Enter the new description",
                                                ),

                                                validator: (value)
                                                {
                                                  if (value == null || value.isEmpty)
                                                  {
                                                    return "Please enter the new task description";
                                                  }

                                                  return null;
                                                },
                                              ),

                                              // Due date selection
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: _controllerEditTaskDueDate,

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
                                                      dueDateSelector(context, _controllerEditTaskDueDate);
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
                                                    onPressed: ()
                                                    {
                                                      // Clear form
                                                      _editFormKey.currentState?.reset();

                                                      // Remove popup
                                                      Navigator.pop(context);
                                                    },

                                                    child: Text("Cancel"),
                                                  ),

                                                  // Update button
                                                  ElevatedButton(
                                                    onPressed: ()
                                                    {
                                                      if (_editFormKey.currentState == null)
                                                      {
                                                        return;
                                                      }

                                                      // Fails validation
                                                      if (!_editFormKey.currentState!.validate())
                                                      {
                                                        _editFormKey.currentState!.save();
                                                        return;
                                                      }

                                                      // Success -- edit task
                                                      FirebaseFirestore.instance
                                                        .collection("tasks")
                                                        .doc(task.id)
                                                        .update({
                                                          "name": _controllerEditTaskName.text,
                                                          "description": _controllerEditTaskDescription.text,
                                                          "date": _controllerEditTaskDueDate.text,
                                                        });

                                                      // Clear form
                                                      _editFormKey.currentState?.reset();

                                                      setState(() {});

                                                      // Remove popup
                                                      Navigator.pop(context);
                                                    },

                                                    child: Text("Update")
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
                              icon: Icon(Icons.edit)
                            ),

                            // trash button
                            IconButton(
                                onPressed: ()
                                {
                                  FirebaseFirestore.instance
                                    .collection("tasks")
                                    .doc(task.id)
                                    .delete();
                                },
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
  DocumentSnapshot task;

  TaskCheckBox({
    super.key,
    required this.task
  });

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

        FirebaseFirestore.instance.collection("tasks").doc(widget.task.id).update({
          "completed": _isChecked
        });

        setState(() {});
      },

      shape: CircleBorder(),
    );
  }
}