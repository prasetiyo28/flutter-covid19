class Corrona {
  
  
  final Confirmed confirmed;
  final Recovered recovered;
  final Death death;
  final DateTime lastUpdate;
  

  Corrona(
      {this.confirmed,
      this.recovered,
      this.death,
      this.lastUpdate
      });

  factory Corrona.fromJson(Map<String, dynamic> json) {
    return new Corrona(
       
        confirmed: Confirmed.fromJson(json['confirmed']),
        death: Death.fromJson(json['deaths']),
        recovered: Recovered.fromJson(json['recovered']),
        lastUpdate: DateTime.parse(json['lastUpdate']),  
        );

  }
}

class Confirmed {
  final int value;
  final String detail;
 

  Confirmed({this.value, this.detail});

  factory Confirmed.fromJson(Map<String, dynamic> json) {
    return new Confirmed(
      value: json['value'] as int,
      detail: json['detail'],
      
    );
  }
}

class Death {
  final int value;
  final String detail;
 

  Death({this.value, this.detail});

  factory Death.fromJson(Map<String, dynamic> json) {
    return new Death(
      value: json['value'] as int,
      detail: json['detail'],
      
    );
  }
}

class Recovered {
  final int value;
  final String detail;
 

  Recovered({this.value, this.detail});

  factory Recovered.fromJson(Map<String, dynamic> json) {
    return new Recovered(
      value: json['value'] as int,
      detail: json['detail'],
      
    );
  }
}

