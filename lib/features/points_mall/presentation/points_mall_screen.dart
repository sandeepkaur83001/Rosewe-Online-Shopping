import 'package:flutter/gestures.dart';
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
    );
  }

  Widget _buildDailyCheckInCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final isToday = index == 0;
              final points = 20 + (index * 10);
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isToday ? const Color(0xFFFFDAB9).withValues(alpha: 0.3) : const Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomText(
                            text: '+$points',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.black87,
                          ),
                        ),
                      ),
                      if (isToday)
                        const Positioned(
                          top: -5,
                          child: Icon(Icons.workspace_premium, size: 16, color: Colors.orange),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: isToday ? 'Today' : '08-${18 + index}',
                    fontSize: 10,
                    textColor: Colors.grey,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Rules', fontSize: 12, textColor: Colors.grey, isUnderline: true),
              CustomButton(
                text: 'Log In',
                width: 100,
                height: 36,
                buttonColor: AppColors.blackColor,
                borderRadius: 4,
                onSubmit: () => RouteNavigate().navigateToPush(context, const LoginScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpinWheelSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
              child: const CustomText(text: 'Rules', fontSize: 12, textColor: Colors.black54),
            ),
          ),
          const SizedBox(height: 20),
          // Simple Wheel Placeholder
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.pink.shade100, width: 8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF1F1), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: CustomPaint(
                  painter: _WheelPainter(),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Center(
                  child: CustomText(text: 'SPIN', fontWeight: FontWeight.bold, textColor: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: 'Login',
                  style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => RouteNavigate().navigateToPush(context, const LoginScreen()),
                ),
                const TextSpan(text: ' to spin the Wheel!'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemCouponHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const CustomText(text: 'Redeem Coupon', fontSize: 18, fontWeight: FontWeight.bold),
          const SizedBox(width: 8),
          Icon(Icons.help_outline, size: 18, color: Colors.grey.shade400),
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.pink.shade50),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: coupon['value'], fontSize: 22, fontWeight: FontWeight.bold, textColor: Colors.deepOrangeAccent),
                      CustomText(text: coupon['condition'], fontSize: 12, textColor: Colors.black87),
                      const SizedBox(height: 4),
                      CustomText(text: 'Expired: ${coupon['expiry']}', fontSize: 11, textColor: Colors.grey),
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
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                        strokeWidth: 5,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(text: '${coupon['left']}%', fontSize: 10, fontWeight: FontWeight.bold),
                          const CustomText(text: 'Left', fontSize: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
           Divider(height: 1,color: Colors.grey.withAlpha(10),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CustomText(text: 'Code: ${coupon['code']}', fontSize: 14, fontWeight: FontWeight.bold),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const CustomText(text: 'R', fontSize: 10, fontWeight: FontWeight.bold, textColor: Colors.orange),
                    ),
                    const SizedBox(width: 4),
                    CustomText(text: '${coupon['points']}', fontSize: 14, fontWeight: FontWeight.bold, textColor: Colors.orange),
                  ],
                ),
                const SizedBox(width: 15),
                CustomButton(
                  text: 'Redeem',
                  width: 90,
                  height: 32,
                  buttonColor: AppColors.blackColor,
                  borderRadius: 4,
                  fontSize: 12,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  onSubmit: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final colors = [
      const Color(0xFFFDE8E8),
      const Color(0xFFF9CACA),
      const Color(0xFFFDE8E8),
      const Color(0xFFF9CACA),
      const Color(0xFFFDE8E8),
      const Color(0xFFF9CACA),
      const Color(0xFFFDE8E8),
      const Color(0xFFF9CACA),
    ];

    final double angle = (2 * pi) / 8;

    for (int i = 0; i < 8; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(rect, i * angle, angle, true, paint);
    }

    // Add some text-like lines for segments
    final linePaint = Paint()..color = Colors.deepOrangeAccent.withValues(alpha: 0.3)..strokeWidth = 1;
    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * angle + angle / 2);
      canvas.drawLine(Offset(radius * 0.4, 0), Offset(radius * 0.8, 0), linePaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
