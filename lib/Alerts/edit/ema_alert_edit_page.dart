import 'package:flutter/material.dart';

class EMAAlertEditSheet extends StatefulWidget {
  final String selectedCoin;
  final int ema1;
  final int ema2;
  final String direction;

  const EMAAlertEditSheet({
    super.key,
    required this.selectedCoin,
    required this.ema1,
    required this.ema2,
    required this.direction,
  });

  @override
  State<EMAAlertEditSheet> createState() => _EMAAlertEditSheetState();
}

class _EMAAlertEditSheetState extends State<EMAAlertEditSheet> {
  late TextEditingController ema1Controller;
  late TextEditingController ema2Controller;
  String direction = "Above";

  @override
  void initState() {
    super.initState();
    ema1Controller = TextEditingController(text: widget.ema1.toString());
    ema2Controller = TextEditingController(text: widget.ema2.toString());
    direction = widget.direction;
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
                Icon(Icons.multiline_chart, color: Colors.orange[200], size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "EMA Alert",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${widget.selectedCoin} EMA crosses",
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ema1Controller,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "EMA 1",
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: ema2Controller,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "EMA 2",
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Crossover Direction",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    value: "Above",
                    groupValue: direction,
                    onChanged: (val) => setState(() => direction = val!),
                    title: const Text("Above", style: TextStyle(color: Colors.white)),
                    activeColor: Colors.blue,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    value: "Below",
                    groupValue: direction,
                    onChanged: (val) => setState(() => direction = val!),
                    title: const Text("Below", style: TextStyle(color: Colors.white)),
                    activeColor: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "ema1": int.tryParse(ema1Controller.text) ?? 0,
                    "ema2": int.tryParse(ema2Controller.text) ?? 0,
                    "direction": direction,
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