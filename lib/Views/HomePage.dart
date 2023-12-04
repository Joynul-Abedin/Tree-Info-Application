import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:tree_info/Utility/Util.dart';
import 'package:tree_info/Views/Components/CategoryScrollList.dart';
import 'package:tree_info/Views/Components/TopSectionWithUserImage.dart';

import '../Models/PlantSpecies.dart';
import 'Components/SearchBarWithSettingsButton.dart';
import 'PlantInfoPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";
  String url = "https://tree-info.onrender.com/api/species?perpage=1000";
  late Future<ApiResponse> _plantsDataFuture;

  @override
  void initState() {
    super.initState();
    _plantsDataFuture = fetchData(url);
  }

  ApiResponse parseResponse(String? responseBody) {
    if (responseBody == null || responseBody.isEmpty) {
      throw Exception("Response body is null or empty");
    }
    final parsedJson = json.decode(responseBody);
    if (parsedJson is! Map<String, dynamic>) {
      throw Exception("Invalid JSON format");
    }
    return ApiResponse.fromJson(parsedJson);
  }

  Future<ApiResponse> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return parseResponse(response.body);
    } else {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApiResponse>(
        future: _plantsDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Lottie.asset("assets/loading.json",
                    width: 200, height: 200));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return buildPageContent(snapshot.data!);
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget buildPageContent(ApiResponse data) {
    return Container(
      color: Colors.green[100],
      child: SingleChildScrollView(
        child: Column(
          children: [
            const TopSectionWithUserImage(),
            const SearchBarWithSettingsButton(),
            CategoryScrollList(
              categories: Utility().categories,
              onCategorySelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            buildPlantList(data),
            // Additional content can be added here using 'data'
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'For You',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            buildPlantList(data),
          ],
        ),
      ),
    );
  }

  Widget buildPlantList(ApiResponse data) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.data.length,
        itemBuilder: (context, index) {
          var plant = data.data[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantInfoPage(plant: plant),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            plant.defaultImage.thumbnail.isEmpty
                                ? "https://via.placeholder.com/200"
                                : plant.defaultImage.thumbnail,
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          child: Text(
                            plant.commonName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
