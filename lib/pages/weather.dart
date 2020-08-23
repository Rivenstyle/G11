import 'package:flutter/material.dart';
//需在pubspec.yaml中安装http依赖
import 'package:http/http.dart' as http;
import 'dart:convert';
//weather.dart里的类已被包含在本文件中，不需要再导入
//import 'weather.dart';

//MyApp类，会调用MyWeatherPage类
class Weatherpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Weather",
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: MyWeatherPage(title: "天气"),
    );
  }
}

//MyWeatherPage为本功能主要任务，需使用StatefulWidget，所以需要以下两个类
//MyWeatherPage该类继承自StatefulWiget 并且重载了createState()方法，所以才需要_MyWeatherPageState类
class MyWeatherPage extends StatefulWidget {
  MyWeatherPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyWeatherPageState createState() => _MyWeatherPageState();
}

//_MyWeatherPageState类，该应用程序的所有逻辑和状态管理代码都在该类中
class _MyWeatherPageState extends State<MyWeatherPage> {
  //int _counter = 0;
  Weather weather = new Weather();
  Color textColor = Colors.white;
  Color containerColor = Colors.transparent;
  TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.white,
  );
  String url =
      "https://www.tianqiapi.com/api/?version=v1&appid=93558729&appsecret=cja56kkA&cityid=101020100";

  @override
  void initState() {
    super.initState();
    getData();
  }

  //从网站上get需要的天气数据，并存储
  //具体存储的数据可参考最后的weather类、databean、hourbean类
  void getData() async {
    http.get(url).then((http.Response response) {
      var jsonData = json.decode(response.body);
      //print(jsonData);
      weather.cityName = jsonData["city"];
      weather.updateTime = jsonData["update_time"];
      List data = new List();
      data = jsonData["data"];
      //print(data);
      for (var d in data) {
        DataBean dataBean = new DataBean();
        dataBean.air = d["air"];
        dataBean.airLevel = d["air_level"];
        dataBean.win_speed = d["win_speed"];
        dataBean.day = d["day"];
        dataBean.curTempurature = d["tem"];
        dataBean.maxTempurature = d["tem1"];
        dataBean.minTempurature = d["tem2"];
        dataBean.weather = d["wea"];
        dataBean.humidity = d["humidity"];
        dataBean.wea_img = d["wea_img"];
        List hours = new List();
        hours = d["hours"];
        //print(hours);
        for (var h in hours) {
          HourBean hourBean = new HourBean();
          hourBean.curTempurature = h["tem"];
          hourBean.weather = h["wea"];
          hourBean.time = h["day"];
          //hourBean.wea_img = h["wea_img"];
          //hourBean.myPrint();
          dataBean.hourBean.add(hourBean);
        }
        weather.dataBean.add(dataBean);
      }
      setState(() {});
    });
  }

  //布局：在数据为空时用_loading()的布局，在有数据时用Stack(三层，在body里实现)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: weather.dataBean.length == 0
          ? _loading()
          : Stack(
              children: <Widget>[
                Image.network(
                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1597826892922&di=8a8945dd663946942f77bc077eae835d&imgtype=0&src=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D2728236354%2C3529579793%26fm%3D214%26gp%3D0.jpg",
                  fit: BoxFit.fill,
                  height: double.infinity,
                ),
                SingleChildScrollView(
                  child: body(),
                ),
              ],
            ),
    );
  }

  //页面为空时的布局
  Widget _loading() {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new CircularProgressIndicator(
            strokeWidth: 5.0,
          ),
          new Container(
            margin: EdgeInsets.only(top: 10.0),
            child: new Text(
              "正在加载..",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  //body布局
  Widget body() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //头部信息，显示所在城市
          AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              "${weather.cityName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          //三层布局，将在接下来的方法中依次实现
          topView(),
          new Container(
            height: 100.0,
            child: centerView(),
          ),
          bottomView(),
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: Text(
              "API来源: https://www.tianqiapi.com",
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  //实现当前温度、温度范围等的展示
  Widget topView() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      color: containerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            weather.dataBean[0].curTempurature,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60,
              color: Colors.white,
            ),
          ),
          Text(
            "${weather.dataBean[0].maxTempurature}/${weather.dataBean[0].minTempurature}",
            style: textStyle,
          ),
          Text(
            "${weather.dataBean[0].weather}  空气${weather.dataBean[0].airLevel}",
            style: textStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "空气质量${weather.dataBean[0].air}",
                style: textStyle,
              ),
              Text(
                "风力${weather.dataBean[0].win_speed}",
                style: textStyle,
              ),
              Text(
                "湿度${weather.dataBean[0].humidity}",
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //实现接下来二十四小时的天气、温度展示
  //支持左右拖动查看，因此使用listview
  Widget centerView() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: _listView2(),
    );
  }

  //需要从hourbean中依次取出
  List<Widget> _listView2() {
    List<Widget> widgets = new List();
    for (var d in weather.dataBean[0].hourBean) {
      widgets.add(itemView2(d));
    }
    return widgets;
  }

  //对取出的数据依次展示
  Widget itemView2(HourBean hour) {
    String img = imgChosen(hour.weather);
    return Container(
      width: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "${hour.time}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          new Container(
            child: new Image.network(
              img,
              fit: BoxFit.contain,
            ),
            width: 40.0,
            height: 40.0,
          ),
          Text(
            "${hour.curTempurature}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  //展示未来七天内的天气
  //跟上一个方法相同，需要依次取出数据
  Widget bottomView() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      color: containerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "预报",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          Column(
            children: _listView(),
          ),
        ],
      ),
    );
  }

  //依次取出数据
  List<Widget> _listView() {
    List<Widget> widgets = new List();
    for (var d in weather.dataBean) {
      widgets.add(itemView(d));
    }
    return widgets;
  }

  //对数据作展示
  Widget itemView(DataBean data) {
    String img = imgChosen(data.wea_img);
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "${data.day}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          new Container(
            child: new Image.network(
              img,
              fit: BoxFit.cover,
            ),
            width: 40.0,
            height: 40.0,
          ),
          Row(
            children: <Widget>[
              Text(
                "${data.maxTempurature}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                "/",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                "${data.minTempurature}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //该方法实现用图片替换天气文字信息
  String imgChosen(String wea_img) {
    if (wea_img == "qing" || wea_img == "晴") {
      return "https://static.easyicon.net/preview/55/552441.gif";
    } else if (wea_img == "yun" || wea_img == "多云") {
      //return "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3948070696,1159337730&fm=15&gp=0.jpg";
      return "https://static.easyicon.net/preview/55/552442.gif";
    } else {
      return "https://static.easyicon.net/preview/55/552443.gif";
    }
  }
}

//以下三个类为本应写在另外一个文件中的weather等信息
class Weather {
  Weather();
  String cityName;
  String updateTime;
  List<DataBean> dataBean = new List();
}

class DataBean {
  DataBean();
  String day;
  //String week;
  String weather;
  int air;
  String airLevel;
  String win_speed;
  int humidity;
  String wea_img;
  String curTempurature;
  String maxTempurature;
  String minTempurature;
  List<HourBean> hourBean = new List();
}

class HourBean {
  String time;
  String weather;
  String curTempurature;
  String wea_img;
  // void myPrint() {
  //   print(time + " " + weather + " " + curTempurature);
  // }
}
