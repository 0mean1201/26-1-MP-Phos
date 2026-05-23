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

app.get("/test-db", async (_req: Request, res: Response) => {
  const mysql = await import("mysql2/promise");
  try {
    const conn = await mysql.createConnection({
      host: process.env.DATABASE_HOST,
      port: parseInt(process.env.DATABASE_PORT || "3306"),
      user: process.env.DATABASE_USER,
      password: process.env.DATABASE_PASSWORD,
      database: process.env.DATABASE_NAME,
      connectTimeout: 10000,
    });
    await conn.execute("SELECT 1");
    await conn.end();
    res.json({ success: true, host: process.env.DATABASE_HOST, port: process.env.DATABASE_PORT });
  } catch (e) {
    res.json({ success: false, host: process.env.DATABASE_HOST, port: process.env.DATABASE_PORT, error: String(e) });
  }
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
