#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fT300but   ºAutor  ³ Luiz Alberto   º Data ³  Nov/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Historico Clientes na Tela Oportunidade                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FT300BUT()
Local aBut := {}

Aadd(aBut,{'Historico Cliente' , '',{|| Iif(!Empty(M->AD1_CODCLI),U_HISTCLI(M->AD1_CODCLI,M->AD1_LOJCLI),.T.)},'PRODUTO'   ,,{1,2,3,4}})
Aadd(aBut,{'Hist. Ligacoes'    , '',{|| fHistLiga(M->AD1_CODCLI,M->AD1_LOJCLI,M->AD1_PROSPE,M->AD1_LOJPRO)},'PRODUTO'   ,,{1,2,3,4}})

Return( aBut )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fT300but   ºAutor  ³ Luiz Alberto   º Data ³  Nov/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Historico Clientes na Tela Oportunidade                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fHistLiga(cCliente,cLoja,cProspe,cLojaPro)
Local oMonoAs	:= TFont():New( "Courier New", 6, 0 )		// Fonte				
Local cCodPed	:= ""                                       // Codigo do atendimento
Local oDlgHist	:= Nil										// Tela do historico
Local oLbx		:= Nil										// Listbox com os registros do cabecalho	
Local oGetHist	:= Nil										// Getdados com os itens do atendimento
Local oObsMemo	:= Nil										// MEMO da observacao do atendimento
Local cObsMemo	:= ""										// Descricao do memo	
Local oCancMemo	:= Nil										// MEMO do cancelamento do atendimento
Local cCancMemo	:= ""                                       // Descricao do cancelamento
Local nEscolha 	:= 0										// Opcao OK ou CANCELA
Local aLigacoes := {}										// Array com o cabecalho do atendimento
Local lRet		:= .F.									 	// Retorno da funcao
Local l380 	 	:= .F.                                      // Flag que indica quem chamou essa rotina (pre-atendimento ou nao).
Local aArea		:= GetArea()								// Salva a area atual
// Bitmaps das legendas do historico
Local oBmp1													// Atendimento 												
Local oBmp2 												// Orcamento
Local oBmp3 												// Aberto
Local oBmp4 												// Liberado
Local oBmp5 												// Faturado 
Local oBmp6 												// Cancelado
Local oBmp7 												// Em Carga (integracao com OMS)
Local lProspect := (!Empty(cProspe))

nUsado := 0

aCols := {}
aHeader := {}

