import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/satellite_model.dart';
import 'package:sky_seek/services/satellite_service.dart';
import 'package:sky_seek/services/token_service.dart';

class SatelliteController extends GetxController {
  var satellites = <Satellite>[].obs;
  var selectedSatellite = Rxn<Satellite>();
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSatellites();
  }

  Future<void> fetchSatellites() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final token = await TokenService.getToken();
      if (token != null && token.isNotEmpty) {
        satellites.value = await SatelliteService.fetchSatellites(token);
        debugPrint('Loaded ${satellites.length} satellites');
      } else {
        throw Exception('Authentication token not found');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      debugPrint('Error loading satellites: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> prepareSatelliteDetails(String satelliteId) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    
    try {
      // First check if we already have this satellite's data
      final existingSatellite = satellites.firstWhereOrNull((sat) => sat.id == satelliteId);
      
      if (existingSatellite != null) {
        selectedSatellite.value = existingSatellite;
        debugPrint('Loaded satellite details from cache: ${existingSatellite.name}');
      } else {
        final token = await TokenService.getToken();
        if (token != null && token.isNotEmpty) {
          selectedSatellite.value = await SatelliteService.fetchSatelliteDetails(token, satelliteId);
          debugPrint('Loaded satellite details: ${selectedSatellite.value?.name}');
        } else {
          throw Exception('Authentication token not found');
        }
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      debugPrint('Error loading satellite details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
