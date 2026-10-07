import 'package:flow_log/src/features/ElectricityDetail/screen/electricity_detail_screen.dart';
import 'package:flow_log/src/features/GasDetail/screen/gas_detail_screen.dart';
import 'package:flow_log/src/features/HotWaterDetail/screen/hot_water_detail_screen.dart';
import 'package:flow_log/src/features/ColdWaterDetail/screen/cold_water_detail_screen.dart';
import 'package:flow_log/src/features/Settings/screen/settings_screen.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Einstellungen',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
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
                  icon: const Icon(
                    Icons.bolt_rounded,
                    size: 52,
                    color: Colors.amber,
                  ),
                  label: 'Strom',
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
                  icon: const Icon(
                    Icons.local_fire_department_rounded,
                    size: 52,
                    color: Colors.orange,
                  ),
                  label: 'Gas',
                  color: Colors.orange.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GasDetailScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: const Icon(
                    Icons.water_drop_rounded,
                    size: 52,
                    color: Colors.blue,
                  ),
                  label: 'Kaltwasser',
                  color: Colors.blue.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ColdWaterDetailScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: const Icon(
                    Icons.waves_rounded,
                    size: 52,
                    color: Colors.redAccent,
                  ),
                  label: 'Warmwasser',
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HotWaterDetailScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
