import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blobs/blobs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octo_image/octo_image.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/CertificateItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/ContactItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/Projectitem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/ServiceItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/SkillItem.dart';
import 'package:portfolio_me/application/viewModel/HomeViewModel.dart';
import 'package:portfolio_me/presentation/notifier/HoverCardProvider.dart';
import 'package:portfolio_me/presentation/notifier/ThemeProvider.dart';
import 'package:portfolio_me/presentation/page/home/component/HomeClipper.dart';
import 'package:portfolio_me/presentation/state/HomeState.dart';
import 'package:portfolio_me/presentation/widgets/AdaptiveImage.dart';
import 'package:portfolio_me/presentation/widgets/AdaptiveLink.dart';
import 'package:portfolio_me/presentation/widgets/AdaptiveText.dart';
import 'package:portfolio_me/presentation/widgets/CrossAnimationButton.dart';
import 'package:portfolio_me/presentation/widgets/DataTemplate.dart';
import 'package:portfolio_me/presentation/widgets/EntranceFader.dart';
import 'package:portfolio_me/presentation/widgets/NavBarLogo.dart';
import 'package:portfolio_me/presentation/widgets/SnackBarBuilder.dart';
import 'package:portfolio_me/utils/PlatformDetector.dart';
import 'package:portfolio_me/utils/Responsive.dart';
import 'package:portfolio_me/utils/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seo_renderer/renderers/text_renderer/text_renderer.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

// ignore: must_be_immutable
class HeaderHome extends StatelessWidget{

  HomeViewModel viewModel;
  late ValueStream<HomeState> headerStream;

  HeaderHome(this.viewModel) {
    viewModel.loadHeaderData();

    headerStream = viewModel.stateHeaderStream.stream;
  }

  double _configSizeHeight(BuildContext context){

    //Desktop
    if(Responsive().isDesktop(context)){
      if(MediaQuery.of(context).size.width < MediaQuery.of(context).size.height){
        return MediaQuery.of(context).size.height - 450;
      }
      else {
        return MediaQuery.of(context).size.height + 200;
      }
    }


    //Tablet
    else if(Responsive().isTablet(context)){
      //Portrait
      if(MediaQuery.of(context).orientation == Orientation.portrait){
        if(MediaQuery.of(context).size.width < MediaQuery.of(context).size.height){
          return (MediaQuery.of(context).size.height) + 300;
        }
        else{
          return  MediaQuery.of(context).size.height < 500 ? (MediaQuery.of(context).size.height * 3) + 250  :  (MediaQuery.of(context).size.height /2) + 200;
        }
      }
      //Landscape
      else {
        return MediaQuery.of(context).size.height < 500 ? (MediaQuery.of(context).size.height * 3) + 250  : (MediaQuery.of(context).size.height /2) + 200;
      }
    }



    //Mobile
    else{
      //Portrait
      if(MediaQuery.of(context).orientation == Orientation.portrait){
        if(MediaQuery.of(context).size.width < MediaQuery.of(context).size.height){
          return (MediaQuery.of(context).size.height * 1.5);
        }
        else{
          return MediaQuery.of(context).size.height * 2 + 300;
        }
      }
      //Landscape
      else {
        return MediaQuery.of(context).size.height * 2 + 300;
      }
    }


  }

