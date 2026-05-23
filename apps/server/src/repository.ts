import { PrismaClient } from './generated/client';
import 'dotenv/config';

const prisma = new PrismaClient();

export { prisma };

export const createAppInstance = async () => {
  return await prisma.appInstance.create({ data: {} });
};

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

export const findGroupsWithFaceCounts = async (appInstanceId: number) => {
  return await prisma.group.findMany({
    where: { appInstanceId },
    include: {
      faces: {
        take: 1,
        orderBy: { id: 'asc' },
        include: { photo: true },
      },
      _count: { select: { faces: true } },
    },
    orderBy: { faces: { _count: 'desc' } },
  });
};

export const countGroups = async (appInstanceId: number) => {
  return await prisma.group.count({ where: { appInstanceId } });
};

export const createGroup = async (appInstanceId: number, name: string) => {
  return await prisma.group.create({ data: { appInstanceId, name } });
};

export const updateGroupName = async (groupId: number, name: string) => {
  return await prisma.group.update({ where: { id: groupId }, data: { name } });
};
