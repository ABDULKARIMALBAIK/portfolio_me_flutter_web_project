import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_me/application/viewModel/HomeViewModel.dart';
import 'package:portfolio_me/presentation/page/home/HomePage.dart';
import 'package:portfolio_me/presentation/page/notFoundPage/NotFoundPage.dart';

class RouteGenerator {

  GoRouter _router = GoRouter(
    observers: [NavigatorObserver()],
    errorBuilder: (context , state) => NotFoundPage(),
    routes: [
      GoRoute(
          path: '/',
          builder: (context ,state) => HomePage(HomeViewModel()))
    ],
  );

  GoRouter getRouters(){
    return _router;
  }

}
