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
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
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
              // Header
              Text(
                "Projects",

                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),

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