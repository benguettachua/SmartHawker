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

// Method to retrieve everything out from a table, SORTED BY UPDATED_AT.
Parse.Cloud.define("retrieveAllObjectsSortedByUpdatedAt", function(request, status) {

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
    query.descending("updatedAt");
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
Parse.Cloud.define("resetPassword", function(request, status) {
  Parse.Cloud.useMasterKey();

  var user = Parse.Object.extend("User");
  var query = new Parse.Query(user);
  if (request.params.email) {
    query.equalTo("email", request.params.email);
  }
  if (request.params.username) {
    query.equalTo("username", request.params.username);
  }

  query.first({
    success: function (Contact) {
      Contact.save(null, {
        success: function (contact) {
          contact.set("password", request.params.password);
          contact.save();
          status.success(true);
        }
      });
    }
  });

});


Parse.Cloud.define("adminLogin", function(request, status) {

  var user = Parse.Object.extend("User");
  var query = new Parse.Query(user);
  if (request.params.username=="admin" && request.params.password=="admin2345" ) {
    status.success(true);

  }else{
    status.success(false);
  }
});

// Deletes a user and all of his records.
Parse.Cloud.define("deleteUser", function(request, status){

  var record = Parse.Object.extend("Record");
  var user = Parse.Object.extend("User");

  var recordQuery = new Parse.Query(record);
  var userQuery = new Parse.Query(user);

  if (request.params.email) {
    userQuery.equalTo("email", request.params.email);
  }
  if (request.params.username) {
    userQuery.equalTo("username", request.params.username);
  }

  var username = "";
  userQuery.first({
    success: function(userToDelete) {
      username = userToDelete.get('username');
      userToDelete.destroy({});

      recordQuery.equalTo("subuser", username);
      recordQuery.find({
        success: function(results) {
          for (var i = 0; i < results.length; i++) {
            var record = results[i];
            record.destroy({});
          }
          status.success(true);
        }
      })
    }
  });
});
