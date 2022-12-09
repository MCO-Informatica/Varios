#Include "Protheus.Ch"

user function MAKORDENT   

	Local aHelpPor 	:= {}
	Local aHelpEsp 	:= {}              
	Local aHelpIng 	:= {}
	Local cPerg		:= "MAKORDENT"
	Local cStringP   := ""  // texto em portugues
	Local cStringE   := ""	// texto em espanhol
	Local cStringI   := ""  // texto em ingles

	If !Pergunte(cPerg, .t.)
		Return (.T.)
	EndIf

	Processa( {||OrdEntr(), "Gerando o Ordem de Entrega"})


return

//
// function : Ordentr
// by JAR in ABM/Makeni  **  12/04/2011
//
Static Function OrdEntr

	Local nOpc := 4
	Local nCol
	Local oDlg       
	Local nLin
	Local nTop
	Local nLeft
	Local nBottom
	Local nRight  

	Local cLinhaOK
	Local cTudoOK
	Local cIniCpos
	Local lDelete
	Local nMax
	Local cFieldOK
	Local cSuperDel
	Local cDelOK
	Local nCol
	Local nCampo

	Local aButtons := {}
	Local cSQL       
	Local cCodProt := Space(10)  
	Local oSay1, oProc, cProc := space(10)

	Local aPosObj  := {}
	Local aObjects := {}
	Local aSize    := {}
	Local aPosGet  := {}
	Local aInfo    := {}

	Private oGetDados
	Private lRefresh := .T.
	Private aHeader := {}
	Private aCols := {}    
	Private aRotina := {}        

	Private aRotina := {{"Pesquisar","AxPesqui",0,1} ,;
	{"Visualizar","AxVisual",0,2} ,;
	{"Incluir","AxInclui",0,3} ,;
	{"Alterar","AxAltera",0,4} ,;
	{"Excluir","AxDeleta",0,5}}

	//             Título,         Campo,      Picture, Tamanho, Decimal, Validação, Reservado, Tipo, Reservado, Reservado                
	AADD(aHeader,{ "Ordem"       , "ORD"       ,""   ,03,0,"","","C","",""})
	//AADD(aHeader,{ "Ord MAK"     , "ORDMAK"    ,"999"  ,03,0,".T.","","C","",""})
	AADD(aHeader,{ "Pedido"      , "Pedido"    ,""  ,06,0,"","","C","",""})
	AADD(aHeader,{ "Nota"        , "NF"        ,""  ,09,0,"","","C","",""})
	AADD(aHeader,{ "Serie"       , "SERIE"     ,""  ,03,0,"","","C","",""})
	AADD(aHeader,{ "CLiente"     , "CLIENTE"   ,""  ,06,0,"","","C","",""})
	AADD(aHeader,{ "Loja"        , "LOJA"      ,""  ,02,0,"","","C","",""})
	AADD(aHeader,{ "Nome Cliente", "NOMECLI"   ,""  ,20,0,"","","C","",""})
	AADD(aHeader,{ "Placa"       , "PLACA"     ,""  ,08,0,"","","C","",""})

	ProcRegua(0)
	IncProc("Selecionando dados...")    

	cSQL:= "SELECT DISTINCT(SD2.D2_PEDIDO) Pedido ,SD2.D2_DOC NF ,SD2.D2_SERIE Serie ,SD2.D2_CLIENTE Cliente , SD2.D2_LOJA Loja ,SA1.A1_NREDUZ NomeCli, DA3.DA3_PLACA Placa "
	cSQL+= "FROM "+RetSqlName('SD2')+" SD2, "+RetSqlName("SF2")+" SF2 , "+RetSqlName("SA1")+" SA1, "+RetSqlName("DA3")+" DA3 WHERE SF2.F2_FILIAL = '"+xFilial('SF2')+"' AND DA3.DA3_FILIAL = '"+xFilial('DA3')+"' AND SF2.F2_DOC = SD2.D2_DOC AND "
	cSQL+= "SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA AND "
	cSQL+= "SF2.F2_VEICUL1 = DA3.DA3_COD AND DA3.DA3_PLACA = '"+mv_par01+"' AND SA1.A1_COD = SD2.D2_CLIENTE AND SF2.F2_EMISSAO between '"+DTOS(mv_par05)+"' AND '"+dtos(mv_par06)+"' AND "
	cSQL+= "SA1.A1_LOJA = SD2.D2_LOJA AND SF2.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND SF2.F2_PRCENT = ' ' AND DA3.D_E_L_E_T_ <> '*' "

	If !Empty( mv_par02 )	// numero do pedido
		cSQl += "and SD2.D2_PEDIDO = '" + mv_par02 + "' "
	endif

	If !Empty( mv_par03 ) .and. ! Empty( mv_par04 )
		cSQL+=" and SD2.D2_DOC = '"+mv_par03+"' AND SD2.D2_SERIE = '"+mv_par04+"' "
	Endif

	If Select('sql') <> 0
		SQL->(dbclosearea())
	Endif

	cSQL := ChangeQuery(cSQL)    
	dbUseArea(.T., "TOPCONN",TCGENQRY(,,cSQL),"sql",.F.,.T.)     

	IncProc("Preparando a tela...")   

	// monta o aCols       
	while !sql->( eof() )

		AAdd(aCols, Array(Len(aHeader)+1)) 
		nLin := Len(aCols)  

		aCols[nLin,1]:= Strzero(nLin,3)
		For nCol := 2 To Len(aHeader)

			If aHeader[nCol,2] == "ORDMAK"
				aCols[nLin,nCol] := space(03)           
				Loop
			Endif

			If aHeader[nCol,2] == "Placa"
				aCols[nLin,nCol] := TRANS(sql->( FieldGet( FieldPos(aHeader[nCol,2]) ) ),'@R XXX-99999')
				Loop
			Endif
			aCols[nLin,nCol] := sql->( FieldGet( FieldPos(aHeader[nCol,2]) ) )
		Next	
		aCols[nLin,Len(aHeader)+1] := .F.	

		sql->( DbSkip() )
	enddo     

	If Empty(aCols) 
		MsgStop("Nao ha Pedidos a Ordenar para estes Parâmetros","Atençao")
		sql->(dbclosearea())
		Return
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 020, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
	{{003,033,160,200,240,263}} )

	/*				  	
	DEFINE MSDIALOG oDlg TITLE "Tela de Configuração das Tabelas de Preços" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oGet := MSGetDados():New(10,2,aPosObj[2,3]+30,aPosObj[2,4]+2,4,"U_A030OK","U_A030OK",,.F.,aCpos,1,,len(aCols))
	*/

	DEFINE MSDIALOG oDlg TITLE "Ordem de Entrega" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

	//oDlg:lMaximized := .T.  

	aCampos  := {} //{"NOUSER"}
	aPosicao := {1,1,50,300} //{18, 5, 50, oDlg:oWnd:nClientWidth/2-10}
	aEdit    := {}  //If(nOpc == 3, {"ORD"}, {})
	lColuna  := .F.

	//oEnchoice := MsMGet():New("sql", , nOpc, , , , aCampos, aPosicao, aEdit, , , , , oDlg, , , lColuna)  

	/*
	nTop      :=  50 //oEnchoice:oBox:nBottom/2 + 5
	nLeft     :=  01 //oEnchoice:oBox:nLeft/2
	nBottom   := 280 //oDlg:oWnd:nHeight/2 - 80
	nRight    := 300 //oEnchoice:oBox:nRight/2
	*/


	//cLinhaOK  := "U_OrdOK"
	cLinhaOK  := "Allwaystrue"
	cTudoOK   := "AllwaysTrue"
	cIniCpos  := ""
	lDelete   := .f.
	nMax      := 99
	cFieldOK  := ""
	cSuperDel := ""
	cDelOK    := "U_DltOrd()"

	cProc := GetSxeNum("ZX8","ZX8_PROT")
	ConfirmSX8()			

	@ 017, 010 SAY oSay1 PROMPT "Processo:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
	@ 029, 010 MSGET oProc VAR cProc SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	aAuxCols:=aCols                                                                                                                 
	oGetDados := MsGetDados():New(50,2,aPosObj[2,3]+30,aPosObj[2,4]+2,nOpc, cLinhaOK, cTudoOK,  "+ORD", lDelete, {"ORDMAK"} ,1 , , nMax)//, cFieldOK, "", , /*cDelOK*/, oDlg)
	//oGet      := MSGetDados():New(10,2,aPosObj[2,3]+30,aPosObj[2,4]+2,4,"U_A030OK","U_A030OK",,.F.,aCpos,1,,len(aCols))
	Aadd( aButtons, {"UP", {|| u_MoveItem(1)}, "Sobe Prioridade", " " , {|| .T.}} )
	Aadd( aButtons, {"DOWN", {|| u_MoveItem(2)}, "Desce Prioridade", " " , {|| .T.}} )

	Activate MSDialog oDlg Centered On INIT (EnchoiceBar(oDlg,{||lOk:=.T.,u_SalvaOrd(oDlg, cProc)},{||oDlg:End()},,@aButtons))

	sql->( DBCloseArea() )

