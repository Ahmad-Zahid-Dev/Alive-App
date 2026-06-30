import 'package:audioplayers/audioplayers.dart';
import '../constants/app_constants.dart';

/// Thin wrapper around audioplayers for UI sound effects.
/// Sounds are optional — if assets are missing, plays silently.
class SoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSplash() => _play(AppConstants.splashSoundPath);
  Future<void> playClick() => _play(AppConstants.clickSoundPath);
  Future<void> playSuccess() => _play(AppConstants.successSoundPath);

  Future<void> _play(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    } catch (_) {
      // Sound files are optional placeholders — fail silently.
    }
  }

  void dispose() => _player.dispose();
}
