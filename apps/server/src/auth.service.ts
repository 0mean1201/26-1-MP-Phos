import { OAuth2Client } from 'google-auth-library';
import jwt from 'jsonwebtoken';
import * as authRepo from './auth.repository';

const oauthClient = new OAuth2Client();
const JWT_SECRET = process.env.JWT_SECRET ?? 'phos-dev-secret';
const CLIENT_ID = process.env.PASSPORT_GOOGLE_CLIENT_ID!;

export const signInWithGoogle = async (idToken: string, appInstanceId?: number) => {
  const ticket = await oauthClient.verifyIdToken({
    idToken,
    audience: CLIENT_ID,
  });
  const payload = ticket.getPayload();
  if (!payload?.sub) throw new Error('유효하지 않은 토큰');

  const user = await authRepo.upsertUser({
    googleId: payload.sub,
    email: payload.email ?? '',
    name: payload.name ?? '',
    picture: payload.picture,
  });

  if (appInstanceId) {
    await authRepo.linkAppInstanceToUser(appInstanceId, user.id);
  }

  const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '30d' });
  return { user, token };
};

export const getUserGroupsService = async (userId: number) => {
  const groups = await authRepo.getUserGroups(userId);
  return groups.map((g) => ({
    groupId: g.id,
    groupName: g.name,
    photoCount: g._count.faces,
    representativeImagePath: g.faces[0]?.photo?.imagePath ?? null,
  }));
};
