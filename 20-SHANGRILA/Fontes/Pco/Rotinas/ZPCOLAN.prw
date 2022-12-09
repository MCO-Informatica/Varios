#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
* Funcao		:	ZPCOLAN
* Autor			:	João Zabotto
* Data			: 	20/03/2014
* Descricao		:	Faz amarração do ponto de lançamento com o lançamento padrão.
* Retorno		:
*/
User Function ZPCOLAN(cEmpFil,cLp,cSeq,cCampo)
	Local aArea		:= GetArea()
	Local cRet 		:= ''
	Local xElse

	Default cEmpFil := ''
	Default cLp 	:= ''
	Default cSeq 	:= ''
	Default cCampo 	:= ''

	If Empty(cEmpFil)
		cEmpFil := xFilial('CT5')
	Else
		cEmpFil := Padr(Alltrim(cEmpFil), TamSX3('CT5_FILIAL')[1])
	EndIf

	CT5->(DbSetOrder(1))
	If CT5->(DbSeek(cEmpFil + padR(cLp,	TAMSX3("CT5_LANPAD")[1]) + padR(cSeq,TAMSX3("CT5_SEQUEN")[1])))
		cRet := Alltrim(CT5->&(cCampo))
	EndIf

	CT1->(DbSetOrder(1))
	If CT1->(DbSeek(xFilial('CT1') + cRet))
		cRet := "IF(!Empty('" + Alltrim(CT5->&(cCampo)) + "'),'" + Alltrim(CT5->&(cCampo)) + "','' )"
	EndIf

	CTT->(DbSetOrder(1))
	If CTT->(DbSeek(xFilial('CTT') + cRet))
		cRet := "IF(!Empty('" + Alltrim(CT5->&(cCampo)) + "'),'" + Alltrim(CT5->&(cCampo)) + "','' )"
	EndIf

	CTD->(DbSetOrder(1))
	If CTD->(DbSeek(xFilial('CTD') + cRet))
		cRet := "IF(!Empty('" + Alltrim(CT5->&(cCampo)) + "'),'" + Alltrim(CT5->&(cCampo)) + "','' )"
	EndIf

	CTH->(DbSetOrder(1))
	If CTH->(DbSeek(xFilial('CTH') + cRet))
		cRet := "IF(!Empty('" + Alltrim(CT5->&(cCampo)) + "'),'" + Alltrim(CT5->&(cCampo)) + "','' )"
	EndIf

&&Posiciono nas tabelas pois os LPs não estão posicionados
&&Contas a Receber
	IF cLp $ '500|'
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial('SA1') + SE1->(E1_CLIENTE + E1_LOJA)))
	
		SED->(DbSetOrder(1))
		SED->(DbSeek(xFilial('SED') + SE1->E1_NATUREZ))
	
	&&Contas a Pagar
	ElseIF cLp $ '510|577|'
	
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial('SA2') + SE2->(E2_FORNECE + E2_LOJA)))
	
		SED->(DbSetOrder(1))
		SED->(DbSeek(xFilial('SED') + SE2->E2_NATUREZ))
	
	&&Contas a Pagar Rateio
	ElseIF cLp $ '511|'
	
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial('SA2') + SEV->(EV_CLIFOR + EV_LOJA)))
	
		SED->(DbSetOrder(1))
		SED->(DbSeek(xFilial('SED') + SEV->EV_NATUREZ))
	
	&&Movimento Bancário
	ElseIF cLp $ '562|'
	
		If !Empty(SE5->E5_CLIFOR)
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial('SA2') + SE5->(E5_CLIFOR + E5_LOJA)))
		EndIf
	
		SED->(DbSetOrder(1))
		SED->(DbSeek(xFilial('SED') + SE5->E5_NATUREZ))
	
	&&Movimento Bancário Rateio
	ElseIF cLp $ '516|'
	
		If !Empty(SE5->E5_CLIFOR)
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial('SA2') + SE5->(E5_CLIFOR + E5_LOJA)))
		EndIf
	
		SED->(DbSetOrder(1))
		SED->(DbSeek(xFilial('SED') + SE5->E5_NATUREZ))
	
	&&Documento de Entrada
	ElseIF cLp $ '650|640|651|'
		IF SD1->D1_TIPO = 'D'
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial('SA1') + SD1->(D1_FORNECE + D1_LOJA)))
		Else
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial('SA2') + SD1->(D1_FORNECE + D1_LOJA)))
		EndIF
	
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial('SF4') + SD1->D1_TES))
	
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1') + SD1->D1_COD))
	
	&&Documento de Saida
	ElseIF cLp $ '610|'
		IF SD2->D2_TIPO = 'D'
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial('SA2') + SD2->(D2_CLIENTE + D2_LOJA)))
		Else
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial('SA1') + SD2->(D2_CLIENTE + D2_LOJA)))
		EndIF
	
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial('SF4') + SD2->D2_TES))
	
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1') + SD2->D2_COD))
	
	&& RH	
	ElseIf Substr(cLp,1,1) $ 'A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|X|Y|W|Z|'
	
		SRV->(DbSetOrder(1))
		SRV->(DbSeek(xFilial('SRV') + SRD->RD_PD))
	
	EndIf

	RestArea(aArea)

Return cRet

