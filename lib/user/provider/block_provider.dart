import 'package:auction_shop/user/model/block_model.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final blockProvider = StateNotifierProvider((ref) {
  final repo = ref.watch(userRepositoryProvider);

  return BlockNotifier(repo: repo);
});

class BlockNotifier extends StateNotifier<BlockBase>{

  final UserRepository repo;
  BlockNotifier({
    required this.repo,
  }):super(BlockLoading());

  // 유저 차단하기
  Future<void> blockUser(int memberId) async {
    final resp = await repo.blockUser(memberId);
    // 만약 기존 데이터가 없으면 데이터 불러오기
    if(!(state is BlockUserList)){
      await getBlockUsers();
      return;
    }
    // 차단한 데이터 추가
    final nState = state as BlockUserList;
    state = nState.copyWith(list: [...nState.list, resp]);
  }

  // 차단 데이터 불러오기
  Future<void> getBlockUsers({
    bool isRefetching = false,
  }) async {
    // 만약 데이터가 벌써 불러와진 상태라면,
    // 서버로 재요청 X => 함수 종료
    if(state is BlockUserList && !isRefetching){
      return;
    }
    state = BlockLoading();
    final resp = await repo.blockUserList();
    state = resp;
  }

  // 차단된 유저 해제하기
  Future<void> blockUserRemove(int id) async {
    await repo.blockUserRemove(id);
    final nState = state as BlockUserList;
    final newList = nState.list.where((e) => e.id != id).toList();
    state = nState.copyWith(list: newList);
  }

  BlockUserList getFakeData(){
    return BlockUserList(list: [
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
      BlockUser(id: 0, blockedMemberId: 0, blockedMemberName: 'blockMemberName'),
    ],);
  }
}