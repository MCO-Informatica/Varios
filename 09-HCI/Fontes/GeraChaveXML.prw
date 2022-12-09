#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML00   บAutor  ณRoberto Souza       บ Data ณ  01/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface/Dialog de Aviso.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HFXML00()
  
Local aArea     := GetArea()
Local lRetorno  := .T.
Local nVezes    := 0
Private lBOSSKEY   := AllTrim(GetSrvProfString("BOSSKEY","0"))=="1"
Private lBtnFiltro := .F.
Private cAlias1    := "ZBX"
Private cAlias2    := "ZBY"
Private cFil1      := xFilial(cAlias1) 
                  
If !lBOSSKEY
	U_MyAviso("Aviso", "Uso Indevido.",{"OK"},3)
	Return
EndIf
If !AliasInDic(cAlias1)
	cMsgAviso := "Tabela "+cAlias1+" Nao encontrada." +CRLF	
	cMsgAviso += "Necessario executar o compatibilizador UpdIF001."+CRLF	
	U_MyAviso("Aviso", cMsgAviso,{"OK"},3)
	Return
EndIf

While lRetorno
	lBtnFiltro:= .F.
    lRetorno := U_HFXML00A(nVezes==0)
    nVezes++
    If !lBtnFiltro
    	Exit
    EndIf
EndDo
RestArea(aArea)

Return(Nil)




User Function HFXML00A(lInit,cAlias)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aPerg     := {}
Local lRetorno  := .T.
Local aIndArq   := {}
Local aFilPar   := {}

Private cCondicao := ""
Private bFiltraBrw
Private aFilBrw   := {}"
Private cCadastro := "Autoriza็ใo de uso Importa XML"
Private aRotina   := {  {"Pesquisar"      ,"AxPesqui"   ,0,1},;
						{"Libera็ใo"   	  ,"U_HFXML00C" ,0,3},;
					 	{"Importar"   	  ,"U_HFXML00D" ,0,2},;
					 	{"Visualizar"  	  ,"AxVisual"   ,0,2} }
//					 	{"Visualizar"	  ,"U_HFXML00B" ,0,2},;


Private aCores   := {}
Private cString  := "SA1"
Private aUserData:= {} 

	AADD(aCores,{"A1_MSBLQL $ ' 2'" ,"BR_VERDE" })
	AADD(aCores,{"A1_MSBLQL == '1'" ,"BR_VERMELHO" })

	MBrowse( 6,1,22,75,cString,,,,,2,aCores,/*cTopFun*/,/*cBotFun*/,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.T.,)

	lRetorno := .F.

Return(lRetorno)


Return                             



User Function HFXML00B( cAlias, nRecNo, nOpc )
Local nX        := 0
Local nCols     := 0
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oMainWnd  := Nil

Private aTela   := {}
Private aGets   := {}
Private aHeader := {}
Private aCols   := {}
Private bCampo  := { |nField| Field(nField) }

cCliente := SA1->A1_COD
clOJA    := SA1->A1_LOJA
cRAZAO   := SA1->A1_NOME
cCNPJ    := SA1->A1_CGC

nTotal := 0

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX:= 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbSeek(cFil1+(cAlias1)->&(cAlias1+'_CODCLI')+(cAlias1)->&(cAlias1+'_LOJCLI'))

While !Eof() .And. SA1->A1_COD == (cAlias1)->&(cAlias1+'_CODCLI') .And. SA1->A1_LOJA == (cAlias1)->&(cAlias1+'_CODCLI')
   aAdd(aCols,Array(nUsado+1))
   nCols ++
   nTotal ++
   
   For nX := 1 To nUsado
      If ( aHeader[nX][10] != "V")
         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
      Else
         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
      Endif
   Next nX
   
   aCols[nCols][nUsado+1] := .F.
   dbSelectArea(cAlias2)
   dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 TO 600,700 PIXEL
//EnChoice(cAlias, nRecNo, nOpc,,,,, aPos,, 3)

// Atualizacao do nome do cliente
@ 136,004 SAY "Cliente: "                                     SIZE 070,7 OF oDlg PIXEL
@ 136,024 SAY oCliente VAR cCliente                           SIZE 098,7 OF oDlg PIXEL

// Atualizacao do total
@ 136,240 SAY "Valor Total: "                                 SIZE 070,7 OF oDlg PIXEL
@ 136,270 SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 070,7 OF oDlg PIXEL

//u_Mod3AtuCli()
oGet := MsGetDados():New(75,2,130,315,nOpc)

ACTIVATE MSDIALOG oDlg CENTERED //ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()})

Return .T.


Static Function CriaHeader()
nUsado  := 0
aHeader := {}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias1)
While ( !Eof() .And. SX3->X3_ARQUIVO == cAlias1 )
   If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
      aAdd(aHeader,{ Trim(X3Titulo()), ;
                     SX3->X3_CAMPO   , ;
                     SX3->X3_PICTURE , ;
                     SX3->X3_TAMANHO , ;
                     SX3->X3_DECIMAL , ;
                     SX3->X3_VALID   , ;
                     SX3->X3_USADO   , ;
                     SX3->X3_TIPO    , ;
                     SX3->X3_ARQUIVO , ;
                     SX3->X3_CONTEXT } )
      nUsado++
   Endif
   dbSkip()
End
Return


//Libera Licen็as
User Function HFXML00C(cAlias, nRecNo, nOpc)
Local aArea := GetArea()
Local cCod  := SA1->A1_COD
Local cLoj  := ""
Local cMsg  := ""
Local lRet  := .T.
Local nPer  := 0
Local oDlg       
Private _cTitulo :='Gerar Chave'
Private _cTexto  :='Deseja realmente gerar chave do importa?'
Private _aBotoes :={"Demo", "Vendida"}
Private _opc     := 0
Private _nDiaVend:= 365

SA1->( dbSetOrder( 1 ) )

nPer := U_MyAviso("Pergunta","Deseja Gerar Chave do registro Selecionado ou para TODAS as Filiais(loja) do Cliente ?",{"Selecionado","TODOS"},2)
If nPer == 1
	cLoj  := SA1->A1_LOJA
	lRet  := .T.
ElseIf nPer == 2
	cLoj  := ""
	lRet  := .T.
