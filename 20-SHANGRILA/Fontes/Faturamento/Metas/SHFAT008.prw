#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  |SFATA003   บAutor  ณFelipe Valenca      บ Data ณ  05/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela cotendo resumo de metas por regiao...                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Shangri-la                                                     บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*---------------------*
User Function SHFAT008()
Local aSays   		:= {}
Local aButtons 		:= {}
Local cPerg    		:= "SHFAT007"
Private cCampo := ""
Private aParamBox	:= {}
Private aCombo    := {'Valor Pmv','Quantidade'}
Private aRet      := {}
Private aCombo	  := {'Sim','Nใo'}

aAdd(aSays," Rotina Respons้vel por efetuar a Gera็ใo do Budget Anual conforme faturamento	")
aAdd(aSays,"             																")
aAdd(aSays,"                                            								")
aAdd(aSays," Desenvolvido Por Joใo Zabotto - Totvs IP   								")
aAdd(aSays,"                                            								")
aAdd(aSays," Clique no botao OK para continuar.											")

aAdd(aButtons,{5,.T.,{|| AjustaPerg() }})
aAdd(aButtons,{1,.T.,{|| Processa({|lEnd| lOk := Processar(),FechaBatch() },"Aguarde... !!!" ) }})
aAdd(aButtons,{2,.T.,{||  lOk := .F. ,FechaBatch() }})

FormBatch(FunDesc(),aSays,aButtons)


Return


