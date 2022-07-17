import 'package:windify/controller/WindDataProvider.dart';
import 'CalculationResult.dart';
import 'package:windify/InvalidLocationException.dart';
class ResultProcessor {


  Future<CalculationResult> getCalculation(String long, String lat, String rotor, String power) async{
    var apiResponse = await WindDataProvider.getData(long, lat, rotor, power);
    String responseBody = apiResponse.body;
    if(responseBody.contains("Pro tuto oblast nejsou definována data")){
      throw InvalidLocationException('No data for current location');
    }
    List<String> filteredParams = getParsedResponse(responseBody);
    return CalculationResult(filteredParams.first, filteredParams.last);
  }

  List<String> getParsedResponse(String apiResponse) {
    List<String> splittedResponse = apiResponse.split("</td><td>");
    return [splittedResponse.elementAt(96),splittedResponse.elementAt(99)];
  }

}
