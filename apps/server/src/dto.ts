export interface CreatePhotoRequest {
  appIdNumber: number; // 사용자 구분용
  imagePath: string;
  vectors: {
    vector: number[];
    groupId: number | null;
  }[];
}

export interface RepresentativeFaceResponse {
  groupId: number;
  groupName: string;
  representativeFaceId: number;
  vector: number[];
}
export interface CreatePhotoRequest {
  appInstanceId: string; // 사용자 구분용
  imagePath: string;
  vectors: {
    vector: number[];
    groupId: number | null;
  }[];
}