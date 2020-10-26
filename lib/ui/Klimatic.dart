import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
        return new ChangeCity();
      })
    );

    if(results!=null && results.containsKey('enter')){
      _cityEntered = results['enter'];
    }
  }

  void showStuff() async{
    Map _data = await getWeather(util.apiId, util.defaultCity);
    debugPrint(_data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu),
              onPressed: () {_goToNextScreen(context);})
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
            width: 490.0,
            height: 1200,
            fit: BoxFit.fill,),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text("${_cityEntered == null ? util.defaultCity : _cityEntered}",
            style: cityStyle(),),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          updateTempWidget(_cityEntered),
        ],
      ),
    );
  }
  

  Widget updateTempWidget(String city){
    return new FutureBuilder(
        future: getWeather(util.apiId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
          if(snapshot.hasData){
            Map content = snapshot.data;
            return new Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(content['main']['temp'].toString(),
                    style: tempStyle(),),
                  )
                ],
              ),
            );
          }
          else{
            return new Container();
          }
        });
  }

  Future<Map> getWeather(String apiId, String city) async{
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=imperial';
    http.Response response = await http.get(apiUrl);
    
    return json.decode(response.body);
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldTextController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        title: new Text("Change City"),
        centerTitle: true,
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/white_snow.png",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Enter city",
                  ),
                  controller: _cityFieldTextController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context, {
                        'enter' : _cityFieldTextController.text,
                      });
                    },
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    child: new Text("Get Weather")),
              )
            ],
          )
        ],
      ),
    );
  }
}



TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}

