import 'dart:io';

import 'package:file_drag_and_drop/drag_container_listener.dart';
import 'package:file_drag_and_drop/file_drag_and_drop_channel.dart';
import 'package:file_drag_and_drop/file_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lottie/lottie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dragAndDropChannel.initializedMainView();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    implements DragContainerListener {
  List<DragFileResult> fileResults = [];

  @override
  void initState() {
    super.initState();
    dragAndDropChannel.addListener(this);
  }

  @override
  void dispose() {
    dragAndDropChannel.removeListener(this);
    super.dispose();
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        ElevatedButton(onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(title: const Text("Color"),
              content: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    setState(() => currentColor = pickerColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        }, child: const Text("背景色"),)
      ]),
      body: Center(
        child: Container(
          color: currentColor,
          child: (fileResults.isNotEmpty &&
              fileResults.first.fileExtension == "json")
              ? Lottie.file(File(fileResults.first.path))
              : Lottie.network(
              'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void draggingFileEntered() {
    print("flutter: draggingFileEntered");
  }

  @override
  void draggingFileExit() {
    print("flutter: draggingFileExit");
  }

  @override
  void performDragFileOperation(List<DragFileResult> fileResults) {
    print("flutter: performDragFileOperation");
    print(fileResults);
    setState(() {
      this.fileResults = fileResults;
    });
  }

  @override
  void prepareForDragFileOperation() {
    print("flutter: prepareForDragFileOperation");
  }


}
