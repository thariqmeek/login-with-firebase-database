import 'package:flutter/material.dart';
import 'package:login/firebase_auth.dart';

enum STATE{
  SIGNIN,SIGNUP
}



class SignInSignUpPage extends StatefulWidget{

  AuthFunc auth;
  VoidCallback onSignedIn;

  



  @override
  State<StatefulWidget> createState()  => new _SignInSignUpPageState();
  
    SignInSignUpPage({this.auth, this.onSignedIn});
  
  
  }
  
  class _SignInSignUpPageState extends State<SignInSignUpPage> {
  
    final _formKey = new GlobalKey<FormState>();
  
    String _email,_password,_errorMessage;

    STATE _formState = STATE.SIGNIN;
    bool  _isIos, _isLoading;

    bool _valideateAndSave(){
      final form = _formKey.currentState;
      if(form.validate())
      {
form.save();
return true;

      }
  return false;
    }
  
  
  void _validateAndSubmit () async{
    setState(() {
      _errorMessage = "";
      _isLoading = true;

    });

    if (_valideateAndSave())
    {
      String userId="";
      try{
        if( _formState ==  STATE.SIGNIN)
        {
          userId = await widget.auth.signIn(_email,_password);

        }
        else 
        {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerificcation();
          _showVerifyEmailSentDialog();
                  }
                  setState(() {
                    _isLoading= false;
                  });

                  if(userId.length > 0 && userId != null && _formState == STATE.SIGNIN)
                  widget.onSignedIn();

                }catch(e){
                  print(e);
                  setState(() {
                    _isLoading = false;
                    if(_isIos)
                    _errorMessage =e.details;
                    else 
                    _errorMessage = e.message;
                  });
                }
              }
          
            }
            
            @override
  void initState() {
    
    super.initState();
    _errorMessage = "";
    _isLoading = false;
  }
            
            void _changeFormToSignUp() {
              _formKey.currentState.reset();
              _errorMessage="";
              setState(() {
                _formState = STATE.SIGNUP;
              });


            }

          void _changeFormToSignIn(){
_formKey.currentState.reset();
_errorMessage="";
setState(() {
  
  _formState =STATE.SIGNIN;
});

          }



            @override
            Widget build(BuildContext context) {
              _isIos = Theme.of(context).platform == TargetPlatform.iOS;
              return new Scaffold(
                appBar: AppBar(title: Text('PS Login'),centerTitle: true,
                backgroundColor: Colors.red[600],

),
                body: Stack(children: <Widget>[
                  showBody(),
                                    showCircularProgress(),
                                                                      ],),
                                                                    );
                                                                  }
                                                                
                                                                    void _showVerifyEmailSentDialog() {
                                                                                          showDialog(context: context,
                                                                              builder: (BuildContext context){
                                                                                return AlertDialog(
                                                                                  title: new Text('Thanks'),
                                                                                  content: new Text('verification email has been sent '),
                                                                                  actions: <Widget>[
                                                                                      
                                                                                                         new FlatButton(onPressed: (){
                                                                                                           _changeFormToSignIn();
                                                                                                          Navigator.of(context).pop();
                                                                                                          
                                                                                                        }, child: Text('OK'))
                                                                                      
                                                                                      
                                                                                      
                                                                                                      ],
                                                                                                    );
                                                                                      
                                                                                      
                                                                                                  });
                                                                                
                                                                  
                                                                  
                                                                  }
                                    
                                      showCircularProgress() {
                                        if(_isLoading)
                                        return Center(child: CircularProgressIndicator(),);
                                        return Container(height: 0.0,width:0.0,);
                                      }
                  
                    showBody() {

                      return new Container(
                        padding: EdgeInsets.all(16.0),
                        child:new Form(
                          key:_formKey,
                          child: new ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              _showText(),
                                                            _showEmailInput(),
                                                                                          _showPasswordInput(),
                                                                                                                        _showButton(),
                                                                                                                                                      _showAskQuestion(),
                                                                                                                                                                                    _showErrorMessage(),
                                                                                                                                                                                                                ],
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                                              )
                                                                                                                                                                                                            ),
                                                                                                                                                                                                          );
                                                                                                                                                                                                        }
                                                                                                                                                                                    
                                                                                                                                                                                     Widget _showErrorMessage() {
                                                                                                                                                      
                                                                                                                                                                                       if(_errorMessage.length > 0  && _errorMessage != null)
                                                                                                                                                                                       {
                                                                                                                                                                                         return new Text(_errorMessage,style: TextStyle(fontSize: 14.0,
                                                                                                                                                                                         color: Colors.red,
                                                                                                                                                                                         height:1.0,
                                                                                                                                                                                         fontWeight: FontWeight.w300),);
                                                                                                                                                      
                                                                                                                                                                                       }
                                                                                                                                                      
                                                                                                                                                                                       else{
                                                                                                                                                                                          return new Container(height: 0.0, width:0.0,);
                                                                                                                                                                                       }
                                                                                                                                                                                     }
                                                                                                                                                      
                                                                                                                                                       Widget _showAskQuestion() {
                                                                                                                                                         return new FlatButton(onPressed: _formState == STATE.SIGNIN? _changeFormToSignUp : _changeFormToSignIn, child: _formState == STATE.SIGNIN ? new Text ('Create an Account',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w300)):
                                                                                                                                                         new Text ('Already An User ? Just Sign in',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w300),));
                                                                                                                                                       }
                                                                                                                        
                                                                                                                          _showButton() {
                                                                                                                            return new Padding(padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),child: SizedBox(height: 40.0, 
                                                                                                                            child:RaisedButton(onPressed: _validateAndSubmit,
                                                                                                                            elevation: 5.0, shape:new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                                                                                            color: Colors.amber,
                                                                                                                            child: _formState == STATE.SIGNIN ? new Text('SIGN - IN', style:  TextStyle(fontSize:20.0,color:Colors.black),):
                                                                                                                            new Text('SIGN - UP', style:  TextStyle(fontSize:20.0,color:Colors.black),) )),);
                                                                                          
                                                                                                                          }
                                                                                          
                                                                                            _showPasswordInput() {
                                                                                              return new Padding(padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),child: TextFormField(
                                                                                                maxLines: 1,
                                                                                                obscureText: true,
                                                                                                autofocus: false,
                                                                                                decoration: new InputDecoration( hintText: 'Enter Password',
                                                                                                icon:Icon(Icons.lock, color: Colors.greenAccent[200])),
                                                                                                validator: (value)  => value.isEmpty ? 'Email Cannot be Empty Bro!!': null,
                                                                                                onSaved: (value)  => _password = value.trim(),
                                                            
                                                                                              ),);
                                                                                          
                                                                                            }

                                                            
                                                              _showEmailInput() {
                                                                return new Padding(padding: EdgeInsets.fromLTRB(0.0, 95.0, 0.0, 0.0),child: TextFormField(
                                                                                                maxLines: 1,
                                                                                                keyboardType: TextInputType.emailAddress,
                                                                                                autofocus: false,
                                                                                                decoration: new InputDecoration( hintText: 'Enter E-mail',
                                                                                                icon:Icon(Icons.mail, color: Colors.greenAccent[50])),
                                                                                                validator: (value)  => value.isEmpty ? 'Password Cannot be Empty Bro!!': null,
                                                                                                onSaved: (value)  => _email = value.trim(),
                                                            
                                                                                              ),);
                                                                                          
                              
                              
                                                              }
                              
                                _showText() {
                                  return new Hero(tag: 'here', child: Padding(padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                                  child:  _formState == STATE.SIGNIN ? Center(child: Text('SIGN -IN', style:TextStyle(fontSize: 40.0,color:Colors.amber,fontWeight: FontWeight.bold),),):
                                  Center(child: Text('SIGN -UP', style:TextStyle(fontSize: 40.0,color:Colors.amber,fontWeight: FontWeight.bold),),),),);
                                }
                  
                      
                  }
                  
                