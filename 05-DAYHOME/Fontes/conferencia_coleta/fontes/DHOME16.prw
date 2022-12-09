#Include 'Protheus.ch'                
#Include "FwBrowse.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"                                      
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RWMAKE.CH"
#Include "AP5MAIL.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Tbiconn.ch"
#INCLUDE "Tbicode.ch"

/*

EPP400110 = 099511710065
18PP190   = EPP400110      

*/

#Define ENTER CHR(13)+CHR(10)                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma   DHOME16   บAutor  ณ FONTANELLI         บ Data ณ  10/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia para ENTRADA de produtos.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DHOME16()

Private cCadastro 
Private cTitulo	  

Private oFont		:= TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Private oFont1 		:= TFont():New("Verdana",,024,,.T.,,,,,.F.,.F.)
Private oFont2 		:= TFont():New("Verdana",,038,,.T.,,,,,.F.,.F.)

Private cAliasTMP	:= ""
Private cArqTrab	:= ""
Private lExiste		:= .F.

cCadastro := "Confer๊ncia de ENTRADA de Produtos"
cTitulo	  := cCadastro

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Browse da tela inicial.                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

FwMsgRun( ,{|| CONFERIR()}, , 'Selecionando Registros, Por favor aguarde' )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFERIR   บAutor  ณ EthosX            บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia de saida de produtos.                          บฑฑ
ฑฑบ          ณ BROWSE.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CONFERIR()

Local oDlg
Private aSize 		:= {}
Private aObjects 	:= {}
Private aInfo  		:= {}
Private aPosObj 	:= {}
Private aPosGet 	:= {}
Private cFiltro	:= ""

Static oFWLayer
Static oFWLayer2
Static oWin1
Static oWin2
Static oWin3
Static oWin4
Static oWin5

aSize	:= MsAdvSize( .F. )
aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

AAdd( aObjects, { 100	, 050	, .T., .F. })
AAdd( aObjects, { 100	, 100	, .T., .T. })

aPosObj	:= MsObjSize(aInfo,aObjects)
aPosGet	:= MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

cFiltro	:= "C7_FILIAL=='"+xFilial("SC7")+"' .AND. DTOS(C7_DATPRF) >= '"+ALLTRIM(GetMv('MV_CONFPCD'))+"'" 

