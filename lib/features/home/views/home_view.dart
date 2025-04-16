import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/services/user_service.dart';
import 'package:opticscan/utils/animations/animation.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin, FormAnimationControllerProvider {
  final UserService _userService = Get.find<UserService>();

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    initAnimationController(this);

    // Start the animation
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpticScan'),
        backgroundColor: const Color(0xFF146EF5),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: FormAnimationBuilder(
        controller: animationController,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Welcome section
              StaggeredFormField(
                controller: animationController,
                startInterval: 0.0,
                endInterval: 0.3,
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${_userService.currentUser.value?.name ?? 'User'}!',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'User Type: ${_userService.currentUser.value?.userType ?? 'pasien'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xACACACAC),
                          ),
                        ),
                        Text(
                          'Email: ${_userService.currentUser.value?.email ?? 'Not available'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xACACACAC),
                          ),
                        ),
                      ],
                    )),
              ),

              const SizedBox(height: 40),

              // Dashboard content
              StaggeredFormField(
                controller: animationController,
                startInterval: 0.2,
                endInterval: 0.5,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This is a placeholder for your dashboard content. You can add your appointments, medical records, or other relevant information here.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDashboardCard(
                              icon: Icons.calendar_today,
                              title: 'Appointments',
                              subtitle: 'View your upcoming appointments',
                              color: const Color(0xFF146EF5),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDashboardCard(
                              icon: Icons.medical_services,
                              title: 'Medical Records',
                              subtitle: 'Access your medical history',
                              color: const Color(0xFF22C55E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Settings button
              StaggeredFormField(
                controller: animationController,
                startInterval: 0.4,
                endInterval: 0.7,
                child: AnimatedButton(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF146EF5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Go to Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF146EF5),
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Home tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            activeIcon: Icon(Icons.person),
          ),
        ],
        onTap: (index) {
          if (index == 2) {}
        },
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
