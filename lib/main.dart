import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// pages
import 'screens/booking_page.dart';
import 'screens/favorites_page.dart';
import 'screens/notification_page.dart';
import 'screens/profile_page.dart';
import 'screens/wallet_page.dart';


void main() {
  runApp(const ParkProApp());
}

class ParkProApp extends StatelessWidget {
  const ParkProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PARK-PRO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        scaffoldBackgroundColor: Colors.grey.shade100,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

/// Mock parking data
class ParkingSpot {
  final String id;
  final String name;
  final LatLng position;
  final double pricePerHour;
  final bool hasEv;
  final bool covered;
  final bool secured;
  final int availableSpots;
  final double distanceKm;
  final String? imageUrl;

  ParkingSpot({
    required this.id,
    required this.name,
    required this.position,
    required this.pricePerHour,
    required this.hasEv,
    required this.covered,
    required this.secured,
    required this.availableSpots,
    required this.distanceKm,
    this.imageUrl,
  });
}

/// Service data model
class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Bottom nav
  int _selectedTab = 0;

  // Search / filters
  final TextEditingController _searchCtl = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _filterEv = false;
  bool _filterCovered = false;
  bool _filterSecured = false;
  String _sort = 'Distance';

  // Location dropdown
  String _city = "Hyderabad";

  // Map
  GoogleMapController? _mapController;
  final LatLng _mockUserLocation = const LatLng(17.444, 78.377); // Hitech City-ish
  final MapType _mapType = MapType.normal;

  // Mock parking data
  late List<ParkingSpot> _allSpots;
  late List<Service> _allServices;
  String? _activeSpotId; // for sheet highlight

  @override
  void initState() {
    super.initState();
    _allSpots = _seedSpots();
    _allServices = _seedServices();
  }

  List<ParkingSpot> _seedSpots() {
    final rnd = Random(17);
    final base = _mockUserLocation;
    final spots = <ParkingSpot>[];
    for (int i = 0; i < 12; i++) {
      final dx = (rnd.nextDouble() - 0.5) * 0.04;
      final dy = (rnd.nextDouble() - 0.5) * 0.04;
      final pos = LatLng(base.latitude + dx, base.longitude + dy);
      final dist = sqrt(dx * dx + dy * dy) * 111; // rough km
      spots.add(
        ParkingSpot(
          id: 'spot_$i',
          name: i == 0
              ? "Downtown Mall Parking"
              : i == 1
              ? "Airport Terminal A"
              : i == 2
              ? "IT Park Block C"
              : "Spot ${i + 1}",
          position: pos,
          pricePerHour: [30, 40, 50, 60, 80][rnd.nextInt(5)].toDouble(),
          hasEv: rnd.nextBool(),
          covered: rnd.nextBool(),
          secured: rnd.nextBool(),
          availableSpots: rnd.nextInt(12) + 1,
          distanceKm: double.parse(dist.toStringAsFixed(2)),
          imageUrl: i % 3 == 0 ? 'https://picsum.photos/300/200?random=$i' : null,
        ),
      );
    }
    return spots;
  }

  List<Service> _seedServices() {
    return [
      Service(
        id: 'service_1',
        name: 'Car Wash',
        description: 'Complete exterior and interior cleaning',
        price: 499,
        imageUrl: 'https://picsum.photos/300/200?random=101',
        category: 'Cleaning',
      ),
      Service(
        id: 'service_2',
        name: 'Detailing',
        description: 'Premium interior and exterior detailing service',
        price: 1499,
        imageUrl: 'https://picsum.photos/300/200?random=102',
        category: 'Cleaning',
      ),
      Service(
        id: 'service_3',
        name: 'Oil Change',
        description: 'Engine oil and filter replacement',
        price: 899,
        imageUrl: 'https://picsum.photos/300/200?random=103',
        category: 'Maintenance',
      ),
      Service(
        id: 'service_4',
        name: 'Tire Service',
        description: 'Tire rotation, balancing and pressure check',
        price: 399,
        imageUrl: 'https://picsum.photos/300/200?random=104',
        category: 'Maintenance',
      ),
      Service(
        id: 'service_5',
        name: 'EV Charging',
        description: 'Fast charging for electric vehicles',
        price: 299,
        imageUrl: 'https://picsum.photos/300/200?random=105',
        category: 'EV Services',
      ),
      Service(
        id: 'service_6',
        name: 'Car Inspection',
        description: 'Comprehensive vehicle health check',
        price: 599,
        imageUrl: 'https://picsum.photos/300/200?random=106',
        category: 'Maintenance',
      ),
    ];
  }

