#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT094VCC ºAutor  ³Sérgio Santana      º Data ³  22/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de Entrada para visualizar a cotações referente ao  º±±
±±º          ³  pedido de compra, posicionado no browse                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Glasstech                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MT094VCC()

PRIVATE aRotina	:= {{OemToAnsi("Pesquisar"),"Ma097Pesq",   0 , 1, 0, .F.},; //
					{OemToAnsi("Consulta pedido"),"A097Visual",  0 , 2, 0, nil},;
					{OemToAnsi("Consulta Saldos"),"A097Consulta",0 , 2, 0, nil},; 
					{OemToAnsi("Liberar"),"A097Libera",  0 , 4, 0, nil},;
					{OemToAnsi("Estornar"),"A097Estorna", 0 , 4, 0, nil},; 
					{OemToAnsi("Superior"),"A097Superi",  0 , 4, 0, nil},;
					{OemToAnsi("Transf. para Superior"),"A097Transf",  0 , 4, 0, nil},; 
					{OemToAnsi("Ausencia Temporaria"),"A097Ausente", 0 , 3, 0, nil},;
					{OemToAnsi("Legenda"),"A097Legend",  0 , 2, 0, .F.}}  
	
If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE" .Or. SCR->CR_TIPO == "IP"

   _aArea := SCR->( GetArea() )

   dbSelectArea("SC7")
   dbSetOrder(1)

   If MsSeek( xFilial("SC7") + Substr( SCR->CR_NUM, 1, Len( SC7->C7_NUM ) ) )

      _cCotacao := SC7->C7_NUMCOT
      SC8->( dbSeek( xFilial( 'SC8' ) + SC7->C7_NUMCOT, .T. ) )
      
      If _cCotacao = SC8->C8_NUM
      
         A161MapCt()
      
      End

   End
   
   RestArea( _aArea )
   Pergunte("MTA094",.F.)

End
	
Return( NIL )



Static Function A161MapCt()

Local oDlg 

Local aItens		:= {}
Local aPropostas	:= {}
Local aItensC		:= {"Pedido de Compra","Contrato"}

Local cTpDoc 		:= If(Val(SC8->C8_TPDOC)== 1,"Pedido de Compra","Contrato")

Local nTpDoc		

Local oSize		:= FWDefSize():New(.T.)
Local lOk			:= .F.
Local lContinua	:= .T.
Local aGrpComp	:= {}
Local lRestCom	:= .F.

PRIVATE cCadastro := "Análise de Cotação"

Pergunte("MTA161",.F.)

//aCoors := FWGetDialogSize(oMainWnd)

//Valida se usuario tem permissão para fazer a analise
If lRestcom .And. !Empty(SC8->C8_GRUPCOM) .And. !VldAnCot(__cUserId,SC8->C8_GRUPCOM)
	Aviso("Acesso Restrito","O  acesso  e  a utilizacao desta rotina e destinada apenas aos usuarios pertencentes ao grupo de compras : "+SC8->C8_GRUPCOM+". com direito de analise de cotacao. ",{"Voltar"},2)
	lContinua := .F.
EndIf

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Iniciar lancamento do PCO                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000051")
	PcoIniLan("000052")

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL
	
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||Iif(VALIDAOK(aPropostas),(lOk := .T.,aItens:=aClone(aItens) ,aPropostas:=aClone(aPropostas),oDlg:End()),.T.)},{||lOk:= .F., oDlg:End()}),ConstLayer(oDlg, @aItens, @aPropostas,@aItensC,@cTpDoc))
	If lOk
		nTpDoc := aScan(aItensC,{|x| x == cTpDoc})
		A161GerDoc(aItens,aPropostas,nTpDoc) //Efetua a geração do pedido de compra ou contrato
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza processo de lancamento do PCO                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoFinLan("000051")
	PcoFinLan("000052")
	PcoFreeBlq("000051")
	PcoFreeBlq("000052")
	
Endif

SetKey( VK_F4,{||NIL} )
SetKey( VK_F5,{||NIL} )
SetKey( VK_F6,{||NIL} )
SetKey( VK_F7,{||NIL} )

Return Nil

Static Function ConstLayer(oDlg, aItens, aPropostas,aItensC,cTpDoc)

Local oFWLayer
Local oPanel0
Local oPanel1
Local oPanel2
Local oPanel3
Local oBrowse1
Local oBrowse2
Local oBrowse3
Local oVlrFinal

Local aCoors		:= {}

Local dDataVld 	:= SC8->C8_VALIDA
Local cCotacao 	:= SC8->C8_NUM

