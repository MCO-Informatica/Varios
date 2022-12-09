#INCLUDE "PROTHEUS.CH" 
#INCLUDE "MSGRAPHI.CH"
#INCLUDE "COLORS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ACDHCI03  ³ Autor ³ Luiz Enrique          ³ Data ³08/11/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³PROJETO Monitor de SEPARACOES                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³HCI                                                         ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ACDHCI03()
  						
Local   cCondicao  
Local   aIndices  	:= {}

Private 	aCores 	:= {{'SC5->C5_STASEP=="0"',	'BR_VERMELHO'	,"Não Iniciado"},;
						{'SC5->C5_STASEP=="1"', 'BR_AMARELO' 	,"Em Andamento"},;
						{'SC5->C5_STASEP=="2"', 'BR_VERDE' 		,"Separado"}}

Private aRotina  	:= {{"Pesquisa" ,"AxPesqui"	,0,1},{"Monitor"	,"U_HCI03Mon",0,2},	{"Legenda"	,"U_HCI03Leg(aCores)",0,2}}
Private cCadastro 	:= "MONITOR DA SEPARACAO "
Private cDelFunc  	:= ".T." 

dbSelectArea("SC5")
dbSetOrder(1)

CriaPerg()
SetKey(VK_F12,{|| Pergunte("PHCI02", .T.)})

While .T.
	If !Pergunte("PHCI02", .T.) 
	   Return
	Endif 	
	If Empty(MV_PAR03)
			CBAlert("Pedido Ate deve ser declarado.")
		    Loop 
	ElseIf Empty(MV_PAR04)
			CBAlert("Data Ate deve ser declarada.")
		    Loop 
	ElseIf MV_PAR02 < MV_PAR01
			CBAlert("Intervalo dos Pedidos Invalido.")
		    Loop  
	ElseIf MV_PAR04 < MV_PAR03
			CBAlert("Periodo declarado Invalido.")
		    Loop  
	Endif 
	Exit
Enddo

cCondicao := "SC5->C5_NUM >= MV_PAR01 .AND. SC5->C5_NUM <= MV_PAR02 "  
cCondicao += ".AND. SC5->C5_EMISSAO >= MV_PAR03 .AND. SC5->C5_EMISSAO <= MV_PAR04"
bFiltraBrw := {|| FilBrowse("SC5", @aIndices, @cCondicao)}
Eval( bFiltraBrw )
mBrowse( 6,1,22,75,"SC5",,,,,, aCores, , , ,{|x|TimerBrw(x)}) 
EndFilBrw("SC5",@aIndices)
	      	    
Return .t. 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³MONITOR()   ³ Autor ³ Luiz Enrique              ³ Data ³08/11/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ MONITOR DE SEPARACOES   		                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCI03Mon() 

Local oDlg       
Local aAdvSize		:= MsAdvSize( NIL , .f.) 
Local nSerie1:=0
Local oTimer

Local 	 aCorBlo	:= {{'0', 'BR_PRETO'	,"Bloqueio de Estoque"},;
						{'0', 'BR_CINZA' 	,"Bloqueio de Credito"},;
						{'0', 'BR_VERDE' 	,"Liberado"},;
						{'0', 'BR_BRANCO' 	,"Sem Processo"}}
						
Local	aCorSep		:= {{'0', 'BR_VERMELHO'	,"Não Iniciado"},;
						{'0', 'BR_AMARELO' 	,"Em Andamento"},;
						{'0', 'BR_VERDE' 	,"Separado"},;
						{'0', 'BR_AZUL' 	,"Faturado"}}	  

//LISTA DOS ITENS DOS PEDIDOS
Private oPasta
Private oLbx
Private oLbx1
Private aLbx:={} 
Private oGraf1

