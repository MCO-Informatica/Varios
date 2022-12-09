#INCLUDE "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACTABELA  �Autor  �Guilherme Giuliano	 � Data �  28/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina criada para reajustar percentual do pre�o unitario  ��
���          � das notas, pedidos e tabela de preco                       ���
�������������������������������������������������������������������������͹��
���Uso       � GOLD HAIR                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*****************************************************************************
User Function ACTabela   
*****************************************************************************
local nPrcBase := 0
local nNovoPrc := 0
Private cPerg := PADR("ACTABELA",10)
Ajustasx1()

Pergunte(cPerg,.F.)

IF !Pergunte(cPerg,.T.)
	Return
ENDIF
                 
IF MV_PAR02 == 0
	Msgalert("Percentual deve ser maior que 0")
	return
ENDIF

dbselectarea("DA1")
dbsetorder(1)
IF dbseek(xFilial("DA1")+MV_PAR01)
	While alltrim(DA1->DA1_CODTAB) == alltrim(MV_PAR01)
	    nPrcBase := Posicione("SB1",1,xFilial("SB1")+DA1->DA1_CODPRO,"B1_PRV1")
	    nNovoPrc := nPrcBase-(((100-MV_PAR02)*nPrcBase)/100)
	    IF nPrcBase > 0
		    RecLock("DA1",.F.)
				DA1->DA1_PRCVEN := nNovoPrc	    
		    MsUnlock() 
		ENDIF    
		DA1->(dbskip())
		loop
	Enddo                              
	PutMv("MV_X_PERC",MV_PAR02)
ENDIF
MsgInfo("Altera��es Concluidas")
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������-���
���Fun��o    � AjustaSX1    �Autor �  J.Marcelino Correa  �    03.06.2005 ���
�������������������������������������������������������������������������-���
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Tabela ?"," "," ","mv_ch1","C",3,0,0,	"G","","DA0","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"02","Porcentagem?"," "," ","mv_ch2","N",6,2,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")

RestArea(aArea)
Return