import 'package:coinlert/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // At the top of your file
import 'package:intl/intl.dart'; // For formatting time (optional)

class EMAAlertSetupPage extends StatefulWidget {
  final VoidCallback? onTapHome;
  final VoidCallback? onTapExplore;
  final VoidCallback? onTapMarket;
  final VoidCallback? onTapAlert;
  final VoidCallback? onTapAccount;

  const EMAAlertSetupPage({
    super.key,
    this.onTapHome,
    this.onTapExplore,
    this.onTapMarket,
    this.onTapAlert,
    this.onTapAccount,
  });

  @override
  State<EMAAlertSetupPage> createState() => _EMAAlertSetupPageState();
}

class _EMAAlertSetupPageState extends State<EMAAlertSetupPage> {
  int selectedIndex = -4; // My account

  // Add this variable to track the selected filter index
  int selectedFilterIndex = 0;

  // List to store only EMA alert notifications
  List<Map<String, dynamic>> emaNotifications = [];

  final List<String> topCoins = [
  "BTC", "ETH", "BNB", "SOL", "XRP", "ADA", "DOGE", "TON", "AVAX", "TRX"
  ];
  String? selectedCoin;


  Future<void> _onNavBarTap(int index) async {
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
      case 3: // EMA Alerts
        final newAlert = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EMAAlertSetupPage(),
          ),
        );
        if (newAlert != null && newAlert is Map<String, dynamic>) {
          setState(() {
            alertRules.insert(0, newAlert);
            selectedFilterIndex = 0; // Highlight "All"
          });
        } else {
          setState(() {
            selectedFilterIndex = 3;
          });
        }
        break;
      case 4:
          Navigator.pushReplacementNamed(context, '/account');
          break;
      }
  }

  
  final TextEditingController ema1Controller = TextEditingController();
  final TextEditingController ema2Controller = TextEditingController();
  String? selectedDirection;
  bool canCreateRule = false;

  
  List<String> directions = ["Above", "Below"];
  List<Map<String, dynamic>> alertRules = [
    {
      "ema1": "EMA 29",
      "direction": "above",
      "ema2": "EMA 200",
      "active": true,
      "pair": "BTC/USD"
    },
    {
      "ema1": "EMA 200",
      "direction": "below",
      "ema2": "EMA 20",
      "active": false,
      "pair": "ETH/BTC"
    },
  ];

  List<bool> emaSelected = [true, true]; // EMA 29, EMA 200
  bool pushNotif = true;
  bool emailNotif = false;


  void _onClear() {
    ema1Controller.clear();
    ema2Controller.clear();
    setState(() {
      selectedDirection = null;
      canCreateRule = false;
    });
  }

   void _onCreateRule() {
  if (selectedCoin == null || selectedCoin!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select a coin.")),
    );
    return;
  }
  if (ema1Controller.text.isEmpty || ema2Controller.text.isEmpty || selectedDirection == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields.")),
    );
    return;
  }
  // Validate numeric input
  final ema1 = num.tryParse(ema1Controller.text);
  final ema2 = num.tryParse(ema2Controller.text);
  if (ema1 == null || ema2 == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("EMA periods must be numbers.")),
    );
    return;
  }

  final newAlert = {
    "icon": Icons.multiline_chart,
    "title": "EMA Alert",
    "coin": selectedCoin,
    "subtitle": "$selectedCoin EMA $ema1 ${selectedDirection!.toLowerCase()} EMA $ema2",
    "price": "$ema1${selectedDirection == "Above" ? ">" : "<"}$ema2",
    "status": "Active",
    "isActive": true,
    "statusColor": Colors.green,
  };

  Navigator.pop(context, newAlert); // Return the alert to AlertsPage
}
  
  void _onAddMoreConditions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Add More Conditions tapped!")),
    );
  }

    void _checkCreateRule() {
    setState(() {
      canCreateRule = ema1Controller.text.isNotEmpty &&
          ema2Controller.text.isNotEmpty &&
          selectedDirection != null;
    });
  }




  Widget _notificationSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [ 
        Icon(icon, color: Colors.white54, size: 19),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
          inactiveTrackColor: Colors.grey[700],
        ),
      ],
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
              Navigator.pop(context, "ALL"); 
            },
          ),
          title: const Text(
            "EMA Alert Setup",
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
                  icon: const Icon(Icons.multiline_chart, color: Colors.orangeAccent),
                  tooltip: "EMA Notifications",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF23242C),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "EMA Notifications",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            if (emaNotifications.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.cleaning_services, color: Colors.white54, size: 22),
                                tooltip: "Clear All",
                                onPressed: () {
                                  setState(() {
                                    emaNotifications.clear();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                          ],
                        ),
                        content: emaNotifications.isEmpty
                            ? const Text(
                                "No Notification Yet",
                                style: TextStyle(color: Colors.white54),
                              )
                            : SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: emaNotifications.length,
                                  itemBuilder: (context, idx) {
                                    final notif = emaNotifications[idx];
                                    return ListTile(
                                      leading: const Icon(Icons.multiline_chart, color: Colors.orangeAccent),
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
                if (emaNotifications.isNotEmpty)
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // New EMA Alert Condition
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23242C),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.multiline_chart, color: Colors.blueAccent, size: 22),
                            SizedBox(width: 7),
                            Text(
                              "New EMA Alert Condition",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Coin Ticker",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: selectedCoin,
                          dropdownColor: const Color(0xFF35363B),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF35363B),
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
                        const Text(
                          "EMA 1 Period:",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: ema1Controller,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}')),
                          ],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "e.g., 12",
                            hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                            filled: true,
                            fillColor: const Color(0xFF35363B),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "EMA 2 Period:",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: ema2Controller,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}')),
                          ],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "e.g., 26",
                            hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                            filled: true,
                            fillColor: const Color(0xFF35363B),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Crossover Direction:",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF35363B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedDirection,
                            hint: const Text(
                              "Select direction",
                              style: TextStyle(color: Colors.white38, fontSize: 14),
                            ),
                            underline: const SizedBox(),
                            dropdownColor: const Color(0xFF35363B),
                            items: directions
                                .map((dir) => DropdownMenuItem<String>(
                                      value: dir,
                                      child: Text(
                                        dir,
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedDirection = v;
                                _checkCreateRule();
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _onAddMoreConditions,
                            icon: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 20),
                            label: const Text(
                              "Add More Conditions",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF35363B),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _onClear,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: const Text(
                                  "Clear",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: canCreateRule ? _onCreateRule : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canCreateRule ? Colors.blueAccent : Colors.grey[800],
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: Text(
                                  "Create Rule",
                                  style: TextStyle(
                                    color: canCreateRule ? Colors.white : Colors.white54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  // Notification Preferences
                  const Text(
                    "Notification Preferences",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23242C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "How to Notify Me",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _notificationSwitch(
                          icon: Icons.notifications_active_outlined,
                          title: "Push Notification",
                          subtitle: "Receive instant alerts on your device.",
                          value: pushNotif,
                          onChanged: (v) => setState(() => pushNotif = v),
                        ),
                        const Divider(color: Colors.white24, height: 22, thickness: 1),
                        _notificationSwitch(
                          icon: Icons.email_outlined,
                          title: "Email Notification",
                          subtitle: "Get details sent directly to your inbox.",
                          value: emailNotif,
                          onChanged: (v) => setState(() => emailNotif = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: _onNavBarTap,
      )
    );
  }
}

// ignore: unused_element
class _FakeCrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 2;
    final paint2 = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2;
    final paint3 = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.3), paint1);
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.7), paint2);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), paint3);
  }

  @override
  bool shouldRepaint(_FakeCrossPainter oldDelegate) => false;
}