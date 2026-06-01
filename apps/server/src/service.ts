import * as repository from "./repository";
import { CreatePhotoRequest, IntimacyEntry, RepresentativeFaceResponse } from "./dto";

export const registerAppInstance = async (deviceId: string) => {
  return await repository.upsertAppInstance(deviceId);
};

export const uploadPhotoData = async (data: CreatePhotoRequest) => {
  const { appInstanceId, imagePath, vectors } = data;
  return await repository.createPhotoAndFaces(appInstanceId, imagePath, vectors);
};

export const getRepresentativeVectors = async (appInstanceId: number): Promise<RepresentativeFaceResponse[]> => {
  const groups = await repository.findGroupsWithRepresentative(appInstanceId);
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

export const createNewGroup = async (appInstanceId: number, name: string): Promise<{ id: number; name: string }> => {
  const groupName = name.trim() !== '' ? name : await _autoName(appInstanceId);
  return await repository.createGroup(appInstanceId, groupName);
};

export const getIntimacyData = async (appInstanceId: number): Promise<IntimacyEntry[]> => {
  const groups = await repository.findGroupsWithFaceCounts(appInstanceId);
  return groups.map((group) => ({
    groupId: group.id,
    groupName: group.name,
    photoCount: group._count.faces,
    representativeVector: (group.faces[0]?.vector ?? []) as number[],
    representativeImagePath: group.faces[0]?.photo?.imagePath ?? null,
  }));
};

export const renameGroup = async (groupId: number, name: string) => {
  return await repository.updateGroupName(groupId, name);
};

const _autoName = async (appInstanceId: number): Promise<string> => {
  const count = await repository.countGroups(appInstanceId);
  return `Person ${count + 1}`;
};
