import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';

class SetLocationPage extends StatefulWidget {
  final Function(double lat, double lon, String name) onLocationChanged;

  const SetLocationPage({super.key, required this.onLocationChanged});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  
  List<Map<String, dynamic>> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _suggestions = [];
          _isSearching = false;
        });
        return;
      }

      setState(() => _isSearching = true);

      final results = await _weatherService.searchLocations(query);

      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Location'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search city (e.g. London, Tokyo)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              setState(() => _suggestions = []);
                            },
                          )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _suggestions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_city, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            _controller.text.isEmpty
                                ? 'Start typing to search for locations'
                                : 'No locations found for "${_controller.text}"',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _suggestions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _suggestions[index];
                        final name = item['name'] ?? '';
                        final country = item['country'] ?? '';
                        final admin1 = item['admin1'] ?? '';
                        final subtitle = [admin1, country].where((e) => e.isNotEmpty).join(', ');

                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(name),
                          subtitle: Text(subtitle),
                          onTap: () {
                            final lat = (item['latitude'] as num).toDouble();
                            final lon = (item['longitude'] as num).toDouble();
                            final fullName = "$name, $country";
                            
                            widget.onLocationChanged(lat, lon, fullName);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Weather updated for $fullName'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