DEFINE FONT oFont NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg TITLE "MONITOR DA SEPARACAO - HCI" FROM aAdvSize[7],0 To aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL 

	oPasta				:= TFolder():New(000,000,{"Informações Sobre a Separação do Pedido: " + SC5->C5_NUM},{},oDlg,,,,.T.,.F.,392,244,)
	oPasta:align 		:= CONTROL_ALIGN_ALLCLIENT  
	oPasta:bSetOption 	:= {|nAtu| MudaPasta(oTimer,@nSerie1,nAtu)}
	
	EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
		
   //PASTA 1	-  LISTA ITENS DO PEDIDOS
	@ 28,10 LISTBOX oLbx FIELDS HEADER " ","Sequencia","Produto","Qtde. Original","Qtde. Separada","Qtde. A Separar","Faturado","" SIZES {10,10,15,20,20,20,10,2} SIZE 490,095 OF oPasta:aDialogs[1] PIXEL		
	oLbx:align := CONTROL_ALIGN_TOP        
	oLbx:bChange := {|| Detalhes()}
	@ 25, 01 	BUTTON "?" SIZE 08,08 OF oDlg PIXEL ACTION U_HCI03Leg(aCorSep) 
	
	@ 135,10 LISTBOX oLbx1 FIELDS HEADER " ","Descricao","Armazem","Lote","Quantidade","Nota Fiscal","" SIZES {2,45,02,10,10,10,2} SIZE 490,070 OF oPasta:aDialogs[1] PIXEL	
	oLbx1:align := CONTROL_ALIGN_ALLCLIENT 	
	@ 120, 01 	BUTTON "?" SIZE 08,08 OF oDlg PIXEL ACTION U_HCI03Leg(aCorBlo)
		
	//PASTA 2 GAFICOS 
	//oGraf1:=Graph("Pedido: "+SC5->C5_NUM,{0,0,0,0},{"Produto","Separados","Nao Separados"},2,{5,0,250,120},,oPasta:aDialogs[2],@nSerie1)
	
   	DEFINE TIMER oTimer INTERVAL 3000 ACTION MudaPasta(oTimer,@nSerie1,oPasta:nOption) OF oDlg
	oTimer:Activate()
	MontaaLbx()
	 
ACTIVATE MSDIALOG oDlg CENTERED  

Return 

//Alternando Pastas           
Static Function MudaPasta(oTimer,nSerie1,nPasta)
oTimer:DeActivate()
MontaaLbx()
If nPasta == 1	
	Detalhes()
/*ElseIf nPasta == 2
    oGraf1:Refresh()
	Atugrafic(oGraf1,{aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],If (aLbx[oLbx:nAt,4]==aLbx[oLbx:nAt,7],0,(aLbx[oLbx:nAt,4]-aLbx[oLbx:nAt,5]))},{"Produto","Separados","Nao Separados"},,4,@nSerie1)	
	*/
EndIf 
oTimer:Activate()
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Detalhes  ºAutor  ³Luiz Enrique	     º Data ³  17/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Lista os detalhes dos Itens do Pediodo atraves do SC9       º±±                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MONITOR HCI                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Detalhes() 

Local aAux 	:= {LoadBitmap( GetResources(), "BR_PRETO"),LoadBitmap( GetResources(), "BR_CINZA"),LoadBitmap( GetResources(), "BR_VERDE"),LoadBitmap( GetResources(), "BR_BRANCO")}
Local aLbx1	:={}
Local cQuery:=""
Local cBloq	:=""

If Empty(aLbx)
	Return
Endif

cQuery 	:= "SELECT B1_DESC,C9_LOCAL,C9_LOTECTL,C9_QTDLIB,C9_NFISCAL + '-' + C9_SERIENF AS NF,C9_BLEST,C9_BLCRED " 
cQuery 	+= "   FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SC9") + " SC9 "  
cQuery 	+= "    WHERE B1_FILIAL = '"	+	xFilial("SB1")	+ "' " 
cQuery 	+= "      AND C9_FILIAL = '"	+	xFilial("SC9")	+ "' " 
cQuery 	+= "      AND B1_FILIAL = C9_FILIAL "
cQuery 	+= "      AND C9_PRODUTO = '" 	+ aLbx[oLbx:nAt,3] 	+ "' "
cQuery 	+= "      AND C9_PEDIDO = '"	+ SC5->C5_NUM 		+ "' " 
cQuery 	+= "      AND SB1.D_E_L_E_T_<>'*' 
cQuery 	+= "      AND SC9.D_E_L_E_T_<>'*' 
cQuery 	+= "      AND B1_COD = C9_PRODUTO "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.) 
         
