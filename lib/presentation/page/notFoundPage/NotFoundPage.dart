import 'package:flutter/material.dart';
import 'package:portfolio_me/presentation/widgets/DataTemplate.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: DataTemplate().notFoundPage(context),
        ),
      ),
    );
  }

}