import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rugram/data/remote_data_sources/post/post_data_source.dart';
import 'package:rugram/domain/models/post_preview.dart';
import 'package:rugram/ui/components/cached_network_image_component.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    final posts = await context.read<PostDataSource>().getPosts();
    log(posts.toString());
    // final dio = Dio(
    //   BaseOptions(
    //     baseUrl: 'https://dummyapi.io/data/v1/',
    //     headers: {
    //       'app-id': '652a56c27041f5843719941b',
    //     },
    //   ),
    // );

    // dio.get('/post')..then(
    //       (value) => log(
    //         value.toString(),
    //       ),
    //     )..onError((error, stackTrace) => null)..whenComplete(() => null);

    // try {
    //   final response = await dio.get('/post');
    //   // final response = await dio.get('/pos');
    //
    //   log(response.toString());
    // } on DioException catch (e) {
    //   log(e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.add),
        title: Text('AppBar'),
        actions: [
          Icon(Icons.add_card_outlined),
          Icon(Icons.read_more),
          Icon(Icons.read_more),
          Icon(Icons.read_more),
        ],
      ),
      body: FutureBuilder(
        future: context.read<PostDataSource>().getPosts(),
        builder: (context, snapshot) {
          final posts = snapshot.data?.data;

          if (posts == null) {
            return const SizedBox.shrink();
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostPreviewCard(
                postPreview: posts[index],
              );
            },
          );
        },
      ),
    );
  }
}

class PostPreviewCard extends StatelessWidget {
  final PostPreview postPreview;

  const PostPreviewCard({
    required this.postPreview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImageComponent(
                        url: postPreview.owner.picture,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postPreview.owner.firstName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(postPreview.owner.lastName),
                      ],
                    ),
                  ),
                ],
              ),
              Icon(Icons.more_horiz),
            ],
          ),
        ),
        CachedNetworkImageComponent(
          url: postPreview.image,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ],
    );
  }
}
