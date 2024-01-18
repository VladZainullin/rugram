import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/remote_data_sources/profile/profile_data_source.dart';
import '../home/bloc/posts_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {

  late final ProfileDataSource profileDataSource;

  late final PostsCubit postsCubit;

  late final String userId;
  late final String userFullName;

  late TextEditingController nameController;
  late TextEditingController surnameController;

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
            userFullName,
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
                            userFullName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                )
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
                      _ => const Center(child: CircularProgressIndicator()),
                    };
                  })
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    postsCubit = PostsCubit(context.read())..initWithTag(tag: "person");
    profileDataSource = context.read<ProfileDataSource>();
    init();
  }

  Future<void> init() async {
    final usersInfo = await profileDataSource.getProfiles();
    final user = usersInfo.data[10];

    userFullName = user.fullName;
    userId = user.id;

    nameController = TextEditingController(text: user.firstName);
    surnameController = TextEditingController(text: user.lastName);

    setState(() {});
  }

  Future<void> update({required String name, required String surname}) async {
    final user = await profileDataSource.updateProfile(profileId: userId, name: name, surname: surname);

    userFullName = user.fullName;
    userId = user.id;

    nameController = TextEditingController(text: user.firstName);
    surnameController = TextEditingController(text: user.lastName);

    setState(() {});
  }

  void _editProfile() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактирование профиля'),
          content: Column(children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Введите имя'),
            ),
            TextFormField(
              controller: surnameController,
              decoration: const InputDecoration(labelText: 'Введите фамилию'),
            ),
          ]),
          actions: <Widget>[
            TextButton(
              onPressed: ()
              {
                update(name: nameController.text, surname: surnameController.text);
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