  List<ParkingSpot> get _filteredSortedSpots {
    var list = _allSpots.where((s) {
      if (_filterEv && !s.hasEv) return false;
      if (_filterCovered && !s.covered) return false;
      if (_filterSecured && !s.secured) return false;
      if (_searchCtl.text.trim().isNotEmpty) {
        final q = _searchCtl.text.toLowerCase();
        if (!s.name.toLowerCase().contains(q)) return false;
      }
      return true;
    }).toList();

    switch (_sort) {
      case 'Price':
        list.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
        break;
      case 'Availability':
        list.sort((b, a) => a.availableSpots.compareTo(b.availableSpots));
        break;
      default: // Distance
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return list;
  }

  List<Service> get _filteredServices {
    if (_searchCtl.text.trim().isEmpty) return _allServices;

    final query = _searchCtl.text.toLowerCase();
    return _allServices.where((service) {
      return service.name.toLowerCase().contains(query) ||
          service.description.toLowerCase().contains(query) ||
          service.category.toLowerCase().contains(query);
    }).toList();
  }

  // Marker color based on availability
  double _hueFor(ParkingSpot s) {
    if (s.availableSpots >= 8) return BitmapDescriptor.hueGreen;
    if (s.availableSpots >= 4) return BitmapDescriptor.hueAzure;
    return BitmapDescriptor.hueRed;
  }

  // --- UI BUILD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTopAppBar(),
      body: _buildHomeContent(), // Always show home content
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: Colors.lightBlueAccent,
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 12,
      title: Row(
        children: [
          const Icon(Icons.local_parking, size: 28, color: Colors.white),
          const SizedBox(width: 8),
          _buildCitySelector(),
          const Spacer(),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              // Navigate to notifications
            },
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              // Navigate to profile
            },
            icon: const Icon(Icons.account_circle, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _city,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: Colors.green.shade700,
          items: const [
            DropdownMenuItem(
              value: "Hyderabad",
              child: Text("Hyderabad", style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: "Chennai",
              child: Text("Chennai", style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: "Bengaluru",
              child: Text("Bengaluru", style: TextStyle(color: Colors.white)),
            ),
          ],
          onChanged: (v) => setState(() => _city = v ?? _city),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Column(
      children: [
        _buildSearchRow(),
        Expanded(
          child: isWide ? _buildWideLayout() : _buildStackedLayout(),
        ),
      ],
    );
  }

  Widget _buildSearchRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: [
          // Search
          Expanded(
            child: TextField(
              controller: _searchCtl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search parking or services...",
                suffixIcon: IconButton(
                  tooltip: 'Use current location',
                  onPressed: () {
                    _searchCtl.text = "Current Location";
                    setState(() {});
                  },
                  icon: const Icon(Icons.near_me),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Date
          IconButton(
            tooltip: 'Pick date & time',
            onPressed: _pickDateTime,
            icon: const Icon(Icons.calendar_today, color: Colors.lightBlueAccent),
          ),
          // Filter
          IconButton(
            tooltip: 'Filters',
            onPressed: _openFilters,
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.lightBlueAccent),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: _selectedDate ?? now,
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (!mounted) return;
    setState(() {
      _selectedDate = d;
      _selectedTime = t;
    });
  }

  String _fmtDateTime(DateTime d, TimeOfDay t) {
    final hh = t.hourOfPeriod.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    final ap = t.period == DayPeriod.am ? "AM" : "PM";
    return "${d.day}/${d.month}/${d.year} • $hh:$mm $ap";
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setM) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _sort,
                          items: const [
                            DropdownMenuItem(value: 'Distance', child: Text('Sort: Distance')),
                            DropdownMenuItem(value: 'Price', child: Text('Sort: Price')),
                            DropdownMenuItem(value: 'Availability', child: Text('Sort: Availability')),
                          ],
                          onChanged: (v) => setM(() => _sort = v ?? _sort),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text("EV Charging"),
                    value: _filterEv,
                    onChanged: (v) => setM(() => _filterEv = v),
                  ),
                  SwitchListTile(
                    title: const Text("Covered"),
                    value: _filterCovered,
                    onChanged: (v) => setM(() => _filterCovered = v),
                  ),
                  SwitchListTile(
                    title: const Text("Security (CCTV/Guard)"),
                    value: _filterSecured,
                    onChanged: (v) => setM(() => _filterSecured = v),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setM(() {
                              _filterEv = _filterCovered = _filterSecured = false;
                              _sort = 'Distance';
                            });
                          },
                          child: const Text("Reset"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text("Apply"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Layouts ---

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Map view
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _buildMapCard(),
          ),
        ),
        // Services and Quick Book
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                Expanded(flex: 1, child: _buildServicesSection()),
                const SizedBox(height: 10),
                Expanded(flex: 1, child: _buildQuickBookCard()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStackedLayout() {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _buildMapCard(height: 320),
        const SizedBox(height: 10),
        _buildServicesSection(),
        const SizedBox(height: 10),
        _buildQuickBookCard(),
      ],
    );
  }

  // Services Section
  Widget _buildServicesSection() {
    final services = _filteredServices;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          if (services.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("No services match your search."),
            )
          else
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildServiceCard(service);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Service Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                service.imageUrl,
                width: 100,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            // Service Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${service.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${service.name} booked successfully!'),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text('Book Now'),
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

  // --- Cards ---

  Widget _buildMapCard({double? height}) {
    final markers = _filteredSortedSpots.map((s) {
      return Marker(
        markerId: MarkerId(s.id),
        position: s.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(_hueFor(s)),
        infoWindow: InfoWindow(title: s.name, snippet: "₹${s.pricePerHour.toStringAsFixed(0)}/hr"),
        onTap: () {
          setState(() => _activeSpotId = s.id);
        },
      );
    }).toSet();

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: _mapType,
        initialCameraPosition: CameraPosition(
          target: _mockUserLocation,
          zoom: 13.2,
        ),
        onMapCreated: (c) => _mapController = c,
        markers: markers,
      ),
    );
  }

  Widget _buildQuickBookCard() {
    final items = _filteredSortedSpots.take(8).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Text(
              "Quick Book / Suggestions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const Divider(height: 1),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("No spots match your filters."),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final s = items[i];
                  return ListTile(
                    leading: Icon(Icons.local_parking,
                        color: s.availableSpots >= 8
                            ? Colors.green
                            : s.availableSpots >= 4
                            ? Colors.blue
                            : Colors.red),
                    title: Text(s.name),
                    subtitle: Text(
                        "${s.distanceKm} km • ₹${s.pricePerHour.toStringAsFixed(0)}/hr"),
                    trailing: Text(
                      s.availableSpots >= 8
                          ? "Good"
                          : s.availableSpots >= 4
                          ? "Limited"
                          : "Few",
                      style: TextStyle(
                        color: s.availableSpots >= 8
                            ? Colors.green
                            : s.availableSpots >= 4
                            ? Colors.orange
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // --- Bottom Nav ---

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _selectedTab,
      onDestinationSelected: (i) => setState(() => _selectedTab = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.favorite_border), label: "Favorites"),
        NavigationDestination(icon: Icon(Icons.book_online), label: "Bookings"),
        NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
      ],
    );
  }
}