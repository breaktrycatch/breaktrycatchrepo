#ifndef CVERTEXBUFFER_H
#define CVERTEXBUFFER_H

#include "stdafx.h"
#include "CIndexBuffer.h"

class CVertexBuffer {
	
public:
	CVertexBuffer();
	~CVertexBuffer() {Release();}

	BOOL CreateBuffer(LPDIRECT3DDEVICE9 pDevice, UINT numVertices, DWORD FVF, UINT vertexSize, BOOL dynamic = false);
	void Release();
	BOOL SetData(UINT numVertices, void *pVertices, DWORD flags = D3DLOCK_DISCARD);
	void SetIndexBuffer(CIndexBuffer* pIB);
	void Render(LPDIRECT3DDEVICE9 pDevice, UINT numPrimitives, D3DPRIMITIVETYPE primitiveType);

private:

	LPDIRECT3DVERTEXBUFFER9 m_pVB;
	CIndexBuffer* m_pIB;
	UINT m_numVerticies;
	UINT m_vertexSize;
	DWORD m_FVF;



};


#endif