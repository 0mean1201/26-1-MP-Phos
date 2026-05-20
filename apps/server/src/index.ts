import dotenv from "dotenv";
dotenv.config();
import express, { Express, Request, Response } from "express";
import cors from "cors";
import {
  registerAppInstanceHandler,
  createPhotoHandler,
  createGroupHandler,
  updateGroupHandler,
  getRepresentativesHandler,
  getIntimacyHandler,
} from "./controller";

const app: Express = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.static('public'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.get("/", (_req: Request, res: Response) => {
  res.send("Hello World! This is TypeScript Server!");
});

// 앱 인스턴스 등록
app.post("/api/app-instances", registerAppInstanceHandler);

// 사진 등록 (얼굴 벡터 + 그룹 정보 포함)
app.post("/api/photos", createPhotoHandler);

// 그룹 생성
app.post("/api/groups", createGroupHandler);

// 그룹 이름 수정
app.patch("/api/groups/:groupId", updateGroupHandler);

// 그룹별 대표 얼굴 벡터 조회
app.get("/api/groups/representatives/:appInstanceId", getRepresentativesHandler);

// 친밀도(그룹별 사진 수) 조회
app.get("/api/groups/intimacy/:appInstanceId", getIntimacyHandler);

app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});
