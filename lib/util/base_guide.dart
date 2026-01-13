

import 'package:flutter_base/util/common_imports.dart';
import 'package:flutter_base/util/common_methods.dart';
import 'package:flutter_base/util/custom_calendar.dart';
import 'package:flutter_base/util/custom_toggle_button.dart';
import 'package:flutter_base/util/top_banner.dart';
import 'package:geolocator/geolocator.dart';

class BaseGuide extends StatefulWidget {
  const BaseGuide({super.key});

  @override
  State<BaseGuide> createState() => _BaseGuideState();
}

class _BaseGuideState extends State<BaseGuide> {
  GlobalKey<TopBannerState> topBannerKey = GlobalKey<TopBannerState>();

  bool selected = true;
  final TextEditingController _controller = TextEditingController();
  int selectedtoggle = 0;

  Pair pair = Pair('Aakash', '21');

  Map<String, dynamic> userMap = {
    "id": 123,
    "name": "Aakash",
    "email": "aakash@example.com",
    "age": 21,
  };

  @override
  Widget build(BuildContext context) {
    Future<void> _checkAndGetLocation() async {
      bool success = await LocationPermissionClass.getCurrentPosition(context);

      if (success) {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          print("Latitude: ${position.latitude}");
          print("Longitude: ${position.longitude}");
        } catch (e) {
          print("Error getting location: $e");
        }
      } else {
        print("Location access denied or GPS disabled");
      }
    }

    return BaseScreen(
      topBannerKey: topBannerKey,
      child: Container(
        padding: EdgeInsets.all(10),
        color: AppColors.textColor,
        child: SingleChildScrollView(
          child: ButtonGridView(
            buttons: [
              CustomButton(
                text: 'TopBanner',
                onSubmit: () =>
                    RouteNavigate().navigateToPush(context, TopBanner()),
              ),
              CustomButton(
                text: 'Custom Calendar',
                onSubmit: () => RouteNavigate().navigateToPush(
                  context,
                  CustomCalendarScreen(),
                ),
              ),
              CustomButton(
                text: 'Custom Toast',
                onSubmit: () => CustomToast.showToast(
                  message: 'This is custom toast message, Kaisa lag rha hai',
                ),
              ),

              CustomButton(
                text: 'Location Permission',
                onSubmit: () {
                  _checkAndGetLocation();
                },
              ),
              CustomButton(
                text: 'Notification',
                onSubmit: () {
                  PushNotifications.showSimpleNotification(
                    title: 'test',
                    body: 'testing push notification',
                    data: userMap,
                  );
                },
              ),

              CustomButton(
                text: 'Camera Per.',
                onSubmit: () {
                  PermissionService().requestCameraPermission();
                },
              ),

              CustomButton(
                text: 'Photo Per.',
                onSubmit: () {
                  PermissionService().requestPhotosPermission();
                },
              ),

              CustomButton(
                text: 'Phone Per.',
                onSubmit: () {
                  PermissionService().requestPhonePermission();
                },
              ),

              CustomButton(
                text: 'Audio Per.',
                onSubmit: () {
                  PermissionService().requestAudioPermission();
                },
              ),

              CustomButton(
                text: 'Storage Per.',
                onSubmit: () {
                  PermissionService().requestStoragePermission();
                },
              ),

              CustomToggleSwitch(
                value: selected,

                onChanged: (value) {
                  setState(() {
                    selected = value;
                  });
                },
              ),

              CustomTextField(
                borderColor: AppColors.grayShade,
                hintText: 'custom text field',
                controller: _controller,
              ),

              CustomTextField(
                isPassword: true,
                borderColor: AppColors.grayShade,
                hintText: 'Password',
                controller: _controller,
              ),

              CustomText(text: 'Simple text'),

              OrDividerLine(),

              PrivacyPolicyWidget(),

              SubTab(
                title: 'Tab',
                onTap: () {},
                iconPath: 'assets/images/back_button_icon.png',
              ),

              GlossyButton(text: "Glossy BTN"),
              OutlineButton(text: 'Outline BTN'),
              SocialButton(text: 'Social BTN'),
              CustomToggleButton(
                labels: ['Yes', 'No'],
                selectedIndex: selectedtoggle,
                onChanged: (value) {
                  setState(() {
                    selectedtoggle = value;
                  });
                },
              ),

              CustomButton(
                text: 'SnackBar.',
                onSubmit: () {
                  snackBar('This is custom Snackbar');
                },
              ),

              CustomButton(
                text: 'Bottom Sheet.',
                onSubmit: () {
                  customBottomSheet(context, Container(height: 100));
                },
              ),

              CustomButton(
                text: 'Colored prints',
                onSubmit: () {
                  printSuccess('Success');
                  printError('Error');
                  printWarning('Warning');
                },
              ),

              CustomButton(
                text: 'showLoader',
                onSubmit: () {
                  DialogService().showLoader();

                  Future.delayed(Duration(seconds: 10), () {
                    DialogService().hideLoader();
                  });
                },
              ),

              CustomButton(
                text: 'Fetch Api',
                onSubmit: () {
                  CommonApiClass().API_CALL_FOR_DEBUGGING('value');
                },
              ),
            ],
          ),
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
        crossAxisAlignment: .start,
        children: [
          BackButton(),

          CustomButton(
            text: 'Show Banner',
            onSubmit: () {
              topBannerKey.currentState?.showTopBanner(
                type: MessageType.info,
                showLoader: false,
                message: 'Feching data....',
              );
            },
          ),
          SizedBox(height: 10),

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
      crossAxisSpacing: 4,
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
    return BaseScreen(
      child: Column(
        crossAxisAlignment: .start,
        children: [BackButton(), CalendarScreen()],
      ),
    );
  }
}