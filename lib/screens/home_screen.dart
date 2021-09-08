import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../models/category_model.dart';
import '../models/todo_model.dart';
import '../services/database_handler.dart';
import '../widgets/drawer_navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  List<TodoModel> todos = [];

  TextEditingController todoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String category = "";
  String date = "";

  late DatabaseHandler databaseHandler;

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();

    databaseHandler = DatabaseHandler();

    this.databaseHandler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    databaseHandler.retrieveCategories().then((value) {
      categories = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
      ),
      drawer: DrawerNavigation(),
      body: FutureBuilder(
        future: this.databaseHandler.retrieveTodos(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (snapshot.data!.length > 0) {
            return Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      TodoModel todoModel = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.shade300,
                        ),
                        title: Text(
                          "${todoModel.todo} | ${todoModel.category}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "${todoModel.description} | ${todoModel.date}"),
                        trailing: IconButton(
                            onPressed: () {
                              Alert(
                                context: context,
                                type: AlertType.warning,
                                title: "Delete",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    color: Colors.blue,
                                  ),
                                  DialogButton(
                                    color: Colors.red,
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      final result = await this
                                          .databaseHandler
                                          .deleteTodo(todoModel.id!);

                                      setState(() {});

                                      Navigator.pop(context);

                                      if (result != 0) {
                                        _showSnackbar("Sukses");
                                      } else {
                                        _showSnackbar("Gagal");
                                      }
                                    },
                                  )
                                ],
                              ).show();
                            },
                            icon: Icon(Icons.delete)),
                      );
                    }));
          } else {
            return Center(
              child: Text("Todo has no data."),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Alert(
              context: context,
              title: "New Todo",
              content: Column(
                children: <Widget>[
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: todoController,
                    decoration: InputDecoration(
                        labelText: 'Todo', hintText: "Enter todo ..."),
                  ),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: "Enter description ..."),
                  ),
                  DateTimePicker(
                    // initialValue: DateTime.now().toString(),
                    dateHintText: "Select date",
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date',
                    onChanged: (val) {
                      date = val;
                    },
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) {
                      date = val!;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  DropdownSearch<String>(
                    mode: Mode.DIALOG,
                    showSelectedItem: true,
                    items: categories.map((e) => e.name).toList(),
                    label: "Category",
                    hint: "Category ...",
                    onChanged: (value) {
                      category = value!;
                    },
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  color: Colors.blue,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                DialogButton(
                  color: Colors.green,
                  onPressed: () async {
                    print(todoController.text);
                    print(descriptionController.text);
                    print(date);
                    print(category);

                    TodoModel todoModel = TodoModel(
                        todo: todoController.text,
                        description: descriptionController.text,
                        date: date,
                        category: category);

                    databaseHandler = DatabaseHandler();

                    int result = await databaseHandler.insertTodo(todoModel);

                    Navigator.pop(context);

                    setState(() {
                      todoController.text = "";
                      descriptionController.text = "";
                      date = "";
                      category = "";
                    });

                    if (result != 0) {
                      _showSnackbar("Sukses");
                    } else {
                      _showSnackbar("Gagal");
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
