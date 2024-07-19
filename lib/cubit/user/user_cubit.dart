import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/forms_status.dart';
import '../../data/models/user/user_model.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState.initialValue());

  Future<void> insertUser({required UserModel userModel}) async {
    try {
      emit(state.copyWith(status: FormsStatus.loading));
      String userUid = FirebaseAuth.instance.currentUser!.uid;
      if (userUid.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .set(userModel.toJson());
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .update({'uid': userUid});
        emit(state.copyWith(status: FormsStatus.success, userData: userModel));

        print(insertUser);
      } else {
        emit(state.copyWith(
            status: FormsStatus.error, errorMessage: 'user not found'));
      }
    } catch (e) {
      emit(state.copyWith(
          status: FormsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> fetchUserDocId() async {
    try {
      emit(state.copyWith(status: FormsStatus.loading));
      String userUid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      emit(
        state.copyWith(
          status: FormsStatus.success,
          userData: UserModel.fromJson(
              documentSnapshot.data() as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
          status: FormsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> updateUserEvent({required UserModel userModel}) async {
    try {
      emit(state.copyWith(
        status: FormsStatus.loading,
      ));
      final String docId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .update(userModel.toUpdateJson());
      emit(state.copyWith(
        status: FormsStatus.success,
        userData: userModel,
      ));
    } catch (error) {
      throw Exception(error);
    }
  }
}
