

class PriceData {
  Data? data;

  PriceData({this.data});

  PriceData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }


}

class Data {
  List<Rows>? rows;

  Data({this.rows});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Rows'] != null) {
      rows = <Rows>[];
      json['Rows'].forEach((v) {
        rows!.add(Rows.fromJson(v));
      });
    }
  }

}

class Rows {
  List<Columns>? columns;
  String? name;
  String? startTime;
  String? endTime;
  String? dateTimeForData;
  int? dayNumber;
  String? startTimeDate;
  bool? isExtraRow;
  bool? isNtcRow;
  String? emptyValue;
  String? parent;

  Rows(
      {this.columns,
        this.name,
        this.startTime,
        this.endTime,
        this.dateTimeForData,
        this.dayNumber,
        this.startTimeDate,
        this.isExtraRow,
        this.isNtcRow,
        this.emptyValue,
        this.parent});

  Rows.fromJson(Map<String, dynamic> json) {
    if (json['Columns'] != null) {
      columns = <Columns>[];
      json['Columns'].forEach((v) {
        columns!.add(Columns.fromJson(v));
      });
    }
    name = json['Name'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    dateTimeForData = json['DateTimeForData'];
    dayNumber = json['DayNumber'];
    startTimeDate = json['StartTimeDate'];
    isExtraRow = json['IsExtraRow'];
    isNtcRow = json['IsNtcRow'];
    emptyValue = json['EmptyValue'];
    parent = json['Parent'];
  }


}

class Columns {
  int? index;
  int? scale;
  int? secondaryValue;
  bool? isDominatingDirection;
  bool? isValid;
  bool? isAdditionalData;
  int? behavior;
  String? name;
  String? value;
  String? groupHeader;
  bool? displayNegativeValueInBlue;
  String? combinedName;
  String? dateTimeForData;
  String? displayName;
  String? displayNameOrDominatingDirection;
  bool? isOfficial;
  bool? useDashDisplayStyle;

  Columns({this.index,
    this.scale,
    this.secondaryValue,
    this.isDominatingDirection,
    this.isValid,
    this.isAdditionalData,
    this.behavior,
    this.name,
    this.value,
    this.groupHeader,
    this.displayNegativeValueInBlue,
    this.combinedName,
    this.dateTimeForData,
    this.displayName,
    this.displayNameOrDominatingDirection,
    this.isOfficial,
    this.useDashDisplayStyle});

  Columns.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    scale = json['Scale'];
    secondaryValue = json['SecondaryValue'];
    isDominatingDirection = json['IsDominatingDirection'];
    isValid = json['IsValid'];
    isAdditionalData = json['IsAdditionalData'];
    behavior = json['Behavior'];
    name = json['Name'];
    value = json['Value'];
    groupHeader = json['GroupHeader'];
    displayNegativeValueInBlue = json['DisplayNegativeValueInBlue'];
    combinedName = json['CombinedName'];
    dateTimeForData = json['DateTimeForData'];
    displayName = json['DisplayName'];
    displayNameOrDominatingDirection = json['DisplayNameOrDominatingDirection'];
    isOfficial = json['IsOfficial'];
    useDashDisplayStyle = json['UseDashDisplayStyle'];
  }
}