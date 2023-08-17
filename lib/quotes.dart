
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:quoteapp/single.dart';

class Quotes extends StatefulWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {

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
    String url='https://quotes.toscrape.com/';
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

  List<String> categories=["love","inspirational","life","humor"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50),
              child: Text("Quotes App",style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 28
              ),),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 0,
              children: categories.map((category) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Single(category)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child: Text(category.toUpperCase(),style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 18
                        ),),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20,),
            isData==false? Center(child: CircularProgressIndicator(),): ListView.builder(
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
            )
          ],
        ),
      ),
    );
  }
}