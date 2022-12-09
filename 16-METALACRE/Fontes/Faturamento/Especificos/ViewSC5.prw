#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"


//??????????????????????????????????????//
//                        Low Intensity colors
//??????????????????????????????????????//


#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY  CLR_HGRAY



//??????????????????????????????????????//
//                       High Intensity Colors
//??????????????????????????????????????//


#define CLR_GRAY        8421504               // RGB( 128, 128, 128 )
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 )
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 )
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 )
#define CLR_HRED            255               // RGB( 255,   0,   0 )
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 )
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 )
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 )

#DEFINE EMIDOC		001
#DEFINE NUMDOC		002
#DEFINE CLIDOC		003
#DEFINE LOJDOC		004
#DEFINE NOMDOC		005
#DEFINE TIPDOC		006
#DEFINE CNDDOC		007
#DEFINE BRUDOC		008
#DEFINE REGDOC		009
                      
#DEFINE ITEITE		001
#DEFINE CODITE		002
#DEFINE DSCITE		003
#DEFINE UNDITE		004
#DEFINE QTDITE		005
#DEFINE UNTITE		006
#DEFINE TOTITE		007
#DEFINE TESITE		008
#DEFINE CFOITE		009
#DEFINE NOPITE		010
#DEFINE DENITE		011
#DEFINE PRCITE		012


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PedParc º Autora³ Luiz Alberto º Data ³ 09/09/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tratamento de Pedidos Parciais    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ gaveteiro                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                   
User Function ViewSC5()
Local aArea 	:= GetArea()
Local cPerg		:= PadR("ViewSC5",10)
Local cIdSuper  := GetNewPar("MV_ENTSC5","000000;000033;000194")

/*If !__cUserId $ cIdSuper
	MsgStop("Atenção Seu Usuário Não Permite Ajustes em Pedidos com OP Gerada !")
	Return .f.
Endif
  */

ValidPerg(cPerg)                     

If !Pergunte(cPerg,.t.)
	Return .t.
Endif

Processa({||U_SC5View()})

RestArea(aArea)
Return Nil

User Function SC5View()
Local nIt       := 0
Local aArea 	:= GetArea()
Local xCols   := {}
Local nLin    := 00
Local x       := 00
Local y       := 00

Local cGetOpc        := GD_UPDATE                                       // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "AllwaysTrue()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "AllwaysTrue()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := Nil                                             // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := "AllwaysTrue()"                                 // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := .F.                                             // Funcao executada para validar a exclusao de uma linha do aCols
Private xHeader := {}
Private aCabDoc	:= {}
Private aIteDoc   := {}
Private oSinal1   := LoadBitmap(GetResources(),"BR_VERDE")
Private oSinal2   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private oSinal3   := LoadBitmap(GetResources(),"BR_LARANJA")
Private oSinal4   := LoadBitmap(GetResources(),"BR_AZUL")
Private oSinal5   := LoadBitmap(GetResources(),"BR_ROSA")
Private oSinal6   := LoadBitmap(GetResources(),"BR_CINZA")
Private oSinal7   := LoadBitmap(GetResources(),"BR_AMARELO")
Private oSinal8   := LoadBitmap(GetResources(),"BR_BRANCO")
Private oSinal9   := LoadBitmap(GetResources(),"BR_VERDE")
Private aPosObj   := {}
aAdd(aPosObj,{130,005,245,600})  // Tamanho do Get

