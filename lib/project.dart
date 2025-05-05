class Project
{
  String name = "";
  int numOfTasks = 0;

  Project.fromMap(Map<String, dynamic> map)
  {
    name = map["name"];
    numOfTasks = map["numOfTasks"];
  }

  Map toJson()
  {
    return {
      "name": name,
      "numOfTasks": numOfTasks
    };
  }
}