Local cFor1		:= ''
Local cFor2		:= ''
Local cCondPag1	:= SC8->C8_COND
Local cCondPag2	:= Space(30)
Local cTpFrete1	:= Space(30)
Local cTpFrete2	:= Space(30)

Local nVlrFinal		:= 0
Local nPag			:= 1
Local nNumPag		:= 0
Local nProp1		:= 0
Local nProp2		:= 0
Local nVlTot1		:= 0
Local nVlTot2		:= 0
Local nI			:= 0
Local nOpcA			:= 0

Local nPercent1
Local nPercent2
Local nAltura

Local lSugere		:= MV_PAR03==1

Setkey( VK_F4,{||A161HisPro(aItens[oBrowse1:At()][1])})
Setkey( VK_F5,{||A161MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(nPag > 1,--nPag,1), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)})
Setkey( VK_F6,{||A161MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(Len(aPropostas) <= nPag,nPag,++nPag), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)})
SetKey( VK_F7,{||A161HisForn(aPropostas[nPag][1][1][1],aPropostas[nPag][1][1][2])})
SetKey( VK_F8,{||A161HisForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])})

A161Prop(cCotacao, @aItens, @aPropostas ) //Efetua a montagem do array para ser usado na interface do Mapa de Cotação

nNumPag := Len(aPropostas)

oPanel0:= tPanel():New(0,0,,oDlg,,,,,,0,0)
oPanel0:Align := CONTROL_ALIGN_ALLCLIENT

// Cria instancia do fwlayer
oFWLayer := FWLayer():New()

// Inicializa componente passa a Dialog criada,o segundo parametro é para 
// criação de um botao de fechar utilizado para Dlg sem cabeçalho 		  
oFWLayer:Init(oPanel0,.F./*,.T.*/)

oPanel0:ReadClientCoors(.T.,.T.)
nAltura := oPanel0:nHeight

nPercent1 := (210 * 100) / nAltura
nPercent2 := 100 - nPercent1 

// Efetua a montagem das linhas das telas

oFWLayer:addLine("LINHA1",nPercent1,.T.)
oFWLayer:addLine("LINHA2",nPercent2,.F.)

// Efetua a montagem das colunas das telas
oFWLayer:AddCollumn("BOX1",34,.T.,"LINHA1")
oFWLayer:AddCollumn("BOX2",33,.T.,"LINHA1")
oFWLayer:AddCollumn("BOX3",33,.T.,"LINHA1")

oFWLayer:AddCollumn("BOX4",34,.T.,"LINHA2")
oFWLayer:AddCollumn("BOX5",33,.T.,"LINHA2")
oFWLayer:AddCollumn("BOX6",33,.T.,"LINHA2")

// Cria a window passando, nome da coluna onde sera criada, nome da window			 	
// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,	
// se é redimensionada em caso de minimizar outras janelas e a ação no click do split 
oFWLayer:AddWindow("BOX1","oPanel1","Dados da Cotação"  ,100,.F.,.T.,,"LINHA1",{ || })
oFWLayer:AddWindow("BOX2","oPanel2","Dados da Proposta"	,100,.F.,.T.,,"LINHA1",{ || })
oFWLayer:AddWindow("BOX3","oPanel3","Dados da Proposta"	,100,.F.,.T.,,"LINHA1",{ || })

oFWLayer:AddWindow("BOX4","oPanel4","Produtos"			,100,.F.,.T.,,"LINHA2",{ || })
oFWLayer:AddWindow("BOX5","oPanel5","Item da Proposta"	,100,.F.,.T.,,"LINHA2",{ || })
oFWLayer:AddWindow("BOX6","oPanel6","Item da Proposta"	,100,.F.,.T.,,"LINHA2",{ || })

// Retorna o objeto do painel da Janela
oPanel1 := oFWLayer:GetWinPanel("BOX1","oPanel1","LINHA1")
oPanel2 := oFWLayer:GetWinPanel("BOX2","oPanel2","LINHA1")
oPanel3 := oFWLayer:GetWinPanel("BOX3","oPanel3","LINHA1")

oPanel4 := oFWLayer:GetWinPanel("BOX4","oPanel4","LINHA2")
oPanel5 := oFWLayer:GetWinPanel("BOX5","oPanel5","LINHA2")
oPanel6 := oFWLayer:GetWinPanel("BOX6","oPanel6","LINHA2")

// Dados da cotação
@ 7,2 SAY RetTitle("C8_NUM") OF oPanel1 PIXEL
@ 5,37 MSGET cCotacao SIZE 30,10 WHEN .F. OF oPanel1 PIXEL

