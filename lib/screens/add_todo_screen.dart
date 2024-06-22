// ignore_for_file: prefer_const_declarations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/status_bar_messenger.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({
    super.key,
    this.item,
  });

  // ignore: strict_raw_type
  final Map? item;

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      final item = widget.item;
      if (item != null) {
        isEditing = true;
        final title = item['title'];
        final description = item['description'];

        titleController.text = title.toString();
        descriptionController.text = description.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Todo' : 'Add Todo',
              style: Theme.of(context).textTheme.titleLarge),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        color: Colors.transparent,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade500,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextFormField(
                    controller: descriptionController,
                    minLines: 3,
                    maxLines: 20,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey.shade700,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey.shade500,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: isEditing ? updateTodosData : submitTodosData,
                  child: Text(isEditing ? 'Update' : 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateTodosData() async {
    final item = widget.item;
    if (item == null) {
      print("You can not call this API for update the record!");
      return;
    }

    final id = item['_id'];
    final isComplete = item['is_completed'];

    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": isComplete
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      showSnackBarMessenger(message: 'Todo has been updated successfully!');
    }
  }

  Future<void> submitTodosData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      showSnackBarMessenger(message: 'Todo has been submitted successfully!');
    }
  }

  void showSnackBarMessenger({String message = '', bool error = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: error ? Colors.white : Colors.white),
      ),
      backgroundColor: error ? Colors.red : Colors.grey.shade900,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
