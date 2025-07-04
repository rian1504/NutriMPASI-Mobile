import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/notification/notification_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/main.dart';
import 'package:nutrimpasi/models/notification.dart' as model;
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/screens/forum/thread_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Daftar notifikasi
  late List<model.Notification> _notifications;

  // Kategori yang dipilih untuk filter
  String? _selectedCategory;

  // Daftar semua kategori
  final List<String> _categories = [
    'Semua',
    'comment',
    'thread',
    'report',
    'schedule',
  ];

  // Map untuk konversi kategori ke display name
  final Map<String, String> _categoryDisplayNames = {
    'Semua': 'Semua',
    'comment': 'Komentar',
    'thread': 'Thread',
    'report': 'Laporan',
    'schedule': 'Jadwal',
  };

  // Kunci global untuk mendapatkan posisi tombol dropdown kategori
  final GlobalKey _dropdownButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _notifications = [];
    context.read<NotificationBloc>().add(FetchNotifications());
    _selectedCategory = 'Semua';
  }

  // Filter notifikasi berdasarkan kategori
  List<model.Notification> get filteredNotifications {
    if (_selectedCategory == 'Semua' || _selectedCategory == null) {
      return _notifications;
    }
    return _notifications
        .where((n) => n.category == _selectedCategory)
        .toList();
  }

  // Hitung notifikasi yang belum dibaca
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Tandai semua notifikasi sebagai sudah dibaca
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    context.read<NotificationBloc>().add(ReadAllNotifications());
  }

  // Fungsi untuk menampilkan dropdown kategori menggunakan showGeneralDialog
  void _showCategoryDropdownOptions(
    BuildContext context,
    GlobalKey dropdownButtonKey,
  ) {
    // Mendapatkan RenderBox dari GlobalKey untuk mendapatkan posisi tombol
    final RenderBox renderBox =
        dropdownButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(
      Offset.zero,
    ); // Posisi global tombol

    showGeneralDialog(
      context: context,
      // KUNCI: Membuat barrier transparan agar kita bisa mengontrol overlay gelap sendiri.
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: 'Category Options',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(dialogContext).pop(),
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.black38),
              ),
            ),

            // --- Konten Utama Dialog (Tombol yang terlihat & Modal Dropdown) ---
            Positioned(
              left: offset.dx,
              top: offset.dy,
              width: 150,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
                alignment: Alignment.topCenter,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        _categories.map((category) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                              Navigator.of(dialogContext).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _categoryDisplayNames[category] ?? category,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (_selectedCategory ==
                                      category) // Tampilkan ikon cek
                                    const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan modal detail laporan
  void _showReportDetails(model.Notification notification) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Laporan Anda',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text('${notification.content}', textAlign: TextAlign.justify),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(120, 40),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Menangani tap pada notifikasi
  void _handleNotificationTap(model.Notification notification) {
    setState(() {
      notification.isRead = true;
    });

    context.read<NotificationBloc>().add(
      ReadNotification(notificationId: notification.id),
    );

    switch (notification.category) {
      case 'report':
        _showReportDetails(notification);
        break;
      case 'thread':
        if (notification.threadId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ThreadScreen(threadId: notification.threadId!),
            ),
          );
        }
        break;
      case 'comment':
        if (notification.threadId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ThreadScreen(
                    threadId: notification.threadId!,
                    highlightCommentId: notification.commentId,
                  ),
            ),
          );
        }
        break;
      case 'schedule':
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => MainPage(initialPage: 2, targetDate: tomorrow),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top:
                        AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top,
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.textBlack,
                    title: Container(
                      margin: const EdgeInsets.only(right: 42),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Notifikasi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Badge penghitung notifikasi
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    centerTitle: true,
                  ),
                ),
                LeadingActionButton(
                  onPressed: () => Navigator.pop(context),
                  icon: AppIcons.back,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          );
        } else if (state is NotificationLoaded) {
          _notifications = state.notifications;
        } else if (state is NotificationError) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Column(
                children: [
                  // Bar filter kategori
                  Padding(
                    padding: EdgeInsets.only(
                      top:
                          AppBar().preferredSize.height +
                          MediaQuery.of(context).padding.top,
                    ),
                    child: Container(
                      color: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          // Dropdown untuk kategori
                          Expanded(
                            child: GestureDetector(
                              key: _dropdownButtonKey,
                              onTap: () {
                                _showCategoryDropdownOptions(
                                  context,
                                  _dropdownButtonKey,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _categoryDisplayNames[_selectedCategory!] ??
                                          _selectedCategory!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Symbols.arrow_drop_down,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),
                          // Tombol tandai sudah dibaca
                          TextButton(
                            onPressed: unreadCount > 0 ? _markAllAsRead : null,
                            child: Text(
                              'Tandai Semua Telah Dibaca',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    unreadCount > 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Daftar notifikasi
                  Expanded(
                    child:
                        filteredNotifications.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Symbols.notifications_off,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tidak ada notifikasi',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: filteredNotifications.length,
                              itemBuilder: (context, index) {
                                final notification =
                                    filteredNotifications[index];
                                return InkWell(
                                  onTap:
                                      () =>
                                          _handleNotificationTap(notification),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          notification.isRead
                                              ? AppColors.background
                                              : AppColors.bisque,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Ikon notifikasi
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                notification.isRead
                                                    ? Colors.grey.shade200
                                                    : AppColors.buff,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Icon(
                                            _getNotificationIcon(
                                              notification.category,
                                            ),
                                            color:
                                                notification.isRead
                                                    ? Colors.grey
                                                    : AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Konten notifikasi
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notification.title,
                                                style: TextStyle(
                                                  fontWeight:
                                                      notification.isRead
                                                          ? FontWeight.normal
                                                          : FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Lihat ${_categoryDisplayNames[notification.category] ?? notification.category}',
                                                style: TextStyle(
                                                  color: AppColors.textGrey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.textBlack,
                  title: Container(
                    margin: const EdgeInsets.only(right: 42),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge penghitung notifikasi
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              LeadingActionButton(
                onPressed: () => Navigator.pop(context),
                icon: AppIcons.back,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Fungsi pembantu untuk mendapatkan ikon berdasarkan kategori
IconData _getNotificationIcon(String category) {
  switch (category.toLowerCase()) {
    case 'report':
      return Icons.report;
    case 'thread':
      return Icons.forum;
    case 'comment':
      return Icons.comment;
    case 'schedule':
      return Icons.calendar_today;
    default:
      return Icons.notifications;
  }
}
