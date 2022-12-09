
# Include "Protheus.ch"           
# Include "Topconn.ch"        
# Include "Set.ch"
# Include "TBICONN.CH"
Static __aInfoTable__
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTA010   บAutor  ณMauro Sano          บ Data ณ  13/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de PD x Produto                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlter. 1  ณ #ASD20120625 - Inclusao de novas funcionalidades e valida- บฑฑ
ฑฑบ          ณ coes.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ESTA010()                                                                                                             

Private cCadastro  	:= "Cadastro de Ponto de Distribui็ใo x Produto"
Private aRotina		:= {	{"Pesquisar"		  ,"AxPesqui"    	, 0, 1},; 
							{"Vincula PD"		  ,"U_ESTA0110" 	, 0, 3},;
							{"Visualizar"		  ,"U_ESTA0100" 	, 0, 2},; 
							{"Incluir"   		  ,"U_ESTA0100" 	, 0, 3},;
							{"Alterar"   		  ,"U_ESTA0100" 	, 0, 4},;
							{"Excluir"   		  ,"U_ESTA0100" 	, 0, 5},;
							{"Calc. Individual"	  ,"U_ESTACALC" 	, 0, 6},; 	//#ASD20120625.n
							{"Calc. Lote"		  ,"U_ESTACALC" 	, 0, 7},;	//#ASD20120625.n   
							{"Desvincula PD"      ,"U_ESTA0120" 	, 0, 3},;	   
							{"Consulta PD"	   	  ,"U_ESTA0104" 	, 0, 2},; 
							{"Notas Fiscais"	  ,"U_ESTA0105" 	, 0, 2},; 
							{"Rel. Pendencias"	  ,"U_ESTAREL1" 	, 0, 8},;
							{"Transf. Fornecedor" ,"U_ESTATRF1" 	, 0, 9}}



dbSelectArea("SZ8")
dbSetOrder(1)
dbGoTop()
mBrowse( 6, 1,22,75,"SZ8")

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0100  บAutor  ณMauro Sano          บ Data ณ  13/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manutencao.                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/        

User Function ESTA0100(cAlias,nReg,nOpcx)

Local aSize      := MsAdvSize()
Local aPosObj    := {}
Local aObjects   := {}
Local aArea      := GetArea()
Local nX         := 0
Local nOpcA      := 0
Local oDlg
Local aCpos      := {}
Local aButtons   := {}
Local nCntFor
Local _aCols1    := {}
Local _aHeader1  := {}

Private oGetDados
Private aTela[0][0]
Private aGets[0]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis de Memoria - Enchoice Principal         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SZ8")
DbSetOrder(1)
For	nX := 1 To FCount()
	If 	nOpcx == 4
		M->&(FieldName(nX)) := CriaVar(FieldName(nX))
	Else
		M->&(FieldName(nX)) := FieldGet(nX)
	EndIf      
Next nX        

If 	nOpcx == 4	
	M->Z8_COD := GetSxENum("SZ8","Z8_COD")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem do _aHeader1 - GetDados                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SX3")
DbSetOrder(1)
If 	DbSeek("SZ9", .F.)
	While !Eof() .And. SX3->X3_ARQUIVO == "SZ9"
		If 	X3USO(SX3->X3_USADO)
			aAdd(_aHeader1,{AllTrim(X3Titulo()),;
			AllTrim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT})
		EndIf
		DbSkip()
	EndDo
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem do aCols - GetDados                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If 	nOpcx == 4 //Inclusao
	aAdd(_aCols1,Array(Len(_aHeader1)+1))
	For nX := 1 To Len(_aHeader1)
		_aCols1[1,nX] := CriaVar(_aHeader1[nX,2])
	Next nX
	_aCols1[Len(_aCols1),Len(_aHeader1)+1] := .F.
Else
	DbSelectArea("SZ9")
	DbSetOrder(1)
	DbSeek(xFilial()+SZ8->Z8_COD)                                                       
	
	While !Eof() .And. SZ9->Z9_FILIAL = xFilial("SZ8") .And. SZ9->Z9_COD == SZ8->Z8_COD 
	
		aAdd(_aCols1,Array(Len(_aHeader1)+1))
		
		For nCntFor	:= 1 To Len(_aHeader1)
			If (_aHeader1[nCntFor][10] != "V")
				_aCols1[Len(_aCols1)][nCntFor] := FieldGet(FieldPos(_aHeader1[nCntFor][2]))
			Else
				_aCols1[Len(_aCols1)][nCntFor] := CriaVar(_aHeader1[nCntFor][2],.T.)
			EndIf
		Next nCntFor
		
		_aCols1[Len(_aCols1), Len(_aHeader1)+1] := .F.
		DbSkip()
	EndDo
Endif            

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta a tela										 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {}
aAdd(aObjects,{0,70,.T.,.F.})
aAdd(aObjects,{100,100,.T.,.T.})
aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)  

//#ASD20120625.bn
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAdicao de botoes - Enchoice Principal             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู    

If	nOpcx == 4 .or. nOpcx == 5
	AADD(aButtons,{"SELECTALL",{||CursorWait(),MsgRun(OemToAnsi("Aguarde, montando a tela para vincula็ใo..."),, {||U_ESTA0110()}), CursorArrow()},"Vincula Entidades ao PD"}) //Vincula Entidades ao PD
	AADD(aButtons,{"UNSELECTALL",{||CursorWait(),MsgRun(OemToAnsi("Aguarde, montando a tela para desvincula็ใo..."),, {||U_ESTA0120()}), CursorArrow()},"Desvincula Entidades ao PD"}) //Desvincula Entidades ao PD
EndIf

AADD(aButtons,{"SDUSTRUCT",{||CursorWait(),MsgRun(OemToAnsi("Aguarde, montando a tela de relacionamentos..."),, {||U_ESTA0104()}), CursorArrow()},"Consulta Entidades do PD"}) //Consulta Entidades do PD
AADD(aButtons,{"RELATORIO",{||CursorWait(),MsgRun(OemToAnsi("Aguarde, montando a consulta เs Notas Fiscais..."),, {||U_ESTA0105()}), CursorArrow()},"NFs"}) //Consulta Notas de Remessa e Retorno do fornecedor indicado no Ponto de Distribui็ใo
//#ASD20120625.en                       

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL

EnChoice( cAlias ,nReg, nOpcx, , , ,  ,APOSOBJ[1], , nOpcx)
oGetDados := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],Iif(nOpcx==2 .or. nOpcx==5, Nil,GD_INSERT+GD_DELETE+GD_UPDATE),"U_ESTA0102("+"'"+str(nOpcx)+"'"+")",,,,,999,,,,,_aHeader1,_aCols1)                                      

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,If(ESTA0103(nOpcx),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()},,aButtons)

If 	nOpca == 1 //Se tudo ok
	Begin 	Transaction
			ESTA0101(nOpcx,oGetDados:aHeader,oGetDados:aCols)
	End 	Transaction
EndIf    

If	!nOpca == 1 .and. nOpcx == 4 //Cancelamento da inclusใo  
	RollBackSX8()
EndIf

MsUnLockAll()

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0101  บAutor  ณMauro Sano          บ Data ณ  13/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gravacao.                                                  บฑฑ
ฑฑบ          ณ                 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ESTA0101(nOpc,_aHeadG,_aColsG)

Local nCntFor := 0
Local nCntFor1:= 0
Local nUsado  := Len(_aHeadG)
Local nUsado1 := Len(_aColsG)    
Local _cFornec:= aScan(_aHeadG,{|x|Alltrim(x[2])=="Z8_FORNEC"})
Local _cLoja  := aScan(_aHeadG,{|x|Alltrim(x[2])=="Z8_LOJA"})   

Do 	Case              

	Case	nOpc == 4 //Inclusao
		                    
			//Inclusao do cabecalho
			DbSelectArea("SZ8")
			Reclock("SZ8",.T.)
			For	nCntFor := 1 To FCount()
				If 	(FieldName(nCntFor) != "Z8_FILIAL")
					FieldPut(nCntFor,M->&(FieldName(nCntFor)))
				Else
					SZ8->Z8_FILIAL := xFilial()
				EndIf
			Next nCntFor
			MsUnlock()       
			
			//Inclusao dos itens
			For nCntFor := 1 To nUsado1
				If 	(!_aColsG[nCntFor][nUsado+1])
					DbSelectArea("SZ9")
					Reclock("SZ9",.T.)
					For nCntFor1 := 1 To nUsado
						If (_aHeadG[nCntFor1][10] != "V")
							SZ9->(FieldPut(FieldPos(Trim(_aHeadG[nCntFor1][2])),_aColsG[nCntFor][nCntFor1]))
						EndIf
					Next nCntFor1
					SZ9->Z9_FILIAL	:= xFilial("SZ9")
					SZ9->Z9_COD 	:= M->Z8_COD 
					SZ9->Z9_FORNEC	:= M->Z8_FORNEC
					SZ9->Z9_LOJA	:= M->Z8_LOJA
					MsUnlock()
				EndIf
			Next nCntFor 
			
			ConfirmSX8()
		
	Case 	nOpc == 5 //Alteracao
		
			//Alteracao do cabecalho
			DbSelectArea("SZ8")
			Reclock("SZ8",.F.)
			For nCntFor := 1 To FCount()
				If (FieldName(nCntFor) != "Z8_FILIAL")
					FieldPut(nCntFor,M->&(FieldName(nCntFor)))
				Else
					SZ8->Z8_FILIAL := xFilial()
				EndIf
			Next nCntFor
			MsUnlock()
		
			//Exclusao dos itens
			DbSelectArea("SZ9")
			DbSetOrder(1)
			If 	DbSeek(xFilial()+M->Z8_COD)
				While 	!Eof() .And. SZ9->Z9_FILIAL == xFilial() .And. SZ9->Z9_COD == M->Z8_COD 
						Reclock("SZ9",.F.)
						dbDelete()
						MsUnlock()
						dbSkip()
				EndDo
			EndIf
		
			//Inclusao dos itens
			For nCntFor := 1 To nUsado1
				If (!_aColsG[nCntFor][nUsado+1])
					dbSelectArea("SZ9")
					Reclock("SZ9",.T.)
					For nCntFor1 := 1 To nUsado
						If (_aHeadG[nCntFor1][10] != "V")
							SZ9->(FieldPut(FieldPos(Trim(_aHeadG[nCntFor1][2])),_aColsG[nCntFor][nCntFor1]))
						EndIf
					Next nCntFor1
					SZ9->Z9_FILIAL	:= xFilial("SZ9")
					SZ9->Z9_COD		:= M->Z8_COD  
					SZ9->Z9_FORNEC	:= M->Z8_FORNEC
					SZ9->Z9_LOJA	:= M->Z8_LOJA
					MsUnlock()
				EndIf
			Next nCntFor
		
	Case 	nOpc == 6 //Exclusao  

			//Exclusao dos itens
			DbSelectArea("SZ9")
			DbSetOrder(1)
			
			If 	DbSeek(xFilial()+M->Z8_COD)
				While 	!Eof() .And. SZ9->Z9_FILIAL == xFilial() .And. SZ9->Z9_COD == M->Z8_COD 
						Reclock("SZ9",.F.)
						DbDelete()
						MsUnlock()
						DbSkip()
				EndDo
			EndIf
			
			//Exclusao do cabecalho
			DbSelectArea("SZ8")
			Reclock("SZ8",.F.)
			dbDelete()
			MsUnlock()
	
EndCase

Return ()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0102 บAutor  ณMauro Sano          บ Data ณ  13/12/09    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao da linha da getdados - equivale a LinhaOK.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ESTA0102(_nOpc,_nPosAtu)

Local _lRet 	 := .T.  
Local _nDel 	 := Len(oGetDados:aHeader)+1 //posicao do item para ativo ou deletado 
Local _nPosPrd := aScan(oGetDados:aHeader,{|x|Alltrim(x[2])=="Z9_PROD"}) 
Local _nPosMin := aScan(oGetDados:aHeader,{|x|Alltrim(x[2])=="Z9_ESTMIN"})
Local _nPosMax := aScan(oGetDados:aHeader,{|x|Alltrim(x[2])=="Z9_ESTMAX"}) 
Local _nx      := 0 

If 	Empty(_nPosAtu)          
	_nPosAtu := n
EndIf
                      
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclusao/Alteracao - valida chave aCols           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	Alltrim(_nOpc) == "4" .or. Alltrim(_nOpc) == "5" 	//Inclusao/alteracao
	
	If	!oGetDados:aCols[_nPosAtu][_nDel] 	//Item nao deletado
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se produto ja existe no aColsณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nx := 1 to Len(oGetDados:aCols) 					   				//Verifica repeticoes do produto
			If	_nx <> _nPosAtu .and.;  						 				//Nใo esta na mesma linha posicionado do aCols
				(!oGetDados:aCols[_nx][_nDel]) .and.;							//Nใo deletado
				oGetDados:aCols[_nx][_nPosPrd] == oGetDados:aCols[_nPosAtu][_nPosPrd]  	//ษ mesmo produto 
			
				Alert(	"Produto jแ utilizado para este Ponto de Distribui็ใo!"+chr(13)+;
						"A็ใo nใo permitida!")
				
				_lRet := .F.
				
				Exit
			EndIf
		Next _nx
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica estoque minimo contra maximoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู       
		If	!oGetDados:aCols[_nPosAtu][_nPosMin] <= oGetDados:aCols[_nPosAtu][_nPosMax]
			Alert(	"Estoque mํnimo deve ser menor ou igual ao estoque mแximo!"+chr(13)+;
					"A็ใo nใo permitida!")
				
				_lRet := .F.        
		EndIf
	EndIf
EndIf
				 		  