  @override
  Widget build(BuildContext context) {

    //I added two containers because fix ClipPath() error !!!!

    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: _configSizeHeight(context) , // MediaQuery.of(context).size.width >= 909 ? MediaQuery.of(context).size.height + 200 :  (MediaQuery.of(context).size.height * 2),
        child: Stack(
          children: [

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: _configSizeHeight(context) , // MediaQuery.of(context).size.width >= 909 ? MediaQuery.of(context).size.height + 200 :  (MediaQuery.of(context).size.height * 2),
              child: ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: _configSizeHeight(context) , // MediaQuery.of(context).size.width >= 909 ? MediaQuery.of(context).size.height + 200 :  (MediaQuery.of(context).size.height * 2),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height:  _configSizeHeight(context) - 200 ,// MediaQuery.of(context).size.width >= 909 ? MediaQuery.of(context).size.height :  (MediaQuery.of(context).size.height * 2),
              child: Center(
                child: StreamProvider<HomeState>(
                  initialData: HomeState.idle(),
                  create: (context) => headerStream,

                  child: Consumer<HomeState>(
                    builder: (context , snapshot , widget){

                      if(snapshot != null){

                        HomeState state = snapshot;

                        //////////////////////// * Idle * ////////////////////////
                        if(state is Idle){
                          ////print('is idle now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * Loading * ////////////////////////
                        else if(state is Loading){
                          //print('is Loading now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * NoData * ////////////////////////
                        else if(state is NoData){
                          //print('is NoData now');
                          return DataTemplate().noData(context);
                        }
                        //////////////////////// * Error * ////////////////////////
                        else if(state is Error){
                          //print('is Error now');
                          Error error = state;
                          //print('error //print: ${error.message + '   ' + error.code}');
                          return DataTemplate().error(context);
                        }
                        //////////////////////// * Success * ////////////////////////
                        else if(state is Success){
                          Success success = state;
                          List<String> data = success.data as List<String>;

                          if(data.length <= 0){
                            //print('is NoData of list now');
                            return DataTemplate().noData(context);
                          }
                          else {
                            //print('data: ${data.length}');

                            return _headerBody(context , data);
                          }


                        }
                        //////////////////////// * Another Option * ////////////////////////
                        else {
                          //print('Unknown state');
                          return DataTemplate().error(context);
                        }

                      }
                      //////////////////////// * Snapshot is NULL * ////////////////////////
                      else {
                        //print('snapshot is null');
                        return DataTemplate().loading(context);
                      }

                    },
                  ),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerBody(BuildContext context , List<String> data) {

    return Container(
        child: Responsive().isDesktop(context)
            ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //////////////////////// * Texts * ////////////////////////
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    //////////////////////// * Welcome Text * ////////////////////////
                    EntranceFader(
                      delay: Duration(milliseconds: 200),
                      duration: Duration(milliseconds: 250),
                      offset: Offset(0 , -3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AdaptiveText(
                            text: AppLocalizations.of(context)!.translate(data[0]),
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                            label: 'Welcome Text',
                            hintLabel: '',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                          SizedBox(width: 8,),
                          AdaptiveImage(
                            label: 'Hand gif',
                            hintLabel: '',
                            target: LinkTarget.blank,
                            link: '/assets/images/hand.gif',
                            altImage: 'Hand gif',
                            widget: Image.asset(
                              PlatformDetector().isWeb() ? '/images/hand.gif' : 'assets/images/hand.gif',
                              width: 30,
                              height: 30,
                              errorBuilder: (ctx , obj , stack) => Center(child: Icon(Icons.error , color: Colors.red,),),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),



                    //////////////////////// * FirstName Text * ////////////////////////
                    EntranceFader(
                      delay: Duration(milliseconds: 350),
                      duration: Duration(milliseconds: 250),
                      offset: Offset(0 , -3),
                      child: AdaptiveText(
                        text: AppLocalizations.of(context)!.translate(data[1]),
                        style: Theme.of(context).textTheme.headline2!.copyWith(letterSpacing: 4 , fontWeight: FontWeight.w100),
                        label: 'Welcome Text',
                        hintLabel: '',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 10,),



                    //////////////////////// * LastName Text * ////////////////////////
                    EntranceFader(
                      delay: Duration(milliseconds: 450),
                      duration: Duration(milliseconds: 250),
                      offset: Offset(0 , -3),
                      child: AdaptiveText(
                        text: AppLocalizations.of(context)!.translate(data[2]),
                        style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w500 , letterSpacing: 5),
                        label: 'Welcome Text',
                        hintLabel: '',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 20,),



                    //////////////////////// * Services Text * ////////////////////////
                    EntranceFader(
                      delay: Duration(milliseconds: 550),
                      duration: Duration(milliseconds: 250),
                      offset: Offset(0 , -3),
                      child: Row(
                        children: [

                          Semantics(
                            label: 'Arrow right icon',
                            hint: '',
                            child: Icon(
                              Icons.arrow_right,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                              semanticLabel: 'Arrow',
                            ),
                          ),

                          SizedBox(width: 10,),

                          DefaultTextStyle(
                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.w200,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Theme.of(context).textTheme.headline5!.color as Color,
                                    offset: Offset(0, 0),
                                  )
                                ]
                            ),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TyperAnimatedText(AppLocalizations.of(context)!.translate(data[3])),
                                TyperAnimatedText(AppLocalizations.of(context)!.translate(data[4])),
                                TyperAnimatedText(AppLocalizations.of(context)!.translate(data[5])),
                                TyperAnimatedText(AppLocalizations.of(context)!.translate(data[6])),
                              ],
                              onTap: () {
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20,),


                    //////////////////////// * Div Text * ////////////////////////
                    if(MediaQuery.of(context).size.width >= 918)
                      EntranceFader(
                        delay: Duration(milliseconds: 650),
                        duration: Duration(milliseconds: 250),
                        offset: Offset(0 , -3),
                        child: Row(
                          children: [
                            Flexible(
                              child: AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[7]),
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Theme.of(context).dividerColor),
                                label: 'Text Div open',
                                maxLines: 1,
                                hintLabel: '',
                              ),
                            ),
                            SizedBox(width: 5,),

                            Flexible(
                              child: AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[9]),
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Theme.of(context).dividerColor),
                                label: 'Text Div open',
                                maxLines: 1,
                                hintLabel: '',
                              ),
                            ),
                            SizedBox(width: 5,),

                            Flexible(
                              child: AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[8]),
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Theme.of(context).dividerColor),
                                label: 'Text Div open',
                                maxLines: 1,
                                hintLabel: '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 20,),



                    ////////////////////////// * SocialMedia Links * ////////////////////////
                    Row(
                      children: [
                        //Github Link
                        EntranceFader(
                          delay: Duration(milliseconds: 750),
                          duration: Duration(milliseconds: 250),
                          offset: Offset(0 , -5),
                          child: AdaptiveLink(
                            anchorText: 'Github Link',
                            hintLabel: '',
                            label: 'Github profile Link',
                            link: 'https://github.com/ABDULKARIMALBAIK',
                            target: LinkTarget.blank,
                            widget: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  launch('https://github.com/ABDULKARIMALBAIK');
                                },
                                child: OctoImage(
                                  width: 30,
                                  height: 30,
                                  image: AssetImage(PlatformDetector().isWeb() ? '/images/github.png' : 'assets/images/github.png'),
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),

                        //StackOverflow Link
                        EntranceFader(
                          delay: Duration(milliseconds: 800),
                          duration: Duration(milliseconds: 250),
                          offset: Offset(0 , -5),
                          child: AdaptiveLink(
                            anchorText: 'StackOverflow Link',
                            hintLabel: '',
                            label: 'StackOverflow profile Link',
                            link: 'https://stackoverflow.com/users/10669265/abdulkarim-albaik',
                            target: LinkTarget.blank,
                            widget: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  launch('https://stackoverflow.com/users/10669265/abdulkarim-albaik');
                                },
                                child: OctoImage(
                                  width: 30,
                                  height: 30,
                                  image: AssetImage(PlatformDetector().isWeb() ? '/images/stackoverflow.png' : 'assets/images/stackoverflow.png'),
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),


                        //Facebook Link
                        EntranceFader(
                          delay: Duration(milliseconds: 850),
                          duration: Duration(milliseconds: 250),
                          offset: Offset(0 , -5),
                          child: AdaptiveLink(
                            anchorText: 'Facebook Link',
                            hintLabel: '',
                            label: 'Facebook profile Link',
                            link: 'https://www.facebook.com/profile.php?id=100074839893743',
                            target: LinkTarget.blank,
                            widget: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  launch('https://www.facebook.com/profile.php?id=100074839893743');
                                },
                                child: OctoImage(
                                  width: 30,
                                  height: 30,
                                  image: AssetImage(PlatformDetector().isWeb() ? '/images/facebook.png' : 'assets/images/facebook.png'),
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),


                        //Instagram Link
                        EntranceFader(
                          delay: Duration(milliseconds: 900),
                          duration: Duration(milliseconds: 250),
                          offset: Offset(0 , -5),
                          child: AdaptiveLink(
                            anchorText: 'Instagram Link',
                            hintLabel: '',
                            label: 'Instagram profile Link',
                            link: 'https://www.instagram.com/abdulkarim_albaik_dev/',
                            target: LinkTarget.blank,
                            widget: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  launch('https://www.instagram.com/abdulkarim_albaik_dev/');
                                },
                                child: OctoImage(
                                  width: 30,
                                  height: 30,
                                  image: AssetImage(PlatformDetector().isWeb() ? '/images/instagram.png' : 'assets/images/instagram.png'),
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),


                        //Twitter Link
                        EntranceFader(
                          delay: Duration(milliseconds: 950),
                          duration: Duration(milliseconds: 250),
                          offset: Offset(0 , -5),
                          child: AdaptiveLink(
                            anchorText: 'Twitter Link',
                            hintLabel: '',
                            label: 'Twitter profile Link',
                            link: 'https://twitter.com/abdalka10233202',
                            target: LinkTarget.blank,
                            widget: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  launch('https://twitter.com/abdalka10233202');
                                },
                                child: OctoImage(
                                  width: 30,
                                  height: 30,
                                  image: AssetImage(PlatformDetector().isWeb() ? '/images/twitter.png' : 'assets/images/twitter.png'),
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),


                        //LinkedIn Link
                        EntranceFader(
                          delay: Duration(milliseconds: 1000),
                          duration: Duration(milliseconds: 250),
                          offset: Offset(0 , -5),
                          child: AdaptiveLink(
                            anchorText: 'LinkedIn Link',
                            hintLabel: '',
                            label: 'LinkedIn profile Link',
                            link: 'https://www.linkedin.com/in/abd-alkarim-albeik-b734aa22a/',
                            target: LinkTarget.blank,
                            widget: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  launch('https://www.linkedin.com/in/abd-alkarim-albeik-b734aa22a/');
                                },
                                child: OctoImage(
                                  width: 30,
                                  height: 30,
                                  image: AssetImage(PlatformDetector().isWeb() ? '/images/linkedin.png' : 'assets/images/linkedin.png'),
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),



            //////////////////////// * Image * ////////////////////////
            Expanded(
              child: EntranceFader(
                delay: Duration(milliseconds: 300),
                duration: Duration(milliseconds: 300),
                offset: Offset(0 , 0),
                child: Center(
                  child: Container(
                      width: 600,
                      height: 600,
                      child: Stack(
                        children: [

                          //Blob Red
                          Center(
                            child: Blob.animatedRandom(
                              size: 520,
                              edgesCount: 7,
                              minGrowth: 4,
                              duration: Duration(milliseconds: 800),
                              styles: BlobStyles(fillType: BlobFillType.stroke , color: Colors.blue , strokeWidth: 2),
                              loop:  true,
                            ),
                          ),


                          //Blob Yellow
                          Center(
                            child: Blob.animatedRandom(
                              size: 520,
                              edgesCount: 7,
                              minGrowth: 4,
                              duration: Duration(milliseconds: 800),
                              styles: BlobStyles(fillType: BlobFillType.stroke , color: Colors.yellow , strokeWidth: 2),
                              loop:  true,
                            ),
                          ),


                          //Bloc fill gradient
                          Center(
                            child: Blob.animatedRandom(
                              size: 520,
                              edgesCount: 7,
                              minGrowth: 4,
                              duration: Duration(milliseconds: 800),
                              styles: BlobStyles(
                                fillType: BlobFillType.fill ,
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.green,
                                      Colors.greenAccent,
                                      Colors.lightGreen,
                                      Colors.lightGreenAccent
                                    ]
                                ).createShader(Rect.fromLTRB(0, 0, 300, 300)) ,),
                              loop:  true,
                            ),
                          ),


                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(400),
                              child: Container(
                                  width: 300,
                                  height: 300,
                                  color: Theme.of(context).backgroundColor,
                                  child: AdaptiveImage(
                                    label: 'Avatar Image',
                                    hintLabel: '',
                                    target: LinkTarget.blank,
                                    link: '/assets/images/avatar.jpg',
                                    altImage: 'This image is ABDULKARIM photo',
                                    widget: OctoImage(
                                      width: 300,
                                      height: 300,
                                      image: AssetImage(PlatformDetector().isWeb() ? '/images/avatar.jpg' : 'assets/images/avatar.jpg'),
                                      placeholderBuilder: OctoPlaceholder.blurHash('LPGbSIoL%g-p%%s:aKo#O[MxIARk',),
                                      errorBuilder: OctoError.icon(color: Colors.red),
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      fadeInCurve: Curves.easeIn,
                                      fadeOutCurve: Curves.easeOut,
                                      fadeInDuration: Duration(milliseconds: 300),
                                      fadeOutDuration: Duration(milliseconds: 300),
                                      placeholderFadeInDuration: Duration(milliseconds: 300),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ),
          ],
        )
            :
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            //////////////////////// * Welcome Text * ////////////////////////
            SizedBox(height: 25,),
            EntranceFader(
              delay: Duration(milliseconds: 200),
              duration: Duration(milliseconds: 250),
              offset: Offset(0 , -3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdaptiveText(
                    text: AppLocalizations.of(context)!.translate(data[0]),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                    label: 'Welcome Text',
                    hintLabel: '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  SizedBox(width: 8,),
                  AdaptiveImage(
                    label: 'Hand gif',
                    hintLabel: '',
                    target: LinkTarget.blank,
                    link: '/assets/images/hand.gif',
                    altImage: 'Hand gif',
                    widget: Image.asset(
                      PlatformDetector().isWeb() ? '/images/hand.gif' : 'assets/images/hand.gif',
                      width: 30,
                      height: 30,
                      errorBuilder: (ctx , obj , stack) => Center(child: Icon(Icons.error , color: Colors.red,),),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),


            //////////////////////// * Avatar  * ////////////////////////
            EntranceFader(
              delay: Duration(milliseconds: 300),
              duration: Duration(milliseconds: 300),
              offset: Offset(0 , 0),
              child: Center(
                child: Container(
                    width: Responsive().isTablet(context) ? 600 : 400,
                    height: Responsive().isTablet(context) ? 600 : 400,
                    child: Stack(
                      children: [

                        //Blob Red
                        Center(
                          child: Blob.animatedRandom(
                            size: Responsive().isTablet(context) ? 520 : 350,
                            edgesCount: 7,
                            minGrowth: 4,
                            duration: Duration(milliseconds: 800),
                            styles: BlobStyles(fillType: BlobFillType.stroke , color: Colors.blue , strokeWidth: 2),
                            loop:  true,
                          ),
                        ),


                        //Blob Yellow
                        Center(
                          child: Blob.animatedRandom(
                            size: Responsive().isTablet(context) ? 520 : 350,
                            edgesCount: 7,
                            minGrowth: 4,
                            duration: Duration(milliseconds: 800),
                            styles: BlobStyles(fillType: BlobFillType.stroke , color: Colors.yellow , strokeWidth: 2),
                            loop:  true,
                          ),
                        ),


                        //Bloc fill gradient
                        Center(
                          child: Blob.animatedRandom(
                            size: Responsive().isTablet(context) ? 520 : 350,
                            edgesCount: 7,
                            minGrowth: 4,
                            duration: Duration(milliseconds: 800),
                            styles: BlobStyles(
                              fillType: BlobFillType.fill ,
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.green,
                                    Colors.greenAccent,
                                    Colors.lightGreen,
                                    Colors.lightGreenAccent
                                  ]
                              ).createShader(Rect.fromLTRB(0, 0, 300, 300)) ,),
                            loop:  true,
                          ),
                        ),


                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(400),
                            child: Container(
                                width: Responsive().isTablet(context) ? 300 : 200,
                                height: Responsive().isTablet(context) ? 300 : 200,
                                color: Theme.of(context).backgroundColor,
                                child: AdaptiveImage(
                                  label: 'Avatar Image',
                                  hintLabel: '',
                                  target: LinkTarget.blank,
                                  link: '/assets/images/avatar.jpg',
                                  altImage: 'This image is ABDULKARIM photo',
                                  widget: OctoImage(
                                    width: Responsive().isTablet(context) ? 300 : 200,
                                    height: Responsive().isTablet(context) ? 300 : 200,
                                    image: AssetImage(PlatformDetector().isWeb() ? '/images/avatar.jpg' : 'assets/images/avatar.jpg'),
                                    placeholderBuilder: OctoPlaceholder.blurHash('LPGbSIoL%g-p%%s:aKo#O[MxIARk',),
                                    errorBuilder: OctoError.icon(color: Colors.red),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    fadeInCurve: Curves.easeIn,
                                    fadeOutCurve: Curves.easeOut,
                                    fadeInDuration: Duration(milliseconds: 300),
                                    fadeOutDuration: Duration(milliseconds: 300),
                                    placeholderFadeInDuration: Duration(milliseconds: 300),
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
            SizedBox(height: 15,),


            //////////////////////// * FirstName Text * ////////////////////////
            EntranceFader(
              delay: Duration(milliseconds: 350),
              duration: Duration(milliseconds: 250),
              offset: Offset(0 , -3),
              child: AdaptiveText(
                text: AppLocalizations.of(context)!.translate(data[1]),
                style: Theme.of(context).textTheme.headline3!.copyWith(letterSpacing: 4 , fontWeight: FontWeight.w100),
                label: 'Welcome Text',
                hintLabel: '',
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            SizedBox(height: 10,),



            //////////////////////// * LastName Text * ////////////////////////
            EntranceFader(
              delay: Duration(milliseconds: 450),
              duration: Duration(milliseconds: 250),
              offset: Offset(0 , -3),
              child: AdaptiveText(
                text: AppLocalizations.of(context)!.translate(data[2]),
                style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w500 , letterSpacing: 5),
                label: 'Welcome Text',
                hintLabel: '',
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            SizedBox(height: 33,),



            //////////////////////// * Services Text * ////////////////////////
            EntranceFader(
              delay: Duration(milliseconds: 550),
              duration: Duration(milliseconds: 250),
              offset: Offset(0 , -3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Semantics(
                    label: 'Arrow right icon',
                    hint: '',
                    child: Icon(
                      Icons.arrow_right,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                      semanticLabel: 'Arrow',
                    ),
                  ),

                  SizedBox(width: 10,),

                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w200,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Theme.of(context).textTheme.headline5!.color as Color,
                            offset: Offset(0, 0),
                          )
                        ]
                    ),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TyperAnimatedText(AppLocalizations.of(context)!.translate(data[3])),
                        TyperAnimatedText(AppLocalizations.of(context)!.translate(data[4])),
                        TyperAnimatedText(AppLocalizations.of(context)!.translate(data[5])),
                        TyperAnimatedText(AppLocalizations.of(context)!.translate(data[6])),
                      ],
                      onTap: () {
                      },
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 33,),


            //////////////////////// * Div Text * ////////////////////////
            EntranceFader(
              delay: Duration(milliseconds: 650),
              duration: Duration(milliseconds: 250),
              offset: Offset(0 , -3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: AdaptiveText(
                      text: AppLocalizations.of(context)!.translate(data[7]),
                      style: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).dividerColor),
                      label: 'Text Div open',
                      maxLines: 1,
                      hintLabel: '',
                    ),
                  ),
                  SizedBox(width: 5,),

                  Flexible(
                    child: AdaptiveText(
                      text: AppLocalizations.of(context)!.translate(data[9]),
                      style: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).dividerColor),
                      label: 'Text Div open',
                      maxLines: 1,
                      hintLabel: '',
                    ),
                  ),
                  SizedBox(width: 5,),

                  Flexible(
                    child: AdaptiveText(
                      text: AppLocalizations.of(context)!.translate(data[8]),
                      style: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).dividerColor),
                      label: 'Text Div open',
                      maxLines: 1,
                      hintLabel: '',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),



            //////////////////////////// * SocialMedia Links * ////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Github Link
                EntranceFader(
                  delay: Duration(milliseconds: 750),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , -5),
                  child: AdaptiveLink(
                    anchorText: 'Github Link',
                    hintLabel: '',
                    label: 'Github profile Link',
                    link: 'https://github.com/ABDULKARIMALBAIK',
                    target: LinkTarget.blank,
                    widget: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          launch('https://github.com/ABDULKARIMALBAIK');
                        },
                        child: OctoImage(
                          width: 30,
                          height: 30,
                          image: AssetImage(PlatformDetector().isWeb() ? '/images/github.png' : 'assets/images/github.png'),
                          placeholderBuilder: (context) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          errorBuilder: OctoError.icon(color: Colors.red),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          fadeInCurve: Curves.easeIn,
                          fadeOutCurve: Curves.easeOut,
                          fadeInDuration: Duration(milliseconds: 300),
                          fadeOutDuration: Duration(milliseconds: 300),
                          placeholderFadeInDuration: Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),

                //StackOverflow Link
                EntranceFader(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , -5),
                  child: AdaptiveLink(
                    anchorText: 'StackOverflow Link',
                    hintLabel: '',
                    label: 'StackOverflow profile Link',
                    link: 'https://stackoverflow.com/users/10669265/abdulkarim-albaik',
                    target: LinkTarget.blank,
                    widget: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          launch('https://stackoverflow.com/users/10669265/abdulkarim-albaik');
                        },
                        child: OctoImage(
                          width: 30,
                          height: 30,
                          image: AssetImage(PlatformDetector().isWeb() ? '/images/stackoverflow.png' : 'assets/images/stackoverflow.png'),
                          placeholderBuilder: (context) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          errorBuilder: OctoError.icon(color: Colors.red),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          fadeInCurve: Curves.easeIn,
                          fadeOutCurve: Curves.easeOut,
                          fadeInDuration: Duration(milliseconds: 300),
                          fadeOutDuration: Duration(milliseconds: 300),
                          placeholderFadeInDuration: Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),


                //Facebook Link
                EntranceFader(
                  delay: Duration(milliseconds: 850),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , -5),
                  child: AdaptiveLink(
                    anchorText: 'Facebook Link',
                    hintLabel: '',
                    label: 'Facebook profile Link',
                    link: 'https://www.facebook.com/profile.php?id=100074839893743',
                    target: LinkTarget.blank,
                    widget: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          launch('https://www.facebook.com/profile.php?id=100074839893743');
                        },
                        child: OctoImage(
                          width: 30,
                          height: 30,
                          image: AssetImage(PlatformDetector().isWeb() ? '/images/facebook.png' : 'assets/images/facebook.png'),
                          placeholderBuilder: (context) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          errorBuilder: OctoError.icon(color: Colors.red),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          fadeInCurve: Curves.easeIn,
                          fadeOutCurve: Curves.easeOut,
                          fadeInDuration: Duration(milliseconds: 300),
                          fadeOutDuration: Duration(milliseconds: 300),
                          placeholderFadeInDuration: Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),


                //Instagram Link
                EntranceFader(
                  delay: Duration(milliseconds: 900),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , -5),
                  child: AdaptiveLink(
                    anchorText: 'Instagram Link',
                    hintLabel: '',
                    label: 'Instagram profile Link',
                    link: 'https://www.instagram.com/abdulkarim_albaik_dev/',
                    target: LinkTarget.blank,
                    widget: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          launch('https://www.instagram.com/abdulkarim_albaik_dev/');
                        },
                        child: OctoImage(
                          width: 30,
                          height: 30,
                          image: AssetImage(PlatformDetector().isWeb() ? '/images/instagram.png' : 'assets/images/instagram.png'),
                          placeholderBuilder: (context) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          errorBuilder: OctoError.icon(color: Colors.red),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          fadeInCurve: Curves.easeIn,
                          fadeOutCurve: Curves.easeOut,
                          fadeInDuration: Duration(milliseconds: 300),
                          fadeOutDuration: Duration(milliseconds: 300),
                          placeholderFadeInDuration: Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),


                //Twitter Link
                EntranceFader(
                  delay: Duration(milliseconds: 950),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , -5),
                  child: AdaptiveLink(
                    anchorText: 'Twitter Link',
                    hintLabel: '',
                    label: 'Twitter profile Link',
                    link: 'https://twitter.com/abdalka10233202',
                    target: LinkTarget.blank,
                    widget: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          launch('https://twitter.com/abdalka10233202');
                        },
                        child: OctoImage(
                          width: 30,
                          height: 30,
                          image: AssetImage(PlatformDetector().isWeb() ? '/images/twitter.png' : 'assets/images/twitter.png'),
                          placeholderBuilder: (context) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          errorBuilder: OctoError.icon(color: Colors.red),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          fadeInCurve: Curves.easeIn,
                          fadeOutCurve: Curves.easeOut,
                          fadeInDuration: Duration(milliseconds: 300),
                          fadeOutDuration: Duration(milliseconds: 300),
                          placeholderFadeInDuration: Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),


                //LinkedIn Link
                EntranceFader(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , -5),
                  child: AdaptiveLink(
                    anchorText: 'LinkedIn Link',
                    hintLabel: '',
                    label: 'LinkedIn profile Link',
                    link: 'https://www.linkedin.com/in/abd-alkarim-albeik-b734aa22a/',
                    target: LinkTarget.blank,
                    widget: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          launch('https://www.linkedin.com/in/abd-alkarim-albeik-b734aa22a/');
                        },
                        child: OctoImage(
                          width: 30,
                          height: 30,
                          image: AssetImage(PlatformDetector().isWeb() ? '/images/linkedin.png' : 'assets/images/linkedin.png'),
                          placeholderBuilder: (context) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          errorBuilder: OctoError.icon(color: Colors.red),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          fadeInCurve: Curves.easeIn,
                          fadeOutCurve: Curves.easeOut,
                          fadeInDuration: Duration(milliseconds: 300),
                          fadeOutDuration: Duration(milliseconds: 300),
                          placeholderFadeInDuration: Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
              ],
            ),
            SizedBox(height: 10,),

          ],
        )
    );

  }
}



// ignore: must_be_immutable
class AboutHome extends StatelessWidget{

  HomeViewModel viewModel;
  late ValueStream<HomeState> aboutStream;

  AboutHome(this.viewModel) {
    viewModel.loadAboutData();

    aboutStream = viewModel.stateAboutStream.stream;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width >= 764 ?  MediaQuery.of(context).size.height + (MediaQuery.of(context).size.height >= 1000 ? - 300 : 250)  : (MediaQuery.of(context).size.height * 1.5) + (MediaQuery.of(context).size.height >= 650 ? - 300 : 250),
      child: Stack(
        children: [

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width >= 764 ?  MediaQuery.of(context).size.height + (MediaQuery.of(context).size.height >= 1000 ? - 300 : 250) : (MediaQuery.of(context).size.height * 1.5) + (MediaQuery.of(context).size.height >= 650 ? - 300 : 250),
            child: ClipPath(
              clipper: AboutClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width >= 764 ?  MediaQuery.of(context).size.height + (MediaQuery.of(context).size.height >= 1000 ? - 300 : 250) : (MediaQuery.of(context).size.height * 1.5) + (MediaQuery.of(context).size.height >= 650 ? - 300 : 250),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width >= 764 ?  MediaQuery.of(context).size.height + (MediaQuery.of(context).size.height >= 1000 ? - 300 : 50): (MediaQuery.of(context).size.height * 1.3) + (MediaQuery.of(context).size.height >= 650 ? - 300 : 50),
              child: StreamProvider<HomeState>(
                initialData: HomeState.idle(),
                create: (context) => aboutStream,

                child: Consumer<HomeState>(
                  builder: (context , snapshot , widget){

                    if(snapshot != null){

                      HomeState state = snapshot;

                      //////////////////////// * Idle * ////////////////////////
                      if(state is Idle){
                        //print('is idle now');
                        return DataTemplate().loading(context);
                      }
                      //////////////////////// * Loading * ////////////////////////
                      else if(state is Loading){
                        //print('is Loading now');
                        return DataTemplate().loading(context);
                      }
                      //////////////////////// * NoData * ////////////////////////
                      else if(state is NoData){
                        //print('is NoData now');
                        return DataTemplate().noData(context);
                      }
                      //////////////////////// * Error * ////////////////////////
                      else if(state is Error){
                        //print('is Error now');
                        Error error = state;
                        //print('error //print: ${error.message + '   ' + error.code}');
                        return DataTemplate().error(context);
                      }
                      //////////////////////// * Success * ////////////////////////
                      else if(state is Success){
                        Success success = state;
                        List<String> data = success.data as List<String>;

                        if(data.length <= 0){
                          //print('is NoData of list now');
                          return DataTemplate().noData(context);
                        }
                        else {
                          //print('data: ${data.length}');

                          return _aboutBody(context , data);
                        }

                      }
                      //////////////////////// * Another Option * ////////////////////////
                      else {
                        //print('Unknown state');
                        return DataTemplate().error(context);
                      }

                    }
                    //////////////////////// * Snapshot is NULL * ////////////////////////
                    else {
                      //print('snapshot is null');
                      return DataTemplate().loading(context);
                    }

                  },
                ),

              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _aboutBody(BuildContext context, List<String> data) {
    return MediaQuery.of(context).size.width >= 764 ?
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //////////////////////// * Subtitle 1 * ////////////////////////
                EntranceFader(
                  delay: Duration(milliseconds: 200),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , 0),
                  child: AdaptiveText(
                    text: AppLocalizations.of(context)!.translate(data[0]),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                    maxLines: 3,
                    hintLabel: '',
                    label: 'Subtitle 1',
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 4,),



                //////////////////////// * Subtitle 2 * ////////////////////////
                EntranceFader(
                  delay: Duration(milliseconds: 200),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , 0),
                  child: AdaptiveText(
                    text: AppLocalizations.of(context)!.translate(data[1]),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                    maxLines: 6,
                    hintLabel: '',
                    label: 'Subtitle 2',
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 4,),



                //////////////////////// * Subtitle 3 * ////////////////////////
                EntranceFader(
                  delay: Duration(milliseconds: 200),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , 0),
                  child: AdaptiveText(
                    text: AppLocalizations.of(context)!.translate(data[2]),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                    maxLines: 4,
                    hintLabel: '',
                    label: 'Subtitle 3',
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 4,),





                //////////////////////// * Subtitle 4 * ////////////////////////
                EntranceFader(
                  delay: Duration(milliseconds: 200),
                  duration: Duration(milliseconds: 250),
                  offset: Offset(0 , 0),
                  child: AdaptiveText(
                    text: AppLocalizations.of(context)!.translate(data[3]),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                    maxLines: 2,
                    hintLabel: '',
                    label: 'Subtitle 1',

                  ),
                ),
                SizedBox(height: 4,),

              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  //////////////////////// * title tech i have worked * ////////////////////////
                  EntranceFader(
                    delay: Duration(milliseconds: 200),
                    duration: Duration(milliseconds: 250),
                    offset: Offset(0 , 0),
                    child: AdaptiveText(
                      text: AppLocalizations.of(context)!.translate(data[4]),
                      style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                      label: 'technologies i have used',
                      hintLabel: '',
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 30,),


                  EntranceFader(
                    delay: Duration(milliseconds: 200),
                    duration: Duration(milliseconds: 250),
                    offset: Offset(0 , 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        //////////////////////// * Java , C# , Flutter * ////////////////////////
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            //////////////////////// * Java  * ////////////////////////
                            Row(
                              children: [
                                Semantics(
                                  label: 'Arrow right icon',
                                  hint: '',
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                    semanticLabel: 'Arrow',
                                  ),
                                ),

                                SizedBox(width: 7,),

                                AdaptiveText(
                                  text: AppLocalizations.of(context)!.translate(data[5]),
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300),
                                  label: 'Java technology',
                                  hintLabel: '',
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            //////////////////////// * C#  * ////////////////////////
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Semantics(
                                  label: 'Arrow right icon',
                                  hint: '',
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                    semanticLabel: 'Arrow',
                                  ),
                                ),

                                SizedBox(width: 7,),

                                AdaptiveText(
                                  text: AppLocalizations.of(context)!.translate(data[6]),
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                                  label: 'C# technology',
                                  hintLabel: '',
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            //////////////////////// * Flutter  * ////////////////////////
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Semantics(
                                  label: 'Arrow right icon',
                                  hint: '',
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                    semanticLabel: 'Arrow',
                                  ),
                                ),

                                SizedBox(width: 7,),

                                AdaptiveText(
                                  text: AppLocalizations.of(context)!.translate(data[7]),
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                                  label: 'Flutter technology',
                                  hintLabel: '',
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                          ],
                        ),


                        SizedBox(width: 60,),


                        //////////////////////// * Dart , Dart , C++ * ////////////////////////
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            //////////////////////// * Dart  * ////////////////////////
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Semantics(
                                  label: 'Arrow right icon',
                                  hint: '',
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                    semanticLabel: 'Arrow',
                                  ),
                                ),

                                SizedBox(width: 7,),

                                AdaptiveText(
                                  text: AppLocalizations.of(context)!.translate(data[8]),
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                                  label: 'Dart technology',
                                  hintLabel: '',
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            //////////////////////// * C++  * ////////////////////////
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Semantics(
                                  label: 'Arrow right icon',
                                  hint: '',
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                    semanticLabel: 'Arrow',
                                  ),
                                ),

                                SizedBox(width: 7,),

                                AdaptiveText(
                                  text: AppLocalizations.of(context)!.translate(data[9]),
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                                  label: 'C++ technology',
                                  hintLabel: '',
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            //////////////////////// * Javascript  * ////////////////////////
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Semantics(
                                  label: 'Arrow right icon',
                                  hint: '',
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                    semanticLabel: 'Arrow',
                                  ),
                                ),

                                SizedBox(width: 7,),

                                AdaptiveText(
                                  text: AppLocalizations.of(context)!.translate(data[10]),
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                                  label: 'Javascript technology',
                                  hintLabel: '',
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                          ],
                        )
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ],
    )
        :
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              //////////////////////// * Subtitle 1 * ////////////////////////
              EntranceFader(
                delay: Duration(milliseconds: 200),
                duration: Duration(milliseconds: 250),
                offset: Offset(0 , 0),
                child: AdaptiveText(
                  text: AppLocalizations.of(context)!.translate(data[0]),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                  maxLines: 3,
                  hintLabel: '',
                  label: 'Subtitle 1',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8,),



              //////////////////////// * Subtitle 2 * ////////////////////////
              EntranceFader(
                delay: Duration(milliseconds: 200),
                duration: Duration(milliseconds: 250),
                offset: Offset(0 , 0),
                child: AdaptiveText(
                  text: AppLocalizations.of(context)!.translate(data[1]),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                  maxLines: 6,
                  hintLabel: '',
                  label: 'Subtitle 2',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8,),



              //////////////////////// * Subtitle 3 * ////////////////////////
              EntranceFader(
                delay: Duration(milliseconds: 200),
                duration: Duration(milliseconds: 250),
                offset: Offset(0 , 0),
                child: AdaptiveText(
                  text: AppLocalizations.of(context)!.translate(data[2]),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                  maxLines: 4,
                  hintLabel: '',
                  label: 'Subtitle 3',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8,),



              //////////////////////// * Subtitle 4 * ////////////////////////
              EntranceFader(
                delay: Duration(milliseconds: 200),
                duration: Duration(milliseconds: 250),
                offset: Offset(0 , 0),
                child: AdaptiveText(
                  text: AppLocalizations.of(context)!.translate(data[3]),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                  maxLines: 2,
                  hintLabel: '',
                  textAlign: TextAlign.center,
                  label: 'Subtitle 1',

                ),
              ),
              SizedBox(height: 40,),



              //////////////////////// * title tech i have worked * ////////////////////////
              EntranceFader(
                delay: Duration(milliseconds: 200),
                duration: Duration(milliseconds: 250),
                offset: Offset(0 , 0),
                child: AdaptiveText(
                  text: AppLocalizations.of(context)!.translate(data[4]),
                  style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                  label: 'technologies i have used',
                  hintLabel: '',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 20,),


              EntranceFader(
                delay: Duration(milliseconds: 200),
                duration: Duration(milliseconds: 250),
                offset: Offset(0 , 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    //////////////////////// * Java , C# , Flutter * ////////////////////////
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //////////////////////// * Java  * ////////////////////////
                        Row(
                          children: [
                            Semantics(
                              label: 'Arrow right icon',
                              hint: '',
                              child: Icon(
                                Icons.arrow_right,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                                semanticLabel: 'Arrow',
                              ),
                            ),

                            SizedBox(width: 7,),

                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[5]),
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300),
                              label: 'Java technology',
                              hintLabel: '',
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        //////////////////////// * C#  * ////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Semantics(
                              label: 'Arrow right icon',
                              hint: '',
                              child: Icon(
                                Icons.arrow_right,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                                semanticLabel: 'Arrow',
                              ),
                            ),

                            SizedBox(width: 7,),

                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[6]),
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                              label: 'C# technology',
                              hintLabel: '',
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        //////////////////////// * Flutter  * ////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Semantics(
                              label: 'Arrow right icon',
                              hint: '',
                              child: Icon(
                                Icons.arrow_right,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                                semanticLabel: 'Arrow',
                              ),
                            ),

                            SizedBox(width: 7,),

                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[7]),
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                              label: 'Flutter technology',
                              hintLabel: '',
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                      ],
                    ),


                    SizedBox(width: 60,),


                    //////////////////////// * Dart , Dart , C++ * ////////////////////////
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //////////////////////// * Dart  * ////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Semantics(
                              label: 'Arrow right icon',
                              hint: '',
                              child: Icon(
                                Icons.arrow_right,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                                semanticLabel: 'Arrow',
                              ),
                            ),

                            SizedBox(width: 7,),

                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[8]),
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                              label: 'Dart technology',
                              hintLabel: '',
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        //////////////////////// * C++  * ////////////////////////
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Semantics(
                              label: 'Arrow right icon',
                              hint: '',
                              child: Icon(
                                Icons.arrow_right,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                                semanticLabel: 'Arrow',
                              ),
                            ),

                            SizedBox(width: 7,),

                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[9]),
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                              label: 'C++ technology',
                              hintLabel: '',
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        //////////////////////// * Javascript  * ////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Semantics(
                              label: 'Arrow right icon',
                              hint: '',
                              child: Icon(
                                Icons.arrow_right,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                                semanticLabel: 'Arrow',
                              ),
                            ),

                            SizedBox(width: 7,),

                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[10]),
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                              label: 'Javascript technology',
                              hintLabel: '',
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
    );
  }
}



// ignore: must_be_immutable
class CertificateHome extends StatelessWidget{

  HomeViewModel viewModel;
  late ValueStream<HomeState> certificateStream;

  late CarouselOptions carouselOptions;

  CertificateHome(this.viewModel) {
    viewModel.loadCertificateData();

    certificateStream = viewModel.stateCertificateStream.stream;

  }


  @override
  Widget build(BuildContext context) {

    carouselOptions = CarouselOptions(
      height: Responsive().isMobile(context) ? 250 : 350,
      aspectRatio: 16/9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 2),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
    );

    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height + 200,
        child: Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height + 200,
              child: ClipPath(
                clipper: CertificateClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height + 200,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: StreamProvider<HomeState>(
                  initialData: HomeState.idle(),
                  create: (context) => certificateStream,

                  child: Consumer<HomeState>(
                    builder: (context , snapshot , widget){

                      if(snapshot != null){

                        HomeState state = snapshot;

                        //////////////////////// * Idle * ////////////////////////
                        if(state is Idle){
                          //print('is idle now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * Loading * ////////////////////////
                        else if(state is Loading){
                          //print('is Loading now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * NoData * ////////////////////////
                        else if(state is NoData){
                          //print('is NoData now');
                          return DataTemplate().noData(context);
                        }
                        //////////////////////// * Error * ////////////////////////
                        else if(state is Error){
                          //print('is Error now');
                          Error error = state;
                          //print('error //print: ${error.message + '   ' + error.code}');
                          return DataTemplate().error(context);
                        }
                        //////////////////////// * Success * ////////////////////////
                        else if(state is Success){
                          Success success = state;
                          List<CertificateItem> data = success.data as List<CertificateItem>;

                          if(data.length <= 0){
                            //print('is NoData of list now');
                            return DataTemplate().noData(context);
                          }
                          else {
                            //print('data: ${data.length}');

                            return _certificateBody(context , data);
                          }


                        }
                        //////////////////////// * Another Option * ////////////////////////
                        else {
                          //print('Unknown state');
                          return DataTemplate().error(context);
                        }

                      }
                      //////////////////////// * Snapshot is NULL * ////////////////////////
                      else {
                        //print('snapshot is null');
                        return DataTemplate().loading(context);
                      }

                    },
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _certificateBody(BuildContext context, List<CertificateItem> data) {

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        //////////////////////// * Subtitle * ////////////////////////
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AdaptiveText(
            text: AppLocalizations.of(context)!.translate('home_certificate_subtitle'),
            style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w200 , letterSpacing: 2),
            maxLines: 2,
            hintLabel: '',
            label: 'Subtitle Certificate',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20,),


        //////////////////////// * Certificates List * ////////////////////////
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 350,
            child: CarouselSlider.builder(
              carouselController: viewModel.carouselController,
              options: carouselOptions,
              itemCount: data.length,
              itemBuilder: (context , index , realIndex){
                return _buildCertificateItem(context , index , realIndex , data[index]);
              },


            ),
          ),
        ),

      ],
    );
  }

  Widget _buildCertificateItem(BuildContext context, int index, int realIndex, CertificateItem certificateItem) {

    ImageProvider network;
    if(PlatformDetector().isWeb())
      network = NetworkImage(certificateItem.urlImage);
    else
      network = CachedNetworkImageProvider(certificateItem.urlImage);

    return AdaptiveLink(
      link: certificateItem.urlImage,
      target: LinkTarget.blank,
      hintLabel: '',
      label: 'Certificate Link',
      anchorText: 'Certificate to display on this website',
      widget: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async{
            // await showDialog(
            //     context: context,
            //     builder: (_) => ImageDialog(certificateItem)
            // );


            html.window.open(
              certificateItem.pdfFile,
              'pdf'
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ClipPath(
              clipper: CertificateItemClipper(),
              child: Container(
                  height: 350,
                  width: 502.10,
                  child: Stack(
                    children: [

                      //Image layer
                      OctoImage(
                        height: 350,
                        width: 502.10,
                        image: network,
                        placeholderBuilder: OctoPlaceholder.blurHash(
                          certificateItem.urlBlurhash,
                        ),
                        errorBuilder: OctoError.icon(color: Colors.red),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        fadeInCurve: Curves.easeIn,
                        fadeOutCurve: Curves.easeOut,
                        fadeInDuration: Duration(milliseconds: 300),
                        fadeOutDuration: Duration(milliseconds: 300),
                        placeholderFadeInDuration: Duration(milliseconds: 300),
                      ),

                      //Shadow layer
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: FractionalOffset.bottomCenter,
                                  end:  FractionalOffset.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.5),
                                    Colors.transparent
                                  ],
                                  // stops: [
                                  //   0.0,
                                  //   0.25
                                  // ]

                                )
                            ),
                          ),
                        ),
                      ),

                      //Text layer
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Text(
                            certificateItem.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                          ),
                        ),
                      )

                    ],
                  )
              ),
            ),
          ),
        ),
      ),
    );

  }

}



// ignore: must_be_immutable
class ServicesHome extends StatelessWidget{


  HomeViewModel viewModel;
  late ValueStream<HomeState> servicesStream;


  ServicesHome(this.viewModel) {
    viewModel.loadServicesData();

    servicesStream = viewModel.stateServicesStream.stream;
  }



  @override
  Widget build(BuildContext context) {

    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height > 1250 ? (MediaQuery.of(context).size.height - 200) : (MediaQuery.of(context).size.height * 2) + 100,
        child: Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height > 1250 ? (MediaQuery.of(context).size.height - 200) :  (MediaQuery.of(context).size.height * 2) + 100,
              child: ClipPath(
                clipper: ServicesClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height > 1250 ? (MediaQuery.of(context).size.height - 200) :  (MediaQuery.of(context).size.height * 2) + 100,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: StreamProvider<HomeState>(
                  initialData: HomeState.idle(),
                  create: (context) => servicesStream,

                  child: Consumer<HomeState>(
                    builder: (context , snapshot , widget){

                      if(snapshot != null){

                        HomeState state = snapshot;

                        //////////////////////// * Idle * ////////////////////////
                        if(state is Idle){
                          //print('is idle now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * Loading * ////////////////////////
                        else if(state is Loading){
                          //print('is Loading now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * NoData * ////////////////////////
                        else if(state is NoData){
                          //print('is NoData now');
                          return DataTemplate().noData(context);
                        }
                        //////////////////////// * Error * ////////////////////////
                        else if(state is Error){
                          //print('is Error now');
                          Error error = state;
                          //print('error //print: ${error.message + '   ' + error.code}');
                          return DataTemplate().error(context);
                        }
                        //////////////////////// * Success * ////////////////////////
                        else if(state is Success){
                          Success success = state;
                          List<ServiceItem> data = success.data as List<ServiceItem>;

                          if(data.length <= 0){
                            //print('is NoData of list now');
                            return DataTemplate().noData(context);
                          }
                          else {
                            //print('data: ${data.length}');

                            return _servicesBody(context , data);
                          }


                        }
                        //////////////////////// * Another Option * ////////////////////////
                        else {
                          //print('Unknown state');
                          return DataTemplate().error(context);
                        }

                      }
                      //////////////////////// * Snapshot is NULL * ////////////////////////
                      else {
                        //print('snapshot is null');
                        return DataTemplate().loading(context);
                      }

                    },
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _servicesBody(BuildContext context, List<ServiceItem> data) {

    return MediaQuery.of(context).size.width >= 800 ?
      Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        //////////////////////// * Subtitle * ////////////////////////
        AdaptiveText(
          text: AppLocalizations.of(context)!.translate('home_services_subtitle'),
          style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w200 , letterSpacing: 2),
          maxLines: 2,
          hintLabel: '',
          label: 'Subtitle Services',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40,),


        //////////////////////// * Mobile & Backend * ////////////////////////
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChangeNotifierProvider<HoverCardProvider>(
              create: (context) => HoverCardProvider(false),
              builder: (context,widget){

                HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

                return GestureDetector(
                  onTapDown: (details) => hover.setHover(true),
                  onTapUp: (details) =>  hover.setHover(false),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) =>  hover.setHover(true),
                    onExit: (event) => hover.setHover(false),
                    child: AnimatedContainer(
                      width: 400,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            if(hover.getHover)
                              BoxShadow(
                                color: Theme.of(context).primaryColor,
                                spreadRadius: 2,
                                offset: Offset(1 , 3),
                                blurRadius: 4,
                              )
                          ]

                      ),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [

                            //////////////////////// * Icon * ////////////////////////
                            SizedBox(height: 10,),
                            AdaptiveImage(
                              link: data[0].imageUrl,
                              hintLabel: '',
                              label: 'Mobile Image',
                              target: LinkTarget.blank,
                              altImage: 'Mobile Image',
                              widget: OctoImage(
                                width: 50,
                                height: 50,
                                image: (PlatformDetector().isWeb() ? NetworkImage(data[0].imageUrl) : CachedNetworkImageProvider(data[0].imageUrl)) as ImageProvider,
                                placeholderBuilder: (context) => Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                ),
                                errorBuilder: OctoError.icon(color: Colors.red),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                fadeInCurve: Curves.easeIn,
                                fadeOutCurve: Curves.easeOut,
                                fadeInDuration: Duration(milliseconds: 300),
                                fadeOutDuration: Duration(milliseconds: 300),
                                placeholderFadeInDuration: Duration(milliseconds: 300),
                              ),
                            ),
                            SizedBox(height: 20,),

                            //////////////////////// * title * ////////////////////////
                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[0].title),
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                              maxLines: 2,
                              hintLabel: '',
                              label: 'title mobile services',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20,),


                            //////////////////////// * subtitle * ////////////////////////
                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[0].description),
                              style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                              maxLines: 6,
                              hintLabel: '',
                              label: 'subtitle mobile services',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5,),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 20,),
            ChangeNotifierProvider<HoverCardProvider>(
              create: (context) => HoverCardProvider(false),
              builder: (context,widget){

                HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

                return GestureDetector(
                  onTapDown: (details) => hover.setHover(true),
                  onTapUp: (details) =>  hover.setHover(false),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) =>  hover.setHover(true),
                    onExit: (event) => hover.setHover(false),
                    child: AnimatedContainer(
                      width: 400,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            if(hover.getHover)
                              BoxShadow(
                                color: Theme.of(context).primaryColor,
                                spreadRadius: 2,
                                offset: Offset(1 , 3),
                                blurRadius: 4,
                              )
                          ]

                      ),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [

                            //////////////////////// * Icon * ////////////////////////
                            SizedBox(height: 10,),
                            AdaptiveImage(
                              link: data[1].imageUrl,
                              hintLabel: '',
                              label: 'Mobile Image',
                              target: LinkTarget.blank,
                              altImage: 'Mobile Image',
                              widget: OctoImage(
                                width: 50,
                                height: 50,
                                image: (PlatformDetector().isWeb() ? NetworkImage(data[1].imageUrl) : CachedNetworkImageProvider(data[1].imageUrl)) as ImageProvider,
                                placeholderBuilder: (context) => Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                ),
                                errorBuilder: OctoError.icon(color: Colors.red),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                fadeInCurve: Curves.easeIn,
                                fadeOutCurve: Curves.easeOut,
                                fadeInDuration: Duration(milliseconds: 300),
                                fadeOutDuration: Duration(milliseconds: 300),
                                placeholderFadeInDuration: Duration(milliseconds: 300),
                              ),
                            ),
                            SizedBox(height: 20,),

                            //////////////////////// * title * ////////////////////////
                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[1].title),
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                              maxLines: 2,
                              hintLabel: '',
                              label: 'title mobile services',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20,),


                            //////////////////////// * subtitle * ////////////////////////
                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[1].description),
                              style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                              maxLines: 6,
                              hintLabel: '',
                              label: 'subtitle mobile services',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5,),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          ],
        ),
        SizedBox(height: 10),

        //////////////////////// * Design & SQL * ////////////////////////
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChangeNotifierProvider<HoverCardProvider>(
              create: (context) => HoverCardProvider(false),
              builder: (context,widget){

                HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

                return GestureDetector(
                  onTapDown: (details) => hover.setHover(true),
                  onTapUp: (details) =>  hover.setHover(false),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) =>  hover.setHover(true),
                    onExit: (event) => hover.setHover(false),
                    child: AnimatedContainer(
                      width: 400,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            if(hover.getHover)
                              BoxShadow(
                                color: Theme.of(context).primaryColor,
                                spreadRadius: 2,
                                offset: Offset(1 , 3),
                                blurRadius: 4,
                              )
                          ]

                      ),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [

                            //////////////////////// * Icon * ////////////////////////
                            SizedBox(height: 10,),
                            AdaptiveImage(
                              link: data[2].imageUrl,
                              hintLabel: '',
                              label: 'Mobile Image',
                              target: LinkTarget.blank,
                              altImage: 'Mobile Image',
                              widget: OctoImage(
                                width: 50,
                                height: 50,
                                image: (PlatformDetector().isWeb() ? NetworkImage(data[2].imageUrl) : CachedNetworkImageProvider(data[2].imageUrl)) as ImageProvider,
                                placeholderBuilder: (context) => Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                ),
                                errorBuilder: OctoError.icon(color: Colors.red),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                fadeInCurve: Curves.easeIn,
                                fadeOutCurve: Curves.easeOut,
                                fadeInDuration: Duration(milliseconds: 300),
                                fadeOutDuration: Duration(milliseconds: 300),
                                placeholderFadeInDuration: Duration(milliseconds: 300),
                              ),
                            ),
                            SizedBox(height: 20,),

                            //////////////////////// * title * ////////////////////////
                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[2].title),
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                              maxLines: 2,
                              hintLabel: '',
                              label: 'title mobile services',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20,),


                            //////////////////////// * subtitle * ////////////////////////
                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[2].description),
                              style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                              maxLines: 6,
                              hintLabel: '',
                              label: 'subtitle mobile services',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5,),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 20,),
            ChangeNotifierProvider<HoverCardProvider>(
              create: (context) => HoverCardProvider(false),
              builder: (context,widget){

                HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

                return GestureDetector(
                  onTapDown: (details) => hover.setHover(true),
                  onTapUp: (details) =>  hover.setHover(false),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) =>  hover.setHover(true),
                    onExit: (event) => hover.setHover(false),
                    child: AnimatedContainer(
                      width: 400,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            if(hover.getHover)
                              BoxShadow(
                                color: Theme.of(context).primaryColor,
                                spreadRadius: 2,
                                offset: Offset(1 , 3),
                                blurRadius: 4,
                              )
                          ]

                      ),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [

                            //////////////////////// * Icon * ////////////////////////
                            SizedBox(height: 10,),
                            AdaptiveImage(
                              link: data[3].imageUrl,
                              hintLabel: '',
                              label: 'Mobile Image',
                              target: LinkTarget.blank,
                              altImage: 'Mobile Image',
                              widget: OctoImage(
                                width: 50,
                                height: 50,
                                image: (PlatformDetector().isWeb() ? NetworkImage(data[3].imageUrl) : CachedNetworkImageProvider(data[3].imageUrl)) as ImageProvider,
                                placeholderBuilder: (context) => Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                ),
                                errorBuilder: OctoError.icon(color: Colors.red),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                fadeInCurve: Curves.easeIn,
                                fadeOutCurve: Curves.easeOut,
                                fadeInDuration: Duration(milliseconds: 300),
                                fadeOutDuration: Duration(milliseconds: 300),
                                placeholderFadeInDuration: Duration(milliseconds: 300),
                              ),
                            ),
                            SizedBox(height: 20,),

                            //////////////////////// * title * ////////////////////////
                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[3].title),
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                              maxLines: 2,
                              hintLabel: '',
                              label: 'title mobile services',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20,),


                            //////////////////////// * subtitle * ////////////////////////
                            AdaptiveText(
                              text: AppLocalizations.of(context)!.translate(data[3].description),
                              style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                              maxLines: 6,
                              hintLabel: '',
                              label: 'subtitle mobile services',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5,),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          ],
        ),
        SizedBox(height: 10),





      ],
    )
        :
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //////////////////////// * Subtitle * ////////////////////////
            AdaptiveText(
              text: AppLocalizations.of(context)!.translate('home_services_subtitle'),
              style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w200 , letterSpacing: 2),
              maxLines: 2,
              hintLabel: '',
              label: 'Subtitle Services',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25,),


            //////////////////////// * Mobile  * ////////////////////////
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ChangeNotifierProvider<HoverCardProvider>(
                create: (context) => HoverCardProvider(false),
                builder: (context,widget){

                  HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

                  return GestureDetector(
                    onTapDown: (details) => hover.setHover(true),
                    onTapUp: (details) =>  hover.setHover(false),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) =>  hover.setHover(true),
                      onExit: (event) => hover.setHover(false),
                      child: AnimatedContainer(
                        width: 400,
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              if(hover.getHover)
                                BoxShadow(
                                  color: Theme.of(context).primaryColor,
                                  spreadRadius: 2,
                                  offset: Offset(1 , 3),
                                  blurRadius: 4,
                                )
                            ]

                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [

                              //////////////////////// * Icon * ////////////////////////
                              SizedBox(height: 10,),
                              AdaptiveImage(
                                link: data[0].imageUrl,
                                hintLabel: '',
                                label: 'Mobile Image',
                                target: LinkTarget.blank,
                                altImage: 'Mobile Image',
                                widget: OctoImage(
                                  width: 50,
                                  height: 50,
                                  image: (PlatformDetector().isWeb() ? NetworkImage(data[0].imageUrl) : CachedNetworkImageProvider(data[0].imageUrl)) as ImageProvider,
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                              SizedBox(height: 20,),

                              //////////////////////// * title * ////////////////////////
                              AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[0].title),
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                                maxLines: 2,
                                hintLabel: '',
                                label: 'title mobile services',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20,),


                              //////////////////////// * subtitle * ////////////////////////
                              AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[0].description),
                                style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                                maxLines: 6,
                                hintLabel: '',
                                label: 'subtitle mobile services',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


            //////////////////////// * Backend * ////////////////////////
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ChangeNotifierProvider<HoverCardProvider>(
                create: (context) => HoverCardProvider(false),
                builder: (context,widget){

                  HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

                  return GestureDetector(
                    onTapDown: (details) => hover.setHover(true),
                    onTapUp: (details) =>  hover.setHover(false),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) =>  hover.setHover(true),
                      onExit: (event) => hover.setHover(false),
                      child: AnimatedContainer(
                        width: 400,
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              if(hover.getHover)
                                BoxShadow(
                                  color: Theme.of(context).primaryColor,
                                  spreadRadius: 2,
                                  offset: Offset(1 , 3),
                                  blurRadius: 4,
                                )
                            ]

                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [

                              //////////////////////// * Icon * ////////////////////////
                              SizedBox(height: 10,),
                              AdaptiveImage(
                                link: data[1].imageUrl,
                                hintLabel: '',
                                label: 'Mobile Image',
                                target: LinkTarget.blank,
                                altImage: 'Mobile Image',
                                widget: OctoImage(
                                  width: 50,
                                  height: 50,
                                  image: (PlatformDetector().isWeb() ? NetworkImage(data[1].imageUrl) : CachedNetworkImageProvider(data[1].imageUrl)) as ImageProvider,
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                              SizedBox(height: 20,),

                              //////////////////////// * title * ////////////////////////
                              AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[1].title),
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                                maxLines: 2,
                                hintLabel: '',
                                label: 'title mobile services',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20,),


                              //////////////////////// * subtitle * ////////////////////////
                              AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[1].description),
                                style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                                maxLines: 6,
                                hintLabel: '',
                                label: 'subtitle mobile services',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


            //////////////////////// * Design * ////////////////////////
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ChangeNotifierProvider<HoverCardProvider>(
                create: (context) => HoverCardProvider(false),
                builder: (context,widget){

                  HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

                  return GestureDetector(
                    onTapDown: (details) => hover.setHover(true),
                    onTapUp: (details) =>  hover.setHover(false),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) =>  hover.setHover(true),
                      onExit: (event) => hover.setHover(false),
                      child: AnimatedContainer(
                        width: 400,
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              if(hover.getHover)
                                BoxShadow(
                                  color: Theme.of(context).primaryColor,
                                  spreadRadius: 2,
                                  offset: Offset(1 , 3),
                                  blurRadius: 4,
                                )
                            ]

                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [

                              //////////////////////// * Icon * ////////////////////////
                              SizedBox(height: 10,),
                              AdaptiveImage(
                                link: data[2].imageUrl,
                                hintLabel: '',
                                label: 'Mobile Image',
                                target: LinkTarget.blank,
                                altImage: 'Mobile Image',
                                widget: OctoImage(
                                  width: 50,
                                  height: 50,
                                  image: (PlatformDetector().isWeb() ? NetworkImage(data[2].imageUrl) : CachedNetworkImageProvider(data[2].imageUrl)) as ImageProvider,
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                              SizedBox(height: 20,),

                              //////////////////////// * title * ////////////////////////
                              AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[2].title),
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                                maxLines: 2,
                                hintLabel: '',
                                label: 'title mobile services',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20,),


                              //////////////////////// * subtitle * ////////////////////////
                              AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[2].description),
                                style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                                maxLines: 6,
                                hintLabel: '',
                                label: 'subtitle mobile services',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            //////////////////////// * SQL * ////////////////////////
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ChangeNotifierProvider<HoverCardProvider>(
                create: (context) => HoverCardProvider(false),
                builder: (context,widget){

                  HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

                  return GestureDetector(
                    onTapDown: (details) => hover.setHover(true),
                    onTapUp: (details) =>  hover.setHover(false),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) =>  hover.setHover(true),
                      onExit: (event) => hover.setHover(false),
                      child: AnimatedContainer(
                        width: 400,
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              if(hover.getHover)
                                BoxShadow(
                                  color: Theme.of(context).primaryColor,
                                  spreadRadius: 2,
                                  offset: Offset(1 , 3),
                                  blurRadius: 4,
                                )
                            ]

                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [

                              //////////////////////// * Icon * ////////////////////////
                              SizedBox(height: 10,),
                              AdaptiveImage(
                                link: data[3].imageUrl,
                                hintLabel: '',
                                label: 'Mobile Image',
                                target: LinkTarget.blank,
                                altImage: 'Mobile Image',
                                widget: OctoImage(
                                  width: 50,
                                  height: 50,
                                  image: (PlatformDetector().isWeb() ? NetworkImage(data[3].imageUrl) : CachedNetworkImageProvider(data[3].imageUrl)) as ImageProvider,
                                  placeholderBuilder: (context) => Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutCurve: Curves.easeOut,
                                  fadeInDuration: Duration(milliseconds: 300),
                                  fadeOutDuration: Duration(milliseconds: 300),
                                  placeholderFadeInDuration: Duration(milliseconds: 300),
                                ),
                              ),
                              SizedBox(height: 20,),

                              //////////////////////// * title * ////////////////////////
                              AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[3].title),
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                                maxLines: 2,
                                hintLabel: '',
                                label: 'title mobile services',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20,),


                              //////////////////////// * subtitle * ////////////////////////
                              AdaptiveText(
                                text: AppLocalizations.of(context)!.translate(data[3].description),
                                style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                                maxLines: 6,
                                hintLabel: '',
                                label: 'subtitle mobile services',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


          ],
        );
  }

}



// ignore: must_be_immutable
class SkillsHome extends StatelessWidget{

  HomeViewModel viewModel;
  late ValueStream<HomeState> skillsStream;


  SkillsHome(this.viewModel) {
    viewModel.loadSkillsData();

    skillsStream = viewModel.stateSkillsStream.stream;
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height >= 1000 ?  MediaQuery.of(context).size.height + (Responsive().isTablet(context) ? 200 : 0 ) :  MediaQuery.of(context).size.height * 2,
      child: StreamProvider<HomeState>(
        initialData: HomeState.idle(),
        create: (context) => skillsStream,

        child: Consumer<HomeState>(
          builder: (context , snapshot , widget){

            if(snapshot != null){

              HomeState state = snapshot;

              //////////////////////// * Idle * ////////////////////////
              if(state is Idle){
                //print('is idle now');
                return DataTemplate().loading(context);
              }
              //////////////////////// * Loading * ////////////////////////
              else if(state is Loading){
                //print('is Loading now');
                return DataTemplate().loading(context);
              }
              //////////////////////// * NoData * ////////////////////////
              else if(state is NoData){
                //print('is NoData now');
                return DataTemplate().noData(context);
              }
              //////////////////////// * Error * ////////////////////////
              else if(state is Error){
                //print('is Error now');
                Error error = state;
                //print('error //print: ${error.message + '   ' + error.code}');
                return DataTemplate().error(context);
              }
              //////////////////////// * Success * ////////////////////////
              else if(state is Success){
                Success success = state;
                List<SkillItem> data = success.data as List<SkillItem>;

                if(data.length <= 0){
                  //print('is NoData of list now');
                  return DataTemplate().noData(context);
                }
                else {
                  //print('data: ${data.length}');

                  return _skillsBody(context , data);
                }


              }
              //////////////////////// * Another Option * ////////////////////////
              else {
                //print('Unknown state');
                return DataTemplate().error(context);
              }

            }
            //////////////////////// * Snapshot is NULL * ////////////////////////
            else {
              //print('snapshot is null');
              return DataTemplate().loading(context);
            }

          },
        ),

      ),
    );
  }

  Widget _skillsBody(BuildContext context, List<SkillItem> data) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [


        //////////////////////// * Frameworks * ////////////////////////
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 30),
          child: AdaptiveText(
            text: AppLocalizations.of(context)!.translate('home_skills_frameworks'),
            style: Theme.of(context).textTheme.headline6!,
            textAlign: TextAlign.center,
            label: 'Frameworks label',
            hintLabel: '',
            maxLines: 1,
          ),
        ),


        //////////////////////// * Frameworks Circles * ////////////////////////
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            //////////////////////// * Flutter circle * ////////////////////////
            _frameworkCircle(context , data[0]),
            SizedBox(width: 30,),


            //////////////////////// * Android circle * ////////////////////////
            _frameworkCircle(context , data[1]),
            SizedBox(width: 30,),


            //////////////////////// * Node.js circle * ////////////////////////
            if(MediaQuery.of(context).size.width > 450)
              _frameworkCircle(context , data[2]),

            SizedBox(width: 10,),

          ],
        ),

        //////////////////////// * Node.js circle (Mobile) * ////////////////////////
        if(MediaQuery.of(context).size.width <=  450)
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 23,),
                  _frameworkCircle(context , data[2]),
                ],
              ),
            ),
          ),


        SizedBox(height: 35,),






        //////////////////////// * Projects & APIs * ////////////////////////
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 30),
          child: AdaptiveText(
            text: AppLocalizations.of(context)!.translate('home_skills_projects_apis'),
            style: Theme.of(context).textTheme.headline6!,
            textAlign: TextAlign.center,
            label: 'Projects & APIs label',
            hintLabel: '',
            maxLines: 1,
          ),
        ),

        //////////////////////// * Projects & APIs Labels * ////////////////////////
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: _projectsAPIsItem(true , context , data[3]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: _projectsAPIsItem(false , context , data[4]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child:  _projectsAPIsItem(true , context , data[5]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child:  _projectsAPIsItem(false , context , data[6]),
              ),


            ],
          ),
        ),
        SizedBox(height: 35,),





        //////////////////////// * Languages * ////////////////////////
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 30),
          child: AdaptiveText(
            text: AppLocalizations.of(context)!.translate('home_skills_languages'),
            style: Theme.of(context).textTheme.headline6!,
            textAlign: TextAlign.center,
            label: 'Languages label',
            hintLabel: '',
            maxLines: 1,
          ),
        ),


        //////////////////////// * Languages Labels * ////////////////////////
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: _languageItem(false , context , data[7]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: _languageItem(false , context , data[8]),
              )

            ],
          ),
        ),
        SizedBox(height: 30,),






        //////////////////////// * Shape last line * ////////////////////////
        //Two Containers ?? this solve ClipPath() ERROR
        Container(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ClipPath(
              clipper: SkillsLastLineClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).backgroundColor,
                    ],
                    begin: Alignment.bottomCenter,
                    end:  Alignment.topCenter,
                  )
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  _frameworkCircle(BuildContext context , SkillItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          child: Stack(
            // fit: StackFit.expand,
            children: [
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: double.parse(item.value),
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: AdaptiveText(
                  text: (double.parse(item.value) * 100).toInt().toString() + "%",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).accentColor , letterSpacing: 2 , fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                  hintLabel: '',
                  label: 'Framework Item Circle',
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),
        AdaptiveText(
          text: item.name,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(letterSpacing: 2 , fontWeight: FontWeight.w200),
          textAlign: TextAlign.center,
          hintLabel: '',
          label: 'Framework Item text',
          maxLines: 1,
        ),
      ],
    );

  }

  _projectsAPIsItem(bool isGreen , BuildContext context, SkillItem item) {

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        AdaptiveText(
          text: item.name,
          style: Theme.of(context).textTheme.headline5!.copyWith(letterSpacing: 2 , fontWeight: FontWeight.w200),
          textAlign: TextAlign.start,
          label: 'Project APIs item label',
          hintLabel: '',
          maxLines: 1,
        ),
        AdaptiveText(
          text: ':',
          style: Theme.of(context).textTheme.headline5!.copyWith(letterSpacing: 2 , fontWeight: FontWeight.w200),
          textAlign: TextAlign.start,
          label: 'Project APIs item label',
          hintLabel: '',
          maxLines: 1,
        ),

        SizedBox(width: 5,),

        AdaptiveText(
          text: item.value,
          style: Theme.of(context).textTheme.headline5!.copyWith(color: isGreen ? Theme.of(context).primaryColor : Theme.of(context).accentColor , letterSpacing: 2 , fontWeight: FontWeight.w200),
          textAlign: TextAlign.center,
          label: 'Frameworks label',
          hintLabel: '',
          maxLines: 1,
        ),
      ],
    );

  }

  _languageItem(bool isGreen, BuildContext context, SkillItem item) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            AdaptiveText(
              text: item.name,
              style: Theme.of(context).textTheme.headline5!.copyWith(letterSpacing: 2 , fontWeight: FontWeight.w200),
              textAlign: TextAlign.start,
              label: 'Language item label',
              hintLabel: '',
              maxLines: 1,
            ),
            AdaptiveText(
              text: ':',
              style: Theme.of(context).textTheme.headline5!.copyWith(letterSpacing: 2 , fontWeight: FontWeight.w200),
              textAlign: TextAlign.start,
              label: 'Language item label',
              hintLabel: '',
              maxLines: 1,
            ),

            SizedBox(width: 5,),
            AdaptiveText(
              text: (double.parse(item.value) * 100).toInt().toString() + "%",
              style: Theme.of(context).textTheme.headline5!.copyWith(color: isGreen ? Theme.of(context).primaryColor : Theme.of(context).accentColor , letterSpacing: 2 , fontWeight: FontWeight.w200),
              textAlign: TextAlign.center,
              label: 'Language item label',
              hintLabel: '',
              maxLines: 1,
            ),
          ],
        ),

        SizedBox(height: 10,),
        SizedBox(
          width: 400,
          height: 5,
          child: LinearProgressIndicator(
            value: double.parse(item.value),
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ],
    );
  }

}



