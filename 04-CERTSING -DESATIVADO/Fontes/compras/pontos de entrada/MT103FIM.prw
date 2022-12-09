#include 'totvs.ch'
#include 'protheus.ch'

//+-------------------------------------------------------------------+
//| Rotina | MT103FIM | Autor | Rafael Beghini | Data | 16.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | P.E - Documento de entrada para tratar casas decimais
//|        | no campo SDE->DE_CUSTO1 Round(2)
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function MT103FIM()
	Local nOpcao   := PARAMIXB[1] //Opção Escolhida pelo usuario no aRotina 3-Incluir 4-Classificar Nota
	Local nConfirma:= PARAMIXB[2] //Se o usuario confirmou a operação de gravação da NFE
	Local cNumDoc  := SF1->F1_DOC
	Local cNumSer  := SF1->F1_SERIE
	Local cFornece := SF1->F1_FORNECE + SF1->F1_LOJA
	Local cPedido  := ''
	Local cItemPC  := ''
	Local cItemNf  := ''
	Local cItemDE  := ''
	Local nTotalD1 := 0
	Local nTotalDE := 0
	Local nAjuste  := 0
	Local nI       := 0
	Local aItensDE := {}
	Local aArea    := {}
	Local nCusto   := AScan( aHeader, {|e| AllTrim(e[2])=="D1_CC" 	})
	Local nDiasV   := Getmv("CT_QTDDIA",,5)
	Local cSuperV  := Getmv("CT_SUPFIN",,"vcoliveira@certisign.com.br")
	Local cSubject := GetMV("CT_APRSBJ",,"Documento de entrada - Vencimento")
	Local cMailApr := ""

	aArea := { SD1->(GetArea()), SDE->(GetArea()) }

	IF nOpcao == 3 .OR. nOpcao == 4

		SD1->( dbSetOrder(1) )
		IF SD1->( dbSeek( xFilial( 'SF1' ) + cNumDoc + cNumSer + cFornece ) )
			
			cPedido := SD1->D1_PEDIDO 
			cItemPC := SD1->D1_ITEMPC	

			While .NOT. SD1->( Eof() ) .AND. SD1->D1_DOC == cNumDoc .AND. SD1->D1_SERIE == cNumSer .AND. SD1->(D1_FORNECE+D1_LOJA) == cFornece
				cItemNf 	:= SD1->D1_ITEM
				nTotalD1 := SD1->D1_CUSTO
				
				SDE->( dbSetOrder(1) )
				IF SDE->( dbSeek( xFilial( 'SDE' ) + cNumDoc + cNumSer + cFornece + cItemNf  ) )
					While .NOT. SDE->( Eof() ) .AND. SDE->DE_DOC == cNumDoc .AND. SDE->DE_SERIE == cNumSer .AND. SDE->DE_ITEMNF == cItemNf
						aAdd( aItensDE, { SDE->DE_ITEM, SDE->DE_PERC, Round(SDE->DE_CUSTO1,2), SDE->(RecNo()) } )
					SDE->( dbSkip() )	
					End
					
					AEval( aItensDE, {|e| nTotalDE += e[3] })
					
					IF nTotalD1 <> nTotalDE
						nAjuste := nTotalD1 - nTotalDE
						ASort( aItensDE,,,{|a,b| a[ 2 ] > b[ 2 ] } )
						aItensDE[ 1, 3 ] := aItensDE[ 1, 3 ] + nAjuste
						
						Begin Transaction
							For nI := 1 To Len(aItensDE)
								SDE->( dbGoTo( aItensDE[ nI, 4 ] ) )
								SDE->( RecLock('SDE',.F.) )
								SDE->DE_CUSTO1 := aItensDE[ nI, 3]
								SDE->(MsUnLock())
							Next nI
						End Transaction
						 
					EndIF
					aItensDE := {}
					nTotalDE := 0
					nTotalD1 := 0
					nAjuste  := 0
				EndIF
			SD1->( dbSkip() )
			End
		EndIF

		/*
		Compila		
		Inicio - Valida data de Vencimento x Data Base 
		*/
		If ((nOpcao == 3 .or. nOpcao == 4 ) .And. nConfirma == 1)
			DbSelectArea("SE2")
			SE2->(DbSetOrder(6))
			SE2->(DbGoTop())
			If DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
				While SE2->(!Eof()) .And. xFilial("SE2") == SE2->E2_FILIAL .And.;
					SF1->F1_FORNECE == SE2->E2_FORNECE .And.;
					SF1->F1_LOJA == SE2->E2_LOJA .And.;
					SF1->F1_SERIE == SE2->E2_PREFIXO .And.;
					SF1->F1_DOC == SE2->E2_NUM

					dVencrea := SE2->E2_VENCREA
					// Atualiza o vencimento real do titulo se entrar vencido na classificacao
					If DateDiffDay(dVencrea,Date()) < nDiasV
					
						DbSelectArea("SC7")
						SC7->(DbSetOrder(1))
						If DbSeek(xFilial("SF1")+cPedido+cItemPC)

							DbSelectArea("SAL")
							SAL->(DbSetOrder(1))
							DbSeek(xFilial("SAL")+SC7->C7_APROV+"01")
							cMailApr := Iif(AllTrim(UsrRetMail(SAL->AL_USER)) != "roni.franco@certisign.com.br",UsrRetMail(SAL->AL_USER),"")

							oProcess	:= TWFProcess():New( "VENC_NF","Documento de entrada - Vencimento" )
							oProcess:NewTask( "VENC_NF","\WORKFLOW\VENC_NF.htm")
					
							oHtml	:= oProcess:oHtml
							oHtml:ValByName( "CDOCUMENTO" 	, SF1->F1_DOC+"/"+SF1->F1_SERIE )
							oHtml:ValByName( "CFORNECEDOR" 	, SF1->F1_FORNECE+"-"+SF1->F1_LOJA+":"+Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME"))
							oHtml:ValByName( "CVALOR" 		, TransForm(SF1->F1_VALBRUT,"@E 999,999,999,999.99"))
							
							oProcess:cTo 		:= cSuperV +';'+ cMailApr
							oProcess:cSubject 	:= cSubject
							oProcess:CFROMNAME	:= "NO-REPLY"
							oProcess:Start()
							oProcess:Free()
							Exit
						EndIf 
					EndIf
					
				SE2->(DBSKIP())
				EndDo
			EndIf
		EndIf 
		/*
		Compila
		Fim - Valida data de Vencimento x Data Base 
		*/

	EndIF
	
	IF nOpcao == 3 .And. SF1->F1_TIPO == 'D' .And. nConfirma > 0
		//NF Devolução referente a Contratos
		FwMsgRun(,{|| U_A680NFDev( cNumDoc, cNumSer, cFornece, nOpcao ) },,'Aguarde, verificando se há faturamento de medição...')
	EndIF
	
	/*IF nOpcao == 3 .And. RTrim(aCols[1,nCusto]) == "80000000"
		//NF Devolução referente a Contratos
		FwMsgRun(,{|| U_CRPA044F() },,'Aguarde, gerando faturas para remuneracao...')
	EndIF*/
		
	AEval( aArea, {|xArea| RestArea(xArea) } )
Return
