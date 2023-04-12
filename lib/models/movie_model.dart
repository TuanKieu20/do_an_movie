class MovieModel {
  double? rating;
  List<Comments>? comments;
  String? category;
  String? description;
  bool? isSub;
  String? author;
  bool? isFullHD;
  String? releaseYear;
  String? time;
  String? trailer;
  String? linkUrl;
  String? poster;
  String? name;
  String? id;

  MovieModel(
      {this.rating,
      this.comments,
      this.category,
      this.description,
      this.isSub,
      this.author,
      this.isFullHD,
      this.releaseYear,
      this.time,
      this.trailer,
      this.linkUrl,
      this.poster,
      this.name,
      this.id});

  MovieModel.fromJson(Map<String, dynamic> json, {required String? idDoc}) {
    rating = json['rating'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    category = json['category'];
    description = json['description'];
    isSub = json['isSub'];
    author = json['author'];
    isFullHD = json['isFullHD'];
    releaseYear = json['releaseYear'].toString();
    time = json['time'];
    trailer = json['trailer'];
    linkUrl = json['linkUrl'];
    poster = json['poster'];
    name = json['name'];
    id = idDoc;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['category'] = category;
    data['description'] = description;
    data['isSub'] = isSub;
    data['author'] = author;
    data['isFullHD'] = isFullHD;
    data['releaseYear'] = releaseYear;
    data['time'] = time;
    data['trailer'] = trailer;
    data['linkUrl'] = linkUrl;
    data['poster'] = poster;
    data['name'] = name;
    return data;
  }
}

class Comments {
  String? author;
  String? data;
  String? likes;
  String? avatar;

  Comments({this.author, this.data, this.likes, this.avatar});

  Comments.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    data = json['data'];
    likes = json['likes'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['author'] = author;
    data['data'] = data;
    data['likes'] = likes;
    data['avatar'] = avatar;
    return data;
  }
}


// class MovieModel {
//   double? rating;
//   List<dynamic>? comments;
//   String? category;
//   String? description;
//   bool? isSub;
//   String? author;
//   bool? isFullHD;
//   String? releaseYear;
//   String? time;
//   String? trailer;
//   String? linkUrl;
//   String? poster;
//   String? name;
//   String? id;

//   MovieModel(
//       {this.rating,
//       this.comments,
//       this.category,
//       this.description,
//       this.isSub,
//       this.author,
//       this.isFullHD,
//       this.releaseYear,
//       this.time,
//       this.trailer,
//       this.linkUrl,
//       this.poster,
//       this.name,
//       this.id});

//   MovieModel.fromJson(Map<String, dynamic> json, {idDoc}) {
//     rating = json['rating'];
//     comments = json['comments'];
//     category = json['category'];
//     description = json['description'];
//     isSub = json['isSub'];
//     author = json['author'];
//     isFullHD = json['isFullHD'];
//     releaseYear = json['releaseYear'].toString();
//     time = json['time'];
//     trailer = json['trailer'];
//     linkUrl = json['linkUrl'];
//     poster = json['poster'];
//     name = json['name'];
//     id = idDoc;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['rating'] = rating;
//     data['comments'] = comments;
//     data['category'] = category;
//     data['description'] = description;
//     data['isSub'] = isSub;
//     data['author'] = author;
//     data['isFullHD'] = isFullHD;
//     data['releaseYear'] = releaseYear;
//     data['time'] = time;
//     data['trailer'] = trailer;
//     data['linkUrl'] = linkUrl;
//     data['poster'] = poster;
//     data['name'] = name;
//     return data;
//   }
// }
