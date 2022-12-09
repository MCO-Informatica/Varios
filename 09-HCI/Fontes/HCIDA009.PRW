#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"     
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"                                                               
#INCLUDE "Font.ch"
#INCLUDE "DBINFO.CH"
#INCLUDE "TBICONN.CH"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3

User Function HCIDA009()
	
	Local aTRB 			:= {}
	Local aHeadMBrow	:= {}
	
	Private cCadastro	:= "Cadastro de Clientes"
	Private _aCores		:= {}
	Private aRotina		:= {{"Visualizar"	,"u_fHCIDA09(2)" 	, 0 , 2},;  	// "Visualizar"
							{"Incluir"		,"u_fHCIDA09(3)"	, 0 , 3},;
							{"Legenda"		,"u_fHCIDA09(7)"	, 0 , 7},;
							{"Contatos"		,"u_fHCIDA09(8)"	, 0 , 8},;
							{"Conhecimento"	,"MsDocument"  		, 0	, 4}}  	// "Incluir"	
								
	Private cAliasTRB	:= GetNextAlias()
	
	Aadd(_aCores,{'CSTATUS = "I"','BR_VERMELHO'	})	// Cliente cadastrado.
	Aadd(_aCores,{'CSTATUS = "O"','BR_AMARELO'	})	// Em processo de aprovacao
	Aadd(_aCores,{'CSTATUS = "V"','BR_AZUL'		})	// Cancelado
	
	//aTRB[1] -> Nome físico do arquivo
	//aTRB[2] -> Nome do índice 1
	MsgRun("Criando estrutura e carregando dados no arquivo temporário...",,{|| aTRB := FileTRB() } )
	
	//aHeadMBrow[1] -> Título 
	//aHeadMBrow[2] -> Campo
	//aHeadMBRow[3] -> Tipo
	//aHeadMBrow[4] -> Tamanho
	//aHeadMBRow[5] -> Decimal
	//aHeadMBrow[6] -> Picture
	MsgRun("Criando coluna para MBrowse...",,{|| aHeadMBrow := HeadBrow() } )
	
	dbSelectArea((cAliasTRB))
	dbSetOrder(1)
	MBrowse(,,,,(cAliasTRB),aHeadMBrow,,,,,_aCores,"","") 
	//Fecha a área
	(cAliasTRB)->(dbCloseArea())
	//Apaga o arquivo fisicamente
	FErase( aTRB[ nTRB ] + GetDbExtension())
	//Apaga os arquivos de índices fisicamente
	FErase( aTRB[ nIND1 ] + OrdBagExt())

Return()

Static Function HeadBrow()

	Local aHead := {}
	
	//Campos que aparecerão na MBrowse, como não é baseado no SX3 deve ser criado.
	//Sequência do vetor: Título, Campo, Tipo, Tamanho, Decimal, Picture
	AAdd( aHead, { "Filial" 		, {|| (cAliasTRB)->A1_FILIAL	} ,"C", TAMSX3( SA1->A1_FILIAL 	)	, 0, "" } )
	AAdd( aHead, { "Codigo" 		, {|| (cAliasTRB)->A1_COD 		} ,"C", TAMSX3( SA1->A1_COD 	)	, 0, "" } )
	AAdd( aHead, { "Loja"   		, {|| (cAliasTRB)->A1_LOJA 		} ,"C", TAMSX3( SA1->A1_LOJA 	)	, 0, "" } )
	AAdd( aHead, { "Nome"			, {|| (cAliasTRB)->A1_NOME 		} ,"C", TAMSX3( SA1->A1_NOME 	)	, 0, "" } )
	AAdd( aHead, { "N.Fantasia"		, {|| (cAliasTRB)->A1_NREDUZ	} ,"C", TAMSX3( SA1->A1_NREDUZ 	)	, 0, "" } )
	AAdd( aHead, { "CPF/CNPJ"		, {|| (cAliasTRB)->A1_CGC 		} ,"C", TAMSX3( SA1->A1_CGC 	)	, 0, "" } )
	AAdd( aHead, { "Segmento"		, {|| (cAliasTRB)->A1_DSATIV1	} ,"C", 40							, 0, "" } )
	AAdd( aHead, { "CEP"			, {|| (cAliasTRB)->A1_CEP 		} ,"C", TAMSX3( SA1->A1_CEP 	)	, 0, "" } )
	AAdd( aHead, { "Endereço"		, {|| (cAliasTRB)->A1_END 		} ,"C", TAMSX3( SA1->A1_END 	)	, 0, "" } )
	AAdd( aHead, { "Bairro"			, {|| (cAliasTRB)->A1_BAIRRO 	} ,"C", TAMSX3( SA1->A1_BAIRRO 	)	, 0, "" } )
	AAdd( aHead, { "Estado"			, {|| (cAliasTRB)->A1_EST 		} ,"C", TAMSX3( SA1->A1_EST 	)	, 0, "" } )
	AAdd( aHead, { "Municipio"		, {|| (cAliasTRB)->A1_MUN 		} ,"C", TAMSX3( SA1->A1_MUN 	)	, 0, "" } )
	AAdd( aHead, { "Cd.Municipio"	, {|| (cAliasTRB)->A1_COD_MUN 	} ,"C", TAMSX3( SA1->A1_COD_MUN )	, 0, "" } )
	AAdd( aHead, { "DDD"			, {|| (cAliasTRB)->A1_DDD 		} ,"C", TAMSX3( SA1->A1_DDD 	)	, 0, "" } )
	AAdd( aHead, { "Telefone"		, {|| (cAliasTRB)->A1_TEL 		} ,"C", TAMSX3( SA1->A1_TEL 	)	, 0, "" } )
	AAdd( aHead, { "Status"			, {|| (cAliasTRB)->CSTATUS 		} ,"C", 1							, 0, "" } )

