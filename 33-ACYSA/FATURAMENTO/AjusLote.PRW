#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description                                                     

@param xParam Parameter Description                             
@return xRet Return Description                                 

/*/                                                             
//--------------------------------------------------------------
User Function AjusLote(cWhen)                        
Local aButtons := {}
Local oFont1 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
Local oFont2 := TFont():New("Times New Roman",,019,,.T.,,,,,.F.,.F.)
Local oFont3 := TFont():New("Times New Roman",,019,,.F.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := SC5->C5_NUM
Local oGet2
Local cGet2 := SC5->C5_CLIENTE
Local oGet3
Local cGet3 := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
Local oSay1
Local oSay2
Private oWBrowse1
Private aWBrowse1 := {}
Private  oDlg
Private lAlt := cWhen                           
Private nPt := 1
lCont := .T.

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+SC5->C5_NUM)
While !Eof() .and. SC5->C5_NUM == SC6->C6_NUM .And. lCont 

	If !Empty(SC6->C6_NOTA)
		lCont := .F.
		Alert("Pedido ja faturado!")
	EndIf
	    
    DbSelectArea("SC6")
    DbSkip()
EndDo

If !lCont
	Return
EndIf

DbSelectArea("SC9")
DbSetOrder(1)
DbSeek(xFilial("SC9")+SC5->C5_NUM)
While !Eof() .and. SC5->C5_NUM == SC9->C9_PEDIDO .And. lCont 

	If !Empty(SC9->C9_BLEST) .OR. !Empty(SC9->C9_BLCRED)
		lCont := .F.
		Alert("Pedido com bloqueio de Credito/Estoque")
	EndIf
	    
    DbSelectArea("SC9")
    DbSkip()
EndDo

If !lCont
	Return
EndIf

  DEFINE MSDIALOG oDlg TITLE "Pedido de Venda" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

    @ 013, 006 SAY oSay1 PROMPT "Pedido:" SIZE 025, 007 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 012, 036 MSGET oGet1 VAR cGet1 WHEN .F. SIZE 060, 012 OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL
    @ 034, 006 SAY oSay2 PROMPT "Cliente :" SIZE 028, 008 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 033, 038 MSGET oGet2 VAR cGet2 WHEN .F. SIZE 060, 012 OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL
    @ 033, 103 MSGET oGet3 VAR cGet3 WHEN .F. SIZE 358, 012 OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL
    fWBrowse1()

  ACTIVATE MSDIALOG oDlg CENTERED ON INIT  EnchoiceBar(oDlg, {||grava()}, {||odlg:end()},,)

Return

//------------------------------------------------ 
Static Function fWBrowse1()
//------------------------------------------------ 
        
    DbSelectArea("SC6")
    DbSetOrder(1)
    DbSeek(xFilial("SC6")+SC5->C5_NUM)
    
    While !Eof() .and. SC5->C5_NUM == SC6->C6_NUM
	    Aadd(aWBrowse1,{SC6->C6_PRODUTO,SC6->C6_DESCRI,SC6->C6_QTDVEN,SC6->C6_PRCVEN,SC6->C6_VALOR,SC6->C6_LOTECTL,SC6->C6_LOCAL})
	    
	    DbSelectArea("SC6")
	    DbSkip()
	EndDo
    
	aSort( aWBrowse1 ,,, {|a,b| a[1]+strzero(a[3],9) < b[1]+strzero(b[3],9)} )

    @ 057, 005 LISTBOX oWBrowse1 Fields HEADER "Produto","Descricao","Quantidade","Vlr. Unitario","Vlr. Total","Lote","Armazem" SIZE 488, 170 OF oDlg PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      aWBrowse1[oWBrowse1:nAt,1],;
      aWBrowse1[oWBrowse1:nAt,2],;
      Transform(aWBrowse1[oWBrowse1:nAt,3],"@E 9,999,999.99"),;
      Transform(aWBrowse1[oWBrowse1:nAt,4],"@E 9,999,999.99"),;
      Transform(aWBrowse1[oWBrowse1:nAt,5],"@E 9,999,999.99"),;
      aWBrowse1[oWBrowse1:nAt,6],;
      aWBrowse1[oWBrowse1:nAt,7];
    }}
    // DoubleClick event
    If lAlt
	    oWBrowse1:bLDblClick := {|| VerLote(oWBrowse1:nAt),oWBrowse1:DrawSelect()}
	EndIf

Return                               

///////////////////////////////////////////////////////////////////////qq
Static Function VerLote(nPos)
             
Local oButton1
Local oButton2
Local oFont1 := TFont():New("MS Sans Serif",,018,,.F.,,,,,.F.,.F.)
Private nQuant  := aWBrowse1[nPos][3]
Private nQtdOri := aWBrowse1[nPos][3]
Private cLote   := aWBrowse1[nPos][6]
Private cLocal  := aWBrowse1[nPos][7]
Private cProd   := aWBrowse1[nPos][1]
Private cDProd  := aWBrowse1[nPos][2]
Private nPrc    := aWBrowse1[nPos][4]
Static oDlg1                 
Public __cProdW := aWBrowse1[nPos][1]
Public __cLocW	:= aWBrowse1[nPos][7]
Private cProdeW := alltrim(cProd)+' - '+cDProd
lContinua := .T.
nPt := 1

While lContinua
  DEFINE MSDIALOG oDlg1 TITLE "Qtd / Lote" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

    @ 014, 005 SAY "Produto:"     SIZE 025, 010 OF oDlg1 FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 012, 045 MSGET cProdeW      SIZE 200, 010 OF oDlg1 COLORS 0, 16777215 FONT oFont1 PIXEL
    @ 034, 005 SAY "Quantidade: " SIZE 045, 010 OF oDlg1 FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 032, 045 MSGET nQuant       SIZE 060, 010 Picture "@E 9,999,999.99" OF oDlg1 COLORS 0, 16777215 FONT oFont1 PIXEL
    @ 054, 005 SAY "Amz: "        SIZE 025, 010 OF oDlg1 FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 052, 045 MSGET cLocal       SIZE 015, 010 OF oDlg1 FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 054, 070 SAY "Lote: "       SIZE 025, 010 OF oDlg1 FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 052, 110 MSGET cLote        SIZE 065, 010 F3 "LOT" OF oDlg1 COLORS 0, 16777215 FONT oFont1 PIXEL

    @ 080, 080 BUTTON oButton2 PROMPT "&Ok" SIZE 037, 012 OF oDlg1 PIXEL Action(GrvLtProd(nPos))
    @ 080, 130 BUTTON oButton1 PROMPT "&Sair" SIZE 037, 012 OF oDlg1 PIXEL Action(lCOntinua:=.F.,oDlg1:End())

  ACTIVATE MSDIALOG oDlg1 CENTERED
EndDo

aSort( aWBrowse1 ,,, {|a,b| a[1]+strzero(a[3],9) < b[1]+strzero(b[3],9)} )

oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      aWBrowse1[oWBrowse1:nAt,1],;
      aWBrowse1[oWBrowse1:nAt,2],;
      Transform(aWBrowse1[oWBrowse1:nAt,3],"@E 9,999,999.99"),;
      Transform(aWBrowse1[oWBrowse1:nAt,4],"@E 9,999,999.99"),;
      Transform(aWBrowse1[oWBrowse1:nAt,5],"@E 9,999,999.99"),;
      aWBrowse1[oWBrowse1:nAt,6],;
      aWBrowse1[oWBrowse1:nAt,7];
    }}
oWBrowse1:refresh()
odlg:Refresh()

Return(.T.)                                  

///////////////////////////////////////////////////////
Static Function GrvLtProd(nPos)
 
If nQuant == 0
	Alert("Favor preencher a quantidade!")
	Return
EndIf 

If nPt == 1	
    aWBrowse1[nPos][3] := nQuant
    aWBrowse1[nPos][5] := nQuant*nPrc
    aWBrowse1[nPos][6] := cLote
    aWBrowse1[nPos][7] := cLocal
Else
	Aadd(aWBrowse1,{cProd,cDprod,nQuant,nPrc,nQuant*nPrc,cLote,cLocal})
EndIf                          

nQtdOri := nQtdOri - nQuant
nQuant := iif(nQtdOri>0,nQtdOri,0)
nPt ++

Return

//------------------------------------------------ 
Static Function Grava()
//------------------------------------------------ 


If lAlt
	GravaDados()
EndIf
     
odlg:Refresh()
odlg:End()
               
Return          

//------------------------------------------------ 
Static Function GravaDados()
//------------------------------------------------ 
                          
_aCabec := {}
_aAux1 := {} 
_aLinhas := {}
_aPedido := {}
cPedido := SC5->C5_NUM
_lErro  := .F.
aVetCons := {}                       
nQtd := 0

DbSelectArea("SC6")
DbSetOrder(1)
If DbSeek(xFilial("SC6")+SC5->C5_NUM)
	
	While !SC6->(EOF()) .And. xFilial("SC6")+SC5->C5_NUM == SC6->C6_FILIAL + SC6->C6_NUM
		
		AAdd(aVetCons,{SC6->C6_PRODUTO,SC6->C6_TES,SC6->C6_LOCAL})
	
		DbSelectArea("SC6")
		DbSkip()
	EndDo

	For i:=1 To Len(aWBrowse1)

		cPos := Ascan(aVetCons,{|x| AllTrim(x[1]) == alltrim(aWBrowse1[i][1])})
			
		_aAux1 := {}
		aAdd(_aAux1,{"C6_ITEM"   ,strzero(i,2)      ,Nil})
		aAdd(_aAux1,{"C6_PRODUTO",aWBrowse1[i][1]   ,Nil})
		aAdd(_aAux1,{"C6_QTDVEN" ,aWBrowse1[i][3]   ,Nil})
		aAdd(_aAux1,{"C6_PRCVEN" ,aWBrowse1[i][4]	,Nil})
		aAdd(_aAux1,{"C6_PRUNIT" ,aWBrowse1[i][4]	,Nil})
		aAdd(_aAux1,{"C6_TES"    ,aVetCons[cPos][2],Nil})
		aAdd(_aAux1,{"C6_LOCAL"  ,aVetCons[cPos][3],Nil})
		aAdd(_aAux1,{"C6_LOTECTL" ,aWBrowse1[i][6]	,Nil})
		AAdd(_aLinhas, _aAux1)                           
		
		nQtd += aWBrowse1[i][3]


	Next i
EndIf

aAdd(_aCabec,{"C5_NUM"   	,SC5->C5_NUM  	,Nil})
aAdd(_aCabec,{"C5_TIPO"   	,SC5->C5_TIPO  	,Nil})
aAdd(_aCabec,{"C5_CLIENTE"	,SC5->C5_CLIENTE	,Nil})
aAdd(_aCabec,{"C5_LOJACLI"	,SC5->C5_LOJACLI  ,Nil})
aAdd(_aCabec,{"C5_TIPOCLI"	,SC5->C5_TIPOCLI   ,Nil})
aAdd(_aCabec,{"C5_CONDPAG"	,SC5->C5_CONDPAG	,Nil})
aAdd(_aCabec,{"C5_TABELA"	,SC5->C5_TABELA	,Nil})
aAdd(_aCabec,{"C5_EMISSAO"	,SC5->C5_EMISSAO	    ,Nil})
aAdd(_aCabec,{"C5_PBRUTO"	,nQtd	    ,Nil})
aAdd(_aCabec,{"C5_PESOL"	,nQtd	    ,Nil})
aAdd(_aCabec,{"C5_ESPECI1"	,"KG"	    ,Nil})
		
lMsHelpAuto := .T.
lMsErroAuto := .F.
	
Processa({|| MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabec,_aLinhas,4)},"Alterando o pedido "+cPedido)

If lMsErroAuto
	DisarmTransaction()
	MostraErro()
	ALERT("ERRO AO ALTERAR PEDIDO, CONTATE SUPORTE!")
	_lErro := .T.
Else                               
	
	lRetorno 		:= .T.
	aBloqueio		:= {}
	aPvlNfs		:= {}
	lLiberado		:= .F.
	lFaturado		:= .F.
	lRejeitado	:= .F.
	
	//컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Faz a Liberacao do Pedido.                                 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If SC5->(DbSeek(xFilial("SC5")+cPedido))
		// Liberacao de pedido
		Ma410LbNfs(2, @aPvlNfs, @aBloqueio)
	EndIf

	If SC5->(DbSeek(xFilial("SC5") + cPedido))
		// Checa itens liberados
		Ma410LbNfs(1, @aPvlNfs, @aBloqueio)
	EndIf

	DbSelectArea("SC9")
	SC9->(DBSetOrder(1))
	If SC9->(DbSeek(xFilial("SC9") + cPedido) )

		While !SC9->(Eof()) .AND. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + cPedido

			lLiberado	:= Empty(SC9->C9_BLCRED) .AND. Empty(SC9->C9_BLEST)
			lFaturado	:= SC9->C9_BLCRED == "10" .AND. SC9->C9_BLEST == "10"
			lRejeitado	:= SC9->C9_BLCRED == "09"
			
			If !lLiberado .And. !lFaturado .And. !lRejeitado
				a450Grava(1, .T., .T., .F.)
			EndIf

			SC9->(DbSkip())

		Enddo

	EndIf
	
	// grava campo memo
	GrvMemo()                        

EndIf

Return .T.

//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author Ricardo Mansano - amedeo.paoli@g3systems.com.br                                              
@since 29/10/2012
/*/                                                             
//--------------------------------------------------------------
Static Function GrvMemo()                        
Local oButton1
Local oFontx := TFont():New("MS Sans Serif",,011,,.F.,,,,,.F.,.F.)
Local oMemo
Local cMemo := SC5->C5_XMENS
Local oSay1
Static oDlg2

  DEFINE MSDIALOG oDlg2 TITLE "Mensagem Nota...." FROM 000, 000  TO 180, 400 COLORS 0, 16777215 PIXEL

    @ 067, 147 BUTTON oButton1 PROMPT "&Ok" SIZE 037, 012 OF oDlg2 PIXEL ACTION(oDlg2:END())
    @ 003, 004 SAY oSay1 PROMPT "Obs. N.F.:" SIZE 077, 007 OF oDlg2 FONT oFontx COLORS 0, 16777215 PIXEL
	@ 015, 003 GET oMemo VAR cMemo OF oDlg2 MEMO SIZE 190,046 PIXEL

  ACTIVATE MSDIALOG oDlg2 CENTERED                                                          
  
RecLock("SC5",.F.)
	SC5->C5_XMENS := cMemo
MsUnLock()

Return
