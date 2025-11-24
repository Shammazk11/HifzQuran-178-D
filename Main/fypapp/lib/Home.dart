import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:adhan/adhan.dart';
import './provider.dart';
import './signup.dart';
import './EditProfile.dart';
import './History.dart';
import './searchAyah.dart';
import './GoalSetting.dart';
import './Pastgoals.dart';
import './sessiondetails.dart';
import './progressHistory.dart';
import 'package:geolocator/geolocator.dart'; // Add this import
import './PerformanceDashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HijriCalendar? _hijriDate;
  DateTime? _currentTime;
  PrayerTimes? _prayerTimes;
  String? _currentPrayer;
  String? _nextPrayer;
  String? _timeUntilNextPrayer;
  bool _isLoading = true;
  String? _locationError; // To store location-related errors for UI feedback

  @override
  void initState() {
    super.initState();
    _initializeIslamicData();
  }

  void _initializeIslamicData() {
    _hijriDate = HijriCalendar.now();
    _updateTimeAndPrayers();
  }

  void _updateTimeAndPrayers() async {
    _currentTime = DateTime.now();
    _locationError = null; // Reset error message

    try {
      Position position = await _determinePosition();
      final myCoordinates = Coordinates(position.latitude, position.longitude);

      final params = CalculationMethod.karachi.getParameters();
      params.madhab = Madhab.hanafi;
      _prayerTimes = PrayerTimes.today(myCoordinates, params);

      _currentPrayer = _getCurrentPrayer();
      _nextPrayer = _getNextPrayer();
      _timeUntilNextPrayer = _calculateTimeUntilNextPrayer();
    } catch (e) {
      print('Error fetching location: $e');
      _locationError = e.toString(); // Store the error message
      // Fallback to Karachi coordinates
      final fallbackCoordinates = Coordinates(24.8607, 67.0011);
      final params = CalculationMethod.karachi.getParameters();
      params.madhab = Madhab.hanafi;
      _prayerTimes = PrayerTimes.today(fallbackCoordinates, params);
      _currentPrayer = _getCurrentPrayer();
      _nextPrayer = _getNextPrayer();
      _timeUntilNextPrayer = _calculateTimeUntilNextPrayer();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        _updateTimeAndPrayers();
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt the user to enable location services
      await _showLocationServiceDialog();
      return Future.error('Location services are disabled.');
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _showLocationServiceDialog() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
            'Please enable location services to get accurate prayer times based on your location.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Optionally open device settings (not guaranteed to work on all platforms)
              Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getCurrentPrayer() {
    if (_prayerTimes == null) return 'Loading...'; // Handle null case
    final current =
        _prayerTimes!.currentPrayer(); // Safe to use ! after null check
    switch (current) {
      case Prayer.fajr:
        return 'Fajr';
      case Prayer.sunrise:
        return 'Sunrise';
      case Prayer.dhuhr:
        return 'Dhuhr';
      case Prayer.asr:
        return 'Asr';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isha';
      default:
        return 'None';
    }
  }

  String _getNextPrayer() {
    if (_prayerTimes == null) return 'Loading...'; // Handle null case
    final next = _prayerTimes!.nextPrayer(); // Safe to use ! after null check
    switch (next) {
      case Prayer.fajr:
        return 'Fajr';
      case Prayer.sunrise:
        return 'Sunrise';
      case Prayer.dhuhr:
        return 'Dhuhr';
      case Prayer.asr:
        return 'Asr';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isha';
      default:
        return 'Fajr (Tomorrow)';
    }
  }

  String _calculateTimeUntilNextPrayer() {
    if (_prayerTimes == null) return 'N/A'; // Handle null case
    final nextPrayerTime =
        _prayerTimes!.timeForPrayer(_prayerTimes!.nextPrayer());
    if (nextPrayerTime == null) return 'N/A';

    final difference = nextPrayerTime.difference(_currentTime!);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return '$hours hr $minutes min';
  }

  String _formatPrayerTime(DateTime? time) {
    if (time == null) return 'N/A';
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    String email = Provider.of<UserProvider>(context).email;
    // Get the first part of the email before @ for a more personalized greeting
    String username = email.split('@')[0];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('Home',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF13A795),
        centerTitle: true,      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                decoration: const BoxDecoration(
                  color: Color(0xFF13A795),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // App Logo
                        Image.asset(
                          'lib/images/logo.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(width: 15),
                        // Welcome Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assalamu Alaikum,',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Islamic Date
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            '${_hijriDate!.hDay} ${_hijriDate!.getLongMonthName()} ${_hijriDate!.hYear} AH',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Prayer Times Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_locationError != null) // Show error if present
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Location Error: $_locationError\nUsing fallback location (Karachi).',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    // Current Prayer Status
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Prayer Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF13A795),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: _buildPrayerStatusCard(
                                  'Current',
                                  _currentPrayer ?? 'Loading...',
                                  _formatPrayerTime(_prayerTimes?.timeForPrayer(
                                      _prayerTimes!.currentPrayer())),
                                  Colors.amber.shade100,
                                  const Color(0xFFFFB300),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildPrayerStatusCard(
                                  'Next',
                                  _nextPrayer ?? 'Loading...',
                                  'in $_timeUntilNextPrayer',
                                  Colors.green.shade100,
                                  const Color(0xFF13A795),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Today's Prayer Times
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Prayer Times',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF13A795),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildPrayerTimeRow(
                              'Fajr', _formatPrayerTime(_prayerTimes?.fajr)),
                          _buildPrayerTimeRow('Sunrise',
                              _formatPrayerTime(_prayerTimes?.sunrise)),
                          _buildPrayerTimeRow(
                              'Dhuhr', _formatPrayerTime(_prayerTimes?.dhuhr)),
                          _buildPrayerTimeRow(
                              'Asr', _formatPrayerTime(_prayerTimes?.asr)),
                          _buildPrayerTimeRow('Maghrib',
                              _formatPrayerTime(_prayerTimes?.maghrib)),
                          _buildPrayerTimeRow(
                              'Isha', _formatPrayerTime(_prayerTimes?.isha)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quick Actions
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF13A795),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuickActionButton(
                                context,
                                'Search Ayah',
                                Icons.search,
                                const SearchAyahPage(),
                              ),
                              _buildQuickActionButton(
                                context,
                                'Set Goals',
                                Icons.flag,
                                const GoalSettingPage(),
                              ),
                              _buildQuickActionButton(
                                context,
                                'Progress',
                                Icons.bar_chart,
                                const GoalDashboardPage(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF13A795),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'lib/images/logo.png',
                  width: 70,
                  height: 70,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Hifz Quran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.history),
          //   title: const Text('History'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const HistoryPage(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchAyahPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Goal Setting'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GoalSettingPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Past Goals'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PastGoalsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading:
            const Icon(Icons.pending_actions),
            title: const Text('Session Details'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserSessionsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Performance'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GoalDashboardPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Implement logout functionality
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStatusCard(String title, String prayer, String time,
      Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            prayer,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeRow(String prayer, String time) {
    final isCurrentPrayer =
        prayer.toLowerCase() == _currentPrayer?.toLowerCase();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isCurrentPrayer)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF13A795),
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                prayer,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      isCurrentPrayer ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentPrayer
                      ? const Color(0xFF13A795)
                      : Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isCurrentPrayer ? FontWeight.bold : FontWeight.normal,
              color: isCurrentPrayer ? const Color(0xFF13A795) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      BuildContext context, String title, IconData icon, Widget destination) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF13A795).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF13A795),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
