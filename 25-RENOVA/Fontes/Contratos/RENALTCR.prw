#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RENALTCR º Autor ³Carlos Tagliaferri Jrº Data ³  Jan/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Alteracao de Parcelas dos Cronogramas                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RENALTCR()

Local cAlias1  := "CNF"
Local cCampos  := "CNF_FILIAL|CNF_NUMERO|CNF_CONTRA|CNF_REVISA|CNF_PERANT|CNF_DTREAL|CNF_TXMOED|CNF_PERIOD|CNF_DIAPAR"// Campos excluidos da GetDados
Local _aAlter  := {"CNF_VLPREV","CNF_DTVENC","CNF_PRUMED"}
Local nOpcX    := 4
Local nOpcA    := 0
Local cVarTemp := ""
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aInfo     := {}

Private oDlg     
Private oTPane1
Private oGetDados	
Private oSaldo
Private _cCronog	:= CNF->CNF_NUMERO
Private _cContra	:= CNF->CNF_CONTRA
Private _cRevisa	:= CNF->CNF_REVISA
Private _nSoma      := 0
Private _nTotal     := 0
Private _nSaldo     := 0
Private aHeader		:= {}
Private aCOLS		:= {}
Private nUsado		:= 0


dbSelectArea(cAlias1)

If Posicione("CN9",1,xFilial("CN9") + _cContra + _cRevisa, "CN9_SITUAC") <> "05"
	MsgStop("Opção somente para contratos vigentes","Atenção!!!")
	Return
EndIf

If !CN240VldUsr(_cContra,"001",.T.)
	Return
EndIf


dbSelectArea(cAlias1)
dbSetOrder(1)
dbSeek( xFilial("CNF") + _cCronog + _cContra + _cRevisa )

dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cCampos)
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO         ,;
		               X3_PICTURE       ,;
		               X3_TAMANHO       ,;
		               X3_DECIMAL       ,;
		               IIF(Empty(X3_VALID), X3_VALID, Space(15)),;
		               X3_USADO         ,;
		               X3_TIPO          ,;
		               X3_ARQUIVO       ,;
		               X3_CONTEXT       })
	Endif
	dbSkip()
End

dbSelectArea(cAlias1)
dbSeek( xFilial("CNF") + _cCronog + _cContra + _cRevisa )

While !EOF() .And. CNF->CNF_FILIAL + CNF->CNF_NUMERO + CNF->CNF_CONTRA + CNF->CNF_REVISA == xFilial("CNF") + _cCronog + _cContra + _cRevisa
   
	aAdd( aCOLS, Array(Len(aHeader)+1))
   
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek(cAlias1)
	While !EOF() .And. X3_ARQUIVO == cAlias1
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cCampos)
			nUsado++
			cVarTemp := cAlias1+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS[Len(aCOLS),nUsado+1] := .F.
	dbSelectArea(cAlias1)
	_nSoma += CNF->CNF_VLPREV
	dbSkip()
End                 

aSize := MsAdvSize(,.F.,400) // Desenha a Janela
AAdd( aObjects, { 100, 10, .T., .T. } )
AAdd( aObjects, { 200, 200, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T.) // Retorna as coordenadas internas do objeto

DEFINE MSDIALOG oDlg TITLE "Alteracao Cronograma" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP

	@ 4, 006 SAY "Numero:"   SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Contrato:" SIZE 80,7 PIXEL OF oTPane1
	@ 4, 176 SAY "Revisao:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 270 SAY "Total:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 390 SAY "Saldo:"    SIZE 70,7 PIXEL OF oTPane1

	@ 3, 029 MSGET _cCronog   When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 090 MSGET _cContra   When .F. SIZE 78,7 PIXEL OF oTPane1
	@ 3, 200 MSGET _cRevisa   When .F. SIZE 40,7 PIXEL OF oTPane1
	@ 3, 290 MSGET _nSoma     When .F. PICTURE "@E 999,999.99" SIZE 80,7 PIXEL OF oTPane1
	@ 3, 410 MSGET oSaldo VAR _nSaldo When .F. PICTURE "@E 999,999.99" SIZE 80,7 PIXEL OF oTPane1
	
	oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcX,"u_Mod2LinOk()","u_Mod2TudOk()","+CNF_PARCEL",.T.,_aAlter,,,Len(aCols),"U_WVlPrev()")

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
	Begin Transaction
    	Mod2Grava(cAlias1)
 	End Transaction
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exclui titulos PR Antigos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CN100ETit(_cContra,_cRevisa,_cCronog)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava titulos PR Novos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 To Len(aCols)
		If aCols[nI][Mod2Pesq("CNF_SALDO")] > 0
			CN100CTit(_cContra,_cRevisa,_cCronog,aCols[nI][Mod2Pesq("CNF_PARCEL")])
		EndIf
	Next nI
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mod2LinOk º Autor ³Carlos Tagliaferri Jrº Data ³  Jan/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Validacao da linha do aCols                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENALTCR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mod2LinOk()
Local lRet := .T.
Local cMsg := ""

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.
If !aCols[n][nUsado+1]
	If Empty(aCols[n][Mod2Pesq("CNF_PARCEL")])
    	cMsg := "Nao sera permitido linhas sem a parcela."
      	Help("",1,"","Mod2LinOk",cMsg,1,0)
      	lRet := .F.
   	Endif
