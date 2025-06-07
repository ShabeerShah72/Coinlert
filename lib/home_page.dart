import 'package:coinlert/widgets/watchlist.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom_navbar.dart';
import 'Coin_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

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

  Widget _priceCard({
    required String title,
    required String price,
    required String change,
    required Color changeColor,
    required IconData icon,
  }) {
    return Container(
      width: 180,
      height: 140,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF23242C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
              Icon(
                icon,
                color: Colors.white38,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            change,
            style: TextStyle(
              color: changeColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'lib/assets/logo/Coinlert.png',
                        width: 120,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF23242C),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Crypto",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _priceCard(
                              title: "BTC Current Price",
                              price: "\$105,549",
                              change: "+1.14%",
                              changeColor: Colors.greenAccent,
                              icon: Icons.currency_bitcoin,
                            ),
                            _priceCard(
                              title: "ETH Current Price",
                              price: "\$2480",
                              change: "-0.92%",
                              changeColor: Colors.redAccent,
                              icon: Icons.currency_exchange,
                            ),
                            _priceCard(
                              title: "BNB Current Price",
                              price: "\$600",
                              change: "=2.30%",
                              changeColor: Colors.greenAccent,
                              icon: Icons.currency_exchange,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "Crypto",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      _cryptoTile(
                        imagePath: "lib/assets/coin/BTC.png",
                        symbol: "BTC",
                        name: "Bitcoin",
                        price: "\$105,549",
                        change: "+1.14%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                      ),
                      _cryptoTile(
                        imagePath: "lib/assets/coin/ETH.png",
                        symbol: "ETH",
                        name: "Ethereum",
                        price: "\$2480",
                        change: "-0.92%",
                        changeColor: Colors.redAccent,
                        chart: _chart(isUp: false),
                      ),
                      const SizedBox(height: 18),
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
                        imagePath: "lib/assets/coin/XRP.png",
                        symbol: "XRP",
                        name: "XRP",
                        price: "\$88.30",
                        change: "+4.12%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                      ),
                      _cryptoTile(
                        imagePath: "lib/assets/coin/BNB.png",
                        symbol: "BNB",
                        name: "BNB",
                        price: "\$57.60",
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
                      const SizedBox(height: 20),
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