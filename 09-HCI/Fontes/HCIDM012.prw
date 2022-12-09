#include "Protheus.CH"
#include "TopConn.Ch"
#include "RwMake.Ch"

User Function HCIDM012(aParamEmp)

	Local _aEmp             		   
	
	Private _aEmprFil	:= {}
	
	If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"

		RpcSetType(3)
		RpcSetEnv(aParamEmp[1],aParamEmp[2])	
              
		Conout("Inicio - HCIDM012")
        u__fHDM012()
        Conout("Fim - HCIDM012")
        
        RpcClearEnv()
	EndIf

Return()

User Function _fHDM012()
	
	Local _aEmail		:= Separa(GetMv("ES_WFSTCLI",,"000148"),",")
	Local _cSend		:= ""
	Local _cAssunto		:= "SITUAÇÃO DE CLIENTES"
	Local _cMsg			:= ""
	Local _oProcess		:= Nil
	Local _oHtml		:= Nil
	Local _cQuery		:= ""
	Local _cAliasQry	:= GetNextAlias()
	Local _aCliAtv		:= {}
	Local _aCliOrc		:= {}
	Local _aCliInt		:= {}
	Local _nI			:= 0
	Local _cDtCort		:= DtoS(dDataBase - GetMv("ES_HCIDA09",,30))
	Local _cPara		:= ""
	
	Conout("Inicio - _FHCIDM012")
	
	_cQuery += " 		SELECT DISTINCT A1_FILIAL  "+CRLF
	_cQuery += " 		,A1_COD  "+CRLF
	_cQuery += " 		,A1_LOJA "+CRLF
	_cQuery += " 		,A1_NOME    "+CRLF
	_cQuery += " 		,A1_NREDUZ   "+CRLF
	_cQuery += " 		,A1_CGC    "+CRLF
	_cQuery += " 		,A1_SATIV1 "+CRLF
	_cQuery += " 		,A1_DDD "+CRLF
	_cQuery += " 		,A1_TEL "+CRLF
	_cQuery += " 		,A1_CEP  "+CRLF
	_cQuery += " 		,A1_END  "+CRLF
	_cQuery += " 		,A1_BAIRRO "+CRLF
	_cQuery += " 		,A1_COD_MUN "+CRLF
	_cQuery += " 		,A1_MUN "+CRLF    
	_cQuery += " 		,A1_EST "+CRLF    
	_cQuery += " 		,(CASE WHEN (SELECT MAX(CJ_TOTAL) FROM " + RetSqlName("SCJ") + " SCJ WHERE CJ_FILIAL = '" + xFilial("SCJ") + "' AND CJ_CLIENTE = A1_COD AND CJ_LOJA = A1_LOJA AND SCJ.D_E_L_E_T_ = ' ' ) > 50000 THEN 'O' ELSE 'C' END) AS FLAG "+CRLF
	_cQuery += " 		,(CASE WHEN (SELECT MAX(C5_EMISSAO) FROM " + RetSqlName("SC5") + " SC5 WHERE C5_FILIAL = '" + xFilial("SC5") + "' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SC5.D_E_L_E_T_ = ' ') > '" + _cDtCort + "' THEN 'O' ELSE 'I' END) AS ATIVC "+CRLF
	_cQuery += " 		,(CASE WHEN (SELECT MAX(CJ_EMISSAO) FROM " + RetSqlName("SCJ") + " SCJ WHERE CJ_FILIAL = '" + xFilial("SCJ") + "' AND CJ_CLIENTE = A1_COD AND CJ_LOJA = A1_LOJA AND SCJ.D_E_L_E_T_ = ' ') > '" + _cDtCort + "' THEN 'O' ELSE 'I' END) AS ATIVO "+CRLF
	_cQuery += " 		,SA1.R_E_C_N_O_ "+CRLF
	_cQuery += " 		FROM "+RetSqlName("SA1") +" SA1 "+CRLF
	_cQuery += " 		WHERE SA1.A1_FILIAL		= '"+xFilial("SA1") 	+"'"+CRLF
	_cQuery += " 		AND A1_MSBLQL <> '1' "
	_cQuery += " 		AND SA1.D_E_L_E_T_ 		=  '" + Space(1) + "' "
	TcQuery _cQuery New Alias (_cAliasQry)
	
	If (_cAliasQry)->(!EOF())
		While (_cAliasQry)->(!EOF())
			Do Case
				Case (_cAliasQry)->ATIVC=="I" .And. (_cAliasQry)->ATIVO=="I"
					Aadd(_aCliInt,{(_cAliasQry)->A1_COD+"/"+(_cAliasQry)->A1_LOJA,(_cAliasQry)->A1_NREDUZ,(_cAliasQry)->A1_EST,Posicione("SX5",1,xFilial("SX5")+ "T3" + (_cAliasQry)->A1_SATIV1,"X5DESCRI()")})
				Case (_cAliasQry)->ATIVO=="O"
					Aadd(_aCliOrc,{(_cAliasQry)->A1_COD+"/"+(_cAliasQry)->A1_LOJA,(_cAliasQry)->A1_NREDUZ,(_cAliasQry)->A1_EST,Posicione("SX5",1,xFilial("SX5")+ "T3" + (_cAliasQry)->A1_SATIV1,"X5DESCRI()")})
				OtherWise
					Aadd(_aCliAtv,{(_cAliasQry)->A1_COD+"/"+(_cAliasQry)->A1_LOJA,(_cAliasQry)->A1_NREDUZ,(_cAliasQry)->A1_EST,Posicione("SX5",1,xFilial("SX5")+ "T3" + (_cAliasQry)->A1_SATIV1,"X5DESCRI()")})
			End Case
			(_cAliasQry)->(dbSkip())
		EndDo
	
		Conout("HCIDM012 - Clientes Ativos:" + AllTrim(Str(Len(_aCliAtv))) )
		Conout("HCIDM012 - Clientes Orçamento:" + AllTrim(Str(Len(_aCliOrc))))
		Conout("HCIDM012 - Clientes Inativos:" + AllTrim(Str(Len(_aCliInt))))
		
		Begin Transaction
		
			_oProcess	:= TWFProcess():New("000001","Situacao clientes")
			_oProcess:NewTask( "000001", "\WORKFLOW\SitCliente.HTM" )
		
			_oProcess:cSubject	:= _cAssunto + " - " + ALLTRIM(SM0->M0_NOME) + " - "  + DtoC(Date())
			_oProcess:UserSiga	:= __cUserId
			_oProcess:NewVersion(.T.)
			_oHTML   			:= _oProcess:oHTML
			
			For _nI	:= 1 To Len(_aCliAtv)
				Aadd( (_oHTML:ValByName( "t1.1" )) 	,_aCliAtv[_nI,1] )
				Aadd( (_oHTML:ValByName( "t1.2" )) 	,_aCliAtv[_nI,2] )
				Aadd( (_oHTML:ValByName( "t1.3" )) 	,_aCliAtv[_nI,3] )
				Aadd( (_oHTML:ValByName( "t1.4" )) 	,_aCliAtv[_nI,4] )
				Aadd( (_oHTML:ValByName( "t1.5" ))	,""	)
				Aadd( (_oHTML:ValByName( "t1.6" ))	,"")
				
			Next _nI			

			For _nI	:= 1 To Len(_aCliOrc)
			
				Aadd( (_oHTML:ValByName( "t2.1" )) 	,_aCliOrc[_nI,1] )
				Aadd( (_oHTML:ValByName( "t2.2" )) 	,_aCliOrc[_nI,2] )
				Aadd( (_oHTML:ValByName( "t2.3" )) 	,_aCliOrc[_nI,3] )
				Aadd( (_oHTML:ValByName( "t2.4" )) 	,_aCliOrc[_nI,4] )
				Aadd( (_oHTML:ValByName( "t2.5" ))	,""	)
				Aadd( (_oHTML:ValByName( "t2.6" ))	,"")
				
			Next _nI
			
			For _nI	:= 1 To Len(_aCliInt)
			
				Aadd( (_oHTML:ValByName( "t3.1" )) 	,_aCliInt[_nI,1] )
				Aadd( (_oHTML:ValByName( "t3.2" ))  ,_aCliInt[_nI,2] )
				Aadd( (_oHTML:ValByName( "t3.3" ))  ,_aCliInt[_nI,3] )
				Aadd( (_oHTML:ValByName( "t3.4" ))  ,_aCliInt[_nI,4] )
				Aadd( (_oHTML:ValByName( "t3.5" ))	,""	)
				Aadd( (_oHTML:ValByName( "t3.6" ))	,"")
				
			Next _nI	        

			For _nI	:= 1 To Len(_aEmail)			
				_cPara	:= AllTrim(UsrRetMail(_aEmail[_nI]))
				_cPara	+= ";bzechetti@totalitsolutions.com.br"		
				Conout("HCIDM012 - Envio:" + AllTrim(_cPara))
				_oProcess:cTo := _cPara
				_oProcess:Start()
			Next _nI
			
		End Transaction
		
		(_cAliasQry)->(dbCloseArea())
	EndIf
	
Return()