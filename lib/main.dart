import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/blocs/baby_food_recommendation/baby_food_recommendation_bloc.dart';
import 'package:nutrimpasi/blocs/comment/comment_bloc.dart';
import 'package:nutrimpasi/blocs/favorite/favorite_bloc.dart';
import 'package:nutrimpasi/blocs/food/food_bloc.dart';
import 'package:nutrimpasi/blocs/food_category/food_category_bloc.dart';
import 'package:nutrimpasi/blocs/food_cooking/food_cooking_bloc.dart';
import 'package:nutrimpasi/blocs/food_detail/food_detail_bloc.dart';
import 'package:nutrimpasi/blocs/food_record/food_record_bloc.dart';
import 'package:nutrimpasi/blocs/food_suggestion/food_suggestion_bloc.dart';
import 'package:nutrimpasi/blocs/like/like_bloc.dart';
import 'package:nutrimpasi/blocs/notification/notification_bloc.dart';
import 'package:nutrimpasi/blocs/nutritionist/nutritionist_bloc.dart';
import 'package:nutrimpasi/blocs/report/report_bloc.dart';
import 'package:nutrimpasi/blocs/schedule/schedule_bloc.dart';
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart';
import 'package:nutrimpasi/constants/deep_link.dart';
import 'package:nutrimpasi/controllers/authentication_controller.dart';
import 'package:nutrimpasi/controllers/baby_controller.dart';
import 'package:nutrimpasi/controllers/comment_controller.dart';
import 'package:nutrimpasi/controllers/favorite_controller.dart';
import 'package:nutrimpasi/controllers/food_controller.dart';
import 'package:nutrimpasi/controllers/food_record_controller.dart';
import 'package:nutrimpasi/controllers/food_suggestion_controller.dart';
import 'package:nutrimpasi/controllers/like_controller.dart';
import 'package:nutrimpasi/controllers/notification_controller.dart';
import 'package:nutrimpasi/controllers/nutritionist_controller.dart';
import 'package:nutrimpasi/controllers/report_controller.dart';
import 'package:nutrimpasi/controllers/schedule_controller.dart';
import 'package:nutrimpasi/controllers/thread_controller.dart';
import 'package:nutrimpasi/screens/auth/login_screen.dart';
import 'package:nutrimpasi/screens/auth/register_screen.dart';
import 'package:nutrimpasi/screens/food/food_list_screen.dart';
import 'package:nutrimpasi/screens/forum/forum_screen.dart';
import 'package:nutrimpasi/screens/home_screen.dart';
import 'package:nutrimpasi/screens/setting/setting_screen.dart';
import 'package:nutrimpasi/screens/features/schedule_screen.dart';
import 'package:nutrimpasi/screens/splash_screen.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'screens/onboarding_screen.dart';
import 'constants/colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Make main async
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // set locale timeago package
  timeago.setLocaleMessages('id', timeago.IdMessages());
  timeago.setDefaultLocale('id');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize deep linking when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkHandler.initDeepLinking();
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = AuthenticationBloc(
              controller: AuthenticationController(),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (bloc.state is AuthenticationInitial) {
                bloc.add(CheckAuthStatus());
              }
            });
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => BabyBloc(controller: BabyController()),
        ),
        BlocProvider(
          create:
              (context) =>
                  BabyFoodRecommendationBloc(controller: BabyController()),
        ),
        BlocProvider(
          create: (context) => CommentBloc(controller: CommentController()),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(controller: FavoriteController()),
        ),
        BlocProvider(
          create: (context) => FoodBloc(controller: FoodController()),
        ),
        BlocProvider(
          create:
              (context) =>
                  FoodCategoryBloc(controller: FoodSuggestionController()),
        ),
        BlocProvider(
          create: (context) => FoodCookingBloc(controller: FoodController()),
        ),
        BlocProvider(
          create:
              (context) => FoodDetailBloc(
                controller: FoodController(),
                favoriteController: FavoriteController(),
              ),
        ),
        BlocProvider(
          create:
              (context) => FoodRecordBloc(controller: FoodRecordController()),
        ),
        BlocProvider(
          create:
              (context) =>
                  FoodSuggestionBloc(controller: FoodSuggestionController()),
        ),
        BlocProvider(
          create: (context) => LikeBloc(controller: LikeController()),
        ),
        BlocProvider(
          create:
              (context) =>
                  NotificationBloc(controller: NotificationController()),
        ),
        BlocProvider(
          create:
              (context) =>
                  NutritionistBloc(controller: NutritionistController()),
        ),
        BlocProvider(
          create: (context) => ReportBloc(controller: ReportController()),
        ),
        BlocProvider(
          create: (context) => ScheduleBloc(controller: ScheduleController()),
        ),
        BlocProvider(
          create:
              (context) => ThreadBloc(
                controller: ThreadController(),
                likeController: LikeController(),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'NutriMPASI',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('id', 'ID')],
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.accent,
          ),
        ),
        navigatorKey: navigatorKey,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is LoginSuccess) {
              return const SplashScreen(nextScreen: MainPage());
            } else if (state is AuthenticationUnauthenticated) {
              return const SplashScreen(nextScreen: OnboardingScreen());
            } else {
              return const SplashScreen();
            }
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => MainPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/password-reset') ?? false) {
            // Let DeepLinkHandler handle this via the navigatorKey
            debugPrint(
              'Ignoring /password-reset in onGenerateRoute; handled by DeepLinkHandler.',
            );
            return null;
          }
          return null;
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final int initialPage;
  final DateTime? targetDate;

  const MainPage({super.key, this.initialPage = 0, this.targetDate});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late int _page;
  Map<String, dynamic> _pageParams = {};

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
    if (widget.targetDate != null) {
      _pageParams = {'targetDate': widget.targetDate};
    }
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const FoodListScreen(),
    const ScheduleScreen(),
    const ForumScreen(),
    const SettingScreen(),
    const Center(child: Text('Settings')),
  ];

  // Fungsi untuk mengubah halaman
  void changePage(int index, {Map<String, dynamic>? additionalParams}) {
    setState(() {
      _page = index;
      _pageParams = additionalParams ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Tampilkan pesan error
            AppFlushbar.showError(
              context,
              title: 'Error',
              message: state.error,
            );
            // Tunggu sebentar lalu navigasi ke home
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                // Navigasi ke login
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          });
        } else if (state is LogoutSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Tampilkan pesan logout sukses
            AppFlushbar.showSuccess(
              context,
              title: 'Berhasil',
              message: state.message,
            );
            // Reset Baby
            context.read<BabyBloc>().add(ResetBaby());
            // Navigasi ke login
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body:
            _page == 1 && _pageParams.containsKey('showUserSuggestions')
                ? FoodListScreen(
                  showUserSuggestions: _pageParams['showUserSuggestions'],
                )
                : _page == 2 && _pageParams.containsKey('targetDate')
                ? ScheduleScreen(targetDate: _pageParams['targetDate'])
                : _screens[_page],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: AppColors.background,
          color: AppColors.primary,
          height: MediaQuery.of(context).size.height * 0.070,
          animationDuration: const Duration(milliseconds: 300),
          index: _page,
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
            Icon(
              Symbols.forum,
              color: Colors.white,
              size: _page == 3 ? 35 : 25,
            ),
            Icon(
              Symbols.settings,
              color: Colors.white,
              size: _page == 4 ? 35 : 25,
            ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
              _pageParams = {};
            });
          },
        ),
      ),
    );
  }
}
