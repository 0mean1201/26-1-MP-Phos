import { prisma } from './repository';

export const upsertUser = async (data: {
  googleId: string;
  email: string;
  name: string;
  picture?: string | null;
}) => {
  return prisma.user.upsert({
    where: { googleId: data.googleId },
    update: { email: data.email, name: data.name, picture: data.picture },
    create: data,
  });
};

export const linkAppInstanceToUser = async (appInstanceId: number, userId: number) => {
  return prisma.appInstance.update({
    where: { id: appInstanceId },
    data: { userId },
  });
};

export const getUserGroups = async (userId: number) => {
  return prisma.group.findMany({
    where: { appInstance: { userId } },
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
