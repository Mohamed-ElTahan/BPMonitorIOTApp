import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data_source/firebase/firestore_data_source.dart';
import '../model/profile_model.dart';
import 'about_me_state.dart';

class AboutMeCubit extends Cubit<AboutMeState> {
  final FirestoreDataSource _dataSource = FirestoreDataSource();

  AboutMeCubit() : super(AboutMeInitial());

  Future<void> fetchProfile(String docId) async {
    emit(AboutMeLoading());
    try {
      final data = await _dataSource.getAboutProfile(docId);
      final ProfileModel profile = ProfileModel.fromJson(data);
      emit(AboutMeLoaded(profileModel: profile));
    } catch (e) {
      emit(AboutMeError());
    }
  }
}
