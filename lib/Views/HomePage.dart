import 'package:flutter/material.dart';
import 'package:tree_info/Utility/Util.dart';
import 'package:tree_info/Views/Components/CategoryScrollList.dart';
import 'package:tree_info/Views/Components/TopSectionWithUserImage.dart';
import 'dart:convert';
import '../Models/PlantSpecies.dart';
import 'Components/SearchBarWithSettingsButton.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";
  String url = "http://192.168.19.208:3000/api/species?perpage=1000";

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
      throw Exception('Failed to load data, status code: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green[100], // Sets the background color of the app
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
            FutureBuilder<ApiResponse>(
              future: fetchData(url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return buildPlantList(snapshot.data!);
                } else {
                  return const Text('No data available');
                }
              },
            ),

            // Plant List as per user interst and location
            FutureBuilder<ApiResponse>(
              future: fetchData(url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Plant as per your Preference", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),
                      ),
                      buildPlantList(snapshot.data!),
                    ],
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ],
        ),
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

  Widget buildPlantList(ApiResponse data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.data.length,
        itemBuilder: (context, index) {
          var plant = data.data[index];
          return GestureDetector(
            onTap: () {
              // Handle the tap event
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
                            plant.defaultImage.thumbnail.isEmpty ? "https://via.placeholder.com/200" : plant.defaultImage.thumbnail,
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

