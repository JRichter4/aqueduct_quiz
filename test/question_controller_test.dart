import 'harness/app.dart';

Future main() async {
  TestApplication testApp = new TestApplication();

  setUpAll(() async => await testApp.start());
  tearDownAll(() async => await testApp.stop());

  test("/questions Returns a List of Questions", () async {
    TestRequest request = testApp.client.request("/questions");

    expectResponse(await request.get(), 200,
        body: allOf([
          hasLength(greaterThan(0)),
          everyElement(endsWith("?")),
        ]));
  });

  test("/questions/index Returns a Single Question", () async {
    TestRequest request = testApp.client.request("/questions/1");
    expectResponse(await request.get(), 200, body: endsWith("?"));
  });

  test("questions/index Out of Range Returns 404", () async {
    TestRequest request = testApp.client.request("/questions/-1");
    expectResponse(await request.get(), 404);
  });
}
