#Include "Protheus.ch"   
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#INCLUDE "FONT.CH"
#INCLUDE "TCBROWSE.CH"

/*
+===============================================================+
|Programa: COMP004 |Autor: Antonio Carlos |Data: 27/11/09       |
+===============================================================+
|Descricao: Politica de preço.                                  |
+===============================================================+
|Uso: Especifico Laselva                                        |
+===============================================================+
*/

User Function COMP004(cProduto)

Private cProd 		:= cProduto
Private _cPlata		:= ""
Private lInvFil		:= .F.

//DeVisual()
DeVisua()

Return

Static Function ConPrec(_lPlat,_cPlata,lInvFil,_nOpc)

Local oOk			:= LoadBitmap( GetResources(), "LBOK")
Local oNo			:= LoadBitmap( GetResources(), "LBNO")

Local aButtons		:= {{"PRODUTO"	, {||DeVisual()	},"Plataforma"	}}   

Private oPrc1
Private oPrc2

Private oDtIni
Private oDtIni

Private _nPrc1		:= 0
Private _nPrc2		:= 0		
Private nOpcA		:= 0
Private _dDtIni		:= CTOD("  /  /  ")
Private _dDtFim		:= CTOD("  /  /  ")
//Private lInvFil		:= .F.
Private aFilial		:= {}
Private cStrFilia	:= ""
Private cStrFil		:= ""
Private cStrGrupo	:= ""
Private cStrGrp		:= ""
Private cFiltrUsr	:= ""
Private cCadastro	:= "Politica de Preco"
Private oLstFilial

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()                                  
EndIf

cQry := " SELECT BZ_FILIAL, COALESCE(BZ_PRV1,0) AS BZ_PRV1, COALESCE(BZ_PRV2,0) AS BZ_PRV2, BZ_DATA1, BZ_DATA2 "
cQry += " FROM "+RetSqlName("SBZ")+" SBZ WITH(NOLOCK) "
If _nOpc == 1
	If !Empty(_cPlata) //.And. !lInvFil
		cQry	+= " INNER JOIN SIGA.dbo.sigamat_copia ON M0_CODFIL = BZ_FILIAL AND CodSetor IN ("+_cPlata+") AND M0_CODFIL <> '' "
	EndIf
EndIf	
cQry += " WHERE " 
If _nOpc == 2
	If !Empty(_cPlata)	
		cQry += " BZ_FILIAL IN ("+_cPlata+") AND "
	EndIf	
EndIf	
cQry += " BZ_COD = '"+cProd+"' AND "
cQry += " SBZ.D_E_L_E_T_ = '' "
cQry += " ORDER BY BZ_FILIAL "

TcQuery cQry NEW ALIAS "TMP"

DbSelectArea("TMP")	
TMP->( DbGoTop() )
If TMP->( !Eof() )
	While TMP->( !Eof() )
		Aadd(aFilial, {.F.,;
			TMP->BZ_FILIAL,;
			TMP->BZ_FILIAL+"-"+Posicione("SM0",1,Substr(cNumEmp,1,2)+TMP->BZ_FILIAL,"M0_FILIAL"),;
			Alltrim(Transform(TMP->BZ_PRV1,"@E 999,999,999.99")),;
			Alltrim(Transform(TMP->BZ_PRV2,"@E 999,999,999.99")),;
			Substr(TMP->BZ_DATA1,7,2)+"/"+Substr(TMP->BZ_DATA1,5,2)+"/"+Substr(TMP->BZ_DATA1,3,2) ,;
			Substr(TMP->BZ_DATA2,7,2)+"/"+Substr(TMP->BZ_DATA2,5,2)+"/"+Substr(TMP->BZ_DATA2,3,2)} )      
		TMP->( DbSkip() )	
	EndDo
Else	
	MsgStop("Nao existem registros para alteracao!")	
	Return(.F.)
EndIf

If Select("TMP") > 0
	DbSelectArea("TMP")                                                                         
	DbCloseArea()
EndIf	

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 500,760 OF oMainWnd PIXEL

DEFINE FONT oFontBold   NAME 'Times New Roman' SIZE 11, 15 Bold

@ 20,10 SAY "Preco 1:" Font oFontBold PIXEL
@ 30,10 MSGET oPrc1 VAR _nPrc1 PICTURE "@E 999,999,999.99" SIZE 80,10 Font oFontBold OF oDlg PIXEL

