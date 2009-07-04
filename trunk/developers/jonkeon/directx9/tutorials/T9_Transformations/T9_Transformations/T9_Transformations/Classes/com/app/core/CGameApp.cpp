#include "stdafx.h"
#include "CGameApp.h"


struct CUSTOMVERTEX {

	float x, y, z;
	DWORD color;

};

CUSTOMVERTEX g_4Vertices[] =
{
	{-1.0f, -1.0f, 5.0f, D3DCOLOR_XRGB( 255, 0, 0 )}, // 0
	{-1.0f, 1.0f, 5.0f, D3DCOLOR_XRGB( 255, 255, 0 )}, // 1
	{ 1.0f, -1.0f, 5.0f, D3DCOLOR_XRGB( 0, 255, 0 )}, // 2
	{ 1.0f, 1.0f, 5.0f, D3DCOLOR_XRGB( 0, 0, 255 )} // 3

}; 

USHORT g_indices[] = { 0, 1, 2, 1, 3, 2 };

CUSTOMVERTEX g_6Vertices[] =
{
	{-1.0f, -1.0f, 5.0f, D3DCOLOR_XRGB( 255, 0, 0 )},
	{-1.0f, 1.0f, 5.0f, D3DCOLOR_XRGB( 255, 255, 0 )},
	{ 1.0f, -1.0f, 5.0f, D3DCOLOR_XRGB( 0, 255, 0 )},
	{-1.0f, 1.0f, 5.0f, D3DCOLOR_XRGB( 255, 0, 255 )},
	{ 1.0f, 1.0f, 5.0f, D3DCOLOR_XRGB( 0, 0, 255 )},
	{ 1.0f, -1.0f, 5.0f, D3DCOLOR_XRGB( 0, 255, 255 )}

}; 







CGameApp::CGameApp() {
	m_pFramework = NULL;
	
}

void CGameApp::Release() {
	SAFE_RELEASE(m_pFramework);
}

void CGameApp::SetFramework(CFramework* pFramework) {
	m_pFramework = pFramework;
}

BOOL CGameApp::Initialize() {
	return TRUE;
}

void CGameApp::onCreateDevice( LPDIRECT3DDEVICE9 pDevice )
{
	m_VB4.CreateBuffer(pDevice, 4, D3DFVF_XYZ | D3DFVF_DIFFUSE, sizeof(CUSTOMVERTEX));
	m_VB4.SetData(4, g_4Vertices);
	m_IB.CreateBuffer(pDevice, 6, D3DFMT_INDEX16);
	m_IB.SetData(6, g_indices);
	m_VB4.SetIndexBuffer(&m_IB);
	m_VB6.CreateBuffer(pDevice, 6, D3DFVF_XYZ | D3DFVF_DIFFUSE, sizeof(CUSTOMVERTEX));
	m_VB6.SetData(6, g_6Vertices);

}

void CGameApp::onResetDevice( LPDIRECT3DDEVICE9 pDevice )
{
	
	D3DVERTEXELEMENT9 vertexDeclaration[] = {
	
		{0, 0, D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_POSITION, 0},
		{0, 12, D3DDECLTYPE_D3DCOLOR, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_COLOR, 0},
		D3DDECL_END()
	};

	LPDIRECT3DVERTEXDECLARATION9 _vertexDeclaration = 0;
	pDevice->CreateVertexDeclaration(vertexDeclaration, &_vertexDeclaration);
	pDevice->SetVertexDeclaration(_vertexDeclaration);

	//Set up render states
	pDevice->SetRenderState(D3DRS_FILLMODE, m_pFramework->GetFillMode());
	pDevice->SetRenderState(D3DRS_SHADEMODE, D3DSHADE_GOURAUD);
	pDevice->SetRenderState(D3DRS_LIGHTING, FALSE);

	//Set the world and view matrices
	D3DXMATRIX identity;
	D3DXMatrixIdentity(&identity);
	pDevice->SetTransform(D3DTS_WORLD, &identity);
	pDevice->SetTransform(D3DTS_VIEW, &identity);

	//Set the projection matrix
	D3DXMATRIX projection;
	float aspect = (float)m_pFramework->GetWidth() / (float)m_pFramework->GetHeight();
	D3DXMatrixPerspectiveFovLH( &projection, D3DX_PI / 3, aspect, 1.0f, 1000.0f );
	pDevice->SetTransform( D3DTS_PROJECTION, &projection ); 





}

void CGameApp::onLostDevice()
{
}

void CGameApp::onDestroyDevice()
{
	m_VB6.Release();
	m_VB4.Release();
	m_IB.Release();

}

void CGameApp::onUpdateFrame( LPDIRECT3DDEVICE9 pDevice )
{
}

void CGameApp::onRenderFrame(LPDIRECT3DDEVICE9 pDevice) {

	pDevice->Clear(0,0,D3DCLEAR_TARGET|D3DCLEAR_ZBUFFER, D3DCOLOR_XRGB(0,0,0), 1.0f, 0);

	pDevice->BeginScene();
	
	D3DXMATRIX world;
	D3DXMatrixTranslation(&world, -1.5f, 1.0f, 0.0f);
	pDevice->SetTransform(D3DTS_WORLD, &world);
	m_VB4.Render(pDevice, 2, D3DPT_TRIANGLELIST);

	D3DXMatrixTranslation(&world, 1.5f, -1.0f, 0.0f);
	pDevice->SetTransform(D3DTS_WORLD, &world);
	m_VB6.Render(pDevice, 2, D3DPT_TRIANGLELIST);


	pDevice->EndScene();
	pDevice->Present(0,0,0,0);

}

void CGameApp::onKeyDown(WPARAM wParam) {
	switch(wParam) {
		case VK_ESCAPE:
			PostQuitMessage(0);
		break;
		case VK_F1:
			if (m_pFramework != NULL) {
				m_pFramework->ToggleFullscreen();
			}
		break;
		case VK_F2:
			if (m_pFramework != NULL) {
				m_pFramework->ToggleWireframe();
			}
		break;
	}
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow) {

	CGameApp* pApplication = new CGameApp();
	CFramework* pFramework = new CFramework((CBaseApp*)pApplication);
	pApplication->SetFramework(pFramework);

	//Initialize any app resources
	if (!pApplication->Initialize()) {
		return 0;
	}

	//Initialize the framework
	if (!pFramework->Initialize("Creating a Framework", hInstance, 640, 480, TRUE)) {
		return 0;
	}

	pFramework->Run();

	//Clean up Resources
	SAFE_RELEASE(pApplication);

	return 0;
}

