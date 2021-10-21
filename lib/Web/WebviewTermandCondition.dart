import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebViewClass extends StatefulWidget {
  final String title;
  final String url;

  WebViewClass(this.title,this.url);
  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: AppColors.tela,
        leading: Padding(padding: EdgeInsets.only(left: 0.0),
          child:InkWell(
             onTap: (){
            if (Navigator.canPop(context)) {
                 Navigator.pop(context);
                      } else {
               SystemNavigator.pop();
                       }
                    },

                     child: Icon(
                Icons.arrow_back,size: 30,
                      color: Colors.white,
                            ),

                      ),),
          title: Center(child: Text(widget.title,style: TextStyle(color: Colors.white),)),

        ),


    body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);

            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),

          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );
  }
}


/*
class WebViewState extends State<WebViewScreen>{

  String title,url;
  bool isLoading=true;
  final _key = UniqueKey();

  WebViewState(String title,String url){
    this.title=title;
    this.url=url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text(this.title,style: TextStyle(fontWeight: FontWeight.w700)),centerTitle: true
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: this.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );
  }

}*/
