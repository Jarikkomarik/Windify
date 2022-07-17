import 'package:http/http.dart' as http;
class WindDataProvider{

  static Future<http.Response> getData(String long, String lat, String rotor, String power) async{
    return await http.get(Uri.parse('http://vitr.ufa.cas.cz/inc/ajax2.php?lotlan=${lat},${long}&rotor=${rotor}&emax=${power}'));
  }

}