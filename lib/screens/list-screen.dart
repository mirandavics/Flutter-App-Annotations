import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/api.dart';
import 'package:flutter_app/models/Annotation.dart';
import 'package:flutter_app/models/http-response.dart';
import 'package:flutter_app/screens/form-screen.dart';
import 'package:flutter_app/screens/login-screen.dart';
import 'package:flutter_app/services/annotationsService.dart';

class ListScreen extends StatefulWidget {
  @override
  State createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  List<dynamic> annotations;
  Annotation newAnnotation;
  bool loading = true;

  @override
  void initState() {
    super.initState();
      getAll();
  }

  Future<dynamic> getAll() async {
    var token = getToken();

    HttpResponse response = await getAllAnnotations(token);

    List<dynamic> list = jsonDecode(response.data).map((c) => Annotation.fromMap(c)).toList();
    setState(() {
      annotations = list;
      loading = false;
    });
  }

  formatDate(value) {

    var newValue = value.replaceAll('-', '');

    var year = newValue.substring(0, 4);
    var month = newValue.substring(4, 6);
    var day = newValue.substring(6, 8);

    return Text(day + '/' + month + '/' + year);
  }

  goToFormScreen(object) {
    Annotation annotation;
    setState(() {
      annotation = object;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormScreen(annotation)),
    );
  }

  goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anotações'),
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.exit_to_app),
          onTap: goToLogin,
        ),
      ),
      body: Column(
        children: <Widget>[
          loading == true ?
          SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              child: Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator()
            )
          )
        : Expanded(
            child: ListView.builder(
                itemCount: annotations == null ? 0 : annotations.length,
                itemBuilder: (context, index) =>
                    Container(
                      color: (index % 2 == 0) ? Colors.white : Color.fromRGBO(0, 0, 0, 0.002),
                      child: ListTile(
                        isThreeLine: true,
                        title: formatDate(annotations[index].datetime),
                        subtitle: Text(annotations[index].text,
                          overflow: TextOverflow.ellipsis
                        ),
                        leading: Icon(Icons.event_note),
                        onTap: () => goToFormScreen(annotations[index]),
                      ),
                    )
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToFormScreen(newAnnotation),
        child: Icon(Icons.add),
      ),
    );
  }
}