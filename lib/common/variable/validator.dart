

String? supportOValidator(String? val, {required String name}) {
  if (val == null || val.isEmpty) {
    return '$name을 입력해주세요.';
  } else {
    return null;
  }
}

String? supportXValidator(String? val, {required String name}) {
  if (val == null || val.isEmpty) {
    return '$name를 입력해주세요.';
  } else {
    return null;
  }
}

String? phoneValidator(String? val) {
  if (val!.isEmpty) {
    return '전화번호를 입력해주세요.';
  } else if (!RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(val)) {
    return '올바른 전화번호 형식을 입력해주세요.';
  }
  return null;
}