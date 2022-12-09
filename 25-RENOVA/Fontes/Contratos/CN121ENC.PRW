#INCLUDE "Protheus.ch"
 
/* 
  CN121ENC() - Luiz M. Suguiura - UPDuo (28/07/2022)
    Possibilita ao desenvolvedor realizar operações após o encerramento da medição.
    Substitui:
    CN120ENCMD = Após encerramento da Medição dentro da transação (Esse é o que será substituido)
    CN120ENMED = Após encerramento da Medição fora da transação (Não usa na Renova)
*/
// O NÚMERO DA PLANILHA NÃO É MAIS GRAVADO NO CND - ANDRÉ IRÁ PASSAR QUAL É A TABELA
User Function CN121ENC()    //==> ALTERADO POR JP EM FEVEREIRO - VERIFICAR ESSAS ALTERAÇÕES

Local lInTrans:= PARAMIXB[1]    // .T. = Dentro da transação ou .F. = Fora da transação
Local lResult := PARAMIXB[2]    // .T. = Encerramento finalizado com sucesso ou .F. = Ocorreu alguma falha
 
If !lInTrans
    Return()
EndIf
     
If !lResult
    MsgAlert("Ocorreu alguma falha na medição!", "Notificação de Falha")
EndIf

// CN1->CN1_ESPCTR == '1'	// Compras
// CN1->CN1_ESPCTR == '2'	// Vendas

U_ContCV(CN1->CN1_ESPCTR)

Return()

// Fabio Jadao Caires
// Data: 27/11/2017
// U_ContCV() = Tratamento de Contrato de Compras ( CN1->CN1_ESPCTR == '1' ) e Vendas ( CN1->CN1_ESPCTR == '2' )

User Function ContCV(cModo)

// Salva o ambiente atual
Local _aAmbiente := {}
Local _lpedtit := .F. //variavel logica que indica se há item na medicao que gera titulo (João - 15/02/22)

If	cModo == "1"	// Compras
	_aAmbiente := { {Alias()} , {"CN1"}, {"CN9"}, {"CND"}, {"CNE"}, {"CNA"}, {"CNF"}, {"SE2"} }
ElseIf cModo == "2"	// Vendas
	_aAmbiente := { {Alias()} , {"CN1"}, {"CN9"}, {"CND"}, {"CNE"}, {"CNA"}, {"CNF"}, {"SE1"} }
EndIF

//João Pedro - 15/02/22
//Aponta para o registro correto da CNE
DbSelectArea("CNE")
CNE->( DbSetOrder(1) ) 
CNE->( DbGoTop() )
If CNE->(MsSeek(CND->(CND_FILIAL+CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED)))    
	while !CNE->(EOF()) .AND. CND->CND_NUMMED == CNE->CNE_NUMMED
		if CNE->CNE_PEDTIT == "2" //Se a medicao gera titulo, fica posicionado no registro e sai do loop
			_lpedtit := .T. //Tem item na medicao que gera titulo
			EXIT
		endif
		CNE->(DBSKIP())
	enddo
EndIf

// Uma vez gerado o título a pagar, atualizar as informacoes complementares do titulo

//If	CN1->CN1_ESPCTR == '1' .AND. CN1->CN1_CTRMED == "2"	// CONTRATO DE COMPRA QUE GERA TITULO
If	CN1->CN1_ESPCTR == '1' .AND. _lpedtit == .T.	// Alterado para pegar as informações contábeis do item da CNE (João - 15/02/2022)
	xGravSE2()
EndIf

//If	CN1->CN1_ESPCTR == '2' .AND. CN1->CN1_CTRMED == "2"	// CONTRATO DE VENDA QUE GERA TITULO
If	CN1->CN1_ESPCTR == '2' .AND. _lpedtit == .T.	// Alterado para pegar as informações contábeis do item da CNE (João - 15/02/2022)
	xGravSE1()
EndIf

