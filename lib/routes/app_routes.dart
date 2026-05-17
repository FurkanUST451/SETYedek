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

  // Client (Hizmet Al) flow
  static const String clientHome = '/client/home';
  static const String categoryPicker = '/client/category-picker';
  static const String freelancersByCategory = '/client/freelancers-by-category';
  static const String freelancerDetail = '/client/freelancer-detail';
  static const String sendOffer = '/client/send-offer';
  static const String projectMode = '/client/project-mode';
  static const String chatDetail = '/client/chat-detail';
  static const String projectDetail = '/client/project-detail';

  // Freelancer (Hizmet Ver) flow — implementation pending
  static const String freelancerOnboarding = '/freelancer/onboarding';
  static const String freelancerHome = '/freelancer/home';
}
