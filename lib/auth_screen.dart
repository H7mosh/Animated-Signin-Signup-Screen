import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth-screen";

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white54,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 94.0),
                      child: Text('shopeini' , style: TextStyle(fontSize: 30.0 , fontFamily: 'Anton'),),
                    ),
                  ),
                  Flexible(
                    child: AuthCard(),
                    flex: deviceSize.width > 600? 2:1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}
enum AuthMode{Login , SignUp}
class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode=AuthMode.Login;

  Map<String , String > _authData = {
    'email':'',
    'password':'',
  };

  var _isLoading = false;

  final _passwordController=TextEditingController();
  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  Future<void> _submit()async{
    if(!_formKey.currentState.validate())
      {
        return;
      }
    setState(() {
      _isLoading=true;
    });
    try{

    }catch(error){

    }
    setState(() {
      _isLoading=false;
    });
  }
  void _switchAuthMode(){
    if(_authMode==AuthMode.Login)
      {
        setState(() {
          _authMode=AuthMode.SignUp;
        });
        _animationController.forward();
      }
    else{
      setState(() {
        _authMode=AuthMode.Login;
      });
      _animationController.reverse();
    }
  }
  @override
  void initState(){
    super.initState();

    _animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(
        begin: Offset(0,-0.15),end: Offset(0,0)
    ).animate(CurvedAnimation(parent: _animationController , curve: Curves.fastOutSlowIn));
    _opacityAnimation=Tween<double>(
        begin: 0.0,end:1.0
    ).animate(CurvedAnimation(parent: _animationController , curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize=MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode==AuthMode.SignUp?320:260,
        constraints: BoxConstraints(minHeight: _authMode==AuthMode.SignUp?320:260,),
        width: deviceSize.width*0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val){
                    if(val.isEmpty || !val.contains('@')){
                      return 'Inavid Email';
                    }return null;
                  },
                  onSaved:(val)
                  {
                    _authData['email']=val;
                  }
                ),
                TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'password'),
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    validator: (val){
                      if(val.isEmpty || val.length<6){
                        return 'password is too short';
                      }return null;
                    },
                    onSaved:(val)
                    {
                      _authData['password']=val;
                    }
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode== AuthMode.SignUp?60:0,
                    maxHeight: _authMode==AuthMode.SignUp?120:0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode==AuthMode.SignUp,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'confirm Password'),
                          keyboardType: TextInputType.visiblePassword,
                          validator:_authMode==AuthMode.SignUp? (val){
                            if(val != _passwordController.text){
                              return 'password does not match';
                            }return null;
                          }:null,
                          onSaved:(val)
                          {
                            _authData['password']=val;
                          }
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                if(_isLoading)  CircularProgressIndicator(),
                RaisedButton(
                     onPressed: _submit,
                     child:Text(_authMode == AuthMode.Login?'LOGIN':'SIGNUP'),
                     shape:RoundedRectangleBorder(
                     borderRadius:BorderRadius.circular(30),
                     ),
                 padding:EdgeInsets.symmetric(horizontal:30 , vertical:8.0),
                 color: Colors.black54,
                  textColor: Colors.white,
               ),
                FlatButton(
                    onPressed: _switchAuthMode,
                    child: Text('${_authMode==AuthMode.Login ? 'SIGNUP' :'LOGIN'} INSTEAD'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

