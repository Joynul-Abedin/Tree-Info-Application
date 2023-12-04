import 'package:flutter/material.dart';

class TopSectionWithUserImage extends StatelessWidget {
  const TopSectionWithUserImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Best Plants for \nOur Green Home",
            style: TextStyle(
              fontWeight: FontWeight.bold, // Makes the text bold
              fontSize: 26, // Sets the font size to 24
            ),
          ),
          Stack(
            alignment: Alignment
                .topRight, // Aligns the status indicator to the top right
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://imgv3.fotor.com/images/cover-photo-image/a-beautiful-girl-with-gray-hair-and-lucxy-neckless-generated-by-Fotor-AI.jpg'),
              ),
              Container(
                width: 15.0, // Size of the status indicator
                height: 15.0,
                decoration: BoxDecoration(
                  color: Colors.green, // Active status color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        Colors.white, // Border to distinguish from the avatar
                    width: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
