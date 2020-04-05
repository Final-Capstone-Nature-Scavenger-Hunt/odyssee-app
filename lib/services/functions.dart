
import 'package:cloud_functions/cloud_functions.dart';

class FunctionService {

  // final String uid;

  // FunctionService({this.uid});

  Future<void> likePost (String operation, String postId) async {
    final HttpsCallable updateLikes = CloudFunctions.instance.getHttpsCallable(functionName: 'likesFunction');

    dynamic resp = await updateLikes.call(<String, dynamic>{
    'operation' : operation,
    'postID' : postId
  });
  }

  Future<void> updateComment (String operation, String postId, {String comment}) async{
    final HttpsCallable updateComments = CloudFunctions.instance.getHttpsCallable(functionName: 'updateComments');

    dynamic resp = await updateComments.call(<String, dynamic>{
      'operation': 'addComment',
      'comment': comment,
      'postID': postId
    });
  }

  Future<void> followUser (String operation, String userToFollow) async {
    final HttpsCallable updateFollowers = CloudFunctions.instance.getHttpsCallable(functionName: 'followersFunction');

    dynamic resp = await updateFollowers.call(<String, dynamic>{
      'operation' : operation,
      'userToFollow' : userToFollow
    });
  }
}