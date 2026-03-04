import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? user;
  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      endDrawer: _buildEndDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang, ${user?['full_name']?.split(' ')[0] ?? 'User'}!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMoneyHealthCard(),
            const SizedBox(height: 16),
            _buildCashFlowCard(),
            const SizedBox(height: 16),
            _buildTargetCard(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bar_chart, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            'Profitly',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
            color: const Color(0xFF166835), // Primary dark green theme
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?['full_name'] ?? 'User Name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          icon: const Icon(Icons.logout, size: 16),
                          label: const Text('Log Out'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profil Saya'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Pengaturan'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Bantuan'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Kebijakan Privasi'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Tentang Aplikasi'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyHealthCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF269D50), Color(0xFF166835)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Placeholder for the Speedometer Gauge
          SizedBox(
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Custom Paint for half circle
                CustomPaint(
                  size: const Size(200, 100),
                  painter: _GaugePainter(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0), // push it down lower
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '82',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        const Text(
                          'Baik',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Money Health Score',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          // Balances
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1D7A42),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saldo Saat Ini', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const Text(
                        'Rp 12.500.000',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const Text(
                        'Rp 3.200.000',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCashFlowCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cash Flow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Icon(Icons.bar_chart, color: Colors.green.shade700),
            ],
          ),
          const SizedBox(height: 16),
          // FlChart placeholder
          SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'Chart Placeholder',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Target Keuangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _buildTargetRowItem(
            icon: Icons.shield_outlined,
            title: 'Dana Darurat',
            current: 'Rp 6.000.000',
            target: '8.000.000',
            progress: 0.75,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          _buildTargetRowItem(
            icon: Icons.business_center_outlined,
            title: 'Modal Usaha',
            current: 'Rp 4.000.000',
            target: '10.000.000',
            progress: 0.4,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildTargetRowItem({
    required IconData icon,
    required String title,
    required String current,
    required String target,
    required double progress,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: current, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        TextSpan(text: ' / $target', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height);
    double radius = size.height - 15;

    Paint trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // Draw background track (half circle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // start angle (pi, left)
      3.14159, // sweep angle (pi, up to right)
      false,
      trackPaint,
    );

    // 7 solid color blocks from left to right
    final baseColors = [
      Colors.green.shade900, // hijau tua
      Colors.green.shade500, // hijau muda
      Colors.green.shade300, // hijau lebih muda lagi
      Colors.yellow.shade500, // kuning
      Colors.red.shade300,   // merah lebih muda lagi
      Colors.red.shade400,   // merah muda
      Colors.red.shade900,   // merah tua
    ];

    List<Color> hardColors = [];
    List<double> hardStops = [];
    for (int i = 0; i < 7; i++) {
      hardColors.add(baseColors[i]);
      hardColors.add(baseColors[i]);
      // Divide the arc into 7 equal pieces using stops
      hardStops.add(i / 7.0);
      hardStops.add((i + 1) / 7.0);
    }

    Paint gradientPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 3.14159,
        endAngle: 3.14159 * 2,
        colors: hardColors,
        stops: hardStops,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // Draw the partitioned colored chunks
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159,
      3.14159,
      false,
      gradientPaint,
    );

    // Indicator at 82%
    // Instead of a sweep that covers everything, we draw a tiny arc to act as a point/bead
    Paint indicatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    double progressAngle = 3.14159 + (3.14159 * 0.82);
    // Draw an indicator bead that sits exactly at 82%
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      progressAngle - 0.015, // slightly before center
      0.03, // Tiny sweep angle just to show a dot
      false,
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
