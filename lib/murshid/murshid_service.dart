import 'app_data_repository.dart';
import 'murshid_cloud_engine.dart';
import 'murshid_context.dart';
import 'murshid_local_engine.dart';
import 'murshid_relationship_engine.dart';

class MurshidService {
  MurshidService({
    required this.repository,
    MurshidLocalEngine? local,
    MurshidCloudEngine? cloud,
    MurshidRelationshipEngine? relationship,
  })  : _local = local ?? MurshidLocalEngine(),
        _cloud = cloud ?? MurshidCloudEngine(),
        _relationship = relationship ?? MurshidRelationshipEngine();

  final AppDataRepository repository;
  final MurshidLocalEngine _local;
  final MurshidCloudEngine _cloud;
  final MurshidRelationshipEngine _relationship;

  final MurshidState state = MurshidState();

  Future<String> respond(String message) async {
    final context = repository.buildContext();
    state.totalMessages += 1;

    if (context.internetAvailable) {
      try {
        return await _cloud.tryOpenAi(context, message);
      } catch (_) {
        try {
          return await _cloud.tryMeta(context, message);
        } catch (_) {
          return _local.respond(context);
        }
      }
    }
    return _local.respond(context);
  }

  String relationshipTitle({required bool humorDetected}) {
    _relationship.updateStage(state);
    return _relationship.titleFor(state, humorDetected: humorDetected);
  }
}