DbSelectArea("SC7")
SC7->( DbSetFilter( {|| &(cFiltro)},cFiltro ) )
SC7->(DbGotop())
	
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd STYLE nOR( WS_VISIBLE,WS_POPUP ) PIXEL

	oDlg:lEscClose := .F.
	
	oFWLayer := FWLayer():New()		
	oFWLayer:Init(oDlg,.F.)

	oFWLayer:AddCollumn("Col01",10,.T.)
	oFWLayer:AddCollumn("Col02",90,.T.)

	oFWLayer:AddWindow("Col01","Win01"	,"A็oes"	,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer:AddWindow("Col02","Win02"	,cCadastro	,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	
	oWin1 := oFWLayer:GetWinPanel('Col01','Win01')
	oWin2 := oFWLayer:GetWinPanel('Col02','Win02')

	// Bot๕es da tela
	oBtn0 := TButton():New(0,0,"Sair",oWin1,{|| oDlg:End() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn0:Align  := CONTROL_ALIGN_BOTTOM

	oBtn2 := TButton():New(0,0,"Inicia Conferencia",oWin1,{|| VeConf06('SC7',SC7->(Recno()),3) },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn2:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn22 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn22:Align  := CONTROL_ALIGN_TOP
	
	oBtn3 := TButton():New(0,0,"Altera Conferencia",oWin1,{|| VeConf06('SC7',SC7->(Recno()),4) },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn3:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn33 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn33:Align  := CONTROL_ALIGN_TOP
	
	oBtn4 := TButton():New(0,0,"Exclui Conferencia",oWin1,{|| VeConf06('SC7',SC7->(Recno()),5) },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn4:Align  := CONTROL_ALIGN_TOP
                                
	@ 000, 000 SAY oBtn44 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn44:Align  := CONTROL_ALIGN_TOP
	
	oBtn5 := TButton():New(0,0,"Finaliza Conferencia",oWin1,{|| VeConf06('SC7',SC7->(Recno()),6) },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn5:Align  := CONTROL_ALIGN_TOP
                                
	@ 000, 000 SAY oBtn55 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn55:Align  := CONTROL_ALIGN_TOP
	
	//oBtn6 := TButton():New(0,0,"eMail Conferencia",oWin1,{|| VaiMail('SC7',SC7->(Recno()),6) },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	//oBtn6:Align  := CONTROL_ALIGN_TOP
                                
	//@ 000, 000 SAY oBtn66 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	//oBtn66:Align  := CONTROL_ALIGN_TOP
	
	//Browse
	DEFINE FWBROWSE oBrowse DATA TABLE ALIAS "SC7" OF oWin2
		
	//Adiciona Legenda no Browse
	ADD LEGEND DATA 'C7_CONFST == "1" .OR. C7_CONFST == " "'	COLOR "ENABLE"		TITLE "Aguardando Confer๊ncia."				OF oBrowse
	ADD LEGEND DATA 'C7_CONFST == "2"'							COLOR "BR_LARANJA"	TITLE "Confer๊ncia Incompleta."				OF oBrowse
	ADD LEGEND DATA 'C7_CONFST == "3"' 							COLOR "DISABLE"		TITLE "Confer๊ncia Finalizada"			 	OF oBrowse

	// Adiciona as colunas do Browse
	ADD COLUMN oColumn DATA { || C7_FILIAL   	}	TITLE "Filial"     	 		SIZE  01 OF oBrowse
	ADD COLUMN oColumn DATA { || C7_NUM	  	 	}	TITLE "Pedido"     	 		SIZE  06 OF oBrowse
	ADD COLUMN oColumn DATA { || C7_EMISSAO  	}	TITLE "Emissao"     		SIZE  08 OF oBrowse
	ADD COLUMN oColumn DATA { || C7_DATPRF  	}	TITLE "Entrega"     		SIZE  08 OF oBrowse
	ADD COLUMN oColumn DATA { || C7_ITEM  	 	}	TITLE "Item"     	 		SIZE  02 OF oBrowse
	ADD COLUMN oColumn DATA { || C7_PRODUTO	 	}	TITLE "Produto"      		SIZE  15 OF oBrowse
	ADD COLUMN oColumn DATA { || C7_DESCRI	 	}	TITLE "Descricao"      		SIZE  30 OF oBrowse
	ADD COLUMN oColumn DATA { || C7_FORNECE  	}	TITLE "Fornecedor"     		SIZE  06 OF oBrowse
	ADD COLUMN oColumn DATA { || C7_LOJA	  	}	TITLE "Loja"	     		SIZE  02 OF oBrowse
	ADD COLUMN oColumn DATA { || Posicione("SA2",1,xFilial("SA2") + C7_FORNECE + C7_LOJA, "A2_NOME")  }	TITLE "Nome" SIZE  40 OF oBrowse
		
	//Ativa o Browse
	ACTIVATE FWBROWSE oBrowse
		
ACTIVATE MSDIALOG oDlg CENTERED
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVeConf06   บAutor  ณ Ethosx	         บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia de saida de produtos.                          บฑฑ
ฑฑบ          ณ GetDados.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VeConf06(cAlias,nReg,nOpc)

Local nI
Local nUsado	:= 0
Local nOpca		:= 0
Local lWhen		:= .F.

Private cGetConf	:= SC7->C7_NUM
Private cGetData	:= Date()
Private cGetHora	:= "00:00"
Private cGetCod		:= SC7->C7_FORNECE
Private cGetLj		:= SC7->C7_LOJA
Private cGetNom		:= Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA, "A2_NOME")
Private cGetProd	:= space(15)
Private nQtd		:= 1

Private cGetUser	:= Space( 20 )
Private cMemoDv	:= ""
Private aHeader	:= {}
Private aCols	:= {}
Private aItens	:= {}
Private _oDlg
Private oGetdados
Private oGetProd
Private oQtd
Private oGetValor
Private INCLUI	:= (nOpc == 3)
Private ALTERA	:= (nOpc == 4)
Private EXCLUI	:= (nOpc == 5)
Private FINALI	:= (nOpc == 6)
Private nQtdConf	:= 0
Private oFont1	:= TFont():New("Verdana",,024,,.T.,,,,,.F.,.F.)
Private oFont2	:= TFont():New("Verdana",,044,,.T.,,,,,.F.,.F.)
Private oFont18	:= TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)

if SC7->C7_CONFST == "1" .And. ((ALTERA) .or. (EXCLUI))
	Aviso("Aviso","Escolha, Iniciar Conf๊rencia !", {"OK"})
	oBrowse:Refresh()
	oBrowse:SetFocus()
	Return
elseIf SC7->C7_CONFST == "3" .And. (INCLUI .or. ALTERA  .OR. FINALI)
	Aviso("Aviso","Escolha, Excluir Conf๊rencia !", {"OK"})
	oBrowse:Refresh()
	oBrowse:SetFocus()
	Return
ElseIf SC7->C7_CONFST == "2" .And. (INCLUI)
	Aviso("Aviso","Escolha, Alterar Conf๊rencia !", {"OK"})
	oBrowse:Refresh()
	oBrowse:SetFocus()
	Return
EndIf


If FINALI 
	if SC7->C7_CONFST == "2" 
		If MsgYesNo("Confirma a Finaliza็ใo ?")
			DbSelectArea("SC7")
			SC7->(DbSetOrder(1))
			SC7->(DbGotop())
			If SC7->(DbSeek(xFilial("SC7") + cGetConf))
				While !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == cGetConf
					RecLock("SC7",.F.)
					SC7->C7_CONFST := "3"  
					SC7->C7_XCDTFIN := dDataBase
					SC7->C7_XCHRFIN := SUBSTR(Time(),1,5)
					SC7->(MsUnlock())
					SC7->(DbSkip())
				EndDo
			
				SC7->(DbGotop())
				SC7->(DbSeek(xFilial("SC7") + cGetConf ))
			
				// EMAIL
				cHtmlPedido := u_MontaPedido(cGetConf)
				cHtml := u_GeraHtml(cHtmlPedido)
				u_EnviaEmail(cHtml,cGetConf)
				
				SC7->(DbGotop())
				SC7->(DbSeek(xFilial("SC7") + cGetConf ))
	
				oBrowse:Refresh()
				oBrowse:SetFocus()
			
			Endif	

			Return Nil
		Else
			Return Nil	
		EndIf
	elseif SC7->C7_CONFST == "3" 
    	Aviso("Aviso","Confer๊ncia jแ Finalizada !", {"OK"}) 
    	Return Nil	
	else
    	Aviso("Aviso","Nใo foi conferido nenhum Produto !", {"OK"})	
    	Return Nil
	EndIf
endif

cQuery := "SELECT C7_FILIAL, C7_NUM, C7_PRODUTO, SUM(C7_QUANT) C7_QUANT FROM "+RetSqlName("SC7")+" "
cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += "   AND C7_NUM = '"+SC7->C7_NUM+"' "
cQuery += "   AND D_E_L_E_T_ = '' "
cQuery += " GROUP BY C7_FILIAL, C7_NUM, C7_PRODUTO"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QrySC7",.T.,.T.)
dbSelectArea("QrySC7")
dbGoTop()
nQtdPrds := 0
While !QrySC7->(Eof())
	aAdd(aItens,{QrySC7->C7_PRODUTO,QrySC7->C7_QUANT})
	QrySC7->(DbSkip())
EndDo
QrySC7->(dbCloseArea())	



//Carrega o Header
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZZ2")
While !Eof() .And. X3_ARQUIVO == "ZZ2"
	If X3USO( X3_USADO ) .And. cNivel >= X3_NIVEL
		if alltrim(X3_CAMPO) <> "ZZ2_NOTA" .AND. alltrim(X3_CAMPO) <> "ZZ2_SCX" .AND. alltrim(X3_CAMPO) <> "ZZ2_CAIXA" 
			aAdd( aHeader, { Trim( X3Titulo() ), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
			nUsado++
		endif	
	Endif
	dbSkip()
Enddo

cGetConf 	:= SC7->C7_NUM
cGetHora	:= SubStr(Time(),1,5)
cGetUser	:= cUserName
lWhen		:= .T.

If INCLUI
	aAdd( aCols, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
			aCols[1, nI] := CriaVar( aHeader[nI, 2])
	Next nI
	aCols[1, Len( aHeader )+1 ] := .F.
Else

	DbSelectArea("ZZ2")
	ZZ2->(DbSetOrder(1))
	ZZ2->(DbSeek(xFilial("ZZ2") + "E" + SC7->C7_NUM ))
	While !ZZ2->(Eof()) .And. ZZ2_FILIAL == xFilial("ZZ2") .AND. SC7->C7_NUM == ZZ2->ZZ2_NUM .AND. "E" == ZZ2->ZZ2_TIPOSC

		aAdd( aCols, Array( Len( aHeader ) + 1 ) )
		
		For nI := 1 To Len( aHeader )
				aCols[Len(aCols), nI] := &(Alltrim(aHeader[nI, 2]))
		Next nI

		aCols[Len(aCols), Len( aHeader )+1 ] := .F.

		ZZ2->(DbSkip())
	EndDo        
		
    nQtdConf := 0
	For nI := 1 To Len(aCols)
			nQtdConf += aCols[nI,3]
	Next nI
	
EndIf

DEFINE MSDIALOG _oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	oFWLayer2 := FWLayer():New()		
	oFWLayer2:Init(_oDlg,.F.)

	oFWLayer2:AddCollumn("Col03",10,.T.)
	oFWLayer2:AddCollumn("Col04",90,.T.)

	oFWLayer2:AddWindow("Col03","Win03"	,"A็oes"			,040,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col03","Win06"	,"Controle"			,060,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win04"	,"Dados do pedido"	,040,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win05"	,"Itens do pedido"	,060,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)

	oWin3 := oFWLayer2:GetWinPanel("Col03","Win03")
	oWin6 := oFWLayer2:GetWinPanel("Col03","Win06")
	oWin4 := oFWLayer2:GetWinPanel("Col04","Win04")
	oWin5 := oFWLayer2:GetWinPanel("Col04","Win05")

	@ 000, 000 BTNBMP oBitmap1  RESNAME "FINAL"  SIZE 008, 035 OF oWin6 MESSAGE "Sair" Action( _oDlg:End() )
	oBitmap1:cCaption := " <F4>"
	oBitmap1:Align  := CONTROL_ALIGN_BOTTOM
	SetKey(VK_F4 ,{|| _oDlg:End() })

	@ 000, 000 SAY oSay7 PROMPT Space(100)				SIZE 049, 005 OF oWin6 COLORS CLR_RED,16777215 PIXEL
	oSay7:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oSay4 PROMPT "Itens Bipados"		SIZE 049, 007 OF oWin6 COLORS CLR_RED,16777215 PIXEL
	oSay4:Align  := CONTROL_ALIGN_TOP
	@ 000, 000 MSGET oGetValor VAR nQtdConf				SIZE 044, 014 OF oWin6 COLORS CLR_RED,16777215 WHEN .F. PICTURE "@E 999999.00" FONT oFont18 PIXEL
	oGetValor:Align  := CONTROL_ALIGN_TOP	

	@ 000, 000 BTNBMP oBitmap2  RESNAME "OK"  SIZE 008, 035 OF oWin3 MESSAGE "Confirmar" Action( Iif(VE06Valid(""),(nOpcA:=1,_oDlg:End()),Nil) )
	oBitmap2:cCaption := "<F10>"
	oBitmap2:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F10,{|| Iif(VE06Valid(""),(nOpcA:=1,_oDlg:End()),Nil) })
		

	@ 005, 010 SAY oSay1 PROMPT "Pedido: " 			SIZE 055, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL
	@ 020, 010 SAY oSay3 PROMPT "Data: " 			SIZE 050, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL
	@ 035, 010 SAY oSay4 PROMPT "Hora: " 			SIZE 055, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL
	@ 050, 010 SAY oSay5 PROMPT "Usuแrio: "			SIZE 055, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL
	@ 065, 010 SAY oSay2 PROMPT "Cliente: "			SIZE 050, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL
	@ 065, 117 SAY oSay5 PROMPT "Loja: " 			SIZE 022, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL
	@ 080, 010 SAY oSay5 PROMPT "Nome: " 			SIZE 022, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL
	
	@ 005, 062 MSGET oGetConf 	VAR cGetConf		SIZE 050, 007 OF oWin4 COLORS 0, 16777215 PIXEL When .F.
	@ 020, 062 MSGET oGetData 	VAR cGetData		SIZE 050, 007 OF oWin4 COLORS 0, 16777215 PIXEL When .F.
	@ 035, 062 MSGET oGetHora 	VAR cGetHora		SIZE 050, 007 OF oWin4 COLORS 0, 16777215 PIXEL When .F.
	@ 050, 062 MSGET oGetUser 	VAR cGetUser		SIZE 050, 007 OF oWin4 COLORS 0, 16777215 PIXEL When .F.
	@ 065, 062 MSGET oGetCod	VAR cGetCod			SIZE 050, 007 OF oWin4 COLORS 0, 16777215 PIXEL When .F.
	@ 065, 142 MSGET oGetLj 	VAR cGetLj			SIZE 015, 007 OF oWin4 COLORS 0, 16777215 PIXEL When .F.
	@ 080, 062 MSGET oGetNom 	VAR cGetNom			SIZE 155, 007 OF oWin4 COLORS 0, 16777215 PIXEL When .F.

	@ 003, 154-20 GROUP oGroup TO 061, 570 PROMPT "" OF oWin4 COLOR 0, 16777215 PIXEL

	@ 010, 160-20 SAY oSay5 PROMPT "Quantidade: " 	SIZE 040, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL
	@ 010, 300-20 SAY oSay5 PROMPT "Produto: " 		SIZE 050, 007 OF oWin4 FONT oFont COLORS 16711680, 16777215 PIXEL

	@ 022, 160-20 MSGET oQtd 		VAR nQtd     SIZE 040, 030 OF oWin4 COLORS 0, 16777215 When lWhen FONT oFont2 Picture "99999" PIXEL 
	@ 022, 300-20 MSGET oGetProd 	VAR cGetProd SIZE 180, 030 OF oWin4 COLORS 0, 16777215 When lWhen FONT oFont2 Picture "@!" PIXEL Valid( VALCOD(nOpca) )

	oGetDados := MsNewGetDados():New(0,0,0,0,nOpc,,,,{""},,,,,,oWin5,aHeader,aCols)
	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetDados:oBrowse:bGotFocus := {|| oQtd:SetFocus() }	

	oQtd:SetFocus()
	 
ACTIVATE MSDIALOG _oDlg CENTERED


oBrowse:Refresh()
oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALCOD     บAutor  ณ Ethosx            บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia de saida de produtos.                          บฑฑ
ฑฑบ          ณ Validacao do produto.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VALCOD( nOpca )

Local nPosProd	:= 0
Local nPosAcol	:= 0
Local nLenAcol	:= 0
Local lRet	:= .T.

If Empty(cGetProd)
	cGetProd := Space(15)
	oGetProd:Refresh()
	nQtd := 1
	oQtd:Refresh()
	oQtd:SetFocus()
	Return lRet
EndIf
      
if nQtd <= 0
		Alert("Quantidade Invalida !")
		lRet := .F.               
else            

	if (SUBSTR(cGetProd,1,2) == alltrim(cFilAnt) .AND. LEN(ALLTRIM(cGetProd)) == 10 ) 
		oGetValor:Refresh()
		oGetDados:Refresh()
        
		cGetProd := Space(15)
		oGetProd:Refresh()
		nQtd := 1
		oQtd:Refresh()    
		
		oQtd:SetFocus()
		
		Return(.T.)
	endif
	
                                                
	lAchou := .F.
	
	if GetMv("MV_CONFPRD")
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))// B1_FILIAL+B1_COD
		If SB1->(DbSeek(xFilial("SB1") + cGetProd ))
			lAchou := .T.
			cGetProd := SB1->B1_COD
		endif
	endif
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(16)) // B1_FILIAL+B1_EAN13
	If SB1->(DbSeek(xFilial("SB1") + cGetProd ))
		lAchou := .T.                        
		cGetProd := SB1->B1_COD
	endif

	DbSelectArea("SB1")
	SB1->(DbSetOrder(15))// B1_FILIAL+B1_DUN14D
	If SB1->(DbSeek(xFilial("SB1") + cGetProd ))
		lAchou := .T.
		cGetProd := SB1->B1_COD
	endif      
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(17)) // B1_FILIAL+B1_UPC12
	If SB1->(DbSeek(xFilial("SB1") + cGetProd ))
		lAchou := .T.                        
		cGetProd := SB1->B1_COD
	endif

	
	if lAchou 
	
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))// B1_FILIAL+B1_COD
		SB1->(DbSeek(xFilial("SB1") + cGetProd ))

		nPosProd := aScan(aItens, {|x| Alltrim(x[1]) == Alltrim(cGetProd)})
		If nPosProd > 0    
			nQtdBip := 0
			nQtdVen := aItens[nPosProd,2]
			For nI := 1 To Len(oGetDados:aCols)
				if alltrim(oGetDados:aCols[nI,1]) == alltrim(cGetProd) 
					nQtdBip += oGetDados:aCols[nI,3]
				EndIf
			Next nI 

			If Len(oGetDados:aCols) == 1 .And. Empty(oGetDados:aCols[1,1])
				oGetDados:aCols := {}
			endif    

			CDESCPROD := "["+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+SB1->B1_COD,"B1_UMRES"))+"] - "+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+SB1->B1_COD,"B1_DESC"))
				
			aAdd(oGetDados:aCols,{SB1->B1_COD,CDESCPROD,nQtd,Date(),SubStr(Time(),1,5),cUserName," "," ",.F.})
		
			nQtdConf := 0
			aEval(oGetDados:aCols,{ |x| nQtdConf += x[3] })
		
			aSort(oGetDados:aCols,,,{|x,y| x[1] < y[1]})
			
		else
			Alert("Produto nใo esta no pedido de Compra !")
			lRet := .F. 
		EndIf
	Else
		Alert("	CODIGO DE BARRA nใo localizado !")
		lRet := .F.
	EndIf

