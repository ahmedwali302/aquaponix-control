import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wifi/wifi.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'dart:convert';

//import 'dart:async';
//import 'package:socket_io/socket_io.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;
//import 'package:web_socket_channel/web_socket_channel.dart';
//import 'package:web_socket_channel/io.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Socket Demo';
    // IOWebSocketChannel channel ;
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white),
            headline: TextStyle(color: Colors.white),
            subtitle: TextStyle(color: Colors.white),
            subhead: TextStyle(color: Colors.white),
            body1: TextStyle(color: Colors.white),
            body2: TextStyle(color: Colors.white),
            button: TextStyle(color: Colors.white),
            caption: TextStyle(color: Colors.white),
            overline: TextStyle(color: Colors.white),
            display1: TextStyle(color: Colors.white),
            display2: TextStyle(color: Colors.white),
            display3: TextStyle(color: Colors.white),
            display4: TextStyle(color: Colors.white),
          ),
          buttonTheme: ButtonThemeData(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              disabledColor: Colors.lightBlueAccent.withOpacity(0.5),
              buttonColor: Colors.lightBlue,
              splashColor: Colors.cyan)),
      title: title,
      home: MyHomePage(
        title: title,
        // channel: channel,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  //WebSocketChannel channel;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool connected = false;
  String ip = '';
  //WebSocketChannel channel ;
  String URI = "http://46.101.237.179:3000";
  List<String> toPrint = ["trying to conenct"];
  SocketIOManager manager;
  SocketIO socket;
  bool isProbablyConnected = false;
  bool isHeating =false ; 
  bool isFeeding =false ;
  bool isLightOn =false ;
  bool isPumpOn =false ;
  @override
  initState() {
    super.initState();
    manager = SocketIOManager();
    //this.connectsocket();
    // this.initialize();
    this.initSocket();
  }

  initSocket() async {
    setState(() => isProbablyConnected = true);
    socket = await manager.createInstance(
        //Socket IO server URI
        URI,
        //Enable or disable platform channel logging
        enableLogging: false);
    socket.onConnect((data) {
      pprint("connected...");
      pprint(data);
      //sendMessage();
    });
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect(pprint);
    socket.on("news", (data) {
      pprint("news");
      pprint(data);
    });
    socket.on('ahmed', (greeting) {
      pprint('Hello, ${greeting}');
    });
    socket.connect();
    socket.emit('ESP', [
      {'Hello': 'world!'},
    ]);
  }

  disconnect() async {
    await manager.clearInstance(socket);
    setState(() => isProbablyConnected = false);
  }

  startheat() async {
    setState(() => isHeating = true);
    if(socket!=null){
      socket.emit('ESP', [{'heating' : 'heatON'}]);
            pprint("Startheating...");

    }
  }

  stopheat() async {
    setState(() => isHeating = false);
  }
   startpump() async {
    setState(() => isPumpOn = true);
  }

  stopump() async {
    setState(() => isPumpOn = false);
  }
   startfeed() async {
    setState(() => isFeeding = true);
  }

  stopfeed() async {
    setState(() => isFeeding = false);
  }
   startlight() async {
    setState(() => isLightOn = true);
  }

  stoplight() async {
    setState(() => isLightOn = false);
  }

  pprint(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }

      print(data);
      toPrint.add(data);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Monitor',),
              Tab(text: 'Control',)
            ],
          ),
          title: Text(widget.title),
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
                        color: Colors.blueGrey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    ListTile(
                    leading: Icon(Icons.ac_unit),
                    title: Text('Ph-level'),
                  ),
                  
                  ListTile(
                    leading: Icon(Icons.ac_unit),
                    title: Text('Temprature'),
                  ),
                  
                  ListTile(
                    leading: Icon(Icons.lightbulb_outline),
                    title: Text('Light intensity'),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_forward),
                    title: Text('Water flow'),
                  ),
                ],
                ),
                
              ),
              SizedBox(height: 5,),
            ],

                        ),

            ),
            Container(
                color: Colors.blueGrey,
                child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Text("TURN ON LIGHT"),
                        onPressed: isLightOn ? null : startlight,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                        child: Text("TURN OF LIGHT"),
                        onPressed: isLightOn ? stoplight : null,
                      )),
                      
                ],
              ),
              SizedBox(
                height: 5,
              ),
               Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Text("FEED"),
                        onPressed: isFeeding ? null : startfeed,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                        child: Text("STOP FEED"),
                        onPressed: isFeeding ? stopfeed : null,
                      )),
                ],
              ),
              SizedBox(height: 5,),
               Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Text("PUMP ON"),
                        onPressed: isPumpOn ? null : startpump,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                        child: Text("PUMP OFF"),
                        onPressed: isPumpOn ? stopump : null,
                      )),
                      
                ],
              ),SizedBox(height: 5,),
               Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Text("HEAT ON"),
                        onPressed: isHeating ? null : startheat,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                        child: Text("HEAT OFF"),
                        onPressed: isHeating ? stopheat : null,
                      )),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Text("Connect"),
                      onPressed: isProbablyConnected ? null : initSocket,
                    ),
                  ),
                  
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                        child: Text("Disconnect"),
                        onPressed: isProbablyConnected ? disconnect : null,
                      )),
                ],
              ),
              SizedBox(
                height: 5,
              ),
                Expanded(
                  child: Center(
                child: ListView(
                  children: toPrint.map((String _) => Text(_ ?? "")).toList(),
                ),
              )),
               SizedBox(
                height: 5,
              ),
            ],
            
            )

            )
          ],
        )
        
        
    ))
     ;
  }
}
