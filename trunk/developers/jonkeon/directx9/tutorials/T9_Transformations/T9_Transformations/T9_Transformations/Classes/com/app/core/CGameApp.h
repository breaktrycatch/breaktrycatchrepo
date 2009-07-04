#ifndef CGAMEAPP_H
#define CGAMEAPP_H

#include "stdafx.h"
#include "CFramework.h"
#include "CVertexBuffer.h"
#include "CIndexBuffer.h"


class CGameApp : public CBaseApp {
	
public:
	CGameApp();
	~CGameApp() {Release();}
	void SetFramework(CFramework* pFramework);
	BOOL Initialize();

	virtual void Release();
	virtual void onCreateDevice(LPDIRECT3DDEVICE9 pDevice);
	virtual void onResetDevice(LPDIRECT3DDEVICE9 pDevice);
	virtual void onLostDevice();
	virtual void onDestroyDevice();
	virtual void onUpdateFrame(LPDIRECT3DDEVICE9 pDevice);
	virtual void onRenderFrame(LPDIRECT3DDEVICE9 pDevice);
	virtual void onKeyDown(WPARAM wParam);

private:
	CFramework* m_pFramework;

	CVertexBuffer m_VB4;
	CVertexBuffer m_VB6;
	CIndexBuffer m_IB;


};


#endif