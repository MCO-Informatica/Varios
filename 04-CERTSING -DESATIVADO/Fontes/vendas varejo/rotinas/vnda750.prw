#include 'protheus.ch'
#include 'parmtype.ch'

user function vnda750(aParSch, cOrigem)
	Local lJob := Select("SX6") <= 0
	
	Default cOrigem := ''
	Private cJobEmp	:= Iif( aParSch == NIL, '01', aParSch[ 1 ] )	
	Private cJobFil	:= Iif( aParSch == NIL, '02', aParSch[ 2 ] )
	
	Conout("Job vnda750 - Begin Emp("+cJobEmp+"/"+cJobFil+") Date "+DtoS(Date())+"-"+Time() )
	If lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp, cJobFil)
	EndIf
	
	v750Proc(cOrigem)
	
	Conout("Job vnda750 - End Begin Emp("+cJobEmp+"/"+cJobFil+") Date "+DtoS(Date())+"-"+Time() )
return

Static Function v750Proc(cOrigem)
	Local cJson			:= ""
	Local cCodOri		:= ""
	Local cUpd			:= ""
	Local cCatego		:= ""
	Local cWhere		:= "% %"
	Local cTRB			:= GetNextAlias()
	Local cMV_SFORCE	:= 'MV_SALESF'
	Local lMV_SFORCE	:= .F.
	
	If .NOT. GetMv( cMV_SFORCE, .T. )
		CriarSX6( cMV_SFORCE, 'L', 'INTEGRACAO SALESFORCE ATIVA/DESATIVA', '.F.' )
	Endif

	lMV_SFORCE := GetMv( cMV_SFORCE, .F. )

	IF cOrigem == 'OS010GRV'
		cWhere := "% ZI_TABPRE = '" + DA0->DA0_CODTAB + "' AND ZI_XTIPINT <> ' ' AND ZI_KITCOMB = 'S' AND %"
	ElseIF cOrigem == 'CSTA110'
		cWhere := "% ZI_XTIPINT <> ' ' AND ZI_KITCOMB = 'S' AND %"
	Else
		cWhere := "% ZI_XTIPINT <> ' ' AND ZI_KITCOMB = 'S' AND ZI_XDTINT = ' ' AND %"
	EndIF

	Beginsql Alias cTRB
		SELECT 
			ZI_PROKIT, 
			ZI_PROGAR, 
			ZI_COMBO, 
			ZJ_CODPROD, 
			ZJ_QTDBAS, 
			ZJ_PRETAB, 
			ZJ_PROGAR, 
			ZI_XTIPINT 
		FROM %Table:SZI% SZI 
			INNER JOIN %Table:SZJ% SZJ 
					ON ZI_FILIAL = ZJ_FILIAL 
						AND ZI_COMBO = ZJ_COMBO 
						AND SZJ.%NOTDEL% 
			INNER JOIN %Table:DA1% DA1 
					ON DA1_FILIAL = %xFilial:DA1% 
						AND DA1_CODTAB = ZI_TABPRE 
						AND DA1_CODCOB = ZI_COMBO 
						AND DA1_ATIVO = '1'
						AND DA1.%NOTDEL%
		WHERE
		   ZI_FILIAL = %xFilial:SZI% AND
		   ZJ_ITEM = ZJ_ITEMORI AND
		   %Exp:cWhere%
		   SZI.%NOTDEL%
		ORDER BY
			ZI_COMBO
	EndSql
	
	SB1->(DbSetOrder(1))
	
	While !(cTRB)->(EoF())
		cJson := '{'
		cJson += '  "operacao":"'+(cTRB)->ZI_XTIPINT+'",'
		cJson += '  "codigoProtheus":"'+Alltrim((cTRB)->ZI_PROKIT)+'",'
		cJson += '  "codigoOrigem":"'+Alltrim((cTRB)->ZI_PROGAR)+'",'
		cJson += '  "codigoCombo":"'+Alltrim((cTRB)->ZI_COMBO)+'",'
		cJson += '  "itens":['
		
		cCodOri		:= (cTRB)->ZI_COMBO
		
		While !(cTRB)->(EoF()) .and. (cTRB)->ZI_COMBO == cCodOri 
			
			cCatego := Posicione("SB1",1,xFilial("SB1")+Alltrim((cTRB)->ZJ_CODPROD),"B1_CATEGO")
			
			If cCatego <> "1" .OR. lMV_SFORCE
				cJson += '    {'
				cJson += '      "codigoProtheus":"'+Alltrim((cTRB)->ZJ_CODPROD)+'",'
				cJson += '      "codigoOrigem":"'+ IIF ( ! Empty(Alltrim((cTRB)->ZJ_PROGAR)),Alltrim((cTRB)->ZJ_PROGAR),Alltrim((cTRB)->ZJ_CODPROD))+'",'
				cJson += '      "valorUnitario":"'+Alltrim(Str((cTRB)->ZJ_PRETAB,8,2))+'",'
				cJson += '      "quantidade":"'+Alltrim(Str((cTRB)->ZJ_QTDBAS))+'"'
				cJson += '    },'
			Endif
			
			(cTRB)->(DbSkip())
		EndDo
		cJson := SubStr(cJson,1,Len(cJson)-1)
		cJson += ' ]'
		cJson += '}'
		
		If v750Env(cJson)
			Conout('Atualiza-Combo: ' + cJson)
			cUpd := "UPDATE "+RetSqlName("SZI")+" SET ZI_XDTINT = '"+DtoC(Date())+" "+Time()+"' WHERE ZI_FILIAL = '"+xFilial("SZI")+"' AND  ZI_COMBO = '"+cCodOri+"' "
			If TCSQLExec( cUpd ) < 0
				MsgStop("[vnda750] Inconsistencia atualizar campo integração Portal "+CRLF+TCSQLError())
				Conout("[vnda750] Inconsistencia atualizar campo integração Portal "+CRLF+TCSQLError())
			EndIf
		EndIf
	EndDo

	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return

Static Function v750Env(cJsonEnv)
	Local oWsObj 	:= WSVVHubServiceService():New()
	Local cCategory 	:= 'ATUALIZA-COMBO'	
	Local cError 		:= ''
	Local cSoapFCode 	:= ''
	Local cSoapFDescr 	:= ''
	Local cSvcError	 	:= ''
	Local cWarning 		:= ''
	
	Local lOk 			:= .T.
	
	Local oWsRes
	Local oWsObj
	
	oWsObj := WSVVHubServiceService():New()
	lOk := oWsObj:sendMessage( cCategory, cJsonEnv )
	cSvcError := GetWSCError()  // Resumo do erro
	cSoapFCode := GetWSCError(2)  // Soap Fault Code
	cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
	If .NOT. Empty( cSoapFCode )
		//Caso a ocorrência de erro esteja com o fault_code preenchido, a mesma teve relação com a chamada do serviço . 
		Conout( cSoapFDescr + ' ' + cSoapFCode )
		Return( .F. )
	Elseif .NOT. Empty( cSvcError )
		//Caso a ocorrência não tenha o soap_code preenchido ela está relacionada a uma outra falha, provavelmente local ou interna.
		Conout( cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVIÇO' )
		Return( .F. )
	Endif
	
Return(lOk)