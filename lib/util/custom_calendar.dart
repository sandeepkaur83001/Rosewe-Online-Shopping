import 'package:flutter_base/util/common_imports.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late PageController _pageController = PageController();
  int monthIndex = 0;
  late int daysInMonth;
  final DateTime _today = DateTime.now();
  late final int selectedYear;
  final int initialPage = 1000;
  late int displayYear;
  _ToggleOptions selectedToggle = _ToggleOptions.monthly;

  late int _selectedYearMonth;

  final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  DateTime _dateFromPageIndex(int pageIndex) {
    final monthOffset = pageIndex - initialPage;
    final totalmonthList =
        (_today.year * 12 + (_today.month - 1)) + monthOffset;
    final year = totalmonthList ~/ 12;
    final month = (totalmonthList % 12) + 1;
    return DateTime(year, month);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);
    monthIndex = initialPage;
    displayYear = _today.year;
    _selectedYearMonth = _today.month;

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? initialPage;
      if (page != monthIndex) {
        setState(() {
          monthIndex = page;
          _selectedYearMonth = _dateFromPageIndex(page).month;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _pageIndexFromDate(DateTime date) {
    final currentTotalmonthList = _today.year * 12 + (_today.month - 1);
    final targetTotalmonthList = date.year * 12 + (date.month - 1);

    return initialPage + (targetTotalmonthList - currentTotalmonthList);
  }

  @override
  Widget build(BuildContext context) {
    var currentDate = _dateFromPageIndex(monthIndex);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: Color(0xffEEEEEE), width: 2),
          top: BorderSide(color: Color(0xffEEEEEE), width: 2),
          right: BorderSide(color: Color(0xffEEEEEE), width: 2),
          bottom: BorderSide(color: Color(0xffEEEEEE), width: 5),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scent Tracker',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xff212121),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          _CustomToggleButton(
            selected: selectedToggle,
            weeklyLabel: 'Weekly',
            monthlyLabel: "Monthly",
            yearlyLabel: "Yearly",
            onChanged: (value) {
              setState(() {
                selectedToggle = value;
              });
            },
          ),

          const SizedBox(height: 20),

          // Prev + month & year + Next
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous month
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                onPressed: () {
                  if (selectedToggle == _ToggleOptions.monthly) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else if (selectedToggle == _ToggleOptions.weekly) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else if (selectedToggle == _ToggleOptions.yearly) {
                    displayYear--;

                    setState(() {});
                  }
                },
              ),

              Text(
                selectedToggle == _ToggleOptions.yearly
                    ? '$displayYear'
                    : '${monthList[currentDate.month - 1]} ${currentDate.year}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: const Color(0xff212121),
                ),
              ),

              // Next month
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right, size: 30),
                onPressed: () {
                  if (selectedToggle == _ToggleOptions.monthly) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else if (selectedToggle == _ToggleOptions.weekly) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else if (selectedToggle == _ToggleOptions.yearly) {
                    displayYear++;

                    setState(() {});
                  }
                },
              ),
            ],
          ),

          if (selectedToggle == _ToggleOptions.weekly) ...[
            // Week days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays
                  .map(
                    (day) => Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  )
                  .toList(),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    monthIndex = page;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  // get current date according to the pageIndex
                  final currentDate = _dateFromPageIndex(pageIndex);

                  // total days in current month
                  final daysInMonth = DateUtils.getDaysInMonth(
                    currentDate.year,
                    currentDate.month,
                  );

                  // get first weekday start (from which day [mon-sun])
                  final firstWeekday = DateTime(
                    currentDate.year,
                    currentDate.month,
                    1,
                  ).weekday;

                  // get prev month total date
                  final prevMonthDate = DateTime(
                    currentDate.year,
                    currentDate.month - 1,
                  );

                  // get prev month total days
                  final daysInPrevMonth = DateUtils.getDaysInMonth(
                    prevMonthDate.year,
                    prevMonthDate.month,
                  );

                  final prevmonthemptyCells = firstWeekday - 1;
                  final totalCells = prevmonthemptyCells + daysInMonth;
                  final rowCount = (totalCells / 7).ceil();
                  final itemCount = rowCount * 7;
                  final nextMonthCells = itemCount - totalCells;

                  return Column(
                    children: [
                      Flexible(
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                              ),
                          itemCount: 7,
                          itemBuilder: (context, monthIndex) {
                            int prevMonth;
                            int nextMonth;

                            if (monthIndex < prevmonthemptyCells) {
                              prevMonth =
                                  daysInPrevMonth -
                                  (prevmonthemptyCells - monthIndex - 1);

                              return Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                child: Center(
                                  child: Text(
                                    '$prevMonth',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xffBDBDBD),
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (monthIndex >=
                                    prevmonthemptyCells + daysInMonth &&
                                monthIndex <
                                    prevmonthemptyCells +
                                        daysInMonth +
                                        nextMonthCells) {
                              nextMonth =
                                  monthIndex -
                                  (prevmonthemptyCells + daysInMonth) +
                                  1;

                              return Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                child: Center(
                                  child: Text(
                                    '$nextMonth',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xffBDBDBD),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final dayNumber =
                                monthIndex - prevmonthemptyCells + 1;

                            return GestureDetector(
                              onTap: () {
                                final selectedDate = DateTime(
                                  displayYear,
                                  monthIndex + 1,
                                );
                                final targetPage = _pageIndexFromDate(
                                  selectedDate,
                                );

                                setState(() {
                                  selectedToggle = _ToggleOptions.monthly;
                                  monthIndex = targetPage;
                                });
                              },
                              child: daysNumberWidget(dayNumber, 2),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],

          if (selectedToggle == _ToggleOptions.monthly) ...[
            // Week days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays
                  .map(
                    (day) => Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  )
                  .toList(),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.36,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    monthIndex = page;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  // get current date according to the pageIndex
                  final currentDate = _dateFromPageIndex(pageIndex);

                  // total days in current month
                  final daysInMonth = DateUtils.getDaysInMonth(
                    currentDate.year,
                    currentDate.month,
                  );

                  // get first weekday start (from which day [mon-sun])
                  final firstWeekday = DateTime(
                    currentDate.year,
                    currentDate.month,
                    1,
                  ).weekday;

                  // get prev month total date
                  final prevMonthDate = DateTime(
                    currentDate.year,
                    currentDate.month - 1,
                  );

                  // get prev month total days
                  final daysInPrevMonth = DateUtils.getDaysInMonth(
                    prevMonthDate.year,
                    prevMonthDate.month,
                  );

                  final prevmonthemptyCells = firstWeekday - 1;
                  final totalCells = prevmonthemptyCells + daysInMonth;
                  final rowCount = (totalCells / 7).ceil();
                  final itemCount = rowCount * 7;
                  final nextMonthCells = itemCount - totalCells;

                  return Column(
                    children: [
                      Flexible(
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: itemCount,
                          itemBuilder: (context, monthIndex) {
                            int prevMonth;
                            int nextMonth;

                            if (monthIndex < prevmonthemptyCells) {
                              prevMonth =
                                  daysInPrevMonth -
                                  (prevmonthemptyCells - monthIndex - 1);

                              return Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                child: Center(
                                  child: Text(
                                    '$prevMonth',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xffBDBDBD),
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (monthIndex >=
                                    prevmonthemptyCells + daysInMonth &&
                                monthIndex <
                                    prevmonthemptyCells +
                                        daysInMonth +
                                        nextMonthCells) {
                              nextMonth =
                                  monthIndex -
                                  (prevmonthemptyCells + daysInMonth) +
                                  1;

                              return Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                child: Center(
                                  child: Text(
                                    '$nextMonth',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xffBDBDBD),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final dayNumber =
                                monthIndex - prevmonthemptyCells + 1;

                            return daysNumberWidget(dayNumber, 2);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],

          if (selectedToggle == _ToggleOptions.yearly) ...[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.22,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: monthList.length,

                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final selectedDate = DateTime(displayYear, index + 1);
                      final targetPage = _pageIndexFromDate(selectedDate);

                      setState(() {
                        selectedToggle = _ToggleOptions.monthly;
                        monthIndex = targetPage;
                      });

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_pageController.hasClients) {
                          _pageController.jumpToPage(targetPage);
                        }
                      });
                    },

                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        monthList[index].substring(0, 3),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff212121),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget daysNumberWidget(int days, int currentday) {
    return days % 2 == 0
        ? days != currentday
              ? Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Color(0xff41B3F9),
                    borderRadius: BorderRadius.circular(1000),
                    border: Border(
                      bottom: BorderSide(color: Color(0xff0572CC), width: 4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$days',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(color: Color(0xff41B3F9), width: 2),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Color(0xff41B3F9),
                      borderRadius: BorderRadius.circular(1000),
                      border: Border(
                        bottom: BorderSide(color: Color(0xff0572CC), width: 4),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$days',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
        : Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Center(
              child: Text(
                '$days',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xff212121),
                ),
              ),
            ),
          );
  }
}

enum _ToggleOptions { weekly, monthly, yearly }

class _CustomToggleButton extends StatelessWidget {
  final _ToggleOptions selected;
  final String weeklyLabel;
  final String monthlyLabel;
  final String yearlyLabel;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final String? fontFamily;
  final Function(_ToggleOptions) onChanged;
  final double? disableButtonWidth;

  const _CustomToggleButton({
    super.key,
    required this.selected,
    required this.weeklyLabel,
    required this.monthlyLabel,
    required this.yearlyLabel,
    required this.onChanged,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.fontFamily,
    this.disableButtonWidth,
  });

  String getToggleText(_ToggleOptions option) {
    switch (option) {
      case _ToggleOptions.weekly:
        return weeklyLabel;
      case _ToggleOptions.monthly:
        return monthlyLabel;
      case _ToggleOptions.yearly:
        return yearlyLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _ToggleOptions.values.map((item) {
        final bool isSelected = item == selected;

        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),

              child: isSelected
                  // Selected toggle
                  ? Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xff41B3F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          getToggleText(item),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  // Unselected toggle
                  : Container(
                      height: 45,
                      width: disableButtonWidth,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          getToggleText(item),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xff212121),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
