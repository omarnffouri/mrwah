import 'package:get/get.dart';

import '../modules/all_vehicles/bindings/all_vehicles_binding.dart';
import '../modules/all_vehicles/views/all_vehicles_view.dart';
import '../modules/booking/views/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/car_detail/bindings/car_detail_binding.dart';
import '../modules/car_detail/views/car_detail_view.dart';
import '../modules/car_search/bindings/car_search_binding.dart';
import '../modules/car_search/views/car_search_view.dart';
import '../modules/car_wash/bindings/car_wash_binding.dart';
import '../modules/car_wash/views/car_wash_view.dart';
import '../modules/home/presentation/bindings/home_binding.dart';
import '../modules/home/presentation/views/home_view.dart';
import '../modules/languages/bindings/languages_binding.dart';
import '../modules/languages/views/languages_view.dart';
import '../modules/lock_screen/bindings/lock_screen_binding.dart';
import '../modules/lock_screen/views/lock_screen_view.dart';
import '../modules/login/presentation/bindings/login_binding.dart';
import '../modules/login/presentation/views/login_view.dart';
import '../modules/main_screen/bindings/main_screen_binding.dart';
import '../modules/main_screen/views/main_screen_view.dart';
import '../modules/my_bookings/bindings/bookings_binding.dart';
import '../modules/my_bookings/views/bookings_view.dart';
import '../modules/on_boarding/bindings/on_boarding_binding.dart';
import '../modules/on_boarding/views/on_boarding_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/partner_program/bindings/partner_program_binding.dart';
import '../modules/partner_program/views/partner_program_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register_stepper/bindings/register_stepper_binding.dart';
import '../modules/register_stepper/views/register_stepper_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/bindings/new_password_binding.dart';
import '../modules/reset_password/bindings/verify_reset_code_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/reset_password/views/new_password_view.dart';
import '../modules/reset_password/views/verify_reset_code_view.dart';
import '../modules/select_role/bindings/select_role_binding.dart';
import '../modules/select_role/views/select_role_view.dart';
import '../modules/shop_detail/views/bindings/shop_detail_binding.dart';
import '../modules/shop_detail/views/shop_detail_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_CODE,
      page: () => const VerifyResetCodeView(),
      binding: VerifyResetCodeBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => const NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_ROLE,
      page: () => const SelectRoleView(),
      binding: SelectRoleBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_STEPPER,
      page: () => const RegisterStepperView(),
      binding: RegisterStepperBinding(),
    ),
    GetPage(
      name: _Paths.CAR_DETAIL,
      page: () => const CarDetailView(),
      binding: CarDetailBinding(),
    ),
    GetPage(
      name: _Paths.CAR_SEARCH,
      page: () => const CarSearchView(),
      binding: CarSearchBinding(),
    ),
    GetPage(
      name: _Paths.CAR_WASH,
      page: () => const CarWashView(),
      binding: CarWashBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_SCREEN,
      page: () => const MainScreenView(),
      binding: MainScreenBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_DETAIL,
      page: () => const ShopDetailView(),
      binding: ShopDetailBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.BOOKINGS,
      page: () => const BookingsView(),
      binding: BookingsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PARTNER_PROGRAM,
      page: () => const PartnerProgramView(),
      binding: PartnerProgramBinding(),
    ),
    GetPage(
      name: _Paths.ALL_VEHICLES,
      page: () => const AllVehiclesView(),
      binding: AllVehiclesBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGES,
      page: () => const LanguagesView(),
      binding: LanguagesBinding(),
    ),
    GetPage(
      name: _Paths.LOCK_SCREEN,
      page: () => const LockScreenView(),
      binding: LockScreenBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
  ];
}
