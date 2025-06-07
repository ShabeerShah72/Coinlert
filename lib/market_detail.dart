import 'package:coinlert/widgets/watchlist.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom_navbar.dart';
import 'coin_detail_page.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  int selectedIndex = 3; // Market

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

  Widget _marketStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF23242C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cryptoMarketTile({
    required String imagePath,
    required String symbol,
    required String name,
    required String price,
    required String change,
    required Color changeColor,
    required Widget chart,
    required String tag,
    required Color tagBg,
    Color? nameColor,
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
        padding: const EdgeInsets.symmetric(vertical: 9.0),
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
                    style: TextStyle(
                      color: nameColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    change,
                    style: TextStyle(
                      color: changeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
              width: 44,
              child: chart,
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 90, // Fixed width for all tags
              height: 32, // Fixed height for all tags
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagBg.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Top Crypto",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23242C),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _marketStatCard(
                        icon: Icons.stacked_line_chart,
                        value: "\$3,000,846,115,031",
                        label: "Total Market Cap",
                      ),
                      _marketStatCard(
                        icon: Icons.swap_horiz,
                        value: "\$70,688,040,341",
                        label: "24h Volume",
                      ),
                      const SizedBox(height: 18),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/BTC.png",
                        symbol: "BTC",
                        name: "Bitcoin",
                        price: "\$110,340",
                        change: "+5.39%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                        tag: "\$110,340",
                        tagBg: Colors.green,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/ETH.png",
                        symbol: "ETH",
                        name: "Ethereum",
                        price: "\$2,350",
                        change: "-4.19%",
                        changeColor: Colors.redAccent,
                        chart: _chart(isUp: false),
                        tag: "\$2,350",
                        tagBg: Colors.red,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/Tether.png",
                        symbol: "Tether",
                        name: "Tether",
                        price: "\$1.00",
                        change: "+0.01%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                        tag: "\$1.00",
                        tagBg: Colors.green,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/BNB.png",
                        symbol: "BNB",
                        name: "BNB",
                        price: "\$600",
                        change: "+2.30%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                        tag: "\$600",
                        tagBg: Colors.green,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/SOL.png",
                        symbol: "SOL",
                        name: "Solana",
                        price: "\$138.10",
                        change: "-5.22%",
                        changeColor: Colors.redAccent,
                        chart: _chart(isUp: false),
                        tag: "\$138.10",
                        tagBg: Colors.red,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/XRP.png",
                        symbol: "XRP",
                        name: "XRP",
                        price: "\$0.88",
                        change: "+4.12%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                        tag: "\$0.88",
                        tagBg: Colors.green,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/USD.png",
                        symbol: "USDC",
                        name: "USD Coin",
                        price: "\$1.00",
                        change: "+0.00%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                        tag: "\$1.00",
                        tagBg: Colors.green,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/Cardamo.png",
                        symbol: "ADA",
                        name: "Cardano",
                        price: "\$0.45",
                        change: "-1.10%",
                        changeColor: Colors.redAccent,
                        chart: _chart(isUp: false),
                        tag: "\$0.45",
                        tagBg: Colors.red,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/DOGE.png",
                        symbol: "DOGE",
                        name: "Dogecoin",
                        price: "\$0.16",
                        change: "+3.50%",
                        changeColor: Colors.greenAccent,
                        chart: _chart(isUp: true),
                        tag: "\$0.16",
                        tagBg: Colors.green,
                      ),
                      _cryptoMarketTile(
                        imagePath: "lib/assets/coin/AVAX.png",
                        symbol: "AVAX",
                        name: "Avalanche",
                        price: "\$34.20",
                        change: "-2.80%",
                        changeColor: Colors.redAccent,
                        chart: _chart(isUp: false),
                        tag: "\$34.20",
                        tagBg: Colors.red,
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