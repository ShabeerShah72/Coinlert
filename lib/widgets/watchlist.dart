class WatchlistManager {
  static final WatchlistManager _instance = WatchlistManager._internal();
  factory WatchlistManager() => _instance;
  WatchlistManager._internal();

  final List<Map<String, dynamic>> recentCoins = [];

  void addCoin(Map<String, dynamic> coin) {
    recentCoins.removeWhere((c) => c['name'] == coin['name']);
    recentCoins.insert(0, coin);
    if (recentCoins.length > 5) {
      recentCoins.removeLast();
    }
  }
}