// Esse trecho trata apenas os títulos provisórios se existirem 
If	cModo == "1"	// Compras
	
	SalvaAmbiente(_aAmbiente)
	
	_cChVctr := CN9->CN9_XFTITI+CN9->CN9_NUMERO+CNA->CNA_NUMERO+CNF->CNF_NUMERO +CNF->CNF_PARCEL
	
	SE2->( DbSetOrder(18))	// E2_FILORIG+E2_MDCONTR+E2_MDPLANI+E2_MDCRON+E2_MDPARCE 
	IF SE2->E2_TIPO = "PR"
		If 	SE2->(DbSeek(_cChVctr))
			IF ! Deleted()
				Reclock("SE2",.F.)
				SE2->(DbDelete())
				Msunlock()
			Endif
		Endif
	Endif
	RestAmbiente(_aAmbiente)
	
ElseIf	cModo == "2"	// Vendas
	
	SalvaAmbiente(_aAmbiente)
	
	_cChVctr := CN9->CN9_XFTITI+CN9->CN9_NUMERO+CNA->CNA_NUMERO+CNF->CNF_NUMERO +CNF->CNF_PARCEL
	
	SE1->( DbOrderNickName("SE1GCT") )	// E1_FILORIG+E1_MDCONTR+E1_MDPLANI+E1_MDCRON+E1_MDPARCE
	If 	SE1->(DbSeek(_cChVctr))
		IF ! Deleted()
			Reclock("SE1",.F.)
			SE1->(DbDelete())
			Msunlock()
		Endif
	Endif
	
	RestAmbiente(_aAmbiente)
	
EndIf

// Incluido atualização do campo CND->CND_PEDIDO para manter compatibilização com gravações efetuadas pelo CNTA120
// Tanto para Compras quanto para Vendas a tabela CXJ é gerada, portanto é possível utilizar essa informação
if Empty(AllTrim(CND->CND_PEDIDO)) .and. CND->CND_CONTRA = CXJ->CXJ_CONTRA
	SalvaAmbiente(_aAmbiente)
	RecLock("CND", .F.)
	CND->CND_PEDIDO := CXJ->CXJ_NUMPED
	MSUnlock()
	RestAmbiente(_aAmbiente)		
endif

Return 

*****************************
// Funcao para salvar o ambiente
*****************************
Static function SalvaAmbiente(_aAmbiente)

Local _ni

For _ni := 1 to len(_aAmbiente)
	dbselectarea(_aAmbiente[_ni,1])
	AADD(_aAmbiente[_ni],indexord())
	AADD(_aAmbiente[_ni],recno())
Next

Return

// Funcao para restaurar o ambiente
Static function RestAmbiente(_aAmbiente)

Local _ni

For _ni := len(_aAmbiente) to 1 step -1
	dbselectarea(_aAmbiente[_ni,1])
	dbsetorder(_aAmbiente[_ni,2])
	dbgoto(_aAmbiente[_ni,3])
Next

Return()

// Fabio Jadao Caires
// Data: 08/11/2017
// Se a medicao gera titulo a pagar, conforme o tipo do contrato, grava informacoes adicionais no título (SE2) gerado

Static Function xGravSE2()

Local _aArea    := GetArea()
Local _lRet     := .T.
Local aRotAuto  := {}
Local cQuery    := ''
//Criado por Ronaldo Bicudo - Totvs / 28/07/2016
Local _cQuery   := ''
Local _cAliasM  := GetNextAlias()
Local _nValorM := 0
Local _nValorV := 0
//Fim da Inclusão
Local _cTipo    := PadR(GetMv("MV_XRETIPO"),Len(SE2->E2_TIPO))
Local _cNat     := ""
Local _aPref    := StrToArray(GetMv("MV_XRENPRF"),";")//ALTERA A VARIAVEL LOCAL  cRetPrf DA FUNÇÃO PADRÃO CN120MedEst
Local _aPref2   := StrToArray(GetMv("MV_XRENPR2"),";")  //Criado porque no parametro MV_XRENPRF não cabe mais.
Local _aDirf    := StrToArray(GetMv("MV_XREDIRF"),";")
Local _aDirf2   := StrToArray(GetMv("MV_XREDIR2"),";") //Criado porque no parametro MV_XREDIR2 não cabe mais.
Local _cDirf    := ""
Local _aCond    := {}
//Local _cNumTit  := PadR(StrZero(Year(dDataBase),4), Len(SE2->E2_NUM))
Local  _cDoc    := Soma1(GetMv("MV_XNUMTIT"),9) // número sequencial do título de Arrendamento/Aluguel - Gileno
Local _cNumTit  := _cDoc
Local _lFisica  := Posicione("SA2",1,xFilial("SA2")+CND->CND_FORNEC+CND->CND_LJFORN,"A2_TIPO") == "F"
//Local _cCC      := ""
//Local _cConta   := ""
//Local _cItem    := ""
//Local _cClass   := ""
//Local _Cv005    := "" // Classe orcamentaria.
Local _cConta := CNE->CNE_CONTA //Como a CNE está apontada no item correto, faço a atribuição das variáveis diretamente (João - 15/02/22)
Local _cCC    := CNE->CNE_CC
Local _cItem  := CNE->CNE_ITEMCT
Local _cClass := CNE->CNE_CLVL
Local _Cv005  := CNE->CNE_EC05DB

