import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xffECE8FF),
            child: Icon(
              Icons.person,
              size: 55,
              color: Colors.deepPurple,
            ),
          ),

          const SizedBox(height: 18),

          const Center(
            child: Text(
              "Miguel Pardo",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Center(
            child: Text(
              "Grade 10",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: ListTile(
              leading: const Icon(Icons.star),
              title: const Text("XP"),
              trailing: const Text("120"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text("Current Streak"),
              trailing: const Text("7 Days"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Subjects Completed"),
              trailing: const Text("5"),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              subtitle: const Text("English / Filipino"),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              trailing: Switch(
                value: true,
                onChanged: null,
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About ALALAi"),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),

          const SizedBox(height: 40),

          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text("Log Out"),
          ),

          const SizedBox(height: 30),

        ],
      ),
    );
  }
}