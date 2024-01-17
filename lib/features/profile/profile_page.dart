import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rugram/features/profile/widgets/profile_widget.dart';
import '../../data/remote_data_sources/profile/profile_data_source.dart';
import '../../domain/models/user_preview.dart';
import '../home/bloc/posts_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late final ProfileDataSource profileDataSource;
  late TabController tabController;
  late final PostsCubit postsCubit;
  TextEditingController nameController = TextEditingController();
  String nickname = "...";
  late UserPreview user;
  List<String> imageUrls = [];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            nickname,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: const [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_box_outlined,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.table_rows_rounded,
                    size: 30,
                  ),
                ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              sliver: SliverToBoxAdapter(
                child: ProfileWidget(
                  imageUrls: imageUrls,
                  nickname: nickname,
                ),
              ),
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
                            onTap: () => _editProfile(),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Center(
                            child: Icon(
                              Icons.person_add,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.video_collection_outlined)),
                  Tab(icon: Icon(Icons.person_add_alt_outlined)),
                ],
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: tabController,
                children: [
                  BlocBuilder<PostsCubit, PostsState>(
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
                          _ => const Center(child: CircularProgressIndicator()),
                        };
                      }),
                  const Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Icon(
                          Icons.person_add,
                          color: Colors.black,
                          size: 60,
                        ),
                        Text(
                          "Фотографии и видео с Вами",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    postsCubit = PostsCubit(context.read())..initWithTag(tag: "person");
    profileDataSource = context.read<ProfileDataSource>();
    init();
    // loadImages();
  }

  Future<void> init() async {
    final usersInfo = await profileDataSource.getProfiles();
    user = usersInfo.data[10];
    nickname = user.firstName;
    setState(() {});
  }

  Future<void> update({required String name}) async {
    final updatedUser = await profileDataSource.updateProfile(profileId: user.id, name: name);
    nickname = updatedUser.firstName;
    setState(() {});
  }

  void _editProfile() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактирование профиля'),
          content: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Новое имя'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: ()
              {
                update(name: nameController.text);
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
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
