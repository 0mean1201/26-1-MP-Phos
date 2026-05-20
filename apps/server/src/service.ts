import * as repository from "./repository";
import { CreatePhotoRequest, RepresentativeFaceResponse } from "./dto";
// ❌ PrismaClient import와 const prisma = new PrismaClient() 삭제

export const uploadPhotoData = async (data: CreatePhotoRequest) => {
  const { appIdNumber, imagePath, vectors } = data;

  const updatedVectors = await Promise.all(
    vectors.map(async (v) => {
      if (v.groupId === null) {
        const groupCount = await repository.countGroups(appIdNumber); // repository에서 처리
        // ... 나머지 로직
      }
      return v;
    })
  );

  return await repository.createPhotoAndFaces(appIdNumber, imagePath, updatedVectors);
};

export const getRepresentativeVectors = async (appInstanceId: number): Promise<RepresentativeFaceResponse[]> => {
  const groups = await repository.findGroupsWithRepresentative(appInstanceId); // ✅ 인자 추가
console.log(groups)
  return groups.flatMap((group) => {
    const firstFace = group.faces[0];
    if (!firstFace) return [];
    return [{
      groupId: group.id,
      groupName: group.name,
      representativeFaceId: firstFace.id,
      vector: firstFace.vector as number[],
    }];
  });
};