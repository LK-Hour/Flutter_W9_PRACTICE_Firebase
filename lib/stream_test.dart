// import 'dart:async';

// void main() {
//   // final controller = StreamController<int>();

//   // int counter = 0;

//   // Timer.periodic(Duration(seconds: 1), (timer) {
//   //   counter++;
//   //   controller.add(counter);

//   //   if (counter == 5) {
//   //     timer.cancel();
//   //     controller.close();
//   //   }
//   // });

//   // // Listen to the stream
//   // controller.stream.listen(
//   //   (newValue) => print("Received $newValue"),
//   //   onDone: () => print("done"),
//   // );
//   DownloadService().startDownload();
// }

// class DownloadService {
//   final StreamController<int> _controller = StreamController();
//   final int interval1 = 500; //waiting time (millisecond)
//   final DateTime estimate_finish_timme = DateTime.now().add(
//     Duration(milliseconds: 500 * 10),
//   );
//   Stream<int> get stream => _controller.stream;

//   void startDownload() async {
//     for (int i = 0; i <= 100; i += 10) {
//       await Future.delayed(Duration(milliseconds: interval1));
//       _controller.add(i) ;
//       print("Progress: ${i}% ");
//     }
//     print("done");
//     _controller.close();
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';

class DownloadService {
  final StreamController<int> _controller = StreamController();

  Stream<int> get stream => _controller.stream;

  void startDownload() async {
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(Duration(milliseconds: 300));
      _controller.add(i);
    }
    _controller.close();
  }
}

DownloadService globalService = DownloadService();

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    void onStart() {
      globalService.startDownload();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Download App"),
        actions: [IconButton(onPressed: onStart, icon: Icon(Icons.download))],
      ),
      body: Center(child: DownloadStatus()),
    );
  }
}

class DownloadStatus extends StatelessWidget {
  const DownloadStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globalService.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        return Column(
          children: [
            LinearProgressIndicator(value: snapshot.data! / 100),
            Text("${snapshot.data}%"),
          ],
        );
      },
    );
  }
}

// import 'dart:async';

// class DownloadService {
//   final StreamController<int> _controller = StreamController();

//   Stream<int> get stream => _controller.stream;

//   void startDownload() async {
//     for (int i = 0; i <= 100; i += 10) {
//       await Future.delayed(Duration(milliseconds: 300));
//       _controller.add(i);
//     }
//     _controller.close();
//   }
// }

// void main() {
//   DownloadService service = DownloadService();
//   Stream<int> serviceStream = service.stream;

//   Stream<String> filteredStream = serviceStream
//       .where((value) => value % 20 == 0)
//       .map((value) => "The value is $value");

//   filteredStream.listen((event) => print("EVENT = $event"));

//   service.startDownload();
// }
