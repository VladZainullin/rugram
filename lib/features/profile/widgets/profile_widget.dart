import 'package:flutter/cupertino.dart';
import 'package:rugram/features/profile/widgets/profile_widget_state.dart';


class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    super.key,
    required this.imageUrls,
    required this.nickname,
  });

  final List<String> imageUrls;
  final String nickname;

  @override
  ProfileWidgetState createState() => ProfileWidgetState();
}