@ 20,100 SAY "Preco 2:" Font oFontBold PIXEL
@ 30,100 MSGET oPrc2 VAR _nPrc2 PICTURE "@E 999,999,999.99" SIZE 80,10 Font oFontBold OF oDlg PIXEL

@ 20,190 SAY "Data Inicio:" Font oFontBold PIXEL
@ 30,190 MSGET oDtIni VAR _dDtIni SIZE 80,10 Font oFontBold OF oDlg PIXEL

@ 20,280 SAY "Data Fim:" Font oFontBold PIXEL
@ 30,280 MSGET oDtFim VAR _dDtFim SIZE 80,10 VALID( oDtIni:SetFocus() ) Font oFontBold OF oDlg PIXEL

//Group Box de Filiais
@ 50,30  TO 240,350 LABEL "Filiais" OF oDlg PIXEL

@ 60,45  CHECKBOX oChkInvFil VAR lInvFil PROMPT "Inverter Selecao" SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aFilial , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oLstFilial:Refresh(.F.)) //"Inverter Selecao"
//@ 60,45  CHECKBOX oChkInvFil VAR lInvFil PROMPT "Inverter Selecao" SIZE 50, 10 OF oDlg PIXEL 
@ 70,40  LISTBOX  oLstFilial VAR cVarFil Fields HEADER "","Filial","Nome","Preco 1","Preco 2","Dt.Inicio","Dt.Fim";
SIZE 300,160 ON DBLCLICK (aFilial:=LSVTroca(oLstFilial:nAt,aFilial),oLstFilial:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstFilial,oOk,oNo,@aFilial) OF oDlg PIXEL	
oLstFilial:SetArray(aFilial)
oLstFilial:bLine := { || {If(aFilial[oLstFilial:nAt,1],oOk,oNo),aFilial[oLstFilial:nAt,2],aFilial[oLstFilial:nAt,3],aFilial[oLstFilial:nAt,4],aFilial[oLstFilial:nAt,5],;
aFilial[oLstFilial:nAt,6],aFilial[oLstFilial:nAt,7]}}

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, { || GrvPreco() }, { ||  oDlg:End() },,  )

Return

Static Function LSVTroca(nIt,aArray)
aArray[nIt,1] := !aArray[nIt,1]
Return aArray

Static Function CTGrpUser(cCodGrup)

Local cName   := Space(15)
Local aGrupo  := {}

PswOrder(1)
IF	PswSeek(cCodGrup,.F.)
	aGrupo   := PswRet()
	cNameGrp := Upper(Alltrim(aGrupo[1,2]))
EndIF
IF cCodGrup == "******"
	cNameGrp := "Todos"
EndIF

Return(cNameGrp)

Static Function GrvPreco()

Local aArea 		:= GetArea()
Local _nCont		:= 0
Local aRetUsu		:= {}		
Private cCTGrpUser	:= ""

PswOrder(2)
If PSWSEEK(cUserName,.T.)
	PswOrder(3)
	aRetUsu := PswRet()
	For nX := 1 to Len(aRetUsu[1][10])
		cCTGrpUser += "/" + IIF(!EMPTY(ALLTRIM(CTGrpUser(aRetUsu[1][10][nX]))),CTGrpUser(aRetUsu[1][10][nX]),aRetUsu[1][10][nX]) + "/"
	Next nX
EndIf

