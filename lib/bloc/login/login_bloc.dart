import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namaz_bajamat/model/visitor_model.dart';
import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
import '../../model/imam_model.dart';
import '../../repository/auth_api/auth_repository.dart';
import '../../utils/enums.dart';
import 'login_state.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(const LoginState.loading());

    try {
      final authRepository = AuthHttpApiRepository();
      final role = SessionController.role;
      if(role == Role.imam){
        final ImamModel? user = await authRepository.loginApi({
          'phoneNo': event.phone,
          'password': event.password,
        });
        if (user != null) emit(LoginState.success(user));
      }else if (role == Role.visitor){
        final VisitorModel? visitor = await authRepository.visitorLoginApi({
          'phone': event.phone,
          'password': event.password,
        });
        if (visitor != null) emit(LoginState.success(null));
      }

    } catch (e) {
      emit(LoginState.error(e.toString()));
    }
  }
}
