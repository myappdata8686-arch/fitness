import 'murshid_context.dart';

class MurshidCloudEngine {
  Future<String> tryOpenAi(MurshidContext context, String userMessage) async {
    throw UnimplementedError('OpenAI integration not configured in this build.');
  }

  Future<String> tryMeta(MurshidContext context, String userMessage) async {
    throw UnimplementedError('Meta integration not configured in this build.');
  }
}
