import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';

class ApiClient{
  // Singleton Pattern
  static final ApiClient instance=ApiClient._internal();
  late Dio dio;

  ApiClient._internal(){
    // Define API Base URL
    dio=Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.108:5000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Bypass SSL or sth like that
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate=
      (HttpClient client){
        client.badCertificateCallback=
          (X509Certificate cert,String host,int port)=>true;
        return client;
      };
  }
}