@ 27,2 SAY RetTitle("C8_VALIDA") OF oPanel1 PIXEL
@ 25,37 MSGET dDataVld SIZE 50,10 WHEN .F. OF oPanel1 PIXEL

@ 47,2 SAY "Valor Final"  OF oPanel1 PIXEL
@ 45,37 MSGET oVlrFinal VAR nVlrFinal SIZE 50,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel1 PIXEL

@ 7,96 SAY RetTitle("C8_TPDOC") OF oPanel1 PIXEL
@ 5,120 MSCOMBOBOX cTpDoc ITEMS aItensC SIZE 68,14 WHEN aScan(aItens,{|x| x[9] == .F.  }) >0 OF oPanel1 PIXEL

@ 27,96 SAY 'Página' OF oPanel1 PIXEL
@ 25,120 MSGET nPag SIZE 20,10 VALID nPag > 0 .And. nPag <= nNumPag .And. ;
			A161MovPag(aPropostas, @oBrowse2, @oBrowse3, nPag, @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2,@oPanel3,oBrowse1);
				 OF oPanel1 PIXEL

@ 27,143 SAY '/' OF oPanel1 PIXEL
@ 25,148 MSGET nNumPag SIZE 20,10 WHEN .F. OF oPanel1 PIXEL

TButton():Create(oPanel1,63,2,'Histórico do Produto (F4)',{||A161HisPro(aItens[oBrowse1:At()][1])},85,13,,,,.T.,,'Histórico do Produto (F4)',,,,)
TButton():Create(oPanel1,45,120,'Página Anterior (F5)',{|| A161MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(nPag > 1,--nPag,1), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1 )},67,13,,,,.T.,,'Página Anterior (F5)',,,,)
TButton():Create(oPanel1,63,120,'Próxima Página (F6)',{|| A161MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(Len(aPropostas) <= nPag,nPag,++nPag), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)},67,13,,,,.T.,,'Próxima Página (F6)',,,,)

// Dados do PRIMEIRO fornecedor na tela
cFor1 		:= aPropostas[1][1][1][3]
nProp1		:= aPropostas[1][1][1][4]
cCondPag1	:= aPropostas[1][1][1][5]
cTpFrete1	:= A161DscFrt(aPropostas[1][1][1][6])
nVlTot1	:= aPropostas[1][1][1][7] 

@ 7,2 SAY 'Fornecedor' OF oPanel2 PIXEL
@ 5,35 MSGET cFor1 SIZE 153,10 WHEN .F. OF oPanel2 PIXEL

@ 27,2 SAY 'Proposta' OF oPanel2 PIXEL
@ 25,35 MSGET nProp1 SIZE 30,10 WHEN .F. OF oPanel2 PIXEL

@ 47,2 SAY 'Tp. Frete'	OF oPanel2 PIXEL
@ 45,35 MSGET cTpFrete1 SIZE 30,10 WHEN .F. OF oPanel2 PIXEL

@ 27,90 SAY 'Cond. Pagto' OF oPanel2 PIXEL
@ 25,125 MSGET cCondPag1 SIZE 63,10 WHEN .F. OF oPanel2 PIXEL


@ 47,90 SAY 'Vl. Total' OF oPanel2 PIXEL
@ 45,125 MSGET nVlTot1 SIZE 63,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel2 PIXEL

TButton():Create(oPanel2,63,35,'Histórico do Fornecedor (F7)',{||A161HisForn(aPropostas[nPag][1][1][1],aPropostas[nPag][1][1][2])},153,13,,,,.T.,,'Histórico do Fornecedor (F7)',,,,)

// Dados do SEGUNDO fornecedor na tela
If !Empty(aPropostas[1,2,1])
	cFor2 		:= aPropostas[1][2][1][3]
	nProp2		:= aPropostas[1][2][1][4]
	cCondPag2	:= aPropostas[1][2][1][5]
	cTpFrete2	:= A161DscFrt(aPropostas[1][2][1][6])
	nVlTot2	:= aPropostas[1][2][1][7]  
	SetKey(VK_F8,{||A161HisForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])})	
Else
	oPanel3:lVisible := .F.
	oPanel6:lVisible := .F.
	SetKey( VK_F8,{||NIL} )
EndIf

@ 7,2 SAY 'Fornecedor' OF oPanel3 PIXEL
@ 5,35 MSGET cFor2 SIZE 153,10 WHEN .F. OF oPanel3 PIXEL

@ 27,2 SAY 'Proposta' OF oPanel3 PIXEL
@ 25,35 MSGET nProp2 SIZE 30,10 WHEN	 .F. OF oPanel3 PIXEL

