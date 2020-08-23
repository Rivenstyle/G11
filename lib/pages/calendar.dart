import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';

class Calendarpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
      ),
      home: new Scaffold(
        body: new Container(
          margin: new EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 10.0,
          ),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Calendar(
                isExpandable: true,
              ),
              new MarketIndex(),
            ],
          ),
        ),
      ),
    );
  }
}

class MarketIndex extends StatefulWidget {
  @override
  _MarketIndexState createState() => _MarketIndexState();
}

class _MarketIndexState extends State<MarketIndex> {
  IndexData shdata = new IndexData();
  IndexData szdata = new IndexData();

  _MarketIndexState() {
    getindex();
  }

// 新浪财经api返回数据是GBK编码，DART不支持，引入GBK转utf8库
  getindex() async {
    String url = 'http://hq.sinajs.cn/list=';
    var response = await http.get(url + 'sh000001');
    String body = gbk.decode(response.bodyBytes);
    List<String> rlist = body.split('"')[1].split(',');
    shdata.name = rlist[0];
    shdata.beginindex = double.parse(rlist[1]);
    shdata.currentindex = double.parse(rlist[3]);

    response = await http.get(url + 'sz399007');
    body = gbk.decode(response.bodyBytes);
    rlist = body.split('"')[1].split(',');
    szdata.name = rlist[0];
    szdata.beginindex = double.parse(rlist[1]);
    szdata.currentindex = double.parse(rlist[3]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 100.0,
                color: Colors.white24,
                child: Text(
                  "${shdata.name}\n今日开盘：${shdata.beginindex.toStringAsFixed(4)}\n实时指数：${shdata.currentindex.toStringAsFixed(4)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 100.0,
                color: Colors.white10,
                child: Text(
                  "${szdata.name}\n今日开盘：${szdata.beginindex.toStringAsFixed(4)}\n实时指数：${szdata.currentindex.toStringAsFixed(4)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//股票指数 数据结构
class IndexData {
  IndexData();
  String name;
  double beginindex = 0;
  double currentindex = 0;
}
