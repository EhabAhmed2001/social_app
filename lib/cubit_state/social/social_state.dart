abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialSuccess extends SocialState {}

class SocialError extends SocialState {
  final String error;
  SocialError(this.error);
}