@ 47,2 SAY 'Tp. Frete'	OF oPanel3 PIXEL
@ 45,35 MSGET cTpFrete2 SIZE 30,10 WHEN .F. OF oPanel3 PIXEL

@ 27,90 SAY 'Cond. Pagto' OF oPanel3 PIXEL
@ 25,125 MSGET cCondPag2 SIZE 63,10 WHEN .F. OF oPanel3 PIXEL

@ 47,90 SAY 'Vl. Total' OF oPanel3 PIXEL
@ 45,125 MSGET nVlTot2 SIZE 63,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel3 PIXEL

TButton():Create(oPanel3,63,35,'Histórico do Fornecedor (F8)',{||A161HisForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])},153,13,,,,.T.,,'Histórico do Fornecedor (F8)',,,,)

// Carga de dados dos produtos
DEFINE FWBROWSE oBrowse1 DATA ARRAY ARRAY aItens NO CONFIG  NO REPORT NO LOCATE OF oPanel4

ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),1] } TITLE "Cod. Produto" HEADERCLICK { || .T. } OF oBrowse1
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),8] } TITLE "Descrição" 	HEADERCLICK { || .T. }	OF oBrowse1
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),3] } TITLE "Quantidade" PICTURE PesqPict("SC8","C8_QUANT") HEADERCLICK { || .T. } OF oBrowse1
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),4] } TITLE "UM" HEADERCLICK { || .T. } OF oBrowse1
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),5] } TITLE "Necessidade" HEADERCLICK { || .T. } OF oBrowse1
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),6] } TITLE "Entrega" HEADERCLICK { || .T. } OF oBrowse1
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),7] } TITLE "Valor Final" PICTURE PesqPict("SC8","C8_TOTAL") HEADERCLICK { || .T. } OF oBrowse1

oBrowse1:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| A161OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
oBrowse1:SetLineHeight(25)

ACTIVATE FWBROWSE oBrowse1

// Carga de dados da primeira proposta na tela
DEFINE FWBROWSE oBrowse2 DATA ARRAY ARRAY aPropostas[nPag,1,2] NO CONFIG  NO REPORT NO LOCATE OF oPanel5
oBrowse2:AddMarkColumns( { || IIf( aPropostas[nPag,1,2,oBrowse2:At(),1], "AVGLBPAR1","" ) },,,) //;
						    /*{ || A161DesMark(nPag,1,oBrowse2:At(),@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3,.F.),;
						    								nVlrFinal:= A161CalTot(aItens),oVlrFinal:Refresh()},;
						    /*{ || A161MarkAll(nPag,1,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
						    								nVlrFinal:= A161CalTot(aItens),oVlrFinal:Refresh()})*/
						    
ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,1,2,oBrowse2:At(),2]),Transform(aPropostas[nPag,1,2,oBrowse2:At(),4], PesqPict("SC8","C8_TOTAL")),'') } TITLE 'Valor Total' SIZE 20 HEADERCLICK { || .T. } OF oBrowse2
ADD COLUMN oColumn DATA { || aPropostas[nPag,1,2,oBrowse2:At(),5] } PICTURE PesqPict("SC8","C8_DATPRF") Type 'D' TITLE 'Entrega' SIZE 20 HEADERCLICK { || .T. } OF oBrowse2
ADD COLUMN oColumn DATA {||'Memo'} PICTURE '@!' TITLE RetTitle("C8_OBS") SIZE 20 HEADERCLICK { || .T. } DOUBLECLICK {|| ShowBMemo(@aPropostas[nPag,1,2,oBrowse2:At(),6])}   OF oBrowse2

oBrowse2:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| A161OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
oBrowse2:SetLineHeight(25)
ACTIVATE FWBROWSE oBrowse2

