import 'package:flutter/material.dart';
import 'package:lamp/lamp.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isOn = false;

  Future _turnFlash(bool flag) async {
    if (flag == _isOn) return;
    !flag ? Lamp.turnOff() : Lamp.turnOn();
    setState(() {
      _isOn = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF212129),
        alignment: Alignment.topCenter,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Opacity(
              opacity: _isOn ? 1.0 : 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  // color: C,
                  borderRadius: BorderRadius.circular(500.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xAAE0DFD8),
                      blurRadius: 100.0,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TorchLight(isOn: _isOn),

                //Light Segment
                Container(
                  width: 230,
                  height: 7.0,
                  decoration: BoxDecoration(
                      color: _isOn ? Color(0xFFF3FDFD) : Colors.grey[500],
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0), right: Radius.circular(20.0))),
                ),

                //Torch
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Image.asset(
                      'assets/torch2.png',
                      fit: BoxFit.fitHeight,
                      width: MediaQuery.of(context).size.width,
                      height: 400.0,
                    ),
                    Positioned(
                      top: 185.0,
                      left: MediaQuery.of(context).size.width / 2 - 45,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          SwitchLayer(),
                          SwitchButton(
                            callback: _turnFlash,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TorchLight extends StatelessWidget {
  const TorchLight({
    Key key,
    @required bool isOn,
  })  : _isOn = isOn,
        super(key: key);

  final bool _isOn;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isOn ? 1.0 : 0.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          ClipPath(
            clipper: LightClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFFE0DFD8),
              ),
            ),
          ),
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(color: Colors.white, spreadRadius: 10.0, blurRadius: 10.0),
              ],
            ),
          ),
          Container(
              width: 200.0,
              height: 200.0,
              child: FlareActor(
                'assets/moving_particles4.flr',
                fit: BoxFit.cover,
                color: Color(0xFFFAFAA8),
                animation: 'move',
              )),
        ],
      ),
    );
  }
}

class SwitchButton extends StatefulWidget {
  final Function(bool) callback;
  SwitchButton({this.callback});

  @override
  SwitchButtonState createState() {
    return SwitchButtonState();
  }
}

class SwitchButtonState extends State<SwitchButton> {
  double offset = 60.0;
  bool _isOn = false;

  _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      offset += details.primaryDelta;
      if (offset > 60.0) {
        offset = 60.0;
      } else if (offset < 0.0) {
        offset = 0.0;
      }
      if (offset < 30.0 && !_isOn) {
        _isOn = true;
        widget.callback(true);
      } else if (offset >= 30.0 && _isOn) {
        _isOn = false;
        widget.callback(false);
      }
    });
  }

  _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      if (offset < 30.0) {
        offset = 0.0;
      } else {
        offset = 60.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Padding(
        padding: EdgeInsets.only(top: offset),
        child: Container(
          height: 90.0,
          width: 86.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.0),
            // color: Colors.deepOrange,
            color: Color(0xFF373747),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !_isOn ? Colors.grey[500] : Color(0xFF00FFB2),
                    boxShadow:
                        !_isOn ? null : [BoxShadow(color: Colors.green[100], blurRadius: 10.0, spreadRadius: 6.0)],
                  ),
                  width: 10.0,
                  height: 10.0,
                ),
              ),
              ButtonLine(),
              SizedBox(height: 3.0),
              ButtonLine(),
              SizedBox(height: 3.0),
              ButtonLine(),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 5.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(10.0),
          right: Radius.circular(10.0),
        ),
        color: Color(0xFF41404B),
      ),
    );
  }
}

class SwitchLayer extends StatelessWidget {
  const SwitchLayer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(60.0),
      elevation: 15.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 80,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0C938B), Color(0xFF00F9D2)],
              ),
              borderRadius: BorderRadius.circular(60.0),
              border: Border.all(color: Color(0xFF1c2126).withOpacity(0.9), width: 6.0),
            ),
          ),
          Container(
            width: 60,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Color(0xFF3F414A),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("OFF", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.cyan)),
                Text("ON", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.cyan)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final step = 230;
    final initial = (size.width - step) / 2 + 5;

    path.lineTo(initial, size.height);
    path.lineTo(initial + step - 10, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}