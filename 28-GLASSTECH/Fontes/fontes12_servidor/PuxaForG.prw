Static cBDGSTQ	:= ""
Static cBDPROT	:= ""
Static cBVGstq	:= ""

/*/{Protheus.doc} PuxaCliG
//TODO Busca um cliente determinado no Gestoq e grava no Protheus caso não exista.
@author Pirolo
@since 26/12/2019
@return return, return_description
/*/
User Function PuxaForG()
Local aPergs   	:= {}
Local aPergs2   	:= {}
Local cRecDest 	:= space(06)
Local aRet	   	:= {}
Local cNaturez	:= Space(10) 

//RPCSETTYPE(3)
//RPCSETENV("01", "0101")

aAdd( aPergs ,{1, "Cód Fornec Gestoq", cRecDest,"@!",'!Empty(mv_par01)',,'.T.',40,.T.})

If !ParamBox(aPergs ,"Integrar Fornec Gestoq",aRet)
    Return
EndIf

cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
cBDPROT	:= GetMv("MV_TWINENV")
cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

_cQry := "SELECT ID_CLIENTE, NOME, ENDERECO, BAIRRO, REPLACE(REPLACE(REPLACE( CEP, '-', '' ), ' ', ''),'.','') CEP, REPLACE(REPLACE(REPLACE( CPFCGC, '-',''),'/',''),'.','') CPFCGC , RGINSC, CONTATO, CONVERT( CHAR(8), CADASTRO, 112) CADASTRO, ISNULL( OP.NATUREZA, '99999') NATUREZA, CID.DESCRICAO, CID.UF, CID.MUNICIPIO, "
_cQry += "NUMERO, TELEFONE FROM "+cBDGSTQ+".[dbo].[CLIENTE] "
_cQry += "LEFT OUTER JOIN "+cBDGSTQ+".[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL "
_cQry += "LEFT OUTER JOIN "+cBDGSTQ+".[dbo].[CIDADE] CID ON CID.ID_CIDADE = CLIENTE.ID_CIDADE "
_cQry += "WHERE ID_CLIENTE = " + aRet[1]

Iif(Select("TMP")>0, TMP->(DbCloseArea()) , Nil ) 

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), 'TMP' )

If TMP->(!Eof())
	_cCodFor := StrZero( TMP->ID_CLIENTE, 6 )
	_xNOME   := AllTrim(TMP->NOME)                 
	_IE      := AllTrim(TMP->RGINSC)
	_CEP     := AllTrim(TMP->CEP)
	_CMUN    := RIGHT(AllTrim(TMP->MUNICIPIO), 5)
	_CPAIS   := '1058'
	_FONE    := AllTrim(TMP->TELEFONE)
	_NRO     := AllTrim(TMP->NUMERO)
	_UF      := TMP->UF
	_XBAIRRO := AllTrim(TMP->BAIRRO)
	_XLGR    := AllTrim(TMP->ENDERECO)
	_XMUN    := AllTrim(TMP->DESCRICAO)
	cCgc     := Alltrim(TMP->CPFCGC)

	aRet	:= {}
	MV_PAR01 := ""
	
	aAdd(aPergs2, {1, "Natureza",  Space(10), ""  , "ExistChav('SED',   MV_PAR01, 1 )"   , "SED", ""   , 0 , .T.}) // Tipo caractere

	DbSelectArea("SED")
	SED->(DbSetOrder(1))

	If ! ( SA2->( dbSeek( xFilial("SA2") + _cCodFor +'01', .F. ) ) )

		If ParamBox(aPergs2 ,"Informe a Natureza do Fornecedor",aRet)
			If SED->(!DbSeek(xFilial("SED")+aRet[1]))
				MsgAlert("Natureza inválida, o fornecedor não será importado.", "Natureza")
				Return
			EndIf

			RecLock( 'SA2', .T. )
				SA2->A2_LOJA    := '01'
				SA2->A2_COD     := _cCodFor
				SA2->A2_NOME    := _xNOME
				SA2->A2_NREDUZ  := Substr( _xNome, 1, at( ' ', _xNome) )
				SA2->A2_INSCR   := _IE
				SA2->A2_CGC     := cCGC
				SA2->A2_CEP     := _CEP
				SA2->A2_MUN     := _XMUN
				SA2->A2_COD_MUN := _CMUN
				SA2->A2_PAIS    := SUBSTR( _CPAIS,1,3 )
				SA2->A2_CODPAIS := '0' + _CPAIS
				SA2->A2_TELRE   := _FONE
				SA2->A2_END     := _XLGR
				SA2->A2_MSBLQL  := '2'
				SA2->A2_NATUREZ	:= aRet[1]
			
				If at( ',', _XLGR ) = 0
						SA2->A2_END := rTrim( SA2->A2_END ) + ', ' + Alltrim( Str( Val( _NRO ), 5, 0) )
				End
			
				SA2->A2_EST    := _UF
				SA2->A2_BAIRRO := _XBAIRRO
				SA2->A2_TIPO := if( Len(cCGC) <> 14, 'F', 'J' )
			SA2->( dbUnLock() )
			
			MsgInfo("Fornecedor importado com sucesso.")
		EndIf
	Else
		
		If ParamBox(aPergs2 ,"Informe a Natureza do Fornecedor",aRet)
			If SED->(!DbSeek(xFilial("SED")+aRet[1]))
				MsgAlert("Natureza inválida, o fornecedor não será importado.", "Natureza")
				Return
			EndIf

			RecLock( 'SA2', .F. )
				SA2->A2_NOME    := _xNOME
				SA2->A2_NREDUZ  := Substr( _xNome, 1, at( ' ', _xNome) )
				SA2->A2_INSCR   := _IE
				SA2->A2_CEP     := _CEP
				SA2->A2_MUN     := _XMUN
				SA2->A2_COD_MUN := _CMUN
				SA2->A2_PAIS    := SUBSTR( _CPAIS,1,3 )
				SA2->A2_CODPAIS := '0' + _CPAIS
				SA2->A2_TELRE   := _FONE
				SA2->A2_END     := _XLGR
				SA2->A2_NATUREZ	:= aRet[1]
			
			If at( ',', _XLGR ) = 0
					SA2->A2_END := rTrim( SA2->A2_END ) + ', ' + Alltrim( Str( Val( _NRO ), 5, 0) )
			End
			
			SA2->A2_EST    := _UF
			SA2->A2_BAIRRO := _XBAIRRO
			SA2->( dbUnLock() )

			MsgInfo("Fornecedor atualizado com a base Gestoq.")
		EndIf
	EndIf
EndIf
TMP->( dbCloseArea() )

