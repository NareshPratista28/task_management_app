import 'package:flutter/foundation.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0;
  String _currentRoute = '/';
  bool _showBottomNav = true;

  // Getters
  int get currentIndex => _currentIndex;
  String get currentRoute => _currentRoute;
  bool get showBottomNav => _showBottomNav;

  // Set current tab index
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Set current route
  void setCurrentRoute(String route) {
    _currentRoute = route;
    _updateBottomNavVisibility(route);
    notifyListeners();
  }

  // Update bottom navigation visibility based on route
  void _updateBottomNavVisibility(String route) {
    // Hide bottom nav on auth screens
    const authRoutes = [
      '/splash',
      '/onboarding',
      '/welcome',
      '/login',
      '/register',
    ];
    _showBottomNav = !authRoutes.contains(route);
  }

  // Navigate to tab
  void navigateToTab(int index) {
    setCurrentIndex(index);
  }
}
