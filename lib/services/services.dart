import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<List<Series>?> getSeries() async {
    var url = Uri.parse("https://api.tvmaze.com/shows");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List result = json.decode(response.body);
      List<Series> resultList = result.map((x) => Series.fromJson(x)).toList();
      return resultList;
    } else {
      return null;
    }
  }

  Future<List<Series>?> getFavouriteSeries() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('favourite-series');
    QuerySnapshot query = await collectionRef.get();
    List<Map<String, dynamic>> favouriteSeriesFromDb = [];

    for (var doc in query.docs) {
      favouriteSeriesFromDb.add(doc.data() as Map<String, dynamic>);
    }

    return List<Series>.from(favouriteSeriesFromDb.map(
      (e) => Series.fromJson(e),
    ));
  }

  Future<DataRequiredForBuild> getDataRequiredForBuild() async {
    return DataRequiredForBuild(
      series: await getSeries(),
      favouriteSeries: await getFavouriteSeries(),
    );
  }
}
