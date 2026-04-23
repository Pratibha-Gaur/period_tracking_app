import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? last;
  DateTime? next;
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> save(DateTime d) async {
    final p = await SharedPreferences.getInstance();
    await p.setString("date", d.toIso8601String());

    if (!mounted) return;
    setState(() {
      last = d;
      next = d.add(Duration(days: 28));
    });
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    String? s = p.getString("date");

    if (s != null) {
      DateTime d = DateTime.parse(s);
      if (!mounted) return;
      setState(() {
        last = d;
        next = d.add(Duration(days: 28));
      });
    }
  }

  /// 🔴 Last period (5 days)
  bool isLastPeriod(DateTime d) {
    if (last == null) return false;
    return d.isAfter(last!.subtract(Duration(days: 1))) &&
        d.isBefore(last!.add(Duration(days: 5)));
  }

  /// 🩷 Next period (predicted 5 days)
  bool isNextPeriod(DateTime d) {
    if (next == null) return false;
    return d.isAfter(next!.subtract(Duration(days: 1))) &&
        d.isBefore(next!.add(Duration(days: 5)));
  }

  /// 💜 Ovulation (around day 14 of cycle)
  bool isOvulation(DateTime d) {
    if (last == null) return false;
    DateTime ovulation = last!.add(Duration(days: 14));
    return d.isAfter(ovulation.subtract(Duration(days: 2))) &&
        d.isBefore(ovulation.add(Duration(days: 2)));
  }

  Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool("isLoggedIn", false);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  String format(DateTime? d) {
    if (d == null) return "--";
    return "${d.day}/${d.month}/${d.year}";
  }

  int daysLeft() {
    if (next == null) return 0;
    return next!.difference(DateTime.now()).inDays;
  }

  Widget dayCircle(DateTime d, Color color) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        "${d.day}",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Period Tracker"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 📅 Calendar
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime(2100),
                focusedDay: focusedDay,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (isLastPeriod(day)) {
                      return dayCircle(day, Colors.red.shade400);
                    }
                    if (isNextPeriod(day)) {
                      return dayCircle(day, Colors.pink.shade300);
                    }
                    if (isOvulation(day)) {
                      return dayCircle(day, Colors.purple.shade300);
                    }
                    return null;
                  },
                ),
              ),
            ),

            /// 📊 Info Cards
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  Text("Next Period",
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text(format(next),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink)),
                  SizedBox(height: 5),
                  Text("${daysLeft()} days to go"),
                ],
              ),
            ),

            /// 🎯 Button
            ElevatedButton(
              onPressed: () async {
                DateTime? d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (d != null) save(d);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text("Select Last Period Date"),
            ),

            SizedBox(height: 20),

            /// 📌 Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                legend(Colors.red, "Last"),
                legend(Colors.pink, "Next"),
                legend(Colors.purple, "Ovulation"),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget legend(Color c, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(width: 12, height: 12, color: c),
          SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}