Return (_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0103  บAutor  ณMauro Sano          บ Data ณ  13/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao botao OK - equivale a TudoOK.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ESTA0103(_nOpc)

Local _lRet := .T.
Local _nz := 0

If	_nOpc == 6 //Exclusao  

	DbSelectArea("SZ3")
	SZ3->(DbOrderNickName("PONDISTRIB")) 
			
	If	SZ3->(DbSeek(xFilial("SZ3")+SZ8->Z8_COD))  
		Alert(	"Existem entidades referenciando este Ponto de Distribui็ใo!"+chr(13)+;
				"A exclusใo nใo serแ possํvel!")    
		_lRet := .F.
	EndIf     
	
	SZ3->(DbCloseArea())
EndIf               

If	_nOpc == 4 .or. _nOpc == 5 	//Inclusao/alteracao
	For _nz := 1 to Len(oGetDados:aCols)
		_lRet := U_ESTA0102(str(_nOpc),_nz)
		If 	!_lRet
			Exit
		EndIf
	Next _nz
EndIf
		
Return (_lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0104บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Botao consulta Entidades do Ponto de Distribui็ใo          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/             

User Function ESTA0104()

Local aArea    	:= GetArea()
Local aPosObj  	:= {}
Local aObjects 	:= {}
Local aSize    	:= MsAdvSize(.F.)
Local nOpc 		:= 2
Local cCodEnt  	:= sz8->z8_cod //M->Z8_COD
Local cNomEnt  	:= sz8->z8_desc //M->Z8_DESC
Local nOpcA    	:= 0
Local cSeek    	:= ""
Local cWhile   	:= "" 
Local aNoFields := {}		// Campos que nao serao apresentados no _aCols2      
Local aYesFields:= {"Z3_CODGAR","Z3_DESENT","Z3_TIPENT","Z3_CODAR","Z3_DESAR","Z3_CODAC","Z3_DESAC","Z3_CODENT"}
Local bCond     := {|| .T.}	// Se bCond .T. executa bAction1, senao executa bAction2
Local bAction1  := {|| .T.}	// Retornar .T. para considerar o registro e .F. para desconsiderar
Local bAction2  := {|| .F.}	// Retornar .T. para considerar o registro e .F. para desconsiderar
Local oDlg
Local oGetD
Local oGet
Local oGet2    
Local _aHeader2	:= {}
Local _aCols2  	:= {}
Local aButtons := {}

aadd(aButtons,{'BUDGETY',{|| ESTA0104Imp() },'Impressใo','ฎ Imprimir'})

DbSelectArea("SZ3") 
SZ3->(DbOrderNickName("PONDISTRIB")) 

cSeek  := xFilial( "SZ3" ) + cCodEnt
cWhile := "SZ3->Z3_FILIAL + SZ3->Z3_PONDIS"   
FillGetDados(nOpc,"SZ3",5,cSeek,{|| &cWhile },{{bCond,bAction1,bAction2}},aNoFields,aYesFields,.T.,/*cQuery*/,/*bMontCols*/,.F.,_aHeader2,_aCols2,/*bAfterCols*/,/*bBeforeCols*/)

If	!Empty(_aCols2[1][1])

	AAdd( aObjects, { 100,  44, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	DEFINE MSDIALOG oDlg TITLE "Entidades do Ponto de Distribui็ใo" FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	
	@ 019,005 SAY "Ponto Distr." SIZE 040,009 OF oDlg PIXEL // "Ponto Distr."
	@ 018,050 GET oGet  VAR cCodEnt SIZE 120,009 OF oDlg PIXEL WHEN .F.
	
	@ 032,005 SAY "Identifica็ใo" SIZE 040,009 OF oDlg PIXEL // "Identifica็ใo"
	@ 031,050 GET oGet2 VAR cNomEnt SIZE 120,009 OF oDlg PIXEL WHEN .F.
				
	oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"AlwaysTrue","AlwaysTrue",,,,999,,,.F.,,_aHeader2,_aCols2)
		
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=1)},{||nOpcA:=1,oDlg:End()},,aButtons) 
			     
Else
	Alert("Nใo existem entidades cadastradas com este Ponto de Distribui็ใo!")
EndIf                                           

RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0105บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Botao consulta Notas Fiscais do fornecedor indicado no     บฑฑ
ฑฑบ          ณ Ponto de Distribui็ใo                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/             

User Function ESTA0105(_cCodPD)

Local aArea    	:= GetArea()
Local nOpc 		:= 2
Local cCodEnt  	:= sz8->Z8_COD
Local cNomEnt  	:= sz8->Z8_DESC
Local _cNome	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+sz8->Z8_FORNEC+sz8->Z8_LOJA,"A2_NOME"))
Local nOpcA    	:= 0
Local _cSeekF2  := ""
Local _cWhileF2  := ""  
Local _cSeekD1  := ""
Local _cWhileD1  := "" 
Local aNoFields := {}	// Campos que nao serao apresentados no _aCols2      
Local aYesFields:= {}	// Campos que serao apresentados no _aCols2
Local oGet 	//Fornecedor
Local oGet2 //Loja      
Local oGet3	//Nome           
Local oGet4	//Total enviado
Local oGet5	//Total retornado
Local oGet6	//Saldo
Local _aHeaderD2:= {}
Local _aColsD2  := {} 
Local _aHeaderD1:= {}
Local _aColsD1	:= {}
Local _cQueryD1 := ""
Local _cQueryD2 := ""
Local _nPEmisD2 := 0
Local _nPFornD2	:= 0
Local _nPLojaD2	:= 0
Local _nPDocD2	:= 0
Local _nPSerD2	:= 0
Local _nPIteD2	:= 0
Local _nPQtdD2	:= 0 
Local _nPDocD1	:= 0
Local _nPSerD1	:= 0
Local oBold			// Objeto para deixar a fonte em negrito   
Local aPosObj  	:= {}
Local aObjects 	:= {}
Local aSize    	:= MsAdvSize(.F.)  
Local oDlg                         
Local oGetD2 		// GetDados com as Notas Fiscais de Saํda
Local oGetD1		// GetDados com as Notas Fiscais de Entrada - itens     
Local _aColsD1Or := {}     
Local _aColsD1Fi := {}        
Local _nTSai	 := 0
Local _nTEnt	 := 0
Local _nTSld	 := 0
 
Private _cForn	:= sz8->Z8_FORNEC
Private _cLoja	:= sz8->Z8_LOJA        

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem do _aHeaderD2 - GetDados - NFS         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SX3")
DbSetOrder(1)
If 	DbSeek("SD2", .F.)
	While !Eof() .And. SX3->X3_ARQUIVO == "SD2"
		aAdd(_aHeaderD2,{AllTrim(X3Titulo()),;
		AllTrim(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT})
		DbSkip()
	EndDo
EndIf       

DbSelectArea("SD2") 
SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM 

_cQueryD2 := U_ESTA0108(_cForn,_cLoja)

//_cSeekD2  := xFilial( "SD2" ) + _cForn + _cLoja
//_cWhileD2 := "SD2->D2_FILIAL + SD2->D2_CLIENTE + SD2->D2_LOJA"
FillGetDados(nOpc,"SD2",3,/*_cSeekD2*/,/*{|| &_cWhileD2 }*/,/*{|| SD2->D2_TIPO $ "B/D"}*/,aNoFields,aYesFields,.T.,_cQueryD2,/*bMontCols*/,.F.,_aHeaderD2,_aColsD2,/*bAfterCols*/,/*bBeforeCols*/, , , , , aYesFields) 

If	!Empty(_aColsD2[1][1])

	AAdd( aObjects, { 100,  44, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ]-10, aSize[ 4 ]-10, 3, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )  
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria listbox, para escolha dos produtos que podem ser retiradosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE FONT oBold    NAME "Arial" SIZE 0, -12 BOLD
	
	DEFINE MSDIALOG oDlg TITLE "Notas Fiscais de Saํda / Entrada do Fornecedor" FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	
	@ 019,005 SAY "Fornecedor" SIZE 040,009 OF oDlg PIXEL // "Fornecedor"
	@ 018,050 GET oGet  VAR _cForn SIZE 120,009 OF oDlg PIXEL WHEN .F.
	
	@ 019,250 SAY "Loja" SIZE 040,009 OF oDlg PIXEL // "Loja"
	@ 018,280 GET oGet2 VAR _cLoja SIZE 120,009 OF oDlg PIXEL WHEN .F. 
	
	@ 032,005 SAY "Nome" SIZE 040,009 OF oDlg PIXEL // "Nome"
	@ 031,050 GET oGet3 VAR _cNome SIZE 120,009 OF oDlg PIXEL WHEN .F. 
	
   	@ 047,005 SAY "NOTAS FISCAIS DE SAIDA" SIZE 200,009 OF oDlg PIXEL FONT oBold // "NOTAS FISCAIS DE SAIDA" 
   					
	oGetD2 := MsNewGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],(aPosObj[2,3]/2)-5,aPosObj[2,4]-5,nOpc,"AlwaysTrue","AlwaysTrue",,{},,999,,,.F.,,_aHeaderD2,_aColsD2) 
	
	//oGetD2:aCols := ASort( oGetD2:aCols,,, { |x,y| dtos(x[_nPEmisD2])+x[_nPDocD2]+x[_nPSerD2]+x[_nPIteD2] < dtos(y[_nPEmisD2])+y[_nPDocD2]+y[_nPSerD2]+y[_nPIteD2] } ),;	
	//oGetD2:oBrowse:Refresh(),;
	
	_nPEmisD2	:= Ascan( oGetD2:aHeader, { |x| AllTrim(x[2])=="D2_EMISSAO" } )        
	_nPFornD2	:= Ascan( oGetD2:aHeader, { |x| AllTrim(x[2])=="D2_CLIENTE" } )
	_nPLojaD2	:= Ascan( oGetD2:aHeader, { |x| AllTrim(x[2])=="D2_LOJA" } )
	_nPDocD2	:= Ascan( oGetD2:aHeader, { |x| AllTrim(x[2])=="D2_DOC" } )
	_nPSerD2	:= Ascan( oGetD2:aHeader, { |x| AllTrim(x[2])=="D2_SERIE" } ) 
	_nPIteD2	:= Ascan( oGetD2:aHeader, { |x| AllTrim(x[2])=="D2_ITEM" } ) 
	_nPQtdD2	:= Ascan( oGetD2:aHeader, { |x| AllTrim(x[2])=="D2_QUANT" } )
	   
	@ (aPosObj[2,3]/2)+5,005 SAY "NOTAS FISCAIS DE ENTRADA / RETORNO" SIZE 200,009 OF oDlg PIXEL FONT oBold // "NOTAS FISCAIS DE ENTRADA / RETORNO"

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do _aHeaderD1 - GetDados - NFE        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SX3")
	DbSetOrder(1)
	If 	DbSeek("SD1", .F.)
		While !Eof() .And. SX3->X3_ARQUIVO == "SD1"
			aAdd(_aHeaderD1,{AllTrim(X3Titulo()),;
			AllTrim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT})
		DbSkip()
		EndDo
	EndIf    
		
	DbSelectArea("SD1") 
	SD1->(DbSetOrder(3)) //D1_FILIAL+DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA  

	_cQueryD1 := U_ESTA0106(_cForn,_cLoja)
	
	//_cSeekD1  	:= xFilial( "SD1" ) + _cForn + _cLoja
	//_cWhileD1 	:= "SD1->D1_FILIAL + SD1->D1_FORNECE + SD1->D1_LOJA"

	FillGetDados(nOpc,"SD1",1,/*_cSeekD1*/,/*{||&_cWhileD1}*/,,aNoFields,aYesFields,.T.,_cQueryD1,,.F.,_aHeaderD1,_aColsD1,,,,,,,aYesFields)
	oGetD1 := MsNewGetDados():New((aPosObj[2,3]/2)+15,aPosObj[2,2],aPosObj[2,3]-15,aPosObj[2,4]-5,nOpc,"AlwaysTrue","AlwaysTrue",,{},,999,,,.F.,,_aHeaderD1,_aColsD1)
	
	@ aPosObj[2,3]-10,005 SAY "Total enviado" SIZE 040,009 OF oDlg PIXEL // "Total saํda"
	@ aPosObj[2,3]-9,055 GET oGet4  VAR _nTSai SIZE 120,009 OF oDlg PIXEL WHEN .F.
	
	@ aPosObj[2,3]-10,200 SAY "Total retornado" SIZE 040,009 OF oDlg PIXEL // "Total entrada"
	@ aPosObj[2,3]-9,250 GET oGet5 VAR _nTEnt SIZE 120,009 OF oDlg PIXEL WHEN .F. 
	
	@ aPosObj[2,3]-10,445 SAY "Saldo" SIZE 040,009 OF oDlg PIXEL // "Saldo"
	@ aPosObj[2,3]-9,495 GET oGet6 VAR _nTSld SIZE 120,009 OF oDlg PIXEL WHEN .F.
	
	_aColsD1Or := oGetD1:aCols
	
	oGetD2:bChange := {|| 	oGetD1:aCols := U_ESTA0107(oGetD1:aHeader,_aColsD1Or,oGetD2:aCols[oGetD2:oBrowse:nat][_nPDocD2],oGetD2:aCols[oGetD2:oBrowse:nat][_nPSerD2],oGetD2:aCols[oGetD2:oBrowse:nat][_nPIteD2]),;
						  	_nTSai := aCols[oGetD2:oBrowse:nat][_nPQtdD2], _nTEnt := U_ESTA0109(oGetD1:aHeader,oGetD1:aCols) , _nTSld := _nTSai-_nTEnt,;
						  	oGetD1:Refresh(), oGet4:Refresh(), oGet5:Refresh(), oGet6:Refresh() }
							    	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetD2:TudoOk(),oDlg:End(),nOpcA:=1)},{||nOpcA:=1,oDlg:End()}) 
Else
	Alert("Nใo existem Notas Fiscais para o fornecedor deste Ponto de Distribui็ใo!")
EndIf          

RestArea(aArea)

Return()      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0106บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta query NFs Entrada                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function ESTA0106(_cFor, _cLoj)

Local _cQueryNF := ""

_cQueryNF := "SELECT * "		
_cQueryNF += "FROM " + RetSqlName("SD1") + " SD1 "
_cQueryNF += "WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "' "
_cQueryNF += "AND SD1.D1_FORNECE = '"+_cFor+"' "
_cQueryNF += "AND SD1.D1_LOJA = '"+_cLoj+"' "
_cQueryNF += "AND SD1.D1_TIPO NOT IN ('B','D') "
_cQueryNF += "AND SD1.D_E_L_E_T_ = ' ' "
_cQueryNF += "ORDER BY SD1.D1_EMISSAO, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_ITEM, SD1.D1_NFORI, SD1.D1_SERIORI "
      
Return (_cQueryNF)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0107บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza aCols SD1                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

User Function ESTA0107(_aHeadD1,_aColOr, _cNFS, _cSerS, _cIteS)

Local _nt := 0            
Local _aRet  := {}   
Local _nPEmi := Ascan(_aHeadD1,{|x|AllTrim(x[2])=="D1_EMISSAO"})
Local _nPDoc := Ascan(_aHeadD1,{|x|AllTrim(x[2])=="D1_DOC"})
Local _nPSer := Ascan(_aHeadD1,{|x|AllTrim(x[2])=="D1_SERIE"})
Local _nPIte := Ascan(_aHeadD1,{|x|AllTrim(x[2])=="D1_ITEM"}) 
Local _nPNFO := Ascan(_aHeadD1,{|x|AllTrim(x[2])=="D1_NFORI"})                                            
Local _nPSerO:= Ascan(_aHeadD1,{|x|AllTrim(x[2])=="D1_SERIORI"})
Local _nPIteO:= Ascan(_aHeadD1,{|x|AllTrim(x[2])=="D1_ITEMORI"})

For _nt := 1 to Len(_aColOr)
	If	Alltrim(_aColOr[_nt][_nPNFO])+Alltrim(_aColOr[_nt][_nPSerO])+Alltrim(_aColOr[_nt][_nPIteO]) == Alltrim(_cNFS)+Alltrim(_cSerS)+Alltrim(_cIteS)
     	Aadd(_aRet, _aColOr[_nt] )    
 	EndIf
