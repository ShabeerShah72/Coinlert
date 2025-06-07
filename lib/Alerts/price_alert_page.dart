import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Add this import at the top
import 'package:intl/intl.dart'; 
import 'package:coinlert/widgets/bottom_navbar.dart';

class PriceAlertsPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onAddAlert;
  final VoidCallback? onTapHome;
  final VoidCallback? onTapExplore;
  final VoidCallback? onTapMarket;
  final VoidCallback? onTapAccount;

  const PriceAlertsPage({
    super.key,
    this.onAddAlert,
    this.onTapHome,
    this.onTapExplore,
    this.onTapMarket,
    this.onTapAccount,
  });

  @override
  State<PriceAlertsPage> createState() => _PriceAlertsPageState();
}

class _PriceAlertsPageState extends State<PriceAlertsPage> {
  int selectedIndex = -2; // My account

  // Add this list to store price notifications
  List<Map<String, dynamic>> priceNotifications = [];

  final List<String> topCoins = [
  "BTC", "ETH", "BNB", "SOL", "XRP", "ADA", "DOGE", "TON", "AVAX", "TRX"
];
String? selectedCoin;

  final TextEditingController _tickerController = TextEditingController();
  final TextEditingController _targetPriceController = TextEditingController();
  int _selectedFreq = 1; // 0=Once, 1=Daily, 2=Weekly

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

  void _onSetAlert() {
    final ticker = _tickerController.text.trim();
    final targetPrice = _targetPriceController.text.trim();
    if (ticker.isEmpty || targetPrice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both ticker and target price.")),
      );
      return;
    }
    // Validate numeric input
    final priceNum = num.tryParse(targetPrice);
    if (priceNum == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Target price must be a number.")),
      );
      return;
    }

    final newAlert = {
      "icon": Icons.attach_money,
      "title": "Price Alert",
      "subtitle": "$ticker reaches \$$targetPrice",
      "price": "\$$targetPrice",
      "status": "Active",
      "isActive": true,
      "statusColor": Colors.green,
    };

    Navigator.pop(context, newAlert); // This will send the alert back to the previous page
  }

  Widget frequencyButton(String label, int idx) {
    final bool selected = idx == _selectedFreq;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFreq = idx),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF23242C) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? Colors.white : Colors.grey[700]!,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget setAlertCard = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18, left: 12, right: 12, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF181A20),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Set New Price Alert",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17.5,
            ),
          ),
          const SizedBox(height: 20),
          const Text("Coin Ticker",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: selectedCoin,
            dropdownColor: const Color(0xFF23242C),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF23242C),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            hint: const Text("Select Coin", style: TextStyle(color: Colors.white38)),
            style: const TextStyle(color: Colors.white, fontSize: 15),
            items: topCoins
                .map((coin) => DropdownMenuItem(
                      value: coin,
                      child: Text(coin, style: const TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCoin = value;
                _tickerController.text = value ?? "";
              });
            },
          ),
          const SizedBox(height: 14),
          const Text("Target Price (\$)",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 5),
          TextField(
            controller: _targetPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}')), // Only numbers and up to 8 decimals
            ],
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "e.g., 185.00",
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFF23242C),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Alert Frequency",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              frequencyButton("Once", 0),
              const SizedBox(width: 8),
              frequencyButton("Daily", 1),
              const SizedBox(width: 8),
              frequencyButton("Weekly", 2),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onSetAlert,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23242C),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                "Set Alert",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget currentAlertCard = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 22),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF181A20),
        borderRadius: BorderRadius.circular(13),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF111217),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: const Color(0xFF111217),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Price Alerts",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF23242C),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Price Alert Notifications",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            if (priceNotifications.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.cleaning_services, color: Colors.white54, size: 22),
                                tooltip: "Clear All",
                                onPressed: () {
                                  setState(() {
                                    priceNotifications.clear();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                          ],
                        ),
                        content: priceNotifications.isEmpty
                            ? const Text(
                                "No Notification Yet",
                                style: TextStyle(color: Colors.white54),
                              )
                            : SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: priceNotifications.length,
                                  itemBuilder: (context, idx) {
                                    final notif = priceNotifications[idx];
                                    return ListTile(
                                      leading: const Icon(Icons.attach_money, color: Colors.amber),
                                      title: Text(
                                        "${notif["ticker"]} hit \$${notif["targetPrice"]}",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        notif["time"] != null
                                            ? DateFormat('yyyy-MM-dd HH:mm:ss').format(notif["time"])
                                            : "",
                                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close", style: TextStyle(color: Colors.white70)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (priceNotifications.isNotEmpty)
                  Positioned(
                    right: 10,
                    top: 12,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(height: 8, color: Colors.transparent),
          Container(height: 1.6, color: const Color(0x22FFFFFF)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  setAlertCard,
                  currentAlertCard,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}