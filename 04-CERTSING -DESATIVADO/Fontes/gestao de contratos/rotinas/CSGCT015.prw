#INCLUDE "CNTA260.ch"
#include "protheus.ch"
#include "tbiconn.ch"

#DEFINE DEF_SVIGE "05" //Vigente
//-----------------------------------------------------------------------
// Rotina | CSGCT050  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina responsavel pela execucao das medicoes de contratos 
//        | do tipo automático  
//-----------------------------------------------------------------------
// Param. | cExp01 - Codigo da Empresa
//        | cExp02 - Codigo da Filial
//        | cExp03 - Horario da execucao HH:MM / Intervalo
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSGCT015(aParam)
	Local lInterval := .T.
	Local cCodEmp   := ''
	Local cCodFil   := ''
	Local cInterval := ''
	
	PRIVATE lMsErroAuto := .F.
	
	cCodEmp   := Iif( aParam == NIL, '01', aParam[ 1 ] )
	cCodFil   := Iif( aParam == NIL, '02', aParam[ 2 ] )
	cInterval := Iif( aParam == NIL, '0' , aParam[ 3 ] )
	
	//Verifica se a rotina e executada atraves de um JOB ou pelo menu
	If ValType(cCodEmp) <> "U" //GetRemoteType() == -1//Execucao por JOB
		lInterval := (At(":",cInterval)==0)
		
		If lInterval .Or. (LEFT( Time(), 5 ) == cInterval)
			RpcSetType ( 3 )
			PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil MODULO "GCT"
				u_xCN260Exc(.T.)
			RESET ENVIRONMENT
		EndIf
	Else//Execucao por Menu
		If Aviso("CNTA260",OemToAnsi(STR0015),{OemToAnsi(STR0017),OemToAnsi(STR0016)}) == 1
			Processa( {|| u_xCN260Exc(.F.) } )
		EndIf
	EndIf
Return(.T.)
//-----------------------------------------------------------------------
// Rotina | xCN260Exc  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Executa medicoes pendentes para os contratos automaticos  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function xCN260Exc(lJob)
Local aCab    := {}//Cabecalho
Local aItem   := {}//Itens
Local aLinha  := {}
Local aCABEC  := {}
Local aITENS  := {}
Local cPROD   := ''
Local cQuery  := ''
Local cNum    := ''
Local dData   := If(lJob,date(),dDataBase)//Data Atual
Local cTxLog  := ''//Texto do log
Local lContinua := .F.
Local lQuery  := .F.
Local nDias   := GetNewPar( "MV_MEDDIAS", 0 )//Parametro que armazena a quantidade de dias de busca
Local dDataI  := dData-nDias//Data de inicio
Local nStack  := 0 
Local cTES    := ''
Local cCONT   := ''
Local cArqTrb := ''
Local cMV_TES := ''
Local cMV_650PROC := 'MV_650PROC'

If .NOT. SX6->( ExisteSX6( 'MV_GCT15TS' ) )
	CriarSX6( 'MV_GCT15TS', 'C', 'TES utilizada para medicoes de compra. CSGCT15.prw', '103' )
Endif

