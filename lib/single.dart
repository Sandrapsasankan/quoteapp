import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class Single extends StatefulWidget {

  final String categoryname;
  Single(this.categoryname);

  @override
  State<Single> createState() => _SingleState();
}

class _SingleState extends State<Single> {

  List quotes=[];
  List author=[];
  bool isData=false;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getQuotes();
  }

  getQuotes() async{
    String url='https://quotes.toscrape.com/tag/${widget.categoryname}/';
    print(url);
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName('quote');
    quotes=quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    author=quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();

    setState(() {
      isData=true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: isData==false? Center(child: CircularProgressIndicator(),): SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50),
              child: Text("${widget.categoryname.toUpperCase()} Quotes",style: TextStyle(
                  fontSize: 25,color: Colors.black,fontWeight: FontWeight.w700
              ),),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: quotes.length,
                itemBuilder: (context,index){
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20,left: 20,bottom: 20),
                            child: Text(quotes[index],style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(author[index],style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600
                            ),),
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}