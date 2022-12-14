#INCLUDE "PROTHEUS.CH"
#INCLUDE "DIALOG.CH"
#INCLUDE "FONT.CH"
#INCLUDE "PRTOPDEF.CH"

#DEFINE xMarcado      1 // Marcado/Desmarcado
#DEFINE xNumTitulo    2 // Numero do Titulo - CNX_NUMERO
#DEFINE xNumMedicao   3 // Numero da Medicao - 
#DEFINE xVlrTitulo    4 // CNX_XVLORI
#DEFINE xPercMedicao  5 // Percentual da Medicao - CNX_XPERC
#DEFINE xValorAdto    6 // Adiantamento a Compensar - CNX_VLADT
#DEFINE xDataAdto     7 // Data do Adiantamento - CNX_DTADT
#DEFINE xNumContrato  8 // Numero do Contrato - CNX_CONTRA
#DEFINE xVlrMedicao   9 // Valor Medicao
#DEFINE xCNX_NUMERO	 10 // Numero sequencial da CNX 
#DEFINE xNumColunas  10

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    ? RNO002  ? Autor ? Antonio Carlos       ? Data ?29/05/2015   潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 砈elecao doa adiantamenentos do modulo SIGAGCT                潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   砇NO002( ExpC1, ExpC2, ExpC3)                                 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros? ExpC1 -> Numero                                             潮?
北?          ? ExpC2 -> Valor  do adiantamento                             潮?
北?          ? ExpC3 -> Data   do adiantamento                             潮?
北?          ? ExpC4 -> Percentual sobre o Valor do Contrato que de inf.   潮?
北?          ? ExpC5 -> Numero do contrato                                 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   ? .T.                                                         潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       ? Gest鉶 de Contratos                                         潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/

User Function RNO002()

Local aArea      := GetArea()

Local cQuery     := ""
Local cAliasQry  := ""

Local nOpca      := 0
Local nLoop      := 0
Local nX
Local _nPedido   := ""

Local lProcessa  := .F.
Local oOk        := LoadBitmap( GetResources(), "LBOK" )
Local oNOk       := LoadBitmap( GetResources(), "LBNO" )
Local oDlg

Local oBold
Local oBmp
Local oBut1

Local lTodos     := .F.
Local cFilCtr    := cFilAnt

Local oSize 	 := FwDefSize():New()
Local oDlg1              
Local lMontaTela	:= .F.

Private _aListBox := {}
Private _nNumTit  := Nil
Private _nVlSom   := 0
Private _nVlTot   := 0
Private nCN9_SALDO:= 0

//Public  _aTitpa   := {}  

//aListBox VARIAVEL PUCLIC DECLARADA NO FONTE PADRAO CNTA130.PRW
For nX:=1 To Len( aListBox )
	If aListBox[nX,1]
		lMontaTela := .T.	
	EndIf
Next nX

//Se o aListBox estiver vazio, quer dizer que j? foram consumidos todos os PAs.
//If Len(aListBox) == 0
//	Aviso("Aten玢o!", "N鉶 ha adiantamentos para esse contrato ou adiantamento(s) j? utilizado(s). ", {" Ok "})     
//    RestArea( aArea ) 
//	Return()
//EndIf

//If !lMontaTela
//	Aviso("Adiantamento Renova %", "Relacione primeiro o adiantamento na rotina padr鉶! ", {" Ok "})     
//    RestArea( aArea ) 
//	Return()
//EndIf


DbSelectArea("CN9")             //Contratos   -   TP_CONT = 1 - Compras
DbSetOrder(1)
DbSeek(xFilial("CN9")+M->CND_CONTRA+M->CND_REVISA)          //+M->CND_CONTRA+M->CND_REVISA)
nCN9_SALDO	:= CN9->CN9_SALDO

If FieldPos("CN9_ESPCTR") > 0
	cEspCtr := CN9->CN9_ESPCTR
ElseIf !Empty(CN9->CN9_CLIENT)
	cEspCtr := "2"
Else
	cEspCtr := "1"
EndIf