// ignore: must_be_immutable
class ProjectsHome extends StatelessWidget{


  HomeViewModel viewModel;
  late ValueStream<HomeState> projectsStream;


  ProjectsHome(this.viewModel) {
    viewModel.loadProjectsData();

    projectsStream = viewModel.stateProjectsStream.stream;
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height + (MediaQuery.of(context).size.height >= 1000 ? 0 : 200),
        child: Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height + (MediaQuery.of(context).size.height >= 1000 ? 0 : 200),
              child: ClipPath(
                clipper: ProjectsClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height + (MediaQuery.of(context).size.height >= 1000 ? 0 : 200),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: StreamProvider<HomeState>(
                  initialData: HomeState.idle(),
                  create: (context) => projectsStream,

                  child: Consumer<HomeState>(
                    builder: (context , snapshot , widget){

                      if(snapshot != null){

                        HomeState state = snapshot;

                        //////////////////////// * Idle * ////////////////////////
                        if(state is Idle){
                          //print('is idle now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * Loading * ////////////////////////
                        else if(state is Loading){
                          //print('is Loading now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * NoData * ////////////////////////
                        else if(state is NoData){
                          //print('is NoData now');
                          return DataTemplate().noData(context);
                        }
                        //////////////////////// * Error * ////////////////////////
                        else if(state is Error){
                          //print('is Error now');
                          Error error = state;
                          //print('error //print: ${error.message + '   ' + error.code}');
                          return DataTemplate().error(context);
                        }
                        //////////////////////// * Success * ////////////////////////
                        else if(state is Success){
                          Success success = state;
                          List<ProjectItem> data = success.data as List<ProjectItem>;

                          if(data.length <= 0){
                            //print('is NoData of list now');
                            return DataTemplate().noData(context);
                          }
                          else {
                            //print('data: ${data.length}');

                            return _projectBody(context , data);
                          }


                        }
                        //////////////////////// * Another Option * ////////////////////////
                        else {
                          //print('Unknown state');
                          return DataTemplate().error(context);
                        }

                      }
                      //////////////////////// * Snapshot is NULL * ////////////////////////
                      else {
                        //print('snapshot is null');
                        return DataTemplate().loading(context);
                      }

                    },
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _projectBody(BuildContext context, List<ProjectItem> data) {

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        //////////////////////// * Subtitle * ////////////////////////
        EntranceFader(
          offset: Offset(0 , 0),
          delay: Duration(milliseconds: 300),
          duration: Duration(milliseconds: 300),
          child: AdaptiveText(
            text: AppLocalizations.of(context)!.translate('home_projects_subtitle'),
            style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w200 , letterSpacing: 2),
            maxLines: 2,
            hintLabel: '',
            label: 'Subtitle Projects',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20,),



        //////////////////////// * Projects List * ////////////////////////
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context , index) => _projectCard(context , data[index]),
            ),
          ),
        ),
        SizedBox(height: 30,),



        //////////////////////// * Button * ////////////////////////
        SizedBox(height: 10,),
        AdaptiveLink(
          anchorText: 'This button launch a link that is ABDULKARIM Github Link',
          label: 'Github Button',
          target: LinkTarget.blank,
          hintLabel: '',
          link: 'https://github.com/ABDULKARIMALBAIK?tab=repositories',
          widget: CrossAnimationButton(
              50,
              160,
              1.2,
              Curves.easeInOut, 400,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Colors.white,
              AppLocalizations.of(context)!.translate('home_projects_button'),
                  () async { launch('https://github.com/ABDULKARIMALBAIK?tab=repositories'); }),
        ),


        SizedBox(height: 20),
        AdaptiveLink(
          anchorText: 'Foody Website is made by ABDULKARIM ALBAIK',
          label: 'Foody Link',
          target: LinkTarget.blank,
          hintLabel: '',
          link: 'https://foody-e374f.firebaseapp.com/',
          widget: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){
                launch('https://foody-e374f.firebaseapp.com/');
              },
              child: Text(
                'Foody Website',
                style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.w100 ,
                    fontStyle: FontStyle.italic ,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
                semanticsLabel: 'Foody Link',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        )

      ],
    );
  }

