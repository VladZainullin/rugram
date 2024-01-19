import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rugram/features/profile/profile_cubit.dart';
import 'package:rugram/features/profile/profile_state.dart';
import '../../data/remote_data_sources/profile/profile_data_source.dart';
import '../home/bloc/posts_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {

  final String userId = "60d0fe4f5311236168a109ca";

  late final ProfilePageCubit profileCubit;
  late final PostsCubit postsCubit;

  @override
  void initState() {
    postsCubit = PostsCubit(context.read())..initWithTagAsync(tag: "person");
    profileCubit = ProfilePageCubit(profileDataSource: context.read<ProfileDataSource>())..initAsync(userId: userId);

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
                                child: InkWell(
                                  onTap: () => () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Редактирование профиля'),
                                          content: Column(children: [
                                            TextFormField(
                                              controller:
                                                  state.nameController(),
                                              decoration: const InputDecoration(
                                                  labelText: 'Введите имя'),
                                            ),
                                            TextFormField(
                                              controller:
                                                  state.surnameController(),
                                              decoration: const InputDecoration(
                                                  labelText: 'Введите фамилию'),
                                            ),
                                          ]),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                profileCubit.updateAsync(
                                                    userId: userId,
                                                    name: state
                                                        .nameController()
                                                        .text,
                                                    surname: state
                                                        .surnameController()
                                                        .text);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Сохранить'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }(),
                                  child: const Center(
                                    child: Text(
                                      'Редактировать профиль',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: BlocBuilder<PostsCubit, PostsState>(
                          bloc: postsCubit,
                          builder: (context, state) {
                            return switch (state) {
                              PostsLoadedState() => GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.postsInfo.data.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      state.postsInfo.data[index].image,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    );
                                  }),
                              _ => const Center(
                                  child: CircularProgressIndicator()),
                            };
                          })),
                ],
              ));
        });
  }

  void showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.network(
              imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
