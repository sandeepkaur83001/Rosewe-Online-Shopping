import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/home/presentation/home_screen.dart';
import 'package:rosewe_online_shopping/features/category/presentation/category_screen.dart';
import 'package:rosewe_online_shopping/features/new_in/presentation/new_in_screen.dart';
import 'package:rosewe_online_shopping/features/bag/presentation/bag_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const NewInScreen(),
    const BagScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.blackColor,
        unselectedItemColor: AppColors.grayShade,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: _navIcon(
              "assets/images/home_icon.png",
              false,
            ),
            activeIcon: _navIcon(
              "assets/images/home_icon.png",
              true,
            ),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: _navIcon(
              "assets/images/categories_icon.png",
              false,
            ),
            activeIcon: _navIcon(
              "assets/images/categories_icon.png",
              true,
            ),
            label: 'Category',
          ),

          BottomNavigationBarItem(
            icon: _navIcon(
              "assets/images/deals_icon.png",
              false,
            ),
            activeIcon: _navIcon(
              "assets/images/deals_icon.png",
              true,
            ),
            label: 'New',
          ),

          BottomNavigationBarItem(
            icon: _navIcon(
              "assets/images/bag_icon.png",
              false,
            ),
            activeIcon: _navIcon(
              "assets/images/bag_icon.png",
              true,
            ),
            label: 'Bag',
          ),

          BottomNavigationBarItem(
            icon: _navIcon(
              "assets/images/profile_icon.png",
              false,
            ),
            activeIcon: _navIcon(
              "assets/images/profile_icon.png",
              true,
            ),
            label: 'Me',
          ),
        ],
      ),
    );
  }

  Widget _navIcon(String asset, bool selected) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        selected
            ? AppColors.blackColor
            : AppColors.grayShade,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        asset,
        width: 24,
        height: 24,
      ),
    );
  }
}