//             X3_TITULO       , X3_CAMPO    , X3_PICTURE      ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3 , X3_CONTEXT , X3_CBOX                        , X3_RELACAO ,X3_WHEN ,X3_VISUAL, X3_VLDUSER, X3_PICTVAR, X3_OBRIGAT
aAdd(xHeader,{"Item"           ,"C6_ITEM"    ,"@!"             ,           4,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Produto "       ,"C6_PRODUTO" ,"@!"             ,          15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Descricao "     ,"B1_DESC"    ,"@!"             ,          40,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Unid.Medida "   ,"D1_UM"      ,"@!"             ,           2,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Quantidade"     ,"C6_QTDVEN"   ,"@E 9,999,999.99",          12,          2, ""      , "€€€€€€€€€€€€€€", "N"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Unitario"       ,"C6_PRCVEN"   ,"@E 9,999,999.99",          12,          2, ""      , "€€€€€€€€€€€€€€", "N"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Total"          ,"C6_VALOR"   ,"@E 9,999,999.99",          12,          2, ""      , "€€€€€€€€€€€€€€", "N"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"TES "           ,"C6_TES"     ,"@!"             ,           3,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"CFOP"           ,"C6_CF"      ,"@!"             ,           4,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Num.OP"         ,"C6_NUMOP"      ,"@!"             ,          15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })

SX3->(dbSetOrder(2), dbSeek("C6_ENTREG"))

Aadd(xHeader,	{	Trim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,;
					SX3->X3_TAMANHO ,SX3->X3_DECIMAL,SX3->X3_VALID,;
					SX3->X3_USADO   ,SX3->X3_TIPO,	;
					SX3->X3_F3      ,SX3->X3_CONTEXT,SX3->X3_CBOX,,SX3->X3_WHEN,	;
					SX3->X3_VISUAL  ,SX3->X3_VLDUSER, SX3->X3_PICTVAR,SX3->X3_OBRIGAT	})

INCLUI := .F.
ALTERA := .T.

RegToMemory("SC5")

//aAdd(xHeader,{"Dt.Entrega"     ,"C6_ENTREG"  ,""               ,           8,          0, ""      , "€€€€€€€€€€€€€€", "D"    , ""    , "R"        , ""                             , ""         ,""      ,"A"      , ""               , ""        , ""        })

xHeader[11][13] := ''

cQuery := "  SELECT DISTINCT C5_EMISSAO, C5_NUM "
cQuery += " 		FROM " + RetSqlName("SC5") + " C5 (NOLOCK), " + RetSqlName("SC6") + " C6 (NOLOCK) "
cQuery += " 		WHERE C5.D_E_L_E_T_ = ''                     "
cQuery += " 		AND C5_FILIAL = '" + xFilial("SC5") + "' "
cQuery += " AND C6.C6_FILIAL = '" + xFilial("SC6") + "' "
cQuery += " AND C5.C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
cQuery += " AND C5.C5_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += " AND C6.C6_NUM = C5.C5_NUM "
cQuery += " AND C6.C6_DATFAT = '' "
If SU7->(dbSetOrder(4), dbSeek(xFilial("SU7")+__cUserID)) .And. __cUserId<>'000194'	// se o usuario logador for operador, então só permite pedidos sem OP
	cQuery += " AND C6.C6_NUMOP = '' "
Endif
cQuery += " AND C5.C5_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += " AND C5.C5_LOJACLI BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQuery += " ORDER BY C5_EMISSAO "

cQuery:=ChangeQuery(cQuery)
TCQuery cQuery Alias QRY4 New  

TcSetField('QRY4','C5_EMISSAO','D')
               
dbSelectArea("QRY4")
dbGoTop()

Count To nRegs

dbGoTop()

If Empty(nRegs)
	MsgStop("Não Localizados Registros Conforme Filtro Informado !")
	QRY4->(dbCloseArea())
	RestArea(aArea)
	Return Nil
Else
	ProcRegua(nRegs)
	While QRY4->(!Eof())
		IncProc("Aguarde Processando Notas...")
		
		SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+QRY4->C5_NUM))
		lFornece := .F.
		If !SC5->C5_TIPO $ 'B,D"
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Else
			SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			lFornece := .T.
		Endif
		
		AAdd(aCabDoc,{	DtoC(SC5->C5_EMISSAO),;
						SC5->C5_NUM,;
						SC5->C5_CLIENTE,;
						SC5->C5_LOJACLI,;     
						Iif(lFornece,SA2->A2_NOME,SA1->A1_NOME),;
						RetTipo(SC5->C5_TIPO),;
						SC5->C5_CONDPAG,;
						TransForm(SC5->C5_TOTPED,'@E 9,999,999,999.99'),;
						SC5->(Recno())})
		
		QRY4->(dbSkip(1))
	Enddo   
	QRY4->(dbCloseArea())
	RestArea(aArea)
