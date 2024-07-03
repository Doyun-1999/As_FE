String? nameValidator(String? val) {
  if (val!.isEmpty) {
    return '이름을 입력해주세요.';
  } else {
    return null;
  }
}

String? addressValidator(String? val) {
  if (val!.isEmpty) {
    return '주소를 입력해주세요.';
  } else {
    return null;
  }
}
