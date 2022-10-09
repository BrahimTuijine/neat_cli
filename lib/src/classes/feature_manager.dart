import 'dart:io';

/// [FeatureManager] handle the creating of the features
abstract class FeatureManager {
  Future<void> createFeature(String featureName, Directory current) async {}
}
