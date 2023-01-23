import 'package:flutter/material.dart';
import 'package:portfolio_me/presentation/widgets/AdaptiveText.dart';
import 'package:portfolio_me/utils/PlatformDetector.dart';
import 'package:portfolio_me/utils/localization/app_localizations.dart';

class NavBarLogo extends StatelessWidget{

  bool reflect;


  NavBarLogo(this.reflect);


  @override
  Widget build(BuildContext context) {

    return reflect
      ?
      Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        AdaptiveText(
          text: AppLocalizations.of(context)!.translate('application_name'),
          style: Theme.of(context).textTheme.bodyText1!,
          maxLines: 1,
          textAlign: TextAlign.center,
          hintLabel: '',
          label: 'Title Logo',
        ),
        SizedBox(width: 5,),
        Image.asset(
          PlatformDetector().isWeb() ? '/images/portfolio.png' : 'assets/images/portfolio.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          width: 40,
          height: 40,
        ),

      ],
    )
        :
      Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          PlatformDetector().isWeb() ? '/images/portfolio.png' : 'assets/images/portfolio.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          width: 40,
          height: 40,
        ),
        SizedBox(width: 5,),
        AdaptiveText(
          text: AppLocalizations.of(context)!.translate('application_name'),
          style: Theme.of(context).textTheme.bodyText1!,
          maxLines: 1,
          textAlign: TextAlign.center,
          hintLabel: '',
          label: 'Title Logo',
        )
      ],
    );

  }


}