Endif
						
If Len(aCabDoc) > 0
	lOk:=.f.

	DEFINE MSDIALOG oDlgDoc TITLE "Consulta Pedidos Vendas" FROM 000, 000  TO 540, 1200 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
	oDlgDoc:lEscClose := .F. //Não permite sair ao usuario se precionar o ESC
	
	@ 003, 005 SAY oMsg1 PROMPT "Pedidos: " SIZE 500, 010 OF oDlgDoc COLORS CLR_GREEN,CLR_WHITE PIXEL
	oMsg1:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	
	@ 120, 005 SAY oMsg2 PROMPT "Itens do Pedido " SIZE 500, 010 OF oDlgDoc COLORS CLR_BLUE,CLR_WHITE PIXEL
	oMsg2:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)


//	@ 011, 005 SAY oMsgCli PROMPT "Cliente: " + cNomeCli SIZE 500, 010 OF oDlgDoc COLORS CLR_GREEN,CLR_WHITE PIXEL
//	oMsgCli:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

//	@ 003, 205 BITMAP oBmp1 RESNAME "BR_VERMELHO"    oF oDlgDoc SIZE 35,15 NOBORDER WHEN .F. PIXEL
//	@ 003, 215 SAY oBmpSay1 PROMPT "Item Encerrado" PIXEL SIZE 90, 16 OF oDlgDoc

//	@ 003, 255 BITMAP oBmp1 RESNAME "BR_LARANJA"    oF oDlgDoc SIZE 35,15 NOBORDER WHEN .F. PIXEL
//	@ 003, 265 SAY oBmpSay1 PROMPT "Item Enc/Emp." PIXEL SIZE 90, 16 OF oDlgDoc
	
//	@ 003, 305 BITMAP oBmp1 RESNAME "BR_VERDE"    oF oDlgDoc SIZE 35,15 NOBORDER WHEN .F. PIXEL
//	@ 003, 315 SAY oBmpSay1 PROMPT "Item Aberto" PIXEL SIZE 90, 16 OF oDlgDoc
	
//	@ 003, 355 BITMAP oBmp1 RESNAME "BR_AMARELO"    oF oDlgDoc SIZE 35,15 NOBORDER WHEN .F. PIXEL
//	@ 003, 365 SAY oBmpSay1 PROMPT "Item Parc.Entregue" PIXEL SIZE 90, 16 OF oDlgDoc

	@ 003, 540 SAY oMsgIt PROMPT "Qtd.Pedidos: " + TransForm(Len(aCabDoc),'9,999') SIZE 500, 010 OF oDlgDoc COLORS CLR_MAGENTA,CLR_WHITE PIXEL
	oMsgit:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

    @ 018, 005 LISTBOX oCabDoc Fields HEADER 'Emissão','Pedido','Código',"Loja",'Fornecedor/Cliente',"Tipo","Cond.Pgto",'Total Pedido' SIZE 590, 090 OF oDlgDoc PIXEL //ColSizes 50,50

    oCabDoc:SetArray(aCabDoc)
    oCabDoc:bChange := {||Processa({||U_IteDocto(oCabDoc:nAt,@xCols,.f.)})}

    oCabDoc:bLine := {|| {		aCabDoc[oCabDoc:nAt,EMIDOC],;
	   								aCabDoc[oCabDoc:nAt,NUMDOC],;
							      	aCabDoc[oCabDoc:nAt,CLIDOC],;
		      						aCabDoc[oCabDoc:nAt,LOJDOC],;
		      						aCabDoc[oCabDoc:nAt,NOMDOC],;
							      	aCabDoc[oCabDoc:nAt,TIPDOC],;
							      	aCabDoc[oCabDoc:nAt,CNDDOC],;
							      	aCabDoc[oCabDoc:nAt,BRUDOC]}}
	