Endif

Return( lRet )
                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mod2TudOk º Autor ³Carlos Tagliaferri Jrº Data ³  Jan/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Validacao Total                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENALTCR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mod2TudOk()

Local lRet   := .T.                              

lRet := u_Mod2LinOk()
     
If lRet
	_nTotal := 0
	For nX := 1 to Len(aCols)
		If aCols[nX][nUsado+1]
			If aCols[nX][Mod2Pesq("CNF_VLREAL")] > 0
				MsgAlert("Foi deletada a parcela " + aCols[nX][Mod2Pesq("CNF_PARCEL")] + " indevidamente.","Atenção!!!")
				lRet := .F.
			EndIf
		EndIf
		If !aCols[nX][nUsado+1]
			_nTotal += aCols[nX][Mod2Pesq("CNF_VLPREV")]
		EndIf
	Next nX
EndIf                                              

If lRet
	If _nSoma <> _nTotal
		MsgAlert("O valor total do cronograma alterado não corresponde com o valor total original.","Atenção!!!")
		lRet := .F.                                                                              
	EndIf
EndIf

Return( lRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mod2Grava º Autor ³Carlos Tagliaferri Jrº Data ³  Jan/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Gravacao das parcelas                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENALTCR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Mod2Grava(cAlias1)
Local lRet := .T.
Local nI := 0
Local nY := 0
Local cVar := ""
Local cParc  := StrZero(1,TamSX3("CNF_PARCEL")[1])

dbSelectArea(cAlias1)
dbSetOrder(3)

For nI := 1 To Len(aCols)
	dbSeek( xFilial("CNF") + _cContra + _cRevisa + _cCronog + aCols[nI][Mod2Pesq("CNF_PARCEL")] )

   	If !aCols[nI][nUsado+1]            
    	If Found()
    		RecLock(cAlias1,.F.)
      	Else
         	RecLock(cAlias1,.T.)
	     	CNF->CNF_FILIAL := xFilial("CNF")
      		CNF->CNF_NUMERO := _cCronog
      		CNF->CNF_CONTRA := _cContra
      		CNF->CNF_REVISA := _cRevisa
      	Endif
      
            
      	For nY = 1 to Len(aHeader)
         	If aHeader[nY][10] # "V"
            	cVar := Trim(aHeader[nY][2])
            	Replace &cVar. With aCols[nI][nY]
         	Endif
      	Next nY
      	MsUnLock(cAlias1)      
   	Else
      	If !Found()
         	Loop
      	Endif
      	RecLock(cAlias1,.F.)
	    	dbDelete()
      	MsUnLock(cAlias1)
   	Endif
Next nI

For nI := 1 To Len(aCols)
   	If !aCols[nI][nUsado+1]            
		(cAlias1)->(dbSeek( xFilial("CNF") + _cContra + _cRevisa + _cCronog + aCols[nI][Mod2Pesq("CNF_PARCEL")] ))
		RecLock(cAlias1,.F.)
			(cAlias1)->CNF_PARCEL := cParc
		MsUnlock()
		cParc := Soma1(cParc)
	EndIf
Next nI

Return( lRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mod2Pesq  º Autor ³Carlos Tagliaferri Jrº Data ³  Jan/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Pesquisa campos no aCols                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENALTCR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Mod2Pesq(cCampo)

Local nPos := 0

nPos := aScan(aHeader,{|x|AllTrim(Upper(x[2]))==cCampo})

Return(nPos)                          




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WVlPrev   º Autor ³Carlos Tagliaferri Jrº Data ³  Jan/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Validacao da da alteracao do valor previsto                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENALTCR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WVlPrev()

Local _lRet := .T.
Local nGDCol := oGetDados:oBrowse:ColPos
Local cGDCpo := "M->"+aHeader[nGDCol,2]

If cGDCpo == "M->CNF_VLPREV"
	If aCols[n][Mod2Pesq("CNF_VLREAL")] > 0
		MsgStop("A parcela " + aCols[n][Mod2Pesq("CNF_PARCEL")] + " não pode ser alterada.","Atenção!!!")
		_lRet := .F.                                                     
	EndIf
	
	If _lRet
		aCols[n][Mod2Pesq("CNF_SALDO")] := M->CNF_VLPREV
		
		_nSaldo := _nSaldo - M->CNF_VLPREV + aCols[n][Mod2Pesq("CNF_VLPREV")]
		oSaldo:Refresh()
	EndIf
EndIf

Return(_lRet)