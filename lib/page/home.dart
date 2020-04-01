import 'dart:ffi';

import 'package:corrona_frontend/model/modelCorona.dart';
import 'package:corrona_frontend/model/modelNews.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _HomeState extends State<Home> {
  Corrona corrona;
  List<News> articles = [];
  int _confirmed = 0;
  int _recovered = 0;
  int _deaths = 0;
  bool _newsOpen = false;
  DateTime _lastUpdate;
  NewsList newsListData;

  
  int _counter = 0;
  var _value = "1";
  var _url = "https://covid19.mathdro.id/api/countries/id";
  void _change(_value){
    switch (_value) {
      case  "2":
        {
          setState(() {
            _url = "https://covid19.mathdro.id/api/";
            _fetchData(_url);
          });
        }
        break;
      case"1":
      {
          setState(() {
            _url = "https://covid19.mathdro.id/api/countries/id";
            _fetchData(_url);
          });
        }
    }
  }

  Future<Null> _fetchData(_url) async {

    final response = await http.get(_url);
    // print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      // var value = datajson.fromJson(datajson);
      // print(value['value']);
      setState(() {
       Corrona corrona = new Corrona.fromJson(data);
       _confirmed = corrona.confirmed.value;
       _recovered = corrona.recovered.value;
       _deaths = corrona.death.value;
       _lastUpdate = corrona.lastUpdate;
       newsListData = new NewsList();
      });
    }
  }

  ScrollController _newsController;
  _newsScrollController() {
    if (_newsController.offset >= _newsController.position.maxScrollExtent &&
        !_newsController.position.outOfRange) {
      newsListData.prev();
    }
    if (_newsController.offset <= _newsController.position.minScrollExtent &&
        !_newsController.position.outOfRange) {
      newsListData.next();
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    _newsController = ScrollController();
    _newsController.addListener(_newsScrollController);
    // _value;
    _fetchData(_url);
  }

  
  @override
  Widget build(BuildContext context) {
    Color cDeaths = Color.fromRGBO(248, 64, 58, 1.0);
    Color cConfirmed = Color.fromRGBO(251, 188, 36, 1.0);
    Color cRecovered = Color.fromRGBO(253, 217, 132, 1.0);

    ScreenUtil.init(context,
        width: 411.42857142857144,
        height: 843.4285714285714,
        allowFontScaling: true
    );

    var data = [
      ClicksPerYear('2016', _deaths, cDeaths),
      ClicksPerYear('2017', _confirmed, cConfirmed),
      ClicksPerYear('2018', _recovered, cRecovered),
    ];

    var series = [
      charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.PieChart(series,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 20));

    var chartWidget = Padding(
      padding: EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 80, horizontal: 103),
              child: Column(
                children: <Widget>[
                  // Text(
                  //   "157,584",
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // Text(
                  //   "case reported",
                  //   style: TextStyle(fontSize: 8),
                  // ),
                ],
              )),
          SizedBox(
            height: 180.0,
            child: chart,
          ),
        ],
      ),
    );

    return Scaffold(
      bottomSheet: SolidBottomSheet(
          minHeight: 150.h,
          maxHeight: 800.h,
          toggleVisibilityOnTap: true,
          draggableBody: true,
          showOnAppear: _newsOpen,
          headerBar: Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            height: 20.h,
            child: Icon(Icons.minimize, size: 30.w),
          ),
          body: Container(
            color: Colors.black26,
            height: 30.h,
            child: Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: ListView(
                  controller: _newsController,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.h),
                        child: newsListData
                    )
                  ],
                )
            ),
          )
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 40, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset("assets/icon.png",width: 20,),
                      Text(
                        "Covid",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "19",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  Icon(Icons.notifications)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_lastUpdate == null ? "day" :
                        "Last Updated," + DateFormat('dd MMM , kk:mm').format(_lastUpdate),
                          style: TextStyle(fontSize: 8),
                        ),
                        Text(
                          "Total Case Stats",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: [

                              DropdownMenuItem<String>(
                                value: "1",
                                child: Text(
                                  "Indonesia",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "2",
                                child: Text(
                                  "Global",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {

                                _value = value;
                                _change(_value);
                              });
                            },
                            value: _value,

                          ),
                        ),
                        // Text(
                        //   "Indonesia",
                        //   style: TextStyle(fontSize: 12),
                        // ),
                        // Icon(Icons.keyboard_arrow_down),
                      ],
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black26,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      chartWidget,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Confimed",
                                  style: TextStyle(
                                      fontSize: 10, color: cConfirmed),
                                ),
                                Text(_confirmed == 0 ? "kososng" : _confirmed.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Recovered",
                                  style: TextStyle(
                                      fontSize: 10, color: cRecovered),
                                ),
                                Text(_recovered == 0 ? "kososng" : _recovered.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Deaths",
                                  style:
                                  TextStyle(fontSize: 10, color: cDeaths),
                                ),
                                Text(_deaths == 0 ? "kososng" : _deaths.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsList extends StatefulWidget {
  _NewsListState newsListState = _NewsListState();

  Future<double> next() async {
    return await newsListState._fetchDataNewsNext();
  }
  Future<double> prev() async {
    return await newsListState._fetchDataNewsPrev();
  }

  @override
  _NewsListState createState() => newsListState;
}

class _NewsListState extends State<NewsList> {
  List<News> articles = [];
  Color titleColor = Color.fromRGBO(251, 188, 36, 1.0);

  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchDataNews();
  }

  Future<Null> _fetchDataNews() async {

    final response = await http.get("https://corona-api-news.herokuapp.com/id/get");
    // print(response.body);
    if (response.statusCode == 200 && this.mounted) {
      final data = jsonDecode(response.body);
      final jsonContents = data['content'];
      List<News> contents = jsonContents.map<News>((content) => News.fromJson(content)).toList();

      setState(() {
        articles = contents;
      });
    }
  }

  Future<double> _fetchDataNewsPrev() async {
    final id = articles[articles.length - 1].id;

    final response = await http.get("https://corona-api-news.herokuapp.com/id/"+id+"/prev");
    if (response.statusCode == 200 && this.mounted) {
      final data = jsonDecode(response.body);
      final jsonContents = data['content'];
      List<News> contents = articles;
      List<News> newContents = jsonContents.map<News>((content) => News.fromJson(content)).toList();
//      contents.removeRange(0, newContents.length);
      newContents.insertAll(0, contents);

      ScreenUtil.init(context,
          width: 411.42857142857144,
          height: 843.4285714285714,
          allowFontScaling: true
      );

      setState(() {
        articles = newContents;
      });

      return (contents.length.toDouble() - 3.62) * 120.h;
    }
  }

  Future<double> _fetchDataNewsNext() async {
    final id = articles[0].id;

    final response = await http.get("https://corona-api-news.herokuapp.com/id/"+id+"/next");
    if (response.statusCode == 200 && this.mounted) {
      final data = jsonDecode(response.body);
      final jsonContents = data['content'];
      List<News> contents = articles;
      List<News> newContents = jsonContents.map<News>((content) => News.fromJson(content)).toList();
//      contents.removeRange(contents.length-newContents.length, contents.length);
      contents.insertAll(0, newContents);

      setState(() {
        articles = contents;
      });

      ScreenUtil.init(context,
          width: 411.42857142857144,
          height: 843.4285714285714,
          allowFontScaling: true
      );

      return newContents.length.toDouble() * 120.h;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 411.42857142857144,
        height: 843.4285714285714,
        allowFontScaling: true
    );
    var news = articles.map<Widget>((article) {
      String content = article.content;
      if (content.length > 120) {
        content = content.substring(0, 120) + "...";
      }
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
                onTap: () => launch(article.link),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(6),
                          vertical: ScreenUtil().setHeight(5)
                      ),
                      child:
                      Image.network(
                          article.coverImage,
                          height: 80.h,
                          width: 80.w,
                          fit: BoxFit.cover
                      ),
                    ),
                    Container(
                        width: 285.w,
                        height: 120.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              article.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 13.ssp,
                                  fontWeight: FontWeight.bold,
                                  color: titleColor
                              ),
                            ),
                            Text(
                              content,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 11.ssp,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  article.source,
                                  style: TextStyle(
                                    fontSize: 8.ssp,
                                  ),
                                ),
                                Text(
                                  "Published " + new DateFormat.yMMMd().format(
                                      article.publishedDate),
                                  style: TextStyle(
                                    fontSize: 8.ssp,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                    )
                  ],
                )
            ),
          ],
        ),
      );
    }).toList();
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: news
      ),
    );
  }
}
