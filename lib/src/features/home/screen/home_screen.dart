import 'package:flow_log/src/features/ElectricityDetail/screen/electricity_detail_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/big_menu_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlowLog'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BigMenuButton(
                  icon: const Icon(Icons.bolt, size: 48, color: Colors.amber),
                  label: 'Electricity',
                  color: Colors.amber.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ElectricityDetailScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: const Icon(Icons.local_fire_department, size: 48, color: Colors.orangeAccent),
                  label: 'Gas',
                  color: Colors.orangeAccent.withValues(alpha: 0.1),
                  onTap: () {},
                ),
                BigMenuButton(
                  icon: const Icon(Icons.water_drop, size: 48, color: Colors.blue),
                  label: 'Cold Water',
                  color: Colors.blue.withValues(alpha: 0.1),
                  onTap: () {},
                ),
                BigMenuButton(
                  icon: const Icon(Icons.hot_tub, size: 48, color: Colors.redAccent),
                  label: 'Hot Water',
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}