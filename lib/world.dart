import 'dart:convert';

import 'package:covid19/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class World extends StatefulWidget {
  @override
  _WorldState createState() => _WorldState();
}

class _WorldState extends State<World> {

  var loading = false;
  final list = List<Country>();
  Country summary;
  List data;

  getData() async {
    setState(() {
      loading = true;
    });
    final url = "https://www.trackcorona.live/api/countries/";
    final response = await http.get(url);
    setState(() {
      final result = jsonDecode(response.body);
      data = result['data'];
      loading = false;
    });
    return 'success';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Country Details"),
        centerTitle: true,
      ),
      body: loading
      ? Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, i){
          final x = data[i];
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15),
                  child: Row(
                    children: <Widget>[
                      Card(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child:Text(x['location'].toString(), style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24
                                  ),textAlign: TextAlign.left,),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            side: BorderSide(
                                              color: Colors.orange,
                                              width: 4.0,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(x['confirmed'].toString(), style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange
                                              ),),
                                              Text("Confirmed", style: TextStyle(fontSize: 14),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            side: BorderSide(
                                              color: Colors.green,
                                              width: 4.0,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(x['recovered'].toString(), style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green
                                              ),),
                                              Text("Recovered", style: TextStyle(fontSize: 14),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            side: BorderSide(
                                              color: Colors.red,
                                              width: 4.0,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(x['dead'].toString(), style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red
                                              ),),
                                              Text("Deaths", style: TextStyle(fontSize: 14),)
                                            ],
                                          ),
                                        ),
                                      )
                                    ]
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          );
        })
    );
  }
}