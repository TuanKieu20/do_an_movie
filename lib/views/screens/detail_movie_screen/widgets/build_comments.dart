import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../constants/styles.dart';
import '../../../../models/movie_model.dart';
import '../../../helpers/helper.dart';

class BuildComments extends StatelessWidget {
  const BuildComments(
      {Key? key,
      required this.movie,
      required this.index,
      this.isShowAll = false})
      : super(key: key);

  final MovieModel movie;
  final int index;
  final bool isShowAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              movie.comments![movie.comments!.length - 1 - index].avatar == ''
                  ? const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/personal.png'))
                  : CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blueGrey,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: CachedNetworkImageProvider(
                          movie.comments![movie.comments!.length - 1 - index]
                              .avatar!,
                          errorListener: () => Image.asset(
                            'assets/images/image_error.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // backgroundImage: NetworkImage(
                        // movie
                        //     .comments![
                        //         movie.comments!.length - 1 - index]
                        //     .avatar!,
                        // ),
                      ),
                    ),
              const SizedBox(width: 10),
              Text(
                movie.comments![movie.comments!.length - 1 - index].author!,
                style: mikado500,
              ),
              const Spacer(),
              IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => Helper.showDialogFuntionLoss(),
                  icon: const Icon(
                    Icons.pending_outlined,
                    color: Colors.white,
                    size: 28,
                  ))
            ],
          ),
          const SizedBox(height: 10),
          Text(
            Helper.validateRestrictedWord(
                movie.comments![movie.comments!.length - 1 - index].data!),
            style: mikado400.copyWith(fontSize: 14, color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                movie.comments![movie.comments!.length - 1 - index].likes!,
                style: mikado500.copyWith(fontSize: 14),
              )
            ],
          ),
          if (index == movie.comments!.length - 1)
            SizedBox(height: isShowAll ? 150 : 20)
        ],
      ),
    );
  }
}
