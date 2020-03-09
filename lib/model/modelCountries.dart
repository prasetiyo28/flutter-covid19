class CountryDetail {
  final String provinceState;
  final String countryRegion;
  // final int lastUpdate;
  // final double lat;
  // final String long;
  final int confirmed;
  final int deaths;
  final int recoverd;
  
  CountryDetail(
      {this.provinceState,
      this.countryRegion,
      // this.lastUpdate,
      // this.lat,
      // this.long,
      this.confirmed,
      this.deaths,
      this.recoverd
      });
    
     

  factory CountryDetail.fromJson(Map<String, dynamic> json) {
    return new CountryDetail(
        provinceState: json['provinceState'],
        countryRegion: json['countryRegion'],
        // lastUpdate: json['lastUpdate'],
        // lat: json["lat"] as double,
        // long: json['long'],
        confirmed: json['confirmed'],
        deaths: json['deaths'],
        recoverd: json['recovered']
    );
}
}