//If ("PRODUTOS" $ cCTGrpUser) .Or. ("000027" $ cCTGrpUser) .Or.("Administrador" $ cUserName) .or. (__cUserId $ GetMv('LA_PODER'))
If ("PRODUTOS" $ cCTGrpUser) .Or. ("000027" $ cCTGrpUser) .Or. ("Administrador" $ cUserName ) .or. (__cUserId $ GetMv('LA_PODER'))
    
	If _dDtFim < _dDtIni
		MsgStop("Data invalida!")
	 	oDtFim:SetFocus()	
	 	Return(.F.)
	EndIf
	
	nPos := aScan(aFilial,{|x| x[1] == .T. }) 
			
	If !Empty(_nPrc2) .And. ( Empty(_dDtIni) .Or. Empty(_dDtFim) ) .And. nPos = 0
				
		MsgStop("Preencha os campos Inicio/Fim promocao!")			
		Return(.F.)
		    
	EndIf
		
	If ( Empty(_dDtIni) .And. Empty(_dDtFim) ) .And. !Empty(_nPrc2) .And. nPos = 0 
				
		MsgStop("Preencha o campo Preco 2!")			
		Return(.F.)
		    
	EndIf
	
	If !Empty(_nPrc1) .And. nPos = 0
				
		MsgStop("Preencha o campo Preco 1 ou selecione alguma filial!")			
		Return(.F.)
		    
	EndIf
		
	If ( !Empty(_dDtIni) .And. !Empty(_dDtFim) )	
	
		If ( _dDtIni < Date() )  .Or. ( _dDtFim < Date() ) 
				
			MsgStop("Data invalida para promocao!")			
			Return(.F.)
		
		EndIf	
		    
	EndIf
	
	//Alterado: Antonio - 02/02/11
	/*	
	If nPos = 0
		MsgStop("Selecione uma filial para processamento!")
		Return
	EndIf
	
	If Empty(_nPrc1) .And. Empty(_nPrc2)
		MsgStop("Preencha os campos de referente ao preco!")			
		Return(.F.)			
	EndIf
	
	If !Empty(_nPrc2)
	
		If ( Empty(_dDtIni) .Or. Empty(_dDtFim) )
			MsgStop("Preencha os campos Inicio/Fim promocao!")			
			Return(.F.)
		EndIf	
		
		If ( _dDtIni < Date() )  .Or. ( _dDtFim < Date() ) 
				
			MsgStop("Data invalida para promocao!")			
			Return(.F.)
		
		EndIf
		
		If _dDtFim < _dDtIni
			MsgStop("Data invalida!")
		 	oDtFim:SetFocus()	
	 		Return(.F.)
		EndIf
	
	EndIf
	*/

	For _nI := 1 To Len(aFilial)	
		
		If aFilial[_nI,1] == .T.
			DbSelectarea("SBZ")
			SBZ->( DbSetOrder(1) )  
			If SBZ->( DbSeek(aFilial[_nI,2]+cProd) )
				
				RecLock("SBZ",.F.)
						     
				//If !Empty(_nPrc1)
					SBZ->BZ_PRV1 := _nPrc1
				//EndIf
					
				If !Empty(_nPrc2)
					SBZ->BZ_PRV2 := _nPrc2
				EndIf
					
				If !Empty(_dDtIni)
					SBZ->BZ_DATA1 := _dDtIni
				EndIf
					
				If !Empty(_dDtFim)
					SBZ->BZ_DATA2 := _dDtFim
				EndIf
				
				SBZ->( MsUnLock() )
					
			EndIf
		EndIf
		
	Next _nI
			
	MsgInfo("Alteracao processada com sucesso!")
	oDlg:End()
	
Else
	MsgStop("Usuario sem permissao para efetuar alteracao!")	
EndIf	

RestArea(aArea)

Return

Static Function DeVisual()

Private oRadio
Private nRadio
Private nOpca := 1
Private oDlgVD

DEFINE MSDIALOG oDlgVD FROM  94,1 TO 273,293 TITLE OemToAnsi("Consulta Plataformas/Lojas") PIXEL 
	
@ 10,17 Say OemToAnsi("Selecione:") SIZE 150,7 OF oDlgVD PIXEL
	
@ 27,07 TO 72, 140 OF oDlgVD  PIXEL
	
@ 35,10 Radio 	oRadio VAR nRadio;
		ITEMS 	"Plataformas",;	
				"Lojas";			
				3D SIZE 100,10 OF oDlgVD PIXEL
	
DEFINE SBUTTON FROM 75,085 TYPE 1 ENABLE OF oDlgVD ACTION ( DeAtu(nOpca) )
DEFINE SBUTTON FROM 75,115 TYPE 2 ENABLE OF oDlgVD ACTION ( oDlgVD:End() )
	
ACTIVATE MSDIALOG oDlgVD CENTERED 

Return

Static Function DeAtu()

If nOpca == 1
	If nRadio == 1
		
		VPlataf(1)			
					
	ElseIf nRadio == 2
		
		VPlataf(2)			
			
	EndIf
		
EndIf

oDlgVD:End()
	
Return

Static Function VPlataf(nOpc)

Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")

Private oDlgP
Private oChkInvFil

Private aPlata		:= {}
Private cStrPlata	:= ""
Private cCadastro	:= IIf(nOpc==1,"Seleciona Plataforma","Seleciona Lojas")

_cLabel	:= IIf(nOpc==1,"Plataformas","Lojas")

lInvFil := .F.

