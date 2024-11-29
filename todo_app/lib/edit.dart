import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Todo.dart';
import 'database.dart';

class edit extends StatefulWidget
{
  TextEditingController take_title=TextEditingController();
  TextEditingController take_desc=TextEditingController();
  TextEditingController date=TextEditingController();

  String hour="";
  String min="";
  String day_night="";
  String dt="";

  edit(String task,String desc,String hour,String min,String day_night,String date)
  {
    this.take_title.text=task;
    this.take_desc.text=desc;
    this.hour=hour;
    this.min=min;
    this.day_night=day_night;
    this.dt=date;
  }
  @override
  _edit createState() => _edit();


}
class _edit extends State<edit> {


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

                  SizedBox(height:100),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.black,
                          child: IconButton(onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Todo()));
                          }, icon: Icon(Icons.clear),
                            color: Colors.white,
                            iconSize: 35,),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.black,
                          child: IconButton(onPressed: (){
                            if((widget.take_title.text).isEmpty || (widget.take_desc.text).isEmpty)
                              {
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
                            else {
                              Dbprovider.updateinfo(
                                widget.take_title.text,
                                widget.take_desc.text,
                                widget.hour,
                                widget.min,
                                widget.day_night,
                                widget.dt,
                              );
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Todo()));
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
