import 'dart:convert';
import 'package:intl/intl.dart';
import 'networking.dart';
// const int HOURLY = 194;




class NordPool   {
   final String currency;
   NordPool({this.currency = 'EUR'});
   static const int HOURLY = 10;
   // static const int DAILY = 14;
   static const int WEEKLY = 12;
   static const int MONTHLY = 11;
   static const int YEARLY = 13;

  Future<dynamic> fetchJson  ({required duration ,required List<String> areas,DateTime ?endDate}) async {
    // If the end date is null, then default to tomorrow
    endDate ??= DateTime.now().add(const Duration(days: 1));

    String formattedEndDate = DateFormat('dd-mm-yyyy').format(endDate);
    String API_URL = '/api/marketdata/page/$duration';

    var url =
    Uri.https('nordpoolgroup.com',API_URL,{'currency':currency,'endDate':formattedEndDate,'entityName':json.encode(areas)});
    NetworkHelper helper = NetworkHelper(url);
    dynamic priceData = await helper.getData();
    // print(priceData);
    return priceData;
  }


  Future<Map<String, dynamic>> ParseJson (dynamic data, List<String> columns, List<String> areas) async {
    data = data['data'];
    DateTime updated = DateTime.parse(data['DateUpdated']);
    DateTime startTime = DateTime.parse(data['DataStartdate']);
    DateTime endTime = DateTime.parse(data['DataEnddate']);

    Map<String,dynamic> areasData = {};
    // areasData[areas[0]] = {};
    for(final r in data['Rows']) {
      DateTime rowStartTime = DateTime.parse(r['StartTime']);
      DateTime rowEndTime = DateTime.parse(r['EndTime']);
      for(final c in r['Columns']) {
        String name = c['Name'];
        if (!areas.contains(name)) {
                continue;
              }
            if (!areasData.keys.contains(name)){
              areasData[name] = {
                'values': [],
              };
            }
            if (r['IsExtraRow']){

              areasData[name][r['Name']] = [double.parse(c['Value'].replaceAll(",", ".").replaceAll(" ", ""))];
            }
            else {
              areasData[name]['values'].add({
                'start': rowStartTime,
                'end': rowEndTime,
                'value': double.parse(c['Value'].replaceAll(",", ".")),
              });

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

   Future<Map<String, dynamic>> hourly ({required List<String> areas,DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
    return ParseJson(await fetchJson(duration: HOURLY,endDate: endDate, areas: areas), columns, areas);
   }

   // Future<Map<String, dynamic>> daily ({required List<String> areas,DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
   //   return ParseJson(await fetchJson(duration: DAILY,endDate: endDate, areas: areas), columns, areas);
   // }

   Future<Map<String, dynamic>> weekly ({required List<String> areas,DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
    return ParseJson(await fetchJson(duration: WEEKLY,endDate: endDate, areas: areas), columns, areas);
   }

   Future<Map<String, dynamic>> monthly ({required List<String> areas,DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
     return ParseJson(await fetchJson(duration: MONTHLY,endDate: endDate, areas: areas), columns, areas);
   }

   Future<Map<String, dynamic>> yearly ({required List<String> areas,DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
     return ParseJson(await fetchJson(duration: YEARLY,endDate: endDate, areas: areas), columns, areas);
   }

   Future<Map<String, dynamic>> getByIndex({required index,  List<String> areas = const ['Oslo'],DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
     switch(index) {
      case 0:
        return hourly(areas: areas,endDate: DateTime.now(),columns: columns);
       case 1:
         return weekly(areas: areas,endDate: endDate,columns: columns);
       case 2:
         return monthly(areas: areas,endDate: endDate,columns: columns);
       case 3:
         return yearly(areas: areas,endDate: endDate,columns: columns);
       case 4:
         return hourly(areas: areas,columns: columns);
       default:
         return hourly(areas: areas,columns: columns);

    }
   }
   Future<List<Map<String, dynamic>>>getAll({ List<String> areas = const ['Oslo'],DateTime ?endDate,List<String> columns = const ['Product', 'High', 'Low', 'Last', 'Avg', 'Volume']}) async {
    return Future.wait(List.generate(5, (index)=>getByIndex(index: index)));


   }
}