endif
		    
	                                                                         
oGetValor:Refresh()
oGetDados:Refresh()

cGetProd := Space(15)
oGetProd:Refresh()
nQtd := 1
oQtd:Refresh()

if lRet
	oQtd:SetFocus()
endif	

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVE06Valid  บAutor  ณ Ethosx            บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia de saida de produtos.                          บฑฑ
ฑฑบ          ณ Validacao.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VE06Valid(Tipo)

Local lRet		:= .T.
Local lConfOk	:= .F.    

if TIPO = "finaliza"  

	lConfOk	:= .T.
	GrvZZ2(.T.)

ElseIf Len(oGetDados:aCols) == 1 .And. Empty(oGetDados:aCols[1,1]) .And. !EXCLUI

	Alert("Confer๊ncia sem Itens !")
	lRet := .F.

ElseIf (INCLUI .Or. ALTERA)

	GrvZZ2(.f.)

ElseIf EXCLUI

	GrvZZ2(.F.)

EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvZZ2     บAutor  ณ Ethosx            บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia de saida de produtos.                          บฑฑ
ฑฑบ          ณ Gravacao da ZZ2.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvZZ2(lConfOk)

Local nI
local cNUMERO := SC7->C7_NUM

DbSelectArea("SC7")
SC7->(DbSetOrder(1))
If SC7->(DbSeek(xFilial("SC7") + cNUMERO  ))
	While !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == cNUMERO
		RecLock("SC7",.F.)
		If lConfOk .And. (INCLUI .Or. ALTERA)
			SC7->C7_CONFST := "3"
			if Empty(SC7->C7_XCUSER) 	
				SC7->C7_XCUSER  := cUserName
				SC7->C7_XCDTINI := dDataBase	
				SC7->C7_XCHRINI := SUBSTR(Time(),1,5)
			endif
			SC7->C7_XCDTFIN := dDataBase
			SC7->C7_XCHRFIN := SUBSTR(Time(),1,5)
		ElseIf (INCLUI .Or. ALTERA)
			SC7->C7_CONFST	:= "2"
			IF INCLUI
				SC7->C7_XCUSER  := cUserName
				SC7->C7_XCDTINI := dDataBase	
				SC7->C7_XCHRINI := SUBSTR(Time(),1,5)
			endif	
		ElseIf EXCLUI
			SC7->C7_CONFST	:= "1"
			SC7->C7_XCUSER  := SPACE(30)
			SC7->C7_XCDTINI := CTOD("  /  /    ")
			SC7->C7_XCHRINI := SPACE(5)
			SC7->C7_XCDTFIN := CTOD("  /  /    ")
			SC7->C7_XCHRFIN := SPACE(5)
		EndIf
		SC7->(MsUnlock())

		SC7->(DbSkip())
	EndDo
