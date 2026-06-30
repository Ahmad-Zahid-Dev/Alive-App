import '../models/home_item_model.dart';

/// Abstract home repository — UI/Providers depend only on this contract.
/// Future: swap implementation to call real REST API without touching UI.
abstract class HomeRepository {
  Future<List<HomeItemModel>> getHomeItems();
}
