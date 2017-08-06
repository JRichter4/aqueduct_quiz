import 'package:aqueduct_quiz/aqueduct_quiz.dart';
import 'package:aqueduct_quiz/model/question.dart';

class QuestionController extends HTTPController {
  @httpGet
  Future<Response> getAllQuestions() async {
    Query<Question> questionQuery = new Query<Question>();
    List<Question> databaseQuestions = await questionQuery.fetch();

    return new Response.ok(databaseQuestions);
  }

  @httpGet
  Future<Response> getQuestionAtIndex(@HTTPPath("index") int index) async {
    Query<Question> questionQuery = new Query<Question>()
      ..where.index = whereEqualTo(index);
    Question singleQuestion = await questionQuery.fetchOne();

    if (singleQuestion == null) return new Response.notFound();

    return new Response.ok(singleQuestion);
  }
}