Return( aHead )

Static Function FileTRB()

	Local aStruct	:= {}
	
	Local cArqTRB		:= ""
	Local cInd1			:= ""
	Local cInd2			:= ""
	Local _cQuery		:= ""
	Local _cAliasQry	:= GetNextAlias()
	Local _cDtCort		:= DtoS(dDataBase - GetMv("ES_HCIDA09",,180))
	Local _cFiltroTop	:= U_HCIDM010("Cliente")	
	
	AAdd( aStruct, { "A1_FILIAL"	, "C", TAMSX3("A1_FILIAL")[1]	, 0 } )
	AAdd( aStruct, { "A1_COD"  		, "C", TAMSX3("A1_COD")[1]		, 0 } )
	AAdd( aStruct, { "A1_LOJA"		, "C", TAMSX3("A1_LOJA")[1]		, 0 } )
	AAdd( aStruct, { "A1_NOME"		, "C", TAMSX3("A1_NOME")[1]		, 0 } )
	AAdd( aStruct, { "A1_NREDUZ"	, "C", TAMSX3("A1_NREDUZ")[1]	, 0 } )
	AAdd( aStruct, { "A1_CGC"		, "C", TAMSX3("A1_CGC")[1]		, 0 } )
	AAdd( aStruct, { "A1_DSATIV1"	, "C", 40						, 0 } )
	AAdd( aStruct, { "A1_CEP"		, "C", TAMSX3("A1_CEP")[1]		, 0 } )
	AAdd( aStruct, { "A1_END"		, "C", TAMSX3("A1_END")[1]		, 0 } )
	AAdd( aStruct, { "A1_BAIRRO"	, "C", TAMSX3("A1_BAIRRO")[1]	, 0 } )
	AAdd( aStruct, { "A1_EST"		, "C", TAMSX3("A1_EST")[1]		, 0 } )
	AAdd( aStruct, { "A1_MUN"		, "C", TAMSX3("A1_MUN")[1]		, 0 } )
	AAdd( aStruct, { "A1_COD_MUN"	, "C", TAMSX3("A1_COD_MUN")[1]	, 0 } )
	AAdd( aStruct, { "A1_DDD"		, "C", TAMSX3("A1_DDD")[1]		, 0 } )
	AAdd( aStruct, { "A1_TEL"		, "C", TAMSX3("A1_TEL")[1]		, 0 } )
	AAdd( aStruct, { "CSTATUS"		, "C", 1						, 0 } )
	
	// Ambas as maneiras devem proceder estes comandos abaixo:
	// Criar fisicamente o arquivo.
	cArqTRB := CriaTrab( aStruct, .T. )
	cInd1 := Left( cArqTRB, 7 ) + "1"

	// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
	dbUseArea( .T., __LocalDriver, cArqTRB, (cAliasTRB), .F., .F. )
	// Criar os índices.
	IndRegua( (cAliasTRB), cInd1, "A1_FILIAL+A1_COD+A1_LOJA", , , "Criando índices ...")
	
	// Libera os índices.
	dbClearIndex()
	// Agrega a lista dos índices da tabela (arquivo).
	dbSetIndex( cInd1 + OrdBagExt() )

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
	If !Empty(_cFiltroTop)
		_cQuery += " 	AND SA1.A1_COD||SA1.A1_LOJA IN (" + _cFiltroTop + ") "
	EndIf
	_cQuery += " 		AND A1_MSBLQL <> '1' "
	_cQuery += " 		AND SA1.D_E_L_E_T_ 		=  '" + Space(1) + "' "
	TcQuery _cQuery New Alias (_cAliasQry)
	
	If (_cAliasQry)->(!EOF())
		While (_cAliasQry)->(!EOF())
			If RecLock((cAliasTRB),.T.)
				(cAliasTRB)->A1_FILIAL	:= (_cAliasQry)->A1_FILIAL
				(cAliasTRB)->A1_COD		:= (_cAliasQry)->A1_COD
				(cAliasTRB)->A1_LOJA	:= (_cAliasQry)->A1_LOJA
				(cAliasTRB)->A1_NOME	:= (_cAliasQry)->A1_NOME
				(cAliasTRB)->A1_NREDUZ	:= (_cAliasQry)->A1_NREDUZ
				(cAliasTRB)->A1_CGC		:= (_cAliasQry)->A1_CGC
				(cAliasTRB)->A1_DSATIV1	:= Posicione("SX5",1,xFilial("SX5")+ "T3" + (_cAliasQry)->A1_SATIV1,"X5DESCRI()")
				(cAliasTRB)->A1_CEP		:= (_cAliasQry)->A1_CEP
				(cAliasTRB)->A1_END		:= (_cAliasQry)->A1_END
				(cAliasTRB)->A1_BAIRRO	:= (_cAliasQry)->A1_BAIRRO
				(cAliasTRB)->A1_EST		:= (_cAliasQry)->A1_EST
				(cAliasTRB)->A1_MUN		:= (_cAliasQry)->A1_MUN
				(cAliasTRB)->A1_COD_MUN	:= (_cAliasQry)->A1_COD_MUN
				(cAliasTRB)->A1_DDD		:= (_cAliasQry)->A1_DDD
				(cAliasTRB)->A1_TEL		:= (_cAliasQry)->A1_TEL
				(cAliasTRB)->CSTATUS	:= Iif((_cAliasQry)->ATIVC=="I" .And. (_cAliasQry)->ATIVO=="I","I",Iif((_cAliasQry)->ATIVO=="O","O","V"))
				(cAliasTRB)->(MsUnLock())
			EndIf
			(_cAliasQry)->(dbSkip())
		EndDo
	EndIf
	
	(_cAliasQry)->(dbCloseArea())