/**
* Funcao		:	AjustaPerg
* Autor			:	Joใo Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
Local cPerg		:= "SHFAT008"
Local lRet		:= .F.
Local cCodigo   := ''

cCodigo   := STRZERO(Val(U_SH003COD('SZ5','Z5_CODIGO',9)),TamSx3('Z5_CODIGO')[1])

aParamBox:= {}

aAdd(@aParamBox,{1,"Codigo Budget"   	,STRZERO(Val(U_SH003COD('SZ5','Z5_CODIGO',9)),TamSx3('Z5_CODIGO')[1])                       ,""    ,"","","", 50,.F.})		// MV_PAR01
aAdd(@aParamBox,{1,"Descri็ao"          ,Space(TamSx3('Z5_DESCRIC')[1]),""    ,"","","", 100,.F.})		// MV_PAR02
aAdd(@aParamBox,{1,"Ano"	 	        ,Space(TamSx3('Z5_ANO')[1])    ,""    ,"","","", 100,.F.})		// MV_PAR03
aAdd(@aParamBox,{1,"Valor"	 	        ,TamSx3('Z5_TOTAL')[1]  ,PesqPict("SZ5","Z5_TOTAL")    ,"","","", 50,.F.})		// MV_PAR04
aAdd(@aParamBox,{1,"Data De"   	    	,	StoD(""),"","","","", 50,.F.})
aAdd(@aParamBox,{1,"Data Ate"   	    ,	StoD(""),"","","","", 50,.F.})
aAdd(@aParamBox,{2,"Boqueado?"          ,1      ,aCombo,50,"",.F.}) && MV_PAR06

If ParamBox(aParamBox,"Parโmetros",@aRet)
	lRet := .T.
Else
	lRet := .F.
EndIf

Return(lRet)

Static Function Processar()
Local lRet := .T.
Local cAlias008		:= GetNextAlias()
Local aRetVen   := {}
Local aRetVenQ  := {}
Local aRetDev  	:= {}
Local aRetDevQ  := {}
Local nValPmv   := 0
Local nCount    := 0
Local nTotPrev  := 0
Local nReg 		:= 0
local dData     := cTod('01/01/' + Alltrim(MV_PAR03) )
Local aQuery    := {}
Local cBloc     := ''
Local cWhere    := ''

If Valtype(MV_PAR07) == 'N'
	MV_PAR07 := '1'
EndIf

If MV_PAR07 $ 'Nใo'
	cWhere := "% AND SB1.B1_MSBLQL IN ('2','') %"
Else
	cWhere := "% AND SB1.B1_MSBLQL IN ('1','2','') %"
EndIf

If Empty(aRet)
	lRet := AjustaPerg()
EndIf
If aviso("Gera็ใo Budget","Confirma Gera็ใo Budget para o ano " + MV_PAR03 ,{"SIM","NAO"},3)=1
	If lRet
		BeginSql Alias cAlias008
			SELECT D2_COD,B1_DESC,B1_GRUPO,B1_TIPO
			FROM %TABLE:SD2% SD2
			INNER JOIN %TABLE:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD AND SB1.%NOTDEL%
			%Exp:cWhere%
			INNER JOIN %TABLE:SF4% SF4 ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_DUPLIC = 'S' AND SF4.%NOTDEL%
			INNER JOIN %TABLE:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D2_DOC = SF2.F2_DOC AND	SD2.D2_SERIE = SF2.F2_SERIE AND SF2.F2_TIPO = 'N' AND SF2.%NOTDEL%
			
			WHERE
			SD2.D2_FILIAL = %xfilial:SD2%
			AND SF2.F2_FILIAL = %xfilial:SF2%
			AND SF4.F4_FILIAL = %xfilial:SF4%
			AND SB1.B1_FILIAL = %xfilial:SB1%
			AND SD2.D2_EMISSAO BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
			AND SD2.D2_TP <> 'AT'
			AND SD2.%NOTDEL%
			GROUP BY  D2_COD,B1_DESC,B1_GRUPO,B1_TIPO
			ORDER BY D2_COD
		EndSql
		
		aQuery := GETLastQuery()
		
		Count to nReg
		
		(cAlias008)->(DbGotop())
		If !(cAlias008)->(Eof())
			If Reclock('SZ5',.T.)
				SZ5->Z5_FILIAL  := xFilial('SZ5')
				SZ5->Z5_CODIGO  := MV_PAR01
				SZ5->Z5_DESCRIC := MV_PAR02
				SZ5->Z5_ANO     := MV_PAR03
				SZ5->Z5_TOTAL   := MV_PAR04
				SZ5->Z5_VLRPRE  := 0
				SZ5->Z5_PERINI  := MV_PAR05
				SZ5->Z5_PERFIM  := MV_PAR06
				MsUnlock()
			EndIf
		EndIf
		
		ProcRegua(nReg)
		
		SZ5->(DbSetOrder(1))
		If SZ5->(DbSeek(xFilial('SZ5') + MV_PAR01))
			While !(cAlias008)->(Eof())
				IncProc("Processando Budget: " + MV_PAR03 + ' - ' + Alltrim((cAlias008)->D2_COD))
				aRetVen   := {}
				aRetVenQ  := {}
				aRetDev   := {}
				aRetDevQ  := {}
				nCount++
				aRetVen  := U_SHFATPMV(1,(cAlias008)->D2_COD,(cAlias008)->B1_GRUPO,MV_PAR05,MV_PAR06)
				aRetVenQ := U_SHFATPMV(2,(cAlias008)->D2_COD,(cAlias008)->B1_GRUPO,MV_PAR05,MV_PAR06)
				aRetDev  := U_SHFATPMV(3,(cAlias008)->D2_COD,(cAlias008)->B1_GRUPO,MV_PAR05,MV_PAR06)
				aRetDevQ := U_SHFATPMV(4,(cAlias008)->D2_COD,(cAlias008)->B1_GRUPO,MV_PAR05,MV_PAR06)
				If Reclock('SZ6',.T.)
					SZ6->Z6_FILIAL  := xFilial('SZ5')
					SZ6->Z6_CODIGO  := MV_PAR01
					SZ6->Z6_SEQUEN  := StrZero(nCount,3)
					SZ6->Z6_PRODUTO := (cAlias008)->D2_COD
					SZ6->Z6_PRDDESC := (cAlias008)->B1_DESC
					SZ6->Z6_GRUPO   := (cAlias008)->B1_GRUPO
					SZ6->Z6_TIPO    := (cAlias008)->B1_TIPO
					nValPmv := If(aRetVen[1] > 0 ,Round((aRetVen[1] - aRetDev[1])/(aRetVenQ[2] - aRetDevQ[2]),2),0)
					SZ6->Z6_VLRPMV  := nValPmv
					SZ6->Z6_QUANT   := Round((aRetVenQ[2] - aRetDevQ[2]),2)
					SZ6->Z6_QTDANT  := Round((aRetVenQ[2] - aRetDevQ[2]),2)
					SZ6->Z6_TOTANT  := Round(SZ6->Z6_QUANT * nValPmv,2)
					SZ6->Z6_VALOR   := Round(SZ6->Z6_QUANT * nValPmv,2)
					MsUnlock()
				EndIf
				nTotPrev += Round(SZ6->Z6_QUANT * nValPmv,2)
				(cAlias008)->(DbSkip())
			EndDo
			If SZ5->(DbSeek(xFilial('SZ5') + MV_PAR01))
				If Reclock('SZ5',.F.)
					SZ5->Z5_VLRPRE  := nTotPrev
					MsUnlock()
				EndIf
			EndIf
		EndIf
	EndIf
EndIF
Return



