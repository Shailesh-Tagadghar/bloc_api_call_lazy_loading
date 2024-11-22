part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class PostInitialFetchEvent extends PostEvent {}

class PostRetryEvent extends PostEvent {}
