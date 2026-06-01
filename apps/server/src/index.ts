import dotenv from "dotenv";
dotenv.config();
import express, { Express, Request, Response } from "express";
import cors from "cors";
import { execSync } from "child_process";
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


app.post("/api/app-instances", registerAppInstanceHandler);
app.post("/api/photos", createPhotoHandler);
app.post("/api/groups", createGroupHandler);
app.patch("/api/groups/:groupId", updateGroupHandler);
app.get("/api/groups/representatives/:appInstanceId", getRepresentativesHandler);
app.get("/api/groups/intimacy/:appInstanceId", getIntimacyHandler);

try {
  execSync("npx prisma db push --accept-data-loss", { stdio: "inherit" });
  console.log("[db]: Schema synced successfully");
} catch (e) {
  console.error("[db]: prisma db push failed:", e);
}

app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});
