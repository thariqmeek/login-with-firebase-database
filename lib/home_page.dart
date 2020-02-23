import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/firebase_auth.dart';

class HomePage extends StatefulWidget{

  AuthFunc auth;
  VoidCallback onSignedOut;
  String userId,userEmail;

  HomePage({Key key,this.auth, this.onSignedOut, this.userEmail,this.userId}):super(key:key);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
    }
  
  class _HomePageState extends State<HomePage> {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool _isEmailVerified = false;
@override
  void initState() {

    super.initState();
    _checkEmailVerification();
      }
    
      @override
      Widget build(BuildContext context) {
        
        return new Scaffold(
          appBar: new AppBar(
            title: Text('LOGIN PAGE'),
            centerTitle: true,
            backgroundColor: Colors.red[600],
            
            actions: <Widget>[FlatButton(onPressed: _signOut, child: Text('Signout'))],
            ),
            body:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                new Center(child:Text('Hey!'+widget.userEmail),),
                new Center(child:Text('Your ID:  '+widget.userId),),
                new Center(child:Text('Welcome to Group'),)
              ],
              
            ),
            drawer: Drawer(),
            bottomNavigationBar: BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
        title: Text("Notification"),
        icon: Icon(Icons.announcement),
        ),
        BottomNavigationBarItem(
        title: Text("Alert"),
        icon: Icon(Icons.report),
          )
          ],),
            
            );
                  }
                
                
                void _checkEmailVerification() async {
                  _isEmailVerified = await widget.auth.isEmailVerified();
                  if(!_isEmailVerified)
                      _showVerifyEmailDialog();
                      }
                      
                      void _showVerifyEmailDialog() {
                        showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: new Text('Verify your Email'),
                            content: new Text('Need E-mail to use this app '),
                            actions: <Widget>[
                              new FlatButton(onPressed: (){
                                Navigator.of(context).pop();
                                _sendVerifyEmail();
                                                  }, child: Text('Send')),
                                
                                                   new FlatButton(onPressed: (){
                                                    Navigator.of(context).pop();
                                                    
                                                  }, child: Text('Dismiss'))
                                
                                
                                
                                                ],
                                              );
                                
                                
                                            });
                                }
                                
                                  
                                
                                void _sendVerifyEmail() {
                                  widget.auth.sendEmailVerificcation();
                                  _showVerifyEmailSentDialog();
                                  }
                                  
                                  void _showVerifyEmailSentDialog() {
                                    showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: new Text('Thanks'),
                            content: new Text('verification emaail has been sent '),
                            actions: <Widget>[
                                
                                                   new FlatButton(onPressed: (){
                                                    Navigator.of(context).pop();
                                                    
                                                  }, child: Text('OK'))
                                
                                
                                
                                                ],
                                              );
                                
                                
                                            });
                          
            
            
            }
              
              void _signOut() async {
                try{
                  await widget.auth.signOut();
                  widget.onSignedOut();
                }catch(e) {
                  print(e);
                }
  }
}