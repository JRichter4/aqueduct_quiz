import 'harness/app.dart';
import 'package:aqueduct_quiz/model/question.dart';

Future main() async {
  TestApplication testApp = new TestApplication();

  setUpAll(() async {
    await testApp.start();

    List<Question> questions = [
      new Question()..description = "Is this a question?",
      new Question()
        ..description = "Why am I the luckiest guy in the entire world?",
      new Question()
        ..description = "Is it because I have the cutest girlfriend ever?",
    ];

    await Future.forEach(questions, (q) {
      Query<Question> query = new Query<Question>()..values = q;
      return query.insert();
    });
  });

  tearDownAll(() async => await testApp.stop());

  test("/questions Returns a List of Questions", () async {
    TestRequest request = testApp.client.request("/questions");

    expectResponse(await request.get(), 200,
        body: allOf([
          hasLength(greaterThan(0)),
          everyElement(containsPair("description", endsWith("?"))),
        ]));
  });

  test("/questions/index Returns a Single Question", () async {
    TestRequest request = testApp.client.request("/questions/1");
    expectResponse(await request.get(), 200,
        body: containsPair("description", endsWith("?")));
  });

  test("questions/index Out of Range Returns 404", () async {
    TestRequest request = testApp.client.request("/questions/-1");
    expectResponse(await request.get(), 404);
  });
}
