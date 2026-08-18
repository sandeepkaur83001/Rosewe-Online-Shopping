import 'dart:io';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/profile/data/repository/profile_repository.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/about_rosewe_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/country_selection_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/currency_selection_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/complete_profile_screen.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/setup_password_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/empty_order_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/contact_us_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/account_delete_reason_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/change_password_screen.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/feedback_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final ProfileController _controller = Get.find<ProfileController>();
  final ProfileRepository _repository = ProfileRepository();
  String _selectedCountry = 'United States';
  String _selectedCurrency = 'USD';
  String _cacheSize = '0.00 MB';

  @override
  void initState() {
    super.initState();
    _calculateCacheSize();
    _initializeSettings();
  }

  void _initializeSettings() {
    final profile = _controller.userProfile.value;
    if (profile != null) {
      if (profile.countryId != null) {
        final country = _controller.countries.firstWhereOrNull((c) => c.id == profile.countryId);
        if (country != null) _selectedCountry = country.name ?? 'United States';
      }
    }
  }

  Future<void> _updatePushNotification(bool enable) async {
    final status = enable ? 'on' : 'off';
    final body = {
      'push_enable': status,
    };

    try {
      final success = await _repository.updateProfile(body, showLoader: true);
      if (success) {
        await _controller.fetchProfile(showLoader: false);
        CustomToast.showToast(message: 'Push notifications updated to $status');
      } else {
        CustomToast.showToast(message: 'Failed to update push notifications');
      }
    } catch (e) {
      debugPrint("Error updating push notification: $e");
    }
  }

  Future<void> _calculateCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      int tempDirSize = await _getDirSize(tempDir);
      
      setState(() {
        _cacheSize = '${(tempDirSize / (1024 * 1024)).toStringAsFixed(2)} MB';
      });
    } catch (e) {
      debugPrint("Error calculating cache size: $e");
    }
  }

  Future<int> _getDirSize(Directory dir) async {
    int size = 0;
    try {
      if (dir.existsSync()) {
        dir.listSync(recursive: true, followLinks: false).forEach((FileSystemEntity entity) {
          if (entity is File) {
            size += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      debugPrint("Error getting directory size: $e");
    }
    return size;
  }

  Future<void> _clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
      
      CustomToast.showToast(message: 'Cache cleared successfully');
      _calculateCacheSize();
    } catch (e) {
      debugPrint("Error clearing cache: $e");
      CustomToast.showToast(message: 'Failed to clear cache');
    }
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF1F1), Colors.white],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Image.asset(
                'assets/images/review_rating_asset.png',
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'Rating & Feedback',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              const CustomText(
                text: 'Would you mind leaving a review and let us know what you love and what we need to improve?',
                fontSize: 14,
                align: TextAlign.center,
                textColor: AppColors.grayShade,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'RATING',
                buttonColor: AppColors.blackColor,
                textColor: AppColors.whiteColor,
                borderRadius: 0,
                height: 45,
                onSubmit: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'FEEDBACK',
                buttonColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                borderColor: AppColors.blackColor,
                widthDecoration: 1,
                borderRadius: 0,
                height: 45,
                onSubmit: () {
                  RouteNavigate().safePop(context);
                  RouteNavigate().navigateToPush(context, FeedbackScreen());
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        centerTitle: true,
        title: const CustomText(
          text: 'Account Settings',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'DancingScript',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            if (!_controller.isLoggedIn.value)
              _buildGroup([
                _settingsItem(context, 'Sign In/Create Account', onTap: () {
                  RouteNavigate().navigateToPush(context, const LoginScreen());
                }),
              ]),
            _buildGroup([
              _settingsItem(context, 'Country/Region', value: _selectedCountry, onTap: () async {
                final result = await RouteNavigate().navigateToPush(
                  context, 
                  CountrySelectionScreen(currentCountry: _selectedCountry),
                );
                if (result != null) {
                  setState(() {
                    _selectedCountry = result;
                  });
                }
              }),
              // _settingsItem(context, 'Currency', value: _selectedCurrency, onTap: () async {
              //   final result = await RouteNavigate().navigateToPush(
              //     context,
              //     CurrencySelectionScreen(currentCurrency: _selectedCurrency),
              //   );
              //   if (result != null) {
              //     setState(() {
              //       _selectedCurrency = result;
              //     });
              //   }
              // }),
            ]),
            _buildGroup([
              _settingsItem(context, 'My Profile', onTap: () {
                final email = _controller.userProfile.value?.email ?? '';
                RouteNavigate().navigateToPush(context, CompleteProfileScreen(email: email));
              }),
            ]),
            _buildGroup([
              _settingsItem(context, 'Add Password', onTap: () {
                RouteNavigate().navigateToPush(context, const ChangePasswordScreen());
              }),
              _settingsItem(context, 'Address Book', onTap: () {
                RouteNavigate().navigateToPush(context, const AddressBookScreen());
              }),
              _settingsItem(context, 'Delete Account', onTap: () {
                RouteNavigate().navigateToPush(context, const AccountDeleteReasonScreen());
              }),
              _settingsItem(context, 'Contact Us', onTap: () {
                RouteNavigate().navigateToPush(context, const ContactUsScreen());
              }),
            ]),
            _buildGroup([
              _settingsItem(
                context, 
                'Push Notifications', 
                value: (_controller.userProfile.value?.pushEnable ?? 'off').toUpperCase(),
                onTap: () {
                  if (!_controller.isLoggedIn.value) {
                    RouteNavigate().navigateToPush(context, const LoginScreen());
                    return;
                  }
                  
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomText(text: 'Push Notifications', fontSize: 18, fontWeight: FontWeight.bold),
                          const SizedBox(height: 20),
                          ListTile(
                            title: const CustomText(text: 'ON', fontSize: 16),
                            onTap: () {
                              Get.back();
                              _updatePushNotification(true);
                            },
                          ),
                           Divider(height: 1,color: Colors.grey.withAlpha(60),),
                          ListTile(
                            title: const CustomText(text: 'OFF', fontSize: 16),
                            onTap: () {
                              Get.back();
                              _updatePushNotification(false);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  );
                }
              ),
              _settingsItem(context, 'About Rosewe', onTap: () {
                RouteNavigate().navigateToPush(context, const AboutRoseweScreen());
              }),
            ]),
            _buildGroup([
              _settingsItem(context, 'Rating & Feedback', onTap: () => _showRatingDialog(context)),
              _settingsItem(context, 'Clear Cache', value: _cacheSize, onTap: _clearCache),
              _settingsItem(context, 'Version', value: DeviceInfoUtil.version),
            ]),
            if (_controller.isLoggedIn.value)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: CustomButton(
                  text: 'LOGOUT',
                  buttonColor: AppColors.blackColor,
                  textColor: AppColors.whiteColor,
                  borderRadius: 0,
                  height: 50,
                  onSubmit: () {
                    _controller.logout();
                    Navigator.pop(context);
                  },
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }

  Widget _buildGroup(List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
        ),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index < items.length - 1)
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _settingsItem(BuildContext context, String title, {String? value, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: CustomText(
        text: title,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        textColor: Colors.black87,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            CustomText(
              text: value,
              fontSize: 15,
              textColor: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
        ],
      ),
    );
  }
}