EndIf

If (INCLUI .Or. ALTERA)

	// EXCLUIR TUDO
	DbSelectArea("ZZ2")
	ZZ2->(DbSetOrder(1))
	If ZZ2->(DbSeek(xFilial("ZZ2") + "E" + cNUMERO  ))
		While !ZZ2->(Eof()) .And. ZZ2_FILIAL == xFilial("ZZ2") .AND. ZZ2->ZZ2_NUM == cNUMERO .And. "E" == ZZ2->ZZ2_TIPOSC
			RecLock("ZZ2",.F.)
			ZZ2->(DbDelete())
			ZZ2->(MsUnlock())
			ZZ2->(DbSkip())
		EndDo
	EndIf

	For nI := 1 To Len(oGetDados:aCols)

		RecLock("ZZ2",.T.)
		ZZ2->ZZ2_FILIAL := xFilial("ZZ2")
		ZZ2->ZZ2_TIPOSC := "E"
		ZZ2->ZZ2_NUM    := cNUMERO
		ZZ2->ZZ2_PRODUT := oGetDados:aCols[nI,1]
		ZZ2->ZZ2_DESC   := "["+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+oGetDados:aCols[nI,1],"B1_UMRES"))+"] - "+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+oGetDados:aCols[nI,1],"B1_DESC"))
		ZZ2->ZZ2_QTDLID := oGetDados:aCols[nI,3]
		ZZ2->ZZ2_DATA   := oGetDados:aCols[nI,4]
		ZZ2->ZZ2_CAIXA  := "N/A"
		ZZ2->ZZ2_NOTA   := "N/A"
		ZZ2->ZZ2_HORA   := oGetDados:aCols[nI,5]
		ZZ2->ZZ2_USER   := oGetDados:aCols[nI,6]            
		ZZ2->(MsUnlock())
	
	Next nI

