class Series {
  int? id;
  String? name;
  double? averageRrating;
  double? userRating;
  String? summary;
  ModelImage? image;
  late bool isFavourite;

  Series({
    this.id,
    this.name,
    this.averageRrating,
    this.image,
    this.isFavourite = false,
  });

  Series.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    averageRrating = json['rating'] != null
        ? convertToDouble(json['rating']['average'])
        : null;
    image = json['image'] != null ? ModelImage.fromJson(json['image']) : null;
    isFavourite = false;
  }

  double? convertToDouble(dynamic input) {
    if (input is double) {
      return input;
    } else if (input is int) {
      return input.toDouble();
    } else {
      return null;
    }
  }
}

class ModelImage {
  String? medium;
  String? original;
  ModelImage({this.medium, this.original});

  ModelImage.fromJson(Map<String, dynamic> json) {
    medium = json['medium'];
    original = json['original'];
  }
}

class DataRequiredForBuild {
  List<Series>? series;
  List<Series>? favouriteSeries;

  DataRequiredForBuild({
    this.series,
    this.favouriteSeries,
  });
}