DbSelectArea("SX3")
dbSetOrder(1)
DbSeek("SUB")
While !Eof().And.(x3_arquivo=="SUB")

	If X3USO(x3_usado).And.cNivel>=x3_nivel .And. !Alltrim(X3_CAMPO) $ "UB_FILIAL"
		nUsado:=nUsado+1
		Aadd(aHeader,{ Trim(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, x3_valid,;
		x3_usado, x3_tipo, x3_F3, x3_context, x3_cbox, x3_relacao } )
	Endif
	DbSkip()
End

aadd(aCOLS,Array(nUsado+1))
For nCntFor	:= 1 To nUsado
	aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
Next nCntFor      
aCOLS[1][Len(aHeader)+1] := .F.        

aFirst := aClone(aCols)

CursorWait()

DbSelectArea("SUA")
DbSetOrder(7)		//FILIAL+CLIENTE+LOJA+STR(UA_DIASDAT,8,0)+STR(UA_HORADAT,8,0)

cQuery := "SELECT * "
cQuery += "FROM " + RetSqlName("SUA") + " SUA "
cQuery += "WHERE "
cQuery += 		"SUA.UA_FILIAL='"  + xFilial("SUA") + "' AND "
cQuery += 		"SUA.UA_CLIENTE='" + Iif(!Empty(cProspe),cProspe,cCliente)  + "' AND "
cQuery += 		"SUA.UA_LOJA='"    + Iif(!Empty(cProspe),cLojaPro,cLoja)     + "' AND "
cQuery += 		"SUA.UA_PROSPEC='" + IIF(lProspect,'T','F') + "' AND "
cQuery += 		"SUA.D_E_L_E_T_<>'*'"
cQuery += " ORDER BY " + SqlOrder(IndexKey())		
		
cQuery := ChangeQuery(cQuery)
		
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMK',.T.,.T.)
DbSelectArea("TMK")
While (!Eof())
			
	AAdd(aLigacoes, {	TkLeg(TMK->UA_DOC,TMK->UA_OPER,TMK->UA_CANC,TMK->UA_NUM),;// 01 - Status
						TMK->UA_NUM,;													// 02 - Atendimento
						DTOC(STOD(TMK->UA_EMISSAO)),;									// 03 - Data	
						Posicione("SA3",1,xFilial("SA3")+TMK->UA_VEND,"A3_NOME"),;		// 04 - Vendedor
						TkOper(TMK->UA_OPER),;									// 05 - Operacao
						IIF(!Empty(TMK->UA_CODCONT),Posicione("SU5",1,xFilial("SU5")+TMK->UA_CODCONT,"U5_CONTAT"),TMK->UA_DESCNT),;	// 06 - Contato
						TMK->UA_NUMSC5,;												// 07 - Pedido
						TkStatus(TMK->UA_STATUS),;									// 08 - Status
						Transform(TMK->UA_VLRLIQ,"@E 999,999,999.99"),;					// 09 - Valor
						Posicione("SUO",1,xFilial("SUO")+TMK->UA_CODCAMP,"UO_DESC"),;	// 10 - Campanha	
						TMK->UA_DOC+"/"+TMK->UA_SERIE,;									// 11 - NF/SERIE
						DTOC(STOD(TMK->UA_EMISNF)),;									// 12 - Emissao
						Posicione("SE4",1,xFilial("SE4")+TMK->UA_CONDPG,"E4_DESCRI"),;	// 13 - Condicao de Pagto
						Posicione("SA4",1,xFilial("SA4")+TMK->UA_TRANSP,"A4_NOME"),;	// 14 - Transportadora	
						TMK->UA_ENDENT,;												// 15 - Endereco Entrega
						TMK->UA_MUNE,;													// 16 - Cidade Entrega
						TMK->UA_CEPE,;													// 17 - Cep Entrega
						TMK->UA_PROXLIG,;												// 18 - Retorno
						TMK->UA_HRPEND,;                                               	// 19 - Hora 	
						TMK->UA_CODOBS,;                                               	// 20 - Codigo Observacao
						TMK->UA_CODCANC} )                                             	// 21 - Codigo do Cancelamento
	DbSkip()
End
DbSelectArea("TMK")
DbCloseArea()
If Len(aLigacoes) <= 0
	Help(" ",1,"SEMDADOS" )
   	CursorArrow()
   	RestArea(aArea)
   	Return(lRet)
Endif
		
cNomCli := ''
If !lProspect
	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+cCliente+cLoja))
	cNomCli := SA1->A1_NOME
Else
	SUS->(dbSetOrder(1), dbSeek(xFilial("SUS")+cProspe+cLojaPro))
	cNomCli	:= SUS->US_NOME
Endif


