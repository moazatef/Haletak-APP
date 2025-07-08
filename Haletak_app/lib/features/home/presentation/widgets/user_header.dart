import 'dart:io';

import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/home/presentation/screens/notification_screen.dart';
import 'package:aluna/features/home/presentation/widgets/clip_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/user_model.dart';

class UserHeader extends StatefulWidget {
  final User user;

  const UserHeader({super.key, required this.user});

  @override
  _UserHeaderState createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  File? _selectedImage;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadSavedImagePath();
  }

  Future<void> _loadSavedImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profileImagePath');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _selectedImage = File(path);
        _imagePath = path;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    const fileName = 'profile.jpg';
    final savedImage =
        await File(pickedFile.path).copy('${appDir.path}/$fileName');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', savedImage.path);

    setState(() {
      _selectedImage = savedImage;
      _imagePath = savedImage.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEE, MMM d').format(DateTime.now());

    ImageProvider profileImage;

    if (_selectedImage != null) {
      profileImage = FileImage(_selectedImage!);
    } else if (widget.user.profileImageUrl.isNotEmpty) {
      profileImage = NetworkImage(widget.user.profileImageUrl);
    } else {
      profileImage = const AssetImage('assets/images/default_avatar.png');
    }

    return Stack(
      children: [
        ClipPath(
          clipper: BarClipper(),
          child: Container(
            height: 220.h,
            color: ColorStyles.mainColor,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Date and Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white,
                          size: 16.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          formattedDate,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.circle_notifications_outlined,
                        color: Colors.white,
                        size: 28.h,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ✅ Profile Section
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 30.r,
                        backgroundImage: profileImage,
                        backgroundColor: Colors.grey.shade300,
                        child: _selectedImage == null
                            ? const Icon(Icons.camera_alt,
                                color: Colors.white, size: 24)
                            : null,
                      ),
                    ),
                    SizedBox(width: 16.w),

                    // ✅ User Name & Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${widget.user.username}",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: ColorStyles.backgroundColor,
                                size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              widget.user.status,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            SizedBox(width: 16.w),
                            const Icon(Icons.local_fire_department,
                                color: ColorStyles.backgroundColor, size: 16),
                            SizedBox(width: 4.w),
                            Text(
                              widget.user.energy,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            SizedBox(width: 16.w),
                            const Icon(Icons.emoji_emotions,
                                color: ColorStyles.backgroundColor, size: 16),
                            SizedBox(width: 4.w),
                            Text(
                              widget.user.mood,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
