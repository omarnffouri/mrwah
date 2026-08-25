import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    final hasImage = image.trim().isNotEmpty;

    return CircleAvatar(
      radius: 38,
      backgroundColor: Colors.amber,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: hasImage
              ? Image.network(
                  image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/user_placeholder.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  'assets/images/user_placeholder.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
