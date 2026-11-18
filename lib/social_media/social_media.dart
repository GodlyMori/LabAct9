import 'package:flutter/material.dart';
import 'create_post_sheet.dart';
import 'post.dart';
import 'post_card.dart';

class SocialMediaPage extends StatefulWidget {
  final String username;

  const SocialMediaPage({
    super.key,
    required this.username,
  });

  @override
  State<SocialMediaPage> createState() =>
      _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  final List<Post> posts = [
    const Post(
      username: 'JohnDoe',
      caption: 'Enjoying the sunny weather!',
      imageUrl: 'https://picsum.photos/id/20/600/400',
    ),
    const Post(
      username: 'JaneSmith',
      caption: 'Just finished a great book!',
      imageUrl: 'https://picsum.photos/id/24/600/400',
    ),
  ];

  Future<void> openCreatePostSheet() async {
    final Post? newPost = await showModalBottomSheet<Post>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return CreatePostSheet(
          username: widget.username,
        );
      },
    );

    if (!mounted || newPost == null) {
      return;
    }

    setState(() {
      posts.insert(0, newPost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Media'),
      ),
      body: posts.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.feed_outlined, size: 64, color: Colors.indigo.shade200),
                  const SizedBox(height: 12),
                  const Text(
                    'No posts yet. Create one!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: posts.length,
              findChildIndexCallback: (Key key) {
                if (key is ObjectKey) {
                  final index = posts.indexOf(key.value as Post);
                  return index != -1 ? index : null;
                }
                return null;
              },
              itemBuilder: (context, index) {
                final post = posts[index];

                return PostCard(
                  key: ObjectKey(post),
                  post: post,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreatePostSheet,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        tooltip: 'Create Post',
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
