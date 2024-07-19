import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:imtihon_4oyuchun/blocs/yandex/yandex_cubit_state.dart';

import '../../data/models/yandex_model/yandex_model.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products/'),
      );
      if (response.statusCode == 200) {
        List products = json.decode(response.body);
        List<ProductModels> productModels = products
            .map<ProductModels>((json) => ProductModels.fromJson(json))
            .toList();
        emit(ProductLoaded(productModels));
      } else {
        emit(ProductError('Failed to load products'));
      }
    } catch (e) {
      emit(ProductError('Failed to load products'));
    }
  }
}