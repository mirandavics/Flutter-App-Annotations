class Annotation {
  int id;
  String token;
  String text;
  String datetime;

  Annotation({
    this.id,
    this.token,
    this.text,
    this.datetime
  });

  dynamic toEdit() => {
    "id": id,
    "token": token,
    "text": text,
  };

  dynamic toSave() => {
    "id": id,
    "token": token,
    "text": text,
    "datetime": datetime,
  };

  factory Annotation.fromMap(json)  {

    var annotation = new Annotation();
    annotation.id = json["id"];
    annotation.token = json["token"];
    annotation.text = json["text"];
    annotation.datetime= json["datetime"];

    return annotation;
  }
}