//DbSelectArea("CND")     //Cabecalho da Medicao
_nPedido := M->CND_PEDIDO	//CND->CND_PEDIDO
_nVlTot  := M->CND_VLTOT	//CND->CND_VLTOT

//+----------------------------------------------------------------------------
//| Verifica liga玢o Pedido x Contrato pelo FIE
//+----------------------------------------------------------------------------
/*DbSelectArea("FIE")
dbSetOrder(1)//Filial+Carteira+Pedido
IF !dbSeek(xFilial("FIE")+"P"+_nPedido)
    RestArea( aArea )
	Aviso("Contrato x Pedido", "N鉶 encontrada a rela玢o ! ", {" Ok "})
    Return( .T. )
ENDIF
*/

//DbSelectArea("CND")
//+-----------------------------------------------------------------------------------------------
//| Verifica os Adiantamentos do Contrato para apresentar no Browse
//+------------------------------------------------------------------------------------------------
cAliasQry := GetNextAlias()
cQuery := "SELECT CNX_FILIAL, CNX_CONTRA, CNX_NUMERO, CNX_DTADT, CNX_VLADT, CNX_NUMMED, CNX_NUMTIT, CNX_XVLORI, CNX_XPERC "
cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
cQuery += " WHERE CNX_FILIAL ='"+xFilial("CNX")+"'"
cQuery += "   AND CNX_CONTRA ='"+M->CND_CONTRA+ "'"
cQuery += "   AND (CNX_NUMMED IN ('"+Space(TamSx3('CND_NUMMED')[1])+"','"+M->CND_NUMMED+"')) AND "
If cEspCtr == "1"
	cQuery += "CNX_FORNEC = '"+M->CND_FORNEC+"' AND "
	cQuery += "CNX_LJFORN = '"+M->CND_LJFORN+"' AND "
Else
	cQuery += "CNX_CLIENT = '"+M->CND_CLIENT+"' AND "
	cQuery += "CNX_LOJACL = '"+M->CND_LOJACL+"' AND "
EndIf
cQuery += " CNX.D_E_L_E_T_=' ' "
cQuery += " ORDER BY CNX_DTADT "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

TCSetField(cAliasQry,"CNX_DTADT","D",08,0)
TCSetField(cAliasQry,"CNX_VLADT","N",TamSX3("CNX_VLADT")[1],TamSX3("CNX_VLADT")[2])

If  (cAliasQry )->( Eof() )
     Aviso( "Adiantamentos - Atencao! ", " N鉶 ha Adiantamentos para esse Contrato.", {"OK"}, 2 )
     ( cAliasQRY )->( dbCloseArea() )
     RestArea( aArea )
     Return( .T. )
Endif
     
If !lMontaTela
	Aviso("Adiantamento Renova %", "Relacione primeiro o adiantamento na rotina padr鉶! ", {" Ok "})     
    RestArea( aArea ) 
	Return()
EndIf

_nNumTit = (cAliasQRY)->CNX_NUMTIT

If len(_aListBox)=0    // Tratamento para caso ja existe o List e ja est鉶 marcados, continuarem marcados
	While !( cAliasQry )->( Eof() )
        //( cAliasQRY )->CNX_XPERC:=0
		AAdd( _aListBox, Array(xNumColunas))
		Atail(_aListBox)[xMarcado]     := If( Empty((cAliasQRY)->CNX_NUMMED),.F.,.T.)
		Atail(_aListBox)[xNumTitulo]   := ( cAliasQRY )->CNX_NUMTIT
		Atail(_aListBox)[xNumMedicao]  := ( cAliasQRY )->CNX_NUMMED
		Atail(_aListBox)[xVlrTitulo]   :=  ( cAliasQRY )->CNX_XVLORI
		Atail(_aListBox)[xPercMedicao] := ( cAliasQRY )->CNX_XPERC
		Atail(_aListBox)[xValorAdto]   := ( cAliasQRY )->CNX_VLADT
		Atail(_aListBox)[xDataAdto]    := ( cAliasQRY )->CNX_DTADT
		Atail(_aListBox)[xNumContrato] := ( cAliasQRY )->CNX_CONTRA
		Atail(_aListBox)[xVlrMedicao]  :=  _nVlTot 
		Atail(_aListBox)[xCNX_NUMERO]  :=  ( cAliasQRY )->CNX_NUMERO
		( cAliasQry )->( dbSkip() )
	EndDo