Else
	cLoj  := SA1->A1_LOJA
	lRet  := .F.
EndIf


DO While Empty( cLoj )

	DEFINE MSDIALOG oDlg TITLE "C๓digo do Cliente" FROM 000,000 TO 200,350 PIXEL

	@ 020,010 Say "C๓digo do Cliente" SIZE 310,230 PIXEL OF oDlg
	@ 020,130 Get oCli VAR cCod When .T. SIZE 30,08 PIXEL OF oDlg

	@ 075,090 BUTTON "OK" SIZE 30,15 PIXEL OF oDlg ACTION oDlg:End()
	@ 075,130 BUTTON "Cancela" SIZE 30,15 PIXEL OF oDlg ACTION ( lRet:=.F.,oDlg:End() )

	ACTIVATE MSDIALOG oDlg CENTERED

	Exit

EndDo

if lRet
	//INCLUIR MENSAGEM 
	_opc := AVISO(_cTitulo, _cTexto, _aBotoes, 1)
	if _opc <> 1 .And. _opc <> 2
		lRet := .F.
	endif
EndIf

if lRet .and. _opc == 2
	//INCLUIR MENSAGEM 
	if AVISO(_cTitulo, 'Deseja informar a qtd de dias para gerar chave?', {"SIM", "NAO"}, 1) == 1
		DEFINE MSDIALOG oDlg TITLE "C๓digo do Cliente" FROM 000,000 TO 200,350 PIXEL

		@ 020,010 Say "Qtd Dias da Licen็a" SIZE 310,230 PIXEL OF oDlg
		@ 020,130 Get oCli VAR _nDiaVend When .T. SIZE 30,08 PIXEL OF oDlg VALID _nDiaVend > 0

		@ 075,090 BUTTON "OK" SIZE 30,15 PIXEL OF oDlg ACTION iif( _nDiaVend > 0, oDlg:End(), lRet:=.T.)
		@ 075,130 BUTTON "Cancela" SIZE 30,15 PIXEL OF oDlg ACTION ( lRet:=.F.,oDlg:End() )

		ACTIVATE MSDIALOG oDlg CENTERED
		
	endif
EndIf

if lRet

	If Empty( cLoj )
		SA1->( dbSeek( xFilial( "SA1" ) + cCod ) )
		Do While .Not. SA1->( Eof() ) .And. SA1->A1_COD == cCod
			ChvXML( @cMsg )
			SA1->( dbSkip() )
		EndDo
		If .Not. Empty( cMsg )
			Aviso("Aviso", cMsg,{"OK"},3)
		EndIf
	Else
		ChvXML()
	EndIf
Endif

SA1->( dbGoto( nRecNo ) )
RestArea( aArea )
Return( lRet )


//Gera Chave do Cliente Selecionado
Static Function ChvXML(cMsg)
Local lMsg := .F.    
cDir     := GetSrvProfString("STARTPATH","")
cRoot    := GetSrvProfString("ROOTPATH","")
cCodProd := "HF000001"
cVersion := "101"
cPathDest:= cRoot+cDir+"\xmlsource\key\"
cCNPJ    := SA1->A1_CGC//"60745411000138"    
DtValid  := Date()+_nDiaVend
DtDemo    := Date()+GetNewPar("MV_IMPDEMO",20)
                                                                                                   
If cMsg == NIL
	lMsg := .T.
	cMsg := ""
Endif