//	@ 100, 005 SAY oMsg2 PROMPT "Pedidos Gerados " SIZE 500, 010 OF oDlgDoc COLORS CLR_GREEN,CLR_WHITE PIXEL
//	oMsg2:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	

//	@ 100, 105 BITMAP oBmp1 RESNAME "BR_VERMELHO"    oF oDlgDoc SIZE 35,15 NOBORDER WHEN .F. PIXEL
//	@ 100, 125 SAY oBmpSay1 PROMPT "Pedido/Item Faturado" PIXEL SIZE 90, 16 OF oDlgDoc

//	@ 100, 205 BITMAP oBmp1 RESNAME "BR_AMARELO"    oF oDlgDoc SIZE 35,15 NOBORDER WHEN .F. PIXEL
//	@ 100, 225 SAY oBmpSay1 PROMPT "Pedido/Item Não Faturado" PIXEL SIZE 90, 16 OF oDlgDoc

//	@ 200, 005 SAY oMsg3 PROMPT "Item: " SIZE 500, 010 OF oDlgDoc COLORS CLR_GREEN,CLR_WHITE PIXEL
//	oMsg3:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

//	@ 200, 030 SAY oMsg4 PROMPT "Item: " SIZE 500, 010 OF oDlgDoc COLORS CLR_BLUE,CLR_WHITE PIXEL
//	oMsg4:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

//	@ 200, 350 SAY oMsg5 PROMPT "Qtd.Original: " SIZE 500, 010 OF oDlgDoc COLORS CLR_BLUE,CLR_WHITE PIXEL
//	oMsg5:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
//	@ 210, 350 SAY oMsg6 PROMPT "Qtd.Faturada: " SIZE 500, 010 OF oDlgDoc COLORS CLR_BLUE,CLR_WHITE PIXEL
//	oMsg6:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
//	@ 220, 350 SAY oMsg7 PROMPT "Qtd.Empenhada: " SIZE 500, 010 OF oDlgDoc COLORS CLR_BLUE,CLR_WHITE PIXEL
//	oMsg7:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
//	@ 230, 350 SAY oMsg8 PROMPT "Saldo: " SIZE 500, 010 OF oDlgDoc COLORS CLR_BLUE,CLR_WHITE PIXEL
//	oMsg8:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

	Processa({||U_IteDocto(1,@xCols,.t.)})

	//Execução das rotinas
	oGdTrt:=MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDlgDoc,xHeader,xCols)
//	oGdTrt:oBrowse:bLDblClick := {|| fDblClick() }
	//oGdTrt:oBrowse:bHeaderClick := {|x,y| fTrataCol(y) }
	
	//cGetCod := StrZero(0,5)
	//oGetCod:Refresh()
	
/*	If Len(oGdTrt:aCols) > 0
		oGdTrt:oBrowse:nAt:= 1
		oGdTrt:oBrowse:Refresh()
		oGdTrt:oBrowse:SetFocus()
	EndIf */

//    @ 130, 005 LISTBOX oIteDoc Fields HEADER 'Item','Codigo','Descrição Item','Und','Quantidade',"Vlr.Unitário",'Total',"TES",'Cfop','Almox.','Conta Cont.',;
//    										'C.Custol',"Ped.Compra","Item P.C.",'Nf.Origem','Serie Orig.',;
//    										'Item Orig.','Lote','Val.Lote' SIZE 590, 120 OF oDlgDoc PIXEL ColSizes 50,50


    @ 255, 005 BUTTON oBotaoSai PROMPT "&Ver Pedido"		ACTION (lOk:=.f.,U_V_PdV(aCabDoc[oCabDoc:nAt,NUMDOC])) 	SIZE 080, 010 OF oDlgDoc PIXEL
    @ 255, 105 BUTTON oBotaoSai PROMPT "&Grava Pedido" 		ACTION (lOk:=.f.,Processa({||U_GrvPedi(oCabDoc:nAt,aCabDoc,oGdTrt:aCols)})) 	SIZE 080, 010 OF oDlgDoc PIXEL
    @ 255, 205 BUTTON oBotaoSai PROMPT "&Retornar" 			ACTION (lOk:=.f.,Close(oDlgDoc)) 	SIZE 080, 010 OF oDlgDoc PIXEL
	
	ACTIVATE MSDIALOG oDlgDoc CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
	If !lOk
		RestArea(aArea)
		Return(Nil)   
	Endif
