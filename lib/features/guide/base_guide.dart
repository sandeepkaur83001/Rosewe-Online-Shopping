
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:geolocator/geolocator.dart';

class BaseGuide extends StatefulWidget {
  const BaseGuide({super.key});

  @override
  State<BaseGuide> createState() => _BaseGuideState();
}

class _BaseGuideState extends State<BaseGuide> {
  GlobalKey<TopBannerState> topBannerKey = GlobalKey<TopBannerState>();

  bool selected = true;
  bool _isSkeletonLoading = false;
  final TextEditingController _controller = TextEditingController();
  int selectedtoggle = 0;

  Pair pair = Pair('Aakash', '21');

  Map<String, dynamic> userMap = {
    "id": 123,
    "name": "Aakash",
    "email": "aakash@example.com",
    "age": 21,
  };

  Future<void> _checkAndGetLocation() async {
    bool success = await LocationPermissionClass.getCurrentPosition(context);

    if (success) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );

        printSuccess("Latitude: ${position.latitude}");
        printSuccess("Longitude: ${position.longitude}");
      } catch (e) {
        printError("Error getting location: $e");
      }
    } else {
      printWarning("Location access denied or GPS disabled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      topBannerKey: topBannerKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('UI Components'),
              ButtonGridView(
                buttons: [
                  CustomButton(
                    text: 'TopBanner',
                    onSubmit: () => RouteNavigate().navigateToPush(context, const TopBanner()),
                  ),
                  CustomButton(
                    text: 'Custom Calendar',
                    onSubmit: () => RouteNavigate().navigateToPush(
                      context,
                      const CustomCalendarScreen(),
                    ),
                  ),
                  CustomButton(
                    text: 'Custom Toast',
                    onSubmit: () => CustomToast.showToast(
                      message: 'This is custom toast message!',
                    ),
                  ),
                  CustomButton(
                    text: 'SnackBar',
                    onSubmit: () => snackBar('This is custom Snackbar'),
                  ),
                  CustomButton(
                    text: 'Bottom Sheet',
                    onSubmit: () => customBottomSheet(context, const Center(child: Text("Custom Content", style: TextStyle(fontSize: 20)))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Permissions'),
              ButtonGridView(
                buttons: [
                  CustomButton(
                    text: 'Location',
                    onSubmit: _checkAndGetLocation,
                  ),
                  CustomButton(
                    text: 'Camera',
                    onSubmit: () => PermissionService().requestCameraPermission(),
                  ),
                  CustomButton(
                    text: 'Photos',
                    onSubmit: () => PermissionService().requestPhotosPermission(),
                  ),
                  CustomButton(
                    text: 'Phone',
                    onSubmit: () => PermissionService().requestPhonePermission(),
                  ),
                  CustomButton(
                    text: 'Audio',
                    onSubmit: () => PermissionService().requestAudioPermission(),
                  ),
                  CustomButton(
                    text: 'Storage',
                    onSubmit: () => PermissionService().requestStoragePermission(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Form Elements'),
              CustomTextField(
                borderColor: AppColors.grayShade,
                hintText: 'Standard Text Field',
                controller: _controller,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                isPassword: true,
                borderColor: AppColors.grayShade,
                hintText: 'Password Field',
                controller: TextEditingController(),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                keyboardType: TextInputType.number,
                borderColor: AppColors.grayShade,
                hintText: 'Numeric Field (iOS Done View)',
                controller: TextEditingController(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const CustomText(text: 'Toggle Switch: '),
                  CustomToggleSwitch(
                    value: selected,
                    onChanged: (value) => setState(() => selected = value),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomToggleButton(
                labels: const ['Option A', 'Option B'],
                selectedIndex: selectedtoggle,
                onChanged: (value) => setState(() => selectedtoggle = value),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Buttons & Labels'),
              const ButtonGridView(
                buttons: [
                  GlossyButton(text: "Glossy"),
                  OutlineButton(text: 'Outline'),
                  SocialButton(text: 'Social'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Utilities & API'),
              ButtonGridView(
                buttons: [
                  CustomButton(
                    text: 'Pick Image (PNG/JPG)',
                    onSubmit: () => FilePickerHelper.showPicker(
                      context,
                      type: PickerType.image,
                      allowedExtensions: ['png', 'jpg', 'jpeg'],
                      onFilePicked: (file) {
                        if (file != null) printSuccess("Picked Image: ${file.path}");
                      },
                    ),
                  ),
                  CustomButton(
                    text: 'Pick Video',
                    onSubmit: () => FilePickerHelper.showPicker(
                      context,
                      type: PickerType.video,
                      onFilePicked: (file) {
                        if (file != null) printSuccess("Picked Video: ${file.path}");
                      },
                    ),
                  ),
                  CustomButton(
                    text: 'Pick Document',
                    onSubmit: () => FilePickerHelper.showPicker(
                      context,
                      type: PickerType.document,
                      allowedExtensions: ['pdf', 'doc', 'docx'],
                      onFilePicked: (file) {
                        if (file != null) printSuccess("Picked Doc: ${file.path}");
                      },
                    ),
                  ),
                  CustomButton(
                    text: 'Notification',
                    onSubmit: () {
                      PushNotifications.showSimpleNotification(
                        title: 'Test Notification',
                        body: 'This is a sample push notification',
                        data: userMap,
                      );
                    },
                  ),
                  CustomButton(
                    text: 'Colored Prints',
                    onSubmit: () {
                      printSuccess('Success Log');
                      printError('Error Log');
                      printWarning('Warning Log');
                    },
                  ),
                  CustomButton(
                    text: 'Show Loader',
                    onSubmit: () {
                      DialogService().showLoader(text: 'Processing...');
                      Future.delayed(const Duration(seconds: 2), () {
                        DialogService().hideLoader();
                      });
                    },
                  ),
                  CustomButton(
                    text: 'Fetch API',
                    onSubmit: () => CommonApiClass().API_CALL_FOR_DEBUGGING('value'),
                  ),
                  CustomButton(
                    text: 'Confirm Dialog',
                    onSubmit: () => DialogService().showConfirmationDialog(
                      title: 'Logout',
                      message: 'Are you sure you want to logout?',
                      onConfirm: () => printSuccess('Confirmed!'),
                    ),
                  ),
                  CustomButton(
                    text: 'Switch Theme',
                    onSubmit: () => ThemeService.switchTheme(),
                  ),
                  CustomButton(
                    text: 'Follow System',
                    onSubmit: () => ThemeService.setSystemTheme(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Advanced Utilities'),
              ButtonGridView(
                buttons: [
                  CustomButton(
                    text: 'App/Device Info',
                    onSubmit: () {
                      printSuccess("App Version: ${DeviceInfoUtil.version}");
                      printSuccess("Device Model: ${DeviceInfoUtil.model}");
                      CustomToast.showToast(message: "Check logs for full device info");
                    },
                  ),
                  CustomButton(
                    text: 'Empty State',
                    onSubmit: () => customBottomSheet(
                      context,
                      const EmptyStateWidget(
                        title: 'No Data Found',
                        message: 'This is a sample empty state widget.',
                        icon: Icons.search_off,
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Network Image',
                    onSubmit: () => customBottomSheet(
                      context,
                      const Column(
                        children: [
                          NetworkImageView(
                            url: 'https://picsum.photos/400/200',
                            height: 150,
                            borderRadius: 12,
                          ),
                          SizedBox(height: 10),
                          CustomText(text: 'Image with shimmer loading'),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Test Env Config',
                    onSubmit: () {
                      printWarning("Current Env: ${EnvConfig.environment.name}");
                      printWarning("Base URL: ${EnvConfig.baseUrl}");
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Skeleton Loading'),
              CustomButton(
                text: _isSkeletonLoading ? 'Stop Loading' : 'Start Loading',
                onSubmit: () => setState(() => _isSkeletonLoading = !_isSkeletonLoading),
              ),
              const SizedBox(height: 10),
              CustomSkeleton(
                isLoading: _isSkeletonLoading,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 30, backgroundColor: Colors.grey),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: double.infinity, height: 16, color: Theme.of(context).colorScheme.onSurface),
                            const SizedBox(height: 8),
                            Container(width: 150, height: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const PrivacyPolicyWidget(),
              const SizedBox(height: 20),
              const OrDividerLine(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class TopBanner extends StatefulWidget {
  const TopBanner({super.key});

  @override
  State<TopBanner> createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  GlobalKey<TopBannerState> topBannerKey = GlobalKey<TopBannerState>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      topBannerKey: topBannerKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BackButton(),
          CustomButton(
            text: 'Show Banner',
            onSubmit: () {
              topBannerKey.currentState?.showTopBanner(
                type: MessageType.info,
                showLoader: false,
                message: 'Fetching data....',
              );
            },
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Hide Banner',
            onSubmit: () {
              topBannerKey.currentState?.hideTopBanner();
            },
          ),
        ],
      ),
    );
  }
}

class ButtonGridView extends StatelessWidget {
  final List<Widget> buttons;
  final int crossAxisCount;

  const ButtonGridView({
    super.key,
    required this.buttons,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 8,
      mainAxisSpacing: 12,
      childAspectRatio: 3.6,
      children: buttons,
    );
  }
}

class CustomCalendarScreen extends StatefulWidget {
  const CustomCalendarScreen({super.key});

  @override
  State<CustomCalendarScreen> createState() => _CustomCalendarStateScreen();
}

class _CustomCalendarStateScreen extends State<CustomCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [BackButton(), CalendarScreen()],
      ),
    );
  }
}