cMV_TES := GetMv( 'MV_GCT15TS' )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera historico                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTxLog := STR0018+" - "+DTOC(dData)+" - "+time()+CHR(13)+CHR(10)//"Log de execucao das medicoes automaticas"
cTxLog += Replicate("-",128)+CHR(13)+CHR(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se o sistema foi atualizado    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lContinua := (CN1->(FieldPos("CN1_MEDAUT")) > 0)

If lContinua
	nStack := GetSX8Len()
	
	If lJob
		ConOut(STR0001)//"Verificando medições pendentes"
		ConOut(STR0002 + time())
	Else
		IncProc(STR0001 + " - " + DTOC(dData))
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra parcelas de contratos automaticos ³
	//³ pendentes para a data atual              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTrb	:= CriaTrab( nil, .F. )
	cQuery := "SELECT DISTINCT CNF.CNF_COMPET,CNF.CNF_CONTRA,CNF.CNF_REVISA,CNA.CNA_NUMERO,CNF.CNF_PARCEL,CN9.CN9_FILIAL FROM " + RetSQLName("CNF") + " CNF, " + RetSQLName("CNA") + " CNA, "+ RetSQLName("CN9") +" CN9, "+ RetSQLName("CN1") +" CN1 WHERE "
	cQuery += "CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
	cQuery += "CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND "
	cQuery += "CN9.CN9_FILIAL = '"+ xFilial("CN9") +"' AND "
	cQuery += "CN1.CN1_FILIAL = '"+ xFilial("CN1") +"' AND "
	cQuery += "CNF.CNF_NUMERO = CNA.CNA_CRONOG AND "
	cQuery += "CNF.CNF_CONTRA = CNA.CNA_CONTRA AND "
	cQuery += "CNF.CNF_REVISA = CNA.CNA_REVISA AND "
	cQuery += "CNF.CNF_CONTRA = CN9.CN9_NUMERO AND "
	cQuery += "CNF.CNF_REVISA = CN9.CN9_REVISA AND "
	//cQuery += "CN9.CN9_TPCTO  = CN1.CN1_CODIGO AND "
	cQuery += "CN1.CN1_MEDAUT = '1' AND "
	cQuery += " cnf.cnf_contra||cnf.CNf_COMPET||cna.cna_numero||cnf.cnf_parcel NOT IN (SELECT CND_CONTRA||CND_COMPET||CND_NUMERO||CND_PARCEL From "+RetSQLName("CND")+" WHERE  CND_filial = '"+xFilial("CND")+"' AND CND_DTINIC >= '"+DTOS(dDataI)+"' AND    CND_DTINIC <= '"+DTOS(dData)+"' AND D_E_L_E_T_= ' ' )  AND "
	cQuery += "CN9.CN9_SITUAC = '"+ DEF_SVIGE +"' AND "
	cQuery += "CNF.CNF_PRUMED >= '"+ DTOS(dDataI) +"' AND "
	cQuery += "CNF.CNF_PRUMED <= '"+ DTOS(dData) +"' AND "
	cQuery += "CNF.CNF_SALDO  > 0 AND "
	cQuery += "CNA.CNA_SALDO  > 0 AND "
	cQuery += "CNF.D_E_L_E_T_ = ' ' AND "
	cQuery += "CNA.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery( cQuery )

	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )

	While !(cArqTrb)->(Eof())
		lQuery    := .T.
		
		aCab  := {}
		aItem := {}
		cNum := CriaVar("CND_NUMMED")
		aAdd(aCab,{"CND_CONTRA",(cArqTrb)->CNF_CONTRA,NIL})
		aAdd(aCab,{"CND_REVISA",(cArqTrb)->CNF_REVISA,NIL})
		aAdd(aCab,{"CND_COMPET",(cArqTrb)->CNF_COMPET,NIL})
		aAdd(aCab,{"CND_NUMERO",(cArqTrb)->CNA_NUMERO,NIL})
		aAdd(aCab,{"CND_NUMMED",cNum,NIL})
		If !Empty(CND->( FieldPos( "CND_PARCEL" ) ))
			aAdd(aCab,{"CND_PARCEL",(cArqTrb)->CNF_PARCEL,NIL})
		EndIf
		
		CNB->( dbSetOrder(1) )
		CNB->( dbSeek( (cArqTrb)->CN9_FILIAL + (cArqTrb)->CNF_CONTRA + (cArqTrb)->CNF_REVISA + (cArqTrb)->CNA_NUMERO ) )
		While CNB->(!EOF()) .And. ;
		      CNB->( CNB_FILIAL + CNB_CONTRA + CNB_REVISA + CNB_NUMERO ) == (cArqTrb)->CN9_FILIAL + (cArqTrb)->CNF_CONTRA + (cArqTrb)->CNF_REVISA + (cArqTrb)->CNA_NUMERO .And. ;
		      CNB->CNB_SLDMED > 0
			SB1->( dbSetorder(1) )
			SB1->( dbSeek( xFilial('SB1') + CNB->CNB_PRODUT ) )
			cTES  := SB1->B1_TE
			cCONT := SB1->B1_CONTA
			
			aLinha := {}
			aadd(aLinha,{"CNE_ITEM" 	,CNB->CNB_ITEM                ,NIL})
			aadd(aLinha,{"CNE_PRODUT" 	,CNB->CNB_PRODUT              ,NIL})
			aadd(aLinha,{"CNE_QUANT" 	,1                            ,NIL})
			aadd(aLinha,{"CNE_VLUNIT" 	,CNB->CNB_VLUNIT              ,NIL})
			aadd(aLinha,{"CNE_VLTOT" 	,CNB->CNB_VLUNIT              ,NIL})
			aadd(aLinha,{"CNE_TE" 		,IIF(Empty(cTES),cMV_TES,cTES),NIL})
			aadd(aLinha,{"CNE_DTENT"	,dData                        ,NIL})
			aadd(aLinha,{"CNE_CC" 		,CNB->CNB_CC                  ,NIL})
			aadd(aLinha,{"CNE_CONTA"	,cCONT                        ,NIL})
			
			aadd(aItem,aLinha)
			CNB->( dbSkip() )
		End
		
		If lJob
			ConOut(STR0003 + " - " + aCab[5,2])
			ConOut(STR0004 + " - " + (cArqTrb)->CNF_CONTRA)
			ConOut(STR0005 + " - " + (cArqTrb)->CNA_NUMERO)
			ConOut(STR0006 + " - " + aCab[3,2])
		Else
			IncProc(STR0003 + " - " + aCab[5,2])
		EndIf
		
		lMsErroAuto := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa rotina automatica para gerar as medicoes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CNTA120(aCab,aItem,3,.F.)
		If !lMsErroAuto
			cTxLog += STR0019+" - "+aCab[5,2]+CHR(13)+CHR(10)//"Medicao gerada com sucesso"
			cTxLog += STR0004+" - "+(cArqTrb)->CNF_CONTRA+CHR(13)+CHR(10)
			cTxLog += STR0022+" - "+(cArqTrb)->CN9_FILIAL+CHR(13)+CHR(10)			
			cTxLog += STR0005+" - "+(cArqTrb)->CNA_NUMERO+CHR(13)+CHR(10)
			cTxLog += STR0006+" - "+aCab[3,2]+CHR(13)+CHR(10)
			If lJob
				ConOut(STR0007+aCab[5,2]+STR0008)
			EndIf
			
			aITENS := {}
			aCABEC := {(cArqTrb)->CN9_FILIAL, (cArqTrb)->CNF_CONTRA, (cArqTrb)->CNF_REVISA, aCAB[5,2], (cArqTrb)->CNF_COMPET, Date()}
			
			SB1->( dbSetOrder(1) )
			CNE->( dbSetOrder(1) )
			CNE->( dbSeek( (cArqTrb)->(CN9_FILIAL+CNF_CONTRA+CNF_REVISA+CNA_NUMERO+aCAB[5,2]) ) )
			While CNE->( !Eof() ) .And. CNE->CNE_FILIAL == (cArqTrb)->CN9_FILIAL .And. CNE->CNE_NUMMED == aCAB[5,2]
				IF CNE->CNE_QUANT > 0
					SB1->( MsSeek(CNE->CNE_FILIAL + CNE->CNE_PRODUTO) )
					cPROD := rTrim( SB1->B1_DESC )
						
					aADD( aITENS, {CNE->CNE_ITEM, CNE->CNE_PRODUTO, cPROD, CNE->CNE_QUANT, CNE->CNE_VLUNIT, CNE->CNE_VLTOT} )
				EndIF
			CNE->( dbSkip() )
			End
			
			IF Len( aITENS ) > 0
				IF GetMv( cMV_650PROC, .F. ) == '1' //Parâmetro habilitado para envio de e-mail
					U_A650Med( aCABEC, aITENS, .T. )
				EndIF
			EndIF
		Else
			//Retorna controle de numeracao
			While GetSX8Len() > nStack
				RollBackSX8()
			EndDo
		EndIf
		(cArqTrb)->(dbSkip())
	EndDo
	
	(cArqTrb)->(dbCloseArea())
	
	If lJob
		ConOut(STR0013 + time())
	EndIf
	cTxLog += STR0013 + time()
Else
	If lJob
		ConOut(STR0014)
	Else
		Aviso("CNTA260",STR0014,{"Ok"})
	EndIf
	cTxLog += STR0014
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada apos a gravacao da medição automática   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CNT260GRV")
	ExecBlock("CNT260GRV",.F.,.F.)
EndIf

If lQuery
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa gravacao do arquivo de historico          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MemoWrite(Criatrab(,.f.)+".LOG",cTxLog)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Emite alerta com o log do processamento           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MEnviaMail("041",{cTxLog})
EndIf
Return