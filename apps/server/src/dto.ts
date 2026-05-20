export interface RegisterAppInstanceResponse {
  appInstanceId: number;
}

export interface CreatePhotoRequest {
  appInstanceId: number;
  imagePath: string;
  vectors: {
    vector: number[];
    groupId: number | null;
  }[];
}

export interface CreateGroupRequest {
  appInstanceId: number;
  name: string;
}

export interface UpdateGroupRequest {
  name: string;
}

export interface CreateGroupResponse {
  groupId: number;
  name: string;
}

export interface RepresentativeFaceResponse {
  groupId: number;
  groupName: string;
  representativeFaceId: number;
  vector: number[];
}

export interface IntimacyEntry {
  groupId: number;
  groupName: string;
  photoCount: number;
  representativeVector: number[];
  representativeImagePath: string | null;
}