// Carga de dados da segunda proposta na tela
DEFINE FWBROWSE oBrowse3 DATA ARRAY ARRAY aPropostas[nPag,2,2] NO CONFIG  NO REPORT NO LOCATE OF oPanel6
	oBrowse3:AddMarkColumns(	{ || IIf( !Empty(aPropostas[nPag,2,2]) .And. aPropostas[nPag,2,2,oBrowse3:At(),1], 'AVGLBPAR1','' ) },,,) //;
							   	/*{ || A161DesMark(nPag,2,oBrowse3:At(),@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3,.F.),;
							   								nVlrFinal:= A161CalTot(aItens), oVlrFinal:Refresh()},;
								/*{ || A161MarkAll(nPag,2,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
															nVlrFinal:= A161CalTot(aItens), oVlrFinal:Refresh()})*/
														
ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,2,2]) .And. !Empty(aPropostas[nPag,2,2,oBrowse3:At(),2]),Transform(aPropostas[nPag,2,2,oBrowse3:At(),4], PesqPict("SC8","C8_TOTAL")),'') } TITLE 'Valor Total' SIZE 20 HEADERCLICK { || .T. } OF oBrowse3
ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,2,2]),aPropostas[nPag,2,2,oBrowse3:At(),5],'') } PICTURE PesqPict("SC8","C8_DATPRF") TITLE 'Entrega' SIZE 20 HEADERCLICK { || .T. } OF oBrowse3
ADD COLUMN oColumn DATA {||'Memo'} PICTURE '@!' TITLE RetTitle("C8_OBS") SIZE 20 HEADERCLICK { || .T. } DOUBLECLICK {|| ShowBMemo(@aPropostas[nPag,2,2,oBrowse3:At(),6])}   OF oBrowse3

oBrowse3:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| A161OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
oBrowse3:SetLineHeight(25)

ACTIVATE FWBROWSE oBrowse3

// -----------------------------------------------------------------------
// Sugestão do Vencedor
// -----------------------------------------------------------------------
If lSugere
	If MV_PAR05 == 0 .And. MV_PAR06 == 0 .And. MV_PAR07 == 0 
		Help("",1,"A161CotVen",,'Cotação Vencedora',4,1)	
	Else
		A161CotVen(aItens,aPropostas,oBrowse1,oBrowse2,oBrowse3)
	EndIf
EndIf

nVlrFinal:= A161CalTot(aItens)

oPanel1:Refresh()
oVlrFinal:Refresh() // Atualiza o campo Valor Final.

Return

//-------------------------------------------------------------------
/*{Protheus.doc} A161Prop
Efetua montagem do array de tens para a grid fixa e o array para as propostas.

@author José Eulálio
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function A161Prop(cNum, aItens, aPropostas )
Local nPag 		:= 1
Local nProp 		:= 1
Local nX 			:= 0
Local nPg 			:= 0
Local nNumPro 	:= 0
Local nY 			:= 1
Local nPosRef1 	:= 0
Local nPosRef2 	:= 0
Local nCusto 		:= ''
Local nPosRef 	:= 0
Local nPa 			:= 0
Local nPo 			:= 0

Local cPgto		:= ''
Local cQuery		:= ''
Local cCodRef 	:= ''
Local cMsg 		:= ''
Local cAtuPos 	:= ''

Local lWin 		:= .F.
Local lFim 		:= .F.
Local lGrdOk 		:= .F.

Local aRefImpos 	:= {}

Local nP     := 0
Local nR     := 0
Local nI     := 0
Local nDif   := 0
Local nPosId := 0

//Query que retorna quantidade de propostas
BeginSQL Alias "SC8PRO"			
	SELECT C8_FORNECE,C8_LOJA,C8_NUMPRO
	FROM %Table:SC8%
	WHERE %NotDel% AND
		C8_FILIAL = %xFilial:SC8% AND
		C8_NUM = %Exp:cNum%
	GROUP BY C8_FORNECE,C8_LOJA,C8_NUMPRO		
EndSQL
Do While SC8PRO->(!EOF())
	nNumPro += 1
	SC8PRO->(dbSkip())
EndDo
SC8PRO->(dbCloseArea())

//Query que organiza as cotações para o Array
cQuery := "SELECT C8_PRODUTO, "
cQuery += "R_E_C_N_O_ SC8REC, "
cQuery += "C8_IDENT, "
cQuery += "C8_ITEMGRD, "
cQuery += "C8_NUMPRO, "
cQuery += "C8_QUANT, "
cQuery += "C8_UM, "
cQuery += "C8_DATPRF, "
cQuery += "C8_FILENT, "
cQuery += "C8_NUMPED, "
cQuery += "C8_NUMCON, "
cQuery += "C8_FORNECE, "
cQuery += "C8_LOJA, "
cQuery += "C8_ITEM, "
cQuery += "C8_NUM, "
cQuery += "C8_COND, "
cQuery += "C8_FORNOME, "
cQuery += "C8_TPFRETE, "
cQuery += "C8_PRAZO, "
cQuery += "C8_ITEMSC "
cQuery += "FROM " + RetSQLName("SC8") + " "
cQuery += "WHERE D_E_L_E_T_ = ' ' AND "
cQuery += "C8_FILIAL = '" + xFilial("SC8") + "' AND "
cQuery += "C8_NUM = '" + cNum + "' "
cQuery += "ORDER BY C8_PRODUTO, C8_NUMPRO, C8_FORNECE, C8_LOJA"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SC8MAPA",.F.,.T.)

//Quantidade de páginas
nPg := Int(nNumPro / 2)
If Mod(nNumPro,2) > 0
	nPg++
EndIf

//Array para a Referência do Imposto
SX3->(dbSetOrder(1))
SX3->(dbSeek("SC8"))
While ( !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SC8" )
	nPosRef1 := At("MAFISREF(",Upper(SX3->X3_VALID))
	
	If ( nPosRef1 > 0 )
		
		nPosRef1 += 10
		nPosRef2 := At(",", SubStr(SX3->X3_VALID, nPosRef1)) - 2

		AAdd(aRefImpos,{"SC8", SX3->X3_CAMPO, SubStr(SX3->X3_VALID, nPosRef1, nPosRef2)})
		
	EndIf
	
	SX3->(dbSkip())
	
EndDo

/*------- Estrutura do Array de aItens --------*/

