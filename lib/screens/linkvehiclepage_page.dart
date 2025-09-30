import 'package:flutter/material.dart';

class LinkVehiclePage extends StatefulWidget {
  const LinkVehiclePage({super.key});

  @override
  State<LinkVehiclePage> createState() => _LinkVehiclePageState();
}

class _LinkVehiclePageState extends State<LinkVehiclePage> {
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _fastagNumberController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String _vehicleType = 'Car';
  String _state = 'Select State';
  String _fastagProvider = 'SBI';
  String _vehicleColor = 'White';
  String _vehicleModel = '';

  // Sample list of linked vehicles
  List<Map<String, String>> linkedVehicles = [];

  void _linkVehicle() {
    String vehicleNumber = _vehicleNumberController.text.trim();
    String ownerName = _ownerNameController.text.trim();

    if (vehicleNumber.isEmpty || ownerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all required fields")),
      );
      return;
    }

    setState(() {
      linkedVehicles.add({
        'vehicleNumber': vehicleNumber,
        'vehicleType': _vehicleType,
        'state': _state,
        'ownerName': ownerName,
        'fastagNumber': _fastagNumberController.text.trim(),
        'fastagProvider': _fastagProvider,
        'vehicleColor': _vehicleColor,
        'vehicleModel': _vehicleModel,
        'mobile': _mobileController.text.trim(),
      });

      // Clear form
      _vehicleNumberController.clear();
      _ownerNameController.clear();
      _fastagNumberController.clear();
      _mobileController.clear();
      _vehicleType = 'Car';
      _state = 'Select State';
      _fastagProvider = 'SBI';
      _vehicleColor = 'White';
      _vehicleModel = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vehicle linked successfully")),
    );
  }

  void _removeVehicle(int index) {
    setState(() {
      linkedVehicles.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vehicle removed")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Link Vehicle"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vehicle Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Vehicle Number
            TextField(
              controller: _vehicleNumberController,
              decoration: InputDecoration(
                labelText: "Vehicle Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(height: 12),

            // Owner Name
            TextField(
              controller: _ownerNameController,
              decoration: InputDecoration(
                labelText: "Owner Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),

            // Vehicle Type
            DropdownButtonFormField<String>(
              value: _vehicleType,
              decoration: InputDecoration(
                labelText: "Vehicle Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ['Car', 'Bike', 'Truck', 'Bus']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _vehicleType = val!;
                });
              },
            ),
            const SizedBox(height: 12),

            // State
            DropdownButtonFormField<String>(
              value: _state,
              decoration: InputDecoration(
                labelText: "Registration State",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                'Select State',
                'Andhra Pradesh',
                'Delhi',
                'Karnataka',
                'Maharashtra',
                'Tamil Nadu'
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _state = val!;
                });
              },
            ),
            const SizedBox(height: 12),

            // Vehicle Model
            TextField(
              onChanged: (val) => _vehicleModel = val,
              decoration: InputDecoration(
                labelText: "Vehicle Model",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.directions_car_filled),
              ),
            ),
            const SizedBox(height: 12),

            // Vehicle Color
            DropdownButtonFormField<String>(
              value: _vehicleColor,
              decoration: InputDecoration(
                labelText: "Vehicle Color",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ['White', 'Black', 'Blue', 'Red', 'Silver', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _vehicleColor = val!;
                });
              },
            ),
            const SizedBox(height: 12),

            // FASTag Number
            TextField(
              controller: _fastagNumberController,
              decoration: InputDecoration(
                labelText: "FASTag Number (Optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 12),

            // FASTag Provider
            DropdownButtonFormField<String>(
              value: _fastagProvider,
              decoration: InputDecoration(
                labelText: "FASTag Provider",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ['SBI', 'HDFC', 'ICICI', 'Paytm', 'Axis Bank']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _fastagProvider = val!;
                });
              },
            ),
            const SizedBox(height: 12),

            // Mobile Number
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),

            // Link Vehicle Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _linkVehicle,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "Link Vehicle",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Linked Vehicles List
            if (linkedVehicles.isNotEmpty)
              const Text(
                "Linked Vehicles",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 12),

            ...linkedVehicles.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> vehicle = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Icon(
                    vehicle['vehicleType'] == 'Car'
                        ? Icons.directions_car
                        : vehicle['vehicleType'] == 'Bike'
                        ? Icons.motorcycle
                        : Icons.local_shipping,
                    color: Colors.blueAccent,
                  ),
                  title: Text(vehicle['vehicleNumber']!),
                  subtitle: Text("${vehicle['ownerName']} • ${vehicle['fastagProvider']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeVehicle(index),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
