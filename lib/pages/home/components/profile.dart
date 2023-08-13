import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person),
            ),
            const Text("Username"),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // logout firebase
                FirebaseAuth.instance.signOut();

                // refresh page
                Navigator.pushReplacementNamed(context, '/auth');
              },
            ),
          ],
        ),
      ],
    );
  }
}
