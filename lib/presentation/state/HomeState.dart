class HomeState {

  HomeState();

  factory HomeState.idle() = Idle;
  factory HomeState.loading() = Loading;
  factory HomeState.success(dynamic data) = Success;
  factory HomeState.error(String message , String code) = Error;
  factory HomeState.noData() = NoData;

}

class Idle extends HomeState{
  Idle();
}

class Loading extends HomeState{
  Loading();
}

class NoData extends HomeState{
  NoData();
}

class Success extends HomeState{
  Success(this.data);

  dynamic data;
}

class Error extends HomeState{
  Error(this.message , this.code);

  final String message , code;
}

