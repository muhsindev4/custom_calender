import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vangeli_panel_app/app/components/dynamic_gridview/dynamic_height_grid_view.dart';
import 'package:vangeli_panel_app/app/utils/const.dart';

import 'app/components/app_route_observer/app_route_observer.dart';
import 'app/themes/dark_theme.dart';
import 'app/themes/light_theme.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  CustomCalendar({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentDate;
  late DateTime _selectedDate;
  List<DateTime> _daysInMonth = [];

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _selectedDate = widget.initialDate;
    _generateDaysInMonth();
  }

  void _generateDaysInMonth() {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDayOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);

    int daysFromPreviousMonth = firstDayOfMonth.weekday % 7;

    final daysInMonth = List<DateTime>.generate(
      lastDayOfMonth.day,
          (index) => DateTime(_currentDate.year, _currentDate.month, index + 1),
    );

    for (int i = 0; i < daysFromPreviousMonth; i++) {
      daysInMonth.insert(0, firstDayOfMonth.subtract(Duration(days: i + 1)));
    }

    setState(() {
      _daysInMonth = daysInMonth;
    });
  }

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
      _generateDaysInMonth();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
      _generateDaysInMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat.MMMM().format(_currentDate);
    final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: Get.width * 0.5,
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Const.borderRadius),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$monthName ${_currentDate.year}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Const.borderRadius),
                            color: Get.theme.primaryColor,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        onPressed: _previousMonth,
                      ),
                      IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Const.borderRadius),
                            color: Get.theme.primaryColor,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Get.theme.primaryColor,
              ),
              DynamicHeightGridView(
                shrinkWrap: true,
                crossAxisCount: 7,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                itemCount: weekdays.length,
                builder: (BuildContext context, int index) {
                  var day = weekdays[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: weekdays.indexOf(day).isEven ? Color(0xFFFFFDF5) : null,
                      borderRadius: weekdays.indexOf(day).isEven
                          ? BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                      )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
              DynamicHeightGridView(
                shrinkWrap: true,
                crossAxisCount: 7,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                itemCount: _daysInMonth.length,
                builder: (BuildContext context, int index) {
                  final day = _daysInMonth[index];
                  final isToday = day.day == DateTime.now().day &&
                      day.month == DateTime.now().month &&
                      day.year == DateTime.now().year;
                  final isSelected = _selectedDate != null &&
                      day.day == _selectedDate.day &&
                      day.month == _selectedDate.month &&
                      day.year == _selectedDate.year;

                  Color getBackgroundColor() {
                    if (index == 0 || index == 2 || index == 4 || index == 6) {
                      return Color(0xFFFFFDF5); // Gradient columns
                    }
                    if (index == 7 || index == 9 || index == 11 || index == 13) {
                      return Color(0xFFFFFCF3); // Gradient columns
                    }
                    if (index == 14 || index == 16 || index == 18 || index == 20) {
                      return Color(0xFFFFFCEF); // Gradient columns
                    }
                    if (index == 21 || index == 23 || index == 25 || index == 27) {
                      return Color(0xFFFDFAEA); // Gradient columns
                    }
                    if (index == 28 || index == 30 || index == 32 || index == 34) {
                      return Color(0xFFFFF8E6); // Gradient columns
                    }
                    return Colors.transparent; // Default transparent background
                  }

                  bool isPreviousMonth = day.month < _currentDate.month;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = day;
                        widget.onDateSelected(_selectedDate);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: getBackgroundColor(),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? Get.theme.primaryColor : Colors.transparent,
                          shape: isSelected ? BoxShape.circle : BoxShape.rectangle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: Get.textTheme.bodyMedium!.copyWith(
                            color: isSelected
                                ? Colors.white
                                : isToday
                                ? Colors.orange
                                : isPreviousMonth
                                ? Colors.grey
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme.getTheme(),
      navigatorObservers: [AppRouteObserver()],
      darkTheme: DarkTheme.getTheme(),
      home: CalendarScreen(),
      themeMode: ThemeMode.light,
    );
  }
}

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomCalendar(
          initialDate: DateTime.now(),
          onDateSelected: (selectedDate) {
            print("Selected date: $selectedDate");
          },
        ),
      ),
    );
  }
}
