import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/planet_model.dart';
import 'package:sky_seek/screens/Compare/comparison_result_screen.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/services/planet_service.dart';
import 'package:sky_seek/widgets/earth_loader.dart';

class ComparePlanetsScreen extends StatefulWidget {
  const ComparePlanetsScreen({super.key});

  @override
  State<ComparePlanetsScreen> createState() => _ComparePlanetsScreenState();
}

class _ComparePlanetsScreenState extends State<ComparePlanetsScreen> {
  // Text editing controllers for the two planet name inputs
  final TextEditingController _planet1Controller = TextEditingController();
  final TextEditingController _planet2Controller = TextEditingController();

  // Loading states
  bool _isLoading = false;
  String _errorMessage = '';

  // List of all available planets for suggestions
  final List<Planet> _allPlanets = [];
  bool _loadingPlanets = true;

  @override
  void initState() {
    super.initState();
    _loadAllPlanets();
  }

  @override
  void dispose() {
    _planet1Controller.dispose();
    _planet2Controller.dispose();
    super.dispose();
  }

  // Load all planets for autocomplete suggestions
  Future<void> _loadAllPlanets() async {
    try {
      setState(() {
        _loadingPlanets = true;
      });

      final planets = await PlanetService.fetchPlanets();

      setState(() {
        _allPlanets.clear();
        _allPlanets.addAll(planets);
        _loadingPlanets = false;
      });
    } catch (e) {
      setState(() {
        _loadingPlanets = false;
      });
      print('Error loading planets: $e');
    }
  }

  // Compare planets using API
  Future<void> _comparePlanets() async {
    // Reset state
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Get planet names from controllers
    final String planet1Name = _planet1Controller.text.trim();
    final String planet2Name = _planet2Controller.text.trim();

    // Validate inputs
    if (planet1Name.isEmpty || planet2Name.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter both planet names';
      });
      return;
    }

    try {
      // Get auth token
      final String? token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Authentication required. Please log in.';
        });
        return;
      }

      // Call the comparison API
      final result = await PlanetService.comparePlanets(
        token,
        planet1Name,
        planet2Name,
      );

      if (result['success'] == true) {
        // Find the Planet objects from the _allPlanets list
        final planet1Object = _findPlanetByName(planet1Name);
        final planet2Object = _findPlanetByName(planet2Name);

        setState(() {
          _isLoading = false;
        });

        if (planet1Object != null && planet2Object != null) {
          // Navigate to the comparison result screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ComparisonResultScreen(
                    planet1: planet1Object,
                    planet2: planet2Object,
                    comparisonData: result['data'],
                  ),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'One or both planets could not be found';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result['error'] ?? 'Failed to compare planets';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error comparing planets: $e';
      });
    }
  }

  // Find a planet by name (case insensitive)
  Planet? _findPlanetByName(String name) {
    return _allPlanets.firstWhereOrNull(
      (planet) => planet.name.toLowerCase() == name.toLowerCase(),
    );
  }

  // Get planet suggestions based on input
  List<String> _getPlanetSuggestions(String query) {
    if (query.isEmpty) {
      return [];
    }

    return _allPlanets
        .where(
          (planet) => planet.name.toLowerCase().contains(query.toLowerCase()),
        )
        .map((planet) => planet.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Compare Planets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background
          SizedBox.expand(
            child: Stack(
              children: [
                // Stars background
                Image.asset(
                  'assets/images/infobg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instruction text
                  Text(
                    'Enter two planet names to compare their features',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 34.h),

                  // Planet input fields
                  Column(
                    children: [
                      // Planet 1 input
                      _buildPlanetInputField(
                        controller: _planet1Controller,
                        label: 'First Planet',
                        icon: Icons.public,
                      ),

                      10.h.verticalSpace,
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          'VS',
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      10.h.verticalSpace,
                      _buildPlanetInputField(
                        controller: _planet2Controller,
                        label: 'Second Planet',
                        icon: Icons.public,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Compare button
                  ElevatedButton(
                    onPressed: _loadingPlanets ? null : _comparePlanets,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Compare Planets',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Error message if any
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Loading suggestions message
                  if (_loadingPlanets)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EarthLoader(size: 60),
                        10.h.verticalSpace,
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build planet input field with autocomplete
  Widget _buildPlanetInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return _getPlanetSuggestions(textEditingValue.text);
        },
        onSelected: (String selection) {
          controller.text = selection;
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            onSubmitted: (_) => onFieldSubmitted(),
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.white70,
                fontFamily: 'Poppins',
              ),
              prefixIcon: Icon(icon, color: Colors.tealAccent),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.black87,
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200.w, maxHeight: 200.h),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        onSelected(option);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