Local _cContra  := CND->CND_CONTRA
Local _cRevisa  := CND->CND_REVISA
Local _cNumplan := CND->CND_NUMERO
Local _cNumMed  := CND->CND_NUMMED
Local _cCodTran := CND->CND_XCTRAN
Local _cDescTra := CND->CND_XDTRAN
Local _aAreaCNE := CNE->(GetArea())   //Incluido Ronaldo Bicudo - Totvs / 20/06/2018

//campos novos para preechimento no título
Local _dPerApu := CNF->CNF_DTVENC //periodo de aputração
Local _dApurac := CNF->CNF_DTVENC //apuração
Local _cCodRec := CN9->CN9_XCODRE //codigo de receita
Local _cCNPJ   := SM0->M0_CGC //CNPJ conforme sigamat
Local _cNome   := SM0->M0_FILIAL //Nome da empresa
Local _cObs	   := SubStr(CND->CND_OBS,1,250) // Observação Romay 10-07-15

Local bPMSDlgFI	:= {||PmsDlgFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)}
Local cPicture  := X3Picture("E2_VALOR")
Local cBco      := Space(TamSX3("A6_COD")[1])
Local cAgc      := Space(TamSX3("A6_AGENCIA")[1])
Local cCta      := Space(TamSX3("A6_CONTA")[1])
Local _dDtVenc  := Ctod("") // Seleção da data de vencimento/pagamento do PA gerado pela medição - PRO FORMAS.
Local nValPA    := 0
Local lExcPms   := IntePMS()

Local _cParcela := " " // Não gravo número de parcela porque  o número do título será único. - Gileno
Local cTpContr  := Alltrim(GetMV("MV_XTCONTR", .F., ""))  // Tipo de contrato onde o vencimento sera informado na medição(030/056/057)
Local nX
Local nX2
Local nX3
Local _cPref 
Local aVencto  // retorno da função com a data de vencimento recalculada pelo padrão - Gileno
Local nValTi := 0.01  // Valor do título, a função exige esse parâmetro, podemos passar qualquer valor   
Local nValIp := 0.01   // Valor Ipi, a função exige esse parâmetro, podemos passar qualquer valor   
Local dDataRe  // Data Referencia, pegar data de EMISSÃO do título   
Local nValSo := 0.01  // Valor do título, a função exige esse parâmetro, podemos passar qualquer valor       
Local dVencimento //Data de vencimento retornada pela função de simulação - Gileno
      
// Luiz M Suguiura (24/10/2019) - Parâmetro para indicar o Gestor para liberação do título
Local cLiber := GetNewPar( "MV_FINALAP", "000001")       
       
//Incluido DbSelectArea para pocicionar no registro correto da tabela CNE
//Ronaldo Bicudo - Totvs - 20/06/2018                
//DbSelectArea("CNE")
//CNE->( DbSetOrder(1) ) 
//CNE->( DbGoTop() )
//If CNE->(MsSeek(CND->(CND_FILIAL+CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED)))    
//	_cConta := CNE->CNE_CONTA
//	_cCC    := CNE->CNE_CC
//	_cItem  := CNE->CNE_ITEMCT
//	_cClass := CNE->CNE_CLVL
//	_Cv005 	:= CNE->CNE_EC05DB
//EndIf

