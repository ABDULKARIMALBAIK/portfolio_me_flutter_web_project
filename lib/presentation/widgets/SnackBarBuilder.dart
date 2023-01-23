import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBarBuilder {

  void buildAwesomeSnackBar(BuildContext context , String label , TextStyle textStyle , AwesomeSnackBarType type){

    switch(type){

      case AwesomeSnackBarType.success :{
        showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: label,
              textStyle: textStyle,
              // backgroundColor: ,
              // icon: ,
              // iconRotationAngle: ,
            )
        );
        break;
      }

      case AwesomeSnackBarType.error :{
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: label,
              textStyle: textStyle,
              // backgroundColor: ,
              // icon: ,
              // iconRotationAngle: ,
            )
        );
        break;
      }

      case AwesomeSnackBarType.info :{
        showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: label,
              textStyle: textStyle,
              // backgroundColor: ,
              // icon: ,
              // iconRotationAngle: ,
            )
        );
        break;
      }

      default: {
        showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: label,
              textStyle: textStyle,
              // backgroundColor: ,
              // icon: ,
              // iconRotationAngle: ,
            )
        );
        break;
      }
    }


  }

}


enum AwesomeSnackBarType {
  error,
  success,
  info
}