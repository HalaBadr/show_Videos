import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player/youtube_player.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task_app/translations.dart';

//import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';

//https://jsoneditoronline.org/?id=e04b8a20dace4b96a68801f4c72bfda9
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
Map<String , dynamic> _data;

Future main()  async {
  _data = await getJSON();
  runApp(
      new MaterialApp(
          localizationsDelegates: [
            const TranslationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            //GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en',''), const Locale('ar',''),
          ],

          home: MyApp()));
}

Future<Map<String , dynamic>> getJSON() async {
  JsonCodec codec = new JsonCodec();
  String apiUrl = "https://my-json-server.typicode.com/HalaBadr/server/db";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}


class MyApp extends StatefulWidget{
  @override

  _HomeScreenState createState() => new _HomeScreenState();


}


class _HomeScreenState extends State<MyApp> {


  Future<void> _refresh() async
  {     print('refreshing...');
  _data = await getJSON();
  setState(() {
    _data=_data;
  });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey ,
      appBar: new AppBar(
        title: Center(
          child: new Text(Translations.of(context).text('App_Title')),
        ),
        backgroundColor: Colors.orange,
      ),
      body:
      new Container(
        child: new Center(
            child: new RefreshIndicator(
              child: new ListView.builder(
                  itemCount: _data["data"].length,
                  padding: const EdgeInsets.all(4.4),
                  itemBuilder: (BuildContext context, int position) {
                    return Column(
                      children: <Widget>[
                        Divider(
                          height: 3.4,
                        ),
                        ListTile(
                          title:(_data["data"][position]["id"]%2!=0)?
                          Text(
                            "${_data["data"][position]["data"]}",
                            style: TextStyle(
                              fontSize: 17.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ):
                          YoutubePlayer(
                            context: context,
                            source: _data["data"][position]["data"],
                            quality: YoutubeQuality.HIGH ,
                            autoPlay: false,

                          ),
                        )
                      ],
                    );
                  }),
              onRefresh: _refresh,
            )
        ),
      ),
    );
  }
}