Endif
RestArea(aArea)
Return Nil


User Function IteDocto(nPos, xCols, lPrimeira)
Local aArea := GetArea()

If nPos > 0 
	cPedNum := aCabDoc[nPos,NUMDOC]
	nItems  := 0	
	aLinhas := {}
	
	SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cPedNum))
	

	If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cPedNum))
		While SC6->(!Eof()) .And.  SC6->C6_FILIAL == xFilial("SC6") .And. cPedNum = SC6->C6_NUM
         	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			
			//Adiciona nova linha para alimentar colunas
			aAdd(aLinhas,Array(11))

			aLinhas[Len(aLinhas)][ITEITE] := SC6->C6_ITEM
    		aLinhas[Len(aLinhas)][CODITE] := SC6->C6_PRODUTO
			aLinhas[Len(aLinhas)][DSCITE] := SB1->B1_DESC
			aLinhas[Len(aLinhas)][UNDITE] := SD1->D1_UM
			aLinhas[Len(aLinhas)][QTDITE] := SC6->C6_QTDVEN
			aLinhas[Len(aLinhas)][UNTITE] := SC6->C6_PRCVEN
			aLinhas[Len(aLinhas)][TOTITE] := SC6->C6_VALOR
			aLinhas[Len(aLinhas)][TESITE] := SC6->C6_TES
			aLinhas[Len(aLinhas)][CFOITE] := SC6->C6_CF
			aLinhas[Len(aLinhas)][NOPITE] := SC6->C6_NUMOP
			aLinhas[Len(aLinhas)][DENITE] := SC6->C6_ENTREG
		
			SC6->(dbSkip(1))
			nItems++		
		Enddo
	Endif
	
//	oMsg4:cCaption := AllTrim(aCabDoc[nPos,PRDCTR]) + ' - ' + AllTrim(aCabDoc[nPos,DESCTR])

//	oMsg5:cCaption := 'Qtd.Original: ' + TransForm(nQtdOri,'@E 9,999,999.9')
//	oMsg6:cCaption := 'Qtd.Faturada: ' + TransForm(nQtdFat,'@E 9,999,999.9')
//	oMsg7:cCaption := 'Qtd.Empenhada: ' + TransForm(nQtdEmp,'@E 9,999,999.9')
//	oMsg8:cCaption := 'Saldo: ' + TransForm(nSaldo,'@E 9,999,999.9')
	
//	oMsg5:Refresh()
//	oMsg6:Refresh()
//	oMsg7:Refresh()
//	oMsg8:Refresh()
Endif
xCols := {}
For x:=1 To Len(aLinhas)
	aAdd(xCols,Array(Len(xHeader)+1))

	nLin := Len(xCols)
	For y:=1 To Len(xHeader)
		xCols[nLin][y] := aLinhas[x][y]
	Next y

	//Tratamento de primeira e ultima linha
	xCols[nLin,Len(xHeader)+1] := .F.

Next x                    
If !lPrimeira
	oGdTrt:aCols := xCols
	aSort(oGdTrt:aCols,,,{|x,y|,x[1] < y[1]})
	oGdTrt:oBrowse:nAt := 1
	oGdTrt:Refresh()
Endif
oDlgDoc:Refresh()
RestArea(aArea)
Return .t.

//**************************************************************************************************


