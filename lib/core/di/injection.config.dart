// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/product/data/datasources/product_remote_data_source.dart'
    as _i1;
import '../../features/product/data/repositories/product_repository_impl.dart'
    as _i1040;
import '../../features/product/domain/repositories/product_repository.dart'
    as _i39;
import '../../features/product/presentation/bloc/product_bloc.dart' as _i415;
import '../../features/product/presentation/bloc/product_list_bloc/product_list_bloc.dart'
    as _i670;
import '../network/network_module.dart' as _i200;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i1.ProductRemoteDataSource>(
        () => _i1.ProductRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i39.ProductRepository>(
        () => _i1040.ProductRepositoryImpl(gh<_i1.ProductRemoteDataSource>()));
    gh.factory<_i670.ProductListBloc>(
        () => _i670.ProductListBloc(gh<_i39.ProductRepository>()));
    gh.factory<_i415.ProductBloc>(
        () => _i415.ProductBloc(gh<_i39.ProductRepository>()));
    return this;
  }
}

class _$NetworkModule extends _i200.NetworkModule {}
