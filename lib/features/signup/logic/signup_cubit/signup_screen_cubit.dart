import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signup_screen_state.dart';

class SignupScreenCubit extends Cubit<SignupScreenState> {
  SignupScreenCubit() : super(SignupScreenInitial());
}

