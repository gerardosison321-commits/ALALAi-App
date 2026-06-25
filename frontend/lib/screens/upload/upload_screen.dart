import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text("Upload Lesson"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Container(
              width: double.infinity,
              height: 220,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.deepPurple.shade100,
                  width: 2,
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.cloud_upload,
                    size: 70,
                    color: Colors.deepPurple.shade300,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Upload your lesson",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "PDF • Image • Worksheet",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Choose PDF"),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt),
                label: const Text("Take Photo"),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.photo_library),
                label: const Text("Choose from Gallery"),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 60,

              child: FilledButton(
                onPressed: () {},
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}