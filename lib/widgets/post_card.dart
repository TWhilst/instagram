import 'package:flutter/material.dart';
import 'package:instagram_clone/models/users.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
 late final Users user;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // DateTime.parse is used to convert from string to datetime
    final dateTime = DateTime.parse(widget.snap["datePublished"]);
    user = Provider.of<UserProvider>(context).getUser;

    /// Header Section
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
              child: Row(
                children: [
                   CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                        widget.snap["profilepic"],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        // The height of the Column will be according to the combined height of its children and incoming height from the parent (that is the remaining space) will be ignored.
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            widget.snap["username"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16,),
                          // this is used to make sure that the listview occupies the space it needs
                          shrinkWrap: true,
                          children: [
                            "Delete",
                            "Remove"
                          ].map((e) => InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16,),
                              child: Text(e),
                            ),
                          )).toList(),
                        )
                      ));
                    },
                    icon: const Icon(Icons.more_vert,),
                  ),
                ],
              ),
          ),

          /// Image Section

          // GestureDetector has a lot of contents unlike InkWell
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;


              });
              await FirestoreMethods().likePost(
                user.uid,
                widget.snap["likes"],
                widget.snap["postid"],);

            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: screenSize.height*0.35,
                  // this means that the width is the entire width
                  width: double.infinity,
                  child: Image.network( widget.snap["posturl"],
                  fit: BoxFit.cover,
                  ),
                ),

                AnimatedOpacity(
                  // this shows how long the animation will stay
                  duration: const Duration(milliseconds: 200),
                  // the one is when it will be visible and the 0 is when it will not
                  opacity: isLikeAnimating? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(Icons.favorite, color: Colors.white, size: 120,),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = true;
                      });
                    }
                  ),
                ),
              ],
            ),
          ),

          /// Like Comment Section
          Row(
            children: [
              LikeAnimation(
                // snap["likes"].contain(user.uid) is to check if the likes contains the user id or not
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_outlined,
                  ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),)
            ],
          ),

          /// Description And Number of Comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  child: Text(
                    "${widget.snap["likes"].length} likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8,),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        TextSpan(
                          text: " ${widget.snap["description"]}"
                        )
                      ]
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all 200 comments",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    // this is used to set the format of the datetime
                    DateFormat.yMMMd().format(dateTime),
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}