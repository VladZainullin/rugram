import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rugram/data/remote_data_sources/post/post_data_source.dart';

import 'widgets/post_previe_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 24),
                child: PostPreviewCard(
                  postPreview: posts[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
