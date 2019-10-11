import 'dart:math';

import 'package:ende_code/model/app_data.dart';
import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/view/decode.dart';
import 'package:ende_code/view/encode.dart';
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/component/simple_message_dialog.dart';
import 'package:ende_code/widget/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {

  var _canShare = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(builder: (context, appData, child) =>
      appData.imageDataList.isEmpty ? Center(child: Text(" + ボタンで あたらしい えを エンコードしてください")) : ListView.builder(
        itemCount: appData.imageDataList.length,
        itemBuilder: (context, index) =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3.0,
              child: InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (buildContext) {
                      return SimpleMessageDialog(
                        title: "データを けしますか？",
                        message: "データを けしたいときは 「はい」を おしてください。\nデータを そのままにするときは 「キャンセル」を おしてください。",
                        onPositiveTapped: () {
                          ImageDataProvider(appData.db).delete(appData.imageDataList[index].id).then((value) {
                            appData.reload();
                          });
                        },
                      );
                    }
                  );
                },
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Decode(appData.imageDataList[index])));
                },
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          appData.imageDataList[index].creator.isEmpty ? SizedBox() : Text(appData.imageDataList[index].creator, style: EndecodeTextStyle.cardCreator,),
                          SizedBox(height: 4),
                          Text(appData.imageDataList[index].title, style: EndecodeTextStyle.cardTitle),
                          SizedBox(height: 8.0),
                          Align(
                            child: Text(appData.imageDataList[index].dataStr, maxLines: 1,),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Encode(imageData: appData.imageDataList[index])));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.edit, color: EndecodeColors.blue,),
                      ),
                    ),
                    SizedBox(width: 4.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _canShare = false;
                        });
                        var num1 = Random().nextInt(10);
                        var num2 = Random().nextInt(10);
                        showDialog(
                          context: context,
                          builder: (buildContext) {
                            return SimpleDialog(
                              title: Text("おうちのひとに みてもらってね"),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text("下の掛け算の答えを入力してください。", style: EndecodeTextStyle.simpleMessage),
                                ),
                                Container(
                                  color: EndecodeColors.orange.shade50,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Center(child: Text("$num1 x $num2", style: EndecodeTextStyle.dialogOption)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.edit),
                                    ),
                                    onChanged: (value) {
                                      setState(() { _canShare = value == "${num1 * num2}"; });
                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    onPressed: _canShare ? () {
                                      Share.share(appData.imageDataList[index].dataStr);
                                    } : null,
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
                                        color: _canShare ? EndecodeColors.blue : Colors.black12,
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: const Center(child: const Text("シェアする", style: const TextStyle(fontSize: 20.0), textAlign: TextAlign.center))
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.share, color: EndecodeColors.blue,),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ),
          )
      )
    );
  }
}