//aItens[n,x]: Numero do item
//aItens[n,1]: C8_PRODUTO
//aItens[n,2]: C8_IDENT
//aItens[n,3]: C8_QUANT
//aItens[n,4]: C8_ UM
//aItens[n,5]: C8_ DATPRF
//aItens[n,6]: C8_ FILENT
//aItens[n,7]: valor do produto por proposta escolhida
//aItens[n,8]: Descrição do Produto
//aItens[n,9]: Flag finalizado
//aItens[n,10]: Fornecedor
//aItens[n,11]: Loja
//aItens[n,12]: Item
//aItens[n,13]: Numero da proposta
//aItens[n,14]: Item da solicitacao

/*------- Estrutura do Array de aPropostas --------*/

//CABEÇALHO//
//aPropostas[n]			: número da página
//aPropostas[n,p]			: posição do pedido na página (1,2)
//aPropostas[n,p,1,x]	: Dados do cabeçalho da proposta 
//aPropostas[n,p,1,1 ]	: Cod Fornecedor 
//aPropostas[n,p,1,2 ]	: Loja 
//aPropostas[n,p,1,3 ]	: Nome 
//aPropostas[n,p,1,4 ]	: Proposta 
//aPropostas[n,p,1,5 ]	: Cond pagto 
//aPropostas[n,p,1,6 ]	: Frete 
//aPropostas[n,p,1,7 ]	: Valor total (soma de nCusto dos itens)
//ITENS DA PROPOSTA// 
//aPropostas[n,p,2,x]	: Itens da proposta 
//aPropostas[n,p,2,x,1]	: Flag vencendor 
//aPropostas[n,p,2,x,2]	: Item
//aPropostas[n,p,2,x,3]	: Cod produto
//aPropostas[n,p,2,x,4]	: Valor total (nCusto)
//aPropostas[n,p,2,x,5]	: Data de entrega 
//aPropostas[n,p,2,x,6]	: Observações
//aPropostas[n,p,2,x,7]	: Filial Entrega 
//aPropostas[n,p,2,x,8]	: Flag finalizado 
//aPropostas[n,p,2,x,9]	: Recno SC8 

/*------- -------------------------------------- --------*/
//Adiciona Array com quantidade de páginas, propostas e cabeçalho e itens de proposta pra cada
For nX := 1 To nPg	
	aAdd(aPropostas,{{{},{}},{{},{}}})
Next nX

nPag  := 1
nProp := 1

