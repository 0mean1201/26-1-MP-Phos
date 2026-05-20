import { Request, Response } from "express";
import * as service from "./service";

// POST /api/photos
export const createPhotoHandler = async (req: Request, res: Response) => {
  try {
    const result = await service.uploadPhotoData(req.body);
    res.status(201).json({ success: true, data: result });
  } catch (error) {
    res.status(500).json({ success: false, message: "사진 저장 중 오류 발생" });
  }
};

// GET /api/groups/representatives
export const getRepresentativesHandler = async (req: Request, res: Response) => {
  try {
    const { appInstanceId } = req.params;
    const appIdNumber = parseInt(appInstanceId as string, 10);


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