import 'dart:math';
import 'api_service.dart';

class GroupAssignmentResult {
  final List<int> groupIds;
  final List<List<double>> vectors;

  GroupAssignmentResult({required this.groupIds, required this.vectors});
}

class GroupingService {
  static const double _threshold = 0.25;

  static final GroupingService _instance = GroupingService._internal();
  factory GroupingService() => _instance;
  GroupingService._internal();

  Future<GroupAssignmentResult> assignGroups(List<List<double>> embeddings) async {
    if (embeddings.isEmpty) {
      return GroupAssignmentResult(groupIds: [], vectors: []);
    }

    final appInstanceId = ApiService().appInstanceId;
    if (appInstanceId == null || appInstanceId == -1) {
      return GroupAssignmentResult(
        groupIds: List.filled(embeddings.length, -1),
        vectors: embeddings,
      );
    }

    List<RepresentativeDto> representatives;
    try {
      representatives = await ApiService().getRepresentatives(appInstanceId);
    } catch (_) {
      return GroupAssignmentResult(
        groupIds: List.filled(embeddings.length, -1),
        vectors: embeddings,
      );
    }

    final List<int> groupIds = [];

    for (final embedding in embeddings) {
      double bestSimilarity = 0.0;
      int bestGroupId = -1;

      for (final rep in representatives) {
        final sim = cosineSimilarity(embedding, rep.vector);
        if (sim > bestSimilarity) {
          bestSimilarity = sim;
          bestGroupId = rep.groupId;
        }
      }

      if (bestSimilarity > _threshold) {
        groupIds.add(bestGroupId);
      } else {
        try {
          final newGroupId = await ApiService().createGroup(appInstanceId, '');
          // 같은 배치 내 이후 임베딩도 이 그룹과 비교할 수 있도록 임시 추가
          representatives.add(RepresentativeDto(
            groupId: newGroupId,
            groupName: 'Person ${representatives.length + 1}',
            representativeFaceId: -1,
            vector: embedding,
          ));
          groupIds.add(newGroupId);
        } catch (_) {
          groupIds.add(-1);
        }
      }
    }

    return GroupAssignmentResult(groupIds: groupIds, vectors: embeddings);
  }

  static double cosineSimilarity(List<double> v1, List<double> v2) {
    if (v1.isEmpty || v2.isEmpty || v1.length != v2.length) return 0.0;
    double dot = 0, n1 = 0, n2 = 0;
    for (int i = 0; i < v1.length; i++) {
      dot += v1[i] * v2[i];
      n1 += v1[i] * v1[i];
      n2 += v2[i] * v2[i];
    }
    if (n1 == 0 || n2 == 0) return 0.0;
    return dot / (sqrt(n1) * sqrt(n2));
  }
}
