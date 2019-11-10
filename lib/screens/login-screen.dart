import 'dart:convert';

import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/screens/list-screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  var username = TextEditingController();
  var password = TextEditingController();
  bool loading = false;

  validLogin() {
    if (username.text != '' && password.text != '')
      return true;
    else {
      FlushbarHelper.createError(
        message: 'Os campos são obrigatórios',
      ).show(context);

      return false;
    }
  }

  void getLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      loading = true;
    });

    if (validLogin() == true) {
      var response = await registerLogin(username.text, password.text);
      var status = jsonDecode(response.statusCode.toString());

     switch(status) {
       case 200:
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => ListScreen()),
         );
         break;
       case 401:
         FlushbarHelper.createError(
           message: 'Nome ou senha inválidos',
         ).show(context);
         break;
       default:
         FlushbarHelper.createError(
           message: 'Ocorreu um problema. Tente novamente',
         ).show(context);
     }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Icon(Icons.supervised_user_circle, size: 90, color: Colors.deepPurple,)
              ),
              TextField(
                controller: username,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.person_outline,
                      color: Colors.black,
                    ),
                    hintText: "Nome"),
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                    hintText: "Senha"
                ),
                style: TextStyle(
                    color: Colors.black
                ),
                obscureText: true,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: SizedBox(
                      width: loading == false ? 280 : 50,
                      height: 50,
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          getLogin();
                        },
                        child: PhysicalModel(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(
                                loading == false ? 15 : 25
                            ),
                            child: Container(
                                alignment: Alignment(1.0, 1.0),
                                child: Center(
                                  child: loading == false ?
                                    Text('Entrar',
                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                    )
                                  : CircularProgressIndicator(
                                      backgroundColor: Colors.white70,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                                  )
                                )
                            )
                        ),
                      )
                  )
              )
            ]
        )
      )
    );
  }
}