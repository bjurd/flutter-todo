import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class Tasks extends StatefulWidget
{
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks>
{
  final _formKey = GlobalKey<FormState>();

  final _controllerTaskName = TextEditingController();
  final _controllerTaskDescription = TextEditingController();
  TextEditingController _controllerTaskDueDate = TextEditingController();

  DateTime selectedDueDate = DateTime.now();

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
        title:Text("Project Name"),
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
                          controller: _controllerTaskName,

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
                                onPressed: () {
                                  if (_formKey.currentState == null) {
                                    print("_formKey.currentState is null");
                                    return;
                                  }

                                  // Fails validation
                                  if (!_formKey.currentState!.validate()) {
                                    print("Failed validation");

                                    _formKey.currentState!.save();

                                    return;
                                  }

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

          child: ListView.builder(
            itemCount: 3,

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
                    leading: TaskCheckBox(),

                    title: Text("task name"),

                    subtitle: Text("Mar 3, 2025 hh::mm::ss"),

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
              );
            },
          ),
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