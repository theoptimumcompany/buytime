import 'dart:async';
import 'dart:math';
import 'package:Buytime/reblox/model/finance/finance_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  bool day;
  bool week;
  bool month;
  bool year;

  Finance financeState;
  BarChartSample1(this.day, this.week, this.month, this.year, this.financeState);
  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  DateTime getDate(int year, int month, int day){
    return DateTime(year, month, day, 0, 0, 0, 0, 0);
  }

  String month = '';
  String year = '';
  List<int> day = [];

  Future<void> _selectDate(BuildContext context) async {
    setState(() {
      day.clear();
    });
    if(widget.day){
      final DateTime picked = await showDatePicker(
          context: context,
          //initialDateRange: DateTimeRange(start: cIn, end: cOut),
          firstDate: new DateTime(2021),
          lastDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          initialDatePickerMode: DatePickerMode.day,
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData(primaryColor: BuytimeTheme.ManagerPrimary, splashColor: BuytimeTheme.ManagerPrimary, colorScheme: ColorScheme.light(onPrimary: Colors.white, primary: BuytimeTheme.ManagerPrimary)),
              child: child,
            );
          },
          initialDate: DateTime.now());

      if (picked != null && picked.day != null) {
        print(picked);
        //day = '${picked.day},${picked.month},${picked.year}';
        setState(() {
          day.add(picked.day);
          day.add(picked.month);
          day.add(picked.year);
        });
      }
      return null;
    }else{
      final DateTimeRange picked = await showDateRangePicker(
          context: context,
          //initialDateRange: DateTimeRange(start: cIn, end: cOut),
          firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          lastDate: new DateTime(2025),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData(primaryColor: BuytimeTheme.ManagerPrimary, splashColor: BuytimeTheme.ManagerPrimary, colorScheme: ColorScheme.light(onPrimary: Colors.white, primary: BuytimeTheme.ManagerPrimary)),
              child: child,
            );
          });


    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: SizeConfig.safeBlockVertical * 30,
      width: SizeConfig.safeBlockHorizontal * 90,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 5),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        key: Key('activity_period_key'),
                        onTap: () {
                          if(widget.day || widget.week){
                            _selectDate(context);
                          }else{
                            Utils.dashboardDateSelection(context, widget.month, widget.year, (m, y) {
                              setState(() {
                                month = m;
                                year = y;
                              });
                            });
                          }

                        },
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            widget.day ? ( day.isNotEmpty ? '${DateFormat('dd MMMM').format(DateTime(day[2], day[1], day[0]))}' : '${DateFormat('dd MMMM').format(DateTime.now())}') :
                            widget.week ? '${DateFormat('EEEE').format(DateTime.now())}' :
                            widget.month ? (month.isNotEmpty ? '$month $year' :'${DateFormat('MMMM yyyy').format(DateTime.now())}') :
                            (year.isNotEmpty ? year : '${DateFormat('yyyy').format(DateTime.now())}'),
                            style: TextStyle(
                                letterSpacing: .25,
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextMalibu,
                                fontWeight: FontWeight.w500,
                                fontSize: 13

                              ///SizeConfig.safeBlockHorizontal * 4
                            ),
                          ),
                        )),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    mainBarData(),
                    swapAnimationDuration: animDuration,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          )
        ],
      )
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [BuytimeTheme.ManagerPrimary],
          width: (widget.day || widget.month) ? 10 : 22,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: BuytimeTheme.ManagerPrimary, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [Colors.white],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingDayGroups() => List.generate(25, (i) {
    return makeGroupData(i,  widget.financeState.today != null ?
                              i < widget.financeState.today.hour.length ?
                                  widget.financeState.today.hour[i].toDouble()
                                  : 0
                              : 0, isTouched: i == touchedIndex);
  });
  List<BarChartGroupData> showingWeekGroups() => List.generate(7, (i) {
    return makeGroupData(i,  widget.financeState.week != null ?
                              i < widget.financeState.week.day.length ?
                                widget.financeState.week.day[i].toDouble()
                                  : 0 : 0, isTouched: i == touchedIndex);
  });
  List<BarChartGroupData> showingMothGroups() => List.generate(30, (i) {
    return makeGroupData(i, widget.financeState.month != null ?
                              i < widget.financeState.month.day.length ?
                                widget.financeState.month.day[i].toDouble()
                                  : 0 : 0, isTouched: i == touchedIndex);
  });
  List<BarChartGroupData> showingYearGroups() => List.generate(12, (i) {
    return makeGroupData(i, widget.financeState.year != null ?
                              i < widget.financeState.year.month.length ?
                                widget.financeState.year.month[i].toDouble()
                                  : 0 : 0, isTouched: i == touchedIndex);
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: BuytimeTheme.ManagerPrimary,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '';
                  break;
                default:
                  weekDay = '';
              }
              return BarTooltipItem(
                '€${(rod.y - 1).toStringAsFixed(0)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.month ? '\n ${DateFormat('dd/MM/yy').format(getDate(DateTime.now().year, DateTime.now().month, rodIndex + 1))}' : '',
                    style: const TextStyle(
                      color: BuytimeTheme.TextWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(color: BuytimeTheme.SymbolLightGrey, fontSize: 10),
          //rotateAngle: 90,
          getTitles: (double value) {
            if (value% 100 == 0 && value != 0) {
              return '${value.toInt()}';
            }
            return '';
          },
          interval: 5,
          margin: 5,
          reservedSize: 30,
        ),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: BuytimeTheme.TextBlack, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return widget.day ? '00' : widget.week ? 'M' : widget.month ? '' : 'J';
              case 1:
                return widget.day ? '' : widget.week ? 'T' : widget.month ? '' : 'F';
              case 2:
                return widget.day ? '' : widget.week ? 'W' : widget.month ? '' : 'M';
              case 3:
                return widget.day ? '' : widget.week ? 'T' : widget.month ? '' : 'A';
              case 4:
                return widget.day ? '' : widget.week ? 'F' : widget.month ? '5' : 'M';
              case 5:
                return widget.day ? '' : widget.week ? 'S' : widget.month ? '' : 'J';
              case 6:
                return widget.day ? '06' : widget.week ? 'S' : widget.month ? '' : 'J';
              case 7:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : 'A';
              case 8:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : 'S';
              case 9:
                return widget.day ? '' : widget.week ? '' : widget.month ? '10' : 'O';
              case 10:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : 'N';
              case 11:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : 'D';
              case 12:
                return widget.day ? '12' : widget.week ? '' : widget.month ? '' : '';
              case 13:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 14:
                return widget.day ? '' : widget.week ? '' : widget.month ? '15' : '';
              case 15:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 16:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 17:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 18:
                return widget.day ? '18' : widget.week ? '' : widget.month ? '' : '';
              case 19:
                return widget.day ? '' : widget.week ? '' : widget.month ? '20' : '';
              case 20:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 21:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 22:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 23:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 24:
                return widget.day ? '24' : widget.week ? '' : widget.month ? '25' : '';
              case 25:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 26:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 27:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 28:
                return widget.day ? '' : widget.week ? '' : widget.month ? '' : '';
              case 29:
                return widget.day ? '' : widget.week ? '' : widget.month ? '30' : '';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: widget.day ? showingDayGroups() :
                widget.week ? showingWeekGroups() :
                widget.month ? showingMothGroups() :
                showingYearGroups(),
      gridData: FlGridData(
        checkToShowVerticalLine: (value) => false,
        show: true,
        checkToShowHorizontalLine: (value) => true,
        horizontalInterval: 100,
        getDrawingHorizontalLine: (value) {
          if(value% 100 == 0 && value != 0){
            return FlLine(
                color: BuytimeTheme.SymbolLightGrey,
                strokeWidth: 0.8,
                dashArray: [8, 4]
            );
          }

          return FlLine(
              color: Colors.white,
              strokeWidth: 0.8,
              dashArray: [8, 4]
          );
        },
      ),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}