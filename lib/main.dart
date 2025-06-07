import 'package:flutter/material.dart';
import 'package:coinlert/intro_page.dart';
import 'package:coinlert/home_page.dart';
import 'package:coinlert/explore_page.dart';
import 'package:coinlert/Alerts/alert_page.dart';
import 'package:coinlert/market_detail.dart';
import 'package:coinlert/account_page.dart';
import 'package:coinlert/Alerts/price_alert_page.dart';
import 'package:coinlert/Alerts/RSI_alert_page.dart';
import 'package:coinlert/Alerts/EMA_alert_page.dart';


final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coinlert',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroPage(),
        '/home': (context) => const HomePage(),
        '/explore': (context) => const ExplorePage(),
        '/alerts': (context) => const AlertsPage(),
        '/market': (context) => const MarketPage(),
        '/account': (context) => const AccountPage(),
        '/price_alerts': (context) => const PriceAlertsPage(),
        '/rsi_alerts': (context) => const RSIAlertSetupPage(),
        '/ema_alerts': (context) => const EMAAlertSetupPage(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}
