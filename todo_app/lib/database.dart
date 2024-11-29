import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'datamodel.dart';
import 'dart:io';
import 'dart:async';


class Dbprovider{

  static Future <void> createTables(sql.Database database) async
  {
    await database.execute("""
           CREATE TABLE info
           (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              task Text,
              about_task Text,
              hour Text,
              min Text,
              day_night Text,
              date Text,
              score INTEGER
              createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
           )"""
    );
  }
  //initialize database
  static Future <sql.Database> db() async
  {
    return sql.openDatabase(
        "database_name.db",
        version: 2,
        onCreate: (sql.Database database, int version) async
        {
          await createTables(database);
        }
    );
  }

  //insertion ops
  static Future<int> addItem(String task,String desc,String hour,String min,String day_night,String date,int score) async
  {
    final db = await Dbprovider.db();
    final data = {'task' :task,
      'about_task' :desc,
      'hour' :hour,
      'min' :min,
      'day_night' :day_night,
      'date' :date,
      'score' :score,
    };
    final id = await db.insert('info', data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);
    return id;
  }

  static Future<List<dataModel>> read_with_date(String date) async //getting all user information
   {
    final db=await Dbprovider.db();
    final List<Map<String,dynamic>>maps;
    maps = await db.query("info" ,where: "date=?" ,whereArgs: [date], orderBy:"score ASC");

    return List.generate(maps.length, (i){
      var dataModel2 = dataModel(task: maps[i]['task'],
          about_task: maps[i]['about_task'],
          hour: maps[i]['hour'],
          min: maps[i]['min'],
          day_night: maps[i]['day_night'],
          date: maps[i]['date'],
        score: maps[i]['score']
      );
      return dataModel2;
    });
  }

  static Future<List<dataModel>> read_except_date(String date) async //getting all user information
      {
    final db=await Dbprovider.db();
    final List<Map<String,dynamic>>maps;
    maps = await db.query("info" ,where: "date!=?" ,whereArgs: [date], orderBy:"score ASC" );

    return List.generate(maps.length, (i){
      var dataModel2 = dataModel(task: maps[i]['task'],
          about_task: maps[i]['about_task'],
          hour: maps[i]['hour'],
          min: maps[i]['min'],
          day_night: maps[i]['day_night'],
          date: maps[i]['date'],
          score: maps[i]['score']
      );
      return dataModel2;
    });
  }

  static Future<List<dataModel>> read_for_auto_del(String date, int score) async //getting all user information
      {
    final db=await Dbprovider.db();
    final List<Map<String,dynamic>>maps;
    maps = await db.query("info" ,where: "date=? and score<?" ,whereArgs: [date,score]);

    return List.generate(maps.length, (i){
      var dataModel2 = dataModel(task: maps[i]['task'],
          about_task: maps[i]['about_task'],
          hour: maps[i]['hour'],
          min: maps[i]['min'],
          day_night: maps[i]['day_night'],
          date: maps[i]['date'],
          score: maps[i]['score']
      );
      return dataModel2;
    });
  }

  static Future<int> updateinfo(String task, String desc,String hour,String min,String day_night,String date) async
  {
    final db = await Dbprovider.db();
    final data = {'task' :task,
      'about_task' :desc,
    };
    return await db.update("info",data, where: "hour=? and min=? and day_night=? and date=?",whereArgs: [hour,min,day_night,date]);

  }

  static Future<int> delete(String hour,String min,String day_night, String date) async
  {
    final db = await Dbprovider.db();
    return await db.delete('info',where: "hour=? and min=? and day_night=? and date=?",whereArgs: [hour,min,day_night,date]);
  }

  static Future<int> auto_delete(String date,int score) async
  {
    final db = await Dbprovider.db();
    return await db.delete('info',where: "date=? and score<?",whereArgs: [date,score]);
  }
  static Future<int> delete_date(String date) async
  {
    final db = await Dbprovider.db();
    return await db.delete('info',where: "date=?",whereArgs: [date]);
  }
}