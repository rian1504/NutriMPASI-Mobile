import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/notification/notification_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/models/notification.dart' as model;
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/screens/forum/post_screen.dart';

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
    'thread': 'Postingan',
    'report': 'Laporan',
    'schedule': 'Jadwal',
  };

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
      case 'comment':
        if (notification.refersId != null && notification.refersId is int) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      PostScreen(threadId: notification.refersId as int),
            ),
          );
        } else if (notification.refersId != null &&
            notification.refersId is String) {
          try {
            final threadId = int.parse(notification.refersId.toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostScreen(threadId: threadId),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Gagal membuka postingan. ID tidak valid."),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
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
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                icon: const Icon(
                                  Symbols.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                items:
                                    _categories.map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          _categoryDisplayNames[value] ?? value,
                                          style: TextStyle(
                                            color:
                                                _selectedCategory == value
                                                    ? Colors.white
                                                    : AppColors.textBlack,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                dropdownColor: AppColors.primary,
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
