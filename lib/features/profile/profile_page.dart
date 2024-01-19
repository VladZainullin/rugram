import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rugram/features/profile/bloc/profile_cubit.dart';
import 'package:rugram/features/profile/bloc/profile_state.dart';
import 'package:rugram/features/profile/widgets/edit_profile_alert.dart';
import 'package:rugram/features/profile/widgets/posts_grid.dart';
import '../../data/remote_data_sources/profile/profile_data_source.dart';
import '../home/bloc/posts_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final String userId = "60d0fe4f5311236168a109cd";

  late final ProfilePageCubit profileCubit;
  late final PostsCubit postsCubit;

  @override
  void initState() {
    postsCubit = PostsCubit(context.read())..initWithTagAsync(tag: "person");
    profileCubit = ProfilePageCubit(
        profileDataSource: context.read<ProfileDataSource>(),
        nameController: TextEditingController(text: "..."),
        surnameController: TextEditingController(text: "..."))
      ..initAsync(userId: userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
        bloc: profileCubit,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                title: Text(
                  state.fullName(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              backgroundColor: Colors.transparent,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    sliver: SliverToBoxAdapter(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                child: ClipOval(
                                    child: Image.network(
                              state.picture(),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                state.fullName(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 32,
                                width: 330,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8)),
                                child: EditProfileAlert(
                                    state: state,
                                    userId: userId,
                                    profileCubit: profileCubit),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  PostsGrid(postsCubit: postsCubit),
                ],
              ));
        });
  }
}
