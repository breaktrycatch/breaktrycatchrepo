#include "stdafx.h"
#include "CIndexBuffer.h"

CIndexBuffer::CIndexBuffer() {
	m_pIB = NULL;
	m_numIndices = 0;
}

void CIndexBuffer::Release() {
	SAFE_RELEASE(m_pIB);
	m_numIndices = 0;
}

BOOL CIndexBuffer::CreateBuffer(LPDIRECT3DDEVICE9 pDevice, UINT numIndicies, D3DFORMAT format, BOOL dynamic) {
	Release();
	m_numIndices = numIndicies;

	//Dynamic buffers can't be in D3DPOOL_MANAGED
	D3DPOOL pool = dynamic ? D3DPOOL_DEFAULT : D3DPOOL_MANAGED;
	UINT size = (format == D3DFMT_INDEX32) ? sizeof(UINT) : sizeof(USHORT);
	DWORD usage = dynamic ? D3DUSAGE_WRITEONLY | D3DUSAGE_DYNAMIC : D3DUSAGE_WRITEONLY;

	if (FAILED(pDevice->CreateIndexBuffer(m_numIndices*size, usage, format, pool, &m_pIB, NULL))) {
		SHOWERROR("CreateIndexBuffer Failed.", __FILE__, __LINE__);
	}

	return true;
}


BOOL CIndexBuffer::SetData(UINT numIndicies, void *pIndicies, DWORD flags) {
	if (m_pIB == NULL) {
		return FALSE;
	}

	char *pData;

	D3DINDEXBUFFER_DESC desc;
	m_pIB->GetDesc(&desc);
	UINT size = (desc.Format == D3DFMT_INDEX32) ? sizeof(UINT) : sizeof(USHORT);

	//Lock the index buffer
	if (FAILED(m_pIB->Lock(0,0,(void**)&pData, flags))) {
		return FALSE;
	}

	memcpy(pData, pIndicies, numIndicies*size);

	//Unlock the index buffer
	if (FAILED(m_pIB->Unlock())) {
		return FALSE;
	}

	return TRUE;
}
