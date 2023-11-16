// like_button.dart
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        // Xử lý sự kiện khi nhấn nút like
      },
      icon: Icon(
        Icons.favorite,
        color: isLiked ? Colors.red : Colors.white,
      ),
    );
  }
}
