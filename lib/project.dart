class Project
{
  String _name = "";
  int _numOfTasks = 0;

  Project.fromMap(Map<String, dynamic> map)
  {
    _name = map["name"];
    _numOfTasks = map["numOfTasks"];
  }

  /*
   * Getters
   */
  String get name => _name;

  int get numOfTasks => _numOfTasks;

  Map toJson()
  {
    return {
      "name": _name,
      "numOfTasks": _numOfTasks
    };
  }


  /*
   * Setters
   */
  set name(String value)
  {
    _name = value;
  }

  set numOfTasks(int value)
  {
    _numOfTasks = value;
  }
}