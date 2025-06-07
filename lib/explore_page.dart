import 'package:coinlert/widgets/bottom_navbar.dart';
import 'package:coinlert/widgets/watchlist.dart';
import 'package:flutter/material.dart';
import 'market_detail.dart';
import 'coin_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int selectedIndex = 1;

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

  Widget _cryptoTile({
    required String imagePath,
    required String symbol,
    required String name,
    required String price,
    required String change,
    required Color changeColor,
    required Widget chart,
  }) {
    return GestureDetector(
      onTap: () {
        WatchlistManager().addCoin({
          'name': name,
          'change': change,
          'changeColor': change.startsWith('+') ? Colors.greenAccent : Colors.redAccent,
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoinDetailPage(
              imagePath: imagePath,
              symbol: symbol,
              name: name,
              price: price,
              change: change,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black,
              child: Image.asset(
                imagePath,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        change,
                        style: TextStyle(
                          color: changeColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
              width: 44,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chart({required bool isUp}) {
    return CustomPaint(
      painter: _ChartPainter(isUp: isUp),
      size: const Size(double.infinity, double.infinity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111217),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              color: const Color(0xFF111217),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF23242C),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 40,
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.white38),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white38),
                        ),
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      const Text(
                        "Result (1)",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _cryptoTile(
                        imagePath: "lib/assets/coin/BTC.png",
                        symbol: "BTC",
                        name: "Bitcoin",
                        price: "\$105,549",
                        change: "+1.13%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "You might also like",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _cryptoTile(
                        imagePath: "lib/assets/coin/ETH.png",
                        symbol: "ETH",
                        name: "Ethereum",
                        price: "\$2480",
                        change: "-0.92%",
                        changeColor: Colors.redAccent,
                        chart: _chart(isUp: false),
                      ),
                      _cryptoTile(
                        imagePath: "lib/assets/coin/Tether.png",
                        symbol: "USDT",
                        name: "Tether",
                        price: "\$1.00",
                        change: "+0.01%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                      ),
                      _cryptoTile(
                        imagePath: "lib/assets/coin/BNB.png",
                        symbol: "BNB",
                        name: "BNB",
                        price: "\$600",
                        change: "+2.30%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                      ),
                      _cryptoTile(
                        imagePath: "lib/assets/coin/SOL.png",
                        symbol: "SOL",
                        name: "Solana",
                        price: "\$138.10",
                        change: "-5.22%",
                        changeColor: Colors.redAccent,
                        chart: _chart(isUp: false),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MarketPage()),
                            );
                          },
                          child: const Text(
                            "Show all (10)",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final bool isUp;
  _ChartPainter({required this.isUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isUp ? Colors.greenAccent : Colors.redAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isUp) {
      path.moveTo(0, size.height * 0.7);
      path.cubicTo(
        size.width * 0.3, size.height * 0.6,
        size.width * 0.6, size.height * 0.3,
        size.width, size.height * 0.1,
      );
    } else {
      path.moveTo(0, size.height * 0.2);
      path.cubicTo(
        size.width * 0.3, size.height * 0.4,
        size.width * 0.6, size.height * 0.7,
        size.width, size.height * 0.9,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) => oldDelegate.isUp != isUp;
}