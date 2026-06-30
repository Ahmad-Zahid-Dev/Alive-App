/// Represents a single live stream item in the home grid.
class HomeItemModel {
  const HomeItemModel({
    required this.id,
    required this.streamerName,
    required this.thumbnailUrl,
    required this.country,
    required this.flagEmoji,
    required this.viewerCount,
    this.isLive = true,
  });

  final String id;
  final String streamerName;
  final String thumbnailUrl;
  final String country;
  final String flagEmoji;
  final int viewerCount;
  final bool isLive;

  factory HomeItemModel.fromJson(Map<String, dynamic> json) => HomeItemModel(
        id: json['id'] as String? ?? '',
        streamerName: json['streamerName'] as String? ?? '',
        thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
        country: json['country'] as String? ?? '',
        flagEmoji: json['flagEmoji'] as String? ?? '',
        viewerCount: json['viewerCount'] as int? ?? 0,
        isLive: json['isLive'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'streamerName': streamerName,
        'thumbnailUrl': thumbnailUrl,
        'country': country,
        'flagEmoji': flagEmoji,
        'viewerCount': viewerCount,
        'isLive': isLive,
      };

  /// Format viewer count for display (e.g. 8200 → "8.2K").
  String get viewerCountFormatted {
    if (viewerCount >= 1000) {
      return '${(viewerCount / 1000).toStringAsFixed(1)}K';
    }
    return viewerCount.toString();
  }
}
