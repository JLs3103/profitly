import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang, Iqbal!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ],
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
                Column(
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
    Paint trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    Paint badPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;
      
    Paint warningPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    Offset center = Offset(size.width / 2, size.height);
    double radius = size.height - 15;

    // Draw background track (half circle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // start angle (pi, left)
      3.14159, // sweep angle (pi, up to right)
      false,
      trackPaint,
    );

    // Draw the segments to look like the design: red, orange, green
    // We can do a sweep gradient or draw arcs. Let's draw arcs for simplicity.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, 
      3.14159 * 0.25, 
      false,
      badPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 + (3.14159 * 0.25), 
      3.14159 * 0.25, 
      false,
      warningPaint,
    );
    Paint greenPaint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 + (3.14159 * 0.5), 
      3.14159 * 0.5, 
      false,
      greenPaint,
    );

    // Overlap the white progress
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // start left
      3.14159 * 0.82, // 82% progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
