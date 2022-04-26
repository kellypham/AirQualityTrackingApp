import 'package:http/http.dart' as http;
import '../models/api_model.dart';

// Air Pollution API
// https://openweathermap.org/api/air-pollution

class ApiService {
  Future<ApiModel?> getAPIData(String latitude, String longitude) async {
    String url =
        'http://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude&lon=$longitude&appid=ea47637d718f573d4c16e85cbf353ecc';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return apiModelFromJson(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }
}
