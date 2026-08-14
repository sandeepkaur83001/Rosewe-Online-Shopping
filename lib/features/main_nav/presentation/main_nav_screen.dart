import 'package:get/get.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/home/presentation/home_screen.dart';
import 'package:rosewe_online_shopping/features/category/presentation/category_screen.dart';
import 'package:rosewe_online_shopping/features/new_in/presentation/new_in_screen.dart';
import 'package:rosewe_online_shopping/features/bag/presentation/bag_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/profile_screen.dart';
import 'package:rosewe_online_shopping/features/home/controller/home_controller.dart';

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
    if (index == 0) {
      Get.find<HomeController>().getHomeData(showLoader: false);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.blackColor,
        unselectedItemColor: AppColors.grayShade,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/unselected_home_icon.png",
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              "assets/images/home_icon.png",
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/categories_icon.png",
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              "assets/images/selected_categories_icon.png",
              width: 24,
              height: 24,
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
            icon: Image.asset(
              "assets/images/unselected_bag.png",
              width: 28,
              height: 28,
            ),
            activeIcon: Image.asset(
              "assets/images/selected_bag.png",
              width: 30,
              height: 30,
            ),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/unselected_me.png",
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              "assets/images/selected_me.png",
              width: 24,
              height: 24,
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
        width: 30,
        height: 30,
        fit: BoxFit.contain ,
      ),
    );
  }
}
