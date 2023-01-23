import 'package:flutter/material.dart';

class HeaderClipper extends CustomClipper<Path>{
  @override
  getClip(Size size) {

    Path path = Path();

    path.lineTo(0, size.height - 100);
    path.lineTo(size.width/4, size.height - 200);
    path.lineTo(size.width/2, size.height);
    path.lineTo(size.width - (size.width/4), size.height - 200);    //(size.width * 3)/4
    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => oldClipper != this;

}


class AboutClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    Path path = Path();

    path.lineTo(size.width/2, 100);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width/2, size.height - 100);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper)  => oldClipper != this;

}


class CertificateClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    Path path = Path();

    path.moveTo(0, 100);
    path.lineTo(size.width/2, 0);
    path.lineTo(size.width, 100);

    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width/2, size.height);
    path.lineTo(0, size.height - 100);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;

}


class ServicesClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    Path path = Path();

    path.lineTo(10, size.height/2);
    path.lineTo(0, size.height);
    path.lineTo(size.width/2, size.height - 50);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 10, size.height/2);
    path.lineTo(size.width, 0);
    path.lineTo(size.width/2, 50);
    // path.lineTo(1,0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;

}


class ProjectsClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    Path path = Path();
    double incrementValue = 40.0;
    double heightValue = 30.0;



    path.lineTo(0, size.height);

    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / incrementValue;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - heightValue : size.height;
      path.lineTo(curXPos, curYPos);
    }

    path.lineTo(size.width, 0);






    // path.moveTo(0, 0);

    var subCurXPos = size.width;
    var subCurYPos = 0.0;
    var decrement = size.width / incrementValue;
    while (subCurXPos > 0.0) {
      subCurXPos -= decrement;
      subCurYPos = subCurYPos == 0.0 ? heightValue : 0.0;
      path.lineTo(subCurXPos, subCurYPos);
    }

    path.lineTo(0, size.height);


    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;

}

class ContactClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    Path path = Path();

    path.lineTo(size.width/4, 50);
    path.lineTo(size.width/2 - 60, 0);
    path.lineTo(size.width/2, 90);
    path.lineTo(size.width/2 + 60, 0);
    path.lineTo(size.width - (size.width/4), 50);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);


    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;


}


//Other Clippers
class CertificateItemClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    //This how much curve i need
    double radius = 30;

    Path path = Path();

    path.moveTo(radius, 0.0);
    path.arcToPoint(Offset(0.0, radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(0.0, size.height - radius);
    path.arcToPoint(Offset(radius, size.height),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height - radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width, radius);
    path.arcToPoint(Offset(size.width - radius, 0.0),
        clockwise: true, radius: Radius.circular(radius));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;

}


class SkillsLastLineClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    Path path = Path();

    path.lineTo(size.width/2, size.height);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;

}