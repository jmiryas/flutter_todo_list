class TodoModel {
  late final int? id;
  late final String todo;
  late final String description;
  late final String date;
  late final String category;

  TodoModel(
      {this.id,
      required this.todo,
      required this.description,
      required this.date,
      required this.category});

  TodoModel.fromMap(Map<String, dynamic> todo)
      : this.id = todo["id"],
        this.todo = todo["todo"],
        this.description = todo["description"],
        this.date = todo["date"],
        this.category = todo["category"];

  Map<String, dynamic> toMap() {
    var mapping = Map<String, dynamic>();

    mapping["id"] = this.id;
    mapping["todo"] = this.todo;
    mapping["description"] = this.description;
    mapping["date"] = this.date;
    mapping["category"] = this.category;

    return mapping;
  }
}
