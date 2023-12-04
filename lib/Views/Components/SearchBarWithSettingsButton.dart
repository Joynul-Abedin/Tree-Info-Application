import 'package:flutter/material.dart';

class SearchBarWithSettingsButton extends StatelessWidget {
  const SearchBarWithSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 300.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Expanded( // Expanded widget to ensure the TextField takes the remaining width
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                      border: InputBorder.none, // Removes underline of the input field
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
