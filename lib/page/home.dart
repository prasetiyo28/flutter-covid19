import 'dart:ffi';


// import 'dart:ffi';

import 'package:Covid19Info/model/modelCorona.dart';
import 'package:Covid19Info/model/modelNews.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  int _confirmed = 0;
  int _recovered = 0;
  int _deaths = 0;
  DateTime _lastUpdate;
  String localization = 'id';
  String country = "Indonesia";

  int _radioValue1 = -1;
  
  

  void _handleRadioValueChange1(int value) {
    Navigator.pop(context);
    setState(() {
      _radioValue1 = value;
      
      switch (_radioValue1) {
        case 0:
          _change(0);
          break;
        case 1:
          _change(1);
          break;
      }
    });
  }


  int _counter = 0;
  int value = 1;
  var _url = "https://covid19.mathdro.id/api/countries/id";
  void _change(int value) {
    Navigator.pop(context);
    switch (value) {
      case 2:
        {
          setState(() {
            country = "Global";
             _radioValue1 = value;
            _url = "https://covid19.mathdro.id/api/";
            _fetchData(_url);
            localization = "en";
          });
        }
        break;
      case 1:
        {
          setState(() {
                        country = "Indonesia";
             _radioValue1 = value;
            _url = "https://covid19.mathdro.id/api/countries/id";
            _fetchData(_url);
            localization = "id";
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
      });
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchData(_url);
  }

  @override
  Widget build(BuildContext context) {
    Color cDeaths = Color.fromRGBO(248, 64, 58, 1.0);
    Color cConfirmed = Color.fromRGBO(251, 188, 36, 1.0);
    Color cRecovered = Color.fromRGBO(30, 118, 236, 1.0);
    Color cBG = Color.fromRGBO(42, 46, 50, 1.0);

    ScreenUtil.init(context,
        width: 411.42857142857144,
        height: 843.4285714285714,
        allowFontScaling: true);

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
    
    void _newTaskModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: cBG,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: new Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                          vertical: ScreenUtil().setHeight(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Lokasi"),
                          IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ),
                    ListTileTheme(
                      selectedColor: Colors.amber,
                      textColor: _radioValue1== 1 ? Colors.amber : Colors.white,
                                          child: RadioListTile(
                          
                          title: const Text("Indonesia"),
                          value: 1,
                          groupValue: _radioValue1,
                          onChanged: _change,
                          activeColor: Colors.amber,
                          
                        
                        ),
                    ),
                    ListTileTheme(
                      textColor: _radioValue1== 2 ? Colors.amber : Colors.white,
                                          child: RadioListTile(
                        title: const Text('Global'),
                        value: 2,
                        groupValue: _radioValue1,
                        onChanged: _change,
                        activeColor: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 37, 41, 1.0),
      bottomSheet: BottomSheetStateless(
        localization: this.localization,
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
                      Image.asset(
                        "assets/icon.png",
                        width: 20,
                      ),
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
                padding: const EdgeInsets.only(top: 27 , bottom: 27),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white10),
                    color: cBG,
                  ),
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      _newTaskModalBottomSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: Colors.amber),
                            Text(
                              country,
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                        Icon(Icons.keyboard_arrow_down)
                        
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _lastUpdate == null
                            ? "day"
                            : "Last Updated," +
                                DateFormat('dd MMM , kk:mm')
                                    .format(_lastUpdate),
                        style: TextStyle(fontSize: 8),
                      ),
                      Text(
                        "Update Kasus Corona",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Lihat Detail", style: TextStyle(fontSize: 10.ssp, color: Colors.amber)),
                      Icon(Icons.keyboard_arrow_right, color: Colors.amber,)
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: cBG,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        chartWidget,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Confimed",
                                    style: TextStyle(
                                        fontSize: 10, color: cConfirmed),
                                  ),
                                  Text(
                                      _confirmed == 0
                                          ? "kosong"
                                          : _confirmed.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Recovered",
                                    style: TextStyle(
                                        fontSize: 10, color: cRecovered),
                                  ),
                                  Text(
                                      _recovered == 0
                                          ? "kosong"
                                          : _recovered.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Deaths",
                                    style:
                                        TextStyle(fontSize: 10, color: cDeaths),
                                  ),
                                  Text(
                                      _deaths == 0
                                          ? "kosong"
                                          : _deaths.toString(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetStateless extends StatelessWidget {
  final String localization;
  const BottomSheetStateless({this.localization}) : super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil.init(context,
        width: 411.42857142857144,
        height: 843.4285714285714,
        allowFontScaling: true);

    String title = "Popular Covid 19 News";
    if (this.localization == "id") {
      title = "Berita Covid 19 Terkini";
    }

    return SolidBottomSheet(
        minHeight: 300.h,
        maxHeight: 720.h,
        toggleVisibilityOnTap: true,
        draggableBody: true,
        headerBar: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(42, 46, 50, 1.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          height: 50.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.minimize,
                  size: 30.w, color: Color.fromRGBO(253, 217, 132, 1.0)),
              Container(
                  transform: Matrix4.translationValues(0.0, 20.0, 0.0),
                  padding: EdgeInsets.only(left: 15.w),
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15.ssp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ],
          ),
        ),
        body: Container(
            color: Color.fromRGBO(42, 46, 50, 1.0),
            child: NewsListStateful(
              localization: this.localization,
            )));
  }
}

class NewsListStateful extends StatefulWidget {
  final String localization;
  const NewsListStateful({this.localization}) : super();

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsListStateful> {
  Color titleColor = Color.fromRGBO(251, 188, 36, 1.0);
  List<News> articles = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  Future<void> _fetchDataNews() async {
    final response = await http.get("https://corona-api-news.herokuapp.com/" +
        widget.localization +
        "/get");
    // print(response.body);
    if (response.statusCode == 200 && this.mounted) {
      final data = jsonDecode(response.body);
      final jsonContents = data['content'];
      List<News> contents =
          jsonContents.map<News>((content) => News.fromJson(content)).toList();

      setState(() {
        articles = contents;
      });
    }
  }

  Future<void> _fetchDataNewsPrev() async {
    final id = articles[articles.length - 1].id;

    final response = await http.get("https://corona-api-news.herokuapp.com/" +
        widget.localization +
        "/" +
        id +
        "/prev");
    if (response.statusCode == 200 && this.mounted) {
      final data = jsonDecode(response.body);
      final jsonContents = data['content'];
      List<News> contents = articles;
      List<News> newContents =
          jsonContents.map<News>((content) => News.fromJson(content)).toList();
//      contents.removeRange(0, newContents.length);
      newContents.insertAll(0, contents);

      setState(() {
        articles = newContents;
      });
    }
  }

  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 411.42857142857144,
        height: 843.4285714285714,
        allowFontScaling: true);

    return Padding(
        padding: EdgeInsets.only(top: 30.h),
        child: SmartRefresher(
            enablePullUp: true,
//            enablePullDown: true,
            header: MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: () async {
              await _fetchDataNews();
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              await _fetchDataNewsPrev();
              _refreshController.loadComplete();
            },
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                    color: Colors.white10,
                    indent: 20.w,
                    endIndent: 20.w,
                    thickness: 1.25.h),
                shrinkWrap: true,
                itemCount: articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return NewsStateful(
                      key: UniqueKey(), article: articles[index]);
                })));
  }
}

class NewsStateful extends StatefulWidget {
  final News article;
  NewsStateful({Key key, this.article}) : super();

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<NewsStateful> {
  Color titleColor = Color.fromRGBO(251, 188, 36, 1.0);

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    ScreenUtil.init(context,
        width: 411.42857142857144,
        height: 843.4285714285714,
        allowFontScaling: true);

    News article = widget.article;
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
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 200.h,
                          maxWidth: 310.w,
                          minWidth: 310.w,
                          minHeight: 100.h),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(15.w, 7.h, 5.w, 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                article.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13.ssp,
                                    fontWeight: FontWeight.bold,
                                    color: titleColor),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    article.source,
                                    style: TextStyle(
                                      fontSize: 8.ssp,
                                    ),
                                  ),
                                  Text(
                                    "Published " +
                                        new DateFormat.yMMMd()
                                            .format(article.publishedDate),
                                    style: TextStyle(
                                      fontSize: 8.ssp,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ))),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(6),
                          vertical: ScreenUtil().setHeight(10)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(article.coverImage,
                              height: 80.h, width: 80.w, fit: BoxFit.cover))),
                ],
              )),
        ],
      ),
    );
  }

  
}
