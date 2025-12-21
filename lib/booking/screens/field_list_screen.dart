import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/screens/field_detail_screen.dart';
import 'package:playserve_mobile/booking/screens/my_bookings_screen.dart';
import 'package:playserve_mobile/booking/widgets/booking_field_card.dart';
import 'package:playserve_mobile/main_navbar.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/booking/theme.dart';
import '../services/booking_service.dart';
import '../config.dart';

class FieldListScreen extends StatefulWidget {
  const FieldListScreen({super.key});

  @override
  State<FieldListScreen> createState() => _FieldListScreenState();
}

class _FieldListScreenState extends State<FieldListScreen> {
  // Filter and search state
  String _searchQuery = '';
  String? _selectedCity;
  double? _priceMin;
  double? _priceMax;
  bool _hasLights = false;
  bool _hasBackboard = false;
  String _sortOption = 'default'; // default, price_low, price_high, name
  int _totalItems = 0;

  // Pagination state
  List<PlayingField> _fields = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasNextPage = true;
  final int _pageSize = 20;

  final List<String> _cities = [
    'Jakarta',
    'Bogor',
    'Depok',
    'Tangerang',
    'Bekasi',
  ];

  @override
  void initState() {
    super.initState();
    _loadFields(reset: true);
  }

  Future<void> _loadFields({bool reset = false}) async {
    if (reset) {
      setState(() {
        _currentPage = 1;
        _fields = [];
        _hasNextPage = true;
        _isLoading = true;
        _error = null;
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final request = context.read<CookieRequest>();
      final service = BookingService(request, baseUrl: kBaseUrl);

      final response = await service.fetchFieldsPaginated(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        city: _selectedCity,
        priceMin: _priceMin,
        priceMax: _priceMax,
        hasLights: _hasLights,
        hasBackboard: _hasBackboard,
        sort: _sortOption != 'default' ? _sortOption : null,
        page: reset ? 1 : _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        if (reset) {
          _fields = response.fields;
        } else {
          _fields.addAll(response.fields);
        }
        _currentPage = response.currentPage;
        _hasNextPage = response.hasNext;
        _totalItems = response.totalItems;
        _isLoading = false;
        _isLoadingMore = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _error = e.toString();
      });
    }
  }

  void _onFiltersChanged() {
    _loadFields(reset: true);
  }

  // void _resetFilters() {
  //   setState(() {
  //     _searchQuery = '';
  //     _selectedCity = null;
  //     _priceMin = null;
  //     _priceMax = null;
  //     _hasLights = false;
  //     _hasBackboard = false;
  //     _sortOption = 'default';
  //   });
  //   _loadFields(reset: true);
  // }

  Future<void> _loadMore() async {
    if (!_hasNextPage || _isLoadingMore) return;

    _currentPage++;
    await _loadFields(reset: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookingBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BookingDecorations.panel,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Find Your',
                                    style: BookingTextStyles.display,
                                  ),
                                  Text(
                                    'Perfect Court',
                                    style: BookingTextStyles.display.copyWith(
                                      color: BookingColors.lime,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: BookingDecorations.primaryButton,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MyBookingsScreen(),
                                  ),
                                ),
                                child: const Text('My Bookings'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Search and Filter UI
                          _buildFilters(),

                          const SizedBox(height: 16),

                          // Result Count
                          if (!_isLoading && _error == null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '$_totalItems courts found',
                                style: BookingTextStyles.body.copyWith(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Content
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: BookingColors.lime,
                                ),
                              ),
                            )
                          else if (_error != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Column(
                                children: [
                                  Text(
                                    'Error: $_error',
                                    style: BookingTextStyles.bodyLight,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => _loadFields(reset: true),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          else if (_fields.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                'No courts available.',
                                style: BookingTextStyles.bodyLight,
                              ),
                            )
                          else
                            Column(
                              children: [
                                _buildGrid(context, _fields),
                                if (_isLoadingMore)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: CircularProgressIndicator(
                                      color: BookingColors.lime,
                                    ),
                                  )
                                else if (_hasNextPage)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _loadMore,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: BookingColors.lime,
                                        foregroundColor: Colors.black,
                                      ),
                                      child: const Text('Load More Courts'),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Text(
                                      'No more courts to load',
                                      style: BookingTextStyles.bodyLight,
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const MainNavbar(currentIndex: 3),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        // Search bar
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search courts...",
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.15),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
            _onFiltersChanged();
          },
        ),

        const SizedBox(height: 16),

        // Filter row
        Row(
          children: [
            // City dropdown
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedCity,
                  dropdownColor: BookingColors.panel,
                  underline: const SizedBox(),
                  hint: const Text(
                    'City',
                    style: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Cities'),
                    ),
                    ..._cities.map(
                      (city) =>
                          DropdownMenuItem(value: city, child: Text(city)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCity = value);
                    _onFiltersChanged();
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Sort dropdown
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _sortOption,
                  dropdownColor: BookingColors.panel,
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(
                      value: 'default',
                      child: Text('Recommended'),
                    ),
                    DropdownMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                    DropdownMenuItem(value: 'name', child: Text('Name: A-Z')),
                  ],
                  onChanged: (value) {
                    setState(() => _sortOption = value!);
                    _onFiltersChanged();
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Feature checkboxes
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text(
                  'Lights',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                value: _hasLights,
                onChanged: (value) {
                  setState(() => _hasLights = value ?? false);
                  _onFiltersChanged();
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: BookingColors.lime,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text(
                  'Backboard',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                value: _hasBackboard,
                onChanged: (value) {
                  setState(() => _hasBackboard = value ?? false);
                  _onFiltersChanged();
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: BookingColors.lime,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Reset filters button
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton(
        //     onPressed: _resetFilters,
        //     style: OutlinedButton.styleFrom(
        //       side: const BorderSide(color: BookingColors.lime),
        //       foregroundColor: BookingColors.lime,
        //       padding: const EdgeInsets.symmetric(vertical: 12),
        //     ),
        //     child: const Text('Clear All Filters'),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<PlayingField> fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        }
        return GridView.builder(
          padding: const EdgeInsets.only(top: 8),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio:
                1.1, // Increased to 1.1 to provide more vertical space and prevent overflow
          ),
          itemCount: fields.length,
          itemBuilder: (_, i) {
            final field = fields[i];
            return BookingFieldCard(
              field: field,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FieldDetailScreen(field: field),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
