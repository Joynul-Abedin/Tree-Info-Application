import 'package:flutter/material.dart';

class CategoryScrollList extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected; // Callback function

  const CategoryScrollList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  CategoryScrollListState createState() => CategoryScrollListState();
}

class CategoryScrollListState extends State<CategoryScrollList> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: SizedBox(
        height: 80.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categories.length,
          itemBuilder: (context, index) {
            bool isSelected = widget.categories[index] == selectedCategory;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = widget.categories[index];
                  widget.onCategorySelected(selectedCategory);
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
