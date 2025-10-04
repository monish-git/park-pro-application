import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Import your pages
import 'screens/favorites_page.dart';
import 'screens/booking_page.dart';
import 'screens/fastag_page.dart';
import 'screens/notification_page.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Park-Pro+',
      theme: ThemeData(
        primaryColor: const Color(0xFF2979FF), // Electric Blue
        scaffoldBackgroundColor: const Color(0xFF121212), // Dark Gray
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: const Color(0xFF2979FF), // Electric Blue
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E), // Slightly lighter dark gray
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color(0xFF2979FF),
          unselectedItemColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2979FF),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const QuickBookPage(),
    );
  }
}

class QuickBookPage extends StatefulWidget {
  const QuickBookPage({super.key});

  @override
  State<QuickBookPage> createState() => _QuickBookPageState();
}

class _QuickBookPageState extends State<QuickBookPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    QuickBookHome(),
    FavoritesPage(),
    BookingPage(),
    FastagPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.local_parking), label: 'FASTag'),
        ],
      ),
    );
  }
}

/// ----------------------
/// HOME PAGE
/// ----------------------
class QuickBookHome extends StatefulWidget {
  const QuickBookHome({super.key});

  @override
  State<QuickBookHome> createState() => _QuickBookHomeState();
}

class _QuickBookHomeState extends State<QuickBookHome> with SingleTickerProviderStateMixin {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.7749, -122.4194);
  String _searchQuery = '';

  final PageController _servicesController = PageController(viewportFraction: 0.7);
  final PageController _featuresController = PageController(viewportFraction: 0.7);

  late AnimationController _chatController;
  late Animation<Offset> _chatOffset;
  bool _isChatOpen = false;

  @override
  void initState() {
    super.initState();
    _chatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _chatOffset = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _chatController, curve: Curves.easeInOut));
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
      _isChatOpen ? _chatController.forward() : _chatController.reverse();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final List<Map<String, dynamic>> filteredParkingSpots = [
    {'name': 'Downtown Parking', 'price': '₹120', 'distance': '0.8 km', 'available': 5},
    {'name': 'City Center Garage', 'price': '₹150', 'distance': '1.2 km', 'available': 3},
  ];

  final List<Map<String, dynamic>> filteredServices = [
    {'icon': Icons.local_car_wash, 'title': 'Car Wash', 'price': '₹200', 'duration': '30 min', 'distance': '0.5 km', 'rating': 4.5},
    {'icon': Icons.build, 'title': 'General Service', 'price': '₹500', 'duration': '2 hrs', 'distance': '1 km', 'rating': 4.8},
    {'icon': Icons.ev_station, 'title': 'EV Charging', 'price': '₹50', 'duration': '1 hr', 'distance': '0.8 km', 'rating': 4.6},
    {'icon': Icons.local_gas_station, 'title': 'Fuel Service', 'price': '₹100', 'duration': '15 min', 'distance': '0.6 km', 'rating': 4.2},
  ];

  final List<Map<String, dynamic>> filteredFeatures = [
    {'icon': Icons.speed, 'title': 'Real Time Parking Detection', 'description': 'Dynamic parking availability detection'},
    {'icon': Icons.navigation, 'title': 'GPS Navigation', 'description': 'Navigate directly to your spot'},
    {'icon': Icons.security, 'title': 'IoT Surveillance', 'description': 'AI-integrated smart security'},
    {'icon': Icons.event_available, 'title': 'Smart Reservations', 'description': 'AI-driven emergency response'},
    {'icon': Icons.mic, 'title': 'Voice & Gesture Control', 'description': 'Park using voice & gestures'},
  ];

  void _showFilterOptions() {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF1E1E1E),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Min Price',
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey[850],
                        filled: true,
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Max Price',
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey[850],
                        filled: true,
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Maximum Distance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Slider(
                activeColor: const Color(0xFF2979FF),
                inactiveColor: Colors.grey,
                value: 5.0,
                min: 0.1,
                max: 20.0,
                divisions: 40,
                label: '5.0 km',
                onChanged: (double value) {},
              ),
              const SizedBox(height: 16),
              const Text('Availability', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Row(
                children: [
                  FilterChip(
                    label: const Text('Available Now'),
                    selectedColor: const Color(0xFF2979FF),
                    onSelected: (bool value) {},
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('EV Charging'),
                    selectedColor: const Color(0xFF2979FF),
                    onSelected: (bool value) {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    IconButton(
                      icon: Icon(Icons.star, color: i <= 4 ? Colors.orange : Colors.grey),
                      onPressed: () {},
                    ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2979FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.local_parking, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text('Park-Pro+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search parking, services, features...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2979FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: _showFilterOptions,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: screenHeight * 0.5,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
                        markers: {
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: _center,
                            infoWindow: const InfoWindow(title: 'Your Location'),
                          ),
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Quick Book / Suggestions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          ...filteredParkingSpots.map((spot) => ParkingSpotCard(
                            name: spot['name'],
                            price: spot['price'],
                            distance: spot['distance'],
                            available: spot['available'],
                          )),
                          const SizedBox(height: 16),
                          const Text('Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 180,
                            child: PageView.builder(
                              controller: _servicesController,
                              itemCount: filteredServices.length,
                              itemBuilder: (context, index) {
                                final service = filteredServices[index];
                                return AnimatedBuilder(
                                  animation: _servicesController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (_servicesController.position.haveDimensions) {
                                      value = (_servicesController.page! - index).abs();
                                      value = (1 - (value * 0.2)).clamp(0.8, 1.0);
                                    }
                                    return Center(
                                      child: SizedBox(height: Curves.easeOut.transform(value) * 180, child: child),
                                    );
                                  },
                                  child: ServiceCard(
                                    icon: service['icon'],
                                    title: service['title'],
                                    price: service['price'],
                                    duration: service['duration'],
                                    distance: service['distance'],
                                    rating: service['rating'],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Smart Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 180,
                            child: PageView.builder(
                              controller: _featuresController,
                              itemCount: filteredFeatures.length,
                              itemBuilder: (context, index) {
                                final feature = filteredFeatures[index];
                                return AnimatedBuilder(
                                  animation: _featuresController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (_featuresController.position.haveDimensions) {
                                      value = (_featuresController.page! - index).abs();
                                      value = (1 - (value * 0.2)).clamp(0.8, 1.0);
                                    }
                                    return Center(
                                      child: SizedBox(height: Curves.easeOut.transform(value) * 180, child: child),
                                    );
                                  },
                                  child: FeatureCard(
                                    icon: feature['icon'],
                                    title: feature['title'],
                                    description: feature['description'],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: _toggleChat,
            child: const Icon(Icons.chat),
          ),
        ),
        SlideTransition(
          position: _chatOffset,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height,
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Chatbot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: _toggleChat),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Hello! I am your assistant.\nAsk me about parking, services, or FASTag.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFF2979FF)),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[850],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ----------------------
/// PARKING CARD
/// ----------------------
class ParkingSpotCard extends StatelessWidget {
  final String name;
  final String price;
  final String distance;
  final int available;

  const ParkingSpotCard({
    super.key,
    required this.name,
    required this.price,
    required this.distance,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.local_parking, size: 40, color: Color(0xFF2979FF)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('$price • $distance • $available spots available', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2979FF)),
              child: const Text('Book'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------------
/// SERVICE CARD
/// ----------------------
class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String price;
  final String duration;
  final String distance;
  final double rating;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.price,
    required this.duration,
    required this.distance,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF2979FF)),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text('$price • $duration', style: const TextStyle(color: Colors.white70)),
            Text('Distance: $distance', style: const TextStyle(color: Colors.white70)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text(rating.toString(), style: const TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// ----------------------
/// FEATURE CARD
/// ----------------------
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({super.key, required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF2979FF)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
