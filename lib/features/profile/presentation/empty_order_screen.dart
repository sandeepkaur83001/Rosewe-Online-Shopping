import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/new_address_screen.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  List<AddressData> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiImplementation.getAddresses();
      if (response.statusCode == 200) {
        final addressResponse = AddressResponse.fromJson(jsonDecode(response.body));
        setState(() {
          _addresses = addressResponse.data ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching addresses: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(text: 'Address Book', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(
          text: 'ADD NEW ADDRESS',
          buttonColor: AppColors.blackColor,
          textColor: AppColors.whiteColor,
          borderRadius: 0,
          height: 50,
          onSubmit: () async {
            final result = await RouteNavigate().navigateToPush(context, const NewAddressScreen());
            if (result == true) {
              _fetchAddresses();
            }
          },
        ),
      ),
      child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : _addresses.isEmpty
              ? const Center(
                  child: EmptyStateWidget(
                    title: 'No Addresses Found',
                    message: 'You haven\'t added any shipping addresses yet.',
                    icon: Icons.location_on_outlined, 
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _addresses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final addr = _addresses[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: '${addr.firstName} ${addr.lastName}',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              if (addr.isDefault == 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const CustomText(
                                    text: 'DEFAULT',
                                    fontSize: 10,
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomText(text: addr.phone ?? '', fontSize: 14, textColor: Colors.black87),
                          const SizedBox(height: 4),
                          CustomText(
                            text: '${addr.addressLine1}${addr.addressLine2 != null ? ', ${addr.addressLine2}' : ''}',
                            fontSize: 14,
                            textColor: Colors.black54,
                          ),
                          CustomText(
                            text: '${addr.city}, ${addr.stateName ?? ''} ${addr.postalCode}, ${addr.countryName ?? ''}',
                            fontSize: 14,
                            textColor: Colors.black54,
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _showDeleteConfirmation(addr),
                                child: const CustomText(text: 'Delete', fontSize: 14, textColor: Colors.red),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () async {
                                  final result = await RouteNavigate().navigateToPush(
                                    context, 
                                    NewAddressScreen(address: addr),
                                  );
                                  if (result == true) {
                                    _fetchAddresses();
                                  }
                                },
                                child: const CustomText(text: 'Edit', fontSize: 14, textColor: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _showDeleteConfirmation(AddressData address) {
    DialogService().showConfirmationDialog(
      title: 'Delete Address',
      message: 'Are you sure you want to delete this address?',
      confirmText: 'DELETE',
      onConfirm: () => _handleDeleteAddress(address.id.toString()),
    );
  }

  Future<void> _handleDeleteAddress(String addressId) async {
    try {
      final response = await ApiImplementation.deleteAddress(addressId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showToast(message: 'Address deleted successfully');
        _fetchAddresses();
      } else {
        final error = jsonDecode(response.body);
        CustomToast.showToast(message: error['message'] ?? 'Failed to delete address');
      }
    } catch (e) {
      debugPrint("Error deleting address: $e");
      CustomToast.showToast(message: 'An error occurred while deleting');
    }
  }
}
