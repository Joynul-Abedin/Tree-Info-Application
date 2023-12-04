import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../Models/PlantInfo.dart';
import '../Models/PlantSpecies.dart';

class PlantInfoPage extends StatefulWidget {
  final PlantSpecies plant;

  const PlantInfoPage({Key? key, required this.plant}) : super(key: key);

  @override
  State<PlantInfoPage> createState() => _PlantInfoPageState();
}

class _PlantInfoPageState extends State<PlantInfoPage> {
  late PlantInfo plantInfo;
  Future<PlantInfo> fetchPlantInfo(String name) async {
    final response = await http.get(Uri.parse(
        "https://tree-info.onrender.com/api/species/plantinfo?treeName=$name"));
    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      return PlantInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Plant Name: ${widget.plant.commonName}");
    fetchPlantInfo(widget.plant.commonName).then((value) => setState(() {
          plantInfo = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.commonName),
      ),
      body: FutureBuilder<PlantInfo>(
        future: fetchPlantInfo(widget.plant.commonName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                      widget.plant.defaultImage.originalUrl.isEmpty
                          ? "https://via.placeholder.com/300"
                          : widget.plant.defaultImage.originalUrl,
                      width: double.infinity,
                      height: 300.0,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Lottie.asset("assets/image_loading.json"),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          widget.plant.scientificName.first,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Introduction:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!.introduction,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Description:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!.description,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Ecology:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!.ecology,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Uses:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!.uses,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                        widget.plant.defaultImage.originalUrl.isEmpty
                            ? "https://via.placeholder.com/300"
                            : widget.plant.defaultImage.originalUrl,
                        width: double.infinity,
                        height: 300.0,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: Lottie.asset("assets/image_loading.json"),
                      );
                    }),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "No Data Available",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
