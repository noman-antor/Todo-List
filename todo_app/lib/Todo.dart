import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:todo_app/Add.dart';
import 'package:todo_app/edit.dart';
import 'database.dart';

/*DateFormat hour=new DateFormat("HH");
         DateFormat min=new DateFormat("mm");
         String x=hour.format(DateTime.now());
         print(x);*/

class Todo extends StatefulWidget {

  int chage_state=0;
  String date_track="";
  @override
  Todo_state createState() => Todo_state();
}

class Todo_state extends State<Todo> {

  List<String> task = [];
  List<String> desc = [];
  List<String> hour = [];
  List<String> min = [];
  List<String> day_night = [];
  List<String> date = [];

  String get_date_now() {
    DateFormat dt = new DateFormat("yyyy-MM-dd");
    String date = dt.format(DateTime.now());
    return date;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prev_date_deletion();
    auto_deletion();
  }
  void prev_date_deletion() async
  {
    DateFormat dt_new=new DateFormat("yyyy-MM-dd");
    String dt_prev=dt_new.format(DateTime.now().subtract(Duration(days: 1)));
    await Dbprovider.delete_date(dt_prev);
  }
  void auto_deletion() async
  {
    DateFormat hour_now=new DateFormat("HH");
    DateFormat min_now=new DateFormat("mm");
    DateFormat dt=new DateFormat("yyyy-MM-dd");
    String dt_now=dt.format(DateTime.now());
    String x=hour_now.format(DateTime.now());
    String y=min_now.format(DateTime.now());
    int xx=int.parse(x)*60;
    int yy=int.parse(y);
    int score_now=xx+yy;
    var number=await Dbprovider.read_for_auto_del(dt_now, score_now);
    int c=number.length;
    if(number.length>0)
      {
        await Dbprovider.auto_delete(dt_now, score_now);
        setState(() {
          task = [];
          desc = [];
          hour = [];
          min = [];
          day_night = [];
          date=[];
        });
        if(widget.chage_state==0)
          {
            read();
          }
        else
          {
            read_for_later();
          }
        final snackBar=SnackBar(content:Text("Auto Deletion Performed for $c Schedule",
            style: TextStyle(color: Colors.black,fontFamily: "Times New Roman")),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: "UNDO",
            onPressed: (){},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    else
      {
        if(widget.chage_state==0)
        {
          read();
        }
        else
        {
          read_for_later();
        }
      }
  }
  void read() async{
    var getting=await Dbprovider.read_with_date(get_date_now());
    for(int i=0;i<getting.length;i++)
    {
      setState(() {
        task.add(getting[i].task);

        desc.add(getting[i].about_task);

        hour.add(getting[i].hour);

        min.add(getting[i].min);

        day_night.add(getting[i].day_night);

        date.add(getting[i].date);

      });

    }
  }
  void read_for_later() async{
    var getting=await Dbprovider.read_except_date(get_date_now());
    for(int i=0;i<getting.length;i++)
    {
      setState(() {
        task.add(getting[i].task);

        desc.add(getting[i].about_task);

        hour.add(getting[i].hour);

        min.add(getting[i].min);

        day_night.add(getting[i].day_night);

        date.add(getting[i].date);

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title:Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Daily Activities",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontFamily: "Times New Roman",
                      fontSize: 25)),
              SizedBox(width: 35,),
              IconButton(onPressed: (){
                showexit(context);
              }, icon: Icon(Icons.exit_to_app_sharp),color: Colors.blueAccent,iconSize: 30,)
            ],
          ),
        ),
        elevation: 20,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Add()));
          }),
      body: RefreshIndicator(
        onRefresh: (){
          return Future.delayed(Duration(seconds: 1),(){
            setState(() {
              task = [];
              desc = [];
              hour = [];
              min = [];
              day_night = [];
              date=[];
              auto_deletion();
              //read_for_later();
            });
          });
        },
        child:Container(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Today",
                            style: TextStyle(
                                fontFamily: "Times New Roman",
                                fontSize: 22,
                                color: Colors.black,),

                          ),

                          onTap: () {
                            setState(() {
                              widget.chage_state=0;
                              task = [];
                              desc = [];
                              hour = [];
                              min = [];
                              day_night = [];
                              date=[];
                            });
                            read();
                          },

                        ),
                        GestureDetector(
                          child: Text(
                            "For Later",
                            style: TextStyle(
                                fontFamily: "Times New Roman",
                                fontSize: 22,
                                color: Colors.black),
                          ),
                          onTap: () {
                            setState(() {
                              widget.chage_state=1;
                              task = [];
                              desc = [];
                              hour = [];
                              min = [];
                              day_night = [];
                              date=[];
                            });
                            read_for_later();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RefreshIndicator(
                    onRefresh: (){
                      return Future.delayed(Duration(seconds: 1),(){
                        setState(() {
                          task = [];
                          desc = [];
                          hour = [];
                          min = [];
                          day_night = [];
                          date=[];
                          auto_deletion();
                          //read_for_later();
                        });
                      });
                    },
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: task.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item=task[index];
                          return Dismissible(
                            key: Key(item),
                            onDismissed: (direction)
                            {
                              Dbprovider.delete(hour[index], min[index], day_night[index], date[index]);
                              setState(() {
                                task.removeAt(index);
                                desc.removeAt(index);
                                hour.removeAt(index);
                                min.removeAt(index);
                                day_night.removeAt(index);
                                date.removeAt(index);
                              });
                            },
                            child:Container(
                                decoration: BoxDecoration(
                                border:
                                Border(bottom: BorderSide(color: Colors.black))),
                            child: ListTile(
                              leading: Container(
                                width: 140,
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task[index], style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text(desc[index],style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14),),
                                    Text(date[index],style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14),),
                                  ],
                                ),
                              ),
                              title: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(hour[index],style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 15)),
                                    Text(":",style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 15)),
                                    Text(min[index],style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 15)),
                                    Text(day_night[index],style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 15)),
                                    SizedBox(width: 30,),
                                    IconButton(onPressed: (){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>edit(
                                        task[index],desc[index],
                                        hour[index],min[index],day_night[index],date[index])));

                                    }, icon: Icon(Icons.edit_rounded),color: Colors.blueAccent),
                                  ],
                                ),
                              ),
                            ),
                          )
                          );
                        }
                      ),
                  )
                ],
              )
            )
        ),
      )
    );
  }

  showexit(BuildContext context)
  {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(title: Text("Are you sure want to Exit?",style: TextStyle(color: Colors.blueAccent,
          fontFamily: "Times New Roman",fontSize: 20),),
        icon: Icon(Icons.android_outlined,size: 50,color: Colors.blueAccent),

        content: Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child:Text("Yes",style: TextStyle(color: Colors.blueAccent,
                      fontFamily: "Times New Roman",fontSize: 20)),
                  onTap: (){
                    SystemNavigator.pop();
                  },
                ),
                GestureDetector(
                  child:Text("No",style: TextStyle(color: Colors.blueAccent,
                      fontFamily: "Times New Roman",fontSize: 20)),
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                )
              ]
          ),
        ),);
    });
  }
}
