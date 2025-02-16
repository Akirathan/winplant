import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:winplant/widgets/loading_image.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class FakeUri extends Fake implements Uri {}

class TestHttpOverrides extends HttpOverrides {
  final HttpClient mockHttpClient;

  TestHttpOverrides(this.mockHttpClient);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return mockHttpClient;
  }
}

void main() {
  setUp(() {
    registerFallbackValue(FakeUri());
  });

  testWidgets('Test loading image', (tester) async {
    var url =
        'https://cdn.myshoptet.com/usr/670621.myshoptet.com/user/shop/orig/103_240926-petra-kvetiny079.jpg?66f91f56';
    var mockHttpClient = MockHttpClient();
    var mockRequest = MockHttpClientRequest();
    var mockResponse = MockHttpClientResponse();

    when(() => mockHttpClient.getUrl(any()))
        .thenAnswer((_) async => mockRequest);
    when(() => mockRequest.close()).thenAnswer((_) async => mockResponse);
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.contentLength).thenReturn(4);
    when(() => mockResponse.compressionState)
        .thenReturn(HttpClientResponseCompressionState.notCompressed);
    when(() => mockResponse.listen(any(),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
        cancelOnError: any(named: 'cancelOnError'))).thenAnswer((invocation) {
      var onData =
          invocation.positionalArguments[0] as void Function(Uint8List);
      onData(Uint8List.fromList([1, 2, 3, 4]));
      return const Stream<Uint8List>.empty().listen(null);
    });

    HttpOverrides.runZoned(() async {
      var widget = LoadingImageWidget(url: Uri.parse(url));
      await tester.pumpWidget(widget);

      //debugPrint(tester.element(find.byType(LoadingImageWidget)).toStringDeep());
      var progressFinder = find.byType(CircularProgressIndicator);
      expect(progressFinder, findsOneWidget);
    }, createHttpClient: (ctx) => mockHttpClient);
  });
}
