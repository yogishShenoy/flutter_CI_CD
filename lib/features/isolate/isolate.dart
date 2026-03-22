import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class IsolatePage extends StatefulWidget {
  @Preview()
  const IsolatePage({super.key});

  @override
  State<IsolatePage> createState() => _IsolatePageState();
}

class _IsolatePageState extends State<IsolatePage> {
  num progress = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body: ListView(
        // crossAxisAlignment: .center,
        // mainAxisAlignment: .center,
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              var json = await IsolateHelper.fetchData((1000, 10));
              debugPrint('Json Parsed: ${json.length}');
            },
            label: Text('Async await'),
            icon: Icon(Icons.star),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            iconAlignment: IconAlignment.end,
            onPressed: () async {
              //Info: compute accepts only one message or fun args
              //Since compute accepts only one argument, we wrap multiple parameters inside a single object (like a data class, Map, or record) and pass that as the message to the isolate.
              // So here used Dart 3 Records
              // We can also use map,class
              debugPrint('tapped compute');
              var json = await compute(IsolateHelper.fetchData, (1000, 10));
              debugPrint('Json Parsed from compute: ${json.length}');
            },
            label: Text('Compute'),
            icon: Icon(Icons.star),
          ),

          SizedBox(height: 30),
          ElevatedButton.icon(
            iconAlignment: IconAlignment.end,
            onPressed: () async {
              debugPrint('tapped');
              var res = await Isolate.run(() {
                return IsolateHelper.fetchDataIsolateRun(iteration: 100);
              });
              debugPrint('Json Parsed from IsolateRun: $res');
            },
            label: Text('Isolate Run'),
            icon: Icon(Icons.star),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              debugPrint('tapped Isolate');
              progress = 0;
              setState(() {});
              var receivePort = ReceivePort();
              await Isolate.spawn(IsolateHelper.fetchDataIsolate, (
                iteration: 100,
                sendPort: receivePort.sendPort,
              ));
              receivePort.listen((msg) {
                debugPrint('Json Parsed from Isolate: $msg');
                try {
                  progress = num.parse(msg.toString());
                  setState(() {});
                } catch (e) {
                  debugPrint('Error: $e');
                }
              });
            },
            label: Text('Isolate'),
            icon: Icon(Icons.star),
          ),
          SizedBox(height: 30),
          CircularProgressIndicator.adaptive(
            year2023: false,
            value: (progress.toDouble() / 100),
          ),
        ],
      ),
    );
  }
}

class IsolateHelper {
  static Future<String> fetchDataIsolateRun({required int iteration}) async {
    await Future.delayed(Duration(seconds: 3));

    final jsonData = jsonEncode(
      List.generate(10000, (i) => {'id': i, 'name': 'Yogish $i'}),
    );

    for (int i = 0; i < iteration; i++) {
      jsonDecode(jsonData);
    }

    return jsonData;
  }

  static Future<String> fetchData((int, int) args) async {
    final (iteration, temp) = args;
    await Future.delayed(Duration(seconds: 3));

    final jsonData = jsonEncode(
      List.generate(10000, (i) => {'id': i, 'name': 'Yogish $i'}),
    );

    for (int i = 0; i < iteration; i++) {
      jsonDecode(jsonData);
    }

    return jsonData;
  }

  static Future<void> fetchDataIsolate(
    ({int iteration, SendPort sendPort}) data,
  ) async {
    await Future.delayed(Duration(seconds: 3));

    final jsonData = jsonEncode(
      List.generate(10000, (i) => {'id': i, 'name': 'Yogish $i'}),
    );

    for (int i = 0; i < data.iteration; i++) {
      jsonDecode(jsonData);
      var percentage = (i / data.iteration) * 100;
      data.sendPort.send(percentage);
    }

    data.sendPort.send(jsonData);
  }
}