  _projectCard(BuildContext context, ProjectItem item) {

    return AdaptiveLink(
      label: 'This project is hosted on Github , you can visited',
      hintLabel: '',
      target: LinkTarget.blank,
      link: item.link,
      anchorText: 'This project is hosted on Github , you can visited',
      widget: GestureDetector(
        onTap: () async{
          if(await canLaunch(item.link)){
            launch(
              item.link,
              enableDomStorage: true,
              enableJavaScript: true);
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 400,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                    colors: [
                      item.startColor,
                      item.endColor
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                ),
              ),
              child: Center(
                child: AdaptiveText(
                  text: item.name,
                  style: Theme.of(context).textTheme.headline5!.copyWith(letterSpacing: 2 , fontWeight: FontWeight.w300),
                  maxLines: 1,
                  hintLabel: '',
                  label: 'Name of Project',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}



// ignore: must_be_immutable
class ContactHome extends StatelessWidget{

  HomeViewModel viewModel;
  late ValueStream<HomeState> contactStream;


  ContactHome(this.viewModel) {
    viewModel.loadContactData();

    contactStream = viewModel.stateContactStream.stream;
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height) + (MediaQuery.of(context).size.height >= 1000 ?  -300 : 200),
        child: Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) + (MediaQuery.of(context).size.height >= 1000 ?  -300 : 200),
              child: ClipPath(
                clipper: ContactClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height) + (MediaQuery.of(context).size.height >= 1000 ? -300 : 200),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: StreamProvider<HomeState>(
                  initialData: HomeState.idle(),
                  create: (context) => contactStream,

                  child: Consumer<HomeState>(
                    builder: (context , snapshot , widget){

                      if(snapshot != null){

                        HomeState state = snapshot;

                        //////////////////////// * Idle * ////////////////////////
                        if(state is Idle){
                          //print('is idle now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * Loading * ////////////////////////
                        else if(state is Loading){
                          //print('is Loading now');
                          return DataTemplate().loading(context);
                        }
                        //////////////////////// * NoData * ////////////////////////
                        else if(state is NoData){
                          //print('is NoData now');
                          return DataTemplate().noData(context);
                        }
                        //////////////////////// * Error * ////////////////////////
                        else if(state is Error){
                          //print('is Error now');
                          Error error = state;
                          //print('error //print: ${error.message + '   ' + error.code}');
                          return DataTemplate().error(context);
                        }
                        //////////////////////// * Success * ////////////////////////
                        else if(state is Success){
                          Success success = state;
                          List<ContactItem> data = success.data as List<ContactItem>;

                          if(data.length <= 0){
                            //print('is NoData of list now');
                            return DataTemplate().noData(context);
                          }
                          else {
                            //print('contact data: ${data.length}');

                            return _contactBody(context , data);
                          }


                        }
                        //////////////////////// * Another Option * ////////////////////////
                        else {
                          //print('Unknown state');
                          return DataTemplate().error(context);
                        }

                      }
                      //////////////////////// * Snapshot is NULL * ////////////////////////
                      else {
                        //print('snapshot is null');
                        return DataTemplate().loading(context);
                      }

                    },
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _contactBody(BuildContext context, List<ContactItem> items) {

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        //////////////////////// * Subtitle * ////////////////////////
        EntranceFader(
          offset: Offset(0 , 0),
          delay: Duration(milliseconds: 300),
          duration: Duration(milliseconds: 300),
          child: AdaptiveText(
            text: AppLocalizations.of(context)!.translate('home_contacts_subtitle'),
            style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w200 , letterSpacing: 2),
            maxLines: 2,
            hintLabel: '',
            label: 'Subtitle Contact',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 25,),



        //////////////////////// * Cards * ////////////////////////
        Responsive().isMobile(context) ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _cardItem(context , items[0]),
                _cardItem(context , items[1]),
                _cardItem(context , items[2]),
              ],
            )
        :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _cardItem(context , items[0]),
            _cardItem(context , items[1]),
            if(MediaQuery.of(context).size.width >= 850)
              _cardItem(context , items[2]),
          ],
        ),

        if(MediaQuery.of(context).size.width < 850 && MediaQuery.of(context).size.width > 500)
          Column(
            children: [
              SizedBox(height: 20),
              _cardItem(context , items[2]),
            ],
          ),

        SizedBox(height: 10),


      ],
    );
  }

  _cardItem(BuildContext context , ContactItem item) {

    return ChangeNotifierProvider<HoverCardProvider>(
      create: (context) => HoverCardProvider(false),
      builder: (context,widget){

        HoverCardProvider hover = Provider.of<HoverCardProvider>(context);

        return GestureDetector(
          onTapDown: (details) => hover.setHover(true),
          onTapUp: (details) =>  hover.setHover(false),
          child: MouseRegion(
            cursor: SystemMouseCursors.basic,
            onEnter: (event) =>  hover.setHover(true),
            onExit: (event) => hover.setHover(false),
            child: AnimatedContainer(
              width: 260,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    if(hover.getHover)
                      BoxShadow(
                        color: Theme.of(context).primaryColor,
                        spreadRadius: 2,
                        offset: Offset(1 , 3),
                        blurRadius: 4,
                      )
                  ]

              ),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    //////////////////////// * Icon * ////////////////////////
                    SizedBox(height: 1,),
                    Icon(
                      item.icon,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 20,),

                    //////////////////////// * title * ////////////////////////
                    AdaptiveText(
                      text: item.title,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w300 , letterSpacing: 2),
                      maxLines: 1,
                      hintLabel: '',
                      label: 'title contact',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20,),


                    //////////////////////// * subtitle * ////////////////////////
                    AdaptiveText(
                      text: item.description,
                      style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w100 , letterSpacing: 2),
                      maxLines: 1,
                      hintLabel: '',
                      label: 'subtitle contact',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5,),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}




//////////////////////// * Secondary Classes * ////////////////////////
// ignore: must_be_immutable
class ImageDialog extends StatelessWidget{

  CertificateItem certificateItem;

  ImageDialog(this.certificateItem);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width >= 502.10 ?  MediaQuery.of(context).size.width : 502.10,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                onError: (obj , stack) => Center(child: Icon(Icons.error , size: 40, color: Colors.red,),),
                image: CachedNetworkImageProvider(certificateItem.urlImage),
                fit: BoxFit.cover
            )
        ),
      ),
    );
  }
}


