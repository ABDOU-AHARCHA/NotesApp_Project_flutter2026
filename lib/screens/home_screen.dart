import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'SF Pro',
      ),
      home: const NotesHomeScreen(),
    );
  }
}

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({Key? key}) : super(key: key);

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  final List<Map<String, String>> notes = [
    {'title': 'Documents', 'date': '10 May | Passport'},
    {'title': 'Documents', 'date': '12 May | Passport'},
    {'title': 'Documents', 'date': '10 May | Passport'},
    {'title': 'Documents', 'date': '11 May | Passport'},
    {'title': 'Documents', 'date': '12 May | Passport'},
    {'title': 'Documents', 'date': '11 May | Passport'},
    {'title': 'Documents', 'date': '10 May | Passport'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8C5E8), // Light pink
              Color(0xFFD4A5D4), // Medium pink
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Greeting section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hi, zain',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Good Morning',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // Grid icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.grid_view,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.black54, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Search note',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // All Notes header with dropdown
                Row(
                  children: const [
                    Text(
                      'All Notes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 28,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Notes list
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: index == 0
                                ? Colors.white
                                : const Color(0xFFE8D4E8),
                            borderRadius: BorderRadius.circular(16),
                            border: index == 0
                                ? Border.all(
                              color: const Color(0xFF7B68AA),
                              width: 2,
                            )
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notes[index]['title']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notes[index]['date']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Floating action button
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9B7FDB),
              Color(0xFF7B68AA),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B68AA).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () {
              // Navigate to create new note
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}