//Fim da Inclusão	
IF 	CN1->CN1_XAFAC == '1'
	_cTipo	:= "FAC"
	_cPref	:= "FAC"
Endif

For nX := 1 to Len(_aPref)
	If Left(_aPref[nX], 3) == CN9->CN9_TPCTO
		_cPref := PadR( SubStr(_aPref[nX], 5, Len(_aPref[nX])), Len( SE2->E2_PREFIXO ) )
	EndIf
Next nX


For nX2 := 1 to Len(_aPref2)  // continuacao de _aPref
	If Left(_aPref2[nX2], 3) == CN9->CN9_TPCTO
		_cPref := PadR( SubStr(_aPref2[nX2], 5, Len(_aPref2[nX2])), Len( SE2->E2_PREFIXO ) )
	Endif
Next nX2

If Empty(_cPref)
	_cPref := "MED"
EndIf
    
//If CN9->CN9_TPCTO $ cTpContr
//	_aCond := {{If(Empty(CND->CND_XDTVEN), dDataBase, CND->CND_XDTVEN), CND->CND_VLTOT}}
//Else
    //Chamo a rotina de 'simulação' de vencimento para recalcular a data de vencimento conforme condição - Gileno 06/09/2018
//	aVencto := Condicao(nValTi,SE4->E4_CODIGO,nValIp,dDataBase,nValSo,,,,,)
//	dVencimento:= aVencto[1][1]
//Endif

//BUSCAPREFIXO
// Posiciona no título a pagar - SE2 -- Usar CND_NUMMED pois nr do título é o nr da medição (Luiz) 
//SE2->( DbSeek( CND->CND_FILIAL + _cPref + CND->CND_NUMTIT ) )
DbSelectArea("SE2")
DbSetOrder(1)
//SE2->( MsSeek( CND->CND_FILIAL + _cPref + CND->CND_NUMTIT ) )
SE2->( MsSeek( CND->CND_FILIAL + _cPref + CND->CND_NUMMED ) )
//If	!SE2->(EOF()) .AND. SE2->E2_FILIAL == CND->CND_FILIAL .AND. Alltrim(SE2->E2_NUM) == Alltrim(CND->CND_NUMTIT) .AND. Alltrim(SE2->E2_MDCONTR) == Alltrim(CND->CND_CONTRA) .AND. Alltrim(SE2->E2_MDREVIS) == Alltrim(CND->CND_REVISA)
If	!SE2->(EOF()) .AND. SE2->E2_FILIAL == CND->CND_FILIAL .AND. Alltrim(SE2->E2_NUM) == Alltrim(CND->CND_NUMMED) .AND. Alltrim(SE2->E2_MDCONTR) == Alltrim(CND->CND_CONTRA) .AND. Alltrim(SE2->E2_MDREVIS) == Alltrim(CND->CND_REVISA)	
	RecLock("SE2",.F.)

	SE2->E2_CCD     := _cCC
	SE2->E2_CONTAD  := _cConta
	SE2->E2_ITEMD   := _cItem
	SE2->E2_CLVLDB  := _cClass
	SE2->E2_EC05DB  := _Cv005
	SE2->E2_XCTRAN  := _cCodTran
	SE2->E2_XDTRAN  := _cDescTra
	SE2->E2_XPERAP  := _dPerApu
	SE2->E2_E_APUR  := _dApurac
	SE2->E2_CODREC  := _cCodRec
	SE2->E2_XCNPJC  := _cCNPJ
	SE2->E2_XCONTR 	:= _cNome
	SE2->E2_XUSER   := cUserName
	SE2->E2_XOBSCT  := _cObs
	
	//If CN9->CN9_TPCTO $ cTpContr //TUST
		//Correção para o sistema salvar a data de vencimento corretamente no SE2 - Gileno 22/08/2018
		//SE2->E2_VENCTO  := _aCond[1][1]                 // Array com apenas 2 registros, por isso chumbei a posição nas 3 linhas
		//SE2->E2_VENCREA := DataValida(_aCond[1][1] )
		//SE2->E2_VENCORI := _aCond[1][1]
	//Else //Contratos não TUST- Gileno
	//	SE2->E2_VENCTO  := dVencimento                // Vencimento recalculando através da função padrão.
	//	SE2->E2_VENCREA := DataValida(dVencimento )
	//	SE2->E2_VENCORI := DataValida(dVencimento ) 				
    //Endif

    // Luiz M. Suguiura - 24/10/2019
    // Atualização dos campos referentes a Recuperação Judicial
    // Se posterior a RJ (16/10/2019) grava o título Liberado
    if SE2->E2_EMISSAO > CtoD("15/10/2019")
    	SE2->E2_APROVA  := ""
    	SE2->E2_DATALIB := dDataBase
    	SE2->E2_STATLIB := "03"
    	SE2->E2_USUALIB := "INC POSTERIOR REC JUDIC  "
    	SE2->E2_CODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse código de liberador
    	SE2->E2_XRJ     := "N"
    else
    	SE2->E2_APROVA  := ""
    	SE2->E2_DATALIB := CtoD("  /  /    ")
    	SE2->E2_STATLIB := ""
    	SE2->E2_USUALIB := ""
    	SE2->E2_CODAPRO := cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para liberação
    	SE2->E2_XRJ     := "S"
    endif
			
	SE2->(MsUnlock())
	
	RecLock("CND",.F.)
	CND->CND_XTITPG := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA    
