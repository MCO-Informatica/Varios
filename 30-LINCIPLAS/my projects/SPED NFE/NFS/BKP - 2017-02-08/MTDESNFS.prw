/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Ponto Entr�MTDesNFS  �                               � Data �15.02.2012���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para compor a descricao dos servicos      ���
���          � prestados, imprimir e gerar arquivo do RPS                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico LINCIPLAS                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
#Include "PROTHEUS.CH"

User Function MTDesNFS()

Local aArea     := GetArea()
Local aAreaSD2  := SD2->(GetArea())
Local aAreaSB1  := SB1->(GetArea())
Local cNota     := SF3->F3_NFISCAL
Local cSerie 	:= SF3->F3_SERIE
Local cCliente  := SF3->F3_CLIEFOR
Local cLoja     := SF3->F3_LOJA
Local xTEXT		:= ""
LOCAL xPEDIDO	:= ""
LOCAL aITENS	:= {}
LOCAL XDESCNFS	:= ""
LOCAL aFATURA	:= {}
LOCAL xMENNOTA	:= ""
Local QuebraLin	:= "\n"


DBSelectArea("SD2")
DBSetOrder(3)
If DbSeek(xFilial() + cNota + cSerie + cCliente + cLoja) 
	_cPedido := SD2->D2_PEDIDO
	dbSelectArea("SC5")                            // * Pedidos de Venda
	dbSetOrder(1)
	If DbSeek(xFilial() + _cPedido)
		While !EOF() .and. SC5->C5_NUM == _cPedido .and. SC5->C5_FILIAL == xFilial("SC5")
			xMENNOTA	:= ALLTRIM(SC5->C5_MENNOTA)+QuebraLin 			   
			SC5->(DBSkip())
		Enddo
	EndIf
	
	DBSelectArea("SE1")
	DBSetOrder(1)
	If DbSeek(xFilial() + cSerie + cNota)
		WHILE SE1->E1_NUM+SE1->E1_PREFIXO == cNota+cSerie
			IF SE1->E1_TIPO $ "AB-/CF-/CH/COF/CS-/CSS/DH/DP/EF/FT/IN-/INS/IRF/IR-/IS-/ISS/NCF/NDC/PI-/PR/R$/RA/TX/
				SE1->(DBSKIP())
				LOOP
			ELSE
				AADD(aFATURA,SE1->E1_VENCREA)
			ENDIF
			SE1->(DBSKIP())
		ENDDO
	ENDIF
	
ENDIF

xTEXT	:= xTEXT + xMENNOTA
    

FOR Z := 1 TO LEN(aFATURA)
	xTEXT	:= xTEXT + "VENCIMENTO: " +DTOC(aFATURA[Z])+ QuebraLin
NEXT



RestArea(aAreaSB1)
RestArea(aAreaSD2)
RestArea(aArea)

Return(xTEXT)