DEFINE MSDIALOG oDlgP TITLE cCadastro FROM 0,0 To 380,400 OF oMainWnd PIXEL

//Group Box de Plataforma
@ 10,10  TO 150,197 LABEL _cLabel OF oDlgP PIXEL

//Grid de Plataformas/Lojas

If Select("TMPLAT") > 0 
	DbSelectArea("TMPLAT")
	DbCloseArea()
EndIf

If nOpc == 1
	cQryPlat := " SELECT CONVERT(VARCHAR(3),Codsetor) AS CODIGO, Descricao AS NOME FROM informatica.dbo.Setor ORDER BY Codsetor "
Else

	cQryPlat := " SELECT BZ_FILIAL AS CODIGO, M0_FILIAL AS NOME " 
	cQryPlat += " FROM "+RetSqlName("SBZ")+" SBZ (NOLOCK) "
	cQryPlat += " INNER JOIN SIGA.dbo.sigamat_copia ON M0_CODFIL = BZ_FILIAL "
	cQryPlat += " WHERE "
	cQryPlat += " BZ_COD = '"+cProd+"' AND "
	cQryPlat += " SBZ.D_E_L_E_T_ = '' "
	cQryPlat += " ORDER BY BZ_FILIAL "
		
EndIf

TcQuery cQryPlat NEW ALIAS "TMPLAT"

DbSelectArea("TMPLAT")
TMPLAT->( DbGoTop() )
While TMPLAT->( !Eof() )
	Aadd( aPlata, { .F.,TMPLAT->CODIGO,TMPLAT->NOME } )
	TMPLAT->( DbSkip() )
EndDo

//@ 60,30  CHECKBOX oChkInvFil VAR lInvFil PROMPT "Inverter Selecao" SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aPlata , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oLstPlata:Refresh(.F.)) //"Inverter Selecao"
@ 20,30  CHECKBOX oChkInvFil VAR lInvFil PROMPT "Visualiza todas" SIZE 50, 10 OF oDlgP PIXEL 
@ 30,25  LISTBOX  oLstPlata VAR cVarPlat Fields HEADER "","Codigo",IIf(nOpc==1,"Plataforma","Loja") SIZE 160,110 ON DBLCLICK (aPlata:=LSVTroca(oLstPlata:nAt,aPlata),oLstPlata:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstPlata,oOk,oNo,@aPlata) OF oDlgP PIXEL	
oLstPlata:SetArray(aPlata)
oLstPlata:bLine := { || {If(aPlata[oLstPlata:nAt,1],oOk,oNo),aPlata[oLstPLata:nAt,2],aPLata[oLstPLata:nAt,3] }}

DEFINE SBUTTON FROM 160,060 TYPE 1 ACTION( AtuDados(nOpc),oDlgP:End() )  ENABLE OF oDlgP
DEFINE SBUTTON FROM 160,110 TYPE 2 ACTION( oDlgP:End() ) ENABLE OF oDlgP

oChkInvFil:Refresh()

ACTIVATE MSDIALOG oDlgP CENTERED
	
Return

Static Function AtuDados(nOpcao)

AEval(aPlata, {|x| If(x[1]==.T.,cStrPlata+="'"+SubStr(x[2],1,TamSX3("B1_FILIAL")[1])+"'"+",",Nil)})
_cPlata	:= Substr(cStrPlata,1,Len(cStrPlata)-1)      

If Empty(_cPlata) .And. !lInvFil
	MsgStop("Selecione uma plataforma para processamento!")
	Return(.F.)
EndIf

ConPrec(.T.,_cPlata,lInvFil,nOpcao)

If Select("TMPLAT") > 0 
	DbSelectArea("TMPLAT")
	DbCloseArea()
EndIf

Return

Static Function DeVisua()

nOpcao := "0"

_cArq := "\system\comp001\"+RetCodUsr()+".txt"

If File(_cArq)

	FT_FUSE(_cArq)
	FT_FGotop()
	
	nLin := 1
	
	While ( !FT_FEof() )
				
		cLinha  := FT_FREADLN()
		
		If nLin == 1
			nOpcao := Alltrim(cLinha)
		ElseIf nLin == 2
			_cPlata := Alltrim(cLinha)	
		EndIf						
								
		FT_FSkip()
		nLin++
		
	EndDo  
			
EndIf

ConPrec(.T.,_cPlata,lInvFil,Val(nOpcao))

Return