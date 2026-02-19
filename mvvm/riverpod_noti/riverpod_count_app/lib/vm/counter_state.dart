//전역관리 가능//어제까지 변수 하나하나
//property 전체계산 상태를 저장하는 데이터모델
class CounterState {
  final int count;
  final int totalClick;

  //생성자 초기상태//변수 생성 에프엠
  CounterState({this.count = 0, this.totalClick = 0}); //생성자

  //특정값이 변경되면 새로운 상태 객체 만듦
  //riverpod은 상태를 직접 수정하지 않음
  //항상 새로운 상태 객체 만듦-복원가능

  CounterState copywith({int? count, int? totalClick}) {
    return CounterState(
      count: count ?? this.count,
      totalClick: totalClick ?? this.totalClick,
    );
  }
}
