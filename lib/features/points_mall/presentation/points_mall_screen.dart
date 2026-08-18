import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';

class PointsMallScreen extends StatefulWidget {
  const PointsMallScreen({super.key});

  @override
  State<PointsMallScreen> createState() => _PointsMallScreenState();
}

class _PointsMallScreenState extends State<PointsMallScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final StreamController<int> _selected = StreamController<int>.broadcast();

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Points Mall',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDE2DC),
              Color(0xFFF7F7F7),
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDailyCheckInCard(),
              const SizedBox(height: 20),
              _buildSpinWheelSection(),
              const SizedBox(height: 20),
              _buildRedeemCouponHeader(),
              _buildCouponList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyCheckInCard() {
    final checkIn = _profileController.checkInData.value;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              children: [
                const TextSpan(text: 'My Points: '),
                TextSpan(
                  text: '${checkIn?.totalPoints ?? 0} = \$${((checkIn?.totalPoints ?? 0) / 100).toStringAsFixed(2)}',
                  style: const TextStyle(color: Color(0xFFF98E70)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Positioned(
                top: 20,
                left: 30,
                right: 30,
                child: Container(
                  height: 1,
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final day = index + 1;
                  int reward = (index + 2) * 10;
                  bool isChecked = false;
                  bool isToday = false;

                  if (checkIn != null) {
                    reward = checkIn.rewards?[day.toString()] ?? reward;
                    isChecked = (checkIn.currentDay ?? 0) >= day &&
                        (day != checkIn.currentDay || checkIn.checkedInToday == true);
                    isToday = checkIn.checkedInToday == true
                        ? (checkIn.currentDay == day)
                        : ((checkIn.currentDay ?? 0) + 1 == day);
                  } else {
                    isToday = index == 0;
                  }

                  int todayIndex = checkIn != null 
                      ? (checkIn.checkedInToday == true ? (checkIn.currentDay ?? 1) - 1 : (checkIn.currentDay ?? 0))
                      : 0;

                  String dateLabel;
                  if (isToday) {
                    dateLabel = 'Today';
                  } else {
                    DateTime date = DateTime.now().add(Duration(days: index - todayIndex));
                    dateLabel = DateFormat('MM-dd').format(date);
                  }

                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? const Color(0xFFF98E70)
                                  : (isToday ? const Color(0xFFFFE0E5) : const Color(0xFFF5F5F5)),
                              shape: BoxShape.circle,
                              border: isToday && !(checkIn?.checkedInToday ?? false)
                                  ? Border.all(color: const Color(0xFFF98E70), width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: isChecked
                                  ? const Icon(Icons.check, size: 20, color: Colors.white)
                                  : CustomText(
                                      text: '+$reward',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      textColor: isToday ? const Color(0xFFFF4D6D) : Colors.black87,
                                    ),
                            ),
                          ),
                          if (index == 2) // Mocking the $15 badge from screenshot
                            Positioned(
                              top: -12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF98E70).withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const CustomText(text: '\$15', fontSize: 8, textColor: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        text: dateLabel,
                        fontSize: 10,
                        textColor: isToday ? Colors.black : Colors.grey,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Rules', fontSize: 12, textColor: Colors.grey, isUnderline: true),
              Obx(() => CustomButton(
                    text: _profileController.isLoggedIn.value
                        ? ((checkIn?.checkedInToday ?? false) ? 'Checked In' : 'Check In')
                        : 'Log In',
                    width: 120,
                    height: 32,
                    buttonColor: (checkIn?.checkedInToday ?? false) ? const Color(0xFFCCCCCC) : AppColors.blackColor,
                    borderRadius: 2,
                    fontSize: 14,
                    onSubmit: () {
                      if (!_profileController.isLoggedIn.value) {
                        RouteNavigate().navigateToPush(context, const LoginScreen());
                      } else if (!(checkIn?.checkedInToday ?? false)) {
                        _profileController.performDailyCheckIn();
                      }
                    },
                  )),
              const SizedBox(width: 40), // Spacing to match screenshot
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpinWheelSection() {
    final List<String> labels = [
      "FREE GIFT",
      "100 R POINTS",
      "THANKS",
      "50 R POINTS",
      "FREE GIFT",
      "US\$3 OFF\nover US\$39",
      "100 R POINTS",
      "US\$12 OFF\nOVER US\$99",
    ];

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 320,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFDE8E8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(160)),
              ),
            ),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 330,
                      height: 330,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      child: FortuneWheel(
                        selected: _selected.stream,
                        animateFirst: false,
                        indicators: const [],
                        items: [
                          for (int i = 0; i < labels.length; i++)
                            FortuneItem(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 35),
                                child: Text(
                                  labels[i],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: i % 2 != 0 ? Colors.white : const Color(0xFFB91C1C),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              style: FortuneItemStyle(
                                color: i % 2 != 0 ? const Color(0xFFF98E70) : const Color(0xFFFEE2E2),
                                borderColor: Colors.white,
                                borderWidth: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (!_profileController.isLoggedIn.value) {
                          RouteNavigate().navigateToPush(context, const LoginScreen());
                          return;
                        }
                        if (_profileController.remainingSpins.value <= 0) {
                          CustomToast.showToast(message: 'Already used your free spin today!');
                          return;
                        }
                        await _profileController.useSpin();
                        _selected.add(Fortune.randomInt(0, labels.length));
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          RotatedBox(
                            quarterTurns: 2,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 80,
                                ),
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 70,
                                ),
                              ],
                            )
                          ),
                          Positioned(
                            bottom: 12,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration:  BoxDecoration(color: Colors.grey, shape: BoxShape.circle,

                              ),
                              alignment: Alignment.center,
                              child: const CustomText(text: 'SPIN', fontSize: 12, fontWeight: FontWeight.bold, textColor: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Obx(() => CustomText(
                      text: 'Number of Free Draws Remaining: ${_profileController.remainingSpins.value}',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFDE8E8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const CustomText(text: '50 Points/Per Spin', fontSize: 14, fontWeight: FontWeight.w500),
              Container(width: 1, height: 20, color: Colors.grey.shade300),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                  children: [
                    const TextSpan(text: 'Your Points: '),
                    TextSpan(
                      text: '${_profileController.checkInData.value?.totalPoints ?? 0}',
                      style: const TextStyle(color: Color(0xFFF98E70), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomButton(
                  text: 'Rules >',
                  buttonColor: const Color(0xFFF98E70),
                  borderRadius: 20,
                  height: 36,
                  fontSize: 13,
                  onSubmit: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: CustomButton(
                  text: 'My Winning Records >',
                  buttonColor: const Color(0xFFF98E70),
                  borderRadius: 20,
                  height: 36,
                  fontSize: 13,
                  onSubmit: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRedeemCouponHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              const CustomText(text: 'Redeem Coupon', fontSize: 18, fontWeight: FontWeight.bold),
              const SizedBox(width: 8),
              Icon(Icons.help_outline, size: 18, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFDE8E8)),
            ),
            child: Row(
              children: [
                const Icon(Icons.confirmation_num_outlined, size: 20, color: Colors.black87),
                const SizedBox(width: 10),
                const CustomText(text: 'My Coupons', fontSize: 14, fontWeight: FontWeight.w500),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponList() {
    final List<Map<String, dynamic>> coupons = [
      {'value': 'US\$2.00', 'condition': 'Over US\$0.00', 'expiry': '2026-09-17', 'left': 81, 'code': 'ROS2', 'points': 100},
      {'value': 'US\$5.00', 'condition': 'Over US\$49.00', 'expiry': '2026-10-17', 'left': 88, 'code': 'ROS5', 'points': 200},
      {'value': '15% OFF', 'condition': 'Over US\$79.00', 'expiry': '2026-11-16', 'left': 91, 'code': 'ROS15', 'points': 300},
      {'value': 'US\$20.00', 'condition': 'Over US\$109.00', 'expiry': '2026-08-17', 'left': 89, 'code': 'ROS20', 'points': 400},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        return _buildCouponCard(coupon);
      },
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Side cutouts
            Positioned(
              left: -10,
              top: 75,
              child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Color(0xFFF7F7F7), shape: BoxShape.circle)),
            ),
            Positioned(
              right: -10,
              top: 75,
              child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Color(0xFFF7F7F7), shape: BoxShape.circle)),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: coupon['value'], fontSize: 24, fontWeight: FontWeight.bold, textColor: const Color(0xFFF98E70)),
                            const SizedBox(height: 4),
                            CustomText(text: coupon['condition'], fontSize: 13, textColor: Colors.black87),
                            const SizedBox(height: 4),
                            CustomText(text: 'Expired: ${coupon['expiry']}', fontSize: 12, textColor: Colors.grey),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: coupon['left'] / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF98E70)),
                              strokeWidth: 5,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(text: '${coupon['left']}%', fontSize: 11, fontWeight: FontWeight.bold),
                                const CustomText(text: 'Left', fontSize: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: _DashLinePainter(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CustomText(text: 'Code: ${coupon['code']}', fontSize: 15, fontWeight: FontWeight.bold),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Color(0xFFFFD54F), shape: BoxShape.circle),
                            child: const CustomText(text: 'R', fontSize: 10, fontWeight: FontWeight.bold, textColor: Colors.white),
                          ),
                          const SizedBox(width: 6),
                          CustomText(text: '${coupon['points']}', fontSize: 16, fontWeight: FontWeight.bold, textColor: const Color(0xFFFFD54F)),
                        ],
                      ),
                      const SizedBox(width: 16),
                      CustomButton(
                        text: 'Redeem',
                        width: 80,
                        height: 30,
                        buttonColor: const Color(0xFFCCCCCC),
                        borderRadius: 2,
                        fontSize: 13,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        onSubmit: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    var max = size.width;
    var dashWidth = 5;
    var dashSpace = 3;
    double startX = 0;
    while (startX < max) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

