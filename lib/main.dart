import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/controllers/authentication_controller.dart';
import 'package:nutrimpasi/controllers/baby_controller.dart';
import 'package:nutrimpasi/screens/auth/login_screen.dart';
import 'package:nutrimpasi/screens/auth/register_screen.dart';
import 'package:nutrimpasi/screens/food/food_listing_screen.dart';
import 'package:nutrimpasi/screens/home_screen.dart';
import 'package:nutrimpasi/screens/schedule_screen.dart';
import 'screens/onboarding_screen.dart';
import 'constants/colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AuthenticationBloc(controller: AuthenticationController()),
        ),
        BlocProvider(
          create: (context) => BabyBloc(controller: BabyController()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
          ),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            // Logic untuk menentukan screen awal berdasarkan auth state
            if (state is AuthenticationInitial) {
              return const OnboardingScreen();
            } else if (state is LoginSuccess) {
              return const HomeScreen();
            } else if (state is AuthenticationError) {
              return const LoginScreen();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _page = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FoodListingScreen(),
    const ScheduleScreen(),
    const Center(child: Text('Forum')),
    const Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: _screens[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppColors.offWhite,
        color: AppColors.primary,
        height: MediaQuery.of(context).size.height * 0.070,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(
            Symbols.home_rounded,
            color: Colors.white,
            size: _page == 0 ? 35 : 25,
          ),
          Icon(
            Symbols.restaurant_menu,
            color: Colors.white,
            size: _page == 1 ? 35 : 25,
          ),
          Icon(
            Symbols.calendar_month,
            color: Colors.white,
            size: _page == 2 ? 35 : 25,
          ),
          Icon(Symbols.forum, color: Colors.white, size: _page == 3 ? 35 : 25),
          Icon(
            Symbols.settings,
            color: Colors.white,
            size: _page == 4 ? 35 : 25,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
