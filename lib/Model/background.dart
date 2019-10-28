import 'package:flutter/material.dart';
import 'package:rmu_space/Font/font_style.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      //backgroundColor: Color(0xff0069aa),
      body: Column(
        children: <Widget>[
          new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              WavyHeader(),
              //WavyFooter()
            ],
          ),
        ],
      ),
    );
  }
}
class BackgroundContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: new RotationTransition(
                    turns: new AlwaysStoppedAnimation(-35 / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 55,
                          width:  110,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                  'assets/icons/icon_opacity.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,),
                          ),
                        ),
                        Container(
                          height: 120,
                          width:  140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                  'assets/icons/icon_opacity.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,),
                          ),
                        ),
                      ],
                    )
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: new RotationTransition(
                    turns: new AlwaysStoppedAnimation(-35 / 360),
                    child: Container(
                      height: MediaQuery.of(context).size.height/4,
                      child: Center(
                        child: new Text("",
                          style: TextStyle(
                              fontFamily: FontStyles().FontFamily,
                              color: Colors.grey[100],
                              fontSize: 18.0),
                        ),
                      ),
                    )
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: new RotationTransition(
                    turns: new AlwaysStoppedAnimation(-35 / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 95,
                          width:  140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                  'assets/icons/icon_opacity.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,),
                          ),
                        ),
                        Container(
                          height: 130,
                          width:  130,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                  'assets/icons/icon_opacity.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,),
                          ),
                        ),
                      ],
                    )
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: new RotationTransition(
                    turns: new AlwaysStoppedAnimation(-35 / 360),
                    child: Container(
                      height: MediaQuery.of(context).size.height/4,
                      child: Center(
                        child: new Text("",
                          style: TextStyle(
                              fontFamily: FontStyles().FontFamily,
                              color: Colors.grey[100],
                              fontSize: 18.0),
                        ),
                      ),
                    )
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: new RotationTransition(
                    turns: new AlwaysStoppedAnimation(-35 / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 140,
                          width:  140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                  'assets/icons/icon_opacity.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,),
                          ),
                        ),
                        Container(
                          height: 75,
                          width:  140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                  'assets/icons/icon_opacity.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,),
                          ),
                        ),
                      ],
                    )
                ),
              ),

              Align(
                alignment: Alignment.topRight,
                child: new RotationTransition(
                    turns: new AlwaysStoppedAnimation(-35 / 360),
                    child: Container(
                      height: MediaQuery.of(context).size.height/4,
                      child: Center(
                        child: new Text("",
                          style: TextStyle(
                              fontFamily: FontStyles().FontFamily,
                              color: Colors.grey[100],
                              fontSize: 18.0),
                        ),
                      ),
                    )
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: new RotationTransition(
                    turns: new AlwaysStoppedAnimation(-35 / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 75,
                          width:  140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                  'assets/icons/icon_opacity.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,),
                          ),
                        ),
                        Container(
                          height: 75,
                          width:  140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                  'assets/icons/icon_opacity.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,),
                          ),
                        ),
                      ],
                    )
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: new RotationTransition(
                    turns: new AlwaysStoppedAnimation(-35 / 360),
                    child: Container(
                      height: MediaQuery.of(context).size.height/4,
                      child: Center(
                        child: new Text("",
                          style: TextStyle(
                              fontFamily: FontStyles().FontFamily,
                              color: Colors.grey[100],
                              fontSize: 18.0),
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        )
    );
  }
}

const List<Color> orangeGradients = [
  Color(0xFF1d9cc3),
  Color(0xff2984b9),
  Color(0xff0069aa),
];
const List<Color> orangeGradientsContent = [
  /*Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),*/
  //Color(0xff438acd),
  Color(0xFFffffff),
  Color(0xFFffffff),
  Color(0xFFffffff),
];

const List<Color> aquaGradients = [
  /*Color(0xFF5AEAF1),
  Color(0xFF8EF7DA),*/
  Color(0xff2984b9),
  Color(0xFF1d9cc3),
];

class WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          //clipper: TopWaveClipper(),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new AssetImage(
                    'assets/images/opacity3.png'),
                fit: BoxFit.contain,
                alignment: Alignment.topRight,
                /*colorFilter: new ColorFilter.mode(Color(0xff4098cb).withOpacity(0.2), BlendMode.dstATop),*/),
              gradient: LinearGradient(
                  colors: orangeGradients,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),

            ),
            height: MediaQuery
                .of(context)
                .size
                /*.height/3.4*/
                .height/3
            ,
          ),
        ),
      ],
    );
  }
}
class WavyHeaderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          //clipper: TopWaveClipper(),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new AssetImage(
                    'assets/images/opacity.png'),
                fit: BoxFit.contain,
                alignment: Alignment.topRight,
                /*colorFilter: new ColorFilter.mode(Color(0xff4098cb).withOpacity(0.2), BlendMode.dstATop),*/),
              gradient: LinearGradient(
                  colors: orangeGradientsContent,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),

            ),
            height: MediaQuery
                .of(context)
                .size
                .height/1.5,
          ),
        ),
      ],
    );
  }
}

class WavyFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FooterWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: new AssetImage(
                  'assets/images/opacity.png')
          ),
          gradient: LinearGradient(
              colors: aquaGradients,
              begin: Alignment.center,
              end: Alignment.bottomRight),
          //shape: CircleBorder(side: BorderSide(color: Colors.white, width: 15.0)),
        ),
        height: MediaQuery
            .of(context)
            .size
            .height / 3,
      ),
    );
  }
}

class CirclePink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-70.0, 90.0),
      child: Material(
        color: Colors.pink,
        child: Padding(padding: EdgeInsets.all(120)),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 15.0)),
      ),
    );
  }
}

class CircleYellow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, 210.0),
      child: Material(
        color: Colors.yellow,
        child: Padding(padding: EdgeInsets.all(140)),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 15.0)),
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    /*var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width / 8, size.height - 30);
    var firstEndPoint = new Offset(size.width / 7, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 5, size.height / 4);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint =
    Offset(size.width - (size.width / 9), size.height / 6);
    var thirdEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();*/

    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
    Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 60);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class YellowCircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return null;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

class TrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0,size.width * 2/5);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(TrapeziumClipper oldClipper) => false;
}
