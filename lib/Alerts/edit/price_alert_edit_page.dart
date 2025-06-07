import 'package:flutter/material.dart';

class PriceAlertEditSheet extends StatefulWidget {
  final String selectedCoin;
  final String currentPrice;
  final String targetPrice;

  const PriceAlertEditSheet({
    super.key,
    required this.selectedCoin,
    required this.currentPrice,
    required this.targetPrice,
  });

  @override
  State<PriceAlertEditSheet> createState() => _PriceAlertEditSheetState();
}

class _PriceAlertEditSheetState extends State<PriceAlertEditSheet> {
  late TextEditingController targetPriceController;

  @override
  void initState() {
    super.initState();
    targetPriceController = TextEditingController(text: widget.targetPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF23242C),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.blue[200], size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Price Alert",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.selectedCoin} reaches ${widget.currentPrice}',
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
            TextField(
              controller: targetPriceController,
              style: const TextStyle(color: Color(0xFF757DFF), fontWeight: FontWeight.bold, fontSize: 22),
              decoration: const InputDecoration(
                labelText: "Target Price",
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "targetPrice": targetPriceController.text,
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