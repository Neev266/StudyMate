import 'package:flutter_app/features/Game/data/game_model.dart';
import 'package:flutter_app/core/api/api_game.dart';

class BoredRepository {
  final ApiClient apiClient;

  BoredRepository(this.apiClient);

  Future<BoredActivity> fetchActivity() async {
    final data =
        await apiClient.get('https://bored-api.appbrewery.com/random');
    return BoredActivity.fromJson(data);
  }
}
