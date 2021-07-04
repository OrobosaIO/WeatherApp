import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(
  MaterialApp(
    title: "Weather",
    home: Home(),
  )
);

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return HomeState();
  }
}

class HomeState extends State<Home>{
  var temp;
  var description;
  var humidity;
  var windSpeed;
  var prec;
  var region;
  String location = '';


  Future getWeather() async{
    http.Response response = await http.get(Uri.parse ('http://api.weatherapi.com/v1/current.json?key=b70fcb2d4a0342699ab185711210307&q=$location&aqi=no'));
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['current']['temp_c'];
      this.description = results['current']['condition']['text'];
      this.humidity = results['current']['humidity'];
      this.windSpeed = results['current']['wind_mph'];
      this.prec = results['current']['precip_mm'];
      this.region = results['location']['country'];
    });
  }


  @override
  void initState(){
    super.initState();
    this.getWeather();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2, //gets the height of the device divided by 2
            width: MediaQuery.of(context).size.width, //gets the width of the device
            decoration:
            BoxDecoration(
                //color: const Color(0xff7c94b6),
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                  ColorFilter.mode(Colors.black.withOpacity(0.85),
                      BlendMode.dstATop),
                  image: AssetImage('images/weather.jpg'), //Photo by Mado El Khouly on Unsplash
                  ),
                borderRadius: BorderRadius.only(  //corner radius
                    topLeft: Radius.circular(0),
                    topRight:Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)
                ),
                ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget> [
               Padding(
                 padding: EdgeInsets.only(bottom: 10.0),
                 child: new TextField(
                   textAlign: TextAlign.center,
                   decoration: new InputDecoration.collapsed(hintText: "--"),
                   style: TextStyle(
                       color: Colors.white,
                       fontSize: 40.0,
                       fontWeight: FontWeight.w600
                   ),
                   onSubmitted: (String text){
                     location = text;
                     getWeather();
                   },
                 )
               ),
               Text(
                 temp != null ? temp.toString() + "\u00B0" : "--",
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 20.0,
                   fontWeight: FontWeight.w600
                 ),
               ),
               Padding(
                   padding: EdgeInsets.only(top: 10.0),
                   child: Text(
                     description != null ? description.toString() : "--",
                     style: TextStyle(
                         color: Colors.white,
                         fontSize: 14.0,
                         fontWeight: FontWeight.w600
                     ),
                   )
               ),
             ],
           )
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget> [
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.thermometerEmpty),
                      title: Text("Temperature", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),) ,
                      trailing: Text(temp != null ? temp.toString() + "\u00B0" : "--", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54),),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.water),
                      title: Text("Humidity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),),
                      trailing: Text(humidity != null ? humidity.toString() : "--", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54),),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.wind),
                      title: Text("Wind Speed", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),),
                      trailing: Text(windSpeed != null ? windSpeed.toString() : "--", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54),),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.cloudRain),
                      title: Text("Precipitation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),),
                      trailing: Text(prec != null ? prec.toString() : "--", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54),),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.locationArrow),
                      title: Text("Country", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),),
                      trailing: Text(region != null ? region.toString() : "--", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54),),
                    )
                  ],
                ),
              )
          )
        ]
      ),
    );
  }
}