import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_me/presentation/notifier/LanguageProvider.dart';
import 'package:portfolio_me/presentation/notifier/ThemeProvider.dart';
import 'package:portfolio_me/utils/PlatformDetector.dart';
import 'package:portfolio_me/utils/localization/app_localizations_setup.dart';
import 'package:portfolio_me/utils/router/RouterGenerator.dart';
import 'package:provider/provider.dart';

void main() async{

  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(StartUp());
}

class StartUp extends StatelessWidget {

  late ThemeProvider _themeProvider;
  late LanguageProvider _languageProvider;


  StartUp(){
    _themeProvider = ThemeProvider();
    _languageProvider = LanguageProvider();
  }

  @override
  Widget build(BuildContext context) {

    //////////////////////// * Android / Web * ////////////////////////
    if(PlatformDetector().isAndroid() || PlatformDetector().isWeb()){
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => _themeProvider,),
          ChangeNotifierProvider(create: (context) => _languageProvider,)
        ],
        child: MaterialApp.router(
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: true,
          title: 'PortfolioME',
          theme: _themeProvider.getTheme,
          routeInformationParser: RouteGenerator().getRouters().routeInformationParser,
          routerDelegate: RouteGenerator().getRouters().routerDelegate,
          supportedLocales: AppLocalizationsSetup.supportedLocales,
          localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
          localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
          locale: _languageProvider.getLanguage,
        ),
      );
    }
    //////////////////////// * Ios * ////////////////////////
    else {
      return MultiProvider(
        providers: [],
        child: CupertinoApp.router(
          debugShowCheckedModeBanner: true,
          title: 'PortfolioME',
          // theme: _themeProvider.getTheme,
          routeInformationParser: RouteGenerator().getRouters().routeInformationParser,
          routerDelegate: RouteGenerator().getRouters().routerDelegate,
          supportedLocales: AppLocalizationsSetup.supportedLocales,
          localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
          localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
          locale: _languageProvider.getLanguage,
        ),
      );
    }
  }
}