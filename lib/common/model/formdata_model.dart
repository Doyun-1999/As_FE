// FormData를 를 만들어주는 basemodel
abstract class FormDataBase {
  // FormData를 만들 때 toJson 함수가 필요함.
  Map<String, dynamic> toJson();
}
