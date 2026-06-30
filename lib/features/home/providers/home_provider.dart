import 'package:flutter/material.dart';
import '../models/home_item_model.dart';
import '../repositories/home_repository.dart';

enum HomeTab { stream, hot, follow }

/// Country filter model.
class CountryFilter {
  const CountryFilter({
    required this.label,
    required this.flag,
    required this.country,
  });
  final String label;
  final String flag;
  final String country; // empty = global
}

/// Manages home screen UI state: tabs, country filter, stream grid data.
class HomeProvider extends ChangeNotifier {
  HomeProvider({required this.homeRepository});

  final HomeRepository homeRepository;

  // ── State ─────────────────────────────────────────────────────────────────
  HomeTab _activeTab = HomeTab.stream;
  HomeTab get activeTab => _activeTab;

  int _activeCountryIndex = 0;
  int get activeCountryIndex => _activeCountryIndex;

  List<HomeItemModel> _items = [];
  List<HomeItemModel> get items => _filteredItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _notificationCount = 3;
  int get notificationCount => _notificationCount;

  // Set of followed streamer IDs (pre-populate with IDs '2' and '4' for dynamic initial content)
  final Set<String> _followedStreamerIds = {'2', '4'};
  Set<String> get followedStreamerIds => _followedStreamerIds;

  // ── Country filters ───────────────────────────────────────────────────────
  final List<CountryFilter> countryFilters = const [
    CountryFilter(label: 'Global', flag: '🌐', country: ''),
    CountryFilter(label: 'India', flag: '🇮🇳', country: 'India'),
    CountryFilter(label: 'Philippines', flag: '🇵🇭', country: 'Philippines'),
    CountryFilter(label: 'Brazil', flag: '🇧🇷', country: 'Brazil'),
    CountryFilter(label: 'Turkey', flag: '🇹🇷', country: 'Turkey'),
  ];

  // ── Getter for filtered items based on country filter and active tab ─────
  List<HomeItemModel> get _filteredItems {
    var list = _items;

    // 1. Filter by country first
    final selectedCountry = countryFilters[_activeCountryIndex].country;
    if (selectedCountry.isNotEmpty) {
      list = list.where((i) => i.country == selectedCountry).toList();
    }

    // 2. Filter/Sort by selected top tab
    switch (_activeTab) {
      case HomeTab.stream:
        // Default list order
        break;
      case HomeTab.hot:
        // Sort by viewer count descending (highest viewer count first)
        list = List<HomeItemModel>.from(list)
          ..sort((a, b) => b.viewerCount.compareTo(a.viewerCount));
        break;
      case HomeTab.follow:
        // Filter by followed streamers only
        list = list.where((i) => _followedStreamerIds.contains(i.id)).toList();
        break;
    }

    return list;
  }

  // ── Follow Actions ────────────────────────────────────────────────────────
  bool isFollowing(String streamerId) => _followedStreamerIds.contains(streamerId);

  void toggleFollow(String streamerId) {
    if (_followedStreamerIds.contains(streamerId)) {
      _followedStreamerIds.remove(streamerId);
    } else {
      _followedStreamerIds.add(streamerId);
    }
    notifyListeners();
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> loadHomeItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await homeRepository.getHomeItems();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTab(HomeTab tab) {
    _activeTab = tab;
    notifyListeners();
  }

  void selectCountry(int index) {
    _activeCountryIndex = index;
    notifyListeners();
  }

  void clearNotifications() {
    _notificationCount = 0;
    notifyListeners();
  }
}