/////////////////////////////
User Function V_PdV(cPedNum)	//--> Rotina de interface da visualizacao do Pedido de Venda
/////////////////////////////

Local aArea     := GetArea()
Local cSavFil   := cFilAnt

//Chamada do Cabecalho da Rotina A103NFISCAL
cCadastro	:= OemToAnsi("Visualização Pedido de Vendas")
//Zerando a Variavel para chamada da Funcao A103NFISCAL (Se Remover Gera nao Conformidade)
aRotina		:= {}
aAdd(aRotina,{OemToAnsi("Pesquisar"), "AxPesqui"   , 0 , 1, 0, .F.}) 		//"Pesquisar"

//----------------------------------------------------------------------------
//| Montagem da interface                                                    |
//----------------------------------------------------------------------------
dbSelectArea("SC5")
dbSetOrder(1)
If MsSeek(xFilial("SC5")+cPedNum)
	A410Visual("SC5",Recno(),2)
EndIf

//----------------------------------------------------------------------------
//| Restaura a integridade da rotina                                         |
//----------------------------------------------------------------------------
cFilAnt := cSavFil
RestArea(aArea)

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FS_CONSNF  ³ Autor  ³ Thiago    	     	  ³ Data ³15/07/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Consulta nota fiscal.		                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_CONSNF(nPos)

#DEFINE FRETE   04	// Valor total do Frete
#DEFINE VALDESP 05	// Valor total da despesa
#DEFINE SEGURO  07	// Valor total do seguro

#define STR0001 "Pesquisar"
#define STR0002 "Visualizar"
#define STR0003 "Incluir"
#define STR0004 "Classificar"

Local aArea		 := GetArea()
Local bBlock    := {|| Nil}
Local nX	   	:= 0
Local aCoresUsr  := {}

PRIVATE l103Auto	:= .F.
PRIVATE aAutoCab	:= {}
PRIVATE aAutoImp    := {}
PRIVATE aAutoItens 	:= {}
PRIVATE aBackSD1    := {}
PRIVATE aBackSDE    := {}

If nPos > 0 
	cDocNum := aCabDoc[nPos,DOCDOC]
	cSerNum := aCabDoc[nPos,SERDOC]
	cForNum := aCabDoc[nPos,FORDOC]
	cLojNum := aCabDoc[nPos,LOJDOC]
Else
	Return .f.
Endif


//Chamada do Cabecalho da Rotina A103NFISCAL
cCadastro	:= OemToAnsi("Documento de Entrada")
//Zerando a Variavel para chamada da Funcao A103NFISCAL (Se Remover Gera nao Conformidade)
aRotina		:= {}
aAdd(aRotina,{OemToAnsi(STR0001), "AxPesqui"   , 0 , 1, 0, .F.}) 		//"Pesquisar"
aAdd(aRotina,{OemToAnsi(STR0002), "A103NFiscal", 0 , 2, 0, nil}) 		//"Visualizar"
aAdd(aRotina,{OemToAnsi(STR0003), "A103NFiscal", 0 , 3, 0, nil}) 		//"Incluir"
aAdd(aRotina,{OemToAnsi(STR0004), "A103NFiscal", 0 , 4, 0, nil}) 		//"Classificar"
                         
INCLUI := .F.
ALTERA := .F.


//Posicionamento do Cabecalho da NF de Entrada para chamada de todos os Itens - Consulta Geral de NF Entrada