cPathDest:= StrTran(cPathDest,"\\","\")
MakeDir(cPathDest)

If _opc == 1	
	If cgc(cCNPJ)
		GeraKey(cCodProd,cVersion,cPathDest,cCNPJ,DtValid,DtDemo,_opc)
		
		cMsgAviso := "Chave de libera็ใo gerada com sucesso:"+CRLF
		cMsgAviso += "Produto: "+cCodProd+CRLF
		cMsgAviso += "NOME: "+SA1->A1_NOME+CRLF
		cMsgAviso += "CNPJ: "+cCNPJ+CRLF
		cMsgAviso += "Vencimento: "+dToc(DtDemo)+CRLF
		cMsgAviso += "Gerado em : "+cPathDest+CRLF
		If lMsg
			Aviso("Aviso", cMsgAviso,{"OK"},3)
		Else
			cMsg += cMsgAviso+CRLF
		Endif
		
	Else
		If lMsg
			Aviso("Aviso", "CNPJ invแlido!",{"OK"},3)
		Else
			cMsg += cCNPJ+" CNPJ invแlido!"+CRLF
		EndIf
	EndIf
	cMsg += " "+CRLF
Else
	If cgc(cCNPJ)
		GeraKey(cCodProd,cVersion,cPathDest,cCNPJ,DtValid,DtDemo,_opc)
		
		cMsgAviso := "Chave de libera็ใo gerada com sucesso:"+CRLF
		cMsgAviso += "Produto: "+cCodProd+CRLF
		cMsgAviso += "NOME: "+SA1->A1_NOME+CRLF
		cMsgAviso += "CNPJ: "+cCNPJ+CRLF
		cMsgAviso += "Vencimento: "+dToc(DtValid)+CRLF
		cMsgAviso += "Gerado em : "+cPathDest+CRLF
		If lMsg
			Aviso("Aviso", cMsgAviso,{"OK"},3)
		Else
			cMsg += cMsgAviso+CRLF
		Endif
		
	Else
		If lMsg
			Aviso("Aviso", "CNPJ invแlido!",{"OK"},3)
		Else
			cMsg += cCNPJ+" CNPJ invแlido!"+CRLF
		EndIf
	EndIf
	cMsg += " "+CRLF
EndIf

Return


//Gera a Chave Efetivamente
Static Function GeraKey(cCodProd,cVersion,cPathDest,cCNPJ,DtValid,DtDemo,_opc)
Local lRet := .F.		
Local cKey := ""
Local cBaseCNPJ := SUBSTR(cCNPJ,1,14) //8 pa 14 -SUBSTR(cCNPJ,1,8)- a Partir de 10 de abriu CNPJ exclusivo por filial.

cKey := cCodProd+;
		cBaseCnpj+;
	 	'HF-CONSULTING-XML'

cKey := Upper(Sha1(cKey))
If _opc == 1 
	cData:=	Encode64(Dtos(DtDemo)+cVersion)
Else
	cData:=	Encode64(Dtos(DtValid)+cVersion)
EndIf

cFinal := cKey + cData
memowrite(cPathDest+cCodProd+cBaseCNPJ+".hfc",cFinal)

Return(lRet)



//Importar sigaMat para o Cadstro de Cliente e Gerar as Chaves dos CNPJs
User Function HFXML00D()
Local aArea   := GetArea()
Local cSigMat := ""
Local cTipo   := ""
Local lRet    := .T.
Private aTipo := {}
Private aParam   := {" "}
Private aPerg    := {}
Private _cTitulo :='Gerar Chave'
Private _cTexto  :='Deseja realmente gerar chave do importa?'
Private _aBotoes :={"Demo", "Vendida"}
Private _opc     := 0 
Private _nDiaVend:= 365

aAdd( aTipo, "1=DBF (DBFCDX)    ")
aAdd( aTipo, "2=BTrieve (BTVCDX)")
aAdd( aTipo, "3=CTree (CTREECDX)")

aadd(aPerg,{2,"Tipo Arquivo","",aTipo,80,".T.",.T.,".T."})

aParam[01] := ParamLoad("Tipo Arquivo",aPerg,1,aParam[01])

If !ParamBox(aPerg,"Importa็ใo Sigamat",@aParam,,,,,,,"Tipo Arquivo",.T.,.T.)
	Return()
Else 
	cTipo := aParam[01]
EndIf

cSigMat := cGetFile("*.emp","SELECAO DO SIGAMAT",1,"SERVIDOR\data\",.T.,GETF_NOCHANGEDIR,.T.,.T.)

If .Not. Empty( cSigMat )
	//MsgRun("Processando Arquivo...","SigaMat", {|| lRet := ImpSigaMat(cTipo, cSigMat) })
	Processa( {|| lRet := ImpSigaMat(cTipo, cSigMat) },"Processando Arquivo...", "SigaMat", .t. )

EndIf

RestArea( aArea )
Return


//Importar sigaMat Escolhido
//Tipo, se ้ DBF, CTree ou Btriev
Static Function ImpSigaMat(cTipo, cSigMat)
Local lRet := .T.
Local lErr := .F.
Local lOK  := .F.
Local cChave := ""
Local lAchou := .f.
Local _cIndice,_dIndex,_nRec,_cEmp,_cCod,_cLoj,_nSaveSX8
Local cMsg := ""
Local cArq := ""
Local aStru:= {}
Private cMarcaOK := GetMark()

BEGIN SEQUENCE

	If cTipo == "1"
		dbUseArea(.T.,"DBFCDX",cSigMat,"SIG",.F.,.F.)
	ElseIf cTipo == "2"
		dbUseArea(.T.,"BTVCDX",cSigMat,"SIG",.F.,.F.)
	ElseIf cTipo == "3"
		dbUseArea(.T.,"CTREECDX",cSigMat,"SIG",.F.,.F.)
	Else
		dbUseArea(.T.,,cSigMat,"SIG",.F.,.F.)
	EndIf

RECOVER

	lErr := .T.

END SEQUENCE

If lErr
	Alert( "Nใo foi possivel Abrir o Arquivo "+cSigMat+". Verifique Se o tipo do Arquivo esta correto: "+cTipo )
   lRet := .F.
Endif

If lRet
	BEGIN SEQUENCE
		aStru := Temporario("SIG")
	 	cArq  := CriaTrab(aStru, .T.)
	  	DBUseArea(.T., __LocalDriver, cArq, "MAT", .T., .F.)

		DbSelectArea("MAT")
		_cIndice := CriaTrab(nil,.F.)
		_dIndex := "M0_CODIGO+M0_CODFIL"
		IndRegua("MAT",_cIndice,_dIndex,,)

		DbSelectArea("SIG")
		SIG->( dbGoTop() )
		Do While .Not. SIG->( Eof() )
		    dbSelectArea("SA1")
		    dbSetOrder(3)
		    cChave := SIG->M0_CGC
	    	lAchou := .f.
	    	if dbseek(xfilial("SA1")+cChave)
	       		lAchou := .t.
			EndIf
			DbSelectArea("MAT")
	   		RecLock( "MAT", .T. )
			FOR nI := 1 TO MAT->( FCount() )
				nPos := SIG->( FieldPos( MAT->( FieldName( nI ) ) ) )
				If nPos > 0
					MAT->( FieldPut( nI, SIG->(FieldGet(nPos)) ) )
				EndIf
			NEXT nI
			If .Not. lAchou
				MAT->M0_OK := cMarcaOK
			EndIf
			MAT->( dbUnLock() )
			DbSelectArea("SIG")
			SIG->( dbSkip() )
		EndDo
		DbSelectArea("SIG")
		DbCloseArea()
		DbSelectArea("MAT")
	RECOVER
		lErr := .T.
	END SEQUENCE

	If lErr
		Alert( "Nใo foi possivel Gerar Arquivo Temporario." )
		lRet := .F.
	Endif

EndIf

If lRet
	lRet := mkbrw()
	If .not. lRet
		dbSelectArea("MAT")
		DbCloseArea()
	EndIf
EndIf

//INCLUIR MENSAGEM 
_opc := AVISO(_cTitulo, _cTexto, _aBotoes, 1)
if _opc <> 1 .and. _opc <> 2
	lRet := .F.
endif

if lRet .and. _opc == 2
	//INCLUIR MENSAGEM 
	if AVISO(_cTitulo, 'Deseja informar a qtd de dias para gerar chave?', {"SIM", "NAO"}, 1) == 1
		DEFINE MSDIALOG oDlg TITLE "C๓digo do Cliente" FROM 000,000 TO 200,350 PIXEL

		@ 020,010 Say "Qtd Dias da Licen็a" SIZE 310,230 PIXEL OF oDlg
		@ 020,130 Get oCli VAR _nDiaVend When .T. SIZE 30,08 PIXEL OF oDlg VALID _nDiaVend > 0

		@ 075,090 BUTTON "OK" SIZE 30,15 PIXEL OF oDlg ACTION iif( _nDiaVend > 0, oDlg:End(), lRet:=.T.)
		@ 075,130 BUTTON "Cancela" SIZE 30,15 PIXEL OF oDlg ACTION ( lRet:=.F.,oDlg:End() )

		ACTIVATE MSDIALOG oDlg CENTERED
		
	endif
EndIf


If lRet
	_nRec := 0
	_cEmp := "##"
	_cCod := ""
	_cLoj := ""
	DbSelectArea("MAT")
	MAT->( dbGoBottom() )
	ProcRegua(MAT->(RecCount()))
	MAT->( dbGotop() )

    Do While .Not. MAT->( Eof() )
		IncProc("Procesando Registro ... " + MAT->M0_CGC )
		++_nRec
		If Empty( MAT->M0_OK )
			MAT->( dbSkip() )
			LOOP
		EndIf

	    dbSelectArea("SA1")
	    dbSetOrder(3)
	    cChave := MAT->M0_CGC
    	lAchou := lOk := .f.
    	if dbseek(xfilial("SA1")+cChave)
       		lAchou := .t.
     	Else
			if _cEmp != MAT->M0_CODIGO
				_cEmp := MAT->M0_CODIGO
				if dbseek(xfilial("SA1")+Substr(cChave,1,8))
					_cCod := SA1->A1_COD
				Else
					_nSaveSX8 := GetSX8Len()
					_cCod := GETSXENUM("SA1","A1_COD")
					While ( GetSX8Len() > _nSaveSX8 )
						ConfirmSX8()
					EndDo
				endif
			    dbSelectArea("SA1")
			    dbSetOrder(1)
				Do While SA1->( dbseek( xfilial("SA1") + _cCod ) ) .And. Substr(cChave,1,8) != Substr(SA1->A1_CGC,1,8)
					_nSaveSX8 := GetSX8Len()
					_cCod := GETSXENUM("SA1","A1_COD")
					While ( GetSX8Len() > _nSaveSX8 )
						ConfirmSX8()
					EndDo
				EndDo
			endif
			_cLoj := MAT->M0_CODFIL
		    dbSelectArea("SA1")
		    dbSetOrder(1)
			Do While SA1->( dbseek( xfilial("SA1") + _cCod + _cLoj ) )
				_cLoj := StrZero( val(_cLoj)+1, len(SA1->A1_LOJA) )
			EndDo
		    dbSetOrder(3)
			lOk := _MBMAKESA1( lAchou, _cCod, _cLoj )  //Vai um a um
		Endif
		If lOk .Or. lAchou
			ChvXML(@cMsg)
		EndIf

		dbSelectArea("MAT")
    	MAT->( dbSkip() )
	EndDo

	DbCloseArea()

	If .Not. Empty( cMsg )
		Aviso("Aviso", cMsg,{"OK"},3)
	EndIf
Endif

Ferase(cArq+GetDBExtension())
Ferase(cArq+OrdBagExt())

Return(lRet)


//Fazer o ExecAuto
Static Function _MBMAKESA1( lAchou, _cCod, _cLoj )
Local _aTitulo	:= {}    

lMsErroAuto := .F.
lMsHelpAuto := .F.

_aTitulo := _Dados_SA1( lAchou, _cCod, _cLoj )

if ! empty(_aTitulo) 

   Begin Transaction
	MSExecAuto({|x,y| MATA030(x,y)},_aTitulo,3)

	If lMsErroAuto
	    //MostraErro()
		DisarmTransaction()
		break
	EndIF
   End Transaction

   If lMsErroAuto
	   Begin Transaction
	   		DbSelectArea( "SA1" )
	   		RecLock( "SA1", .T. )
			SA1->A1_COD			:= _aTitulo[01][2]
			SA1->A1_LOJA		:= _aTitulo[02][2]
			SA1->A1_PESSOA		:= _aTitulo[03][2]
			SA1->A1_NOME		:= _aTitulo[04][2]
			SA1->A1_NREDUZ		:= _aTitulo[05][2]
			SA1->A1_TIPO		:= _aTitulo[06][2]
			SA1->A1_END			:= _aTitulo[07][2]
			SA1->A1_MUN			:= _aTitulo[08][2]
			SA1->A1_EST			:= _aTitulo[09][2]
			SA1->A1_BAIRRO		:= _aTitulo[10][2]
			SA1->A1_COD_MUN		:= _aTitulo[11][2]
			SA1->A1_CEP    		:= _aTitulo[12][2]
			SA1->A1_CGC    		:= _aTitulo[13][2]
			SA1->A1_INSCR		:= _aTitulo[14][2]
			SA1->A1_DDD  		:= _aTitulo[15][2]
			SA1->A1_TEL  		:= _aTitulo[16][2]
			SA1->A1_FAX  		:= _aTitulo[17][2]
			SA1->( MsUnLock() )
			lMsErroAuto := .F.
	   End Transaction
   EndIf

Endif

Return(!lMsErroAuto)

//Matriz para o ExecAuto
Static Function _DADOS_SA1( lAchou, _cCod, _cLoj )
Local _aSA1 := GETAREA()
Local _aTitulo := {}
Local cPessoa, cNome, cNReduz
Local cEnder, cMunici, cBairro, cLimite, cRegiao
Local cCep, cFone, cCgc, cTransp, cDig, cUltcom
Local cUf, cEmail, cDDD, cInsc, cFax, cVend, cOldCod    
Local cCodMun := ""

cPessoa := "J"
cNome   := iif(MAT->(FieldPos("M0_NOMECOM")) > 0, MAT->M0_NOMECOM, " " )
cNReduz := iif(MAT->(FieldPos("M0_FILIAL")) > 0, MAT->M0_FILIAL, " " )
cEnder  := iif(MAT->(FieldPos("M0_ENDCOB")) > 0, MAT->M0_ENDCOB, " " )
cBairro := iif(MAT->(FieldPos("M0_BAIRCOB")) > 0, MAT->M0_BAIRCOB, " " )
cCep    := iif(MAT->(FieldPos("M0_CEPCOB")) > 0, MAT->M0_CEPCOB, " " )
cUf		:= iif(MAT->(FieldPos("M0_ESTCOB")) > 0, MAT->M0_ESTCOB, " " )
cCodMun := iif(MAT->(FieldPos("M0_CODMUN")) > 0, Substr(MAT->M0_CODMUN,3,len(MAT->M0_CODMUN)), " " )
cMunici := iif(MAT->(FieldPos("M0_CIDCOB")) > 0, MAT->M0_CIDCOB, " " )
cDDD    := iif(MAT->(FieldPos("M0_TEL")) > 0, Substr(MAT->M0_TEL,1,2), " " )
cFone   := iif(MAT->(FieldPos("M0_TEL")) > 0, Substr(MAT->M0_TEL,2,len(MAT->M0_TEL)), " " )
cFax    := iif(MAT->(FieldPos("M0_FAX")) > 0, MAT->M0_FAX, " " )
cCgc    := iif(MAT->(FieldPos("M0_CGC")) > 0, MAT->M0_CGC, " " )
cInsc   := iif(MAT->(FieldPos("M0_INSC")) > 0, MAT->M0_INSC, " " )

dbSelectArea("SA1")
dbSetOrder(1)

AADD( _aTitulo ,	{"A1_COD" 		,_cCod					 					,Nil})
AADD( _aTitulo ,	{"A1_LOJA" 		,_cLoj										,Nil})
AADD( _aTitulo ,	{"A1_PESSOA"	,cPessoa									,Nil})
AADD( _aTitulo ,	{"A1_NOME" 		,cNome										,Nil})
AADD( _aTitulo ,	{"A1_NREDUZ"	,cNReduz									,Nil})
AADD( _aTitulo ,	{"A1_TIPO"		,"F"										,Nil})
AADD( _aTitulo ,	{"A1_END" 		,cEnder										,Nil})
AADD( _aTitulo ,	{"A1_MUN" 		,cMunici									,Nil}) 
Aadd( _aTitulo ,	{"A1_EST"		,cUf										,Nil})
AADD( _aTitulo ,	{"A1_BAIRRO"	,cBairro									,Nil})
AADD( _aTitulo ,	{"A1_COD_MUN"	,cCodMun									,Nil})
AADD( _aTitulo ,	{"A1_CEP" 		,cCep										,Nil})
AADD( _aTitulo ,	{"A1_CGC" 		,cCgc										,Nil}) 
AADD( _aTitulo ,	{"A1_INSCR"		,cInsc										,Nil})
AADD( _aTitulo ,	{"A1_DDD" 		,cDDD										,Nil})
AADD( _aTitulo ,	{"A1_TEL" 		,cFone										,Nil})
AADD( _aTitulo ,	{"A1_FAX" 		,cFax										,Nil})

RESTAREA(_aSA1)
Return(_aTitulo)


//Gera Estrutura para arquivo Temporแrio a Partir do SigaMat Recebido
Static Function Temporario(cAlias)
Local aStr  := {}
Local aStru := {}
Local nI := 0

DbSelectArea(cAlias)
aStr := dbStruct()

AaDd( aStru, {"M0_OK", "C", 2, 0} )
For ni := 1 to Len(aStr)
	If aStr[ni][1] <> "M0_OK"
		AaDd(aStru,aStr[ni])
	EndIF
Next

Return( aStru )


//MarkBrowse para Excolher os CNPJs do sigamat que deseja importar
Static Function mkbrw()
Local lRet := .T.
Local aButtons	:= {}
Local aGetArea	:= GetArea()
Local aInfo		:= {}
Local aPosObj	:= {}
Local aObjects	:= {}
Local aSize		:= MsAdvSize()  			// Define e utiliza็ใo de janela padrใo Microsiga
Local cGetLOk  	:= "AllwaysTrue"	   		// Funcao executada para validar o contexto da linha atual do aCols
Local cGetTOk  	:= "AllwaysTrue"    		// Funcao executada para validar o contexto geral da MsNewGetDados
Local oFolder	:= Nil
Local oDlg01	:= Nil
Local oMarkBw	:= Nil
Local lInverte	:= .F.
Local lOk		:= .F.
Local cChvAtu	:= " "
Local cChvAnt	:= " "
Local oFont		:= Nil
Local aCpos     := {}
Local aCores    := {}

aCpos := {}
aadd( aCpos, {"M0_OK"     ,,"" } )
aadd( aCpos, {"M0_CODIGO" ,,"EMP"     ,"@!" } )
aadd( aCpos, {"M0_CODFIL" ,,"Fil"     ,"@!" } )
aadd( aCpos, {"M0_CGC"    ,,"CNPJ"    ,"@R 99.999.999/9999-99" } )
If MAT->(FieldPos("M0_FILIAL")) > 0
	aadd( aCpos, {"M0_FILIAL" ,,"Filial"  ,"@!" } )
EndIf
If MAT->(FieldPos("M0_NOMECOM")) > 0
	aadd( aCpos, {"M0_NOMECOM",,"Nome"    ,"@!" } )
Endif
If MAT->(FieldPos("M0_ENDCOB")) > 0
	aadd( aCpos, {"M0_ENDCOB" ,,"End"     ,"@!" } )
Endif
If MAT->(FieldPos("M0_BAIRCOB")) > 0
	aadd( aCpos, {"M0_BAIRCOB",,"Bairro"  ,"@!" } )
EndIf
If MAT->(FieldPos("M0_CEPCOB")) > 0
	aadd( aCpos, {"M0_CEPCOB" ,,"Cep"     ,"@!" } )
Endif
If MAT->(FieldPos("M0_ESTCOB")) > 0
	aadd( aCpos, {"M0_ESTCOB" ,,"UF"      ,"@!" } )
EndIf
If MAT->(FieldPos("M0_CIDCOB")) > 0
	aadd( aCpos, {"M0_CIDCOB" ,,"Cidade"  ,"@!" } )
EndIf
If MAT->(FieldPos("M0_CODMUN")) > 0
	aadd( aCpos, {"M0_CODMUN" ,,"Cd.Mun"  ,"@!" } )
EndIf
If MAT->(FieldPos("M0_TEL")) > 0
	aadd( aCpos, {"M0_TEL"    ,,"Tel"     ,"@!" } )
Endif
If MAT->(FieldPos("M0_FAX")) > 0
	aadd( aCpos, {"M0_FAX"    ,,"Fax"     ,"@!" } )
EndIf
If MAT->(FieldPos("M0_INSC")) > 0
	aadd( aCpos, {"M0_INSC"   ,,"I.E."    ,"@!" } )
EndIf

aCores := {}

dbSelectArea("MAT")
//COUNT TO nQtdReg
MAT->( dbGotop() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Apresenta botao se nao for visualizacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aButtons,{'CHECKED' ,{ || HFXML00Inv(cMarcaOK,@oMarkBw) }, "Inverter Marca็ใo", "Inverter"})
aAdd(aButtons,{'DESTINOS',{ || HFXML00Inv(cMarcaOK,@oMarkBw,.T.) }, "Marcar todos os tํtulos", "Marc Todos"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as posicoes da GetDados e Paineis ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//aAdd( aObjects, { 100, 060, .T., .T. } )      //GetDados
//aAdd( aObjects, { 100, 040, .T., .T. } )      //Folder
//aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
//aPosObj := MsObjSize( aInfo, aObjects,.T. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao da tela ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู    //aSize[7],0 TO aSize[6],aSize[5]
DEFINE MSDIALOG oDlg01 TITLE "Importar SigaMat" FROM 000,000 TO 430,800 OF oMainWnd PIXEL 

oDlg01:lMaximized := .F.

//@ -15,270 Button "ZOCA" Size 010,011 PIXEL OF oMainWnd ACTION (cJobs:=U_GetJob(cJobs)) 
//@ -15,-15 BUTTON oBtn PROMPT "ZOCA" SIZE 10,50 PIXEL OF oDlg01

//DEFINE FONT oFont NAME "Arial" SIZE 10,12 BOLD

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao do objeto Folder ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//oFolder	:= TFolder():New(10,2,{"Chaves"},{},oDlg01,,,,.T.,.F.,aPosObj[1][4],aPosObj[2][3],)  //-aPosObj[2][1]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o objeto Mark para a selecao dos podrutos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oMarkBw:=MsSelect():New("MAT","M0_OK","",aCpos,@lInverte,@cMarcaOK,{17,10,150,400},,,,,aCores) //oFolder:aDialogs[1]

oMarkBw:oBrowse:Refresh()
oMarkBw:oBrowse:lhasMark    := .T.
oMarkBw:oBrowse:lCanAllmark := .T.
oMarkBw:oBrowse:Align       := CONTROL_ALIGN_ALLCLIENT	//Usado no modelo FLAT


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Permite selecao se nใo for visualizacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oMarkBw:oBrowse:bAllMark    := { || HFXML00Inv(cMarcaOK,@oMarkBw) }
oMarkBw:oBrowse:bChange     := { || HFXML00Chg(@oMarkBw) }
oMarkBw:BMark               := { || HFXML00Dis(@oMarkBw,cMarcaOK) }

ACTIVATE MSDIALOG oDlg01 CENTERED  ON INIT EnchoiceBar(oDlg01,;
{|| lOk := .T., iif( msgYesNo("Importar Marcados ?" ,"Pegunta"),oDlg01:End(),lOk := .F. )},;
{|| lOk := .F., iif( msgYesNo("Cancela Importa็ใo ?","Pegunta"),oDlg01:End(),lOk := .F. )},,aButtons)

lRet := lOk

Return( lRet )


//Iverter Sele็ใo do MarkBrowse ou Selecionar/Deselecionar Todos
Static Function HFXML00Inv(cMarcaOK,oMarkBw,lMarkAll)
Local aGetArea	:= GetArea()
Local lMarcSim	:= .F.

If lMarkAll
	lMarcSim := Aviso( "Marcar/Desmarcar todos", "Deseja marcar ou desmarcar todos os tํtulos?", { "Marcar", "Desmarcar" } ) == 1
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ While para marcar ou desmarcar os produtos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MAT->( dbGotop() )
Do while MAT->( !EOF() )

	If lMarkAll
		RecLock("MAT", .F.)
		MAT->M0_OK	:= If(lMarcSim, cMarcaOK, "  ")
		MAT->( MsUnLock() )
	Else
		If  MAT->M0_OK == cMarcaOK
			RecLock("MAT", .F.)
			MAT->M0_OK	:= "  "
			MAT->( MsUnLock() )
		Else
			RecLock("MAT", .F.)
			MAT->M0_OK	:= cMarcaOK
			MAT->( MsUnLock() )
		EndIf
	EndIf

	MAT->( dbSkip() )
EndDo

oMarkBw:oBrowse:Refresh(.T.)
RestArea( aGetArea )
Return


//Refresh na hora de Marcar ou Desmarcar o Rezistro
Static Function HFXML00Dis(oMarkBw, cMarcaOK)
Local aGetArea := GetArea()

oMarkBw:oBrowse:Refresh(.T.)

RestArea( aGetArea )
Return


//Refresh na linha do MarkBrowse
Static Function HFXML00Chg(oMarkBw)
Local cRetFun := " "

oMarkBw:oBrowse:Refresh(.T.)

Return cRetFun


/*
============================================================================================================================
OTO
============================================================================================================================
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACHAVEXMLบAutor  ณMicrosiga           บ Data ณ  06/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraChaveXML()

Private oDlg
Private oGrp1
Private oUsuario
Private oSenha
Private oSay4
Private oSay5
Private oGrp6
Private oGet7
Private oSBtn8
Private oSBtn9
Private oSBtn10 
Private oFolder
Private oListBox1
Private oWBrowse1
Private aWBrowse1 := {}

Private cUsuarioXML := space(20)
Private cSenhaXML   := space(20)
Private cCaminhXML  := ""
Private lRet        := .F. 
Private nListBox1   := 1 
Private aItensList  := {}

PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1" 

//cCaminhXML  := GETMV("MV_PASTAPD")

//If Empty(cCaminhXML)
//   cCaminhXML  := GetMVHF("MV_PASTAPD" , .T.,'D:\MP10\Protheus_Data\system\valida.DBF' , '' ,.t., 'Pasta Onde esta o Arquivo Chave Lib.' )
//Endif

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Gerador de Chave de Seguran็a"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 471
oDlg:nHeight := 274
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

@ 003, 003 FOLDER oFolder SIZE 226, 120 OF oDlg ITEMS "Acesso","Empresas" COLORS 0, 16777215 PIXEL
fWBrowse1(oFolder)

oGrp1 := TGROUP():Create(oFolder:aDialogs[1])
oGrp1:cName := "oGrp1"
oGrp1:cCaption := "[ Digite o Usuแrio e Senha ]"
oGrp1:nLeft := 12
oGrp1:nTop := 4
oGrp1:nWidth := 422
oGrp1:nHeight := 118
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oUsuario := TGET():Create(oFolder:aDialogs[1])
oUsuario:cName := "cUsuario"
oUsuario:cToolTip := "Digite o Usuแrio"
oUsuario:nLeft := 147
oUsuario:nTop := 43
oUsuario:nWidth := 158
oUsuario:nHeight := 21
oUsuario:lShowHint := .F.
oUsuario:lReadOnly := .F.
oUsuario:Align := 0
oUsuario:cVariable := "cUsuarioXML"
oUsuario:bSetGet := {|u| If(PCount()>0,cUsuarioXML:=u,cUsuarioXML) } 
oUsuario:bValid := {|| IF(ALLTRIM(cUsuarioXML) == 'HFRAFAEL',.T., AlertaXML(1)) }
oUsuario:lVisibleControl := .T.
oUsuario:lPassword := .F.
oUsuario:lHasButton := .F.

oSenha := TGET():Create(oFolder:aDialogs[1])
oSenha:cName := "oSenha"
oSenha:cToolTip := "Digite a Senha"
oSenha:nLeft := 147
oSenha:nTop := 73
oSenha:nWidth := 156
oSenha:nHeight := 21
oSenha:lShowHint := .F.
oSenha:lReadOnly := .F.
oSenha:Align := 0
oSenha:cVariable := "cSenhaXML"
oSenha:bSetGet := {|u| If(PCount()>0,cSenhaXML:=u,cSenhaXML) } 
oSenha:bValid := {|| IF(ALLTRIM(cSenhaXML) == '2011',.T., AlertaXML(2)) }
oSenha:lVisibleControl := .T.
oSenha:lPassword := .T.
oSenha:lHasButton := .F.

oSay4 := TSAY():Create(oFolder:aDialogs[1])
oSay4:cName := "oSay4"
oSay4:cCaption := "Usuแrio :"
oSay4:nLeft := 102
oSay4:nTop := 49
oSay4:nWidth := 44
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oSay5 := TSAY():Create(oFolder:aDialogs[1])
oSay5:cName := "oSay5"
oSay5:cCaption := "Senha :"
oSay5:nLeft := 105
oSay5:nTop := 78
oSay5:nWidth := 38
oSay5:nHeight := 15
oSay5:lShowHint := .F.
oSay5:lReadOnly := .F.
oSay5:Align := 0
oSay5:lVisibleControl := .T.
oSay5:lWordWrap := .F.
oSay5:lTransparent := .F.

oGrp6 := TGROUP():Create(oFolder:aDialogs[1])
oGrp6:cName := "oGrp6"
oGrp6:cCaption := "[ Localiza็ใo do SIGAMAT.EMP do CLiente ]"
oGrp6:nLeft := 13
oGrp6:nTop := 125
oGrp6:nWidth := 421
oGrp6:nHeight := 63
oGrp6:lShowHint := .F.
oGrp6:lReadOnly := .F.
oGrp6:Align := 0
oGrp6:lVisibleControl := .T.  

oGet7 := TGET():Create(oFolder:aDialogs[1])
oGet7:cName := "oGet7"
oGet7:cToolTip := "Informe a Localiza็ใo do SIGAMAT.EMP do Cliente"
oGet7:nLeft := 25
oGet7:nTop := 150
oGet7:nWidth := 356
oGet7:nHeight := 21
oGet7:lShowHint := .F.
oGet7:lReadOnly := .F.
oGet7:Align := 0
oGet7:cVariable := "cCaminhXML"
oGet7:bSetGet := {|u| If(PCount()>0,cCaminhXML:=u,cCaminhXML) }  
oGet7:bValid := {|| IF(ALLTRIM(cCaminhXML) <> '',IF(ValidaCam(cCaminhXML),.T.,AlertaXML(3)), AlertaXML(3)) }  
oGet7:bWhen :={|| .T. }
oGet7:lVisibleControl := .T.
oGet7:lPassword := .F.
oGet7:lHasButton := .F.

oSBtn8 := SBUTTON():Create(oFolder:aDialogs[1])
oSBtn8:cName := "oSBtn8"
oSBtn8:nLeft := 14
oSBtn8:nTop := 192
oSBtn8:nWidth := 55
oSBtn8:nHeight := 22
oSBtn8:lShowHint := .F.
oSBtn8:lReadOnly := .F.
oSBtn8:Align := 0
oSBtn8:lVisibleControl := .T.
oSBtn8:nType := 1                
oSBtn8:bAction := {|| GERACHVXML(cCaminhXML),oDlg:end() }

oSBtn9 := SBUTTON():Create(oFolder:aDialogs[1])
oSBtn9:cName := "oSBtn9"
oSBtn9:nLeft := 76
oSBtn9:nTop := 192
oSBtn9:nWidth := 52
oSBtn9:nHeight := 22
oSBtn9:lShowHint := .F.
oSBtn9:lReadOnly := .F.
oSBtn9:Align := 0
oSBtn9:lVisibleControl := .T.
oSBtn9:nType := 2 
oSBtn9:bAction := {||fechacli(),oDlg:end() }

oDlg:Activate()

Return  
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fechacli บAutor  ณMicrosiga           บ Data ณ  07/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function fechacli()

If Select("CLI") > 0
	DbCloseArea("CLI")
EndIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACHAVEXMLบAutor  ณMicrosiga           บ Data ณ  06/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AlertaXML(cTipoErro)  
If cTipoErro == 1           
	MsgStop('Usuแrio Incorreto !!!!!!!')
ElseIf	cTipoErro == 2
	MsgStop('Senha Incorreta !!!!!!!')
ElseIf	cTipoErro == 3
	MsgStop('SIGAMAT.EMP nใo encontrado !!!!!!!')
EndIf	
Return(.F.)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACHAVEXMLบAutor  ณMicrosiga           บ Data ณ  06/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaCam(cCaminhXML)     

lRet := .F.

If file(cCaminhXML)
	lRet := .T.
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACHAVEXMLบAutor  ณMicrosiga           บ Data ณ  06/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GERACHVXML(cCaminhXML)                                                                                                

cArq := cCaminhXML

lAbril := MyOpenSM0Ex(cArq)

if lAbril 
	nH:=fCreate(Left(alltrim(cCaminhXML),AT('.',cCaminhXML)) + 'HFC')
	For axt := 1 to Len(aWBrowse1)
		If aWBrowse1[axt][1] == .T.
			cStringTRV := SUBSTR(ALLTRIM(aWBrowse1[axt][4]),1,8) + 'HF-CONSULTING-XML'+ALLTRIM(CLI->M0_CORPKEY) + ALLTRIM(STR(CLI->M0_CHKSUM)) + ALLTRIM(CLI->M0_PSW)
			cStringTRV := embaralha(cStringTRV,0) + chr(13) + chr(10)
			fWrite(nH,cStringTRV) 
			cStringTRV := ""
		EndIf
	Next
	fClose(nh)           

EndIf


Return            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACHAVEXMLบAutor  ณMicrosiga           บ Data ณ  06/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function MyOpenSM0Ex()

Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20
	MsOpenDbfHF(.T.,"DBFCDX",'sigamat.emp',"CLI",.T.,.t.,.F.,.F.)
	If !Empty( Select( "CLI" ) ) 
		lOpen := .T. 	
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop 

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf                                 

Return( lOpen ) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACHAVEXMLบAutor  ณMicrosiga           บ Data ณ  06/22/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetMVHF(cParametro , lHelp , cDefault , cFil ,lCria, cDescriP )

Local cSvFilAnt		:= cFilAnt
Local xResultado	:= NIL
Local nX			:= 0.00 
Local aSX6   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cTexto := ''
Local cAlias := ''
	
cFilAnt	:= cFil

IF PCount() == 0.00
	
	__GetMV := NIL
	
Else
	If lCria == .T.
		aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}
		AADD(aSx6,{cFil,cParametro,"C",cDescriP,"","","","","","","","",cDefault,"","","",""})
		dbSelectArea("SX6")
		dbSetOrder(1)

		For i:= 1 To Len(aSX6)
			If !Empty(aSX6[i][2])
				If !dbSeek(aSX6[i,1]+aSX6[i,2])
					lSX6	:= .T.
					If !(aSX6[i,2]$cAlias)
						cAlias += aSX6[i,2]+"/"
					EndIf
					RecLock("SX6",.T.)
					For j:=1 To Len(aSX6[i])
					If !Empty(FieldName(FieldPos(aEstrut[j])))
							FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
						EndIf
					Next j
					dbCommit()
					MsUnLock()
				EndIf
			EndIf
		Next i		
	EndIf
	
	xResultado := GetMv( cParametro , lHelp , cDefault )
	
EndIF

Return( xResultado )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACHAVEXMLบAutor  ณMicrosiga           บ Data ณ  07/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ListSMOCli(aWBrowse1)

Local lOpen := .F. 
Local nLoop := 0 

If Select("CLI") > 0
	DbCloseArea("CLI")
EndIF
MyOpenSM0Ex()
DbSelectArea("CLI")
dbcreateindex("CLI","CLI->M0_CODIGO + Substr(CLI->M0_CGC,1,8)",{|| CLI->M0_CODIGO+Substr(CLI->M0_CGC,1,8)})
DbSetIndex("CLI")
cEmpTodas := "" 
While !Eof()                                                           
	If cEmpTodas <> CLI->M0_CODIGO+Substr(CLI->M0_CGC,1,8)
		aadd(aWBrowse1,{.F.,CLI->M0_CODIGO,CLI->M0_NOMECOM,CLI->M0_CGC})
		cEmpTodas := CLI->M0_CODIGO+Substr(CLI->M0_CGC,1,8)
	EndIf	
	DbSkip()               
End
DbCloseArea("CLI")
Ferase("CLI.CDX")		
Return(aWBrowse1)    



//------------------------------------------------
Static Function fWBrowse1()
//------------------------------------------------
Local oOk := LoadBitmap( GetResources(), "LBOK")
Local oNo := LoadBitmap( GetResources(), "LBNO")


    // Insert items here 
    ListSMOCli(aWBrowse1)
    
	@ 002, 003 LISTBOX oWBrowse1 Fields HEADER "","Empresa","Razao Social","CNPJ" SIZE 222, 105 OF oFolder:aDialogs[2] PIXEL 
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
      aWBrowse1[oWBrowse1:nAt,2],;
      aWBrowse1[oWBrowse1:nAt,3],;
      aWBrowse1[oWBrowse1:nAt,4];
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACHAVEXMLบAutor  ณMicrosiga           บ Data ณ  07/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function MsOpEndbfHF(lNewArea,cDriver,cArquivo,cAlias,lShared,lReadOnly,lHelp,lQuit)

Local lUsed:= .F.
Local nTentativas:=1

lHelp := Iif(lHelp==Nil,.F.,lHelp)	 // Edita Help se Arquivo nao foi aberto
lQuit := Iif(lQuit==Nil,.F.,lQuit)	 // Finaliza Sistema se arq nao Existe
cDriver := Iif(cDriver == Nil,__cRdd,cDriver)

cArquivo := RetArq(cDriver,cArquivo,.T.)	// Nome do arquivo depEndEndo da Rdd
If lQuit
	If !MsFile(cArquivo,,cDriver) 	 // Se Arquivo nao existir, Final()
		Final(cArquivo+OemToAnsi(" no encontrado")) //
	EndIf
EndIf

If Select(cAlias) == 0
	DbUseArea(lNewArea,cDriver,cArquivo,cAlias,lShared,lReadOnly)

	lUsed:= Used()

	If !lUsed
		If lShared
			While !lUsed
				If nTentativas==3
					Final(OemToAnsi(" Arquivo ")+cArquivo+OemToAnsi(" Exclusivo")) 
				EndIf
				Help(cArquivo,1,"EXCL")
				nTentativas++
				DbUseArea(lNewArea,cDriver,cArquivo,cAlias,lShared,lReadOnly)
				lUsed:= Used()
			End
		Else
			Return .F.
		EndIf
	EndIf
EndIf

Return .T.	