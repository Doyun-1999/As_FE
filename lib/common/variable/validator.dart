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

String? detailAddressValidator(String? val) {
  if (val!.isEmpty) {
    return '상세주소를 입력해주세요.';
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