#ifndef CINDEXBUFFER_H
#define CINDEXBUFFER_H

#include "stdafx.h"

class CIndexBuffer {

public: 
	CIndexBuffer();
	~CIndexBuffer() {Release();}
	BOOL CreateBuffer(LPDIRECT3DDEVICE9 pDevice, UINT numIndicies, D3DFORMAT format, BOOL dynamic = FALSE);
	void Release();
	BOOL SetData(UINT numIndices, void *pIndices, DWORD flags = D3DLOCK_DISCARD);
	LPDIRECT3DINDEXBUFFER9 GetBuffer() {return m_pIB;}

private:
	LPDIRECT3DINDEXBUFFER9 m_pIB;
	UINT m_numIndices;



};


#endif