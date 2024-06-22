// ignore_for_file: prefer_const_declarations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../utils/status_bar_messenger.dart';

class ViewTodoScreen extends StatelessWidget {
  const ViewTodoScreen({
    super.key,
    this.item,
  });

  // ignore: strict_raw_type
  final Map? item;

  String getMaxWords(String input, int length) {
    List<String> words = input.split(' ');
    if (words.length <= length) {
      return input;
    } else {
      return words.take(3).join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final todo = item;
    return Scaffold(
      appBar: AppBar(
        title: Text(getMaxWords(todo!['title'].toString(), 3),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                todo['title'].toString(),
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                todo['description'].toString(),
                style: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
