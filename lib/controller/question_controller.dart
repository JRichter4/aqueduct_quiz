import 'package:aqueduct_quiz/aqueduct_quiz.dart';
import 'package:aqueduct_quiz/model/question.dart';

class QuestionController extends HTTPController {
  @httpGet
  Future<Response> getAllQuestions() async {
    var questionQuery = new Query<Question>();
    var databaseQuestions = await questionQuery.fetch();

    return new Response.ok(databaseQuestions);
  }

  @httpGet
  Future<Response> getQuestionAtIndex(@HTTPPath("index") int index) async {
    var questionQuery = new Query<Question>().where.index = whereEqualTo(index);
    var singleQuestion = await questionQuery.fetchOne();

    if (singleQuestion == null) return new Response.notFound();

    return new Response.ok(singleQuestion);
  }
}
