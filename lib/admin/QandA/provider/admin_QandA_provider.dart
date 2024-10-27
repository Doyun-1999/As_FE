import 'package:auction_shop/admin/QandA/model/admin_QandA_model.dart';
import 'package:auction_shop/admin/QandA/repository/admin_QandA_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final adminQandAStateProvider = Provider.family<List<AdminAnswerModel>, bool>((ref, status){
  final provider = ref.watch(adminQandAProvider);

  final sortedData = provider.list.where((e) => e.status == status).toList();
  return sortedData;
});

final adminQandAProvider = StateNotifierProvider<AdminQandANotifier, AdminAnswerListModel>((ref) {

  final repo = ref.watch(adminQandARepositoryProvider);
  
  return AdminQandANotifier(repo: repo);
});


class AdminQandANotifier extends StateNotifier<AdminAnswerListModel>{
  final AdminQandARepository repo;

  AdminQandANotifier({
    required this.repo
  }):super(AdminAnswerListModel(list: []));

  // 유저의 QandA 데이터 받기
  void getAnswerdInquiry(bool status) async {
    final isFirst = state.list.firstWhereOrNull((e) => e.status == status);
    // 이미 데이터가 있다면 return;
    if(isFirst != null){
      return;
    }
    final resp = await repo.getAnswerdInquiry(status);
    state = state.copyWith(list: [...state.list, ...resp.list]);
  }

  // 유저의 QandA 데이터 받기
  Future<void> answerInquiry({
    required String content,
    required int id,
  }) async {
    final resp = await repo.answerInquiry(content: content, id: id);
    // id값이 같은 것만 다시 provider 데이터 update
    final newState = state.list.map((e) {
      if(e.id == id){
        return resp;
      }else{
        return e;
      }
    }).toList();
    state = state.copyWith(list: newState);
  }
}