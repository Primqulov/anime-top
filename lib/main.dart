import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AnimationMenuPage(),
    );
  }
}

class AnimationMenuPage extends StatelessWidget {
  const AnimationMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const BuiltInImplicitPage(),
      const CustomImplicitPage(),
      const BuiltInExplicitPage(),
      const CustomExplicitPage(),
    ];

    final titles = [
      '1. Build-In Implicit',
      '2. Custom Implicit',
      '3. Build-In Explicit',
      '4. Custom Explicit',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bounce Ball Animations'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => pages[index],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(titles[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildBall() {
  return Image.asset(
    'assets/images/ball.jpg',
    width: 150,
    height: 150,
  );
}

class BuiltInImplicitPage extends StatefulWidget {
  const BuiltInImplicitPage({super.key});

  @override
  State<BuiltInImplicitPage> createState() => _BuiltInImplicitPageState();
}

class _BuiltInImplicitPageState extends State<BuiltInImplicitPage> {
  bool isUp = false;

  void playAnimation() {
    setState(() {
      isUp = !isUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build-In Implicit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: playAnimation,
        child: const Icon(Icons.play_arrow),
      ),
      body: AnimatedAlign(
        duration: const Duration(milliseconds: 800),
        curve: Curves.bounceOut,
        alignment:
        isUp ? const Alignment(0, -0.8) : const Alignment(0, 0.8),
        child: buildBall(),
      ),
    );
  }
}

class CustomImplicitPage extends StatefulWidget {
  const CustomImplicitPage({super.key});

  @override
  State<CustomImplicitPage> createState() => _CustomImplicitPageState();
}

class _CustomImplicitPageState extends State<CustomImplicitPage> {
  bool isUp = false;

  void playAnimation() {
    setState(() {
      isUp = !isUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Implicit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: playAnimation,
        child: const Icon(Icons.play_arrow),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: isUp ? 250 : -250,
          end: isUp ? -250 : 250,
        ),
        duration: const Duration(milliseconds: 800),
        curve: Curves.bounceOut,
        child: buildBall(),
        builder: (context, value, child) {
          return Center(
            child: Transform.translate(
              offset: Offset(0, value),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class BuiltInExplicitPage extends StatefulWidget {
  const BuiltInExplicitPage({super.key});

  @override
  State<BuiltInExplicitPage> createState() => _BuiltInExplicitPageState();
}

class _BuiltInExplicitPageState extends State<BuiltInExplicitPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    animation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: const Offset(0, -1.5),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
      ),
    );
  }

  void playAnimation() {
    controller.reset();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build-In Explicit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: playAnimation,
        child: const Icon(Icons.play_arrow),
      ),
      body: Center(
        child: SlideTransition(
          position: animation,
          child: buildBall(),
        ),
      ),
    );
  }
}

class CustomExplicitPage extends StatefulWidget {
  const CustomExplicitPage({super.key});

  @override
  State<CustomExplicitPage> createState() => _CustomExplicitPageState();
}

class _CustomExplicitPageState extends State<CustomExplicitPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    animation = Tween<double>(
      begin: 250,
      end: -250,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
      ),
    );
  }

  void playAnimation() {
    controller.reset();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Explicit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: playAnimation,
        child: const Icon(Icons.play_arrow),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          child: buildBall(),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, animation.value),
              child: child,
            );
          },
        ),
      ),
    );
  }
}