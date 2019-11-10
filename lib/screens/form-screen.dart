import 'dart:convert';

import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/api.dart';
import 'package:flutter_app/models/Annotation.dart';
import 'package:flutter_app/screens/list-screen.dart';
import 'package:flutter_app/services/annotationsService.dart';

class FormScreen extends StatefulWidget {
  final Annotation annotation;

  FormScreen(this.annotation);

  @override
  State createState() => FormScreenState();
}

class FormScreenState extends State<FormScreen> {
  var annotationField = TextEditingController();
  bool loadingSave = false;
  bool loadingRemove = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    if (widget.annotation != null)
      annotationField.text = widget.annotation.text;
  }

  validForm() {
    if (annotationField.text == '') {
      FlushbarHelper.createError(
        message: 'É obrigatório preencher a anotação',
      ).show(context);

      return false;
    }

    return true;
  }

  save() async {
    if (validForm() == true) {
      setState(() {
        loadingSave = true;
      });

      var request = new Annotation();
      request.text = annotationField.text;
      request.token = token;
      request.datetime = DateTime.now().toString();
      request.id = widget.annotation != null ? widget.annotation.id : null;

      var response = await saveAnnotation(request.id, request.id != null ? request.toEdit() : request.toSave());
      var status = jsonDecode(response.statusCode.toString());
      showMessage(status, 'salva', 'salvar');
    }
  }

  remove() async {
    setState(() {
      loadingRemove = true;
    });
    var response = await deleteAnnotation(widget.annotation.id, token);
    var status = jsonDecode(response.statusCode.toString());
    showMessage(status, 'removida', 'remover');
  }

  showMessage(status, messageSuccess, messageFail) {
    setState(() {
      loadingSave = false;
      loadingRemove = false;
    });

    switch(status) {
      case 200:
        goToListScreen();
        FlushbarHelper.createSuccess(
          message: 'Anotação $messageSuccess com sucesso!',
        ).show(context);
        break;
      case 422:
        FlushbarHelper.createError(
          message: 'Ocorreu um problema ao $messageFail a anotação. Tente novamente.',
        ).show(context);
        break;
      default:
        FlushbarHelper.createError(
          message: 'Ocorrou um erro no servidor. Tente novamente mais tarde',
        ).show(context);
    }
  }

  goToListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anotação'),
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: goToListScreen,
        ),
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 280,
                  child:  TextFormField(
                      controller: annotationField,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        labelText: "Escreva aqui sua anotação",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                            fontSize: 20
                        ),
                      )),
                ),
              ),
        ]),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
                children: <Widget>[
                  widget.annotation != null && widget.annotation.id != null ?
                    FloatingActionButton(
                      heroTag: 'delete',
                      backgroundColor: Colors.red,
                      child: loadingRemove == false ?
                        Icon(Icons.delete) :
                        CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                        ),
                      onPressed: remove,
                    )
                  : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: FloatingActionButton(
                      heroTag: 'save',
                      backgroundColor: Colors.deepPurple,
                      child: loadingSave == false ?
                        Icon(Icons.check) :
                        CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                        ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        save();
                      },
                    ),
                  )
                ],
              ),
          ),
        ],
      ),
    );
  }
}