Next _nt   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณOrdena array para apresentacao na sequencia corretaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_aRet := ASort( _aRet,,, { |x,y| dtos(x[_nPEmi])+x[_nPDoc]+x[_nPSer]+x[_nPIte] < dtos(y[_nPEmi])+y[_nPDoc]+y[_nPSer]+y[_nPIte] } )

Return(_aRet)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0108บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta query NFs Saํda                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function ESTA0108(_cFor, _cLoj)

Local _cQueryNF := ""

_cQueryNF := "SELECT * "		
_cQueryNF += "FROM " + RetSqlName("SD2") + " SD2 "
_cQueryNF += "WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
_cQueryNF += "AND SD2.D2_CLIENTE = '"+_cFor+"' "
_cQueryNF += "AND SD2.D2_LOJA = '"+_cLoj+"' "
_cQueryNF += "AND SD2.D2_TIPO IN ('B','D') "
_cQueryNF += "AND SD2.D_E_L_E_T_ = ' ' "
_cQueryNF += "ORDER BY SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_ITEM "
      
Return (_cQueryNF) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0109บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta query para saldo = NFS - NFE                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function ESTA0109(_aHeaderSD1, _aColsSD1)

Local _nTotalEnt:= 0
Local _nPQtdD1	:= Ascan( _aHeaderSD1, { |x| AllTrim(x[2])=="D1_QUANT" })
Local _ny		:= 0

For _ny := 1 to Len(_aColsSD1) 
	_nTotalEnt += _aColsSD1[_ny][_nPQtdD1]
Next _ny 
		
Return (_nTotalEnt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0110บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta tela para a vincula็ใo PD x Entidade                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function ESTA0110()  
                                                                                           
Local _aArea := GetArea() 
Local cFilter	:= "Z3_TIPENT == '4'" 
Local _cItMark 	:= ""       
Local _cSelec   := ""
Local _nx  		:= 0                          
Local nTamCpo 	:= TamSX3("Z3_CODGAR")[1] 
Local _cQuery1	:= ""
Local __cqry    := ""


DbSelectArea("SZ3")
SZ3->(DbSetOrder())
SZ3->(DbGoTop())  

__cqry := __cqry + " SELECT  DISTINCT Z3_CODGAR              "+CRLF
__cqry := __cqry + " FROM "+retSqlName("SZ3")+"              "+CRLF
__cqry := __cqry + " WHERE                                   "+CRLF
__cqry := __cqry + " Z3_PONDIS     = '"+SZ8->Z8_COD+"'  AND  "+CRLF
__cqry := __cqry + " Z3_TIPENT     = '4'                AND  "+CRLF  
__cqry := __cqry + " Z3_ATIVO     <> 'N'                AND  "+CRLF
__cqry := __cqry + " D_E_L_E_T_    = ' '                     "+CRLF
tcquery __cqry new alias "TSZ3"
while !tsz3->(eof())   
   _cSelec += tsz3->z3_codgar
   tsz3->(dbskip())
end-while
tsz3->(dbclosearea())

/*
While 	SZ3->(!EOF())  
		If	Alltrim(SZ3->Z3_PONDIS) == Alltrim(SZ8->Z8_COD) .and. SZ3->Z3_TIPENT == "4" .and. SZ3->Z3_ATIVO <> "N"
			_cSelec += SZ3->Z3_CODENT     
		EndIf
		SZ3->(DbSkip())
EndDo  
*/
			                                                            
_cItMark 	:= U_ESTA0130( "SZ3" , "Z3_CODGAR" , "Z3_DESENT" , .F. , NIL , cFilter, _cSelec,"Vincula็ใo PD x Entidades",,,,,.F.,"SZ3_05" )
sz3->(dbsetorder(4))//Z3_PEDGAR     
If	!Empty(_cItMark)
	If	MsgYesNo ("Confirma a vincula็ใo deste PD เ(s) entidade(s) selecionadas?")
		For _nx := 1 To Len(_cItMark) Step nTamCpo
			If 	SZ3->(DbSeek(xFilial("SZ3")+SubStr(_cItMark,_nx,nTamCpo)))
				Reclock("SZ3",.F.)
				SZ3->Z3_PONDIS := SZ8->Z8_COD
				MsUnlock()
			EndIf
		Next _nx  
		Alert("Vincula็ใo efetuada! ษ possํvel verificar os efeitos da a็ใo por meio do botใo 'Consulta Entidades do PD'.")
	EndIf
EndIf

Return() 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0120บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta tela para desvincula็ใo PD x Entidade                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function ESTA0120()  
                                                                                           
Local _aArea := GetArea() 
Local cFilter	:= "Z3_TIPENT == '4'" //"Z3_PONDIS == '"+SZ8->Z8_COD+"'"
Local _cItMark 	:= ""       
Local _cSelec   := ""
Local _nx  		:= 0                          
Local nTamCpo 	:= TamSX3("Z3_CODGAR")[1]   
Local _cQuery1	:= ""
Local __cqry    := ""

DbSelectArea("SZ3")
SZ3->(DbSetOrder())
SZ3->(DbGoTop())
	
__cqry := __cqry + " SELECT  DISTINCT Z3_CODGAR                "+CRLF
__cqry := __cqry + " FROM "+retSqlName("SZ3")+"                "+CRLF
__cqry := __cqry + " WHERE                                     "+CRLF
__cqry := __cqry + " ( Z3_PONDIS    = '      ' OR              "+CRLF
__cqry := __cqry + " Z3_PONDIS     <> '"+SZ8->Z8_COD+"' ) AND  "+CRLF
__cqry := __cqry + " Z3_TIPENT      = '4'                 AND  "+CRLF  
__cqry := __cqry + " Z3_ATIVO      <> 'N'                 AND  "+CRLF
__cqry := __cqry + " D_E_L_E_T_     = ' '                      "+CRLF
tcquery __cqry new alias "TSZ3"

while !tsz3->(eof())   
   _cSelec += tsz3->z3_codgar
   tsz3->(dbskip())
end-while
tsz3->(dbclosearea())
	
/*
While 	SZ3->(!EOF())  
		If	(Empty(SZ3->Z3_PONDIS) .or. !Alltrim(SZ3->Z3_PONDIS) == Alltrim(SZ8->Z8_COD)) .and. SZ3->Z3_TIPENT == "4" .and. SZ3->Z3_ATIVO <> "N"
			_cSelec += SZ3->Z3_CODENT     
		EndIf
		SZ3->(DbSkip())
EndDo
*/   
		 		                                                            
_cItMark 	:= U_ESTA0130( "SZ3" , "Z3_CODGAR" , "Z3_DESENT" , .F. , NIL , cFilter, _cSelec,"Desvincula็ใo PD x Entidades",,,,,.F.,"SZ3_05" )

sz3->(dbsetorder(4))//Z3_PEDGAR     

If	!Empty(_cItMark)     
	If	MsgYesNo ("Confirma a desvincula็ใo deste PD เ(s) entidade(s) selecionadas?")
		For _nx := 1 To Len(_cItMark) Step nTamCpo    
			If 	SZ3->(DbSeek(xFilial("SZ3")+SubStr(_cItMark,_nx,nTamCpo)))
			    
				Reclock("SZ3",.F.)
				SZ3->Z3_PONDIS := ""
				MsUnlock()
			EndIf
		Next _nx       
		Alert("Desvincula็ใo efetuada! ษ possํvel verificar os efeitos da a็ใo por meio do botใo 'Consulta Entidades do PD'.")
	EndIf
EndIf

Return()                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTA0130บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta tela para amarracao PD x Entidade                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function ESTA0130(;
							cAlias 			,;	//01 -> Alias
							cField 			,;	//02 -> Campo de Codigo
							cFieldDesc		,;	//03 -> Campo que contem a descricao
							l1Elem			,;	//04 -> Se serแ permitido selecionar apenas um unico elemento
							nMaxElem		,;	//05 -> Maximo de Elementos para Selecao
							cFilter			,;	//06 -> Se Devera Filtar a Tabela para a carga das informacoes
							cPreSelect		,;	//07 -> Elementos que ja foram pre-selecionados
							cTitulo			,;	//08 -> Titulo para f_Opcoes
							lMultSelect		,;	//09 -> Inclui Botoes para Selecao de Multiplos Itens
							lComboBox		,;	//10 -> Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
							lNotOrdena		,;	//11 -> Nao Permite a Ordenacao
							lNotPesq		,;	//12 -> Nao Permite a Pesquisa	
							lForceRetArr    ,;	//13 -> Forca o Retorno Como Array
							cF3				 ;	//14 -> Consulta F3
						 )

Local aPreSelect	:= {}
Local aOpcoes		:= {}

Local cFil			:= xFilial( cAlias )
Local cMvPar		:= &( Alltrim( ReadVar() ) )
Local cMvParDef		:= ""
Local cMvRetor		:= ""
Local cMvParam		:= ""
Local cReplicate	:= ""

Local cFieldFil

Local lFilExistField

Local nFor			:= 0
Local nLenFor		:= Len( AllTrim( cMvPar ) )
Local nTamCpo		:= 0
Local nInfoTable

DEFAULT l1Elem 			:= .F.
DEFAULT cPreSelect		:= ""
DEFAULT cMvPar			:= SetMemVar( "__NoExistVar__" , "" , .T. )

DEFAULT lMultSelect		:= .T.
DEFAULT lComboBox		:= .F.
DEFAULT lNotOrdena		:= .F.
DEFAULT lNotPesq		:= .F.
DEFAULT lForceRetArr    := .F.
DEFAULT cF3				:= cAlias

cField		:= Upper( AllTrim( cField ) )
nTamCpo		:= TamSX3(cField)[1]
cReplicate  := Replicate( "*" , nTamCpo )

CursorWait()

If 	!( l1Elem )
	nLenFor := Len( AllTrim( cMvPar ) )
	For nFor := 1 To nLenFor
		cMvParam += SubStr( cMvPar , nFor , nTamCpo )
		cMvParam += cReplicate
	Next nFor
EndIf

cMvPar := cMvParam
lFilExistField	:= FilExistField( cAlias , @cFieldFil )

DEFAULT __aInfoTable__	:= {}

If 	( ( nInfoTable := aScan( __aInfoTable__ , { |x| x[1] == cAlias } ) ) == 0 )
	aAdd( __aInfoTable__ , { cAlias , NIL , {} } )
	nInfoTable := Len( __aInfoTable__ )
EndIf

If 	( Empty( __aInfoTable__[ nInfoTable , 3 ] ) )
	If 	( lFilExistField )
		( cAlias )->( dbSetOrder( RetOrder( cAlias , cFieldFil + cField ) ) )
	Else
		( cAlias )->( dbSetOrder( RetOrder( cAlias , cField ) ) )
	EndIf	
	BldaMrkOpcoes( @cAlias , @cFil , @cField , @cFieldDesc , @cFieldFil , @cFilter , @__aInfoTable__ , @nInfoTable )
EndIF	

nLenFor := Len( cPreSelect )

For nFor := 1 To Len( cPreSelect ) Step nTamCpo
	aAdd( aPreSelect , SubStr( cPreSelect , nFor , nTamCpo ) )
Next nFor

nLenFor := Len( __aInfoTable__[ nInfoTable , 3 ] )

For nFor := 1 To nLenFor
	IF ( aScan( aPreSelect , SubStr( __aInfoTable__[ nInfoTable , 3 , nFor ] , 1 , nTamCpo ) ) == 0 )
		cMvParDef += SubStr( __aInfoTable__[ nInfoTable , 3 , nFor ] , 1 , nTamCpo )
		aAdd( aOpcoes , __aInfoTable__[ nInfoTable , 3 , nFor ] )
	EndIF
Next nFor

CursorArrow()

If (;
		Empty( cTitulo );
		.and.;
		GetCache( "SX2" , cAlias , NIL , NIL , 1 , .T. );
	)	
	cTitulo := GetCache( "SX2" , cAlias , NIL , "X2Nome()" , 1 , .F. )
EndIf

DEFAULT nMaxElem	:= Len( aOpcoes )

If 	f_Opcoes(;
				@cMvPar 		,;	//01 -> Variavel de Retorno
				cTitulo   		,;	//02 -> Titulo da Coluna com as opcoes
				aOpcoes   		,;	//03 -> Opcoes de Escolha (Array de Opcoes)
				cMvParDef 		,;	//04 -> String de Opcoes para Retorno
				NIL				,;	//05 -> Nao Utilizado
				NIL				,;	//06 -> Nao Utilizado
				l1Elem			,;	//07 -> Se a Selecao sera de apenas 1 Elemento por vez
				nTamCpo			,;	//08 -> Tamanho da Chave
				nMaxElem		,;	//09 -> No maximo de elementos na variavel de retorno	
				lMultSelect		,;	//10 -> Inclui Botoes para Selecao de Multiplos Itens
				lComboBox		,;	//11 -> Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
				cField			,;	//12 -> Qual o Campo para a Montagem do aOpcoes
				lNotOrdena		,;	//13 -> Nao Permite a Ordenacao
				lNotPesq		,;	//14 -> Nao Permite a Pesquisa	
				lForceRetArr    ,;	//15 -> Forca o Retorno Como Array
				cF3				 ;	//16 -> Consulta F3
			 )

	CursorWait()

	nLenFor := Len( cMvPar )
	For nFor := 1 To nLenFor Step nTamCpo
		If ( SubStr( cMvpar , nFor , nTamCpo ) # cReplicate )
			cMvRetor += SubStr( cMvPar , nFor , nTamCpo )
		EndIf
	Next nFor

	&( Alltrim( ReadVar() ) ) := AllTrim( cMvRetor )

	CursorArrow()

EndIF

Return(cMvPar)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณBldaMrkOpcoesบAutor  ณAldoney Dias     บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta tela para amarracao PD x Entidade                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

Static Function BldaMrkOpcoes(;
									cAlias		,;	//01 -> Apelido da Tabela
									cFil		,;	//02 -> Filial
									cField		,;	//03 -> Campo de Codigo
									cFieldDesc	,;	//04 -> Campo de Descricao
									cFieldFil	,;	//05 -> Campo da Filial
									cFilter		,;	//06 -> Filtro a Ser Executado para a Carga das Informacoes
									aInfoTable	,;	//07 -> Array com Informacoes da Tabela
									nInfoTable	 ;	//08 -> Posicao da Tabela no Array
							  )

Local aArea		:= GetArea()
Local aQuery	:= {}
Local aHeader	:= {}
Local aIndex	:= {}

Local bAscan	:= { |x| ( x == cCpoDes ) } 
Local bSkip		:= { || .F. }
Local cCntCpo	:= ""
Local cCpoDes	:= ""

Begin Sequence

	If ( ( cAlias )->( FieldPos( cField ) ) == 0 )
		Break
	EndIF

	bSkip	:= { || (;
						cCpoDes := (;
										( cCntCpo := &( cField ) )	+ ;
										" - "						+ ;
										&( cFieldDesc )				  ;
										);
						 ),;
						 IF( aScan( aInfoTable[ nInfoTable , 3 ] , bAscan ) == 0 .and. !Empty( cCntCpo ),;
						 	 aAdd( aInfoTable[ nInfoTable , 3 ] , cCpoDes ),;
						 	 NIL;
						 	),;
						 (;
						 	cCntCpo	:= "" ,;
						 	.F.;
						 );	
					}

	IF !Empty( aInfoTable[ nInfoTable , 2 ] )
		aHeader := aInfoTable[ nInfoTable , 2 ]
	EndIF	

	#IFDEF TOP
		IF (;
				( cAlias )->( RddName() == "TOPCONN" );
				.and.;
				Empty( cFilter );
			)	
			If !Empty( cFieldFil )
				aQuery		:= Array( 03 )
				aQuery[01]	:= cFieldFil+"='"+cFil+"'"
				aQuery[02]	:= " AND "
				aQuery[03]	:= "D_E_L_E_T_<>'*' "
			EndIF
		EndIF
	#ENDIF

	If !Empty( cFilter )

		( cAlias )->( FilBrowse( cAlias , @aIndex , cFilter ) )

	EndIf

	( cAlias )->( GdBuildCols(	aHeader			,;	//01 -> Array com os Campos do Cabecalho da GetDados
								NIL				,;	//02 -> Numero de Campos em Uso
								NIL				,;	//03 -> [@]Array com os Campos Virtuais
								NIL				,;	//04 -> [@]Array com os Campos Visuais
								NIL				,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
								{				 ;
									cFieldFil	,;
									cField		,;
									cFieldDesc	 ;
								}				,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
								NIL				,;	//07 -> [@]Array unidimensional contendo os Recnos
								cAlias			,;	//08 -> Alias do Arquivo Pai
								cFil			,;	//09 -> Chave para o Posicionamento no Alias Filho
								NIL				,;	//10 -> Bloco para condicao de Loop While
								bSkip			,;	//11 -> Bloco para Skip no Loop While
								.F.				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
								.F.				,;	//13 -> Se Sera considerado o Inicializador Padrao
								.F.				,;	//14 -> Opcional, Carregar Todos os Campos
								.F.				,;	//15 -> Opcional, Nao Carregar os Campos Virtuais
								aQuery			,;	//16 -> Opcional, Utilizacao de Query para Selecao de Dados
								.F.				,;	//17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
								.T.				,;	//18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
								.F.				,;	//19 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
								.T.				,;	//20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
								.F.				,;	//21 -> Verifica se Deve Checar se o campo eh usado
								.F.				,;	//22 -> Verifica se Deve Checar o nivel do usuario
								.F.				 ;	//23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
					   		);
		         )

		IF !Empty( cFilter )

			( cAlias )->( EndFilBrw( cAlias , @aIndex ) )

		EndIF

		IF !Empty( aInfoTable[ nInfoTable , 2 ] )
			aInfoTable[ nInfoTable , 2 ] := aHeader
		EndIF

End Sequence

RestArea( aArea )

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTACALCบAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chamada para o calculo de saldo e consumos dos produtos    บฑฑ
ฑฑบ          ณ para o(s) Ponto(s) de Distribui็ใo                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/             

User Function ESTACALC(_cAlias,_nReg,_nOpcx)
                
Local _lCalc		:= .T. 
Local _lCadAuto		:= .T.    
Local _lValida		:= .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida cแlculo individual manual para item bloqueado                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
If	_nOpcx == 7 //Calculo individual manual
	If	SZ8->Z8_MSBLQL == "1"
		Alert("O cแlculo nใo serแ efetuado para este item por se tratar de registro bloqueado!")
		_lValida := .F.
	EndIf
EndIf

If	_lValida
                                                                       
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInforma e aguarda sobre: 1) qual m้todo de cแlculo - 2)cadastramento automatico de itens ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
	If	_nOpcx == 7 //Calculo individual manual
		_lCalc 		:= MsgYesNo ("Deseja efetuar o cแlculo de saldo/consumos para todos os produtos do PD "+Alltrim(SZ8->Z8_COD)+"?") 
		_lCadAuto 	:= MsgYesNo ("Deseja efetuar o cadastramento automแtico de produtos para o PD "+Alltrim(SZ8->Z8_COD)+", considerando o hist๓rico de itens da tabela de poder de terceiros?") 
	ElseIf	!IsBlind() //Se nao for chamada por Schedule ้ calculo em lote manual: exibe mensagem                                       
		_lCalc 		:= MsgYesNo ("Deseja efetuar o cแlculo de saldos/consumos para todos os produtos de todos os PDs?")
		_lCadAuto 	:= MsgYesNo ("Deseja efetuar o cadastramento automแtico de produtos para todos os PDs, considerando o hist๓rico de itens da tabela de poder de terceiros?")
	EndIf                      
	         
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamada e controle do andamento do cadastramento ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
	If	_lCadAuto
		CursorWait()
		MsgRun(OemToAnsi("Aguarde, processando o cadastramento automแtico dos itens..."),, {||U_ESTCALC2(_cAlias,_nReg,_nOpcx)}) 
		CursorArrow()    
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamada e controle do andamento do cแlculoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
	If	_lCalc
		CursorWait()
		MsgRun(OemToAnsi("Aguarde, processando os cแlculos..."),, {||U_ESTCALC1(_cAlias,_nReg,_nOpcx)})
		CursorArrow()    
	EndIf                            

EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTCALC1บAutor  ณAldoney Dias          บ Data ณ  25/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do Saldo e dos Consumos dos produtos para os Pontosบฑฑ
ฑฑบ          ณ de Distribui็ใo                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/             

User Function ESTCALC1(_cAlias,_nReg,_nOpcx)
                
Local aArea    	:= GetArea()
Local _cQuery1 	:= ""
Local _cFornDe	:= Iif(_nOpcx == 7,SZ8->Z8_FORNEC,Space(TamSX3("Z8_FORNEC")[1]))
Local _cFornAte	:= Iif(_nOpcx == 7,SZ8->Z8_FORNEC,Replicate("Z",TamSX3("Z8_FORNEC")[1]))
Local _cLojaDe	:= Iif(_nOpcx == 7,SZ8->Z8_LOJA,Space(TamSX3("Z8_LOJA")[1]))
Local _cLojaAte	:= Iif(_nOpcx == 7,SZ8->Z8_LOJA,Replicate("Z",TamSX3("Z8_LOJA")[1]))  
Local _nMes		:= 0      
Local _nRecAtu	:= 0     
Local _nRecAnt	:= 0  
  	 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona e calcula itens e quantidadesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
If	Alltrim(Upper(TcGetDb())) == "ORACLE"
	_cQuery1 := "SELECT FORNEC, LOJA, PROD, R_E_C_N_O_, DT, TIPO, QUANT FROM ( "
EndIf

_cQuery1 += "SELECT SZ9.Z9_FORNEC AS FORNEC, " 
_cQuery1 += "SZ9.Z9_LOJA AS LOJA, "
_cQuery1 += "SZ9.Z9_PROD AS PROD, "
_cQuery1 += "SZ9.R_E_C_N_O_ AS R_E_C_N_O_, "
_cQuery1 += "CASE WHEN SUBSTRING(SB6.B6_EMISSAO,1,6) IS NULL THEN '' ELSE SUBSTRING(SB6.B6_EMISSAO,1,6) END AS DT, "
_cQuery1 += "'C' AS TIPO, "
_cQuery1 += "CASE WHEN SUM(SB6.B6_QUANT) IS NULL THEN 0 ELSE SUM(SB6.B6_QUANT) END AS QUANT "
_cQuery1 += "FROM " + RetSqlName("SZ9") + " SZ9 "
_cQuery1 += "LEFT JOIN " + RetSqlName("SB6") + " SB6 ON SB6.B6_FILIAL = '" + xFilial("SB6") + "' "
_cQuery1 += "AND SB6.B6_PRODUTO = SZ9.Z9_PROD "
_cQuery1 += "AND SB6.B6_CLIFOR = SZ9.Z9_FORNEC "
_cQuery1 += "AND SB6.B6_LOJA = SZ9.Z9_LOJA "
_cQuery1 += "AND SB6.B6_TPCF = 'F' "
//_cQuery1 += "AND SB6.B6_PODER3 = 'R' "       
_cQuery1 += "AND SB6.B6_PODER3 = 'D' "       
_cQuery1 += "AND SUBSTRING(SB6.B6_EMISSAO,1,6) BETWEEN SUBSTRING('"+DtoS(MsSomaMes(dDataBase,-12,.T.))+"',1,6) AND SUBSTRING('"+DtoS(dDataBase)+"',1,6) "
_cQuery1 += "AND SB6.D_E_L_E_T_ = '' "
_cQuery1 += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = '" + xFilial("SZ8") + "' " 
_cQuery1 += "AND SZ8.Z8_COD = SZ9.Z9_COD "
_cQuery1 += "AND SZ8.Z8_FORNEC = SZ9.Z9_FORNEC "
_cQuery1 += "AND SZ8.Z8_LOJA = SZ9.Z9_LOJA "
_cQuery1 += "AND SZ8.Z8_MSBLQL <> '1' "  
_cQuery1 += "AND SZ8.D_E_L_E_T_ = '' "
_cQuery1 += "WHERE SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' "
_cQuery1 += "AND SZ9.Z9_FORNEC BETWEEN '"+_cFornDe+"' AND '"+_cFornAte+"' "
_cQuery1 += "AND SZ9.Z9_LOJA BETWEEN '"+_cLojaDe+"' AND '"+_cLojaAte+"' "
_cQuery1 += "AND SZ9.D_E_L_E_T_ = '' "
_cQuery1 += "GROUP BY SZ9.Z9_FORNEC, SZ9.Z9_LOJA, SZ9.Z9_PROD, "
_cQuery1 += "SZ9.R_E_C_N_O_, "
_cQuery1 += "SUBSTRING(SB6.B6_EMISSAO,1,6) "

_cQuery1 += "UNION "

_cQuery1 += "SELECT SZ9.Z9_FORNEC AS FORNEC, " 
_cQuery1 += "SZ9.Z9_LOJA AS LOJA, "
_cQuery1 += "SZ9.Z9_PROD AS PROD, "
_cQuery1 += "SZ9.R_E_C_N_O_ AS R_E_C_N_O_, "
_cQuery1 += "'' AS DT, "
_cQuery1 += "'S' AS TIPO, "
_cQuery1 += "CASE WHEN SUM(SB6.B6_SALDO) IS NULL THEN 0 ELSE SUM(SB6.B6_SALDO) END AS QUANT "
_cQuery1 += "FROM " + RetSqlName("SZ9") + " SZ9 "
_cQuery1 += "LEFT JOIN " + RetSqlName("SB6") + " SB6 ON SB6.B6_FILIAL = '" + xFilial("SB6") + "' "
_cQuery1 += "AND SB6.B6_PRODUTO = SZ9.Z9_PROD "
_cQuery1 += "AND SB6.B6_CLIFOR = SZ9.Z9_FORNEC "
_cQuery1 += "AND SB6.B6_LOJA = SZ9.Z9_LOJA "
_cQuery1 += "AND SB6.B6_TPCF = 'F' "
_cQuery1 += "AND SB6.B6_PODER3 = 'R' "
_cQuery1 += "AND SB6.D_E_L_E_T_ = '' "
_cQuery1 += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = '" + xFilial("SZ8") + "' " 
_cQuery1 += "AND SZ8.Z8_COD = SZ9.Z9_COD "
_cQuery1 += "AND SZ8.Z8_FORNEC = SZ9.Z9_FORNEC "
_cQuery1 += "AND SZ8.Z8_LOJA = SZ9.Z9_LOJA "
_cQuery1 += "AND SZ8.Z8_MSBLQL <> '1' "  
_cQuery1 += "AND SZ8.D_E_L_E_T_ = '' "
_cQuery1 += "WHERE SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' "
_cQuery1 += "AND SZ9.Z9_FORNEC BETWEEN '"+_cFornDe+"' AND '"+_cFornAte+"' "
_cQuery1 += "AND SZ9.Z9_LOJA BETWEEN '"+_cLojaDe+"' AND '"+_cLojaAte+"' "
_cQuery1 += "AND SZ9.D_E_L_E_T_ = '' "
_cQuery1 += "GROUP BY SZ9.Z9_FORNEC, SZ9.Z9_LOJA, SZ9.Z9_PROD, "
_cQuery1 += "SZ9.R_E_C_N_O_ "

If	Alltrim(Upper(TcGetDb())) == "ORACLE"
	_cQuery1 += ") "
EndIf

_cQuery1 += "ORDER BY FORNEC, LOJA, PROD, R_E_C_N_O_, DT, TIPO, QUANT "

_cQuery1 := ChangeQuery(_cQuery1)
                                                                        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEncerra area do arquivo temporario, caso abertaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	Select("SZ9DADOS") > 0  
	SZ9DADOS->(dbCloseArea())
EndIf  
	                               
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณCria nova area do arquivo temporarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
TCQUERY _cQuery1 NEW ALIAS "SZ9DADOS"

DbSelectArea("SZ9DADOS") 
SZ9DADOS->(DbGoTop())  

DbSelectArea("SZ9")
SZ9->(DbOrderNickName("SZ9003")) //Filial + Fornecedor + Loja
        
