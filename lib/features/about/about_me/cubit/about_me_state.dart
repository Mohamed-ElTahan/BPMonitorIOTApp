import '../model/profile_model.dart';

abstract class AboutMeState {}

class AboutMeInitial extends AboutMeState {}

class AboutMeLoading extends AboutMeState {}

class AboutMeLoaded extends AboutMeState {
  final ProfileModel profileModel;

  AboutMeLoaded({required this.profileModel});
}

class AboutMeError extends AboutMeState {
  AboutMeError();
}
