import { Request, Response } from "express";
import * as service from "./service";
import { CreateGroupRequest, UpdateGroupRequest } from "./dto";

// POST /api/app-instances
export const registerAppInstanceHandler = async (_req: Request, res: Response) => {
  try {
    const instance = await service.registerAppInstance();
    res.status(201).json({ success: true, data: { appInstanceId: instance.id } });
  } catch (error) {
    res.status(500).json({ success: false, message: "앱 인스턴스 등록 실패" });
  }
};

// POST /api/photos
export const createPhotoHandler = async (req: Request, res: Response) => {
  try {
    const result = await service.uploadPhotoData(req.body);
    res.status(201).json({ success: true, data: result });
  } catch (error) {
    res.status(500).json({ success: false, message: "사진 저장 중 오류 발생" });
  }
};

// POST /api/groups
export const createGroupHandler = async (req: Request, res: Response) => {
  try {
    const { appInstanceId, name }: CreateGroupRequest = req.body;
    if (typeof appInstanceId !== 'number') {
      return res.status(400).json({ success: false, message: "appInstanceId는 숫자여야 합니다." });
    }
    const group = await service.createNewGroup(appInstanceId, name ?? '');
    res.status(201).json({ success: true, data: { groupId: group.id, name: group.name } });
  } catch (error) {
    res.status(500).json({ success: false, message: "그룹 생성 실패" });
  }
};

// GET /api/groups/representatives/:appInstanceId
export const getRepresentativesHandler = async (req: Request, res: Response) => {
  try {
    const appIdNumber = parseInt(String(req.params.appInstanceId ?? ''), 10);
    if (isNaN(appIdNumber)) {
      return res.status(400).json({ message: "올바르지 않은 appInstanceId 형식입니다." });
    }
    const data = await service.getRepresentativeVectors(appIdNumber);
    res.status(200).json({ success: true, data });
  } catch (error) {
    console.error("❌ 오류:", error);
    res.status(500).json({ success: false, message: "조회 중 오류 발생" });
  }
};

// PATCH /api/groups/:groupId
export const updateGroupHandler = async (req: Request, res: Response) => {
  try {
    const groupId = parseInt(String(req.params.groupId ?? ''), 10);
    if (isNaN(groupId)) {
      return res.status(400).json({ success: false, message: "올바르지 않은 groupId 형식입니다." });
    }
    const { name }: UpdateGroupRequest = req.body;
    if (!name || name.trim() === '') {
      return res.status(400).json({ success: false, message: "이름을 입력해주세요." });
    }
    const group = await service.renameGroup(groupId, name.trim());
    res.status(200).json({ success: true, data: { groupId: group.id, name: group.name } });
  } catch (error) {
    res.status(500).json({ success: false, message: "그룹 이름 수정 실패" });
  }
};

// GET /api/groups/intimacy/:appInstanceId
export const getIntimacyHandler = async (req: Request, res: Response) => {
  try {
    const appIdNumber = parseInt(String(req.params.appInstanceId ?? ''), 10);
    if (isNaN(appIdNumber)) {
      return res.status(400).json({ success: false, message: "올바르지 않은 appInstanceId 형식입니다." });
    }
    const data = await service.getIntimacyData(appIdNumber);
    res.status(200).json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, message: "친밀도 조회 실패" });
  }
};
