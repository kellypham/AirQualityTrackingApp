import 'dart:convert';

ApiModel apiModelFromJson(String str) => ApiModel.fromJson(json.decode(str));

String apiModelToJson(ApiModel data) => json.encode(data.toJson());

class ApiModel {
  ApiModel({
    required this.coord,
    required this.list,
  });

  List<double> coord;
  List<ListElement> list;

  factory ApiModel.fromJson(Map<String, dynamic> json) => ApiModel(
        coord: [json["coord"]['lat'], json["coord"]['lon']],
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "coord": List<dynamic>.from(coord.map((x) => x)),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListElement {
  ListElement({
    required this.dt,
    required this.main,
    required this.components,
  });

  int dt;
  API main;
  Map<String, double> components;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        dt: json["dt"],
        main: API.fromJson(json["main"]),
        components: Map.from(json["components"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "main": main.toJson(),
        "components":
            Map.from(components).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class API {
  API({
    required this.aqi,
  });

  int aqi;

  factory API.fromJson(Map<String, dynamic> json) => API(
        aqi: json["aqi"],
      );

  Map<String, dynamic> toJson() => {
        "aqi": aqi,
      };
}
