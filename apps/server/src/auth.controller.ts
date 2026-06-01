import { Request, Response } from 'express';
import * as authService from './auth.service';

// POST /api/auth/google
// body: { idToken: string, appInstanceId?: number }
export const googleSignInHandler = async (req: Request, res: Response) => {
  try {
    const { idToken, appInstanceId } = req.body;
    if (!idToken) {
      return res.status(400).json({ success: false, message: 'idToken이 필요합니다.' });
    }
    const result = await authService.signInWithGoogle(
      idToken,
      appInstanceId ? Number(appInstanceId) : undefined,
    );
    res.json({ success: true, data: result });
  } catch (e) {
    console.error('[auth] Google 로그인 오류:', e);
    res.status(401).json({ success: false, message: 'Google 인증 실패' });
  }
};

// GET /api/users/:userId/groups
export const getUserGroupsHandler = async (req: Request, res: Response) => {
  try {
    const userId = parseInt(String(req.params.userId ?? ''), 10);
    if (isNaN(userId)) {
      return res.status(400).json({ success: false, message: '잘못된 userId' });
    }
    const data = await authService.getUserGroupsService(userId);
    res.json({ success: true, data });
  } catch (e) {
    res.status(500).json({ success: false, message: '그룹 조회 실패' });
  }
};
