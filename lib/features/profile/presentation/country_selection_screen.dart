import 'package:rosewe_online_shopping/core/common_imports.dart';

class CountrySelectionScreen extends StatefulWidget {
  final String currentCountry;
  const CountrySelectionScreen({super.key, required this.currentCountry});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Map<String, List<String>> _allCountries = {
    'A': [
      'Afghanistan',
      'Albania',
      'Algeria',
      'Andorra',
      'Angola',
      'Antigua and Barbuda',
      'Argentina',
      'Armenia',
      'Australia',
      'Austria',
      'Azerbaijan',
    ],
    'B': [
      'Bahamas',
      'Bahrain',
      'Bangladesh',
      'Barbados',
      'Belarus',
      'Belgium',
      'Belize',
      'Benin',
      'Bhutan',
      'Bolivia',
      'Bosnia and Herzegovina',
      'Botswana',
      'Brazil',
      'Brunei',
      'Bulgaria',
      'Burkina Faso',
      'Burundi',
    ],
    'C': [
      'Cabo Verde',
      'Cambodia',
      'Cameroon',
      'Canada',
      'Central African Republic',
      'Chad',
      'Chile',
      'China',
      'Colombia',
      'Comoros',
      'Congo',
      'Costa Rica',
      'Croatia',
      'Cuba',
      'Cyprus',
      'Czechia',
    ],
    'D': [
      'Democratic Republic of the Congo',
      'Denmark',
      'Djibouti',
      'Dominica',
      'Dominican Republic',
    ],
    'E': [
      'Ecuador',
      'Egypt',
      'El Salvador',
      'Equatorial Guinea',
      'Eritrea',
      'Estonia',
      'Eswatini',
      'Ethiopia',
    ],
    'F': [
      'Fiji',
      'Finland',
      'France',
    ],
    'G': [
      'Gabon',
      'Gambia',
      'Georgia',
      'Germany',
      'Ghana',
      'Greece',
      'Grenada',
      'Guatemala',
      'Guinea',
      'Guinea-Bissau',
      'Guyana',
    ],
    'H': [
      'Haiti',
      'Honduras',
      'Hungary',
    ],
    'I': [
      'Iceland',
      'India',
      'Indonesia',
      'Iran',
      'Iraq',
      'Ireland',
      'Israel',
      'Italy',
      'Ivory Coast',
    ],
    'J': [
      'Jamaica',
      'Japan',
      'Jordan',
    ],
    'K': [
      'Kazakhstan',
      'Kenya',
      'Kiribati',
      'Kuwait',
      'Kyrgyzstan',
    ],
    'L': [
      'Laos',
      'Latvia',
      'Lebanon',
      'Lesotho',
      'Liberia',
      'Libya',
      'Liechtenstein',
      'Lithuania',
      'Luxembourg',
    ],
    'M': [
      'Madagascar',
      'Malawi',
      'Malaysia',
      'Maldives',
      'Mali',
      'Malta',
      'Marshall Islands',
      'Mauritania',
      'Mauritius',
      'Mexico',
      'Micronesia',
      'Moldova',
      'Monaco',
      'Mongolia',
      'Montenegro',
      'Morocco',
      'Mozambique',
      'Myanmar',
    ],
    'N': [
      'Namibia',
      'Nauru',
      'Nepal',
      'Netherlands',
      'New Zealand',
      'Nicaragua',
      'Niger',
      'Nigeria',
      'North Korea',
      'North Macedonia',
      'Norway',
    ],
    'O': [
      'Oman',
    ],
    'P': [
      'Pakistan',
      'Palau',
      'Palestine',
      'Panama',
      'Papua New Guinea',
      'Paraguay',
      'Peru',
      'Philippines',
      'Poland',
      'Portugal',
    ],
    'Q': [
      'Qatar',
    ],
    'R': [
      'Romania',
      'Russia',
      'Rwanda',
    ],
    'S': [
      'Saint Kitts and Nevis',
      'Saint Lucia',
      'Saint Vincent and the Grenadines',
      'Samoa',
      'San Marino',
      'Sao Tome and Principe',
      'Saudi Arabia',
      'Senegal',
      'Serbia',
      'Seychelles',
      'Sierra Leone',
      'Singapore',
      'Slovakia',
      'Slovenia',
      'Solomon Islands',
      'Somalia',
      'South Africa',
      'South Korea',
      'South Sudan',
      'Spain',
      'Sri Lanka',
      'Sudan',
      'Suriname',
      'Sweden',
      'Switzerland',
      'Syria',
    ],
    'T': [
      'Taiwan',
      'Tajikistan',
      'Tanzania',
      'Thailand',
      'Timor-Leste',
      'Togo',
      'Tonga',
      'Trinidad and Tobago',
      'Tunisia',
      'Turkey',
      'Turkmenistan',
      'Tuvalu',
    ],
    'U': [
      'Uganda',
      'Ukraine',
      'United Arab Emirates',
      'United Kingdom',
      'United States',
      'Uruguay',
      'Uzbekistan',
    ],
    'V': [
      'Vanuatu',
      'Vatican City',
      'Venezuela',
      'Vietnam',
    ],
    'W': [
      'Yemen',
    ],
    'X': [],
    'Y': [
      'Yemen',
    ],
    'Z': [
      'Zambia',
      'Zimbabwe',
    ],
  };

