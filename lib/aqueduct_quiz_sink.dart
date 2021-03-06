import 'aqueduct_quiz.dart';
import 'controller/question_controller.dart';

class QuizConfig extends ConfigurationItem {
  QuizConfig(String configPath) : super.fromFile(configPath);

  DatabaseConnectionConfiguration database;
}

/// This class handles setting up this application.
///
/// Override methods from [RequestSink] to set up the resources your
/// application uses and the routes it exposes.
///
/// See the documentation in this file for the constructor, [setupRouter] and [willOpen]
/// for the purpose and order of the initialization methods.
///
/// Instances of this class are the type argument to [Application].
/// See http://aqueduct.io/docs/http/request_sink
/// for more details.
class AqueductQuizSink extends RequestSink {
  ManagedContext context;

  /// Constructor called for each isolate run by an [Application].
  ///
  /// This constructor is called for each isolate an [Application] creates to serve requests.
  /// The [appConfig] is made up of command line arguments from `aqueduct serve`.
  ///
  /// Configuration of database connections, [HTTPCodecRepository] and other per-isolate resources should be done in this constructor.
  AqueductQuizSink(ApplicationConfiguration appConfig) : super(appConfig) {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}")
    );

    var dbConfig = new QuizConfig(appConfig.configurationFilePath);
    var dataModel = new ManagedDataModel.fromCurrentMirrorSystem();

    PostgreSQLPersistentStore dataStore =
        new PostgreSQLPersistentStore.fromConnectionInfo(
            dbConfig.database.username,
            dbConfig.database.password,
            dbConfig.database.host,
            dbConfig.database.port,
            dbConfig.database.databaseName,
        );

    context = new ManagedContext(dataModel, dataStore);
  }

  /// All routes must be configured in this method.
  ///
  /// This method is invoked after the constructor and before [willOpen] Routes must be set up in this method, as
  /// the router gets 'compiled' after this method completes and routes cannot be added later.
  @override
  void setupRouter(Router router) {
    router
        .route("/questions/[:index]")
        .generate(() => new QuestionController());
  }

  /// Final initialization method for this instance.
  ///
  /// This method allows any resources that require asynchronous initialization to complete their
  /// initialization process. This method is invoked after [setupRouter] and prior to this
  /// instance receiving any requests.
  @override
  Future willOpen() async {}
}
