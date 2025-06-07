import 'package:flutter/material.dart';
import 'package:coinlert/Alerts/EMA_alert_page.dart';
import 'package:coinlert/Alerts/alert_page.dart';
import 'home_page.dart';
import 'explore_page.dart';
import 'market_detail.dart';
import 'account_page.dart';

class CoinDetailPage extends StatefulWidget {
  final String imagePath;
  final String symbol;
  final String name;
  final String price;
  final String change;

  const CoinDetailPage({
    super.key,
    required this.imagePath,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  int selectedIndex = -9;

  void _onNavBarTap(int index) {
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExplorePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AlertsPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MarketPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AccountPage()),
        );
        break;
    }
  }

  Widget _navBarIcon(IconData icon, String label, {bool selected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? Colors.blueAccent : Colors.white, size: 28),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.blueAccent : Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodButton(String period, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.greenAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Colors.greenAccent : Colors.greenAccent,
          width: selected ? 0 : 1,
        ),
      ),
      child: Text(
        period,
        style: TextStyle(
          color: selected ? Colors.black : Colors.greenAccent,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _chart() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: _ChartPainter(
          isUp: widget.change.startsWith('+'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine color for price change
    final bool isUp = widget.change.startsWith('+');
    final Color changeColor = isUp ? Colors.greenAccent : Colors.redAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF111217),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111217),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card with main info
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23242C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.black,
                            child: Image.asset(
                              'lib/assets/coin/${widget.symbol}.png',
                              width: 32,
                              height: 32,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.symbol,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.change,
                                style: TextStyle(
                                  color: changeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            widget.price,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Period selection
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _periodButton("1D", true),
                          _periodButton("1W", false),
                          _periodButton("1M", false),
                          _periodButton("3M", false),
                          _periodButton("1Y", false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Chart
                    Container(
                      margin: const EdgeInsets.only(top: 6, bottom: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.white12),
                          top: BorderSide(color: Colors.white12),
                          right: BorderSide(color: Colors.white12),
                          bottom: BorderSide(color: Colors.white12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _chart(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("\$10", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                Text("\$20", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                Text("\$30", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                Text("\$40", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                Text("\$50", style: TextStyle(color: Colors.white54, fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("10:00", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                Text("12:00", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                Text("14:00", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                Text("16:00", style: TextStyle(color: Colors.white54, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 26),
                        width: 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF23242C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EMAAlertSetupPage()));
                          },
                          child: const Text(
                            "Add Alert",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Navigation Bar
          Container(
            height: 74,
            decoration: const BoxDecoration(
              color: Color(0xFF181A20),
              border: Border(top: BorderSide(color: Color(0xFF23242C))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navBarIcon(
                  Icons.home,
                  "Home",
                  selected: selectedIndex == 0,
                  onTap: () => _onNavBarTap(0),
                ),
                _navBarIcon(
                  Icons.search,
                  "Explore",
                  selected: selectedIndex == 1,
                  onTap: () => _onNavBarTap(1),
                ),
                _navBarIcon(
                  Icons.add_alert,
                  "Alert",
                  selected: selectedIndex == 2,
                  onTap: () => _onNavBarTap(2),
                ),
                _navBarIcon(
                  Icons.show_chart,
                  "Market",
                  selected: selectedIndex == 3,
                  onTap: () => _onNavBarTap(3),
                ),
                _navBarIcon(
                  Icons.account_circle,
                  "My account",
                  selected: selectedIndex == 4,
                  onTap: () => _onNavBarTap(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final bool isUp;
  _ChartPainter({this.isUp = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isUp ? Colors.greenAccent : Colors.redAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isUp) {
      path.moveTo(0, size.height * 0.7);
      path.lineTo(size.width * 0.15, size.height * 0.5);
      path.lineTo(size.width * 0.25, size.height * 0.6);
      path.lineTo(size.width * 0.35, size.height * 0.3);
      path.lineTo(size.width * 0.45, size.height * 0.4);
      path.lineTo(size.width * 0.55, size.height * 0.2);
      path.lineTo(size.width * 0.65, size.height * 0.5);
      path.lineTo(size.width * 0.75, size.height * 0.4);
      path.lineTo(size.width * 0.85, size.height * 0.6);
      path.lineTo(size.width, size.height * 0.5);
    } else {
      path.moveTo(0, size.height * 0.3);
      path.lineTo(size.width * 0.15, size.height * 0.5);
      path.lineTo(size.width * 0.25, size.height * 0.4);
      path.lineTo(size.width * 0.35, size.height * 0.7);
      path.lineTo(size.width * 0.45, size.height * 0.6);
      path.lineTo(size.width * 0.55, size.height * 0.8);
      path.lineTo(size.width * 0.65, size.height * 0.5);
      path.lineTo(size.width * 0.75, size.height * 0.6);
      path.lineTo(size.width * 0.85, size.height * 0.4);
      path.lineTo(size.width, size.height * 0.5);
    }

    canvas.drawPath(path, paint);

    final gridPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;
    for (int i = 1; i < 5; i++) {
      double dy = size.height * i / 5;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) => oldDelegate.isUp != isUp;
}