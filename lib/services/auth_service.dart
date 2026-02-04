class AuthService {

  Future<bool> login(String email, String password) async{

    await Future.delayed(Duration(seconds: 2));
    if(email == 'test@test.com' && password == '123456') {
      return true;
    }
    return false;
  }





}