import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gallery/avinya/asset/lib/data.dart';
import 'package:gallery/avinya/attendance/lib/data/activity_attendance.dart';

List<DateTime> getWeekdaysFromDate(DateTime fromDate, int numberOfWeekdays) {
 List<DateTime> weekdaysList = [];
  // Loop until we have the required number of weekdays
  while (weekdaysList.length < numberOfWeekdays) {
    // Move to the next day
    fromDate = fromDate.add(Duration(days: 1));

    // Check if the current day is a weekday
    if (fromDate.weekday >= 1 && fromDate.weekday <= 5) {
      weekdaysList.add(fromDate);
    }
  }

  return weekdaysList;
}
class PersonAttendanceMarkerReport extends StatefulWidget {
  const PersonAttendanceMarkerReport({super.key});

  @override
  State<PersonAttendanceMarkerReport> createState() => _PersonAttendanceMarkerReportState();
}

class _PersonAttendanceMarkerReportState extends State<PersonAttendanceMarkerReport> {

 List<ActivityAttendance> _personAttendanceReport = [];
 var result_limit = 14;
 DateTime fourteenDaysAgoDate = DateTime.now().subtract(Duration(days: 14));
 List<DataColumn> _weekdaysColumns = [];
 List<String?> stringDateTimeList = [];
 List<DateTime> weekdaysList = [];

  @override
  void initState() {
    super.initState();
    _generateWeekdaysColumns();
  }

  void _generateWeekdaysColumns() {
    weekdaysList = getWeekdaysFromDate( fourteenDaysAgoDate , 14);
    // Generate the DataColumn list
    for (DateTime date in weekdaysList) {
      _weekdaysColumns.add(DataColumn(
        label: Text('${date.toString().split(" ")[0]}'),
      ));
    }
  }
 Future<List<ActivityAttendance>> refreshPersonActivityAttendanceReport() async{

     _personAttendanceReport = await getPersonActivityAttendanceReport(
        campusAppsPortalInstance.getUserPerson().id!,
        campusAppsPortalInstance.activityIds['homeroom']!,
        result_limit
     );        
     
    // _personAttendanceReport.removeWhere((dayAttendance) => [null].contains(dayAttendance.sign_in_time));

   //_columnNames = _personAttendanceReport.map((dayAttendance) => dayAttendance.sign_in_time!.substring(0,10)).toList();
    
   // print("columnnames"+"$_columnNames");
   return _personAttendanceReport;
 }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ActivityAttendance>>(
      future: refreshPersonActivityAttendanceReport(),
      builder: (BuildContext context,AsyncSnapshot snapshot){

        if(snapshot.hasData){
        stringDateTimeList = weekdaysList.map((datetime){return datetime.toString().split(" ")[0];}).toList();
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: PaginatedDataTable(
               columns: [
                 DataColumn(label: Text('Date')),
                 DataColumn(label: Text('Attendance'))
               ], 
               source: _PersonAttendanceMarkerReportDataSource(snapshot.data,stringDateTimeList),
               rowsPerPage: 15,
               dataRowHeight: 30.0,  
               columnSpacing: 15.0,        
          ),
        );
        
        }else if(snapshot.hasError){
           return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
        },
      );
  }
}

class _PersonAttendanceMarkerReportDataSource extends DataTableSource{

 _PersonAttendanceMarkerReportDataSource(this._data,this.numberOfColumns);

  List<ActivityAttendance> _data;
  List<String?>  numberOfColumns = [];
  
  @override
  DataRow? getRow(int index) {
    List<DataCell> cells = [];

    print("index"+"$index");
    print("data"+"$_data");
    print("numberofcolumns"+"$numberOfColumns");
    final attendance = numberOfColumns[index];
    int i=0;
  
    for( ;i<_data.length;i++){
     
            if (_data[i].sign_in_time != null &&
              attendance == _data[i].sign_in_time!.split(" ")[0]) {
              cells.add(DataCell(Text(attendance!)));
              cells.add(DataCell(Text("Present")));
              break;
              }
    }
    if(i==_data.length){
      if(cells.isEmpty){
        cells.add(DataCell(Text(attendance!)));
        cells.add(DataCell(Container(child: Text("Absent"), color: Colors.red)));   
      }
    }   
    return DataRow(cells: cells);
  }
  
  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;
  
  @override
  // TODO: implement rowCount
  int get rowCount => numberOfColumns.length;
  
  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}