While TMP->(!Eof())
			
	If !TMP->C9_BLEST $ "  |10"  
		cBloq:= "1"
	Elseif !TMP->C9_BLCRED $ "  |10"
		cBloq:= "2"
	Else
		cBloq:= "3"
	Endif										 
	TMP->(Aadd(aLbx1,{cBloq,B1_DESC,C9_LOCAL,C9_LOTECTL,C9_QTDLIB,NF,""}))
	TMP->(dbSkip())
EndDo

TMP->(dbclosearea())                                             
If Empty(aLbx1)  
	aLbx1:={{"4",Space(45),Space(02),Space(10),Space(10),Space(10),""}}
EndIf  

oLbx1:SetArray( aLbx1 ); oLbx1:bLine := {|| {aAux[val(aLbx1[oLbx1:nAt,1])],aLbx1[oLbx1:nAt,2],aLbx1[oLbx1:nAt,3],aLbx1[oLbx1:nAt,4],aLbx1[oLbx1:nAt,5],aLbx1[oLbx1:nAt,6],aLbx1[oLbx1:nAt,7]} }; oLbx1:Refresh()

Return 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³MontaaLbx   ³ Autor ³ Luiz Enrique              ³ Data ³08/11/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Mostra Status dos Itens do Pedido em questão                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                                         
Static Function MontaaLbx()

Local aAux 	:= {LoadBitmap( GetResources(), "BR_VERMELHO"),LoadBitmap( GetResources(), "BR_AMARELO"),LoadBitmap( GetResources(), "BR_VERDE"),LoadBitmap( GetResources(), "BR_AZUL")}
Local cStat := ""
aLbx		:= {}

SC6->(DbSetORder(1))//Filial+Pedido
SC6->(DbSeek(xFilial('SC6')+ SC5->C5_NUM)) 
                     
While SC6->(!Eof() .and. C6_FILIAL+C6_NUM == xFilial("SC5")+SC5->C5_NUM)    
    If SC6->C6_QTDEMP == 0 .And. SC6->C6_QTDENT == 0
		cStat:= "1"	// Nao Iniciado
	ElseIf SC6->C6_QTDEMP < SC6->C6_QTDVEN .And. SC6->C6_QTDEMP <> 0
		cStat:= "2" // Em Andamento
	ElseIf SC6->C6_QTDEMP == SC6->C6_QTDVEN .And. SC6->C6_QTDEMP <> 0
		cStat:= "3" // Ja Separado
	Elseif (SC6->C6_QTDVEN-SC6->C6_QTDENT)+SC6->C6_QTDEMP == 0 
		cStat:= "4"	//Faturado
	Endif										 
  	SC6->(Aadd(aLbx,{cStat,C6_ITEM,C6_PRODUTO,C6_QTDVEN,C6_QTDEMP,If (C6_QTDVEN==SC6->C6_QTDENT,0,(C6_QTDVEN-C6_QTDEMP)),SC6->C6_QTDENT,""}))
	SC6->(dbSkip())
EndDo 
        
If Empty(aLbx)                                    
	aLbx:={{"1",Space(10),Space(30),Space(20),Space(20),Space(20),Space(10),Space(2)}}
EndIf
oLbx:SetArray( aLbx ); oLbx:bLine := {|| {aAux[val(aLbx[oLbx:nAt,1])],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]} }; oLbx:Refresh()

Return                                      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³Graph       ³ Autor ³ Luiz Enrique              ³ Data ³08/11/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Mostra o Grafico com os Status da Separacao                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function Graph(cTitulo,aValores,aRotulo,nTipGraf,aPosSiz,aGcores,oDlg,nSerie)  
Local oGraphic
If aGcores == Nil
	aGcores := {CLR_BLUE,CLR_GREEN,CLR_CYAN,CLR_RED,CLR_MAGENTA,CLR_BLACK,CLR_BROWN,CLR_HGRAY,CLR_LIGHTGRAY,;
				CLR_GRAY,CLR_HBLUE,CLR_HGREEN,CLR_HCYAN,CLR_HRED,CLR_HMAGENTA,CLR_YELLOW,CLR_WHITE}
