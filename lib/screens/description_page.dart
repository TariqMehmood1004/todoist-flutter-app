import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionPage extends StatelessWidget {
  const DescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About the App',
            style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'App Name',
                  style: GoogleFonts.aBeeZee(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Todoist',
                    style: GoogleFonts.aBeeZee(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.0),
            Text(
              'Todoist is a simple and intuitive app designed to help you manage your tasks efficiently. With features like adding, editing, and deleting todos, it ensures that you stay on top of your tasks effortlessly. You can also mark tasks as completed and view your progress at a glance.',
              style: GoogleFonts.aBeeZee(
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.0),
            Text(
              '1. Add new tasks easily\n'
              '2. Edit existing tasks\n'
              '3. Delete tasks you no longer need\n'
              '4. Mark tasks as completed\n'
              '5. View a list of all your tasks\n'
              '6. Clean and user-friendly interface',
              style: GoogleFonts.aBeeZee(
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.0),
            Text(
              'If you have any questions or feedback, feel free to reach out to us at contact@todoistapp.com.',
              style: GoogleFonts.aBeeZee(
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Version',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    '1.0.0',
                    style: GoogleFonts.montserrat(
                      textStyle: Theme.of(context).textTheme.titleSmall,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
