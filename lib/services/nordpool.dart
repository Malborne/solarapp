import 'dart:convert';
import 'package:intl/intl.dart';
import 'networking.dart';
// const int HOURLY = 194;




class NordPool   {
   final String currency;

  NordPool({this.currency = 'EUR'});

  static const int HOURLY = 10;
  static const int DAILY = 11;
  static const int WEEKLY = 12;
  static const int MONTHLY = 13;
  static const int YEARLY = 14; //Over Many years

  Future<dynamic> fetchJson(
      {required duration, required String? area, DateTime? endDate}) async {
    // If the end date is null, then default to tomorrow
    endDate ??= DateTime.now().add(const Duration(days: 1));
    area ??= '';
    String formattedEndDate =
        '${endDate.day.toString().padLeft(2, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.year.toString().padLeft(2, '0')}';
    print(formattedEndDate);
    String API_URL = '/api/marketdata/page/$duration';

    var url = Uri.parse(
        'https://www.nordpoolgroup.com$API_URL?currency=$currency&endDate=$formattedEndDate');
    // print(url.toString());

    // var url =
    //
    // Uri.https('www.nordpoolgroup.com',API_URL,{'currency':currency,'endDate':formattedEndDate,'entityName':area});
    // print(url.toString());
    NetworkHelper helper = NetworkHelper(url);
    dynamic priceData = await helper.getData();
    // print(priceData);
    return priceData;
  }


   Future<Map<String, dynamic>> ParseJson(
      dynamic data, List<String> columns, String area) async {
    data = data['data'];
    DateTime updated = DateTime.parse(data['DateUpdated']);
    DateTime startTime = DateTime.parse(data['DataStartdate']);
    DateTime endTime = DateTime.parse(data['DataEnddate']);

    Map<String, dynamic> areasData = {};
    // areasData[areas[0]] = {};
    for (final r in data['Rows']) {
      DateTime rowStartTime = DateTime.parse(r['StartTime']);
      DateTime rowEndTime = DateTime.parse(r['EndTime']);
      for(final c in r['Columns']) {
        String name = c['Name'];

        if (!areasData.keys.contains(name)){
              areasData[name] = {
                'values': [],
              };
            }
            if (r['IsExtraRow']) {
          try {
            areasData[name][r['Name']] = [
              double.parse(c['Value'].replaceAll(",", ".").replaceAll(" ", ""))
            ];
          } on FormatException catch (e) {
            //DO nothing just skip it
          }
        } else {
          // print(c['Value'].replaceAll(",", "."));

          try {
            areasData[name]['values'].add({
              'start': rowStartTime,
              'end': rowEndTime,
              'value': double.parse(c['Value'].replaceAll(",", ".")),
            });
          } on FormatException catch (e) {
            //DO nothing, just skip it
          }
        }
      }

    }

    return {
      'start': startTime,
      'end': endTime,
      'updated': updated,
      'currency': currency,
      'areas': areasData
    };
  }

  Future<Map<String, dynamic>> hourly(
      {required String area,
      DateTime? endDate,
      List<String> columns = const [
        'Product',
        'High',
        'Low',
        'Last',
        'Avg',
        'Volume'
      ]}) async {
    return ParseJson(
        await fetchJson(duration: HOURLY, endDate: endDate, area: area),
        columns,
        area);
  }

  Future<Map<String, dynamic>> daily(
      {required String area,
      DateTime? endDate,
      List<String> columns = const [
        'Product',
        'High',
        'Low',
        'Last',
        'Avg',
        'Volume'
      ]}) async {
    return ParseJson(
        await fetchJson(duration: DAILY, endDate: endDate, area: area),
        columns,
        area);
  }

  // Future<Map<String, dynamic>> weekly ({required List<String> areas,DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
  //  return ParseJson(await fetchJson(duration: WEEKLY,endDate: endDate, areas: areas), columns, areas);
  // }

  Future<Map<String, dynamic>> monthly(
      {required String area,
      DateTime? endDate,
      List<String> columns = const [
        'Product',
        'High',
        'Low',
        'Last',
        'Avg',
        'Volume'
      ]}) async {
    return ParseJson(
        await fetchJson(duration: MONTHLY, endDate: endDate, area: area),
        columns,
        area);
  }

  Future<Map<String, dynamic>> yearly(
      {required String area,
      DateTime? endDate,
      List<String> columns = const [
        'Product',
        'High',
        'Low',
        'Last',
        'Avg',
        'Volume'
      ]}) async {
    return ParseJson(
        await fetchJson(duration: YEARLY, endDate: endDate, area: area),
        columns,
        area);
  }

  // Future<Map<String, dynamic>> getByIndex({required index,  List<String> areas = const ['Oslo'],DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
  //   switch(index) {
  //    case 0:
  //      return hourly(areas: areas,endDate: DateTime.now(),columns: columns);
  //     case 1:
  //       return daily(areas: areas,endDate: endDate,columns: columns);
  //     case 2:
  //       return monthly(areas: areas,endDate: endDate,columns: columns);
  //     case 3:
  //       return yearly(areas: areas,endDate: endDate,columns: columns);
  //     case 4:
  //       return hourly(areas: areas,columns: columns);
  //     default:
  //       return hourly(areas: areas,columns: columns);
  //
  //  }
  // }
  Future<Map<String, dynamic>> getAll(
      {String area = 'Oslo',
      DateTime? endDate,
      List<String> columns = const [
        'Product',
        'High',
        'Low',
        'Last',
        'Avg',
        'Volume'
      ]}) async {
    List<String> keys = ['Hours', 'Days', 'Months', 'Tomorrow'];
    Map<String, dynamic> map = {};
    List<dynamic> list = await Future.wait([
      hourly(area: area, endDate: DateTime.now()),
      daily(area: area),
      monthly(area: area),
      hourly(area: area),
    ]);
    for (var i = 0; i < keys.length; i++) {
      map[keys[i]] = list[i];
    }
    return map;
  }
}
