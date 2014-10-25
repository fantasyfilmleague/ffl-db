'use strict';

var pg = require('pg');
var fs = require('fs');
var util = require('util');
var _ = require('underscore');

exports.createConnectionStringFromEnvironment = function () {
  var env = process.env;
  var format = 'postgres://%s:%s@%s/%s';
  return util.format(format, env.POSTGRES_USERNAME, env.POSTGRES_PASSWORD, env.POSTGRES_HOST, env.POSTGRES_DATABASE);
};

exports.getConnectionStringFromEnvironment = function () {
  var env = process.env;
  var connectionString = env.POSTGRES_CONNECTION_STRING;
  return (connectionString) ? connectionString : exports.createConnectionStringFromEnvironment();
};

var connect = exports.connect = function (connectionString, callback) {
  var effectiveConnectionString = connectionString;
  var effectiveCallback = callback;

  if (arguments.length === 1) {
    effectiveCallback = connectionString;
    effectiveConnectionString = exports.getConnectionStringFromEnvironment();
  }

  pg.connect(effectiveConnectionString, function(error, client, done) {
    if(error) {
      return effectiveCallback(error);
    }

    effectiveCallback(null, client, done);
  });
};

var query = exports.query = function (sql, params, callback) {
  var temp;
  var effectiveSql = sql;
  var effectiveParams = params;
  var effectiveCallback = callback;

  if (_.isFunction(sql.toParams)) {
    temp = sql.toParams();
    effectiveSql = temp.text;
    effectiveParams = temp.values;
    effectiveCallback = (_.isFunction(params)) ? params : callback;
  }

  connect(function (error, client, done) {
    if (error) {
      return effectiveCallback(error);
    }

    client.query(effectiveSql, effectiveParams, effectiveCallback);
  });
};

exports.queryOne = function (sql, params, callback) {
  var effectiveParams = params;
  var effectiveCallback = callback;

  if (arguments.length === 2 && _.isFunction(params)) {
      effectiveCallback = params;
      effectiveParams = null;
  }

  query(sql, effectiveParams, function (error, result) {
    if (error) {
      return callback(error);
    }

    callback(null, _.first(result.rows));
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
