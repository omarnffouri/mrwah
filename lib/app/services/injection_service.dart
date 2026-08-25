import 'package:mrwah/app/core/connection/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mrwah/app/core/connection/dio_client.dart';
import 'package:mrwah/app/modules/booking/data/datasource/booking_car_remote_data_source.dart';
import 'package:mrwah/app/modules/booking/data/repo/booking_car_repository_impl.dart';
import 'package:mrwah/app/modules/booking/domain/repo/booking_car_repo.dart';
import 'package:mrwah/app/modules/booking/domain/usecases/create_booking_usecase.dart';
import 'package:mrwah/app/modules/home/data/datasources/remote_data_source.dart';
import 'package:mrwah/app/modules/home/data/repositories/car_repo_impl.dart';
import 'package:mrwah/app/modules/home/domain/repositories/cars_repo.dart';
import 'package:mrwah/app/modules/home/domain/usecases/get_best_cars_usecase.dart';
import 'package:mrwah/app/modules/home/domain/usecases/get_vehicles_usecase.dart';
import 'package:mrwah/app/modules/login/data/datasources/auth_remote_data_source.dart';
import 'package:mrwah/app/modules/login/data/repositories/auth_repository_impl.dart';
import 'package:mrwah/app/modules/login/domain/repo/auth_repository.dart';
import 'package:mrwah/app/modules/login/domain/usecases/add_device_token.dart';
import 'package:mrwah/app/modules/login/domain/usecases/delete_usecase.dart';
import 'package:mrwah/app/modules/login/domain/usecases/login_usecase.dart';
import 'package:mrwah/app/modules/login/domain/usecases/logout_usecase.dart';
import 'package:mrwah/app/modules/my_bookings/data/datasource/bookings_remote_datasource.dart';
import 'package:mrwah/app/modules/my_bookings/data/repos/bookings_repository_impl.dart';
import 'package:mrwah/app/modules/my_bookings/domain/repos/bookings_repository.dart';
import 'package:mrwah/app/modules/my_bookings/domain/usecases/get_bookings_usecase.dart';
import 'package:mrwah/app/modules/register_stepper/domain/usecases/register_usecase.dart';
import 'package:mrwah/app/modules/shop_detail/data/datasource/shop_remote_data_source.dart';
import 'package:mrwah/app/modules/shop_detail/data/repos/shop_repository_impl.dart';
import 'package:mrwah/app/modules/shop_detail/domain/repo/shop_repository.dart';
import 'package:mrwah/app/modules/shop_detail/domain/usecases/create_car_wash_booking_usecase.dart';
import 'package:mrwah/app/modules/shop_detail/domain/usecases/get_car_wash_shops_usecase.dart';
import 'package:mrwah/app/services/biometric_auth_service.dart';
import 'package:mrwah/app/modules/reset_password/data/datasources/reset_password_remote_data_source.dart';
import 'package:mrwah/app/modules/reset_password/data/repositories/reset_password_repository_impl.dart';
import 'package:mrwah/app/modules/reset_password/domain/repositories/reset_password_repository.dart';
import 'package:mrwah/app/modules/reset_password/domain/usecases/reset_password_usecase.dart';
import 'package:mrwah/app/modules/reset_password/domain/usecases/send_reset_email_usecase.dart';
import 'package:mrwah/app/modules/reset_password/domain/usecases/verify_reset_code_usecase.dart';

/// Main instance of [GetIt] for whole project
final sl = GetIt.instance;

Future<void> init() async {
  // initializing network related things
  initNetwork();
  // initializing repositories

  sl.registerLazySingleton<BiometricAuthService>(() => BiometricAuthService());

  initRepositories();
  // initilaizing datasources
  initDataSources();
  // initilaizing usecases
  initUseCases();
}

initNetwork() {
  sl.registerLazySingleton<INetworkInfo>(
    () => NetworkInfoImpl(dataConnectionChecker: sl()),
  );

  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker(),
  );

  sl.registerLazySingleton(() => DioClient());
}

/// Injecting repositories (Clean Arch) of api calls in [GetIt]
initRepositories() {
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ICarsRepository>(
    () => CarsRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<BookingsRepository>(
    () => BookingsRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<IBookingCarRepository>(
    () => BookingCarRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<IResetPasswordRepository>(
    () => ResetPasswordRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
}

/// Injecting data source (Clean Arch) of api calls in [GetIt]
initDataSources() {
  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ICarsRemoteDataSource>(
    () => CarsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<IBookingsRemoteDataSource>(
    () => BookingsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<IBookingCarRemoteDataSource>(
    () => BookingCarRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<IShopRemoteDataSource>(
    () => ShopRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<IResetPasswordRemoteDataSource>(
    () => ResetPasswordRemoteDataSourceImpl(),
  );
}

initUseCases() {
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetBestCarsUseCase(sl()));
  sl.registerLazySingleton(() => GetBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => CreateCarWashBookingUsecase(sl()));

  sl.registerLazySingleton(() => GetVehiclesUseCase(sl()));

  sl.registerLazySingleton(() => GetCarWashShopsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUsecase(sl()));
  sl.registerLazySingleton(() => AddDeviceTokenUseCase(sl()));
  sl.registerLazySingleton(() => SendResetEmailUseCase(sl()));
  sl.registerLazySingleton(() => VerifyResetCodeUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
}

/// Init a [GetStorage].
Future<void> initLocalDb() async {
  await GetStorage.init();
}