DbSelectArea("SF1")
DbSetOrder(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
If SF1->(dbSetOrder(1), dbSeek(xFilial("SF1")+cDocNum+cSerNum+cForNum+cLojNum))
//	If DbSeek(SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
		A103NFISCAL("SF1",SF1->(Recno()),2,.F.,.F.)
//	Endif
Endif

//Voltando com a Chamada da Variavel a Rotina para o Programa Principal
aRotina	:= {}
RestArea(aArea)
Return



Static Function RetTipo(cTipo)
If cTipo == 'N'
	Return 'Normal'
ElseIf cTipo == 'D'
	Return 'Devolução'
ElseIf cTipo == 'B'
	Return 'Beneficiamento'
ElseIf cTipo == 'C'
	Return 'Complemento'
Endif

Return 'Normal'

	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ValidPerg º Autor ³ AP6 IDE            º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica os parametro cadastrados. Se nao existir, cria-os.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg(cPerg)

PutSx1( cPerg   ,"01","De Emissao"	           ,"","","mv_ch1","D",8,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"02","Ate Emissao"	           ,"","","mv_ch2","D",8,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"03","Do Pedido"	           ,"","","mv_ch3","C",6,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"04","Ate Pedido"	           ,"","","mv_ch4","C",6,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"05","De Cliente"             ,"","","mv_ch5","C",6,0,0,"G","","SA1","","","MV_PAR05","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"06","Ate Cliente"            ,"","","mv_ch6","C",6,0,0,"G","","SA1","","","MV_PAR06","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"07","De Loja"		           ,"","","mv_ch7","C",2,0,0,"G","","","","","MV_PAR07","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"08","Ate Loja"		       ,"","","mv_ch8","C",2,0,0,"G","","","","","MV_PAR08","","","","","","","","","","","","","","","","",{},{},{})

Return Nil


User Function GrvPedi(nPos,aCabDoc,aCols)
Local aArea := GetArea()
Local	lAtu := .f.

If nPos > 0 
	cPedNum := aCabDoc[nPos,NUMDOC]

	If MsgYesNo ("Confirma Atualização dos Dados do Pedido "+cPedNum +" ?")
		For nLin := 1 To Len(aCols)
			If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cPedNum+aCols[nLin,1]+aCols[nLin,2]))
				If SC6->C6_ENTREG <> aCols[nLin,DENITE] 
					lAtu := .t.          
					
					// Atualiza Item do Pedido de Vendas
					
					If RecLock("SC6",.f.)
						SC6->C6_ENTREG	:=	aCols[nLin,DENITE]
						SC6->(MsUnlock())
					Endif
					
					// Atualiza Item do Call Center se Existir
					
					If SUB->(dbSetOrder(3), dbSeek(xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM))
						If RecLock("SUB",.f.)
							SUB->UB_DTENTRE	:=	aCols[nLin,DENITE]
							SUB->(MsUnlock())
						Endif
					Endif					
					
					// Atualiza Ordem de Producao
					
					If SC2->(dbSetOrder(9), dbSeek(xFilial("SUB")+SC6->C6_NUMOP+SC6->C6_ITEM))
						While SC2->(!Eof()) .And. SC2->C2_FILIAL == xFilial("SC2") .And. SC2->C2_ITEM == SC6->C6_ITEM .And. SC2->C2_NUM == SC6->C6_NUMOP 
							If RecLock("SC2",.f.)
								SC2->C2_DATPRF	:=	aCols[nLin,DENITE]
								SC2->(MsUnlock())
							Endif

							SC2->(dbSkip(1))
						Enddo
					Endif					
				
					aAreaSC2    := SC2->(GetArea())
					aAreaSC5    := SC5->(GetArea())
					aAreaSC6    := SC6->(GetArea())
					aAreaSC9    := SC9->(GetArea())
					aAreaSB1    := SB1->(GetArea())
			
					If cEmpAnt == '01'
						If Empty(SC5->C5_PEDWEB)
							U_CargaPed(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO) // Ajusta Saldo Carga Fabrica
						Endif
					Endif
																			
					RestArea(aAreaSC2)
					RestArea(aAreaSC5)
					RestArea(aAreaSC6)
					RestArea(aAreaSC9)
					RestArea(aAreaSB1)
					
				Endif
			Endif
		Next
		
	Endif
Endif            

If lAtu
	MsgInfo("Atualização de Pedido/Atendimento e Ordem de Produção " + cPedNum + " Efetuado com Sucesso !")
Endif

RestArea(aArea)
Return .t.
