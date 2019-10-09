import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/widget/component/canvas.dart' as view;
import 'package:flutter/material.dart';

class Decode extends StatefulWidget {

  final ImageData imageData;

  const Decode(this.imageData, {Key key}) : super(key: key);

  @override
  _DecodeState createState() => _DecodeState();
}

class _DecodeState extends State<Decode> {

  @override
  Widget build(BuildContext context) {
    final canvasSize = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ?
      MediaQuery.of(context).size.width - 32 :
      MediaQuery.of(context).size.height - 32 - 160;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Wrap(
                children: widget.imageData.data.map((num) => Padding(padding: const EdgeInsets.all(8.0), child:Text("$num", style: const TextStyle(fontSize: 24.0),))).toList(),
              ),
              SizedBox(height: 32),
              view.Canvas(
                width: canvasSize,
                cellNum: widget.imageData.cellNum,
              )
            ],
          ),
        ),
      ),
    );
  }
}