import 'package:flutter/material.dart';

class RSIAlertEditSheet extends StatefulWidget {
  final String selectedCoin;
  final double overbought;
  final double oversold;

  const RSIAlertEditSheet({
    super.key,
    required this.selectedCoin,
    required this.overbought,
    required this.oversold,
  });

  @override
  State<RSIAlertEditSheet> createState() => _RSIAlertEditSheetState();
}

class _RSIAlertEditSheetState extends State<RSIAlertEditSheet> {
  late double overboughtValue;
  late double oversoldValue;

  @override
  void initState() {
    super.initState();
    overboughtValue = widget.overbought;
    oversoldValue = widget.oversold;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF23242C),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: Colors.purple[200], size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "RSI Alert",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${widget.selectedCoin} RSI",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white24, height: 22, thickness: 1),
            const SizedBox(height: 10),
            const Text(
              "RSI Thresholds",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Overbought", style: TextStyle(color: Colors.white70)),
                const Spacer(),
                Text(overboughtValue.toInt().toString(), style: const TextStyle(color: Colors.white)),
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
            Row(
              children: [
                const Text("Oversold", style: TextStyle(color: Colors.white70)),
                const Spacer(),
                Text(oversoldValue.toInt().toString(), style: const TextStyle(color: Colors.white)),
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
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "overbought": overboughtValue,
                    "oversold": oversoldValue,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Add Alert",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}