'use strict';

var pg = require('pg');
var fs = require('fs');

var connect = exports.connect = function (connectionString, callback) {
  pg.connect(connectionString, function(error, client, done) {
    if(error) {
      return callback(error);
    }

    callback(null, client, done);
  });
};

function executeSqlFile(file, connectionString, callback) {
  fs.readFile(file, {encoding:'utf8'}, function (error, data) {
    if (error) {
      return callback(error);
    }

    connect(connectionString, function (error, client, done) {
      if (error) {
        return callback(error);
      }

      client.query(data, function (error, result) {
        done();
        callback(error, result);
      });
    });
  });
}

exports.createDatabase = executeSqlFile.bind(null, './sql/create.sql');
exports.deleteDatabase = executeSqlFile.bind(null, './sql/delete.sql');
exports.createSchema = executeSqlFile.bind(null, './sql/schema.sql');