//	CND->CND_NUMTIT := SE2->E2_NUM //ATUALIZO O NUMERO DO TITULO NO CAMPO PADRAO TOTVS PARA NAO DAR CHAVE DUPLICADA POR CONTA DA ALTERARAÇAO DO PREFIXO NO PE CN120ALT.PRW
	CND->(MsUnlock())
	
EndIf

SE2->(DbCloseArea())
Restarea(_aAreaCNE) //Incluido Ronaldo Bicudo - Totvs / 20/06/2018

Return

// Fabio Jadao Caires
// Data: 27/11/2017
// Se a medicao gera titulo a receber, conforme o tipo do contrato, grava informacoes adicionais no título (SE1) gerado

Static Function xGravSE1()

Local _aArea    := GetArea()
Local _lRet     := .T.
Local aRotAuto  := {}
Local cQuery    := ''
//Criado por Ronaldo Bicudo - Totvs / 28/07/2016
Local _cQuery   := ''
Local _cAliasM  := GetNextAlias()
Local _nValorM := 0
Local _nValorV := 0
//Fim da Inclusão
Local _aPref    := StrToArray(GetMv("MV_XRENPRF"),";")
Local _aPref2   := StrToArray(GetMv("MV_XRENPR2"),";")  //Criado porque no parametro MV_XRENPRF não cabe mais.
Local _cPref    := ""
Local _cTipo    := PadR(GetMv("MV_XRETIPO"),Len(SE1->E1_TIPO))
Local _cNat     := ""
Local _aDirf    := StrToArray(GetMv("MV_XREDIRF"),";")
Local _aDirf2   := StrToArray(GetMv("MV_XREDIR2"),";") //Criado porque no parametro MV_XREDIR2 não cabe mais.
Local _cDirf    := ""
Local _aCond    := {}
//Local _cNumTit  := PadR(StrZero(Year(dDataBase),4), Len(SE1->E1_NUM))
Local  _cDoc    := Soma1(GetMv("MV_XNUMTIT"),9) // número sequencial do título de Arrendamento/Aluguel - Gileno
Local _cNumTit  := _cDoc
Local _cCC      := ""
Local _cConta   := ""
Local _cItem    := ""
Local _cClass   := ""
Local _Cv005    := "" // Classe orcamentaria.
Local _cContra  := CND->CND_CONTRA
Local _cRevisa  := CND->CND_REVISA
Local _cNumplan := CND->CND_NUMERO
Local _cNumMed  := CND->CND_NUMMED
Local _cCodTran := CND->CND_XCTRAN
Local _cDescTra := CND->CND_XDTRAN
Local _mObs     := CND->CND_OBS //Incluido Ronaldo Bicudo - Totvs - 18/06/2018

