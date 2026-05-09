import 'package:get/get.dart';

import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/register/register_binding.dart';
import '../modules/auth/register/register_view.dart';
import '../modules/client/chat_detail/chat_detail_binding.dart';
import '../modules/client/chat_detail/chat_detail_view.dart';
import '../modules/client/freelancer_detail/freelancer_detail_binding.dart';
import '../modules/client/freelancer_detail/freelancer_detail_view.dart';
import '../modules/client/home/client_home_binding.dart';
import '../modules/client/home/client_home_view.dart';
import '../modules/client/send_offer/send_offer_binding.dart';
import '../modules/client/send_offer/send_offer_view.dart';
import '../modules/freelancer/home/freelancer_home_binding.dart';
import '../modules/freelancer/home/freelancer_home_view.dart';
import '../modules/freelancer/onboarding/freelancer_onboarding_binding.dart';
import '../modules/freelancer/onboarding/freelancer_onboarding_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/project_client/home/project_client_home_binding.dart';
import '../modules/project_client/home/project_client_home_view.dart';
import '../modules/project_client/onboarding/project_onboarding_binding.dart';
import '../modules/project_client/onboarding/project_onboarding_view.dart';
import '../modules/role_selection/role_selection_binding.dart';
import '../modules/role_selection/role_selection_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.roleSelection,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
    ),

    // Client
    GetPage(
      name: AppRoutes.clientHome,
      page: () => const ClientHomeView(),
      binding: ClientHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.freelancerDetail,
      page: () => const FreelancerDetailView(),
      binding: FreelancerDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.sendOffer,
      page: () => const SendOfferView(),
      binding: SendOfferBinding(),
    ),
    GetPage(
      name: AppRoutes.chatDetail,
      page: () => const ChatDetailView(),
      binding: ChatDetailBinding(),
    ),

    // Freelancer
    GetPage(
      name: AppRoutes.freelancerOnboarding,
      page: () => const FreelancerOnboardingView(),
      binding: FreelancerOnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.freelancerHome,
      page: () => const FreelancerHomeView(),
      binding: FreelancerHomeBinding(),
    ),

    // Project Client
    GetPage(
      name: AppRoutes.projectOnboarding,
      page: () => const ProjectOnboardingView(),
      binding: ProjectOnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.projectClientHome,
      page: () => const ProjectClientHomeView(),
      binding: ProjectClientHomeBinding(),
    ),
  ];
}
