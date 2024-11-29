import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/datamodel.dart';
import 'database.dart';
import 'datamodel.dart';
import 'Todo.dart';


import 'package:flutter/material.dart';
class Add extends StatefulWidget
{
  TextEditingController take_title=TextEditingController();
  TextEditingController take_desc=TextEditingController();
  TextEditingController date=TextEditingController();
  @override
  Add_ createState ()=> Add_();

}
class Add_ extends State<Add>
{
  List<String> hour=["01","02","03","04","05","06","07","08","09","10","11","12"];

  List<String> min=["00","01","02","03","04","05","06","07","08","09","10",
                    "11","12","13","14","15","16","17","18","19","20",
                    "21","22","23","24","25","26","27","28","29","30",
                    "31","32","33","34","35","36","37","38","39","40",
                    "41","42","43","44","45","46","47","48","49","50",
                    "51","52","53","54","55","56","57","58","59",];

  List<String> day_night=["AM","PM"];



  String dropdown_hour_value="12";
  String dropdown_min_value="00";

  String dropdown_AM_or_PM="AM";
  
  Future<void> additem(String task, String desc,String hour,String min,String day_night,String date,int score) async
  {
    if(task.isEmpty || desc.isEmpty || date.isEmpty)
      {
        print(date);
        final snackBar=SnackBar(content:Text("Ooopsss! There is something missing",
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
        print(date);
        await Dbprovider.addItem(task, desc, hour, min, day_night, date, score);
      }

  }
  
  /*Future<void> read() async
  {
    print("Database Reading......");
    var getting=await Dbprovider.readall();
    print(getting.length);
    for(int i=0;i<getting.length;i++)
      {
        print(getting[i].task);
        print(" ");
        print(getting[i].about_task);
      }

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
      child:Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            //space for giving title
            Text(" Task?",style: TextStyle(color: Colors.black,
                fontFamily: "Times New Roman",fontSize: 20),),
            SizedBox(height:10),
            TextField(
              maxLength: 10,
              controller: widget.take_title,
              style: TextStyle(fontFamily: "Times New Roman",color: Colors.blueAccent),
              decoration: InputDecoration(
                  filled: true,
                  border: UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: ()
                    {
                      widget.take_title.clear();
                    },
                  )
              ),
            ),
            SizedBox(height: 20),
            Text(" About Task?",style: TextStyle(color: Colors.black,
                fontFamily: "Times New Roman",fontSize: 20),),
            SizedBox(height:10),
            //space for giving description
            TextField(
              maxLength: 15,
              controller: widget.take_desc,
              style: TextStyle(fontFamily: "Times New Roman",color: Colors.blueAccent),
              decoration: InputDecoration(
                  filled: true,
                  border: UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: ()
                    {
                      widget.take_desc.clear();
                    },
                  )
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Row(
                children: [
                  Text(" When?",style: TextStyle(color: Colors.black,
                      fontFamily: "Times New Roman",fontSize: 20),),
                  SizedBox(width: 20,),
                  //For hour menu
                  DropdownButton(
                      value: dropdown_hour_value,
                      style: TextStyle(color: Colors.black,
                          fontFamily: "Times New Roman",fontSize: 18),
                      onChanged:(String? newvalue){
                        setState(() {
                          dropdown_hour_value=newvalue!;
                        });},
                      items: hour.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),

                  ),
                  SizedBox(width: 20,),
                  //For Minute menu
                  DropdownButton(
                    value: dropdown_min_value,
                    style: TextStyle(color: Colors.black,
                        fontFamily: "Times New Roman",fontSize: 18),
                    onChanged:(String? newvalue){
                      setState(() {
                        dropdown_min_value=newvalue!;
                      });},
                    items: min.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),

                  ),
                  SizedBox(width: 20,),
                  DropdownButton(
                    value: dropdown_AM_or_PM,
                    style: TextStyle(color: Colors.black,
                        fontFamily: "Times New Roman",fontSize: 18),
                    onChanged:(String? newvalue){
                      setState(() {
                        dropdown_AM_or_PM=newvalue!;
                      });},
                    items: day_night.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            //Date operation
            SizedBox(height: 30),
            Text(" Select Date? :",style: TextStyle(color: Colors.black, fontFamily: "Times New Roman",fontSize: 18)),
            SizedBox(
              width: 250,
              child: TextField(
                  controller: widget.date,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today), onPressed: () {  },
                    ),

                  ),
                  readOnly : true,
                  onTap: () async
                  {
                    DateTime? datechoose=await showDatePicker(context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101)
                    );
                    if(datechoose !=null)
                    {
                      String formatteddate=DateFormat('yyyy-MM-dd').format(datechoose);
                      setState(() {
                        widget.date.text=formatteddate;
                      }
                      );
                    }
                  }
              ),
            ),
            SizedBox(height:100),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: IconButton(onPressed: (){
                      Navigator.of(context).pop();
                      }, icon: Icon(Icons.clear),
                      color: Colors.white,
                      iconSize: 35,),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: IconButton(onPressed: (){
                      if(dropdown_AM_or_PM.contains("AM"))
                        {
                          int h=0;
                          int m=0;
                          int score=0;
                          if(dropdown_hour_value == '12')
                            {
                              h=0*60;
                              m=int.parse(dropdown_min_value);
                              score=(h+m);
                            }
                          else
                            {
                              h=(int.parse(dropdown_hour_value))*60;
                              m=int.parse(dropdown_min_value);
                              score=(h+m);
                            }
                          DateFormat hour=new DateFormat("HH");
                          DateFormat min=new DateFormat("mm");
                          DateFormat dt=new DateFormat("yyyy-MM-dd");
                          String dt_now=dt.format(DateTime.now());
                           String x=hour.format(DateTime.now());
                           String y=min.format(DateTime.now());
                           int xx=int.parse(x)*60;
                           int yy=int.parse(y);
                           int score_now=xx+yy;
                           if(score_now>=score && (widget.date.text) == dt_now)
                             {
                               final snackBar=SnackBar(content:Text("Time Selection Error",
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
                               additem(widget.take_title.text,
                                   widget.take_desc.text,
                                   dropdown_hour_value,
                                   dropdown_min_value,
                                   dropdown_AM_or_PM,
                                   widget.date.text,
                                   score);
                               //read();
                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Todo()));
                             }


                        }
                      else
                        {
                          int h=0;
                          int m=0;
                          int score=0;
                          if(dropdown_hour_value == '12')
                          {
                            h=(0+12)*60;
                            m=int.parse(dropdown_min_value);
                            score=(h+m);
                          }
                          else
                          {
                            h=((int.parse(dropdown_hour_value))+12)*60;
                            m=int.parse(dropdown_min_value);
                            score=(h+m);
                          }

                          DateFormat hour=new DateFormat("HH");
                          DateFormat min=new DateFormat("mm");
                          DateFormat dt=new DateFormat("yyyy-MM-dd");

                          String dt_now=dt.format(DateTime.now());
                          String x=hour.format(DateTime.now());
                          String y=min.format(DateTime.now());
                          int xx=int.parse(x)*60;
                          int yy=int.parse(y);
                          int score_now=xx+yy;
                          if(score_now>=score && (widget.date.text)==dt_now)
                          {
                            final snackBar=SnackBar(content:Text("Time Selection Error",
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
                            additem(widget.take_title.text,
                                widget.take_desc.text,
                                dropdown_hour_value,
                                dropdown_min_value,
                                dropdown_AM_or_PM,
                                widget.date.text,
                                score);
                            //read();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Todo()));
                          }
                        }
                    }, icon: Icon(Icons.save),
                      color: Colors.white,
                      iconSize: 35,),
                  ),
                ],
              ),
            )
          ],
        ),
      )
      )
    );
  }

}