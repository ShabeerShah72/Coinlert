import 'package:coinlert/main.dart'; 
import 'package:coinlert/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:coinlert/widgets/watchlist.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  
  get symbol => null;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with RouteAware {
  int selectedIndex = 4; // My account

  List<Map<String, dynamic>> get recentCoins => WatchlistManager().recentCoins;
  

  void _onNavBarTap(int index) {
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/explore');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/alerts');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/market');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/account');
        break;
    }
  }

  Widget _watchlistItem({
    required String name,
    required String change,
    required Color changeColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.black,
            
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              change,
              style: TextStyle(
                color: changeColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back to this page
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111217),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(54),
        child: AppBar(
          backgroundColor: const Color(0xFF111217),
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'lib/assets/logo/Coinlert.png',
                      width: 120,
                      height: 80,
                      fit: BoxFit.contain,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          centerTitle: false,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 8,
            color: Colors.transparent,
          ),
          Container(
            height: 2,
            color: const Color(0x22FFFFFF),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Container
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23242C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.black,
                            backgroundImage: AssetImage('lib/assets/coin/BTC.png'), // Placeholder image
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Shabeer Shah",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "shabeershah4777@gmail.com",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Thanks for joining Coinlert",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // My Watchlist
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 22),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My Watchlist",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (recentCoins.isEmpty)
                            const Text(
                              "No recently opened coins.",
                              style: TextStyle(color: Colors.white54),
                            )
                          else
                            ...recentCoins.map((coin) => Column(
                              children: [
                                _watchlistItem(
                                  name: coin['name'] ?? '',
                                  change: coin['change'] ?? '',
                                  changeColor: coin['changeColor'] ?? Colors.white,
                                ),
                                const SizedBox(height: 16),
                              ],
                            )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Add creator text at the bottom, before navigation bar and centered
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 4),
            child: Center(
              child: Text(
                'Created by Shabeer Shah',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Bottom Navigation Bar
          BottomNavBar(
            selectedIndex: selectedIndex,
            onTap: _onNavBarTap,
          ),
        ],
      ),
    );
  }
}