Endif 

@ aPosSiz[1],aPosSiz[2] MSGRAPHIC oGraphic SIZE aPosSiz[3],aPosSiz[4] OF oDlg PIXEL 
oGraphic:Align := CONTROL_ALIGN_ALLCLIENT
oGraphic:SetTitle( cTitulo , "", CLR_GREEN, A_LEFTJUST, GRP_TITLE)
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)  
oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:l3D :=.T. 

Return oGraphic 
                      
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³AtuGrafic   ³ Autor ³ Luiz Enrique              ³ Data ³08/11/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Atualiza o Grafico com os Status da Separacao na troca de Pastas ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function AtuGrafic(oGraphic,aValores,aRotulo,aGcores,nTipGraf,nSerie)
Local nX
If aGcores == Nil
	aGcores := {	CLR_BLUE,CLR_GREEN,CLR_CYAN,CLR_RED,CLR_MAGENTA,CLR_BLACK,CLR_BROWN,CLR_HGRAY,CLR_LIGHTGRAY,;
					CLR_GRAY,CLR_HBLUE,CLR_HGREEN,CLR_HCYAN,CLR_HRED,CLR_HMAGENTA,CLR_YELLOW,CLR_WHITE}
Endif 

oGraphic:DelSerie(nSerie)
oGraphic:Refresh()
nSerie  := oGraphic:CreateSerie(nTipGraf)
For nX:= 1 to len (aValores)
	oGraphic:Add(nSerie,aValores[nX],aRotulo[nX],aGcores[nX])
Next
Return .t. 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ENCW08    ºAutor  ³Fabrica de Software º Data ³  10/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Chamada para a funcao do timer do browser                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TimerBrw(oMBrowse)
Local oTimer
DEFINE TIMER oTimer INTERVAL 3000 ACTION TmBrowse(GetObjBrow(),oTimer) OF oMBrowse
oTimer:Activate()
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ENCW08    ºAutor  ³Fabrica de Software º Data ³  10/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao do timer                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TmBrowse(oObjBrow,oTimer)
oTimer:Deactivate()
oObjBrow:Refresh()
oTimer:Activate()
Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³HCI03Leg    ³ Autor ³ Luiz Enrique              ³ Data ³08/11/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Legenda principal dos Status da Separacao por Pedido 			 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
User Function HCI03Leg(aCores) 

Local aLegenda:= {}
Local i       := 0
For i:= 1 To Len(aCores)
	Aadd(aLegenda,{aCores[i,2],aCores[i,3]})
Next i
BrwLegenda("Monitor de Separacao","Legenda",aLegenda) 
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CriaPerg ³ Autor ³ Luiz Enrique          ³ Data ³ 23/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica grupo de perguntas no SX1 e cria se necessario    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HCI                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */ 
Static Function CriaPerg()

PutSx1("PHCI02","01","Pedido de","Pedido de","Pedido de"	,"mv_ch1","C",06,0,1,"G",,"SC5","","","MV_PAR01","","","","","","","","","","","","","","","","","","","","")
PutSx1("PHCI02","02","Pedido Ate","Pedido Ate","Pedido Ate"	,"mv_ch2","C",06,0,1,"G",,"SC5","","","MV_PAR02","","","","","","","","","","","","","","","","","","","","")
PutSx1("PHCI02","03","Data de","Data de","Data de"			,"mv_ch3","D",08,0,1,"G",,"","","","MV_PAR03","","","","","","","","","","","","","","","","","",)
PutSx1("PHCI02","04","Data Ate","Data Ate","Data Ate"		,"mv_ch4","D",08,0,1,"G",,"","","","MV_PAR03","","","","","","","","","","","","","","","","","",)

Return  