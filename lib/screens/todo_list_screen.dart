// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:http/http.dart' as http;
import 'add_todo_screen.dart';
import 'description_page.dart';
import 'view_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key, required this.title});
  final String title;

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<dynamic> todos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchTodos,
            icon: Icon(TablerIcons.refresh, size: 15),
          ),
          IconButton(
            onPressed: navigateToAboutScreen,
            icon: Icon(TablerIcons.layout, size: 15),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchTodos();
        },
        child: Visibility(
          visible: isLoading,
          replacement: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Visibility(
              visible: todos.isNotEmpty,
              replacement: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * .8,
                alignment: Alignment.center,
                child: Text("No Todos Found!",
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your created Todos",
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context).textTheme.titleMedium,
                            color: Colors.white54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(TablerIcons.category_2,
                            color: Colors.white54, size: 20.0),
                      ],
                    ),
                  ),

                  // List of all todos
                  ListView.builder(
                    itemCount: todos.length,
                    padding: const EdgeInsets.all(12.0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final todo = todos[index] as Map;
                      final id = todo['_id'] as String;
                      bool isCompleted = todo['is_completed'] as bool;
                      return Card(
                        color:
                            isCompleted ? Color(0xFFD26900) : Color(0xFF1b1b1b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                        margin: const EdgeInsets.all(3.0),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          onTap: () async {
                            await navigateToViewTodoScreen(todo);
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            todo['title'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            todo['description'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.labelSmall,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: PopupMenuButton(
                            color: Colors.grey.shade900,
                            constraints: BoxConstraints(),
                            iconSize: 14,
                            onSelected: (value) {
                              if (value == 'edit') {
                                navigateToEditTodoScreen(todo);
                              } else if (value == 'delete') {
                                deleteById(id);
                              } else if (value == 'is_completed') {
                                final currentStatus =
                                    todos[index]['is_completed'] as bool;
                                final newStatus = !currentStatus;

                                markTodoAsCompleted(
                                  id,
                                  title: todo['title'] as String,
                                  description: todo['description'] as String,
                                  isCompleted: newStatus,
                                );
                              }
                            },
                            itemBuilder: (context) {
                              List<PopupMenuEntry<String>> items = [];

                              if (!isCompleted) {
                                items.add(
                                  PopupMenuItem(
                                    height: 28,
                                    textStyle: GoogleFonts.roboto(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(TablerIcons.edit, size: 14),
                                        SizedBox(width: 10),
                                        Text(
                                          'Edit',
                                          style: GoogleFonts.roboto(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                            color: Colors.white54,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (!isCompleted) {
                                items.add(
                                  PopupMenuItem(
                                    height: 28,
                                    textStyle: GoogleFonts.roboto(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(TablerIcons.trash, size: 14),
                                        SizedBox(width: 10),
                                        Text(
                                          'Delete',
                                          style: GoogleFonts.roboto(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                            color: Colors.white54,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              items.add(
                                PopupMenuItem(
                                  height: 28,
                                  textStyle: GoogleFonts.roboto(
                                    textStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                    color: Colors.white54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  value: 'is_completed',
                                  child: Row(
                                    children: [
                                      Icon(
                                          isCompleted
                                              ? TablerIcons.checks
                                              : TablerIcons.rosette,
                                          size: 14),
                                      SizedBox(width: 10),
                                      Text(
                                        'Completed',
                                        style: GoogleFonts.roboto(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              return items;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  // List of all todos
                ],
              ),
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          onPressed: navigateToAddTodoScreen,
          // backgroundColor: Color(0xFF7340EA),
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          elevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          splashColor: Colors.white24,
          tooltip: 'Add Todo',
          child: const Icon(
            Icons.add,
            size: 17,
          ),
        ),
      ),
    );
  }

  Future<void> markTodoAsCompleted(String id,
      {String? title, String? description, bool? isCompleted}) async {
    final body = {
      "title": title ?? '',
      "description": description ?? '',
      "is_completed": isCompleted ?? false,
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
      setState(() {
        final index = todos.indexWhere((todo) => todo['_id'] == id);
        if (index != -1) {
          todos[index]['is_completed'] = isCompleted;
        }
      });
    } else {
      showSnackBarMessenger(message: 'Failed to update todo', error: true);
    }
  }

  // ignore: strict_raw_type
  Future<void> navigateToEditTodoScreen(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoScreen(item: item));

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodos();
  }

  // ignore: strict_raw_type
  Future<void> navigateToViewTodoScreen(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => ViewTodoScreen(item: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodos();
  }

  Future<void> navigateToAddTodoScreen() async {
    final route =
        MaterialPageRoute(builder: (context) => const AddTodoScreen());

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodos();
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filteredTodos = todos.where((e) => e['_id'] != id).toList();

      setState(() {
        todos = filteredTodos;
      });

      showSnackBarMessenger(message: "Todo deleted successfully");
    } else {
      showSnackBarMessenger(message: "Failed to delete todo");
    }
  }

  Future<void> fetchTodos() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;

      final result = json['items'] as List;

      setState(() {
        todos = result;
      });
    }

    print("\n\n\n Todos Length :> ${todos.length}.");

    setState(() {
      isLoading = false;
    });
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

  // ignore: strict_raw_type
  Future<void> navigateToAboutScreen() async {
    final route =
        MaterialPageRoute(builder: (context) => const DescriptionPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodos();
  }
}
