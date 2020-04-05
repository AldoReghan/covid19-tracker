import 'dart:convert';

import 'package:covid19/world.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './model/indonesia_model.dart';
import 'model/world_model.dart';

class Indonesia extends StatefulWidget {
  @override
  _IndonesiaState createState() => _IndonesiaState();
}

class _IndonesiaState extends State<Indonesia> {

  var loading = false;
  IndonesiaModel summary;
  final list = new List<IndonesiaModel>();

  WorldModel summaryWorld;
  final worldlist = List<WorldModel>();

  getDataIndonesia() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get("https://kawalcovid19.harippe.id/api/summary");
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    summary = IndonesiaModel(
      confirmed: data['confirmed']['value'], 
      recovered: data['recovered']['value'], 
      deaths: data['deaths']['value'], 
      activeCare: data['activeCare']['value']
    );
    list.add(summary);
    print("Confirmed: "+summary.confirmed.toString());
    print("dalam penanganan: "+summary.activeCare.toString());
    print("sembuh: "+summary.recovered.toString());
    print("meninggal dunia: "+summary.deaths.toString());
  }

  worldData() async {
    worldlist.clear();
    final responsePositive = await http.get("https://api.kawalcorona.com/positif");
    final resultPositive = jsonDecode(responsePositive.body);

    final responseRecovered = await http.get("https://api.kawalcorona.com/sembuh");
    final resultRecovered = jsonDecode(responseRecovered.body);

    final responseDeaths = await http.get("https://api.kawalcorona.com/meninggal");
    final resultDeaths = jsonDecode(responseDeaths.body);

    summaryWorld = WorldModel(
      confirmed: resultPositive['value'],
      recovered: resultRecovered['value'],
      deaths: resultDeaths['value']
    );

    print(summaryWorld.confirmed.toString());

    worldlist.add(summaryWorld);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataIndonesia();
    worldData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19 TRACKER"),
        centerTitle: true,
      ),
      body: loading
      ? Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i){
          final x = list[i];
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: Text("COVID-19 In Indonesia", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ) ,
                  textAlign: TextAlign.center,),
              ),
              Container(
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 140,
                        width: 140,
                        margin: EdgeInsets.only(left: 100, top: 2),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: <Widget>[
                              Center(
                                child:Text(x.confirmed.toString(), style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 24
                                ),),
                              ),
                              Center(
                                child:Text("Confirmed", style: TextStyle(
                                  fontSize: 14
                                ),),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(width: 4,color: Colors.orange, style: BorderStyle.solid)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                  left: 25,
                  right: 20,
                  bottom: 20
                ),
                child: Row(
                  children: <Widget>[
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
                      height: 100,
                      width: 100,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors.blue,
                            width: 4.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(x.activeCare.toString(), style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                            ),),
                            Text("Active Care", style: TextStyle(fontSize: 14),)
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
                  ],
                ),
              ),
              Container(
                child: Text("Worlwide Report", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 120,
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
                            Text(summaryWorld.confirmed.toString(), style: TextStyle(
                              fontSize: 20,
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
                      width: 120,
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
                            Text(summaryWorld.recovered.toString(), style: TextStyle(
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
                      width: 120,
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
                            Text(summaryWorld.deaths.toString(), style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                            ),),
                            Text("Deaths", style: TextStyle(fontSize: 14),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: 200,
                  child: Container(
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context)=>World())
                        );
                      },
                      child: Card(
                        color: Colors.lightBlueAccent,
                        margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text("See Country Details", style: TextStyle(
                            color: Colors.white
                          ) ,textAlign: TextAlign.center,)),
                      ),
                    ),
                  ),
              )
            ],
          );
        })
    );
  }
}