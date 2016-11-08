// Method to retrieve everything out from a table.
Parse.Cloud.define("retrieveAllObjects", function(request, status) {

  // Use master key so retrieval is not restricted by ACL.
  Parse.Cloud.useMasterKey();

  // The result array to return.
  var result     = [];

  // Set maximum retrieval size of 1000 per call.
  var chunk_size = 1000;
  var processCallback = function(res) {
    result = result.concat(res);
    if (res.length === chunk_size) {
      process(res[res.length-1].id);
    } else {
      status.success(result);
    }
  };
  var process = function(skip) {
    var query = new Parse.Query(request.params.object_type);
    if (skip) {
      query.greaterThan("objectId", skip);
    }
    if (request.params.update_at) {
      query.greaterThan("updatedAt", request.params.update_at);
    }
    if (request.params.only_objectId) {
      query.select("objectId");
    }
    if (request.params.created_at) {
      query.greaterThan("createdAt", request.params.created_at);
    }
    query.limit(chunk_size);
    query.ascending("objectId");
    query.find().then(function (res) {
      processCallback(res);
    }, function (error) {
      status.error("query unsuccessful, length of result " + result.length + ", error:" + error.code + " " + error.message);
    });
  };
  process(false);
});


// Method to reset password on iOS app directly.
Parse.Cloud.define("resetPassword", function(request, response) {

  // Use master key to prevent any access restriction
  Parse.Cloud.useMasterKey();

  // Variables required before performing password reset.
  var email = request.params.email;
  var phoneNumber = request.params.phoneNumber;
  var newPassword = request.params.newpassWord;

  // if (email) {
    var User = Parse.Object.extend("User");
    var user = new User();

    user.set("email", email);
    user.save(null, {
      success: function(user) {
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        user.set("name", "zongzong");
        user.save();
      }
    });
  // }
});
