#INCLUDE "RWMAKE.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FIVEWIN.CH'
#INCLUDE 'APVT100.CH'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � User Function DV080SCR() �Autor  �  Edson Estevam       Data �  24/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para agregar a descri��o do produto no     ��
���             � Coletor de Dados                                            ��
���          �                                                             ��
�������������������������������������������������������������������������͹��
���Uso       � MAKENI                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function DV080SCR()

	Local aArea     := GetArea()
	Local aAreaSB1 := SB1->(GetArea())
	Local lWmsLote := SuperGetMv('MV_WMSLOTE',.F.,.F.)
	Local aAreaSDB  := GetArea("SDB")

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "DV080SCR" , __cUserID )

	_cProduto  := SDB->DB_PRODUTO 
	DbSelectarea("SB1")
	Dbsetorder(1)
	If SB1->(DbSeek(xFilial("SB1")+ _cProduto))
		_cDescPro := ALLTRIM(SB1->B1_DESC)

		//--  01234567890123456789
		//--0 ______Apanhe_______
		//--1 Pegue o Produto
		//--2 PA1
		//--3 Lote
		//--4 Descri��o
		//--5 AUTO000636
		//--6 ___________________
		//--7  Pressione <ENTER>

		DLVTCabec(,.F.,.F.,.T.)  
		@ 02,00 VTSay PadR("Pegue o Produto", VTMaxCol()) //'Pegue o Produto'
		//@ 02,00 VTSay SB1->B1_COD
		@ 03,00 VTSay _cDescPro
		@ 04,00 VTSay PadR("Lote",VTMaxCol()) //'Lote '
		@ 05,00 VTSay SDB->DB_LOTECTL

	Endif


	RestArea(aAreaSDB)
	RestArea(aAreaSB1)
	RestArea(aArea)
Return	