Return({cArqTRB,cInd1})

User Function fHCIDA09(_nOpc)

	Local _aArea	:= GetArea()

	Do Case
		Case _nOpc == 2 //Visual
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1") + (cAliasTRB)->A1_COD + (cAliasTRB)->A1_LOJA))
				AxVisual( 'SA1', SA1->( Recno() ), 2 )
			EndIf
			
		Case _nOpc == 3 //Incluir
			u_fHCIDA03(3)
			
		Case _nOpc == 7 //Legenda
		
			BrwLegenda(cCadastro,"Legenda",{{"BR_AZUL"  		, "Cliente Ativo (Comprando)."		},;
											{"BR_AMARELO"		, "Cliente Orçamento (Orçando)."		},; 
											{"BR_VERMELHO"		, "Cliente Inativo."		}}) 
									
		Case _nOpc == 8 //Contatos
			U__fContato()
			
	End Case
	
	RestArea(_aArea)

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fSU5XB
Rotina para criação da consulta padrão de Contatos.

@author 	Bruna Zechetti de Oliveira
@since 		30/09/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function _fContato()

	Local alEstrut		:= {}
	Local alCampos		:= {}
	Local olChkB		:= Nil
	Local olBtn1		:= Nil
	Local olBtn2		:= Nil
	Local olBtn3		:= Nil
	Local clNomTmp		:= ""
	Local clMarca		:= "X"
	Local llChkB		:= .T.
	Local _nOpc			:= 0
	Local _cBusca		:= Space(TamSX3("U5_CODCONT")[1])
	Local _nIndice		:= 1
	Local _oIndice		:= Nil
	Local _aBusca		:= {"Codigo","Nome"}
	Private olMark		:= Nil
	Private _cAliasSU5	:= GetNextAlias()
	
	aAdd(alCampos,{"COD"	,,"Codigo"			,"@!"})
	aAdd(alCampos,{"NOME"	,,"Nome"			,"@!"})	
	aAdd(alCampos,{"EMAIL"	,,"E-mail"			,"@!"})	
	aAdd(alCampos,{"DDD"	,,"DDD"				,"@!"})	
	aAdd(alCampos,{"TEL"	,,"Telefone"		,"@!"})	

	aAdd(alEstrut,{"COD"	,"C",TamSX3("U5_CODCONT")[1]	,TamSX3("U5_CODCONT")[2]})
	aAdd(alEstrut,{"NOME"	,"C",TamSX3("U5_CONTAT")[1]		,TamSX3("U5_CONTAT")[2]})	
	aAdd(alEstrut,{"EMAIL"	,"C",TamSX3("U5_EMAIL")[1]		,TamSX3("U5_EMAIL")[2]})	
	aAdd(alEstrut,{"DDD"	,"C",TamSX3("U5_DDD")[1]		,TamSX3("U5_DDD")[2]})	
	aAdd(alEstrut,{"TEL"	,"C",TamSX3("U5_FONE")[1]		,TamSX3("U5_FONE")[2]})	

	clNomTmp	:= CriaTrab(alEstrut,.T.)
	If Select((_cAliasSU5)) > 0
		(_cAliasSU5)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,,clNomTmp,_cAliasSU5,.F.)
	
	INDEX ON COD 	TAG IND1 TO &clNomTmp
	INDEX ON NOME 	TAG IND2 TO &clNomTmp

	FGrvTMP2(1)

	(_cAliasSU5)->(dbSetOrder(1))
	(_cAliasSU5)->(dbGoTop())
	
	@000,000 To 440,705 DIALOG olDlgTip TITLE "Contatos x Cliente"
	
		olMark	:= MsSelect():New((_cAliasSU5),"",,alCampos,,@clMarca,{35,04,200,352})
		_oIndice := TComboBox():New(005,004,{|u|if(PCount()>0,_nIndice:=u,_nIndice)},_aBusca,100,20,olDlgTip,,{||FGrvTMP2(_nIndice),(_cAliasSU5)->(dbGoTop()),olMark:oBrowse:Refresh(),;
																												_cBusca	:= Iif(ValType(_nIndice)=="C",Iif(SubStr(_nIndice,1,1)=="C",Space(TAMSX3("U5_CODCONT")[1]),Space(TAMSX3("U5_CONTAT")[1])),Space(100)),olDlgTip:Refresh()},,,,.T.,,,,,,,,,'_nIncide')
		
		@ 018,004 MSGET _cBusca    							SIZE 150 ,9 OF olDlgTip PIXEL
		@ 004,310 BUTTON olBtn3		PROMPT "Pesquisar" 		SIZE 40,12 ACTION (_fPesqCON(_nIndice,_cBusca)) 	PIXEL OF olDlgTip
		@ 019,310 BUTTON olBtn3		PROMPT "Limpar Pesq." 	SIZE 40,12 ACTION (FGrvTMP2(_nIndice), _cBusca	:= Iif(ValType(_nIndice)=="C",if(SubStr(_nIndice,1,1)=="C",Space(TAMSX3("U5_CODCONT")[1]),Space(TAMSX3("U5_CONTAT")[1])),Space(100)),olDlgTip:Refresh())				PIXEL OF olDlgTip
		@ 205,310 BUTTON olBtn2		PROMPT "Fechar"  		SIZE 40,12 ACTION olDlgTip:End() PIXEL OF olDlgTip

	ACTIVATE DIALOG olDlgTip CENTERED
		
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fPesqCON
Função para filtro/pesquisa das despesas.

