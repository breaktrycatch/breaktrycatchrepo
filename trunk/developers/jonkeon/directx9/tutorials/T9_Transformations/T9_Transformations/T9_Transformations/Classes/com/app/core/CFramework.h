#ifndef CFRAMEWORK_H
#define CFRAMEWORK_H

#include "stdafx.h"
#include "CGraphics.h"

class CBaseApp {
	
public:

	virtual ~CBaseApp() {}
	virtual void Release() = 0;
	virtual void onCreateDevice(LPDIRECT3DDEVICE9 pDevice) = 0;
	virtual void onResetDevice(LPDIRECT3DDEVICE9 pDevice) = 0;
	virtual void onLostDevice() = 0;
	virtual void onDestroyDevice() = 0;
	virtual void onUpdateFrame(LPDIRECT3DDEVICE9 pDevice) = 0;
	virtual void onRenderFrame(LPDIRECT3DDEVICE9 pDevice) = 0;
	virtual void onKeyDown(WPARAM wParam) = 0;
};

class CFramework {
	
public:
	CFramework(CBaseApp* pGameApp);
	~CFramework() {Release();}
	BOOL Initialize(char* title, HINSTANCE hInstance, int width, int height, BOOL windowed = TRUE);
	void Run();
	void Release();
	void ToggleFullscreen();
	void ToggleWireframe();

	DWORD GetFillMode();
	int GetWidth();
	int GetHeight();

	static LRESULT CALLBACK StaticWndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

private:
	LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
	void onCreateDevice();
	void onResetDevice();
	void onLostDevice();
	void onDestroyDevice();
	void onUpdateFrame();
	void onRenderFrame();

	HWND m_hWnd;
	HINSTANCE m_hInstance;
	BOOL m_active;
	int m_windowWidth;
	int m_windowHeight;
	int             m_fullscreenWidth;
	int             m_fullscreenHeight;
	WINDOWPLACEMENT m_wp;

	DWORD           m_fillMode;

	CGraphics* m_pGraphics;
	CBaseApp* m_pGameApp;

};

#endif