return


User Function OrdOK()

	If n > Len(aCols)
		Return .f.
	Endif

	If Type("aCols[n+1,3]") == "U"
		Return .f.
	Endif

Return .t.

user Function MoveItem(nAcao)  
	Local nPTmp

	if nAcao == 1    //sobe
		if n > 1 .and. n <= len( aCols )
			nPTmp := Val(aCols[n,1])
			aCols[n,1] := StrZero(nPTmp - 1,3)
			aCols[n-1,1] := StrZero(nPTmp,3)
		endif    	
	else			// desce
		if n >= 1 .and. n < len( aCols )
			nPTmp := Val(aCols[n,1])
			aCols[n,1]   := StrZero(nPTmp + 1,3)
			aCols[n+1,1] := StrZero(nPTmp,3)
		endif		
	endif         

	aCols := ASORT(aCols,,, { |x, y| x[1] < y[1] })   
	getdrefresh()
Return

//
// function : DltOrd
// by JAR in ABM/Makeni  **  12/04/2011
// 
user function DltOrd()

	ApMsgInfo( "Deleta?" )
Return

//
// function : SalvaOrd
// by JAR in ABM/Makeni  **  12/04/2011
// Salva as alterações em ZX8
user function SalvaOrd(_oDlg, _cProc)
	local nRegs, nCols
	Local nx := 0
	Local i := 0

	If Empty(_cProc)
		MsgStop(" Nr. Processo deve ser Informado ")
		Return .f.                     	
	Endif

	If ZX8->( DBSeek(xFilial("ZX8")+_cProc) )
		MsgStop("Processo ja registrado com este Codigo, Utilize outro Codigo","Atençao")
		Return .f.
	Endif

	If MsgYesNo("Confirma a Ordem de Entrega Digitada ?")
		DbSelectArea("ZX8")
		For i := 1 to Len( aCols )
			//grava o roteiro
			cPed     := aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'Pedido'})]
			cOrdEnt  := aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'ORD'})]

			Reclock("ZX8",.t.)
			ZX8_FILIAL		:= xFilial("ZX8")
			ZX8_DOC   		:= aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'NF'})]
			ZX8_SERIE   	:= aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'SERIE'})]
			ZX8_CLIENT  	:= aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'CLIENTE'})]
			ZX8_LOJA   		:= aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'LOJA'})]
			ZX8_ORDEM       := cOrdEnt
			ZX8_PLACA   	:= mv_par01 //aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'PLACA'})]
			//			   	ZX8_DESCR		:= //aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'DESCRPLACA'})]
			ZX8_PROT		:= _cProc
			ZX8_NUM         := cPed
			MsUnLock()

			//Grava o historico

			cEnt:=""
			cEnt+="Ordem Pedido    Cliente" + chr(13)+chr(10)
			If Val(cOrdEnt) >1
				cEnt:="Entregas Anteriores "+chr(13)+chr(10)
				cEnt+="------------------- "+chr(13)+chr(10)
				cEnt+="Ordem Pedido    Cliente" + chr(13)+chr(10)
			Endif

			For nx:=1 to Val(cOrdEnt)
				cEnt+=aCols[nx,Ascan(aHeader,{|x| Alltrim(x[2]) == 'ORD'})]+"   "
				cEnt+="  "+aCols[nx,Ascan(aHeader,{|x| Alltrim(x[2]) == 'Pedido'})]+"   "
				cEnt+=aCols[nx,Ascan(aHeader,{|x| Alltrim(x[2]) == 'CLIENTE'})]+"  "+aCols[nx,Ascan(aHeader,{|x| Alltrim(x[2]) == "NOMECLI"})]+chr(13)+chr(10)
			Next nx

			cMotivo:="Entrega Nr: "+cOrdEnt+" Veiculo Placa Nr: "+Trans(ZX8->ZX8_PLACA,'@R XXX-99999')+" NF Nr: "+ZX8->ZX8_DOC
			U_GrvLogPd( cPed, ZX8->ZX8_CLIENT, ZX8->ZX8_LOJA, "Ordem de Entrega ", cMotivo, Nil, cEnt  )

			If Sf2->(dbseek(xFilial('SF2')+ZX8->ZX8_DOC+ZX8->ZX8_SERIE))
				Sf2->(RecLock("SF2",.f.))
				Sf2->F2_PRCENT = _cProc
				Sf2->(MsUnlock())
			Endif

			/*
			dbSelectArea("SZ4")
			RecLock("SZ4",.T.)
			SZ4->Z4_PEDIDO  :=
			SZ4->Z4_CLIENTE := aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'CLIENTE'})]
			SZ4->Z4_LOJA    := aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'LOJA'})]
			SZ4->Z4_DATALIB := dDataBase
			SZ4->Z4_DATAPED := dDataBase
			SZ4->Z4_RESP    := SubStr(cUsuario,7,15)
			SZ4->Z4_EVENTO  := "Ordem de entrega: " + aCols[i,Ascan(aHeader,{|x| Alltrim(x[2]) == 'ORD'})] + " proc: " + _cProc
			MsUnlock()
			*/

		Next

		MsgInfo("Atualizacao Realizada com Sucesso")
		_oDlg:End()
	EndIf

Return .t.