class SupportWidget{

  final List<String> _sectionsName = [
    "Home",
    "About",
    "Certificates",
    "Services",
    "Skills",
    "Projects",
  ];


  final List<IconData> _sectionsIcons = [
    Icons.home_outlined,
    Icons.person_outline,
    Icons.wallet_membership_outlined,
    Icons.build,
    Icons.star_outline,
    Icons.wallet_travel_outlined,
    Icons.article,
    Icons.phone,
  ];


  void _scroll(int i , ScrollController controller , BuildContext context) {

    switch(i){
      case 0 : {
        controller.animateTo(
          0.0,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        break;
      }
      case 1 : {
        controller.animateTo(
          848.49,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        break;
      }
      case 2 : {
        controller.animateTo(
          1806.3103,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        break;
      }
      case 3 : {
        controller.animateTo(
          2845.6265,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        break;
      }
      case 4 : {
        double d = Responsive().isMobile(context) ? 1000 : 0;
        controller.animateTo(
          4218.5847 + d,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        break;
      }
      case 5 : {
        double d = Responsive().isMobile(context) ? 1000 : 0;
        controller.animateTo(
          5569.8357 + d,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        break;
      }
      default:{
        controller.animateTo(
          0.0,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        break;
      }

    }

  }

  Widget _appBarActions(BuildContext context , String childText, int index, IconData icon , ScrollController controller) {

    return MediaQuery.of(context).size.width <= 905 ?

      EntranceFader(
        offset: Offset(0, -10),
        delay: Duration(milliseconds: 100),
        duration: Duration(milliseconds: 250),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            splashColor: Theme.of(context).primaryColor.withAlpha(70),
            hoverColor: Theme.of(context).primaryColor.withAlpha(70),
            onPressed: () {
              _scroll(index , controller , context);
              // Navigator.pop(context);
            },
            child: ListTile(
              leading: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                  childText,
                  style: Theme.of(context).textTheme.bodyText1
              ),
            ),
          )
    ),
      )
        :
    EntranceFader(
      offset: Offset(0, -10),
      delay: Duration(milliseconds: 100),
      duration: Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 60.0,
        child: MaterialButton(
          hoverColor: Theme.of(context).primaryColor.withOpacity(0.4),
          onPressed: () => _scroll(index , controller , context),
          child: Text(
            childText,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );

    // return MediaQuery.of(context).size.width > 200    //760
    //     ?
    // EntranceFader(
    //   offset: Offset(0, -10),
    //   delay: Duration(milliseconds: 100),
    //   duration: Duration(milliseconds: 250),
    //   child: Container(
    //     padding: const EdgeInsets.all(8.0),
    //     height: 60.0,
    //     child: MaterialButton(
    //       hoverColor: Theme.of(context).primaryColor.withOpacity(0.4),
    //       onPressed: () => _scroll(index , controller),
    //       child: Text(
    //         childText,
    //         style: Theme.of(context).textTheme.bodyText1,
    //       ),
    //     ),
    //   ),
    // )
    //     :
    //
    // Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: MaterialButton(
    //       hoverColor: Theme.of(context).primaryColor.withAlpha(70),
    //       onPressed: () {
    //         _scroll(index , controller);
    //         // Navigator.pop(context);
    //       },
    //       child: ListTile(
    //         leading: Icon(
    //           icon,
    //           color: Theme.of(context).primaryColor,
    //         ),
    //         title: Text(childText,
    //             style: Theme.of(context).textTheme.bodyText1
    //         ),
    //       ),
    //     )
    // );
  }

  AppBar appBarTabDesktop(BuildContext context , ThemeProvider themeProvider , ScrollController controller , ConfettiController confettiController) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: MediaQuery.of(context).size.width < 780
          ?
      EntranceFader(
          duration: Duration(milliseconds: 250),
          offset: Offset(0, -10),
          delay: Duration(seconds: 3),
          child: NavBarLogo(false)
      )
          :
      EntranceFader(
        offset: Offset(0, -10),
        duration: Duration(milliseconds: 250),
        delay: Duration(milliseconds: 100),
        child: NavBarLogo(false),
      ),
      actions: [
        for (int i = 0; i < _sectionsName.length; i++)
          _appBarActions(context , _sectionsName[i], i, _sectionsIcons[i] , controller),
        EntranceFader(
          offset: Offset(0, -10),
          delay: Duration(milliseconds: 100),
          duration: Duration(milliseconds: 250),
          child: Container(
            height: 60.0,
            width: 120.0,
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              splashColor: Theme.of(context).primaryColor.withAlpha(150),
              hoverColor: Theme.of(context).primaryColor.withAlpha(150),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Theme.of(context).primaryColor)),
              onPressed: () {

                //Play Confetti
                confettiController.play();

                //Show SnackBar
                SnackBarBuilder().buildAwesomeSnackBar(
                    context,
                    AppLocalizations.of(context)!.translate('home_snackBar_thankYouResume'),
                    Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                    AwesomeSnackBarType.success);

                //Open link
                html.window.open(
                    'https://drive.google.com/file/d/1YH1KDLRkXBoEY2fd6f3UKtDye825Q9Pb/view?usp=sharing', /////////////////////////////////////////////////////
                    "pdf");
              },
              child: TextRenderer(
                text: Semantics(
                  label: 'Resume Label',
                  child: Text(
                    AppLocalizations.of(context)!.translate('home_appBar_resume'),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w100),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              )
            ),
          ),
        ),
        const SizedBox(width: 15.0),
        // SizedBox(
        //   height: 30.0,
        //   child: Switch.adaptive(
        //     inactiveTrackColor: Colors.grey,
        //     value: !themeProvider.isLightTheme,
        //     onChanged: (value) {
        //       themeProvider.setTheme(!value);
        //     },
        //     activeColor: Theme.of(context).primaryColor,
        //   ),
        // ),
        const SizedBox(width: 3.0),
      ],
    );
  }

  Widget appBarMobile(BuildContext context , ThemeProvider themeProvider , ScrollController controller , ConfettiController confettiController) {
    return Drawer(
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25.0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: NavBarLogo(false),
              ),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.light_mode,
              //     color: Theme.of(context).primaryColor,
              //   ),
              //   title: AdaptiveText(
              //     text: AppLocalizations.of(context)!.translate('home_appBar_switch'),
              //     style: Theme.of(context).textTheme.bodyText1!,
              //     maxLines: 1,
              //     textAlign: TextAlign.start,
              //     hintLabel: '',
              //     label: 'Dark Mode Label',
              //   ),
              //   trailing: Switch.adaptive(
              //     inactiveTrackColor: Colors.grey,
              //     value: !themeProvider.isLightTheme,
              //     onChanged: (value) {
              //       themeProvider.setTheme(!value);
              //     },
              //     activeColor: Theme.of(context).primaryColor,
              //   ),
              // ),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < _sectionsName.length; i++)
                    _appBarActions(context , _sectionsName[i], i, _sectionsIcons[i] , controller),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  splashColor: Theme.of(context).primaryColor.withAlpha(150),
                  hoverColor: Theme.of(context).primaryColor.withAlpha(150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Theme.of(context).primaryColor,)),
                  onPressed: () {


                    //Play Confetti
                    confettiController.play();

                    //Show SnackBar
                    SnackBarBuilder().buildAwesomeSnackBar(
                        context,
                        AppLocalizations.of(context)!.translate('home_snackBar_thankYouResume'),
                        Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                        AwesomeSnackBarType.success);

                    //Open link
                    html.window.open(
                        'https://drive.google.com/file/d/1YH1KDLRkXBoEY2fd6f3UKtDye825Q9Pb/view?usp=sharing',
                        "pdf");
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.book,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: TextRenderer(
                      text: Semantics(
                        label: 'Resume Label',
                        child: Text(
                          AppLocalizations.of(context)!.translate('home_appBar_resume'),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w100),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Path drawStar(Size size) {

    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;

  }

}
