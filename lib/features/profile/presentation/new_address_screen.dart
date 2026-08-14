import 'package:get/get.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';

class NewAddressScreen extends StatefulWidget {
  final AddressData? address;
  const NewAddressScreen({super.key, this.address});

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  ProfileCountryData? _selectedCountry;
  StateData? _selectedState;
  List<StateData> _states = [];
  bool _isStatesLoading = false;

  // Track errors for each field
  final Map<String, bool> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _emailController.text = widget.address!.email ?? '';
      _firstNameController.text = widget.address!.firstName ?? '';
      _lastNameController.text = widget.address!.lastName ?? '';
      _address1Controller.text = widget.address!.addressLine1 ?? '';
      _address2Controller.text = widget.address!.addressLine2 ?? '';
      _cityController.text = widget.address!.city ?? '';
      _zipController.text = widget.address!.postalCode ?? '';
      _phoneController.text = widget.address!.phone ?? '';
      
      if (widget.address!.countryId != null) {
        _selectedCountry = _profileController.countries.firstWhereOrNull((c) => c.id == widget.address!.countryId);
        if (_selectedCountry != null) {
          _fetchStates(_selectedCountry!.id.toString());
        }
      }
    } else {
      _emailController.text = _profileController.userProfile.value?.email ?? '';
      if (_profileController.countries.isNotEmpty) {
        _selectedCountry = _profileController.countries.firstWhereOrNull((c) => c.name?.toLowerCase() == 'united states') ?? _profileController.countries.first;
        _fetchStates(_selectedCountry!.id.toString());
      }
    }
  }

  Future<void> _fetchStates(String countryId) async {
    setState(() {
      _isStatesLoading = true;
      _selectedState = null;
      _states = [];
    });

    try {
      final response = await ApiImplementation.getStates(countryId, showLoader: false);
      if (response.statusCode == 200) {
        final stateResponse = StateResponse.fromJson(jsonDecode(response.body));
        setState(() {
          _states = stateResponse.data ?? [];
          if (widget.address != null && widget.address!.stateId != null) {
            _selectedState = _states.firstWhereOrNull((s) => s.id == widget.address!.stateId);
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching states: $e");
    } finally {
      setState(() {
        _isStatesLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateField(String key, dynamic value) {
    setState(() {
      if (value is String) {
        _fieldErrors[key] = value.trim().isEmpty;
      } else {
        _fieldErrors[key] = value == null;
      }
    });
  }

  void _handleSave() async {
    // Perform full validation
    _validateField('email', _emailController.text);
    _validateField('firstName', _firstNameController.text);
    _validateField('lastName', _lastNameController.text);
    _validateField('address1', _address1Controller.text);
    _validateField('city', _cityController.text);
    _validateField('country', _selectedCountry);
    _validateField('zip', _zipController.text);
    _validateField('phone', _phoneController.text);
    
    if (_states.isNotEmpty) {
      _validateField('state', _selectedState);
    }

    if (_fieldErrors.values.any((error) => error)) {
      CustomToast.showToast(message: 'Please fill all required fields highlighted in red');
      return;
    }

    final body = {
      'type': 'home',
      'email': _emailController.text,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'phone': _phoneController.text,
      'address_line_1': _address1Controller.text,
      'address_line_2': _address2Controller.text,
      'city': _cityController.text,
      'state_id': _selectedState?.id?.toString() ?? '',
      'country_id': _selectedCountry!.id.toString(),
      'postal_code': _zipController.text,
      'is_default': widget.address?.isDefault?.toString() ?? '1',
    };

    final response = widget.address == null 
        ? await ApiImplementation.addAddress(body)
        : await ApiImplementation.updateAddress(widget.address!.id.toString(), body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      CustomToast.showToast(message: widget.address == null ? 'Address added successfully' : 'Address updated successfully');
      if (mounted) Navigator.pop(context, true);
    } else {
      final error = jsonDecode(response.body);
      CustomToast.showToast(message: error['message'] ?? 'Failed to save address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        centerTitle: true,
        title: CustomText(
          text: widget.address == null ? 'New Address' : 'Edit Address', 
          fontSize: 18, 
          fontWeight: FontWeight.bold
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(
          text: 'SAVE',
          buttonColor: AppColors.blackColor,
          textColor: AppColors.whiteColor,
          borderRadius: 0,
          height: 50,
          onSubmit: _handleSave,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(text: 'Contact Information', fontSize: 16, fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            _buildInputField(
              label: 'Enter valid email to receive order information',
              controller: _emailController,
              hint: 'Email',
              errorKey: 'email',
            ),
            const SizedBox(height: 25),
            const CustomText(text: 'Shipping Address', fontSize: 16, fontWeight: FontWeight.bold),
            const SizedBox(height: 15),
            _buildInputField(controller: _firstNameController, hint: 'First Name', errorKey: 'firstName'),
            const SizedBox(height: 15),
            _buildInputField(controller: _lastNameController, hint: 'Last Name', errorKey: 'lastName'),
            const SizedBox(height: 15),
            _buildInputField(controller: _address1Controller, hint: 'Address', errorKey: 'address1'),
            const SizedBox(height: 15),
            _buildInputField(controller: _address2Controller, hint: 'Apartment, suite, etc.(optional)'),
            const SizedBox(height: 15),
            _buildInputField(controller: _cityController, hint: 'City', errorKey: 'city'),
            const SizedBox(height: 15),
            _buildCountryDropdown(),
            const SizedBox(height: 15),
            _buildStateDropdown(),
            const SizedBox(height: 15),
            _buildInputField(controller: _zipController, hint: 'Zip Code', errorKey: 'zip'),
            const SizedBox(height: 15),
            _buildInputField(controller: _phoneController, hint: 'Phone', errorKey: 'phone'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({String? label, required TextEditingController controller, required String hint, String? errorKey}) {
    final hasError = errorKey != null && (_fieldErrors[errorKey] ?? false);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          CustomText(text: label, fontSize: 12, textColor: Colors.black87),
          const SizedBox(height: 5),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: hasError ? Colors.red : Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            onChanged: (val) {
              if (errorKey != null && (_fieldErrors[errorKey] ?? false)) {
                setState(() => _fieldErrors[errorKey] = val.trim().isEmpty);
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    final hasError = _fieldErrors['country'] ?? false;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(text: 'Country/Region', fontSize: 12, textColor: Colors.black87),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: hasError ? Colors.red : Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ProfileCountryData>(
              value: _selectedCountry,
              isExpanded: true,
              hint: const CustomText(text: 'Select Country', fontSize: 14),
              items: _profileController.countries.map((country) {
                return DropdownMenuItem<ProfileCountryData>(
                  value: country,
                  child: CustomText(text: country.name ?? '', fontSize: 14),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCountry = value;
                    _fieldErrors['country'] = false;
                  });
                  _fetchStates(value.id.toString());
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    final hasError = _fieldErrors['state'] ?? false;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(text: 'State', fontSize: 12, textColor: Colors.black87),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: hasError ? Colors.red : Colors.grey.shade300),
          ),
          child: _isStatesLoading 
              ? const SizedBox(height: 48, child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))))
              : DropdownButtonHideUnderline(
                  child: DropdownButton<StateData>(
                    value: _selectedState,
                    isExpanded: true,
                    hint: CustomText(text: _states.isEmpty ? 'No states available' : 'Select State', fontSize: 14),
                    items: _states.map((state) {
                      return DropdownMenuItem<StateData>(
                        value: state,
                        child: CustomText(text: state.name ?? '', fontSize: 14),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedState = value;
                        _fieldErrors['state'] = false;
                      });
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