Endif
                 
( cAliasQRY )->( dbCloseArea() )

//+----------------------------------------------------------------------------
//| Defini玢o da janela e seus conte鷇os
//+----------------------------------------------------------------------------
DEFINE MSDIALOG oDlg TITLE "Adiantamentos" FROM 0,0 TO 282,552 OF oDlg PIXEL
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

@ 03, 40 SAY "Adiantamentos"  FONT oBold PIXEL
@ 03, 30 TO 16 ,250 LABEL ''  OF oDlg PIXEL

oList := TWBrowse():New(20, 10, 255, 108 ,,{ "","T韙ulo","Val Adiantamento", " % ","Val a Compensar","Valor Medicao","Data", "Contrato","Sequencia CNX"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oList:SetArray(_aListBox)
oList:bLine := { || { If(           _aListBox[oList:nAT,xMarcado]=.T., oOk, oNOK ),;
                                    _aListBox[oList:nAt,xNumTitulo]  ,;
                          Transform(_aListBox[oList:nAT,xValorAdto]  ,"@E 999,999,999.99" ),;
                                    _aListBox[oList:nAT,xPercMedicao],;                                         
                          If(xVlrTitulo>0,Transform(_aListBox[oList:nAT,xVlrTitulo]  ,"@E 999,999,999.99" ),Transform(_aListBox[oList:nAT,xVlrMedicaoi]  ,"@E 999,999,999.99" )),;                                    //Deve mostrar inicialmente o valor total da medi玢o
                          Transform(_aListBox[oList:nAT,xVlrMedicao] ,"@E 999,999,999.99" ),;                          
                                    _aListBox[oList:nAT,xDataAdto],_aListBox[oList:nAT,xNumContrato],_aListBox[oList:nAT,xCNX_NUMERO]} }
oList:bLDblClick := { || CN130MkCron()}

@ 130,025 CheckBox oTodos Var lTodos Prompt "Marcar Todos" Size 060, 015 PIXEL OF oDlg On Click MarcDesm( lTodos )
//@ 130,075 BUTTON "Excluir" SIZE 35,11 ACTION {|| Excper(  oList)} OF oDlg PIXEL
@ 130,165 BUTTON "Alterar" SIZE 35,11 ACTION {|| Altperc( oList),PastaTotais( oList )} OF oDlg PIXEL   //Esta era a que estava no lugar do 4 -  @_aListBox,
DEFINE SBUTTON oBut1 FROM 130, 130 TYPE 1 ACTION ( nOpca := 1,	oDlg:End() ) ENABLE of oDlg
DEFINE SBUTTON oBut2 FROM 130, 220 TYPE 2 ACTION ( nOpca := 0, oDlg:End() )  ENABLE of oDlg

ACTIVATE MSDIALOG oDlg CENTERED

RestArea( aArea )

Return( .T. )

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯屯退屯屯屯脱屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯槐?
北篜rograma  矯N130MkCron  篈utor  砇obson Nayland      ? Data ?  23/10/06罕?
北掏屯屯屯屯拓屯屯屯屯屯屯褪屯屯屯拖屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯贡?
北篋esc.     矼arca/Desmarca itens na TwBrowse .                          罕?
北?          ?                                                            罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Gest鉶 de Contratos                                        罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/

Static Function CN130MkCron()

Local nX         := 0
Local lRetVCK    := .T.

IF _aListBox[oList:nAT, xMarcado]==.T.
   _aListBox[oList:nAT, xMarcado]:=.F.
Else
   _aListBox[oList:nAT, xMarcado]:=.T.
Endif

Return()


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯屯退屯屯屯脱屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯槐?
北篜rograma  矼arcDesm     篈utor  砇obson Nayland      ? Data ?  23/10/06罕?
北掏屯屯屯屯拓屯屯屯屯屯屯褪屯屯屯拖屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯贡?
北篋esc.     矼arca/Desmarca todos os itens na TwBrowse .                 罕?
北?          ?                                                            罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Gest鉶 de Contratos                                        罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function MarcDesm( lTodos )

Local nX := 0

For nX := 1 to Len(_aListBox)
	If lTodos
		_aListBox[nX,1] := .T.
	Else
		_aListBox[nX,1] := .F.
	EndIf
Next nX

oList:Refresh()

Return Nil


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Alterar Percentual do Aditamento                   ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
Static Function Altperc(oList)
Local _nMValp          := 0
Local _nValp           := 0
Local _cFunction       := ""
Local nRowList
Local cPict
Local oDlgEdit
Local oDlgGet
Local oDlgBtn
Local aDim := {}
Local oRect:= tRect():New(0,0,0,0) // obt閙 as coordenadas da c閘ula
Local nVlrAdto:= 0     

Local nValor1 := 0
Local nValor2 := 0

_cFunction := FUNNAME()

oList:GetCellRect (4,,oRect)   // a janela de edi玢o deve ficar
aDim := {oRect:nTop,oRect:nLeft,oRect:nBottom,oRect:nRight}

nRowList := oList:nAt
xEdit    := oList:aArray[nRowList, xPercMedicao]

cPict:= If(ValType(xEdit) == "N", "@ER 999.99%", "")

_nMValp := oList:aArray[nRowList, xVlrMedicao]  // xVlrTitulo]

//FOR n := 1 TO Len(oList:aArray)
//    IF oList:aArray[n, xMarcado]
//       _nMValp := oList:aArray[nRowList, 9]  // xVlrTitulo]
//    EndIf
//NEXT

Do While .T.

    DEFINE MSDIALOG oDlgEdit OF oList:oWnd  FROM 0, 0 TO 0, 0 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL
    oList:lDisablePaint := .f.

    @ 0,0 MSGET  oDlgGet VAR xEdit SIZE 0,0 OF oDlgEdit FONT oList:oFont PICTURE cPict  PIXEL HASBUTTON
    @ 0,0 BUTTON oDlgBtn PROMPT "Dummy" SIZE 0,0 OF oDlgEdit    //o bot鉶 dummy ? usado apenas para permitir a troca de foco
    oDlgBtn:bGotFocus := {|| oDlgEdit:nLastKey := VK_RETURN, oDlgEdit:End(0)}

    // posiciona o get
    oDlgGet:Move(-2,-2, aDim[4]-aDim[2]+4 ,aDim[3]-aDim[1]+4 )

    // posiciona dialogo sobre a celula
    oDlgEdit:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])


    ACTIVATE MSDIALOG oDlgEdit