  late Map<String, List<String>> _filteredCountries;
  final List<String> _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#'.split('');

  @override
  void initState() {
    super.initState();
    _filteredCountries = Map.from(_allCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = Map.from(_allCountries);
      } else {
        _filteredCountries = {};
        _allCountries.forEach((key, list) {
          final filteredList = list.where((country) => 
            country.toLowerCase().contains(query.toLowerCase())).toList();
          if (filteredList.isNotEmpty) {
            _filteredCountries[key] = filteredList;
          }
        });
      }
    });
  }

  void _scrollToLetter(String letter) {
    if (!_filteredCountries.containsKey(letter) || _filteredCountries[letter]!.isEmpty) return;

    int sectionIndex = _filteredCountries.keys.toList().indexOf(letter);
    if (sectionIndex == -1) return;

    double offset = 0;
    for (int i = 0; i < sectionIndex; i++) {
      String key = _filteredCountries.keys.elementAt(i);
      // Header height: 35
      offset += 35;
      // ListTile height: 40 + Divider height: 1
      offset += (_filteredCountries[key]!.length * 40) + (_filteredCountries[key]!.length - 1);
    }

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onAlphabetGesture(Offset localPosition, double totalHeight) {
    final double itemHeight = totalHeight / _alphabet.length;
    final int index = (localPosition.dy / itemHeight).floor().clamp(0, _alphabet.length - 1);
    final String letter = _alphabet[index];
    _scrollToLetter(letter);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        centerTitle: true,
        title: const CustomText(
          text: 'Country/Region',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Country/Region',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset("assets/images/search_icon.png",),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              // Current Selection
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    Image.asset("assets/images/location_icon.png",height: 24,),
                    const SizedBox(width: 8),
                    CustomText(
                      text: widget.currentCountry,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              // Country List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredCountries.length,
                  itemBuilder: (context, index) {
                    String key = _filteredCountries.keys.elementAt(index);
                    List<String> countriesList = _filteredCountries[key]!;
                    if (countriesList.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Colors.grey[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: key,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              if (index == 0)
                                const CustomText(
                                  text: '#',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.black54,
                                ),
                            ],
                          ),
                        ),
                        // Countries
                        ...countriesList.asMap().entries.map((entry) {
                          int countryIndex = entry.key;
                          String country = entry.value;
                          return Column(
                            children: [
                              SizedBox(
                                height: 40,
                                child: ListTile(
                                  onTap: () => Navigator.pop(context, country),
                                  title: CustomText(text: country, fontSize: 14),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  dense: true,
                                ),
                              ),
                              if (countryIndex < countriesList.length - 1)
                                Divider(height: 1, thickness: 0.5,color: Colors.grey),
                            ],
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          // Alphabet Index on right
          if (_searchController.text.isEmpty)
            Positioned(
              right: 0,
              top: 100,
              bottom: 40,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double totalHeight = constraints.maxHeight;
                  return GestureDetector(
                    onVerticalDragUpdate: (details) => _onAlphabetGesture(details.localPosition, totalHeight),
                    onTapDown: (details) => _onAlphabetGesture(details.localPosition, totalHeight),
                    child: Container(
                      width: 30,
                      color: Colors.transparent, // Expand hit test area
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _alphabet.map((char) => Expanded(
                          child: Center(
                            child: CustomText(
                              text: char, 
                              fontSize: 12,
                              textColor: Colors.grey,
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  );
                }
              ),
            ),
        ],
      ),
    );
  }
}
