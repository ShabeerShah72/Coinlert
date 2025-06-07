import 'package:flutter/material.dart';
import 'package:coinlert/widgets/bottom_navbar.dart';
import 'package:intl/intl.dart'; // For formatting time (optional)

class RSIAlertSetupPage extends StatefulWidget {
  final VoidCallback? onTapHome;
  final VoidCallback? onTapExplore;
  final VoidCallback? onTapMarket;
  final VoidCallback? onTapAlert;
  final VoidCallback? onTapAccount;

  const RSIAlertSetupPage({
    super.key,
    this.onTapHome,
    this.onTapExplore,
    this.onTapMarket,
    this.onTapAlert,
    this.onTapAccount,
  });

  @override
  State<RSIAlertSetupPage> createState() => _RSIAlertSetupPageState();
}

class _RSIAlertSetupPageState extends State<RSIAlertSetupPage> {
  int selectedIndex = -3; // My account

  // List to store only RSI alert notifications
  List<Map<String, dynamic>> rsiNotifications = [];

  final List<String> topCoins = [
  "BTC", "ETH", "BNB", "SOL", "XRP", "ADA", "DOGE", "TON", "AVAX", "TRX"
];
String? selectedCoin;
  
  // Call this when an RSI alert is triggered (i.e., milestone achieved)

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
  
  double overboughtValue = 70;
  double oversoldValue = 30;
  bool pushNotif = true;
  bool emailNotif = false;

  


void _onSetAlert() {
  if (selectedCoin == null || selectedCoin!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select a coin.")),
    );
    return;
  }
  final newAlert = {
    "icon": Icons.show_chart,
    "title": "RSI Alert",
    "coin": selectedCoin, // <-- Add this line
    "subtitle": "$selectedCoin RSI Overbought: ${overboughtValue.toInt()}, Oversold: ${oversoldValue.toInt()}",
    "price": "OB:${overboughtValue.toInt()} / OS:${oversoldValue.toInt()}",
    "status": "Active",
    "isActive": true,
    "statusColor": Colors.green,
  };
  Navigator.pop(context, newAlert);
}

  void _onResetSettings() {
    setState(() {
      overboughtValue = 70;
      oversoldValue = 30;
      pushNotif = true;
      emailNotif = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Settings Reset!")),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            "RSI Alert Setup",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          // ...existing code...
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
                  tooltip: "RSI Alert Notifications",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF23242C),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "RSI Alert Notifications",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            if (rsiNotifications.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.cleaning_services, color: Colors.white54, size: 22),
                                tooltip: "Clear All",
                                onPressed: () {
                                  setState(() {
                                    rsiNotifications.clear();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                          ],
                        ),
                        content: rsiNotifications.isEmpty
                            ? const Text(
                                "No Notification Yet",
                                style: TextStyle(color: Colors.white54),
                              )
                            : SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: rsiNotifications.length,
                                  itemBuilder: (context, idx) {
                                    final notif = rsiNotifications[idx];
                                    return ListTile(
                                      leading: const Icon(Icons.show_chart, color: Colors.purpleAccent),
                                      title: Text(
                                        notif["desc"] ?? "",
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
                if (rsiNotifications.isNotEmpty)
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // --- Add this block ---
                  const Text(
                    "Coin Ticker",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
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
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  // --- End block ---
                  const SizedBox(height: 18),
                  // RSI Thresholds
                  const Text(
                    "RSI Thresholds",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23242C),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "▶ RSI Overbought",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              overboughtValue.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: overboughtValue,
                          min: 50,
                          max: 100,
                          divisions: 50,
                          activeColor: Colors.blueAccent,
                          inactiveColor: Colors.white24,
                          onChanged: (v) => setState(() => overboughtValue = v),
                        ),
                        const Text(
                          "Trigger an alert when RSI crosses above this level.",
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23242C),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "▶ RSI Oversold",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              oversoldValue.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: oversoldValue,
                          min: 0,
                          max: 50,
                          divisions: 50,
                          activeColor: Colors.blueAccent,
                          inactiveColor: Colors.white24,
                          onChanged: (v) => setState(() => oversoldValue = v),
                        ),
                        const Text(
                          "Trigger an alert when RSI crosses below this level.",
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // Notification Preferences
                  const Text(
                    "Notification Preferences",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23242C),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.notifications_active_outlined, color: Colors.pinkAccent, size: 21),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Push Notifications",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Receive instant alerts on your device.",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: pushNotif,
                              onChanged: (v) => setState(() => pushNotif = v),
                              activeColor: Colors.blue,
                              inactiveTrackColor: Colors.grey[700],
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white24, height: 20, thickness: 1),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined, color: Colors.pinkAccent, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Email Alerts",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Get detailed alerts in your inbox.",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: emailNotif,
                              onChanged: (v) => setState(() => emailNotif = v),
                              activeColor: Colors.blue,
                              inactiveTrackColor: Colors.grey[700],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Set Alert Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _onSetAlert,
                      icon: const Icon(Icons.notifications_active_outlined, color: Colors.white, size: 20),
                      label: const Text(
                        "Set Alert",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF23242C),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Reset Settings Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _onResetSettings,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24, width: 1.3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        "Reset Settings",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
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