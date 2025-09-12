import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:uerj_companion/features/profile/data/user_repository.dart';
import 'package:uerj_companion/features/profile/domain/user_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _logger = Logger();
  final UserRepository _repository;
  final FirebaseAuth _firebaseAuth;

  ProfileBloc({
    required UserRepository userRepository,
    required FirebaseAuth firebaseAuth,
  }) : _repository = userRepository,
       _firebaseAuth = firebaseAuth,
       super(ProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final userId = _firebaseAuth.currentUser!.uid;
        final userProfile = await _repository.getUserProfile(userId);
        emit(ProfileLoaded(userProfile));
      } catch (e) {
        _logger.e(e);
        emit(ProfileError(e.toString()));
      }
    });
  }
}