IF Empty(CND->CND_DATAFI)  //  CND_DTFIM

    // calcula o valor pelo percentual informado
    _nValp := ((xEdit*_nVlTot)/100)

    If xEdit > 100
       Aviso("Percentual Adiantamento", "Valor informado n鉶 poder? ser maior que 100%", {" Ok "})
       Loop
    ElseIf xEdit < 0
       Aviso("Percentual Adiantamento", "Dever? ser informado um valor positivo", {" Ok "})
       Loop
    //Valor por % informado  > Valor da Medi玢o
    ElseIf  _nValp  > _nMValp .OR. _nValp > oList:aArray[nRowList, xVlrMedicao]  // xValorAdto
       Aviso("Percentual Adiantamento", "Informar um % que resulte valor inferior ao adiantamento", {" Ok "})
       Loop
    Else
    	/*
    		Avalia se o valor do adiantamento eh maior que o saldo do adiantamento.
    	*/
    
       nVlrAdto	:= oList:aArray[nRowList, xValorAdto]
       
       If _nValp > nVlrAdto
			_nValp := nVlrAdto   
       EndIf
           
       oList:aArray[nRowList, xPercMedicao] := xEdit
       oList:aArray[nRowList, xVlrTitulo]   := _nValp
       oList:Refresh()
       

	   		
       // DbSelectArea("FIE")             //Contratos   -   TP_CONT = 1 - Compras
       // DbSetOrder(3)
       // IF (DbSeek(xFilial("FIE")+"P"+CND->CND_FORNEC+CND->CND_LJFORN+"ADT"+_aListBox[oList:nAt,xNumTitulo]))
       //    _nVlSom = FIE->FIE_SALDO
       // ENDIF
       
       
       // Validacao do saldo do contrato
       // _nMValp 		Valor da Medicao
       // nCN9_SALDO    Valor do saldo do Contrato
       // nVlrAdto      Valor do adiantamento
       // _nValp        Valor a Compensar
      
 //      	If (nVlrAdto - _nValp ) > ( _nMValp - nCN9_SALDO )
 //			Aviso("Medicao Encerrada n鉶 poder? ser alterado","Saldo do contrato n鉶 poder? ser menor que o adiantamento."+CRLF+"1-Utilize o restante do adiantamento do contrato"+CRLF+"2-Inicie uma revis鉶 contratual.", {" Ok "})       
 //     	Else

	       	//Gravar o valor alterado na tabela CNx
	       	DbSelectArea("CNX")             //Contratos   -   TP_CONT = 1 - Compras
	       	DbSetOrder(1)                                                    
	       	IF (DbSeek(xFilial("CNX")+oList:aArray[nRowList, xNumContrato] + oList:aArray[nRowList, xCNX_NUMERO]  ))//+oList:aArray[nRowList, xNumTitulo])) //Filial+Contrato+Numero
	           	RecLock("CNX", .F.)
	           		CNX->CNX_XVLORI  := _nValp
	           		CNX->CNX_XPERC   :=  xEdit
	  	       	MsUnlock()
	           //Aviso("Percentual Adiantamento", "Adiantamento: " + Transform(_nVlSom,"@E 999,999,999.99" ) + "  Saldo Contrato: "+Transform(CN9->CN9_SALDO,"@E 999,999,999.99" ), {" Ok "})
		   	ENDIF
		
  		EXIT
       
    Endif
