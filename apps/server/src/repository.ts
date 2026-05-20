import { PrismaClient } from './generated/client';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';
import 'dotenv/config';

const adapter = new PrismaMariaDb({
  host: process.env.DATABASE_HOST,
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  connectionLimit: 5,
});

const prisma = new PrismaClient({ adapter });

export { prisma };
// 1. 사진과 얼굴 데이터를 한 번에 저장 (트랜잭션)
export const createPhotoAndFaces = async (
  appInstanceId: number,
  imagePath: string,
  vectors: { vector: any; groupId: number | null }[]
) => {
  return await prisma.photo.create({
    data: {
      appInstanceId,
      imagePath,
      faces: {
        create: vectors.map((v) => ({
          vector: v.vector,
          groupId: v.groupId,
        })),
      },
    },
    include: {
      faces: true,
    },
  });
};
 
// 2. 특정 사용자의 그룹별 대표 얼굴 조회
export const findGroupsWithRepresentative = async (appInstanceId: number) => {
  return await prisma.group.findMany({
    where: { appInstanceId },
    include: {
      faces: {
        take: 1,
        orderBy: { id: 'asc' },
      },
    },
  });
};

// repository.ts에 추가
export const countGroups = async (appInstanceId: number) => {
  return await prisma.group.count({ where: { appInstanceId } });
};

export const createGroup = async (appInstanceId: number, name: string) => {
  return await prisma.group.create({ data: { appInstanceId, name } });
};