import 'dart:math';

import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/style/styles.dart';
import 'package:flutter/material.dart';

class SaveDataDialogBody extends StatefulWidget {

  final Function onSave;
  @required final ImageData imageData;

  const SaveDataDialogBody({Key key, this.onSave, this.imageData}) : super(key: key);

  @override
  _SaveDataDialogBodyState createState() => _SaveDataDialogBodyState();
}

class _SaveDataDialogBodyState extends State<SaveDataDialogBody> {

  String _title = "";
  String _creator = "";

  var _titleEditController = TextEditingController();
  var _creatorEditController = TextEditingController();

  bool get _canSave {
    return _title.isNotEmpty;
  }

  void _save() {
    widget.onSave(_title, _creator);
  }

  @override
  void initState() {
    _title = widget.imageData.title;
    _creator = widget.imageData.creator;

    _titleEditController.text = _title;
    _creatorEditController.text = _creator;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: min(640, MediaQuery.of(context).size.width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("タイトル", style: EndecodeTextStyle.label),
            SizedBox(height: 8),
            Theme(
              data: ThemeData (
                primaryColor: EndecodeColors.blue,
              ),
              child: TextField(
                controller: _titleEditController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit),
                ),
                onChanged: (value) {
                  setState(() { _title = value; });
                },
              ),
            ),
            SizedBox(height: 32),
            Text("つくったひと", style: EndecodeTextStyle.label),
            SizedBox(height: 8),
            Theme(
              data: ThemeData (
                primaryColor: EndecodeColors.blue,
              ),
              child: TextField(
                controller: _creatorEditController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit),
                ),
                onChanged: (value) {
                  setState(() { _creator = value; });
                },
              ),
            ),
            SizedBox(height: 60),
            RaisedButton(
              onPressed: _canSave ? _save : null,
              disabledTextColor: Colors.white,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 52,
                decoration: BoxDecoration(
                  color: _canSave ? EndecodeColors.blue : Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: const Center(child: const Text("ほぞん", style: const TextStyle(fontSize: 20.0), textAlign: TextAlign.center))
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleEditController.dispose();
    _creatorEditController.dispose();
    super.dispose();
  }
}