
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthFunc

{

  Future <String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> sendEmailVerificcation();
  Future<void> signOut();

  Future<bool> isEmailVerified();

}

class MyAuth implements AuthFunc{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  @override
  Future<void> sendEmailVerificcation() async {
    var user =   await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  @override
  Future<String> signIn(String email, String password)  async{

    
    var user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password) async {
    var user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  @override
  Future<bool> isEmailVerified() async {
    var user= await _firebaseAuth.currentUser();
    return user.isEmailVerified;
    
  }


}