//campos novos para preechimento no título
Local _dPerApu := CNF->CNF_DTVENC //periodo de aputração
Local _dApurac := CNF->CNF_DTVENC //apuração
Local _cCodRec := CN9->CN9_XCODRE //codigo de receita
Local _cCNPJ   := SM0->M0_CGC //CNPJ conforme sigamat
Local _cNome   := SM0->M0_FILIAL //Nome da empresa
Local _cObs	   := SubStr(CND->CND_OBS,1,250) // Observação Romay 10-07-15
Local cPicture  := X3Picture("E1_VALOR")
Local cBco      := Space(TamSX3("A6_COD")[1])
Local cAgc      := Space(TamSX3("A6_AGENCIA")[1])
Local cCta      := Space(TamSX3("A6_CONTA")[1])
Local _dDtVenc  := Ctod("") // Seleção da data de vencimento/pagamento do PA gerado pela medição - PRO FORMAS.
Local _cParcela := " " // Não gravo número de parcela porque  o número do título será único. - Gileno
Local cTpContr  := Alltrim(GetMV("MV_XTCONTR", .F., ""))
Local nX
Local nX2
Local nX3

_cConta := CNE->CNE_CONTA
_cCC    := CNE->CNE_CC
_cItem  := CNE->CNE_ITEMCT
_cClass := CNE->CNE_CLVL
_Cv005 	:= CNE->CNE_EC05DB

For nX := 1 to Len(_aPref)
	If Left(_aPref[nX], 3) == CN9->CN9_TPCTO
		_cPref := PadR( SubStr(_aPref[nX], 5, Len(_aPref[nX])), Len( SE1->E1_PREFIXO ) )
	EndIf
Next nX


For nX2 := 1 to Len(_aPref2)  // continuacao de _aPref
	If Left(_aPref2[nX2], 3) == CN9->CN9_TPCTO
		_cPref := PadR( SubStr(_aPref2[nX2], 5, Len(_aPref2[nX2])), Len( SE1->E1_PREFIXO ) )
	Endif
Next nX2

If Empty(_cPref)
	_cPref := "MED"
EndIf

// Posiciona no título a pagar - SE1 -- Usar CND_NUMMED pois nr do título é o nr da medição (Luiz)
//SE1->( DbSeek( CND->CND_FILIAL + _cPref + CND->CND_NUMTIT ) )
SE1->( DbSeek( CND->CND_FILIAL + _cPref + CND->CND_NUMMED ) )

//If	!SE1->(EOF()) .AND. SE1->E1_FILIAL == CND->CND_FILIAL .AND. Alltrim(SE1->E1_NUM) == Alltrim(CND->CND_NUMTIT) .AND. Alltrim(SE1->E1_MDCONTR) == Alltrim(CND->CND_CONTRA) .AND. Alltrim(SE1->E1_MDREVIS) == Alltrim(CND->CND_REVISA)
If	!SE1->(EOF()) .AND. SE1->E1_FILIAL == CND->CND_FILIAL .AND. Alltrim(SE1->E1_NUM) == Alltrim(CND->CND_NUMMED) .AND. Alltrim(SE1->E1_MDCONTR) == Alltrim(CND->CND_CONTRA) .AND. Alltrim(SE1->E1_MDREVIS) == Alltrim(CND->CND_REVISA)
	
	RecLock("SE1",.F.)
	
	//	SE1->E1_TIPO    := _cTipo
	SE1->E1_CCC     := _cCC
	SE1->E1_CREDIT  := _cConta
	SE1->E1_ITEMCTA := _cItem
	SE1->E1_CLVL    := _cClass
	SE1->E1_EC05CR  := _Cv005
	SE1->E1_XOBS    := _mObs //Incluido Ronaldo Bicudo - Totvs - 18/06/2018
	
	SE1->(MsUnlock())
	
	RecLock("CND",.F.)
	CND->CND_XTITPG := SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
	CND->(MsUnlock())
	
EndIf

Return
