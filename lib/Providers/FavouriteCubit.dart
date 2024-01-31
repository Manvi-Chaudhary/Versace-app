import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteCubit extends Cubit<List<int>> {
  FavouriteCubit() : super([0,0,0,0,0,0]);
  void add(int i){

    state[i]=1;
    emit([...state]);

  }
  void remove(int i){
    state[i]=0;
    emit([...state]);
  }
}