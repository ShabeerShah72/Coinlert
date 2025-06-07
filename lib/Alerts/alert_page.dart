import 'package:coinlert/Alerts/EMA_alert_page.dart';
import 'package:coinlert/Alerts/RSI_alert_page.dart';
import 'package:coinlert/Alerts/edit/ema_alert_edit_page.dart';
import 'package:coinlert/Alerts/edit/rsi_alert_edit_sheet.dart';
import 'package:coinlert/Alerts/price_alert_page.dart';
import 'package:coinlert/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:coinlert/Alerts/edit/price_alert_edit_page.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  int selectedFilterIndex = 0;
  int selectedIndex = 2; // Alert is selected

  double overboughtValue = 75;
  double oversoldValue = 30;

  final List<Map<String, dynamic>> filters = [
    {"label": "All"},
    {"label": "Price Alerts", "icon": Icons.attach_money},
    {"label": "RSI Alerts", "icon": Icons.show_chart},
    {"label": "EMA Alerts", "icon": Icons.multiline_chart},
  ];

  // Start with an empty alert list
  List<Map<String, dynamic>> alertCards = [];

  List<Map<String, dynamic>> notifications = [
    {
      "icon": Icons.attach_money,
      "title": "BTC Price Hit",
      "subtitle": "BTC/USD reached \$70,000",
      "price": "\$70000.00",
      "notifiedAt": DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      "icon": Icons.show_chart,
      "title": "ETH RSI Alert",
      "subtitle": "ETH/USD RSI dropped below 30",
      "price": "\$30.00",
      "notifiedAt": DateTime.now().subtract(const Duration(minutes: 2)),
    },
  ];

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

  Widget _filterButton(String label, {required int index, IconData? icon}) {
    final bool selected = index == selectedFilterIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton.icon(
        onPressed: () async {
          if (index == 2) { // RSI Alerts
            final newAlert = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RSIAlertSetupPage(),
              ),
            );
            if (newAlert != null && newAlert is Map<String, dynamic>) {
              setState(() {
                alertCards.insert(0, newAlert);
                selectedFilterIndex = 0; // Highlight "All"
              });
            } else {
              setState(() {
                selectedFilterIndex = 2; // Stay on RSI Alerts if nothing returned
              });
            }
          } else {
            setState(() {
              selectedFilterIndex = index;
            });
            switch (index) {
              case 1:
              final newAlert = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PriceAlertsPage(),
                ),
              );
              setState(() {
                selectedFilterIndex = 0; // Always highlight "All" after returning
              });
              if (newAlert != null && newAlert is Map<String, dynamic>) {
                setState(() {
                  alertCards.insert(0, newAlert);
                });
              }
              break;
              case 2:
              final newAlert = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RSIAlertSetupPage(),
                ),
              );
              setState(() {
                selectedFilterIndex = 0; // Always highlight "All" after returning
              });
              if (newAlert != null && newAlert is Map<String, dynamic>) {
                setState(() {
                  alertCards.insert(0, newAlert);
                });
              }
              break;
              case 3:
                 final newAlert = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EMAAlertSetupPage(),
                  ),
                );
                if (newAlert != null && newAlert is Map<String, dynamic>) {
                  setState(() {
                    alertCards.insert(0, newAlert);
                    selectedFilterIndex = 0; // Highlight "All"
                  });
                } else {
                  setState(() {
                    selectedFilterIndex = 0; // Stay on EMA Alerts if nothing returned
                  });
                }
                break;
              default:
                break;
            }
          }
        },
        icon: icon != null
            ? Icon(
                icon,
                color: selected ? Colors.black : Colors.white,
                size: 18,
              )
            : const SizedBox.shrink(),
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: selected ? Colors.white : const Color(0xFF23242C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: selected ? Colors.white : Colors.white24,
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _alertCard({
    required int idx,
    required IconData icon,
    required String title,
    required String subtitle,
    required String price,
    required String status,
    required Color statusColor,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF23242C),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue[200], size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      title == "RSI Alert" && alertCards[idx]["coin"] != null
                          ? "${alertCards[idx]["coin"]} RSI"
                          : subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == "Active" ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  setState(() {
                    alertCards.removeAt(idx);
                  });
                },
                child: const Icon(Icons.delete_outline, color: Colors.white38, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF757DFF),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 3),
              const Text(
                "Target",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white38, size: 20),
                onPressed: () async {
                  if (title == "Price Alert") {
                    final coin = subtitle.split(' ')[0];
                    final currentPrice = price;
                    final targetPrice = price;

                    final result = await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: PriceAlertEditSheet(
                            selectedCoin: coin,
                            currentPrice: currentPrice,
                            targetPrice: targetPrice,
                          ),
                        ),
                      ),
                    );
                    if (result != null && result["targetPrice"] != null) {
                      setState(() {
                        alertCards[idx]["title"] = "Price Alert";
                        alertCards[idx]["subtitle"] = "$coin reaches $currentPrice";
                        alertCards[idx]["price"] = result["targetPrice"];
                      });
                    }
                  } else if (title == "RSI Alert") {
                    final result = await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: RSIAlertEditSheet(
                          selectedCoin: alertCards[idx]["coin"] ?? "ETHUSDT", // Use the saved coin
                          overbought: overboughtValue,
                          oversold: oversoldValue,
                        ),
                      ),
                    ),
                  );
                    if (result != null) {
                      setState(() {
                        alertCards[idx]["title"] = "RSI Alert";
                        alertCards[idx]["subtitle"] = "${"ETHUSDT"} RSI";
                        alertCards[idx]["price"] = "Above ${result["overbought"].toInt()}/Below ${result["oversold"].toInt()}";
                        overboughtValue = result["overbought"];
                        oversoldValue = result["oversold"];
                      });
                    }
                  } else if (title == "EMA Alert") {
                    final coin = subtitle.split(' ')[0];
                    final priceParts = price.split(RegExp(r'[><, ]')).where((e) => e.isNotEmpty).toList();
                    int ema1 = priceParts.isNotEmpty ? int.tryParse(priceParts[0]) ?? 0 : 0;
                    int ema2 = priceParts.length > 1 ? int.tryParse(priceParts[1]) ?? 0 : 0;
                    String direction = price.contains('>') ? "Above" : "Below";

                    final result = await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: EMAAlertEditSheet(
                            selectedCoin: coin,
                            ema1: ema1,
                            ema2: ema2,
                            direction: direction,
                          ),
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        alertCards[idx]["title"] = "EMA Alert";
                        alertCards[idx]["subtitle"] = "$coin EMA crosses";
                        alertCards[idx]["price"] =
                            "${result["ema1"]}${result["direction"] == "Above" ? ">" : "<"}${result["ema2"]}";
                      });
                    }
                  } else {
                    _editAlertDialog(idx);
                  }
                },
                tooltip: "Edit",
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 22, thickness: 1),
          Row(
            children: [
              const Text(
                "Status Control",
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Switch(
                value: isActive,
                onChanged: (val) {
                  setState(() {
                    alertCards[idx]["isActive"] = val;
                    alertCards[idx]["status"] = val ? "Active" : "Inactive";
                    alertCards[idx]["statusColor"] = val ? Colors.green : Colors.grey;
                  });
                },
                activeColor: Colors.blue,
                inactiveTrackColor: Colors.grey[700],
              ),
            ],
          )
        ],
      ),
    );
  }

  void addNotification(Map<String, dynamic> alert) {
    setState(() {
      notifications.insert(0, {
        ...alert,
        "notifiedAt": DateTime.now(),
      });
      if (notifications.length > 20) notifications = notifications.sublist(0, 20);
    });
  }

  void _editAlertDialog(int idx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF23242C),
        title: const Text(
          "Edit Alert",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Edit functionality for this alert type is not implemented yet.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
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
              Navigator.maybePop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            "Alerts",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
                  tooltip: "Price Notifications",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF23242C),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Price Notifications",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            if (notifications.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.cleaning_services, color: Colors.white54, size: 22),
                                tooltip: "Clear All",
                                onPressed: () {
                                  setState(() {
                                    notifications.clear();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                          ],
                        ),
                        content: notifications.isEmpty
                            ? const Text(
                                "No Notification Yet",
                                style: TextStyle(color: Colors.white54),
                              )
                            : SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: notifications.length,
                                  itemBuilder: (context, idx) {
                                    final notif = notifications[idx];
                                    return ListTile(
                                      leading: Icon(notif["icon"], color: Colors.white70),
                                      title: Text(
                                        notif["title"] ?? "",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        "${notif["subtitle"] ?? ""}\n${notif["notifiedAt"] != null ? notif["notifiedAt"].toString().substring(0, 19) : ""}",
                                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                                      ),
                                      trailing: Text(
                                        notif["price"] ?? "",
                                        style: const TextStyle(color: Colors.blueAccent),
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
                if (notifications.isNotEmpty)
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Row(
              children: List.generate(
                filters.length,
                (i) => _filterButton(
                  filters[i]['label'],
                  index: i,
                  icon: filters[i]['icon'],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Column(
                children: List.generate(
                  alertCards.length,
                  (idx) => _alertCard(
                    idx: idx,
                    icon: alertCards[idx]["icon"],
                    title: alertCards[idx]["title"],
                    subtitle: alertCards[idx]["subtitle"],
                    price: alertCards[idx]["price"],
                    status: alertCards[idx]["status"],
                    statusColor: alertCards[idx]["statusColor"],
                    isActive: alertCards[idx]["isActive"],
                  ),
                ),
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