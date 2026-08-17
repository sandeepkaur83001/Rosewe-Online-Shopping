import 'dart:io';

import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  FeedbackSuggestion? _selectedSuggestionType;
  FeedbackProblem? _selectedProblem;
  final TextEditingController _detailController = TextEditingController();
  final List<XFile> _selectedImages = [];

  List<FeedbackSuggestion> _suggestionTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFeedbackOptions();
  }

  Future<void> _fetchFeedbackOptions() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final response = await ApiImplementation.getFeedbackOptions(showLoader: false);
      if (response.statusCode == 200) {
        final optionsResponse = FeedbackOptionsResponse.fromJson(jsonDecode(response.body));
        if (!mounted) return;
        setState(() {
          _suggestionTypes = optionsResponse.data ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching feedback options: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _onImagePick() async {
    if (_selectedImages.length >= 5) {
      CustomToast.showToast(message: 'You can upload up to 5 images');
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.take(5 - _selectedImages.length));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  bool get _isSubmitEnabled {
    return _selectedSuggestionType != null && 
           _selectedProblem != null && 
           _detailController.text.trim().isNotEmpty;
  }

  void _handleSubmit() async {
    final dialog = Get.find<DialogService>();
    dialog.showLoader();

    try {
      final body = {
        'feedback_suggestion_id': _selectedSuggestionType!.id.toString(),
        'feedback_problem_id': _selectedProblem!.id.toString(),
        'other_problem': _selectedProblem!.isOther == true ? _detailController.text.trim() : '',
        'description': _detailController.text.trim(),
      };

      final files = _selectedImages.map((x) => File(x.path)).toList();

      final response = await ApiService.formPost(
        ApiEndpoints.feedbackStore, 
        body: body, 
        files: files,
        fileType: 'images[]',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showToast(message: 'Feedback submitted successfully');
        if (mounted) Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body);
        CustomToast.showToast(message: error['message'] ?? 'Failed to submit feedback');
      }
    } catch (e) {
      debugPrint("Error submitting feedback: $e");
      CustomToast.showToast(message: 'An error occurred while submitting');
    } finally {
      dialog.hideLoader();
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
        title: const CustomText(
          text: 'Feedback', 
          fontSize: 18, 
          fontWeight: FontWeight.bold,
          fontFamily: 'Humanist521',
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.whiteColor,
        child: CustomButton(
          text: 'SUBMIT',
          buttonColor: _isSubmitEnabled ? AppColors.blackColor : const Color(0xFFDCDCDC),
          textColor: AppColors.whiteColor,
          borderRadius: 0,
          height: 45,
          onSubmit: _isSubmitEnabled ? _handleSubmit : null,
        ),
      ),
      child: _isLoading 
          ? const Center(child: CircularDotLoader(label: ''))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: '1.You have suggestions for:',
              child: Column(
                children: _suggestionTypes.map((type) => RadioListTile<FeedbackSuggestion>(
                  title: CustomText(text: type.name ?? '', fontSize: 14, textColor: Colors.black87),
                  value: type,
                  groupValue: _selectedSuggestionType,
                  activeColor: Colors.black,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() {
                    _selectedSuggestionType = val;
                    _selectedProblem = null; // Reset question 2
                  }),
                )).toList(),
              ),
            ),
            const SizedBox(height: 15),

            _buildSection(
              title: '2.Which of the following problems have you met:',
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<FeedbackProblem>(
                    isExpanded: true,
                    hint: CustomText(
                      text: _selectedSuggestionType == null 
                          ? '*Please answer question 1 first' 
                          : 'Select a problem',
                      fontSize: 13,
                      textColor: _selectedSuggestionType == null ? Colors.red.shade300 : Colors.grey,
                    ),
                    value: _selectedProblem,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: _selectedSuggestionType == null ? null : (val) {
                      setState(() => _selectedProblem = val);
                    },
                    items: (_selectedSuggestionType?.problems ?? [])
                        .map((FeedbackProblem value) {
                      return DropdownMenuItem<FeedbackProblem>(
                        value: value,
                        child: CustomText(text: value.name ?? '', fontSize: 14),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildSection(
              title: '3.Describe your suggestion in detail:',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: _detailController,
                          maxLines: 6,
                          maxLength: 500,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Please describe your suggestion so we can work it as fast as we can.',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                            counterText: '',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            text: '${_detailController.text.length}/500',
                            fontSize: 12,
                            textColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const CustomText(
                    text: 'Upload an image will help with your description(Up to 5)',
                    fontSize: 13,
                    textColor: Colors.black54,
                  ),
                  const SizedBox(height: 10),
                  _buildImageUploadArea(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                TextSpan(
                  text: title, 
                  style: const TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildImageUploadArea() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...List.generate(_selectedImages.length, (index) {
          return Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_selectedImages[index].path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
        if (_selectedImages.length < 5)
          GestureDetector(
            onTap: _onImagePick,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red.shade100, width: 1),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFFFF9F9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   "assets/images/rosewe_logo_clean.png", // Just a placeholder, or use a specific icon if available
                  //   height: 30,
                  //   color: Colors.red.shade200,
                  // ),
                  const SizedBox(height: 8),
                  const Icon(Icons.add_a_photo_outlined, color: Colors.redAccent, size: 32),
                  const SizedBox(height: 4),
                  const CustomText(text: 'Upload Image', fontSize: 10, textColor: Colors.redAccent),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
