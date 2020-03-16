import 'package:flutter/material.dart';
import 'dart:math';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
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

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  @override
  Widget build(BuildContext context) {

    Color cDeaths = Color.fromRGBO(248, 64, 58, 1.0);
    Color cConfirmed = Color.fromRGBO(251, 188, 36, 1.0);
    Color cRecovered = Color.fromRGBO(253, 217, 132, 1.0);

    var data = [
      ClicksPerYear('2016', 12, cDeaths),
      ClicksPerYear('2017', 42,  cConfirmed),
      ClicksPerYear('2018', 30, cRecovered),
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

    var chart = charts.PieChart(
      series,
      animate: true,
      defaultRenderer: new charts.ArcRendererConfig(arcWidth: 25)
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(10.0),
      child: SizedBox(
        height: 180.0,
        child: chart,
      ),
    );
    return Scaffold(
      bottomSheet: SolidBottomSheet(
        minHeight: 150,
        headerBar: Container(
          decoration: BoxDecoration(
           color: Colors.black26,
           borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
          ),
          
          height: 20,
          child: Center(
            child: Container(child: Icon(Icons.minimize)),
          ),
        ),
        body: Container(
          
          color: Colors.black26,
          height: 30,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: ListView(
                children: <Widget>[
                  Column(children: <Widget>[
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                    Text("Data1"),
                  ],)
                ],
              )
            ),
          ),
        ),
      ),
      body: Container(
        
        child: Padding(
        padding: const EdgeInsets.only(top : 40.0, right: 20, left: 20),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          
          Row(
            children: <Widget>[
              Text("Covid",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
              Text("19",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top:30),
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Last Updated , 16 Maret 2019" , style: TextStyle(fontSize: 8),),
                    Text("Total Case Stats",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                    Text("Indonesia",style: TextStyle(fontSize: 12),),
                    Icon(Icons.keyboard_arrow_down),
                  ],),
                )

              ],
            ),
          ),

          Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color : Colors.black26,
              
              
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                chartWidget,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      Text("Confimed",style: TextStyle(fontSize: 10, color: cConfirmed),),
                      Text("98074",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      Text("Recovered",style: TextStyle(fontSize: 10, color: cRecovered),),
                      Text("98074",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      Text("Deaths",style: TextStyle(fontSize: 10, color: cDeaths),),
                      Text("98074",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],),
                  ),

                ],)
              ],
            ),
          ),
        ),

        ],),
      ),),
      
    );
  }
}