DEFINE MSDIALOG oDlgHist FROM  50,001 TO 600,750 TITLE "Historico" PIXEL //"Historico" 
	
	@01,02 TO 210,374 LABEL "Ultimas Ligacoes" +" :"+ cNomCli OF oDlgHist  PIXEL //"Ultimas Ligacoes" 
	
	@08,05 LISTBOX oLbx FIELDS;
		HEADER ;
			" ",;		// Cores 
			'Atendimento',;	// Atendimento  
			'Data',;	// Data  
			'Vendedor',;	// Vendedor  
			'Operacao',;	// Opera‡„o  
			'Contato',;	// Contato  
			'Pedido',;	// Pedido  
			'Status',;	// Status  
			'Valor',;	// Valor  
			'Campanha',;	// Campanha  
			'Nota Fiscal',;	// Nota Fiscal  
			'Emissao NF',;	// Emiss„o NF  
			'Condicao de Pagto' ,;	// Condi‡„o de Pagto 
			'Transportadora',;	// Transportadora  
			'Endereco Entrega',;	// Endere‡o Entrega  
			'Cidade',;	// Cidade  
			'CEP',;	// CEP 
			'Retorno',;	// Retorno 
			'Hora';	// Hora 
		SIZE 365,100 OF oDlgHist PIXEL  
	
		oLbx:SetArray(aLigacoes)
		oLbx:bLine:={||{aLigacoes[oLbx:nAt,1],;
						aLigacoes[oLbx:nAt,2],;
						aLigacoes[oLbx:nAt,3],;
						aLigacoes[oLbx:nAt,4],;
						aLigacoes[oLbx:nAt,5],;
						aLigacoes[oLbx:nAt,6],;
						aLigacoes[oLbx:nAt,7],;
						aLigacoes[oLbx:nAt,8],;
						aLigacoes[oLbx:nAt,9],;
						aLigacoes[oLbx:nAt,10],;
						aLigacoes[oLbx:nAt,11],;
				        aLigacoes[oLbx:nAt,12],;
				        aLigacoes[oLbx:nAt,13],;
				        aLigacoes[oLbx:nAt,14],;
				        aLigacoes[oLbx:nAt,15],;
				        aLigacoes[oLbx:nAt,16],;
				        aLigacoes[oLbx:nAt,17],;
						aLigacoes[oLbx:nAt,18],;
						aLigacoes[oLbx:nAt,19],;			        
						aLigacoes[oLbx:nAt,20],;			        
						aLigacoes[oLbx:nAt,21]}}			        
		
	oLbx:bChange:= {|| cCodPed:= aLigacoes[oLbx:nAt,2],;
					   TkCargaItem(	@cObsMemo	,@cCancMemo				,oObsMemo				,oCancMemo,;
										oGetHist	,aLigacoes[oLbx:nAt,2]	,aLigacoes[oLbx:nAt,20]	,aLigacoes[oLbx:nAt,21] )}
	oLbx:Refresh()
	oLbx:SetFocus(.T.)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pego o codigo do atendimento e carrega o acols com os itens	  ³
	//³deste atendimento se ele existir.                          	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodPed := Eval(oLbx:bLine)[2]
		
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pego o codigo do atendimento e carrega o acols com os itens	  ³
	//³deste atendimento se ele existir.                          	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodPed := Eval(oLbx:bLine)[2]
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o acols com os itens da ligacao selecionada.			   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TkMontaItens("SUB",cCodPed,"V")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Modificado o valor da variavel N para 1 para que não seja tomado³
	//³como parametro a posicao do acols da tela de atendimento        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	n := 1
	oGetHist:= MSGetDados():New(115,5,200,370,2,"AlwaysTrue","AlwaysTrue","",.T.,,,.F.,300)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Observa‡„o da liga‡„o										   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 212,02 TO 258,124 LABEL "Observacao da ligacao"  OF oDlgHist PIXEL  // //"Observa‡„o da liga‡„o" 
	@ 220,05 GET oObsMemo VAR cObsMemo OF oDlgHist MEMO SIZE 114,35 PIXEL READONLY
	oObsMemo:oFont := oMonoAs
	oObsMemo:bRClicked := {|| AllwaysTrue() }
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Motivo do Cancelamento se for um or‡amento cancelado  		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 212,133 TO 258,257 LABEL "Motivo do Cancelamento"  OF oCancMemo PIXEL  // //"Motivo do Cancelamento" 
	@ 220,138 GET oCancMemo VAR cCancMemo OF oCancMemo MEMO SIZE 114,35 PIXEL READONLY
	oCancMemo:oFont := oMonoAs
	oCancMemo:bRClicked := {|| AllwaysTrue() }

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Bitmaps das legendas do historico     ³
	//³                                      ³
	//³Marrom - Atendimento 			     ³
	//³Azul -  Orcamento                     ³
	//³Verde - Aberto                        ³
	//³Amarelo - Liberado                    ³
	//³Vermelho - NF.Emitida                 ³
	//³Preto - Cancelado                     ³
	//³Branco - Em Carga (integracao com OMS)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    // Legendas da Tela
    
	@ 265,05 BITMAP oBmp1 ResName "BR_MARRON" OF oDlgHist Size 10,10 NoBorder When .F. Pixel 
	@ 265,15 SAY "Atendimento" OF oDlgHist Color CLR_BROWN,CLR_WHITE PIXEL   	//"Atendimento"

	@ 265,55 BITMAP oBmp2 ResName "BR_AZUL" OF oDlgHist Size 10,10 NoBorder When .F. Pixel 
	@ 265,65 SAY "Orcamento" OF oDlgHist Color CLR_BLUE,CLR_WHITE PIXEL  	//"Orcamento"

	@ 265,105 BITMAP oBmp3 ResName "BR_VERDE" OF oDlgHist Size 10,10 NoBorder When .F. Pixel
	@ 265,115 SAY "Aberto" OF oDlgHist Color CLR_GREEN,CLR_WHITE PIXEL  	//"Aberto"

	@ 265,155 BITMAP oBmp4 ResName "BR_AMARELO" OF oDlgHist Size 10,10 NoBorder When .F. Pixel
	@ 265,165 SAY "Liberado" OF oDlgHist Color CLR_BLACK PIXEL  			//"Liberado"
        
	@ 265,205 BITMAP oBmp5 ResName "BR_VERMELHO" OF oDlgHist Size 10,10 NoBorder When .F. Pixel
	@ 265,215 SAY "NF.Emitida" OF oDlgHist Color CLR_RED,CLR_WHITE PIXEL  	//"NF.Emitida"

	@ 265,255 BITMAP oBmp6 ResName "BR_PRETO" OF oDlgHist Size 10,10 NoBorder When .F. Pixel
	@ 265,265 SAY "Cancelado" OF oDlgHist Color CLR_BLACK,CLR_WHITE PIXEL  //"Cancelado

	@ 265,305 BITMAP oBmp7 ResName "BR_BRANCO" OF oDlgHist Size 10,10 NoBorder When .F. Pixel
	@ 265,315 SAY "Em Carga" OF oDlgHist Color CLR_BLACK,CLR_WHITE PIXEL  	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega o atendimento para a tela do Televendas para a operacao de ALTERACAO                                                 ³
	//³Quando a rotina for executa a partir da Agenda de Operador somente sao feitas inclusoes de atendimento, por isso o flag l380 ³
	//³Quando a operacao for de VISUALIZACAO o historico so pode ser consultado sem alteracao de atendimento.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (!l380) .OR. (nOpc <> 2)
		DEFINE SBUTTON FROM 240,300 TYPE 1 	ENABLE OF oDlgHist ACTION (nEscolha:=1,oDlgHist:End())
	Endif	
	
	DEFINE SBUTTON FROM 240,340 TYPE 2 	ENABLE OF oDlgHist ACTION (nEscolha:=0,oDlgHist:End())		

