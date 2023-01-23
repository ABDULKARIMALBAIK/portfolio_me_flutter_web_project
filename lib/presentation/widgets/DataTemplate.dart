import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_me/presentation/widgets/AdaptiveImage.dart';
import 'package:portfolio_me/presentation/widgets/AdaptiveText.dart';
import 'package:portfolio_me/utils/localization/app_localizations.dart';
import 'package:url_launcher/link.dart';

class DataTemplate {

  int sizeWidth = 1300;

  //No Data Screen
  Widget noData(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdaptiveImage(
            link: '',///////////////////////////////////////////////
            label: 'This image is used to display a placeholder in this screen',
            hintLabel: '',
            target: LinkTarget.blank,
            altImage: 'No Data Image',
            widget: SvgPicture.network(
              '', ////////////////////////////////////////////
              width: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
              height: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
              fit: BoxFit.fill,
              placeholderBuilder: (context) => Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
                    height: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Flexible(
            child: AdaptiveText(
                text: AppLocalizations.of(context)!.translate('templateData_noData'),
                label: 'This text is a part of No data screen',
                textAlign: TextAlign.center,
                hintLabel: '',
                style: Theme.of(context).textTheme.headline6!.copyWith(),
                maxLines: 2),
          ),
        ],
      ),
    );
  }

  //No Internet Screen
  Widget noInternet(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdaptiveImage(
            link: '',///////////////////////////////////////////////
            label: 'This image is used to display a placeholder in this screen',
            hintLabel: '',
            target: LinkTarget.blank,
            altImage: 'No Internet Image',
            widget: SvgPicture.network(
              '',   ///////////////////////////////////////////////
              width: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
              height: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
              fit: BoxFit.fill,
              placeholderBuilder: (context) => Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
                    height: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Flexible(
            child: AdaptiveText(
                text: AppLocalizations.of(context)!.translate('templateData_noInternet'),
                style: Theme.of(context).textTheme.headline6!.copyWith(),
                hintLabel: '',
                label: 'This text is a part of No Internet screen',
                textAlign: TextAlign.center,
                maxLines: 2),
          ),
        ],
      ),
    );
  }

  //Error Screen
  Widget error(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdaptiveImage(
            label: 'This image is used to display a placeholder in this screen',
            hintLabel: '',
            altImage: 'Error Image',
            target: LinkTarget.blank,
            link: '',///////////////////////////////////////////////
            widget: SvgPicture.network(
              '',  ///////////////////////////////////////////////
              width: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
              height: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
              fit: BoxFit.fill,
              placeholderBuilder: (context) => Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
                    height: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Flexible(
            child: AdaptiveText(
              text: AppLocalizations.of(context)!.translate('templateData_error'),
                hintLabel: '',
                textAlign: TextAlign.center,
                label: 'This text is a part of Error screen',
                style: Theme.of(context).textTheme.headline6!.copyWith(),
                maxLines: 2),
          ),
        ],
      ),
    );
  }

  //Loading Screen
  Widget loading(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(
            height: 18,
          ),
          Flexible(
            child: AdaptiveText(
                text: AppLocalizations.of(context)!.translate('templateData_load'),
                hintLabel: '',
                textAlign: TextAlign.center,
                label: 'This text is a part of Loading screen',
                style: Theme.of(context).textTheme.headline6!.copyWith(),
                maxLines: 2),
          ),
        ],
      ),
    );
  }

  //Not Found Page Screen
  Widget notFoundPage(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          AdaptiveImage(
            label: 'This image is used to display a placeholder in this screen',
            hintLabel: '',
            altImage: 'Not Found Page Image',
            target: LinkTarget.blank,
            link: '',///////////////////////////////////////////////
            widget: SvgPicture.network(
              '',  ///////////////////////////////////////////////
              width: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
              height: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
              fit: BoxFit.fill,
              placeholderBuilder: (context) => Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
                    height: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width > sizeWidth ? 60 : 0),
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Flexible(
            child: AdaptiveText(
              text: AppLocalizations.of(context)!.translate('templateData_not_found_page'),
                textAlign: TextAlign.center,
                hintLabel: '',
                label: 'This text is a part of Not Found Page screen',
                style: Theme.of(context).textTheme.headline6!.copyWith(),
                maxLines: 2),
          ),
        ],
      ),
    );
  }

}