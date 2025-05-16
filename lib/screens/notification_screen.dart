import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Daftar notifikasi
  late List<NotificationModel> _notifications;

  // Kategori yang dipilih untuk filter
  String? _selectedCategory;

  // Daftar semua kategori
  final List<String> _categories = ['Semua', 'Komentar', 'Postingan', 'Ulasan'];

  @override
  void initState() {
    super.initState();
    _notifications = NotificationModel.dummyNotifications;
    _selectedCategory = 'Semua';
  }

  // Filter notifikasi berdasarkan kategori
  List<NotificationModel> get filteredNotifications {
    if (_selectedCategory == 'Semua' || _selectedCategory == null) {
      return _notifications;
    }
    return _notifications
        .where((n) => n.categoryLabel == _selectedCategory)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textBlack,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_notifications.length}',
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
      body: Column(
        children: [
          // Bar filter kategori
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      style: TextStyle(color: Colors.black, fontSize: 14),
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
                                value,
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
                          unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
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
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              notification.isRead = true;
                            });
                            // TODO: Implementasi aksi ketika notifikasi ditekan
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  notification.isRead
                                      ? AppColors.background
                                      : AppColors.bisque,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    notification.icon,
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
                                        notification.message,
                                        style: TextStyle(
                                          fontWeight:
                                              notification.isRead
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Lihat ${notification.categoryLabel.toLowerCase()}',
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
    );
  }
}
