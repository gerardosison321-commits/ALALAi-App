import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text("Progress"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
              ),
              title: const Text("Current Streak"),
              subtitle: const Text("7 Days"),
              trailing: Text(
                "🔥",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              title: const Text("Total XP"),
              subtitle: const Text("120 XP"),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Today's Goal",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      value: .65,
                      minHeight: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "13 / 20 Cards",
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            "Subjects",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.science),
              title: const Text("Science"),
              trailing: const Text("82%"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text("Mathematics"),
              trailing: const Text("74%"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text("English"),
              trailing: const Text("91%"),
            ),
          ),

          const SizedBox(height: 30),

        ],
      ),
    );
  }
}