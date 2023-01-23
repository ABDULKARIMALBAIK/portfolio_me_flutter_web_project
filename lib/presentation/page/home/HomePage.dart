import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:portfolio_me/application/viewModel/HomeViewModel.dart';
import 'package:portfolio_me/presentation/notifier/LanguageProvider.dart';
import 'package:portfolio_me/presentation/notifier/ThemeProvider.dart';
import 'package:portfolio_me/presentation/page/home/component/HomeWidget.dart';
import 'package:portfolio_me/presentation/widgets/AdaptiveText.dart';
import 'package:portfolio_me/presentation/widgets/NavBarLogo.dart';
import 'package:portfolio_me/utils/PlatformDetector.dart';
import 'package:portfolio_me/utils/localization/app_localizations.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget{

  HomeViewModel viewModel;

  HomePage(this.viewModel);

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

  }


  @override
  // TODO: implement widget
  HomePage get widget => super.widget;


  @override
  void dispose() {

    widget.viewModel.confettiController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    //print('app_width: ${MediaQuery.of(context).size.width}');
    //print('app_height: ${MediaQuery.of(context).size.height}');


    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: true);
    LanguageProvider language = Provider.of<LanguageProvider>(context,listen: true);

    widget.viewModel.initAppProviders(theme, language);
    widget.viewModel.listen();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar:
        MediaQuery.of(context).size.width <= 905
            ?
        AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            NavBarLogo(true),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05,)
          ],
        )
            :
        SupportWidget().appBarTabDesktop(context , widget.viewModel.themeProvider , widget.viewModel.themeProvider.getScroll , widget.viewModel.confettiController),

        drawer: MediaQuery.of(context).size.width <= 905
            ?
        SupportWidget().appBarMobile(context ,widget.viewModel.themeProvider , widget.viewModel.themeProvider.getScroll , widget.viewModel.confettiController)
            :
        null,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              //////////////////////// * Page body * ////////////////////////
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child:
                    //This mean Browser is open in Android OS or IOS OS
                PlatformDetector().isWeb() && (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android) ?
                _singleScrollChild()
                    :
                  //This mean Browser is open in Desktop OS (Windows or MacOS or Linux)
                Scrollbar(   //ScrollBar is changed in ThemeAppGenerator class
                  controller: widget.viewModel.themeProvider.getScroll,
                  child: ImprovedScrolling(
                      scrollController: widget.viewModel.themeProvider.getScroll,
                      mmbScrollConfig: MMBScrollConfig(
                        customScrollCursor: DefaultCustomScrollCursor(),
                      ),
                      keyboardScrollConfig: KeyboardScrollConfig(
                        arrowsScrollAmount: 250.0,
                        homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
                          return const Duration(milliseconds: 100);
                        },
                        endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
                          return const Duration(milliseconds: 2000);
                        },
                      ),
                      customMouseWheelScrollConfig: const CustomMouseWheelScrollConfig(
                        scrollAmountMultiplier: 2.0,
                      ),
                      onScroll: (scrollOffset) {
                        //print(Scroll offset: $scrollOffset',),
                      },

                      onMMBScrollStateChanged: (scrolling){
                        //print('Is scrolling: $scrolling',)
                      },
                      onMMBScrollCursorPositionUpdate: (localCursorOffset, scrollActivity){
                        //print('Cursor position: $localCursorOffset\n''Scroll activity: $scrollActivity',)
                      },
                      enableMMBScrolling: true,
                      enableKeyboardScrolling: true,
                      enableCustomMouseWheelScrolling: true,
                      child:  _singleScrollChild()
                  ),
                )
              ),

              //////////////////////// * Confetti * ////////////////////////
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: widget.viewModel.confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [
                    Colors.green,
                    Colors.blue,
                    Colors.red,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                    Colors.yellow,
                    Colors.cyan,
                  ],
                  createParticlePath: (size) => SupportWidget().drawStar(size),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _singleScrollChild() {
    return SingleChildScrollView(
      controller: widget.viewModel.themeProvider.getScroll,
      physics:
          //Web to Android or IOS OS
      PlatformDetector().isWeb() && (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android) ?
      BouncingScrollPhysics()
      :
      //Web to Windows or MacOs or Linux
      NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [

          //////////////////////// * Header * ////////////////////////
          HeaderHome(widget.viewModel),

          SizedBox(height: 40,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Theme.of(context).textTheme.headline5!.color as Color,  ///////////////
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                child: AnimatedTextKit(
                  animatedTexts: [
                    FlickerAnimatedText(AppLocalizations.of(context)!.translate('home_about_title')),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  onTap: () {
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 30,),




          //////////////////////// * About * ////////////////////////
          AboutHome(widget.viewModel),


          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Theme.of(context).textTheme.headline5!.color as Color,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                child: AnimatedTextKit(
                  animatedTexts: [
                    FlickerAnimatedText(AppLocalizations.of(context)!.translate('home_certificate_title')),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  onTap: () {
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 90,),




          //////////////////////// * Certificates * ////////////////////////
          CertificateHome(widget.viewModel),


          SizedBox(height: 80,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Theme.of(context).textTheme.headline5!.color as Color,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                child: AnimatedTextKit(
                  animatedTexts: [
                    FlickerAnimatedText(AppLocalizations.of(context)!.translate('home_services_title')),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  onTap: () {
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 50,),




          //////////////////////// * Services * ////////////////////////
          ServicesHome(widget.viewModel),


          SizedBox(height: 30,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Theme.of(context).textTheme.headline5!.color as Color,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                child: AnimatedTextKit(
                  animatedTexts: [
                    FlickerAnimatedText(AppLocalizations.of(context)!.translate('home_skills_title')),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  onTap: () {
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 60,),




          //////////////////////// * Skills * ////////////////////////
          SkillsHome(widget.viewModel),


          SizedBox(height: 50,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Theme.of(context).textTheme.headline5!.color as Color,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                child: AnimatedTextKit(
                  animatedTexts: [
                    FlickerAnimatedText(AppLocalizations.of(context)!.translate('home_projects_title')),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  onTap: () {
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 100,),




          //////////////////////// * Projects * ////////////////////////
          ProjectsHome(widget.viewModel),



          SizedBox(height: 60,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Theme.of(context).textTheme.headline5!.color as Color,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                child: AnimatedTextKit(
                  animatedTexts: [
                    FlickerAnimatedText(AppLocalizations.of(context)!.translate('home_contacts_title')),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  onTap: () {
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 100,),



          //////////////////////// * Contacts * ////////////////////////
          ContactHome(widget.viewModel),




          //////////////////////// * Right Reserved * ////////////////////////
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: AdaptiveText(
                  text: AppLocalizations.of(context)!.translate('home_rights_title'),
                  style: Theme.of(context).textTheme.bodyText1!,
                  label: 'Right Reserved Label',
                  hintLabel: '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
