class AppRoutes {
  AppRoutes._();

  // Boot
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Role
  static const String roleSelection = '/role-selection';

  // Client flow
  static const String clientHome = '/client/home';
  static const String freelancerDetail = '/client/freelancer-detail';
  static const String sendOffer = '/client/send-offer';
  static const String chatDetail = '/client/chat-detail';

  // Freelancer flow
  static const String freelancerOnboarding = '/freelancer/onboarding';
  static const String freelancerHome = '/freelancer/home';

  // Project client flow
  static const String projectOnboarding = '/project/onboarding';
  static const String projectClientHome = '/project/home';
}