_nRecAnt := SZ9DADOS->R_E_C_N_O_
_nRecAtu := SZ9DADOS->R_E_C_N_O_

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVarre arquivo temporario e atualiza dados SZ9ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While SZ9DADOS->(!Eof())//Entra no laco para emissao da NF Entrada 
	                                   
	If	!_nRecAnt == SZ9DADOS->R_E_C_N_O_ 
		SZ9->(DbGoTo(_nRecAnt))
		Reclock("SZ9",.F.)
			SZ9->Z9_DTCALC := dDataBase
			If	SZ9->(Z9_CSM01+Z9_CSM02+Z9_CSM03+Z9_CSM04+Z9_CSM05+Z9_CSM06+Z9_CSM07+Z9_CSM08+Z9_CSM09+Z9_CSM10+Z9_CSM11+Z9_CSM12) > 0
				SZ9->Z9_MEDCSM := Round((SZ9->(Z9_CSM01+Z9_CSM02+Z9_CSM03+Z9_CSM04+Z9_CSM05+Z9_CSM06+Z9_CSM07+Z9_CSM08+Z9_CSM09+Z9_CSM10+Z9_CSM11+Z9_CSM12)/12),2)  
			Else
				SZ9->Z9_MEDCSM := 0	
			EndIf
		SZ9->(MsUnlock()) 
	EndIf
			  
	SZ9->(DbGoTo(SZ9DADOS->R_E_C_N_O_))
	
	_nRecAtu := SZ9DADOS->R_E_C_N_O_  
	
	Reclock("SZ9",.F.)  
			
	If	SZ9DADOS->TIPO == "S"            				//Se tipo S, atualiza saldo
		SZ9->Z9_SALDO := SZ9DADOS->QUANT
	Else      								          	//Tipo C, verifica mes para atualizar consumo
	        
		If	!Empty(SZ9DADOS->DT)
			
			If 	Substr(DtoS(dDataBase),1,6) == SZ9DADOS->DT //Ano/Mes atual, _nMes := 0	  
				_nMes := 0
			Else        
				_nMes := Val(Substr(SZ9DADOS->DT,5,2)) //Mes do registro
			EndIf
			                         
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza campos de acordo com _nMesณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If		_nMes == 0
					SZ9->Z9_CSMATU := SZ9DADOS->QUANT 
			ElseIf 	_nMes == 1   
					SZ9->Z9_CSM01 := SZ9DADOS->QUANT 
			ElseIf 	_nMes == 2   
					SZ9->Z9_CSM02 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 3   
					SZ9->Z9_CSM03 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 4   
					SZ9->Z9_CSM04 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 5   
					SZ9->Z9_CSM05 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 6   
					SZ9->Z9_CSM06 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 7   
					SZ9->Z9_CSM07 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 8   
					SZ9->Z9_CSM08 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 9   
					SZ9->Z9_CSM09 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 10   
					SZ9->Z9_CSM10 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 11   
					SZ9->Z9_CSM11 := SZ9DADOS->QUANT
			ElseIf 	_nMes == 12   
					SZ9->Z9_CSM12 := SZ9DADOS->QUANT
			EndIf
		Else
			SZ9->Z9_CSMATU 	:= 0 
			SZ9->Z9_CSM01 	:= 0
			SZ9->Z9_CSM02 	:= 0
			SZ9->Z9_CSM03 	:= 0
			SZ9->Z9_CSM04 	:= 0
			SZ9->Z9_CSM05 	:= 0
			SZ9->Z9_CSM06 	:= 0
			SZ9->Z9_CSM07 	:= 0
			SZ9->Z9_CSM08 	:= 0
			SZ9->Z9_CSM09 	:= 0
			SZ9->Z9_CSM10 	:= 0
			SZ9->Z9_CSM11 	:= 0
			SZ9->Z9_CSM12 	:= 0        
		EndIf	
	EndIf
	
	SZ9->(MsUnlock())
	
	_nRecAnt := _nRecAtu
	
	SZ9DADOS->(DbSkip())
EndDo                  
     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava ultimo item ao sair do lacoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	_nRecAnt > 0
	SZ9->(DbGoTo(_nRecAnt))
		Reclock("SZ9",.F.)
		SZ9->Z9_DTCALC := dDataBase
		If	SZ9->(Z9_CSM01+Z9_CSM02+Z9_CSM03+Z9_CSM04+Z9_CSM05+Z9_CSM06+Z9_CSM07+Z9_CSM08+Z9_CSM09+Z9_CSM10+Z9_CSM11+Z9_CSM12) > 0
			SZ9->Z9_MEDCSM := Round((SZ9->(Z9_CSM01+Z9_CSM02+Z9_CSM03+Z9_CSM04+Z9_CSM05+Z9_CSM06+Z9_CSM07+Z9_CSM08+Z9_CSM09+Z9_CSM10+Z9_CSM11+Z9_CSM12)/12),2)  
		Else
			SZ9->Z9_MEDCSM := 0	
		EndIf
	SZ9->(MsUnlock()) 
EndIf       

RestArea(aArea) 

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTCALC2บAutor  ณAldoney Dias          บ Data ณ  14/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastramento automatico dos produtos para os Pontos de    บฑฑ
ฑฑบ          ณ de Distribui็ใo, considerando hist๓rico da tabela de Poder บฑฑ  
ฑฑบ          ณ de Terceiros.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/             

User Function ESTCALC2(_cAlias,_nReg,_nOpcx)
                
Local aArea    	:= GetArea()
Local _cQuery1 	:= ""
Local _cFornDe	:= Iif(_nOpcx == 7,SZ8->Z8_FORNEC,Space(TamSX3("Z8_FORNEC")[1]))
Local _cFornAte	:= Iif(_nOpcx == 7,SZ8->Z8_FORNEC,Replicate("Z",TamSX3("Z8_FORNEC")[1]))
Local _cLojaDe	:= Iif(_nOpcx == 7,SZ8->Z8_LOJA,Space(TamSX3("Z8_LOJA")[1]))
Local _cLojaAte	:= Iif(_nOpcx == 7,SZ8->Z8_LOJA,Replicate("Z",TamSX3("Z8_LOJA")[1]))  
Local _nMes		:= 0      
Local _nRecAtu	:= 0     
Local _nRecAnt	:= 0  
  	 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona itens SB6/SZ8/SZ9            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery1 += "SELECT SZ8.Z8_COD AS COD, "
_cQuery1 += "SB6.B6_CLIFOR AS FORNEC, " 
_cQuery1 += "SB6.B6_LOJA AS LOJA, "
_cQuery1 += "SB6.B6_PRODUTO AS PRODB6, " 

If	Alltrim(Upper(TcGetDb())) == "ORACLE"	
	_cQuery1 += "NVL(SZ9.Z9_PROD,'') AS PRODZ9 "
Else
  	_cQuery1 += "ISNULL(SZ9.Z9_PROD,'') AS PRODZ9 "
EndIf                                              

_cQuery1 += "FROM " + RetSqlName("SB6") + " SB6 " 
_cQuery1 += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = '" + xFilial("SZ8") + "' " 
_cQuery1 += "AND SZ8.Z8_FORNEC = SB6.B6_CLIFOR "
_cQuery1 += "AND SZ8.Z8_LOJA = SB6.B6_LOJA "
_cQuery1 += "AND SZ8.Z8_MSBLQL <> '1' "  
_cQuery1 += "AND SZ8.D_E_L_E_T_ = '' "
_cQuery1 += "LEFT JOIN " + RetSqlName("SZ9") + " SZ9 ON SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' "
_cQuery1 += "AND SB6.B6_PRODUTO = SZ9.Z9_PROD "
_cQuery1 += "AND SB6.B6_CLIFOR = SZ9.Z9_FORNEC "
_cQuery1 += "AND SB6.B6_LOJA = SZ9.Z9_LOJA " 
_cQuery1 += "AND SZ9.D_E_L_E_T_ = '' "  
_cQuery1 += "WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "' "
_cQuery1 += "AND SB6.B6_CLIFOR BETWEEN '"+_cFornDe+"' AND '"+_cFornAte+"' "
_cQuery1 += "AND SB6.B6_LOJA BETWEEN '"+_cLojaDe+"' AND '"+_cLojaAte+"' "   
_cQuery1 += "AND SB6.B6_TPCF = 'F' "
_cQuery1 += "AND SB6.B6_PODER3 = 'R' "
_cQuery1 += "AND SB6.D_E_L_E_T_ = '' "  
_cQuery1 += "GROUP BY SZ8.Z8_COD, SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_PRODUTO, SZ9.Z9_PROD "
_cQuery1 += "ORDER BY SZ8.Z8_COD, SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_PRODUTO, SZ9.Z9_PROD "

_cQuery1 := ChangeQuery(_cQuery1)
                                                                        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEncerra area do arquivo temporario, caso abertaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	Select("SZ9INCL") > 0  
	SZ9INCL->(dbCloseArea())
EndIf  
	                               
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณCria nova area do arquivo temporarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
TCQUERY _cQuery1 NEW ALIAS "SZ9INCL"

DbSelectArea("SZ9INCL") 
SZ9INCL->(DbGoTop())  
    
DbSelectArea("SZ9")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVarre arquivo temporario e atualiza dados SZ9ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While 	SZ9INCL->(!Eof()) 
	  	
	  	If	Empty(SZ9INCL->PRODZ9) 	   
	  		
			Reclock("SZ9",.T.)
				SZ9->Z9_FILIAL	:= xFilial("SZ9")
				SZ9->Z9_COD 	:= SZ9INCL->COD 
				SZ9->Z9_FORNEC	:= SZ9INCL->FORNEC
				SZ9->Z9_LOJA	:= SZ9INCL->LOJA
				SZ9->Z9_PROD	:= SZ9INCL->PRODB6
			MsUnlock()
		EndIf

		SZ9INCL->(DbSkip())
EndDo                  
     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava ultimo item ao sair do lacoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	!Empty(SZ9INCL->PRODB6) .and. Empty(SZ9INCL->PRODZ9) 	   
  		
	Reclock("SZ9",.T.)
		SZ9->Z9_FILIAL	:= xFilial("SZ9")
		SZ9->Z9_COD 	:= SZ9INCL->COD 
		SZ9->Z9_FORNEC	:= SZ9INCL->FORNEC
		SZ9->Z9_LOJA	:= SZ9INCL->LOJA
		SZ9->Z9_PROD	:= SZ9INCL->PRODB6
	MsUnlock()
EndIf

RestArea(aArea) 

Return()                                                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTAREL1บAutor  ณAldoney Dias          บ Data ณ  18/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de pend๊ncias entre Poder de Terceiros x Cadastroบฑฑ
ฑฑบ          ณ de Pontos de Distrui็ใo/Produtos                           บฑฑ  
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ESTAREL1
               
Local wnrel
Local cString  	:= "SB6"
Local titulo   	:= "Pendencias - Poder3 x PD"
Local NomeProg 	:= "ESTAREL1"                               
Local Tamanho 	:= "M"
Local cPerg	:= "ESTAREL1"
Local aPergs := {}