ElseIf EXCLUI

	DbSelectArea("ZZ2")
	ZZ2->(DbSetOrder(1))
	If ZZ2->(DbSeek(xFilial("ZZ2") + "E" + cNUMERO  ))
		While !ZZ2->(Eof()) .And. ZZ2_FILIAL == xFilial("ZZ2") .AND. ZZ2->ZZ2_NUM == cNUMERO .And. "E" == ZZ2->ZZ2_TIPOSC
			RecLock("ZZ2",.F.)
			ZZ2->(DbDelete())
			ZZ2->(MsUnlock())
			ZZ2->(DbSkip())
		EndDo
	EndIf

EndIf

SC7->(DbGotop())
SC7->(DbSeek(xFilial("SC7") + cNUMERO ))

oBrowse:Refresh()
oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VaiMail  บAutor  ณ Ethosx	         บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Email de conferenica.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VaiMail(cAlias,nReg,nOpc)

cNUMERO := SC7->C7_NUM

cHtmlPedido := u_MontaPedido(cNUMERO)
cHtml := u_GeraHtml(cHtmlPedido)
u_EnviaEmail(cHtml,cNUMERO)

SC7->(DbGotop())
SC7->(DbSeek(xFilial("SC7") + cNUMERO ))
							
Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta Pedido																	  |
//ณ																				  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function MontaPedido(_cPedido)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณP E D I D O    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	

	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	SC7->(DbGotop())
	SC7->(dbSeek(xfilial("SC7")+_cPedido))

	cMenPED := '<table border="1" width="100%">'
	
	cMenPED += '<tr>'
	cMenPED += '<td width="25%"><b><font size="2"> <font color="#0000FF" face="Verdana">'
	cMenPED += "Filial" 
	cMenPED += '</font> </font></b></td>'
	cMenPED += '<td width="75%"><font face="Verdana" size="2">'
	cMenPED += SC7->C7_FILIAL+"-"+SM0->M0_FILIAL
	cMenPED += '</font></td>'
	cMenPED += '</tr>'
	
	cMenPED += '<tr>'
	cMenPED += '<td width="25%"><b><font size="2"> <font color="#0000FF" face="Verdana">'
	cMenPED += "Pedido de Compra" 
	cMenPED += '</font> </font></b></td>'
	cMenPED += '<td width="75%"><font face="Verdana" size="2">'
	cMenPED += SC7->C7_NUM
	cMenPED += '</font></td>'
	cMenPED += '</tr>'
	
	cMenPED += '<tr>'
	cMenPED += '<td width="25%"><b><font size="2"> <font color="#0000FF" face="Verdana">'
	cMenPED += "Emissใo" 
	cMenPED += '</font> </font></b></td>'
	cMenPED += '<td width="75%"><font face="Verdana" size="2">'
	cMenPED += DTOC(SC7->C7_EMISSAO)
	cMenPED += '</font></td>'
	cMenPED += '</tr>'
		
	cMenPED += '<tr>'
	cMenPED += '<td width="25%"><b><font size="2"> <font color="#0000FF" face="Verdana">'
	cMenPED += "Fornecedor" 
	cMenPED += '</font> </font></b></td>'
	cMenPED += '<td width="75%"><font face="Verdana" size="2">'
	cMenPED += SC7->C7_FORNECE+"/"+SC7->C7_LOJA+" "+Upper(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME"))		
	cMenPED += '</font></td>'
	cMenPED += '</tr>'

	// ITEM HTML
	
	cMenPED += '</table>'                       
	cMenPED += '<table border="1" width="100%">'
	
	cMenPED += '<tr>'
	                          
	//Item
	cMenPED += '<td width="2%"><b><font color="#0000FF" face="Verdana" size="2">'
	cMenPED += "Item" 
	cMenPED += '</font></b></td>'
	      
	//Entrega
	cMenPED += '<td width="3%"><b><font color="#0000FF" face="Verdana" size="2">'
	cMenPED += "Entrega" 
	cMenPED += '</font></b></td>'
	        
	//Produto
	cMenPED += '<td width="50%"><b><font color="#0000FF" face="Verdana" size="2">'
	cMenPED += "Produto" 
	cMenPED += '</font></b></td>'
	         
	//Quantidade
	cMenPED += '<td width="3%"><b><font color="#0000FF" face="Verdana" size="2">'
	cMenPED += "QTD" 
	cMenPED += '</font></b></td>'
	
	//Bipado
	cMenPED += '<td width="3%"><b><font color="#0000FF" face="Verdana" size="2">'
	cMenPED += "Bipado" 
	cMenPED += '</font></b></td>'

	cMenPED +=   '</tr>'
	
	nTOTQTD := 0
	nTOTBIP := 0

	_aitens := {}             
	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xfilial("SC7")+_cPedido))
	While !EOF() .and. ( _cPedido == SC7->C7_NUM )          

		cQuery := "SELECT SUM (ZZ2_QTDLID) TOTAL FROM "+RetSqlName("ZZ2")+" "
		cQuery += " WHERE ZZ2_FILIAL = '"+xFilial("ZZ2")+"' "
		cQuery += "   AND ZZ2_TIPOSC = 'E' "
		cQuery += "   AND ZZ2_NUM = '"+SC7->C7_NUM+"' "
		cQuery += "   AND ZZ2_PRODUT = '"+SC7->C7_PRODUTO+"' "
		cQuery += "   AND D_E_L_E_T_ = '' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QryZZ2",.T.,.T.)
		dbSelectArea("QryZZ2")
		nBIP := QryZZ2->TOTAL
		QryZZ2->(dbCloseArea())	

		aAdd(_aitens,{SC7->C7_ITEM,DTOC(SC7->C7_DATPRF),SC7->C7_PRODUTO+" "+upper(Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")),Transform(SC7->C7_QUANT,"999999"),Transform(nBIP,"999999") })				
		nTOTQTD := nTOTQTD + SC7->C7_QUANT
		nTOTBIP := nTOTBIP + nBIP
		SC7->(dbSkip())

	EndDo  
	
	aAdd(_aitens,{"","","T O T A L",Transform(nTOTQTD,"999999"),Transform(nTOTBIP,"999999")})				

	For nCont := 1 To Len(_aitens)
	
		cMenPED += '<tr>'
		            
		//Item
		cMenPED += '<td width="2%"><font face="Verdana" size="2">'
		cMenPED += Iif(!Empty(_aitens[nCont][1]),_aitens[nCont][1],' ') 
		cMenPED += '</font></td>'
	                                                                
		//Entrega	
		cMenPED += '<td width="8%"><font face="Verdana" size="2"><div align="center">'
		cMenPED += Iif(!Empty(_aitens[nCont][2]),_aitens[nCont][2],' ') 
		cMenPED += '</div></font></td>'
		 
		//Poduto
		cMenPED += '<td width="10%"><font face="Verdana" size="2">'
		cMenPED += Iif(!Empty(_aitens[nCont][3]),_aitens[nCont][3],' ') 
		cMenPED += '</font></td>'

		// Quantidade
		cMenPED += '<td width="10%"><font face="Verdana" size="2"> <div align="right">'
		cMenPED += Iif(!Empty(_aitens[nCont][4]),_aitens[nCont][4],' ') 
		cMenPED += '</div></font></td>'

		// Bip
		cMenPED += '<td width="10%"><font face="Verdana" size="2"> <div align="right">'
		cMenPED += Iif(!Empty(_aitens[nCont][5]),_aitens[nCont][5],' ') 
		cMenPED += '</div></font></td>'
			
		cMenPED +=  '</tr>'           
		
	Next nCont

	cMenPED += '</table>'                                                   

RETURN (cMenPED)

  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera HTML para constituicao do corpo de e-mail.								  |
//ณ																				  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function GeraHtml(cHTMLPEDIDO)

chtml:= ""
chtml+='<!doctype html>'
chtml+='<html>'
chtml+='<head>'
chtml+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
chtml+='<title>[titulo]</title>'
chtml+='</head>'
chtml+='<body>'
chtml+='<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">'
chtml+='  <tr>'
chtml+='	  <td width="300" align="right" valign="middle"><font color="#EF7622" size="5" face="Arial">C O N F E R E N C I A</font><br>'
chtml+='      </td>'
chtml+='  </tr>'
chtml+='  <tr>'
chtml+='    <td width="20" align="left" style="pedding-bottom=5px;" width="20" height="20" style="padding-bottom:10px" alt=""/><br></td>'
chtml+='      </td>'
chtml+='  </tr>'
chtml+='  <tr>'
chtml+='    <td height="22" colspan="2" align="left" bgcolor="#EF7622" style="padding-left:6px; padding-right:6px;"><strong><font face="Arial" size="1" color="#FFFFFF">'
chtml+= alltrim(DiaSemana(ddatabase))+", "
chtml+= substr(dtos(ddatabase),7,2)+ " de "
chtml+= MesExtenso(substr(dtos(ddatabase),5,2)) + " de "
chtml+= substr(dtos(ddatabase),1,4)
chtml+='  </font></strong></td>'
chtml+='  <tr>'
chtml+='    <td colspan="2" bgcolor="#FFFFFF"><table width="600" border="0" cellspacing="0" cellpadding="0">'
chtml+='        <tbody>'
chtml+='          <tr>'
chtml+='            <td width="580" bgcolor="#FFFFFF"><font face="Arial" size="2" color="#333333"> <br>'

chtml+='   '+ cHTMLPEDIDO +'<br><br>'

chtml+='</font> <font face="Arial" size="2" color="#333333"><br>'

chtml+='               <br>'
chtml+='           </tr>'
chtml+='         </tbody>'
chtml+='       </table></td>'
chtml+='   </tr>'
chtml+='     <td height="20" colspan="2" align="center" bgcolor="#EF7622" style="padding-left:6px; padding-right:6px;"><font face="Arial" size="1" color="#FFFFFF">DayHome - '+substr(dtos(ddatabase),1,4)+' - Todos os direitos reservados</font></td>'
chtml+='   </tr>'
chtml+=' </table>'
chtml+=' </body>'
chtml+=' </html>'

RETURN(chtml)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEnvia e-mail								  |
//ณ																				  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function EnviaEmail(cHtml,yPedido)


lSmtpSSL  := GetMV("MV_RELSSL")
lSmtpTLS  := GetMV("MV_RELTLS")
lAuteSMTP := GetNewPar("MV_RELAUTH",.F.)
cServSMTP := GetMV("MV_RELSERV")
cUserSMTP := GetMV("MV_RELACNT")
cPassSMTP := GetMV("MV_RELPSW")
cUserFrom := GetMV("MV_RELFROM")                     

cAssunto 	:= "Listagem da Conferencia do Pedido de Compra: "+yPedido
cPara		:= ALLTRIM(GetMv('MV_CONFMAI'))
cMensagem	:= cHtml

lResult := .f. 

if !lSmtpSSL .AND. !lSmtpTLS
	CONNECT SMTP SERVER cServSMTP ACCOUNT cUserSMTP PASSWORD cPassSMTP RESULT lResult 
endif

if lSmtpSSL .AND. lSmtpTLS
	CONNECT SMTP SERVER cServSMTP ACCOUNT cUserSMTP PASSWORD cPassSMTP RESULT lResult SSL TLS
endif
	
if lSmtpSSL .AND. !lSmtpTLS
	CONNECT SMTP SERVER cServSMTP ACCOUNT cUserSMTP PASSWORD cPassSMTP RESULT lResult SSL 
endif                                                                                     

if !lSmtpSSL .AND. lSmtpTLS
	CONNECT SMTP SERVER cServSMTP ACCOUNT cUserSMTP PASSWORD cPassSMTP RESULT lResult TLS
endif                                                                                     
                                 
If lResult .And. lAuteSMTP
    lResult := MailAuth( cUserSMTP, cPassSMTP )
    If !lResult
        lResult := QADGetMail() 
    EndIf
EndIf

If !lResult
    GET MAIL ERROR cError
   	    conout('Erro de Autenticacao no Envio de e-mail antes do envio: '+cError)
    Return
EndIf                                  

SEND MAIL FROM cUserFrom TO cPara CC "" SUBJECT cAssunto BODY cMensagem RESULT lResult 

If !lResult
    GET MAIL ERROR cError
    conout('Erro de Envio de e-mail: '+cError)
else
	conout('eMail enviado!')
EndIf

DISCONNECT SMTP SERVER

Return

