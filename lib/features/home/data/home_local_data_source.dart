import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../models/home_item_model.dart';

/// Returns dummy home stream data from bundled JSON asset.
class HomeLocalDataSource {
  Future<List<HomeItemModel>> getHomeItems() async {
    final raw = await rootBundle.loadString(AppConstants.dummyHomePath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = json['streams'] as List<dynamic>;
    return list
        .map((e) => HomeItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