Private Limite	:= 132
Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parmetros           ณ
//ณ mv_par01         // Do Ponto Distribuicao      ณ
//ณ mv_par02         // Ate Ponto Distribuicao     ณ
//ณ mv_par03         // Do Fornecedor              ณ
//ณ mv_par04         // Da Loja                    ณ
//ณ mv_par05         // Ate Fornecedor             ณ
//ณ mv_par06         // Ate Loja                   ณ
//ณ mv_par07         // Da Data Emissao NF Origem  ณ
//ณ mv_par08         // Ate Data Emissao NF Origem ณ
//ณ mv_par09         // Ordena por                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
aAdd(aPergs,{"Do Ponto Distribuicao"	,,,"mv_ch1","C",6,0,0,"G",""									,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Ate Ponto Distribuicao"	,,,"mv_ch2","C",6,0,0,"G","naovazio() .and. mv_par02>=mv_par01"	,"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Do Fornecedor"			,,,"mv_ch3","C",6,0,0,"G",""									,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""}) 
aAdd(aPergs,{"Da Loja "					,,,"mv_ch4","C",2,0,0,"G",""									,"mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Ate Fornecedor"			,,,"mv_ch5","C",6,0,0,"G","naovazio() .and. mv_par05>=mv_par03"	,"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
aAdd(aPergs,{"Ate Loja "				,,,"mv_ch6","C",2,0,0,"G","naovazio() .and. mv_par06>=mv_par04"	,"mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Da Dt Emissao NF Origem"	,,,"mv_ch7","D",8,0,0,"G",""									,"mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Ate Dt Emissao NF Origem"	,,,"mv_ch8","D",8,0,0,"G","naovazio() .and. mv_par08>=mv_par07"	,"mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Ordena por"				,,,"mv_ch9","N",1,0,1,"C",""									,"mv_par09","P Distrib","","","","","Cod Fornec","","","","","Nom Fornec","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg, aPergs)

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,"Pendencias PODER3 x PD", "", "",.F.,.F.,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif   

SetDefault(aReturn,cString)

RptStatus({|lEnd| ESTAREL2(@lEnd,wnRel,cString,Tamanho,NomeProg)},titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTAREL2บAutor  ณAldoney Dias          บ Data ณ  18/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prepara impressao ESTAREL1                                 บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ESTAREL2(lEnd,WnRel,cString,Tamanho,NomeProg)

Local _cQuery1 	:= "" 
Local _cQuery2 	:= ""    //             1         2         3         4         5         6         7         8         9         10        11        12
                         //    1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local cabec1  	:=  oemtoansi("COD PD  DESCRICAO DO PD                           FORNEC/LJ  NOME FORNECEDOR                       CPF/CNPJ                       ")
Local cabec2  	:=  oemtoansi("PRODUTO           DESCRIวรO PRODUTO                               SALDO EM TERCEIRO (A)   SALDO CADASTRO PD (B)   DIFERENวA (A-B) ")
Local cRodaTxt 	:= oemtoansi("Rodap้")
Local nCntImpr 
Local nTipo   

Private _cForAtu := ""                 

nCntImpr 	:= 0
li 			:= 80 
m_pag 		:= 1  	//ณ Inicializa os codigos de caracter Comprimido da impressora ณ
nTipo 		:= 15 	//ณ Monta os Cabecalhos                                        ณ
titulo		:= oemtoansi("Pendencias - Poder3 x PD")

//_cQuery1 += "SELECT PDCOD, PDDESC, FORNCOD, FORNCLJ, FORNNOM, CNPJCPF, TIPO, PRODB6, SUM(SALDB6) AS SALDOB6, PRODZ9, SUM(SALDZ9) AS SALDOZ9 FROM ("

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrioriza itens SB6 - mesmo nใo existindo SZ9     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery1 += "SELECT SZ8.Z8_COD AS PDCOD, " 
_cQuery1 += "SZ8.Z8_DESC AS PDDESC, "
_cQuery1 += "SZ8.Z8_FORNEC AS FORNCOD, " 
_cQuery1 += "SZ8.Z8_LOJA AS FORNCLJ, " 
_cQuery1 += "SZ8.Z8_NOMFOR AS FORNNOM, "
_cQuery1 += "SZ8.Z8_CNPJCPF AS CNPJCPF, " 
_cQuery1 += "SZ8.Z8_TIPO AS TIPO, "  
_cQuery1 += "SB6.B6_PRODUTO AS PRODB6, " 
_cQuery1 += "SUM(SB6.B6_SALDO) AS SALDB6, "
_cQuery1 += "'' AS PRODZ9, "
_cQuery1 += "0 AS SALDZ9 "
_cQuery1 += "FROM " + RetSqlName("SB6") + " SB6 " 
_cQuery1 += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = '" + xFilial("SZ8") + "' " 
_cQuery1 += "AND SZ8.Z8_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery1 += "AND SZ8.Z8_FORNEC = SB6.B6_CLIFOR "
_cQuery1 += "AND SZ8.Z8_LOJA = SB6.B6_LOJA "
_cQuery1 += "AND SZ8.Z8_MSBLQL <> '1' "  
_cQuery1 += "AND SZ8.D_E_L_E_T_ = '' " 
_cQuery1 += "LEFT JOIN " + RetSqlName("SZ9") + " SZ9 ON SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' "
_cQuery1 += "AND SB6.B6_PRODUTO = SZ9.Z9_PROD "
_cQuery1 += "AND SB6.B6_CLIFOR = SZ9.Z9_FORNEC "
_cQuery1 += "AND SB6.B6_LOJA = SZ9.Z9_LOJA " 
_cQuery1 += "AND SZ9.D_E_L_E_T_ = '' "
_cQuery1 += "WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "' "
_cQuery1 += "AND SB6.B6_CLIFOR BETWEEN '"+mv_par03+"' AND '"+mv_par05+"' "
_cQuery1 += "AND SB6.B6_LOJA BETWEEN '"+mv_par04+"' AND '"+mv_par06+"' " 
_cQuery1 += "AND SB6.B6_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"' "  
_cQuery1 += "AND SB6.B6_TPCF = 'F' "
_cQuery1 += "AND SB6.B6_PODER3 = 'R' "
_cQuery1 += "AND SB6.D_E_L_E_T_ = '' "
_cQuery1 += "AND SZ9.Z9_PROD IS NULL "
_cQuery1 += "GROUP BY SZ8.Z8_COD, SZ8.Z8_DESC, SZ8.Z8_FORNEC, SZ8.Z8_LOJA, SZ8.Z8_NOMFOR, SZ8.Z8_CNPJCPF, SZ8.Z8_TIPO, SB6.B6_PRODUTO "

_cQuery1 += "UNION "                  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrioriza itens SZ9 - mesmo nใo existindo SB6     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery1 += "SELECT SZ8.Z8_COD AS PDCOD, " 
_cQuery1 += "SZ8.Z8_DESC AS PDDESC, "
_cQuery1 += "SZ8.Z8_FORNEC AS FORNCOD, " 
_cQuery1 += "SZ8.Z8_LOJA AS FORNCLJ, "  
_cQuery1 += "SZ8.Z8_NOMFOR AS FORNNOM, "
_cQuery1 += "SZ8.Z8_CNPJCPF AS CNPJCPF, " 
_cQuery1 += "SZ8.Z8_TIPO AS TIPO, "    
_cQuery1 += "'' AS PRODB6, " 
_cQuery1 += "0 AS SALDB6, "
_cQuery1 += "SZ9.Z9_PROD AS PRODZ9, "
_cQuery1 += "SUM(SZ9.Z9_SALDO) AS SALDZ9 "
_cQuery1 += "FROM " + RetSqlName("SZ9") + " SZ9 " 
_cQuery1 += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = '" + xFilial("SZ8") + "' " 
_cQuery1 += "AND SZ8.Z8_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery1 += "AND SZ8.Z8_FORNEC = SZ9.Z9_FORNEC "
_cQuery1 += "AND SZ8.Z8_LOJA = SZ9.Z9_LOJA "
_cQuery1 += "AND SZ8.Z8_MSBLQL <> '1' "  
_cQuery1 += "AND SZ8.D_E_L_E_T_ = '' " 
_cQuery1 += "LEFT JOIN " + RetSqlName("SB6") + " SB6 ON SB6.B6_FILIAL = '" + xFilial("SB6") + "' "
_cQuery1 += "AND SB6.B6_PRODUTO = SZ9.Z9_PROD "
_cQuery1 += "AND SB6.B6_CLIFOR = SZ9.Z9_FORNEC "
_cQuery1 += "AND SB6.B6_LOJA = SZ9.Z9_LOJA " 
_cQuery1 += "AND SB6.B6_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"' "
_cQuery1 += "AND SB6.B6_TPCF = 'F' "
_cQuery1 += "AND SB6.B6_PODER3 = 'R' "
_cQuery1 += "AND SB6.D_E_L_E_T_ = '' "  
_cQuery1 += "WHERE SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' "
_cQuery1 += "AND SZ9.Z9_FORNEC BETWEEN '"+mv_par03+"' AND '"+mv_par05+"' "
_cQuery1 += "AND SZ9.Z9_LOJA BETWEEN '"+mv_par04+"' AND '"+mv_par06+"' " 
_cQuery1 += "AND SZ9.D_E_L_E_T_ = '' "
_cQuery1 += "AND SB6.B6_PRODUTO IS NULL " 
_cQuery1 += "GROUP BY SZ8.Z8_COD, SZ8.Z8_DESC, SZ8.Z8_FORNEC, SZ8.Z8_LOJA, SZ8.Z8_NOMFOR, SZ8.Z8_CNPJCPF, SZ8.Z8_TIPO, SZ9.Z9_PROD "

_cQuery1 += "UNION "                  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrioriza itens existentes em SB6/SZ9             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery1 += "SELECT SZ8.Z8_COD AS PDCOD, " 
_cQuery1 += "SZ8.Z8_DESC AS PDDESC, "
_cQuery1 += "SZ8.Z8_FORNEC AS FORNCOD, " 
_cQuery1 += "SZ8.Z8_LOJA AS FORNCLJ, "  
_cQuery1 += "SZ8.Z8_NOMFOR AS FORNNOM, "
_cQuery1 += "SZ8.Z8_CNPJCPF AS CNPJCPF, " 
_cQuery1 += "SZ8.Z8_TIPO AS TIPO, "  
_cQuery1 += "SB6.B6_PRODUTO AS PRODB6, " 
_cQuery1 += "SUM(SB6.B6_SALDO) AS SALDB6, "
_cQuery1 += "SZ9.Z9_PROD AS PRODZ9, "
_cQuery1 += "SUM(SZ9.Z9_SALDO) AS SALDZ9 "
_cQuery1 += "FROM " + RetSqlName("SZ9") + " SZ9 " 
_cQuery1 += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = '" + xFilial("SZ8") + "' " 
_cQuery1 += "AND SZ8.Z8_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery1 += "AND SZ8.Z8_FORNEC = SZ9.Z9_FORNEC "
_cQuery1 += "AND SZ8.Z8_LOJA = SZ9.Z9_LOJA "
_cQuery1 += "AND SZ8.Z8_MSBLQL <> '1' "  
_cQuery1 += "AND SZ8.D_E_L_E_T_ = '' " 
_cQuery1 += "INNER JOIN " + RetSqlName("SB6") + " SB6 ON SB6.B6_FILIAL = '" + xFilial("SB6") + "' "
_cQuery1 += "AND SB6.B6_PRODUTO = SZ9.Z9_PROD "
_cQuery1 += "AND SB6.B6_CLIFOR = SZ9.Z9_FORNEC "
_cQuery1 += "AND SB6.B6_LOJA = SZ9.Z9_LOJA " 
_cQuery1 += "AND SB6.B6_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"' "
_cQuery1 += "AND SB6.B6_TPCF = 'F' "
_cQuery1 += "AND SB6.B6_PODER3 = 'R' "
_cQuery1 += "AND SB6.D_E_L_E_T_ = '' "  
_cQuery1 += "WHERE SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' "
_cQuery1 += "AND SZ9.Z9_FORNEC BETWEEN '"+mv_par03+"' AND '"+mv_par05+"' "
_cQuery1 += "AND SZ9.Z9_LOJA BETWEEN '"+mv_par04+"' AND '"+mv_par06+"' " 
_cQuery1 += "AND SZ9.D_E_L_E_T_ = '' "
_cQuery1 += "GROUP BY SZ8.Z8_COD, SZ8.Z8_DESC, SZ8.Z8_FORNEC, SZ8.Z8_LOJA, SZ8.Z8_NOMFOR, SZ8.Z8_CNPJCPF, SZ8.Z8_TIPO, SB6.B6_PRODUTO, SZ9.Z9_PROD "
  
//_cQuery1 += ") "
//_cQuery1 += "GROUP BY PDCOD, PDDESC, FORNCOD, FORNCLJ, CNPJCPF, TIPO, PRODB6, PRODZ9 "

If		mv_par09 == 1 	//1=Ordena por PD
		_cQuery1 += "ORDER BY PDCOD, PDDESC, FORNCOD, FORNCLJ, FORNNOM, CNPJCPF, TIPO, PRODB6, PRODZ9 " 
ElseIf	mv_par09 == 2	//2=Ordena por Cod Fornecedor/loja      
		_cQuery1 += "ORDER BY FORNCOD, FORNCLJ, FORNNOM, PDCOD, PDDESC, CNPJCPF, TIPO, PRODB6, PRODZ9 "
Else 					//3=Ordena por Nome Fornecedor/loja 
		_cQuery1 += "ORDER BY FORNNOM, FORNCOD, FORNCLJ, PDCOD, PDDESC, CNPJCPF, TIPO, PRODB6, PRODZ9 "
EndIf
	          
_cQuery1 := ChangeQuery(_cQuery1)
                                                                        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEncerra area do arquivo temporario, caso abertaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	Select("PENDENT") > 0  
	PENDENT->(dbCloseArea())
EndIf  
	                               
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณCria nova area do arquivo temporarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
TCQUERY _cQuery1 NEW ALIAS "PENDENT"

DbSelectArea("PENDENT") 
PENDENT->(DbGoTop())
    
DbSelectArea("PENDENT")
SetRegua((RecCount()))

While PENDENT->(!Eof())

	If 	lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	End
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Movimenta a regua       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IncRegua()    
	          
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamada da impressao dos itensณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	If 	li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)  
	End
	ESTAREL3()
    
	PENDENT->(DbSkip())        
	
Enddo                 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime ultimo registro ao sair do la็oณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ESTAREL3()

Set Printer To
dbCommitAll()
Ourspool(WnRel)

MS_FLUSH()
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTAREL3บAutor  ณAldoney Dias          บ Data ณ  18/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime itens                                              บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                    

Static Function ESTAREL3

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso haja produto referenciado no registro OU para SB6, OU para SZ9, E exista diferenca de saldo, imprime.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	(!Empty(PENDENT->PRODB6) .or. !Empty(PENDENT->PRODZ9)) .and. ((PENDENT->SALDB6)-(PENDENT->SALDZ9)) <> 0 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤÿฟ
	//ณAo saltar fornecedor, imprime dado referente ao cabecalho 1  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤÿู
	If !_cForAtu == PENDENT->PDCOD 
	    
		If	li > 9
			@ li, 001	PSAY Replicate("-",Limite)
			li++
		EndIf
		  
		@ li, 001	PSAY PENDENT->PDCOD
		@ li, 008  	PSAY Substr(PENDENT->PDDESC,1,40)
		@ li, 051	PSAY PENDENT->FORNCOD+"/"+PENDENT->FORNCLJ
		@ li, 062   PSAY Substr(PENDENT->FORNNOM,1,36)
		@ li, 100   PSAY Iif(PENDENT->TIPO == "J", Transform(Alltrim(PENDENT->CNPJCPF),"@R 99.999.999/9999-99"), Transform(Alltrim(PENDENT->CNPJCPF),"@R 999.999.999-99")) 
		li++                           
		_cForAtu := PENDENT->PDCOD 
	EndIf
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤÿฟ
	//ณImprime item                                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤÿู
	If		!Empty(PENDENT->PRODB6)
			@ li, 001   PSAY PENDENT->PRODB6
			@ li, 019   PSAY Substr(Posicione("SB1",1,xFilial("SB1")+PENDENT->PRODB6,"B1_DESC"),1,46)
	ElseIf	!Empty(PENDENT->PRODZ9)	 		   
			@ li, 001   PSAY PENDENT->PRODZ9
			@ li, 019   PSAY Substr(Posicione("SB1",1,xFilial("SB1")+PENDENT->PRODZ9,"B1_DESC"),1,46)
	EndIf	      
			
	@ li, 067   PSAY PENDENT->SALDB6					PICTURE PesqPict("SB6","B6_SALDO")
	@ li, 091   PSAY PENDENT->SALDZ9 					PICTURE PesqPict("SB6","B6_SALDO")
	@ li, 115   PSAY (PENDENT->SALDB6)-(PENDENT->SALDZ9)PICTURE PesqPict("SB6","B6_SALDO")
	li++
	
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTATRF1บAutor  ณAldoney Dias          บ Data ณ  03/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime itens                                              บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                     

User Function ESTATRF1()                       

Local _cNom1	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+SZ8->Z8_FORNEC+SZ8->Z8_LOJA,"A2_NOME"))
Local aSize    	:= MsAdvSize(.F.)
Local nOpcA 	:= 0
Local oDialog       
Local oGet1
Local oGet2
Local oGet3
Local oBold
Local aSize    	:= MsAdvSize(.F.)

Private _cFor1	:= SZ8->Z8_FORNEC
Private _cLoj1	:= SZ8->Z8_LOJA               
Private _cFor2	:= Space(TamSX3("A2_COD")[1])
Private _cLoj2	:= Space(TamSX3("A2_LOJA")[1])         
Private _cNom2	:= Space(TamSX3("A2_NOME")[1]) 
Private oGet4
Private oGet5
Private oGet6 
         
If	MsgYesNo (	"Esta rotina altera o fornecedor do PD, transferindo automaticamente os materiais pendentes com o fornecedor anterior para o atual (indicado), efetuando:"+chr(13)+chr(13)+;
				"1) A emissใo da NF Entrada para fornecedor anterior, baixando PODER3 de todos os materiais em seu poder;"+chr(13)+chr(13)+;
				"2) A emissใo do PV ao fornecedor atual, com os exatos materiais retornados do fornecedor anterior; e"+chr(13)+chr(13)+;
				"Deseja continuar?")                             
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณCria listbox, para escolha dos produtos que podem ser retiradosณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				DEFINE FONT oBold    NAME "Arial" SIZE 0, -12 BOLD
				
				DEFINE MSDIALOG oDialog TITLE "Transferencia de Fornecedor x PD" From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
				        
				
				@ 030,060 SAY "FORNECEDOR DO PONTO DE DISTRIBUIวรO (PD)" SIZE 200,009 OF oDialog PIXEL FONT oBold 
				
				@ 060,060 SAY "Fornecedor" SIZE 030,009 OF oDialog PIXEL 
				@ 059,090 GET oGet1 VAR _cFor1 SIZE 050,009 OF oDialog PIXEL WHEN .F. 
				
				@ 060,143 SAY "Loja" SIZE 010,009 OF oDialog PIXEL 
				@ 059,153 GET oGet2 VAR _cLoj1 SIZE 010,009 OF oDialog PIXEL WHEN .F.
				
				@ 060,173 SAY "Nome" SIZE 040,009 OF oDialog PIXEL 
				@ 058,190 GET oGet3 VAR _cNom1 SIZE 120,009 OF oDialog PIXEL WHEN .F. 
				
				@ 090,060 SAY "NOVO FORNECEDOR DO PONTO DE DISTRIBUIวรO (PD)" SIZE 200,009 OF oDialog PIXEL FONT oBold  
				
				@ 120,060 SAY "Fornecedor" SIZE 030,009 OF oDialog PIXEL          
				@ 119,090 MSGET oGet4 VAR _cFor2 F3 "FOR" Picture "@!" SIZE 050,009 Valid U_ESTATRF2() OF oDialog PIXEL    
				                                                                                                                 
				@ 120,143 SAY "Loja" SIZE 010,009 OF oDialog PIXEL                                                    
				@ 119,153 MSGET oGet5 VAR _cLoj2 Picture "@!" SIZE 010,009 Valid U_ESTATRF2() OF oDialog PIXEL WHEN .F.
				           				
				@ 120,173 SAY "Nome" SIZE 040,009 OF oDialog PIXEL 
				@ 119,190 GET oGet6 VAR _cNom2 SIZE 120,009 WHEN .F. Valid .T. OF oDialog PIXEL
							
				ACTIVATE MSDIALOG oDialog on init EnchoiceBar(oDialog,{|| nOpcA:=1,oDialog:End()},{||nOpcA:=0,oDialog:End()})		 
EndIf            

If	nOpca == 1
	Begin Transaction 	
		FWMsgRun(,{|| ESTA0200() },,'Aguarde, Processando transfer๊ncia...')
	End Transaction	
EndIf

Return()     

Static Function ESTA0200()
	Local _cTRF3 := ""
	Local _cKeyD1 := "" 
	
	//Emite NF Entrada com itens selecionados para fornecedor anterior, baixando PODER3 - retorna "1", se emitiu NF, atualiza fornecedor 
	//Se emissao da NF Entrada retornar "3" ้ porque nใo emitiu por erro, entao nao faz nada
	//Se nใo emitir por falta de saldo no SB6 - retorna "2", atualiza fornecedor
	_cTRF3 := U_ESTATRF3() 
	
	If	_cTRF3 == "1" //Emitiu NF Entrada sem erro
		_cKeyD1	:= SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)
	
			//Emite PV ao novo fornecedor com TES controlando PODER3
			If	U_ESTATRF4(_cKeyD1)                                                       
				//Altera fornecedor na SZ8 e SZ9
				U_ESTATRF6()							
			EndIf		
	ElseIf	_cTRF3 == "2"
			//Altera fornecedor na SZ8 e SZ9
			U_ESTATRF6() 		
	EndIf		     
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTATRF2บAutor  ณAldoney Dias          บ Data ณ  03/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua validacoes da tela                                  บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                     

User Function ESTATRF2()

Local lRetorno := .T.
Local aAreaAnt := GetArea()               
      
If	Empty(_cFor2)
	Alert("Indique o c๓digo do fornecedor!")
	lRetorno := .F.                                    
EndIf   

If	Empty(_cLoj2)
	Alert("Indique o c๓digo da loja!")
	lRetorno := .F.                                    
EndIf 

If	!Empty(_cFor2) .And. Empty(_cLoj2)
	If	!ExistCpo("SA2",_cFor2)
		Alert("Nใo existe fornecedor com o c๓digo indicado!")
		lRetorno := .F.                                    
	EndIf
EndIf    

If	!Empty(_cFor2) .And. !Empty(_cLoj2)
	If	!ExistCpo("SA2",_cFor2+_cLoj2)
		Alert("Nใo existe fornecedor e loja com os c๓digos indicados!")
		lRetorno := .F.                                    
	EndIf
EndIf

If 	!Empty(_cFor2) .And. !Empty(_cLoj2)
	_cNom2 := Posicione("SA2",1,xFilial("SA2")+_cFor2+_cLoj2,"A2_NOME")
	If Type("oGet6") <> "U"
		oGet6:Refresh()
	EndIf
EndIf                                     
	
RestArea(aAreaAnt) 

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTATRF3บAutor  ณAldoney Dias          บ Data ณ  03/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona itens com saldo em PODER3 e emite NF Entrada para บฑฑ 
ฑฑบ          ณfornecedor anterior do PD.                                  บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/            

User Function ESTATRF3()

Local _aArea   := GetArea() 				  		//Armazena areas para posterior retorno  
Local _cQuery1 := "" 
Local _cRet	   := "3"   

Private _nSldB6		:= 0							//Checa se existe saldo no SB6
Private _cForAtu  	:= "" 							//Chave fornecedor atual (posicionado)
Private _cLojAtu  	:= "" 							//Chave loja atual (posicionada)    
Private _cPrdAtu	:= ""                         	//Chave produto atual (posicionado)
Private _cSerie   	:= GetMV("MV_XSERDEV",,"2")		//Serie da NF de Entrada - retorno terceiros  
Private _cTesDev  	:= GetMV("MV_XTESDEV",,"008")	//Tes utilizado para devolucao de poder de terceiro
Private _cTipoNF  	:= GetMV("MV_XTPDEVO",,"N")		//Tipo de documento de entrada referente a devolucao
Private _cEspecie 	:= GetMV("MV_XESPECI",,"SPED")	//Especie na nota fiscal de entrada, referente a devolucao  
Private _cTpNrNfs 	:= GetMV("MV_TPNRNFS",,"2")    	//Serie da NF de Saida (param. para numeracao autom.) 
Private _cNumDev 	:= PadR(NxtSX5Nota(_cSerie, .T., _cTpNrNfs), TamSX3("F1_DOC")[1])	//Numero da NF de Entrada - retorno terceiros 
Private _aItens   	:= {} 							//Array com linhas da SD2 
Private _aEmail	  	:= {} 							//Dados para envio do email     
Private _nRecnoF1 	:= 0 							//Recno da NFe Entrada gravada
Private _nTotDev	:= 0							//Armazena quantidade total devolvida para a chave forncedor+loja+produto    
Private _nSldDevZ5 	:= 0							//Quantidade inicial/restante pendente a devolver
Private _nSldPrdB6 	:= 0							//Quantidade do produto no terceiro disponivel para devolver     
Private _aQtdDev	:= {}                          	//Quantidade devolvida para a chave Fornecedor+Loja+produto - criado para o caso de quebra de itens 990 e na marcacao da SZ5
Private lMsErroAuto := .F. 							//Controla erro retorno rotina  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSelecao dos itens com saldo em PODER3 (SB6) a processar       ณ 
//ณ(retornar em NF Entrada) para forneceodr anterior.            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
                                                                                
_cQuery1 := "SELECT SB6.B6_CLIFOR AS FORNECE, SB6.B6_LOJA AS LOJA, SB6.B6_PRODUTO AS PRODUTO, SUM(SB6.B6_SALDO) AS SALDO " 
_cQuery1 += "FROM " + RetSqlName("SB6") + " SB6 " 
_cQuery1 += "WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "' " 
_cQuery1 += "AND SB6.B6_CLIFOR = '"+SZ8->Z8_FORNEC+"' "
_cQuery1 += "AND SB6.B6_LOJA = '"+SZ8->Z8_LOJA+"' "
_cQuery1 += "AND SB6.B6_TPCF = 'F' " 
_cQuery1 += "AND SB6.B6_PODER3 = 'R' " 
_cQuery1 += "AND SB6.D_E_L_E_T_ = ' '" 
_cQuery1 += "GROUP BY SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_PRODUTO "
_cQuery1 += "HAVING SUM(SB6.B6_SALDO) > 0 "
_cQuery1 += "ORDER BY SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_PRODUTO "         

_cQuery1 := ChangeQuery(_cQuery1)
       
If	Select("SB6DEV") > 0  
	SB6DEV->(dbCloseArea())
EndIf  
		
TCQUERY _cQuery1 NEW ALIAS "SB6DEV"  

DbSelectArea("SB6DEV")
SB6DEV->(DbGoTop())                   

If	!Empty(SB6DEV->FORNECE)

	//Atualiza variaveis antes de entrar no laco
	_cForAtu 	:= SB6DEV->FORNECE
	_cLojAtu 	:= SB6DEV->LOJA       
	_cPrdAtu	:= SB6DEV->PRODUTO 
	_nSldDevZ5 	:= SB6DEV->SALDO            
	_nSldB6		:= SB6DEV->SALDO
	                                              
	While SB6DEV->(!Eof())//Entra no laco para emissao da NF Entrada  
		
		//Mudou o fornecedor/loja emite a nota
		If		!_cForAtu+_cLojAtu == SB6DEV->FORNECE+SB6DEV->LOJA 
				
			If 	Len(_aItens) > 0 .and. Len(_aItens) <= 990 //houver itens (<= 990), emite NF ao fornecedor
				If 	U_PODTER5() //Emitiu NF.
					_cRet := "1"
				Else
					_cRet := "3" //Nao emitiu NF
				EndIf 
			Endif
			
			//Atualiza variaveis para novo fornecedor
			_cForAtu 	:= SB6DEV->FORNECE
			_cLojAtu 	:= SB6DEV->LOJA         
			_cPrdAtu	:= SB6DEV->PRODUTO 
			_nSldDevZ5 	:= SB6DEV->SALDO  
			_nSldB6 	:= U_PODTER2() 
			
			Loop
				
		//Sendo mesmo fornecedor/loja e atingir limite de 990 itens, emite NF ao fornecedor atual          
		ElseIf	_cForAtu+_cLojAtu == SB6DEV->FORNECE+SB6DEV->LOJA .and. Len(_aItens) == 990  
				
				If	U_PODTER5() //Emite NF. 
					_cRet := "1"
				                          
					//Se apos a emissao da NF trocar de produto para o mesmo fornecedor, atualiza variaveis
					If	!_cPrdAtu == SB6DEV->PRODUTO
						_cPrdAtu 	:= SB6DEV->PRODUTO	
						_nSldDevZ5 	:= SB6DEV->SALDO 
						_nSldB6 	:= U_PODTER2()
					EndIf                       
				Else
					_cRet := "3" //Nao emitiu NF
				EndIf
				
		//Se ainda existir saldo a devolver na SZ5 e na SB6 para chave Fornecedor+loja+produto correntes
		ElseIf	_cForAtu+_cLojAtu+_cPrdAtu == SB6DEV->FORNECE+SB6DEV->LOJA+SB6DEV->PRODUTO .and. _nSldDevZ5 > 0 .and. _nSldB6 > 0  
		
				U_PODTER3() //Adiciona item atual para proxima NF (mesmo fornecedor)    
					                         
		Else	//Se nenhuma das anteriores, atualiza variaveis                   
		                                            
				If		(Len(_aItens) < 990)  .or.;									  //Se nao atingir maximo de itens na NF, salta registro, ou; 
						(Len(_aItens) == 990 .and. (_nSldDevZ5 == 0 .or. _nSldB6 == 0)) //Se nao atingir maximo de itens na NF e nใo houver saldo, salta registro
				
						SB6DEV->(DbSkip()) //Salta registro
		                
		   				If	SB6DEV->(!EOF()) .and.	_cForAtu+_cLojAtu == SB6DEV->FORNECE+SB6DEV->LOJA
							_cPrdAtu	:= SB6DEV->PRODUTO   
							_nSldDevZ5 	:= SB6DEV->SALDO
							_nSldB6 	:= U_PODTER2() 
						EndIf
				
				EndIf
		EndIf		
						                                                                                     
	EndDo       
	
	//Verifica ao sair do laco se deve ou nao emitir NF (ultima - fim de laco)
	If 	Len(_aItens) > 0 .and. Len(_aItens) <= 990 
		If	U_PODTER5() //Emitiu NF
			_cRet := "1"           
		Else
			_cRet := "3" //Nao emitiu NF
		EndIf
	EndIf
		                                                      	                                                      
	//Envia email se destinatarios estiverem parametrizados e houver dados a serem informados
	If 	Len(_aEmail) > 0 .and. _cRet == "1"
		U_PODTER6()
	EndIf
Else
	_cRet := "2"   	      
EndIf

RestArea(_aArea)    

Return(_cRet)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTATRF4บAutor  ณAldoney Dias          บ Data ณ  03/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmissao do Pedido de Venda para o segundo fornecedor, com   บฑฑ 
ฑฑบ          ณdados retornados do primeiro, para posterior faturamento.   บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                              

User Function ESTATRF4(_cChaveD1)

Local aCabec 	:= {}
Local aItens 	:= {}
Local aLinha 	:= {}  
Local _cQuery1 	:= ""
Local _nItem 	:= 1
Local nY 		:= 0
Local cDoc 		:= ""
Local _lOk 		:= .T.   
Local _nVlB6	:= 0 
Local _xTesRem 	:= GetMV("MV_XTESREG",,"611")	//Tes utilizado para remessa de poder de terceiro

PRIVATE lMsErroAuto := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Abertura do ambiente|
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//PREPARE ENVIRONMENT

//EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Verificacao do ambiente |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

dbSelectArea("SE4")
dbSetOrder(1)

dbSelectArea("SED")
dbSetOrder(1)

dbSelectArea("SA2")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica TESณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู

If	!SF4->(MsSeek(xFilial("SF4")+_xTesRem)) 
	_lOk := .F.
	ConOut("Cadastrar TES: "+_xTesRem+"")
Else 
	If	SF4->F4_PODER3 <> "R" .or. SF4->F4_MSBLQL == "1"	
		_lOk := .F.
		ConOut("TES: "+_xTesRem+" nใo controla remessa a Poder de Terceiro ou estแ bloqueada!")
	EndIf
EndIf                    
             
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica condi็ใo de pagamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If	!SE4->(MsSeek(xFilial("SE4")+"000")) 
	_lOk := .F.
	ConOut("Cadastrar condicao de pagamento: 000")
Else
	If	SE4->E4_MSBLQL == "1"
		_lOk := .F.
		ConOut("Condi็ใo de pagamento utilizada bloqueada: 000")
	EndIf
EndIf
             
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica naturezaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If	!SED->(MsSeek(xFilial("SED")+"FT020001")) 
	_lOk := .F.
	ConOut("Natureza simples remessa nใo existe: FT020001")
Else     
	If	SED->ED_MSBLQL == "1"
		_lOk := .F.
		ConOut("Natureza utilizada bloqueada: FT020001")
	EndIf
EndIf
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica fornecedorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If	!SA2->(MsSeek(xFilial("SA2")+_cFor2+_cLoj2)) 
	_lOk := .F. 
	ConOut("Cadastrar fornecedor/loja: "+_cFor2+"/"+_cLoj2+"")
Else                                     
	If	SA2->A2_MSBLQL == "1" 
		_lOk := .F. 
		ConOut("Fornecedor/loja bloqueado: "+_cFor2+"/"+_cLoj2+"")  
	EndIf
EndIf
	
//ฺฤฤฤฤฤฤฤฤฟ
//ณEmite PVณ
//ภฤฤฤฤฤฤฤฤู

If 	_lOk 
	
	ConOut("Inicio: "+Time())
	 
	cDoc := GetSxeNum("SC5","C5_NUM") 
	aCabec := {} 
	aItens := {}                              
	                                 
	aadd(aCabec,{"C5_FILIAL" 	,xFilial("SC5")								,Nil})
	aadd(aCabec,{"C5_NUM" 		,cDoc										,Nil})
	aadd(aCabec,{"C5_TIPO" 		,"B"										,Nil})
	aadd(aCabec,{"C5_CLIENTE"	,_cFor2										,Nil})
	aadd(aCabec,{"C5_LOJACLI"	,_cLoj2										,Nil})
	aadd(aCabec,{"C5_EMISSAO"	,dDataBase									,Nil})
	aadd(aCabec,{"C5_CONDPAG"	,SE4->E4_CODIGO								,Nil})
	aadd(aCabec,{"C5_XNATURE"	,"FT020001"									,Nil})
	aadd(aCabec,{"C5_VEND1"		,"000001"									,Nil})
	aadd(aCabec,{"C5_TIPOCLI"	,"R"										,Nil})  
	aadd(aCabec,{"C5_LOJAENT"	,_cLoj2										,Nil}) 
	aadd(aCabec,{"C5_MOEDA"		,1											,Nil})  
	aadd(aCabec,{"C5_TIPLIB"	,"1"										,Nil})
	aadd(aCabec,{"C5_TPCARGA"	,"2"										,Nil})
	aadd(aCabec,{"C5_MSBLQL"	,"2"										,Nil})
	aadd(aCabec,{"C5_GERAWMS"	,"2"										,Nil})
	aadd(aCabec,{"C5_LIBEROK"	,"S"										,Nil})            
		
	aLinha := {}
                       
	DbSelectArea("SD1")
	SD1->(DbSetOrder()) //FILIAL+DOC+SERIE+FORNECE+LOJA+COD+ITEM
	SD1->(DbGoTop())         
	
	If	SD1->(MsSeek(xFilial("SD1") + _cChaveD1)) 
		               
		While 	SD1->(!EOF()) .and. !SD1->D1_TIPO $ "BD" .and. xFilial("SD1") + _cChaveD1 == xFilial("SD1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA  
			                                          
				aadd(aLinha,{"C6_FILIAL" 	,xFilial("SC6")					,Nil})            
				aadd(aLinha,{"C6_NUM" 		,cDoc							,Nil})
				aadd(aLinha,{"C6_ITEM"		,StrZero(Val(SD1->D1_ITEM),2)	,Nil})
				aadd(aLinha,{"C6_PRODUTO"	,SD1->D1_COD					,Nil})
				aadd(aLinha,{"C6_QTDVEN"	,SD1->D1_QUANT		   			,Nil})
				aadd(aLinha,{"C6_PRCVEN"	,SD1->D1_VUNIT		   			,Nil})
				aadd(aLinha,{"C6_PRUNIT"	,SD1->D1_VUNIT		   			,Nil})
				aadd(aLinha,{"C6_VALOR"		,SD1->D1_TOTAL		 			,Nil})
				aadd(aLinha,{"C6_TES"		,_xTesRem			  			,Nil})    
				aadd(aLinha,{"C6_QTDLIB"	,SD1->D1_QUANT		  			,Nil})
				
				aadd(aItens,aLinha) 
				
				aLinha := {}
				_nItem := Len(aItens)+1
				
				SD1->(DbSkip())
		EndDo       
	EndIf
					
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ 
	//| Inclusao|
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	MATA410(aCabec,aItens,3)
			
	If 	!lMsErroAuto 
		ConOut("Incluido com sucesso!"+cDoc) 
	Else  
		MostraErro()
		_lOk := .F.                   
		RollBAckSx8()
		ConOut("Erro na inclusao!")
	EndIf 
	
	ConOut("Fim : "+Time())
EndIf

//ENVIRONMENT

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTATRF5บAutor  ณAldoney Dias          บ Data ณ  03/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite Nota Fiscal de Saํda para o PV.                       บฑฑ 
ฑฑบ          ณ                                                            บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                     

User Function ESTATRF5()

Ma460Proc("SC9",GetNewPar("MV_GARSSFW","RP2"),.F.,.F.,.F.,.F.,.F.,3,3,"","ZZZZZZ",.F.,0,"","ZZZZZZ",.F.,.F.,"",@lEnd,"2")

Return(.T.)                                                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณESTATRF6บAutor  ณAldoney Dias          บ Data ณ  03/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza fornecedor na SZ8 e SZ9.                           บฑฑ 
ฑฑบ          ณ                                                            บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/            

User Function ESTATRF6()     

//Altera fornecedor do PD caso ainda nใo esteja cadastrado.
SZ8->(dBSetOrder(2))

If 	!SZ8->(MsSeek(xFilial("SZ8")+_cFor2+_cLoj2)) .and. SZ8->(MsSeek(xFilial("SZ8")+_cFor1+_cLoj1))                                      

	SA2->( dbSetOrder(1) )
	SA2->( dbSeek( xFilial("SA2") + _cFor2 + _cLoj2 ) )

	//Altera fornecedor do PD - cabecalho
	Reclock("SZ8",.F.)
	SZ8->Z8_FORNEC 	:= _cFor2
	SZ8->Z8_LOJA	:= _cLoj2
	SZ8->Z8_NOMFOR 	:= SA2->A2_NOME
	SZ8->Z8_EMAIL  	:= SA2->A2_EMAIL
	SZ8->Z8_TIPO   	:= SA2->A2_TIPO
	SZ8->Z8_CNPJCPF	:= SA2->A2_CGC
	MsUnlock() 
					
	//Altera fornecedor do PD - itens      
	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1))
	
	SZ9->(MsSeek(xFilial("SZ9")+SZ8->Z8_COD))
	
	While	SZ9->(!EOF()) .and. SZ9->Z9_COD == SZ8->Z8_COD
		Reclock("SZ9",.F.)
			SZ9->Z9_FORNEC	:= _cFor2
			SZ9->Z9_LOJA	:= _cLoj2
		MsUnlock() 
				
		SZ9->(DbSkip())
	EndDo
EndIf

Return()                                                                 

//=====================================

User Function FTEC() 

Local cTitulo:="" 
Local MvPar 
Local MvParDef:="" 

Private aSit:={} 

MvPar:=&(Alltrim(ReadVar())) 
mvRet:=Alltrim(ReadVar())                

Aadd(aSit,'1' + " - " + 'Aberto') 
Aadd(aSit,'2' + " - " + 'Infra Em Execucao') 
Aadd(aSit,'3' + " - " + 'Em Aprov. Cliente') 
Aadd(aSit,'4' + " - " + 'Aguard. Entrega') 
Aadd(aSit,'5' + " - " + 'Infra Liberada') 
Aadd(aSit,'6' + " - " + 'Cancelado') 
Aadd(aSit,'7' + " - " + 'Encerrado') 

                                

MvParDef:= "1234567" 

IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,.F.) 
     &MvRet := mvpar                                                                           
EndIF 

Return(.T.) 


//-----------------------------------------------------------------------
// Rotina | GPE10Imp  | Autor | Rafael Beghini       | Data | 10/12/2015
//-----------------------------------------------------------------------
// Descr. | Impressao do relat๓rio  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function ESTA0104Imp()
	//Private cPerg:= "CSGPE010"
	Private oReport  := Nil
	Private oBreak   := Nil
	Private oSecCab  := Nil
	Private oSecItem := Nil
	
	Private nOpcImp := 0
	
	/*IF nOpcImp == 0	
		//Incluo/Altero as perguntas na tabela SX1
		AjustaSX1(cPerg)	
		//gero a pergunta de modo oculto, ficando disponํvel no botใo a็๕es relacionadas
		Pergunte(cPerg,.F.)	          
	EndIF
	*/
	ReportDef(nOpcImp)
	oReport:PrintDialog()	
Return Nil

//+------------------------------------------------------------------+
//| Rotina | ReportDef | Autor | Rafael Beghini | Data | 10/12/2015  |
//+------------------------------------------------------------------+
//| Descr. | Defini็ใo da estrutura do relat๓rio.			         |
//|        | 		                                                 |
//+------------------------------------------------------------------+
//| Uso    | Recursos Humanos			                             |
//+------------------------------------------------------------------+
Static Function ReportDef(nOpcImp)
	Local aOrd := {}
	
	aAdd( aOrd, "PD x PA" )
	
	oReport := TReport():New("ESTA0104Imp",'Ponto de Distribui็ใo x Produtos',,;
			   {|oReport| PrintReport(oReport, aOrd, nOpcImp)},;
			   "Este relat๓rio irแ imprimir o relat๓rio de Ponto de Distribui็ใo x Produtos")
	
	oReport:cFontBody:= 'Consolas'
	oReport:nFontBody:= 7
	oReport:nLineHeight:= 30
	oReport:SetPortrait(.T.)  //Retrato - oReport:SetLandscape(.T.) //Paisagem
	
	oSecCab := TRSection():New( oReport , 'Ponto de Distribui็ใo (PD)', {"QRY"}, aOrd, .F., .T.)

	TRCell():New( oSecCab, "Z8_COD"   	, "QRY", 'C๓digo'	 	,"@!",010)
	TRCell():New( oSecCab, "Z8_DESC"  	, "QRY", 'Descri็ใo'	,"@!",050)
	TRCell():New( oSecCab, "Z8_FORNEC"	, "QRY", 'Fornecedor'	,"@!",010)
	TRCell():New( oSecCab, "Z8_NOMFOR"	, "QRY", 'Nome'			,"@!",040)
	TRCell():New( oSecCab, "Z8_CNPJCPF"	, "QRY", 'CJPN'			,"@!",020)
	
	oSecItem := TRSection():New( oReport , 'Pontos de Atendimentos (PA)', {"QRY"}, NIL, .F., .T.)
	
	TRCell():New( oSecItem, "Z3_CODENT" , "QRY", 'Entidade'		,"@!",020)
	TRCell():New( oSecItem, "Z3_DESENT" , "QRY", 'Descri็ใo'	,"@!",050)
	TRCell():New( oSecItem, "Z3_TIPENT"	, "QRY", 'Tipo Entidade',"@!",020)
	TRCell():New( oSecItem, "Z3_CODGAR"	, "QRY", 'Entidade GAR' ,"@!",020)    
	TRCell():New( oSecItem, "Z3_CODAC"	, "QRY", 'Grupo/Rede'   ,"@!",020)  
	TRCell():New( oSecItem, "Z3_DESAC"	, "QRY", 'Descri็ใo'	,"@!",050)  
	TRCell():New( oSecItem, "Z3_CODAR"	, "QRY", 'AR'			,"@!",020)  
	TRCell():New( oSecItem, "Z3_DESAR"	, "QRY", 'Descri็ใo'	,"@!",050)  

	oReport:SetTotalInLine(.F.)
	
	//Aqui, farei uma quebra  por se็ใo
	oSecCab:SetPageBreak(.F.)
	oSecCab:SetTotalInLine(.F.)
	oSecCab:SetTotalText(" ")			

Return Nil

//+--------------------------------------------------------------------+
//| Rotina | PrintReport | Autor | Rafael Beghini | Data | 30/06/2014  |
//+--------------------------------------------------------------------+
//| Descr. | Executa a query para processamento do relat๓rio.          |
//|        | 		                                                   |
//+--------------------------------------------------------------------+
//| Uso    | Recursos Humanos (Benefํcios)                             |
//+--------------------------------------------------------------------+
Static Function PrintReport(oReport,aOrd, nOpcImp)
	Local cSQL	:= ""
	Local cNcm	:= ""
	Local cTipo	:= ""
	Local nPOS	:= 0
	Local aTIPO	:= {}
	
	cSQL += "SELECT Z8_COD," + CRLF
	cSQL += "       Z8_DESC," + CRLF
	cSQL += "       Z8_FORNEC," + CRLF
	cSQL += "       Z8_CNPJCPF," + CRLF
	cSQL += "       Z8_NOMFOR," + CRLF
	cSQL += "       Z3_CODENT," + CRLF
	cSQL += "       Z3_DESENT," + CRLF
	cSQL += "       Z3_TIPENT," + CRLF
	cSQL += "       Z3_CODGAR," + CRLF
	cSQL += "       Z3_CODAC," + CRLF
	cSQL += "       Z3_DESAC," + CRLF
	cSQL += "       Z3_CODAR," + CRLF
	cSQL += "       Z3_DESAR" + CRLF
	cSQL += "FROM   " + RetSqlName("SZ8") + " Z8" + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SZ3") + " Z3" + CRLF
	cSQL += "               ON Z3_FILIAL = Z8_FILIAL" + CRLF
	cSQL += "                  AND Z3_PONDIS = Z8_COD" + CRLF
	cSQL += "WHERE  Z8.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "       AND Z8_FILIAL = '" + xFilial('SZ8') +  "' " + CRLF
	cSQL += "       AND Z8_COD = '" + SZ8->Z8_COD +  "' " + CRLF

	cSQL := ChangeQuery(cSQL)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	aTIPO := StrTokArr( SX3->( Posicione( 'SX3', 2, 'Z3_TIPENT'  , 'X3CBox()' ) ), ';' )
	
	//crio o novo alias
	TCQUERY cSQL NEW ALIAS "QRY"	
	
	dbSelectArea("QRY")
	QRY->(dbGoTop())
	
	oReport:SetMeter(QRY->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira se็ใo
		oSecCab:Init()

		oReport:IncMeter()
					
		cNcm 	:= QRY->Z8_COD
		IncProc( "Imprimindo PI " + QRY->Z8_COD )
		
		//imprimo a primeira se็ใo				
		oSecCab:Cell("Z8_COD"	 ):SetValue( rTrim(QRY->Z8_COD)     )
		oSecCab:Cell("Z8_DESC"	 ):SetValue( rTrim(QRY->Z8_DESC)    )				
		oSecCab:Cell("Z8_FORNEC" ):SetValue( rTrim(QRY->Z8_FORNEC)  )
		oSecCab:Cell("Z8_NOMFOR" ):SetValue( rTrim(QRY->Z8_NOMFOR)  )				
		oSecCab:Cell("Z8_CNPJCPF"):SetValue( rTrim(QRY->Z8_CNPJCPF) )				
		oSecCab:Printline()

		//inicializo a segunda se็ใo
		oSecItem:init()
	
		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While QRY->Z8_COD == cNcm
			oReport:IncMeter()		
			
			nPos  := AScan( aTIPO, {|x| Left(x,1) == QRY->Z3_TIPENT  } )
			cTipo := IIF( nPos > 0,RTrim( SubStr( aTIPO[ nPos ], 3 ) ), QRY->Z3_TIPENT)
			
			//IncProc("Imprimindo produto "+alltrim(TRBNCM->B1_COD))
			oSecItem:Cell("Z3_CODENT"):SetValue( rTrim(QRY->Z3_CODENT) 	)
			oSecItem:Cell("Z3_DESENT"):SetValue( rTrim(QRY->Z3_DESENT)	)
			oSecItem:Cell("Z3_TIPENT"):SetValue( rTrim(cTipo)			)
			oSecItem:Cell("Z3_CODGAR"):SetValue( rTrim(QRY->Z3_CODGAR)  )
			oSecItem:Cell("Z3_CODAC" ):SetValue( rTrim(QRY->Z3_CODAC) 	)
			oSecItem:Cell("Z3_DESAC" ):SetValue( rTrim(QRY->Z3_DESAC) 	)
			oSecItem:Cell("Z3_CODAR" ):SetValue( rTrim(QRY->Z3_CODAR)	)
			oSecItem:Cell("Z3_DESAR" ):SetValue( rTrim(QRY->Z3_DESAR)	)
			oSecItem:Printline()
	
 			QRY->(dbSkip())
 		EndDo		
 		//finalizo a segunda se็ใo para que seja reiniciada para o proximo registro
 		oSecItem:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira se็ใo
		oSecCab:Finish()
	Enddo
Return