ACTIVATE MSDIALOG oDlgHist CENTER ON INIT CursorArrow()

RestArea(aArea)
	
Return(.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Tk271OrcPed ³ Autor ³Marcelo Kotaki       ³ Data ³ 08/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica quais os pedidos estao liberados e com NF gerada	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TeleVendas                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo K ³11/06/02³710   ³-Revisao do fonte                     	  ³±±
±±³Andrea F. ³31/05/04³811   ³-BOPS:71829 Correcao da exibicao dos Bitmaps³±±
±±³          ³        ³      ³ das Legendas Liberado e Encerrado.         ³±±
±±³Fernando  ³23/10/06³811   ³- BOPS:110887 correcao da exibicao dos      ³±±
±±³          ³        ³      ³Bitmaps para somente mudar para faturado    ³±±
±±³          ³        ³      ³caso todos os itens do ped. sejam faturados ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TkLeg(cNF,cOper,cCanc,cNum)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bitmaps das legendas do historico     ³
//³                                      ³
//³Marrom - Atendimento 			     ³
//³Azul -  Orcamento                     ³
//³Verde - Aberto                        ³
//³Amarelo - Liberado                    ³
//³Vermelho - NF.Emitida                 ³
//³Preto - Cancelado                     ³
//³Branco - Em Carga (integracao com OMS)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oAtendimento:= LoadBitmap( GetResources(),"BR_MARRON")        // Bitmap 
Local oOrcamento  := LoadBitmap( GetResources(),"BR_AZUL")			// Bitmap 
Local oAberto	  := LoadBitmap( GetResources(),"BR_VERDE")			// Bitmap 	
Local oLiberado   := LoadBitmap( GetResources(),"BR_AMARELO") 		// Bitmap 
Local oFaturado   := LoadBitmap( GetResources(),"BR_VERMELHO")		// Bitmap 
Local oCancelado  := LoadBitmap( GetResources(),"BR_PRETO")			// Bitmap 
Local oCarga      := LoadBitmap( GetResources(),"BR_BRANCO")		// Bitmap 
Local oRet															// Objeto de Retorno
Local aArea		  := GetArea()										// Salva a area atual

DbSelectArea("SUA")
DbSetOrder(1)
DbSeek(xFilial("SUA")+cNum)

If !Empty(TRIM(cCanc))
	oRet := oCancelado
Else	
	If cOper == "1" //Faturamento
		Do case
			Case Empty(cNF) //Aberto
				oRet := oAberto
				
				If !Empty(SUA->UA_NUMSC5)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifico se esse pedido foi liberado pelo SIGAFAT³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("SC9")
					DbSetOrder(1)
					If DbSeek(xFilial("SC9")+SUA->UA_NUMSC5)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se todos os itens estao faturados,           ³
						//³caso um item nao esteja a legenda ficara como liberado³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea("SC6")
				   		DbSetOrder(1)
						If DbSeek( xFilial( "SC6" ) + SUA->UA_NUMSC5 )
						 
							While !SC6->( Eof() ) .AND. SUA->UA_NUMSC5 == SC6->C6_NUM
								If Empty( SC6->C6_NOTA )
								    oRet := oLiberado
								    Exit
						   		Else
						   			oRet:=oFaturado
								Endif  
								SC6->( DbSkip() )
							End 
							
						 EndIf	
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifico se esse pedido esta em Carga (OMS)      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("DAI")
					DbSetOrder(4)
					If DbSeek(xFilial("DAI")+SUA->UA_NUMSC5)
						oRet := oCarga
					Endif						
					
				Endif
				
			Case !Empty(cNF) // NF. Emitida
				oRet := oFaturado
		Endcase
		
	ElseIf cOper == "2"  //Or‡amento
		oRet := oOrcamento
		
	ElseIf cOper == "3"  //Atendimento
	    oRet := oAtendimento	
	Endif
Endif

RestArea(aArea)
Return(oRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TkOperTlv  ³ Autor ³Luis Marcelo Kotaki	 ³ Data ³22/07/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Busca o tipo de operacao realizada no ATENDIMENTO selecionado³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TeleVendas                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TkOper(cCampo)
Local cDesc := ""		//Tipo de operacao

Do Case
	Case AllTrim(cCampo) == "1"
		cDesc := "Faturamento"
	Case AllTrim(cCampo) == "2"
		cDesc := "Or‡amento  " 
	Case AllTrim(cCampo) == "3"
		cDesc := "Atendimento" 
Endcase          

Return(cDesc)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TkStatus   ³ Autor ³Vendas Clientes    	 ³ Data ³21/07/00  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Busca o status do pedido selecionado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TeleVendas - SX3                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   
Static Function TkStatus(cCampo)

Local cDesc := " "			//Retorno do status

Do case
	case AllTrim(cCampo) == "NF." .AND. AllTrim(SUA->UA_OPER) == "1"
  		 cDesc := "NF.Emitida" 
  		 
	case AllTrim(cCampo) == "RM." .AND. AllTrim(SUA->UA_OPER) == "1"
  		 cDesc := "Merc.Enviada" 

	case AllTrim(cCampo) == "SUP" .AND. AllTrim(SUA->UA_OPER) == "1"
  		 cDesc := "Ped. Bloq." 

	case AllTrim(cCampo) == "SUP" .AND. AllTrim(SUA->UA_OPER) == "3"  // Atendimento
  		 cDesc := "Atendimento"

	case AllTrim(cCampo) == "CAN"
  		 cDesc := "Cancelado " 

	case AllTrim(SUA->UA_STATUS) == "LIB"
  		 cDesc := "Liberado  " 

	other
		 cDesc := "Or‡amento" 
Endcase

Return(cDesc)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±± 
±±³Fun‡„o	 ³TkCargaItem ³ Autor ³ Luis Marcelo Kotaki	 ³ Data ³ 15/03/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Carrega os items gravados em cada atendimento selecionado    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TeleVendas                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo K ³11/06/02³710   ³-Revisao do fonte                     	   ³±±
±±³          ³        ³      ³                                             ³±±
±±³          ³        ³      ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TkCargaItem(	cObsMemo	,cCancMemo	,oObsMemo	,oCancMemo,;
								oGetHist	,cCodPed	,cCodObs	,cCodCan)

Local aFirst[1][Len(aHeader)+1]

aCols := aClone(aFirst)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o acols com os itens da ligacao selecionada.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TkMontaItens("SUB",cCodPed,"V")

oGetHist:oBrowse:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrego a observa‡„o do or‡amento e o motivo do cancelam. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cObsMemo := MSMM(cCodObs,TamSx3("UA_OBS")[1])
oObsMemo:Refresh()

cCancMemo:= MSMM(cCodCan,TamSx3("UA_OBSCANC")[1])
oCancMemo:Refresh()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³TkMontaItens ³ Autor ³ Vendas e CRM       ³ Data 10/10/2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Monta a getdados dos itens do atendimento para o Historico  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ExpC1 - Alias, ExpC2 - Codigo da Ligacao, ExpC3 - Rotina    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³CALL CENTER  									   	          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                     
Static Function TkMontaItens(cAlias,cCodLig,cTipo,nIndice)

Local lSaveInc	:= .F.		//Copia do INCLUI
Local cSeek		:= ""		//Expressao Seek para posicionar na tabela
Local cWhile		:= ""		//Enquanto for igual a cSeek
Local bCond		:= {|| .T. }

Default nIndice := 1

aHeader	:= {}
aCols	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz uma copia do INCLUI para depois restaura-la                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lSaveInc:= INCLUI

Do Case
	Case (cAlias == "SUB")
		cWhile	:= "SUB->UB_FILIAL + SUB->UB_NUM"
		INCLUI  := .F.

	Case (cAlias == "SUD")
		cWhile	:= 	"SUD->UD_FILIAL + SUD->UD_CODIGO"
		INCLUI  := .F.

	Case (cAlias == "ACG")
		cWhile	:= "ACG->ACG_FILIAL + ACG->ACG_CODIGO"
		INCLUI  := .F.
	
	Case cAlias == "ACC"
		cWhile	:= "ACC->ACC_FILIAL + ACC->ACC_CODOBJ"

	Case cAlias == "SU6"
		cWhile	:= "SU6->U6_FILIAL + SU6->U6_LISTA"	

	Case cAlias == "SU8"
		cWhile	:= "SU8->U8_FILIAL + SU8->U8_CRONUM"

	Case cAlias == "AB2"
		cWhile	:= "AB2->AB2_FILIAL + AB2->AB2_NRCHAM"
		
	Case cAlias == "AB7"
		cWhile	:= "AB7->AB7_FILIAL + AB7->AB7_NUMOS"
		
	Case cAlias == "SC6"
		cWhile	:= "SC6->C6_FILIAL + SC6->C6_NUM" 

	Case cAlias == "SL2"
		cWhile	:= "SL2->L2_FILIAL + SL2->L2_NUM"

	Case cAlias == "SD1"
		cWhile	:= "SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA"
	
	Case cAlias == "MEJ"
		cWhile	:= "MEJ->MEJ_FILIAL + MEJ->MEJ_CODREG"
		
	Case cAlias == "MBP"
		cWhile	:= "MBP->MBP_FILIAL + MBP->MBP_NUMCAR"		
		bCond	:= {|| If( MBP->MBP_DTVAL >= dDatabase , .T. , .F. ) }
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa FillGetDados para preencher o aHeader e aCols ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSeek  := xFilial(cAlias) + cCodLig
If Empty(cCodLig)
	
	FillGetDados(	2				,cAlias		,nIndice							,/*cSeek	  */,;
					/*{|| &cWhile}*/,{|| .T. }	,/*aNoFields*/				,/*aYesFields*/	,; 
					/*lOnlyYes*/	,/*cQuery*/	,{|| TkaColsVazio(cAlias) }	,.F.			) 
	
Else

	FillGetDados(	2				,cAlias			,nIndice							,cSeek			,;
	  				{|| &cWhile }	,bCond		,/*aNoFields*/				,/*aYesFields*/	,; 
					/*lOnlyYes*/	,/*cQuery*/		,/*bMontCols*/				,/*lEmpty*/		,;
					/*aHeaderAux*/	,/*aColsAux*/	,{|| TkxAlteraCols(cTipo) }	,/*bBeforeCols*/	)

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura o valor original do INCLUI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
INCLUI:= lSaveInc

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TkxAlteraCols  ºAutor ³Vendas Clientes º Data ³  16/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera os campos virtuais do aCols                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FillGetDados                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³cTipo: Tipo (M=Telemarketing;V=Televendas;C=Telecobranca)   º±±
±±º          ³															  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TkxAlteraCols( cTipo )
Local nPAssunto := 0	//Posicao do campo no aHeader
Local nPDescAss := 0	//Posicao do campo no aHeader
Local nPProd 	:= 0	//Posicao do campo no aHeader
Local nPDescPro := 0	//Posicao do campo no aHeader
Local nPOcorren	:= 0	//Posicao do campo no aHeader
Local nPDescOco	:= 0	//Posicao do campo no aHeader
Local nPAcao   	:= 0	//Posicao do campo no aHeader
Local nPDescAca	:= 0	//Posicao do campo no aHeader
Local nPCodOpe 	:= 0	//Posicao do campo no aHeader
Local nPDescOpe	:= 0	//Posicao do campo no aHeader
Local nPDescCom := 0	//Posicao do campo no aHeader
Local nUB_DESCRI:= 0  	//Posicao do campo UB_DESCRI 
Local aUser		:= {}	//Array de usuarios

If cTipo == "M" // TeleMarketing
	nPAssunto := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_ASSUNTO"} )
	nPDescAss := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_DESCASS"} )
	nPProd    := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_PRODUTO"} )
	nPDescPro := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_DESCPRO"} )
	nPOcorren := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_OCORREN"} )
   	nPDescOco := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_DESCOCO"} )
	nPCodOpe  := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_OPERADO"} )
	nPDescOpe := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_DESCOPE"} )
	nPAcao    := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_SOLUCAO"} )
	nPDescAca := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_DESCSOL"} )
	nPDescCom := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UD_OBSEXEC"} )

ElseIf cTipo == "V" // Televendas
	nPProd 	  := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UB_PRODUTO"} )
	nPDescPro := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UB_DESCRI"} )
	nUB_DESCRI:= SUB->(FieldPos("UB_DESCRI"))
	
ElseIf cTipo == "C" // Telecobranca
	nPTipo 	 := Ascan(aHeader, {|x| AllTrim( x[2] ) == "ACG_TIPO"} )
	nPDescTp := Ascan(aHeader, {|x| AllTrim( x[2] ) == "ACG_DESCTP"} )
	nPNature := Ascan(aHeader, {|x| AllTrim( x[2] ) == "ACG_NATURE"} )
	nPDescNt := Ascan(aHeader, {|x| AllTrim( x[2] ) == "ACG_DESCNT"} )
	nPOperad := Ascan(aHeader, {|x| AllTrim( x[2] ) == "ACG_OPERAD"} )
	nPDescOp := Ascan(aHeader, {|x| AllTrim( x[2] ) == "ACG_DESCOP"} )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega as descricoes para os campos virtuais.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cTipo == "M") //Telemarketing
	aCols[Len(aCols)][nPDescAss]:= Posicione("SX5",1,xFilial("SX5") + "T1" + aCols[Len(aCols)][nPAssunto],"X5DESCRI()")
	aCols[Len(aCols)][nPDescPro]:= Posicione("SB1",1,xFilial("SB1") + aCols[Len(aCols)][nPProd],"B1_DESC")
	aCols[Len(aCols)][nPDescOco]:= Posicione("SU9",1,xFilial("SU9") + aCols[Len(aCols)][nPAssunto] + aCols[Len(aCols)][nPOcorren],"U9_DESC")
	aCols[Len(aCols)][nPDescAca]:= Posicione("SUQ",1,xFilial("SUQ") + aCols[Len(aCols)][nPAcao],"UQ_DESC")
	aCols[Len(aCols)][nPDescCom]:= MSMM(SUD->UD_CODEXEC,60)
	PswOrder(1)	// Operador
	If PswSeek( aCols[Len(aCols)][nPCodOpe] )
		aUser:= PswRet(1)
		aCols[Len(aCols)][nPDescOpe]:= aUser[1][2]
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega as descricoes para os campos virtuais.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cTipo == "V") //Televendas
	If nUB_DESCRI == 0 
		aCols[Len(aCols)][nPDescPro]:= Posicione("SB1",1,xFilial("SB1") + aCols[Len(aCols)][nPProd],"B1_DESC")
	EndIf	
