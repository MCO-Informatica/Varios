#include "totvs.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100GE2  �Autor  � Logos Tecnology    � Data �  02/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para grava��o do titulo a pagar gerado     ���
���          �pela importa��o TXT - historico especifico no titulo        ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICO VERION                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Utilizado em conjunto com a rotina NFIMPVER.PRW
User Function MT100GE2
Local _nPosProc := 0
Local _dDtDI 	:= ""
Local _cNumDI 	:= ""
//ExecBlock("MT100GE2",.F.,.F.,{aColsSE2[nX],nOpcA,aHeadSE2})
If l103Auto
	If ( _nPosProc := aScan(_aProcNF,{|x| x[1][3][2] == SE2->E2_NUM}) )> 0
		If !Empty(_aProcNF[_nPosProc][1][17][2])
			_dDtDI := DTOC( _aProcNF[_nPosProc][1][17][2] )
		Endif
		If !Empty(_aProcNF[_nPosProc][1][16][2])
			_cNumDI := _aProcNF[_nPosProc][1][16][2]
		Endif
	Endif
	RecLock("SE2",.F.)
	SE2->E2_HIST := "DI "+_cNumDI+" "+_dDtDI
	MsUnlock()
Endif
Return

