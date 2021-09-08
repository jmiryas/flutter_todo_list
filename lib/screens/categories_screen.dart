import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../services/database_handler.dart';
import '../models/category_model.dart';
import '../screens/home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late DatabaseHandler databaseHandler;

  void _clearTextField() {
    this._categoryController.text = "";
    this._descriptionController.text = "";
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    this.databaseHandler = DatabaseHandler();

    this.databaseHandler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            },
          ),
          title: Text("Categories"),
          centerTitle: true),
      body: FutureBuilder(
          future: this.databaseHandler.retrieveCategories(),
          builder: (BuildContext context,
              AsyncSnapshot<List<CategoryModel>> snapshot) {
            if (!(snapshot.data!.length > 0)) {
              return Center(
                child: Text("Categories has no data."),
              );
            } else {
              return Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      CategoryModel category = snapshot.data![index];

                      return GestureDetector(
                        onTap: () {
                          this._categoryController.text = category.name;
                          this._descriptionController.text =
                              category.description;

                          Alert(
                              context: context,
                              title: "New Category",
                              content: Column(
                                children: <Widget>[
                                  TextField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    controller: _categoryController,
                                    decoration: InputDecoration(
                                      labelText: "Category",
                                    ),
                                  ),
                                  TextField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      labelText: "Description",
                                    ),
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      this._clearTextField();
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                DialogButton(
                                  color: Colors.green,
                                  onPressed: () async {
                                    CategoryModel currentCategory =
                                        CategoryModel(
                                            id: category.id,
                                            name: this._categoryController.text,
                                            description: this
                                                ._descriptionController
                                                .text);

                                    final result = await this
                                        .databaseHandler
                                        .updateCategory(currentCategory);

                                    setState(() {
                                      this._categoryController.text = "";
                                      this._descriptionController.text = "";
                                    });

                                    Navigator.pop(context);

                                    if (result != 0) {
                                      _showSnackbar("Sukses");
                                    } else {
                                      _showSnackbar("Gagal");
                                    }
                                  },
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ]).show();
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: CategoryModel.categoryColor,
                          ),
                          title: Text(
                            category.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(category.description),
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
                                            .deleteCategory(category.id!);

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
                        ),
                      );
                    }),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Alert(
              context: context,
              title: "New Category",
              content: Column(
                children: <Widget>[
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: "Category",
                    ),
                  ),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                    ),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      this._clearTextField();
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                DialogButton(
                  color: Colors.green,
                  onPressed: () async {
                    CategoryModel categoryModel = CategoryModel(
                        name: _categoryController.text,
                        description: _descriptionController.text);

                    final result = await this
                        .databaseHandler
                        .insertCategory(categoryModel);

                    setState(() {
                      this._clearTextField();
                    });

                    Navigator.pop(context);

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
