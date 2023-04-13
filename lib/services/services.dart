import 'dart:convert';

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
}
