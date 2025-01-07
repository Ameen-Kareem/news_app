import 'package:http/http.dart' as http;
import 'package:news_app/appConfig.dart';

class ApiHelper {
  Future fetchGetAPIs({required String endpoint}) async {
    final url = Uri.parse(Appconfig.baseUrl + endpoint);
    final response = await http.get(url);
    return response;
  }
}
