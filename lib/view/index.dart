import 'package:ende_code/model/app_data.dart';
import 'package:ende_code/view/decode.dart';
import 'package:ende_code/view/encode.dart';
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(builder: (context, appData, child) =>
      ListView.builder(
        itemCount: appData.imageDataList.length,
        itemBuilder: (context, index) =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3.0,
              child: InkWell(
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Encode()));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.edit, color: EndecodeColors.blue,),
                      ),
                    ),
                    SizedBox(width: 4.0),
                    InkWell(
                      onTap: () {
                        Share.share(appData.imageDataList[index].dataStr);
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