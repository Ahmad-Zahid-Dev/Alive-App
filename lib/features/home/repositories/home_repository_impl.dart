import '../data/home_local_data_source.dart';
import '../models/home_item_model.dart';
import 'home_repository.dart';

/// Concrete [HomeRepository] using local dummy data.
/// To connect to a real API, swap [HomeLocalDataSource] for a remote source.
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.localDataSource});

  final HomeLocalDataSource localDataSource;

  @override
  Future<List<HomeItemModel>> getHomeItems() =>
      localDataSource.getHomeItems();
}