ELSE
       Aviso("Percentual Adiantamento", "Medicao Encerrada n鉶 poder? ser alterado", {" Ok "})
     EXIT
ENDIF

Enddo

oList:SetFocus()

If oList:aArray[oList:nAt, xPercMedicao] # 0 .And. (! oList:aArray[oList:nAt, xMarcado])
  oList:aArray[oList:nAt, xMarcado] := .T.
ElseIf oList:aArray[oList:nAt, xPercMedicao] == 0 .And. oList:aArray[oList:nAt, xMarcado]
  oList:aArray[oList:nAt, xMarcado] := .F.
Endif
  
Return(.T.)


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Excluir Percentual do Aditamento                     ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
Static Function Excper(oList)
Local nRowList := oList:nAt

If Aviso("Marca玢o Adiantamentos", "Confirma exclus鉶 do adiantamento da medi玢o?", {" N鉶 ", " Sim "}) <> 2
	Return
Endif

//Excluir o registro na tabela CNx
DbSelectArea("CNX")
DbSetOrder(1)
DbSeek(xFilial("CNX")+oList:aArray[nRowList, xNumContrato]+oList:aArray[nRowList, xNumTitulo])    //+M->CNX_CONTRA+M->CNX_NUMERO
RecLock("CNX", .F.)
dbDelete()
MsUnlock()

Return(.T.)

Static Function PastaTotais( oBjtLista )
Local nLinha	:= 0  
Local nValor1	:= 0
Local nValor2	:= 0

FOR nLinha := 1 TO Len(oBjtLista:aArray)
    IF oBjtLista:aArray[nLinha, xMarcado]
       nValor1 += 	oBjtLista:aArray[nLinha, xVlrMedicao]	// Valor da Medicao (ok)  
       nValor2 += 	oBjtLista:aArray[nLinha, xVlrTitulo]   	// Valor a Compensar (ok)
    EndIf
NEXT                        

M->CND_TOTADT	:= nValor2 	
nTotVlMed		:= M->CND_VLTOT - M->CND_TOTADT

Return(.T.)