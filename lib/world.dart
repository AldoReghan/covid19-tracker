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
  Country summary;
  List<Country> _search = [];
  final list = List<Country>();
  List data;

  getData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final url = "https://www.trackcorona.live/api/countries";
    final response = await http.get(url);
    setState(() {
      final result = jsonDecode(response.body);
      data = result['data'];
      for (var i = 0; i < data.length; i++) {
        summary = Country(
          location: data[i]['location'],
          latitude: data[i]['latitude'].toString(),
          longitude: data[i]['longitude'].toString(),
          confirmed: data[i]['confirmed'].toString(),
          deaths: data[i]['dead'].toString(),
          recovered: data[i]['recovered'].toString(),
        );
        list.add(summary);
      }
      loading = false;
    });
    return 'success';
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if(text.isEmpty){
      setState((){});
      return;
    }

    list.forEach((f){
      if (f.location.contains(text)) _search.add(f); 
    });

    setState((){});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Column(
       children: <Widget>[
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                margin: EdgeInsets.only(top: 20),
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: "Search", border: InputBorder.none
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel), 
                    onPressed: (){
                      controller.clear();
                      onSearch('');
                    }
                  ),
                ),
              ),
            ),
          ),
          loading
          ? Center(child: CircularProgressIndicator(),)
          : 
          Expanded(
            child: _search.length != 0 || controller.text.isNotEmpty 
            ? ListView.builder(
              itemCount: _search.length,
              itemBuilder: (context,i){
                final b = _search[i];
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
                                      child:Text(b.location.toString(), style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24
                                      ),textAlign: TextAlign.left,),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 80,
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
                                                  Text(b.confirmed.toString(), style: TextStyle(
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
                                            height: 80,
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
                                                  Text(b.recovered.toString(), style: TextStyle(
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
                                            height: 80,
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
                                                  Text(b.deaths.toString(), style: TextStyle(
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
            : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i){
              final x = list[i];
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
                                      child:Text(x.location.toString(), style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24
                                      ),textAlign: TextAlign.left,),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 80,
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
                                                  Text(x.confirmed.toString(), style: TextStyle(
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
                                            height: 80,
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
                                                  Text(x.recovered.toString(), style: TextStyle(
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
                                            height: 80,
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
                                                  Text(x.deaths.toString(), style: TextStyle(
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
            }),
          ),
       ],
     )
    );
  }
}