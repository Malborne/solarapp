import 'package:solar/services/location.dart';
import 'package:solar/services/networking.dart';

// const openWeatherMapURL = '/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true';
const openWeatherMapURL = '/v1/forecast';
//api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true
var url =
Uri.https('api.open-meteo.com','/v1/forecast',{'latitude':'52.52','longitude':'25.41','current_weather':'true'});
class WeatherModel {
  Future<dynamic> getCityWeather(cityName) async {
    NetworkHelper helper = NetworkHelper(
        url);
    var weatherData = await helper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location myLocation = Location();
    List<double> latLong = await myLocation.getCurrentLocation();
    if (latLong[2]==0)
    {return null;}
    double latitude = latLong[0];
    double longitude = latLong[1];
    print('Latitude: $latitude');
    print('Longitude: $longitude');

    var url =
    Uri.https('api.open-meteo.com','/v1/forecast',{'latitude':latitude.toString(),'longitude':longitude.toString(),'current_weather':'true'});

    NetworkHelper helper = NetworkHelper(
        url
    );
        // '$openWeatherMapURL?lat=${myLocation.latitude}&lon=${myLocation.longitude}&appid=$apiKey&units=metric');

    var weatherData = await helper.getData();
    return weatherData;
  }

  Future<double> getTempFromWeatherData() async{
    dynamic weatherData = await getLocationWeather();
    return weatherData['current_weather']['temperature'];
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(double temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
