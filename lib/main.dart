import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int times = 1 * 60; // 1min
  late Timer timer;
  String timeview = '0:00:00';
  bool isrunning = false;

  void timeReset() {
    setState(() {
      timeStop();
      times = 1 * 60;
      isrunning = false;
      timeview = Duration(seconds: times).toString().split('.').first;
    });
  }

  void addTime(int sec) {
    times += sec;
    times = times < 0 ? 0 : times;
    setState(() {
      timeview = Duration(seconds: times).toString().split('.').first;
    });
  }

  void timeStart() {
    if (isrunning) {
      // 돌고 있음 => 시간 멈춤, 상태 변셩
      timeStop();
      setState(() {
        isrunning = !isrunning;
      });
    } else {
      // 안돌고 있음 => 돌아감 변경
      // 1초마다 1씩 내려감.. 일정간격마다 수행
      setState(() {
        isrunning = !isrunning;
      });
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          timeview = Duration(seconds: times).toString().split('.')[0];
          print(times--);
          if (times < 0) {
            timeStop();
            times = 1 * 60;
          }
        });
      });
    }
  }

  void timeStop() {
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // times = totalTime;
    timeview = Duration(seconds: times).toString().split('.').first;
    return MaterialApp(
        home: Scaffold(
      body: Column(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'My Timer',
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    timeButton(sec: 60, color: Colors.cyan),
                    timeButton(
                        sec: 30,
                        color: const Color.fromARGB(255, 175, 204, 14)),
                    timeButton(
                        sec: -60, color: const Color.fromARGB(255, 41, 97, 46)),
                    timeButton(
                        sec: -30,
                        color: const Color.fromARGB(255, 146, 60, 26)),
                  ],
                ),
              )),
          Flexible(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    timeview,
                    style: const TextStyle(color: Colors.amber, fontSize: 40),
                  ),
                ),
              )),
          Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.pink,
                child: Center(
                    child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 50,
                          onPressed: timeReset,
                          icon: const Icon(Icons.restore_rounded)),
                      const SizedBox(
                        width: 20,
                      ),
                      if (isrunning)
                        IconButton(
                            iconSize: 50,
                            onPressed: timeStart,
                            icon:
                                const Icon(Icons.pause_circle_outline_rounded))
                      else
                        IconButton(
                            iconSize: 50,
                            onPressed: timeStart,
                            icon: const Icon(Icons.play_circle_fill_rounded))
                    ],
                  ),
                )),
              ))
        ],
      ),
    ));
  }

  GestureDetector timeButton({required int sec, required Color color}) {
    return GestureDetector(
      onTap: () => addTime(sec),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(child: Text('$sec')),
      ),
    );
  }
}
