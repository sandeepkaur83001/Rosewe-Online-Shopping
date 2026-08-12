import 'package:rosewe_online_shopping/core/common_imports.dart';

class CurrencySelectionScreen extends StatefulWidget {
  final String currentCurrency;
  const CurrencySelectionScreen({super.key, required this.currentCurrency});

  @override
  State<CurrencySelectionScreen> createState() => _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  late String _selectedCurrency;

  final List<String> _currencies = [
    'USD', 'EUR', 'GBP', 'CAD', 'AUD', 'CHF', 'HKD', 'JPY', 'RUB', 'BRL',
    'CLP', 'NOK', 'DKK', 'SEK', 'KRW', 'ILS', 'HUF', 'NZD', 'MXN', 'AED', 'ZAR'
  ];

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.currentCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        centerTitle: true,
        title: const CustomText(
          text: 'Currency',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: ListView.separated(
        itemCount: _currencies.length,
        separatorBuilder: (context, index) =>  Divider(height: 1, indent: 16,color: Colors.grey.withAlpha(50),),
        itemBuilder: (context, index) {
          final currency = _currencies[index];
          final isSelected = currency == _selectedCurrency;
          return ListTile(
            onTap: () {
              setState(() {
                _selectedCurrency = currency;
              });
              // Return selected currency to previous screen after a small delay
              Future.delayed(const Duration(milliseconds: 200), () {
                if (mounted) Navigator.pop(context, _selectedCurrency);
              });
            },
            title: CustomText(
              text: currency,
              fontSize: 14,
              textColor: Colors.black87,
            ),
            trailing: isSelected 
                ? const Icon(Icons.check, color: Colors.orange, size: 20)
                : null,
          );
        },
      ),
    );
  }
}
