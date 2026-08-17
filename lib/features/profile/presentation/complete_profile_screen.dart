import 'package:get/get.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/profile/data/repository/profile_repository.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String email;
  const CompleteProfileScreen({super.key, required this.email});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final ProfileController _controller = Get.find<ProfileController>();
  final ProfileRepository _repository = ProfileRepository();
  
  ProfileCountryData? _selectedCountry;
  final TextEditingController _genderController = TextEditingController(text: 'Privacy');
  final TextEditingController _birthdayController = TextEditingController(text: '0000-00-00');

  final Set<int> _selectedCategories = {};
  final Set<int> _selectedStyles = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final profile = _controller.userProfile.value;
    if (profile != null) {
      if (profile.countryId != null) {
        _selectedCountry = _controller.countries.firstWhereOrNull((c) => c.id == profile.countryId);
      }
      if (profile.gender != null) {
        _genderController.text = profile.gender!.capitalizeFirst ?? 'Privacy';
      }
      if (profile.birthday != null) {
        _birthdayController.text = profile.birthday!;
      }
      if (profile.favoriteCategoryIds != null) {
        _selectedCategories.addAll(profile.favoriteCategoryIds!);
      }
      if (profile.favoriteStyleIds != null) {
        _selectedStyles.addAll(profile.favoriteStyleIds!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(text: 'Profile Information', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularDotLoader(label: ''));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Email'),
              _buildReadOnlyField(widget.email),
              const SizedBox(height: 15),

              _buildLabel('Country *'),
              _buildCountryDropdown(),
              const SizedBox(height: 15),

              _buildLabel('Gender *'),
              _buildGenderDropdown(),
              const SizedBox(height: 15),

              _buildLabel('Birthday *'),
              _buildDateField(),
              const SizedBox(height: 25),

              _buildLabel('Favorite Categories *'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _controller.categories.map((cat) => _buildChip(cat.name ?? '', cat.id ?? -1, _selectedCategories)).toList(),
              ),
              const SizedBox(height: 25),

              _buildLabel('Favorite Style *'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _controller.styles.map((style) => _buildChip(style.name ?? '', style.id ?? -1, _selectedStyles)).toList(),
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: 'Confirm',
                buttonColor: AppColors.blackColor,
                textColor: AppColors.whiteColor,
                borderRadius: 0,
                height: 45,
                onSubmit: _handleUpdateProfile,
              ),
            ],
          ),
        );
      }),
    );
  }

  void _handleUpdateProfile() async {
    if (_selectedCountry == null) {
      CustomToast.showToast(message: 'Please select a country');
      return;
    }

    final dialog = Get.find<DialogService>();
    dialog.showLoader();

    try {
      final body = {
        'country_id': _selectedCountry!.id,
        'currency_id': _controller.currencies.isNotEmpty ? _controller.currencies.first.id : 1,
        'gender': _genderController.text.toLowerCase(),
        'birthday': _birthdayController.text,
        'category_ids': _selectedCategories.toList(),
        'style_ids': _selectedStyles.toList(),
      };

      final success = await _repository.updateProfile(body, showLoader: true);
      if (success) {
        CustomToast.showToast(message: 'Profile updated successfully');
        await _controller.fetchProfile(showLoader: false);
        if (mounted) Navigator.pop(context);
      } else {
        CustomToast.showToast(message: 'Failed to update profile');
      }
    } finally {
      dialog.hideLoader();
    }
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomText(text: label, fontSize: 14, textColor: Colors.black87),
    );
  }

  Widget _buildReadOnlyField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: CustomText(text: text, fontSize: 14, textColor: Colors.black54),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: _birthdayController.text.isEmpty ? 'YYYY-MM-DD' : _birthdayController.text,
              fontSize: 14,
              textColor: _birthdayController.text.isEmpty ? Colors.grey : Colors.black87,
            ),
            const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
    
    // Try to parse existing date if valid
    if (_birthdayController.text.isNotEmpty && _birthdayController.text != '0000-00-00') {
      try {
        initialDate = DateTime.parse(_birthdayController.text);
      } catch (e) {
        // use default
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _birthdayController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Widget _buildCountryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProfileCountryData>(
          value: _selectedCountry,
          isExpanded: true,
          hint: const CustomText(text: 'Select Country', fontSize: 14),
          items: _controller.countries.map((country) {
            return DropdownMenuItem<ProfileCountryData>(
              value: country,
              child: CustomText(text: country.name ?? '', fontSize: 14),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _genderController.text,
          items: ['Privacy', 'Male', 'Female'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CustomText(text: value, fontSize: 14),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _genderController.text = newValue;
              });
            }
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildChip(String label, int id, Set<int> selectionSet) {
    bool isSelected = selectionSet.contains(id);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectionSet.remove(id);
          } else {
            selectionSet.add(id);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomText(
          text: label,
          fontSize: 12,
          textColor: isSelected ? Color(0xffE24D54): Colors.black87,
        ),
      ),
    );
  }
}
