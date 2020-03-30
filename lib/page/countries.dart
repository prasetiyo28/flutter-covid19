import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:corrona_frontend/model/modelCountries.dart';


class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  List<CountryDetail> _list = [];
  var loading = false;
  Future<Null> _fetchData() async {
    setState(() {
      loading = true;
    });
    final response = await http.get("https://covid19.mathdro.id/api/confirmed");
    // print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _list.add(CountryDetail.fromJson(i));
        }
        loading = false;
      });
    }
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Corrona Data"),),
      body: Container(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, i) {
                  final x = _list[i];
                  return Container(
                    decoration: BoxDecoration(
    border: Border.all(
      color: Colors.black,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(12),
  ),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(x.provinceState != null ? x.provinceState : "-"),
                        Text(x.countryRegion != null ? x.countryRegion : "-"),
                        Text("Confirmed : "),
                        Text(x.confirmed.toString() != null ? x.confirmed.toString() : "-"),
                        Text("Recovered : "),
                        Text(x.recoverd.toString() != null ? x.recoverd.toString() : "-"),
                        Text("Deaths : "),
                        Text(x.deaths != null ? x.deaths.toString() : "-"),
                        // Text(x.lat != null ? x.lat : "-"),
                      
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}