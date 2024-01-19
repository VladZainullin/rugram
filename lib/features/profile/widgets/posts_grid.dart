import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/bloc/posts_cubit.dart';

class PostsGrid extends StatelessWidget {
  final PostsCubit postsCubit;

  const PostsGrid({super.key, required this.postsCubit});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
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
            }));
  }

}