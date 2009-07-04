#include "stdafx.h"
#include "CWorldTransform.h"

CWorldTransform::CWorldTransform() {
	Reset();
}

void CWorldTransform::Reset() {
	D3DXMatrixIdentity(&m_translate);
	D3DXMatrixIdentity(&m_rotate);
	D3DXMatrixIdentity(&m_scale);
	D3DXMatrixIdentity(&m_transform);
	m_rotationX = m_rotationY = m_rotationZ = 0.0f;
}

void CWorldTransform::TranslateAbs(float x, float y, float z) {

	m_translate._41 = x;
	m_translate._42 = y;
	m_translate._43 = z;

}

void CWorldTransform::TranslateRel(float x, float y, float z) {

	m_translate._41 += x;
	m_translate._42 += y;
	m_translate._43 += z;

}

//In Radians
void CWorldTransform::RotateAbs(float x, float y, float z) {
	m_rotationX = x;
	m_rotationY = y;
	m_rotationZ = z;
	D3DXMatrixRotationYawPitchRoll(&m_rotate, m_rotationY, m_rotationX, m_rotationZ);
}

void CWorldTransform::RotateRel(float x, float y, float z) {
	m_rotationX += x;
	m_rotationY += y;
	m_rotationZ += z;
	D3DXMatrixRotationYawPitchRoll(&m_rotate, m_rotationY, m_rotationX, m_rotationZ);
}


void CWorldTransform::ScaleAbs(float x, float y, float z) {

	m_scale._11 = x;
	m_scale._22 = y;
	m_scale._33 = z;

}

void CWorldTransform::ScaleRel(float x, float y, float z) {

	m_scale._11 += x;
	m_scale._22 += y;
	m_scale._33 += z;

}

D3DXMATRIX* CWorldTransform::GetTransform() {
	m_transform = m_scale*m_rotate*m_translate;
	return &m_transform;
}