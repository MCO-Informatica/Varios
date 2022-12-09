#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	21/01/2014
* Descricao		:	
* Retorno		: 	
*/
User Function SHFAT016()
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Private cPerg    		:= "SHREAJUS"
	Private cCampo := ""
	Private aParamBox	:= {}
	Private aCombo    := {'Valor Pmv','Quantidade'}
	Private aRet      := {}

	If Aviso('Copia do Budget','Deseja Efetuar a Copia do BudGet: ' + Alltrim(SZ5->Z5_CODIGO) + '/' + Alltrim(SZ5->Z5_ANO) ,{'SIM','NAO'}) == 1
		Processar(Alltrim(SZ5->Z5_CODIGO),Alltrim(SZ5->Z5_DESCRIC),SZ5->Z5_TOTAL,SZ5->Z5_VLRPRE,Alltrim(SZ5->Z5_ANO),SZ5->Z5_PERINI,SZ5->Z5_PERFIM )
	EndIf

Return

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	14/03/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function Processar(cCod,cDesc,nTotal,nValor,cAno,dDataIni,dDataFim)
	Local aRegistro   := {}
	Local nPosicao    := 0
	Local lret := .F.
	Local cCodigo   := STRZERO(Val(U_SH003COD('SZ5','Z5_CODIGO',9)),TamSx3('Z5_CODIGO')[1])
	Local cAlias := ''
	
	SZ5->(DbSetOrder(1))
	If !SZ5->(DbSeek(xFilial('SZ5') + cCodigo))
		If RecLock('SZ5',.T.)
			SZ5->Z5_FILIAL := xFilial('SZ5')
			SZ5->Z5_CODIGO := cCodigo
			SZ5->Z5_DESCRIC:= cDesc
			SZ5->Z5_TOTAL  := nTotal
			SZ5->Z5_VLRPRE := nValor
			SZ5->Z5_ANO    := cAno
			SZ5->Z5_PERINI := dDataIni
			SZ5->Z5_PERFIM := dDataFim
			SZ5->(MsUnlock())
		EndIf
		
		If SZ5->(DbSeek(xFilial('SZ5') + cCodigo))
		
			cAlias := GetNextAlias()
			BeginSql Alias cAlias
				SELECT *
				FROM %TABLE:SZ6% SZ6
				WHERE
				SZ6.Z6_FILIAL = %xFilial:SZ6% AND
				SZ6.Z6_CODIGO   = %Exp:cCod%    AND
				SZ6.%notDel%
				Order By Z6_SEQUEN
			EndSql
		
			While !(cAlias)->(Eof())
					
				IF Reclock('SZ6',.T.)
					SZ6->Z6_FILIAL	:= xFilial('SZ6')
					SZ6->Z6_CODIGO	:= cCodigo
					SZ6->Z6_SEQUEN	:= (cAlias)->Z6_SEQUEN
					SZ6->Z6_PRODUTO	:= (cAlias)->Z6_PRODUTO
					SZ6->Z6_PRDDESC	:= (cAlias)->Z6_PRDDESC
					SZ6->Z6_GRUPO	:= (cAlias)->Z6_GRUPO
					SZ6->Z6_TIPO	:= (cAlias)->Z6_TIPO
					SZ6->Z6_VLRPMV	:= (cAlias)->Z6_VLRPMV
					SZ6->Z6_QTDANT	:= (cAlias)->Z6_QTDANT
					SZ6->Z6_TOTANT	:= (cAlias)->Z6_TOTANT
					SZ6->Z6_QUANT	:= (cAlias)->Z6_QUANT
					SZ6->Z6_VALOR	:= (cAlias)->Z6_VALOR
					SZ6->(DbSkip())
				EndIf
				(cAlias)->(DbSkip())
			EndDo
			
			(cAlias)->(DbCloseArea())
		EndIf
	EndIf

Return

