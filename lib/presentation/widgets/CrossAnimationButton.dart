import 'package:flutter/material.dart';
import 'package:portfolio_me/presentation/notifier/HoverCardProvider.dart';
import 'package:provider/provider.dart';

class CrossAnimationButton extends StatelessWidget{

  final double? height;
  final double? width;
  final double? thickness;
  final Curve? curve;
  final int? milliseconds;
  final Color? unTouchEdgesColor;
  final Color? touchEdgesColor;
  final Color? unTouchBackgroundColor;
  final Color? touchBackgroundColor;
  final Color? unTouchTextColor;
  final Color? touchTextColor;
  final String? text;
  final VoidCallback onPress;


  CrossAnimationButton(
      this.height,
      this.width,
      this.thickness,
      this.curve,
      this.milliseconds,
      this.unTouchEdgesColor,
      this.touchEdgesColor,
      this.unTouchBackgroundColor,
      this.touchBackgroundColor,
      this.unTouchTextColor,
      this.touchTextColor,
      this.text,
      this.onPress);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<HoverCardProvider>(
      create: (context) => HoverCardProvider(false),
      builder: (context , widget){

        HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

        return Container(
          height: height,
          width: width,
          child: GestureDetector(
            onTapDown: (e) => hover.setHover(true),
            onTapUp: (e) => hover.setHover(false),
            child: MouseRegion(
              onEnter: (val) {
                hover.setHover(true);
              },
              onExit: (val) {
                hover.setHover(false);
              },
              cursor: SystemMouseCursors.click,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Material(
                    child: InkWell(
                      onTap: (){
                        onPress.call();
                      },
                      child: Ink(
                        width: width,
                        height: height,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: milliseconds! + 150),
                          curve: curve!,
                          height: height,
                          width: width,
                          color: hover.getHover
                              ? touchBackgroundColor
                              : unTouchBackgroundColor,
                          child: Center(
                              child: Text(
                                  text.toString(),
                                  style: hover.getHover ?
                                  Theme.of(context).textTheme.subtitle1!.copyWith(color: touchTextColor) :
                                  Theme.of(context).textTheme.subtitle1!.copyWith(color: unTouchTextColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: AnimatedContainer(
                      height: thickness,
                      width: hover.getHover ? width! : 15,
                      color: hover.getHover ? touchEdgesColor : unTouchEdgesColor,
                      duration: Duration(milliseconds: milliseconds!),
                      curve: curve!,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: AnimatedContainer(
                      height: hover.getHover ? height! : 15,
                      width: thickness,
                      color: hover.getHover ? touchEdgesColor : unTouchEdgesColor,
                      duration: Duration(milliseconds: milliseconds!),
                      curve: curve!,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: AnimatedContainer(
                      height: thickness,
                      width: hover.getHover ? width! : 15,
                      color: hover.getHover ? touchEdgesColor : unTouchEdgesColor,
                      duration: Duration(milliseconds: milliseconds!),
                      curve: curve!,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: AnimatedContainer(
                      height: hover.getHover ? height! : 15,
                      width: thickness,
                      color: hover.getHover ? touchEdgesColor : unTouchEdgesColor,
                      duration: Duration(milliseconds: milliseconds!),
                      curve: curve!,
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

}