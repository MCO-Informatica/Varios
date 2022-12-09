#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF2460I   บAutor  ณBruno Abrigo        บ Data ณ  01/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para tratar o volume do Pedido             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ METALACRE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SF2460I()
Local _aAliasSF2:= GetArea()

If cEmpAnt <> '01'
	Return .t.
Endif

DbSelectArea("SD2")
SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))

if !SD2->(Eof())
	&& Percorre itens Faturados e armazena a somatoria da quantidade, peso liquido e peso Bruto:
	While !SD2->(Eof()) .and. xFilial("SD2") == SD2->D2_FILIAL .and. ;
	                         SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		
		dbSelectArea("Z01")
		Z01->(dbSetOrder(1))
		If Z01->(dbSeek(xFilial("Z01")+SC6->C6_XLACRE+SD2->D2_PEDIDO+SD2->D2_ITEMPV ))
			Z01->(RecLock("Z01",.F.))
			Z01->Z01_STAT:="5"
			Z01->(MsUnlock())
		Endif      
		
//		U_ChkLacre(SC6->C6_XLACRE)
		
		DBSELECTAREA("SD2")
		SD2->(DbSkip())
	Enddo
Else
	Conout("Ponto de entrada SF2460I "+HORA() + " Pedido nใo econtrado")
Endif

RestArea(_aAliasSF2)
Return