@author 	Bruna Zechetti de Oliveira
@since 		15/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function _fPesqCON(_nOpc,_cBusca)

	If ValType(_nOpc) == "C"
		_nOpc	:= Iif(SubStr(_nOpc,1,2)=="C",1,2)
	EndIf

    (_cAliasSU5)->(dbSetOrder(_nOpc))
    (_cAliasSU5)->(dbSeek(AllTrim(_cBusca)))
    
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} FGrvTMP2
Função para gravação dos dados da consulta padrão de Contatos.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function FGrvTMP2(_nOpc)

	Local _cQuery	:= ""
	Local _cCodCon	:= U_HCIDM010("PRECLI")
	Local _cAlias02	:= GetNextAlias()
	Local _cFunNome	:= FunName()
	Local _cCliente	:= ""
	Local _nI		:= 0
	
	Do Case
		Case ALLTRIM(UPPER(_cFunNome)) ==	"HCIDA011"
			_cCliente	:= M->US_COD+M->US_LOJA
		Case ALLTRIM(UPPER(_cFunNome)) ==	"HCIDA018"
			_cCliente	:= M->Z02_CLIENT+M->Z02_LOJAC
		Case ALLTRIM(UPPER(_cFunNome)) ==	"HCIDA009"
			_cCliente	:= (cAliasTRB)->A1_COD+(cAliasTRB)->A1_LOJA
	End Case

	If Select((_cAliasSU5)) > 0
		(_cAliasSU5)->(dbGoTop())
		If (_cAliasSU5)->(!Eof())
			While (_cAliasSU5)->(!Eof())
				If RecLock((_cAliasSU5), .F., .T.)
					(_cAliasSU5)->( dbDelete() )
					(_cAliasSU5)->( MsUnLock() )
				EndIf
				(_cAliasSU5)->( dbSkip() )				
			EndDo
		EndIf
	EndIf

	_cQuery	:= "SELECT	U5_CODCONT, U5_CONTAT, U5_EMAIL, U5_DDD, U5_FONE  "
	_cQuery	+= " FROM " + RetSqlName("SU5") + " SU5 "
	
	If !Empty(_cCliente)
		_cQuery	+= " INNER JOIN " + RetSqlName("AC8") + " AC8 "
		_cQuery	+= " ON AC8_FILIAL = '" + xFilial("AC8") + "' "
		_cQuery	+= " AND AC8_ENTIDA = 'SA1' "
		_cQuery	+= " AND AC8_CODENT = '" + _cCliente + "' "
		_cQuery	+= " AND AC8_CODCON = U5_CODCONT " 
		_cQuery	+= " AND AC8.D_E_L_E_T_ = ' ' "
	EndIf
	
	_cQuery	+= " WHERE U5_FILIAL = '" + xFilial("SU5") + "' "
	If !Empty(_cCodCon)
		_cQuery	+= " AND U5_CODCONT IN (" + _cCodCon + ") "
	EndIf
	_cQuery	+= " AND SU5.D_E_L_E_T_ = ' '"
    _cQuery	+= " ORDER BY U5_CODCONT, U5_CONTAT "
	TcQuery _cQuery New Alias &(_cAlias02)	
	
	If (_cAlias02)->(!EOF())
		While (_cAlias02)->(!EOF())
			If RecLock((_cAliasSU5),.T.)
				(_cAliasSU5)->COD	:= (_cAlias02)->U5_CODCONT
				(_cAliasSU5)->NOME	:= (_cAlias02)->U5_CONTAT
				(_cAliasSU5)->EMAIL	:= (_cAlias02)->U5_EMAIL
				(_cAliasSU5)->DDD	:= (_cAlias02)->U5_DDD
				(_cAliasSU5)->TEL	:= (_cAlias02)->U5_FONE
				MsUnLock()
			EndIf		
			(_cAlias02)->(dbSkip())
		EndDO
	EndIf
	(_cAlias02)->(dbCloseArea())
	
    (_cAliasSU5)->(dbSetOrder(1))

Return(Nil)