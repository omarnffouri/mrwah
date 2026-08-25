import 'package:get/get.dart';
import 'package:mrwah/app/services/storage_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/home/data/models/brands_model.dart';
import 'package:mrwah/app/modules/home/domain/entities/car_entity.dart';
import 'package:mrwah/app/modules/home/domain/usecases/get_best_cars_usecase.dart';
import 'package:mrwah/app/modules/login/presentation/controllers/login_controller.dart';
import 'package:mrwah/app/services/injection_service.dart';

import '../../domain/entities/article_entity.dart';

class HomeController extends GetxController {
  // repository
  final user = Get.find<LoginController>().user;

  // variables
  final refreshController = RefreshController();
  final articles = <Article>[].obs;
  final isLoading = false.obs;
  final isError = false.obs;
  final errorCode = ''.obs;
  final getBestCarsUseCase = sl<GetBestCarsUseCase>();

  RxList<Brand> brands = <Brand>[].obs;
  RxList<CarEntity> bestCars = <CarEntity>[].obs;
  RxList<CarEntity> nearbyCars = <CarEntity>[].obs;
  RxList<CarEntity> filteredCars = <CarEntity>[].obs;
  RxString errorMessage = ''.obs;
  final favorites = <String>[].obs;

  // NEW: Selected brand filter
  RxString selectedBrand = ''.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
    debounce(searchQuery, (_) => filterCars(),
        time: const Duration(milliseconds: 200));
    loadFavorites();
  }

  void filterCars() {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty && selectedBrand.value.isEmpty) {
      filteredCars.assignAll(bestCars);
      return;
    }

    filteredCars.assignAll(bestCars.where((car) {
      final name = (car.name).toLowerCase();
      final brandName = (car.brandName).toLowerCase();

      final matchesSearch = query.isEmpty
          ? true
          : (name.contains(query) || brandName.contains(query));
      final matchesBrand = selectedBrand.value.isEmpty
          ? true
          : brandName == selectedBrand.value.toLowerCase();

      return matchesSearch && matchesBrand;
    }).toList());
  }

  void selectBrand(String brandName) {
    if (selectedBrand.value == brandName) {
      selectedBrand.value = '';
    } else {
      selectedBrand.value = brandName;
    }

    filterCars();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    isError.value = false;

    final result = await getBestCarsUseCase();
    result.fold(
      (data) {
        brands.value = data.brands;
        bestCars.value = data.bestCars;
        nearbyCars.value = data.nearbyCars ?? [];

        filteredCars.assignAll(bestCars);

        isError.value = false;
      },
      (Failure failure) {
        isError.value = true;
        errorMessage.value = failure.message;
      },
    );

    isLoading.value = false;
  }

  void loadFavorites() {
    final saved =
        StorageService.getFavorites().map((e) => e.toString()).toList();
    favorites.value = saved; // 👈 assign new list object
    favorites.refresh(); // 👈 force UI update (important!)
  }

  void toggleFavorite(String carId) async {
    await StorageService.toggleFavorite(carId);
    loadFavorites(); // reload from storage
  }
}
