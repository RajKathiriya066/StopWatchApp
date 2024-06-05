import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int seconds = 0, minutes = 0, hours = 0;
  String dSeconds = "00", dMinutes = "00", dHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;
      dHours = "00";
      dMinutes = "00";
      dSeconds = "00";
      laps = [];
      started = false;
    });
  }

  void addLaps() {
    String lap = "$dHours:$dMinutes:$dSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      int lSeconds = seconds + 1;
      int lMinutes = minutes;
      int lHours = hours;
      if (lSeconds > 59) {
        if (lMinutes > 59) {
          lHours++;
          lMinutes = 0;
          lSeconds = 0;
        } else {
          lMinutes++;
          lSeconds = 0;
        }
      }
      setState(() {
        seconds = lSeconds;
        minutes = lMinutes;
        hours = lHours;
        dSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        dMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        dHours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "StopWatch App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.indigoAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  "$dHours:$dMinutes:$dSeconds",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 82.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 400.0,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView.builder(
                    itemCount: laps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lap no:${index + 1}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            Text(
                              "Lap no:${laps[index]}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? start() : stop();
                      },
                      fillColor: Colors.black,
                      shape: const StadiumBorder(),
                      child: Text(
                        (!started) ? "Start" : "Pause",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  IconButton(
                    onPressed: () {
                      addLaps();
                    },
                    icon: const Icon(Icons.flag),
                    color: Colors.white,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        reset();
                      },
                      fillColor: Colors.black,
                      shape: const StadiumBorder(),
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
