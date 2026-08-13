import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/country_selection_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String email;
  const CompleteProfileScreen({super.key, required this.email});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController(text: 'Privacy');
  final TextEditingController _birthdayController = TextEditingController(text: '0000-00-00');

  final List<String> _categories = ['Tops', 'Dresses', 'Swimwear', 'Jumpsuits', 'Plus Size'];
  final List<String> _styles = [
    'Basics', 'Casual', 'Elegant', 'Sexy', 'Vintage', 'Vacation', 'Party', 'wedding_guest'
  ];

  final Set<String> _selectedCategories = {};
  final Set<String> _selectedStyles = {};

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
        title: const CustomText(text: 'Complete Profile', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Email'),
            _buildReadOnlyField(widget.email),
            const SizedBox(height: 15),
            
            _buildLabel('Country *'),
            _buildCountryField(),
            const SizedBox(height: 15),

            _buildLabel('Gender *'),
            _buildGenderDropdown(),
            const SizedBox(height: 15),

            _buildLabel('Birthday *'),
            _buildTextField(_birthdayController, '0000-00-00'),
            const SizedBox(height: 25),

            _buildLabel('Favorite Categories *'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) => _buildChip(cat, _selectedCategories)).toList(),
            ),
            const SizedBox(height: 25),

            _buildLabel('Favorite Style *'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _styles.map((style) => _buildChip(style, _selectedStyles)).toList(),
            ),
            const SizedBox(height: 40),

            CustomButton(
              text: 'Confirm',
              buttonColor: AppColors.blackColor,
              textColor: AppColors.whiteColor,
              borderRadius: 0,
              height: 45,
              onSubmit: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCountryField() {
    return GestureDetector(
      onTap: _selectCountry,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: AbsorbPointer(
          child: TextField(
            controller: _countryController,
            decoration: const InputDecoration(
              hintText: 'Select Country',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ),
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
          initialValue: _genderController.text,
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

  Future<void> _selectCountry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountrySelectionScreen(currentCountry: _countryController.text),
      ),
    );
    if (result != null && result is String) {
      setState(() {
        _countryController.text = result;
      });
    }
  }

  Widget _buildChip(String label, Set<String> selectionSet) {
    bool isSelected = selectionSet.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectionSet.remove(label);
          } else {
            selectionSet.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomText(
          text: label,
          fontSize: 12,
          textColor: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