EndIf

If (cTipo == "C") //Telecobranca
	aCols[Len(aCols)][nPDescTp]:= Posicione("SB1",1,xFilial("SB1") + aCols[Len(aCols)][nPTipo],"B1_DESC")
	aCols[Len(aCols)][nPDescNt]:= Posicione("SED",1,xFilial("SED") + aCols[Len(aCols)][nPNature],"ED_DESCRIC")

	PswOrder(1)	// Operador
	If PswSeek( aCols[Len(aCols)][nPOperad] )
		aUser:= PswRet(1)
		aCols[Len(aCols)][nPDescOp]:= aCols[n][nPDescOp] := aUser[1][2]
	EndIf
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TkaColsVazio   ºAutor ³Vendas Clientes º Data ³  16/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera uma linha no aCols (vazia)                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FillGetDados                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³cAlias: Alias da tabela que aparecera no aCols			  º±±
±±º          ³															  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TkaColsVazio(cAlias)

Local nUsado:= 0	//Posicao do campo no aCols
Local nPos  := 0 	//Utilizado Somente para SUB pois na atualização a ordem e uso dos campos são mantidos e com isso o nUsado não faz sentido.
Local nLinha:= 0 	//Usada como indice em laco For...Next

aCols := Array(1, Len(aHeader) + 1)

For nLinha := 1 TO Len(aHeader)
	nUsado++

	If IsHeadRec(aHeader[nLinha,2]) 
		aCols[1,nUsado]:= 0	            
	ElseIf IsHeadAlias(aHeader[nLinha,2])
		aCols[1,nUsado]:= cAlias		
	ElseIf aHeader[nLinha][8] == "C"	//X3_TIPO
		aCols[1][nUsado] := SPACE(aHeader[nLinha][4]) //X3_TAMANHO

	ElseIf aHeader[nLinha][8] == "M"
		aCols[1][nUsado] := ""

	ElseIf aHeader[nLinha][8] == "L"
		aCols[1][nUsado] := .F.
	Else
		aCols[1][nUsado] := CriaVar(AllTrim(aHeader[nLinha][2]),.T.)  //X3_CAMPO
	Endif

Next nLinha

If cAlias == "SUB"
	nPos:= aScan(aHeader,{|x| Alltrim(x[2]) == "UB_ITEM"})
	If nPos > 0 
		aCols[1][nPos] := "01"
	Endif
Endif

aCols[1][Len(aHeader)+1] := .F.

Return .T.