//Array de Itens na grid de Produtos
While SC8MAPA->(!EOF())
	
	//Inicia a posição do Array aPropostas
	nPag  := 1
	nProp := 1
	
	//Quebra do While de Propostas
	cQuebra := SC8MAPA->(C8_PRODUTO)
	
	While !SC8MAPA->(EOF()) .And. SC8MAPA->(C8_PRODUTO) == cQuebra
		
		SC8->(DbGoTo(SC8MAPA->SC8REC))
		
		cProduto := SC8MAPA->C8_PRODUTO
		
		If SC8->C8_GRADE == 'S'
			MatGrdPrRf(@cProduto, .T.)
			
			cDesc := MaGetDescGrd(cProduto) //Recupera nome do produto
				
		Else
			
			cDesc := Posicione("SB1", 1, xFilial("SB1")+cProduto, "B1_DESC")
			
		EndIf
		
		nPosPro := AScan(aItens, {|i| i[1] == SC8MAPA->C8_PRODUTO })
		
		If nPosPro == 0
			
			AAdd(aItens, {cProduto, SC8MAPA->C8_IDENT, SC8MAPA->C8_QUANT, SC8MAPA->C8_UM, SToD(SC8MAPA->C8_DATPRF), SC8MAPA->C8_FILENT, 0, cDesc, !Empty(SC8MAPA->C8_NUMPED), SC8MAPA->C8_FORNECE, SC8MAPA->C8_LOJA, SC8MAPA->C8_ITEM, SC8MAPA->C8_NUMPRO, SC8MAPA->C8_ITEMSC })
			
		Else
			
			If aItens[nPosPro][10] == SC8MAPA->C8_FORNECE .And. aItens[nPosPro][11] == SC8MAPA->C8_LOJA .And. aItens[nPosPro][13] == SC8MAPA->C8_NUMPRO
				
				AAdd(aItens, {cProduto, SC8MAPA->C8_IDENT, SC8MAPA->C8_QUANT, SC8MAPA->C8_UM, SToD(SC8MAPA->C8_DATPRF), SC8MAPA->C8_FILENT, 0, cDesc, !Empty(SC8MAPA->C8_NUMPED), SC8MAPA->C8_FORNECE, SC8MAPA->C8_LOJA, SC8MAPA->C8_ITEM, SC8MAPA->C8_NUMPRO, SC8MAPA->C8_ITEMSC })
				
			EndIf
			
		EndIf
		
		//Adiciona posição no Array na primeira passagem
		If Empty(SC8MAPA->C8_ITEMGRD) .Or. SC8MAPA->C8_ITEMGRD == StrZero(1, Len(SC8MAPA->C8_ITEMGRD))
			
			AAdd(aPropostas[nPag, nProp, 2], {})
			
		EndIf		
		
		//Tratamento para Preenche Array de aPropostas
		If SC8->(DbSeek(xFilial("SC8")+cNum+SC8MAPA->(C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD)))
			
			//Inicia o Valor
			lWin := .F.
			lFim := .F.
			
			//Verifica se tem numero de pedido e marca como vencedor
			If !Empty(SC8->C8_NUMPED) .Or. !Empty(SC8->C8_NUMCON)
				
				//Marca como Finalizado
				lFim := .T.
				
				//Marca como Vencedor/Perdedor				
				If SC8->C8_NUMPED # Replicate('X', Len(SC8->C8_NUMPED)) .Or.;
					(SC8->C8_NUMCON # Replicate('X', Len(SC8->C8_NUMCON)) .And. !Empty(SC8->C8_NUMCON))
					
					lWin := .T.
					
				Else
					
					lWin := .F.
										
				EndIf
				
			EndIf
			
			//Calcula o Custo para o valor total do produto
			MaFisIni(SC8->C8_FORNECE, SC8->C8_LOJA, "F", "N", "R")
			MaFisIniLoad(1)
			
			For nY := 1 To Len(aRefImpos)
				
				MaFisLoad(aRefImpos[nY, 3], SC8->(FieldGet(FieldPos(aRefImpos[nY, 2]))), 1)
				
			Next nY
			
			MaFisEndLoad(1)
			
			nCusto := Ma160Custo("SC8",1)
			
			MaFisEnd()
			
			// Tratamento para adicionar cabeçalho somente uma vez
			If Empty(aPropostas[nPag, nProp, 1])
				
				//Recupera condição de pagamento
				cPgto := Posicione("SE4", 1, xFilial("SE4")+SC8->C8_COND, "E4_DESCRI")
				
				//Preenche Array do Cabeçalho
				aPropostas[nPag, nProp, 1] := {SC8->C8_FORNECE, SC8->C8_LOJA, SC8->C8_FORNOME, SC8->C8_NUMPRO, cPgto, SC8->C8_TPFRETE, 0}
				
			EndIf
			
			//Tratamento para Itens de Grade
			If SC8->C8_GRADE == 'S'
				
				cCodRef := SC8->C8_PRODUTO
				cFrnRef := SC8->C8_FORNECE
				cLojRef := SC8->C8_LOJA
				
				lReferencia := MatGrdPrRf(@cCodRef, .T.)
				
				//Caso exista Item de Grade, apenas soma nCusto ao produto existente na Proposta				
				If !Empty(aPropostas[nPag, nProp, 2]) .And. !Empty(aPropostas[nPag, nProp, 2, 1]) .And. Type("aPropostas[nPag, nProp, 2, 3]") <> 'U' .And. (nPosRef := AScan(aPropostas[nPag, nProp, 2], {|x| x[3] == cCodRef} )) > 0
					
					aPropostas[nPag, nProp, 2, nPosRef, 4] += nCusto
					
					//Soma nCusto no Valor total do Cabeçalho
					aPropostas[nPag, nProp, 1, 7] += nCusto
					
				Else
					
					//Preenche Array dos Produtos de cada proposta
					aTail(aPropostas[nPag, nProp, 2]) := {lWin, SC8->C8_ITEM, cCodRef, nCusto, (DATE()+SC8->C8_PRAZO), SC8->C8_OBS, SC8->C8_FILENT, lFim, SC8->(Recno())}
					
					//Soma nCusto no Valor total do Cabeçalho
					aPropostas[nPag, nProp, 1, 7] += nCusto
					
				EndIf
				
			Else
				
				//Preenche Array dos Produtos de cada proposta						
				aTail(aPropostas[nPag, nProp, 2]) := {lWin, SC8->C8_ITEM, SC8->C8_PRODUTO, nCusto, (DATE()+SC8->C8_PRAZO), SC8->C8_OBS, SC8->C8_FILENT, lFim, SC8->(Recno())}
				
				//Soma nCusto no Valor total do Cabeçalho
				aPropostas[nPag, nProp, 1, 7] += nCusto
				
			EndIf
			
		ElseIf Empty(SC8MAPA->C8_ITEMGRD)
			
			//Preenche Vazio Array de aProspostas, caso não hava o produto para aquela proposta
			aTail(aPropostas[nPag, nProp, 2]) := {.F., '' , '', 0, CToD('//'), '', '', .F., 0}
			
		EndIf
		
		If lWin
			
			aItens[Len(aItens), 7] := aPropostas[nPag, nProp, 2, Len(aPropostas[nPag, nProp, 2]), 4]
			
		EndIf
		
		//Preenche variáveis para verificar se é uma proposta (fornecedor) diferente
		cAtuPos := SC8MAPA->(C8_FORNECE+C8_LOJA+C8_NUMPRO)
		
		//Skip para a próxima linha da busca
		SC8MAPA->(DbSkip())
		
		//Atualiza a posição do Array, caso não seja o mesmo item de Grade		
		If (SC8MAPA->(C8_FORNECE+C8_LOJA+C8_NUMPRO)) # cAtuPos
			
			If nProp == 1
				
				nProp := 2
				
			Else
				
				nPag++
				
				nProp := 1
				
			EndIf
			
		EndIf
		
	EndDo
		
EndDo

// Tratamento para incluir linhas em branco no array aProposta, pois podemos ter uma proposta com mais produtos do que a outra.
For nP := 1 To Len(aPropostas)
	
	For nR := 1 To Len(aPropostas[nP])
		
		If Len(aPropostas[nP][nR][2]) < Len(aItens)
			
			nDif := Len(aItens) - Len(aPropostas[nP][nR][2]) // Quantos itens faltam para igualar as linhas entre as propostas.
			
			For nI := 1 To nDif
				
				// Adiciona posicoes faltantes para igualar as propostas, caso necessario.
				AAdd(aPropostas[nP, nR, 2], {})
				
				aTail(aPropostas[nP, nR, 2]) := {.F., '' , '', 0, CToD('//'), '', '', .F., 0}
				
			Next nI
			
			For nI := 1 To Len(aPropostas[nP][nR][2])
				
				If aPropostas[nP, nR, 2, nI, 9] > 0
					
					// Aqui verifico qual a posicao correta do item com proposta no array de itens vazios (sem proposta).
					SC8->(DbGoTo(aPropostas[nP, nR, 2, nI, 9])) // Item com proposta.
					
					nPosId := AScan(aItens, {|i| i[2] == SC8->C8_IDENT})
					
					If nPosId # nI
						
						// Posiciona o item na ordem correta dentro do array de propostas.
						aPropostas[nP, nR, 2, nPosId] := aPropostas[nP, nR, 2, nI] 
						
						// Como o item estava na posição errada, limpo as colunas do array.
						aPropostas[nP, nR, 2, nI] := {.F., '' , '', 0, CToD('//'), '', '', .F., 0}
						
					EndIf
					
				EndIf
				
			Next nI
			
		EndIf
		
	Next nR
	
Next nP

SC8MAPA->(DbCloseArea())

Return NIL

//-------------------------------------------------------------------
/*{Protheus.doc} A161CalTot
Calcula valor total da analise da cotação

@author Leonardo Quintania
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function A161CalTot(aItens)
Local nX 		:= 1
Local nTotal	:= 0

For nX :=1 To Len(aItens)
	nTotal+= aItens[nX,7]

Next nX


Return nTotal
