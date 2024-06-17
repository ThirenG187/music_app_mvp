import 'dart:convert';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  late http.Client client;
  final String _baseURL = ServerConstants.serverURL;

  AuthRemoteRepository() {
    client = http.Client();
  }

  Future<Either<AppFailure, UserModel>> login({
    required email,
    required password,
  }) async {
    try {
      final data = jsonEncode({
        'email': email,
        'password': password,
      });

      final response = await client.post(
        Uri.parse("$_baseURL/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: data,
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        // handled the error
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(UserModel.fromMap(resBodyMap['user']).copyWith(
        token: resBodyMap['token'],
      ));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final data = jsonEncode(
        {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final response = await client.post(
        Uri.parse("$_baseURL/auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: data,
      );

      final resMapBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(resMapBody['detail']));
      }

      return Right(UserModel.fromMap(resMapBody));
    } on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final response = await client.get(
        Uri.parse("$_baseURL/auth/"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      final resMapBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resMapBody['detail']));
      }

      return Right(
        UserModel.fromMap(resMapBody).copyWith(
          token: token,
        ),
      );
    } on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
