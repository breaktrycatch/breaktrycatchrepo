#include "stdafx.h"
#include "CVertexBuffer.h"

CVertexBuffer::CVertexBuffer() {
	m_pVB = NULL;
	m_pIB = NULL;
	m_numVerticies = 0;
	m_FVF = 0;
	m_vertexSize = 0;
}

BOOL CVertexBuffer::CreateBuffer(LPDIRECT3DDEVICE9 pDevice, UINT numVertices, DWORD FVF, UINT vertexSize, BOOL dynamic) {

	Release();

	m_numVerticies = numVertices;
	m_FVF = FVF;
	m_vertexSize = vertexSize;

	//Dynamic buffers can't be in D3DPOOL_MANAGED
	D3DPOOL pool = dynamic ? D3DPOOL_DEFAULT : D3DPOOL_MANAGED;
	DWORD usage = dynamic ? D3DUSAGE_WRITEONLY | D3DUSAGE_DYNAMIC : D3DUSAGE_WRITEONLY;

	if (FAILED (pDevice->CreateVertexBuffer(m_numVerticies*m_vertexSize, usage, m_FVF, pool, &m_pVB, NULL))) {
		SHOWERROR("CreateVertexBuffer Failed.", __FILE__, __LINE__);
		return FALSE;
	}

	return true;
}


void CVertexBuffer::Release() {

	SAFE_RELEASE(m_pVB);
	m_numVerticies = 0;
	m_FVF = 0;
	m_vertexSize = 0;
	//Index buffer is released in CIndexBuffer
	m_pIB = NULL;

}

BOOL CVertexBuffer::SetData(UINT numVertices, void *pVertices, DWORD flags) {
	
	if (m_pVB == NULL) {
		return FALSE;
	}

	char *pData;

	//Lock the vertex buffer
	if (FAILED(m_pVB->Lock(0,0,(void**)&pData, flags))) {
		SHOWERROR("IDirect3DVertexBuffer9::Lock Failed.", __FILE__, __LINE__);
		return false;
	}

	//Copy verticies to vertex buffer
	memcpy(pData, pVertices, numVertices*m_vertexSize);

	//unlock verticies
	if (FAILED(m_pVB->Unlock())) {
		SHOWERROR("IDirect3DVertexBuffer9::Unlock Failed.", __FILE__, __LINE__);
		return false;
	}

	return true;

}

void CVertexBuffer::SetIndexBuffer(CIndexBuffer* pIB) {
	m_pIB = pIB;
}

void CVertexBuffer::Render(LPDIRECT3DDEVICE9 pDevice, UINT numPrimitives, D3DPRIMITIVETYPE primitiveType) {
	if (pDevice == NULL) {
		
		return;

	}

	pDevice->SetStreamSource(0,m_pVB,0,m_vertexSize);
	pDevice->SetFVF(m_FVF);

	if (m_pIB) {
		pDevice->SetIndices(m_pIB->GetBuffer());
		pDevice->DrawIndexedPrimitive(primitiveType, 0, 0, m_numVerticies, 0, numPrimitives);
	}
	else {
		pDevice->DrawPrimitive(primitiveType, 0, numPrimitives);
	}
}

