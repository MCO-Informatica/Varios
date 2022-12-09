#include 'protheus.ch'
#include 'topconn.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CadEqp º Autor ³ Luiz Alberto  ³ 20.09.2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro Equipe Operadores PCP                             º±±
±±º          ³ Cliente: Metalacre                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CadEqp()
Private cCadastro	:= "Cadastro de Equipes de Operadores"
Private aHeaderSZD	:= {}
Private nUsado  	:= 0
Private aCampos		:= {}      	
Private aCores:={}
Private aLegenda:={}
Private aRotina:={	{"&Pesquisar"	 ,'AxPesqui'     	, 0, 1 },;
					{"&Visualizar" ,'u_EdtEqp'		, 0, 2 },;
					{"&Incluir"    ,'u_EdtEqp'		, 0, 3 },;
					{"&Alterar"    ,'u_EdtEqp'		, 0, 4 },;
					{"&Excluir"    ,'u_EdtEqp'		, 0, 5 }}

DbSelectArea("SZ1")
DbSetOrder(1)
MBrowse(01,01,30,70,"SZ1")
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³ EdtEqp   ³Autor  ³Jose Carlos Dias    ³ Data ³ 05.09.2007   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡„o ³ Incluir, Alterar ou Finaliza Movimentacao de Produtos         ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function EdtEqp(cAlias,nReg,nOpc)
Local oEdit3
Local oEdit5
Local oEdit6
Local oEdit7
Local oEdit8
Local aAlter       	:= {""}
Local nOpc1			:= 0
Local nSuperior    	:= C(063)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= C(000)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= C(188)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= C(269)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem 269
Local _lAlter		:= .F.
Local nMax			:= 999
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.
// Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do
// segundo campo>+..."
Local nFreeze      	:= 000              // Campos estaticos na GetDados.
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols
Local _nk			:= 0
Local aAux 			:= {}
Local _nOpc			:= 0
// Defina aqui os Botoes da sua EnchoiceBar
// Exemplo: Aadd(aButtons,{"USER", {|| Alert("Inclua a Acao")}, "Contatos"})
Local aButtons		:= {}

Private aHeader		:= {}
Private aCols		:= {}
Private oDlg
Private oEdit4
Private oEdit10
Private _cDesCli   	:= ""
Private _lRet		:= .F.
Private __nOpc		:= nOpc
Private aAltCampos	:= {"Z1_CODOPER","Z1_DESCOPE"}
Private	_cUsuario 	:= Alltrim(SubStr(CUSUARIO,7,15))
Private _cDataHora	:= ""
Private _cNomProd	:= ""
Private oEdit0
Private oEdit1
Private oEdit2
//*****************************************************************
// nOpc = 2 : INCLUSAO
// nOpc = 3 : ALTERACAO
// nOpc = 4 : EXCLUSAO
// nOpc = 5 : VISUALIZACAO
//*****************************************************************
//Function RegToMemory(cAlias,lInc,lDic,lInitPad)
//*****************************************************************
//_cLote    := GETSX8NUM("SZB","ZB_CODINT")
//_cClient  := Iif(Alltrim(GetMV("MV_CLIPAD"))='',Space(06),Alltrim(GetMV("MV_CLIPAD")))
//_cVend	  := Iif(Alltrim(GetMV("MV_VENDPAD"))='',Space(06),Alltrim(GetMV("MV_VENDPAD")))
//*****************************************************************
If nOpc=3
	RegToMemory("SZ1",.T.)
	M->Z1_CODOPER:=Space(06)
	M->Z1_DESCOPE:=Space(40)
	M->Z1_TIPO:='O'
	_lRet		:= .T.
	INCLUI := .t.
	ALTERA := .f.
Else
	If nOpc==4
		If SZ1->Z1_TIPO == 'O'
			MsgStop("Alteração Só Para Tipos Equipes !")
			Return .f.
		Endif
		INCLUI := .f.
		ALTERA := .t.
	Else
		INCLUI := .f.
		ALTERA := .f.
	Endif
	DbSelectArea("SZ1")
	DbGoto(nReg)
	RegToMemory("SZ1",.F.,.T.,.F.)
	DbSelectArea("SZ1")
	M->Z1_CODOPER:=SZ1->Z1_CODOPER
	M->Z1_DESCOPE:=SZ1->Z1_DESCOPE
	M->Z1_TIPO   :=SZ1->Z1_TIPO
	_lRet		:= .T.
Endif

If _lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria aHeader e aCols da GetDados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")        
	dbSetOrder(1)
	dbSeek("SZF")
	nUsado  := 0
	While !Eof().And.(x3_arquivo=="SZF")
		If !(Alltrim(X3_CAMPO) $ 'ZF_FILIAL|ZF_CODOPER')
			If X3USO(x3_usado) .And. cNivel >= x3_nivel
				nUsado++
				_cValid:=X3_VALID
				Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,_cValid,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,;
				SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				Aadd(aAlter,UPPER(x3_campo))
			Endif
		Endif
		dbSkip()
	Enddo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos itens                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols :={}
	aAux  :={}
	If nOpc<>3
		DbSelectArea("SZF")
		DbSetOrder(1)
		If DbSeek(xFilial("SZF")+SZ1->Z1_CODOPER)
			While !Eof() .And. SZF->ZF_CODOPER = SZ1->Z1_CODOPER
				AADD(aCols,{SZF->ZF_OPERADO,SZF->ZF_NOME,.F.})
				DbSkip()
			Enddo
		Endif
	Else
		For nX := 1 to Len(aHeader)
			Aadd(aAux,CriaVar(aHeader[nX,2]))
		Next nX
		Aadd(aAux,.F.)
		Aadd(aCols,aAux)
	Endif
	
	If nOpc==3
		_lAlter:=.T.
	Else
		_lAlter:=.F.
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM C(178),C(181) TO C(548),C(717) PIXEL
	// Cria Componentes Padroes do Sistema
	@ C(030),C(025) MsComboBox oEdit0 Var M->Z1_TIPO ITEMS {"O=Operador","E=Equipes"}   WHEN _lAlter Size C(80),C(007) ON CHANGE (fVldTipo(M->Z1_TIPO)) PIXEL OF oDlg
	@ C(045),C(025) MsGet oEdit1 Var M->Z1_CODOPER Valid fNomFu() F3 'SRAPER' Size C(023),C(007) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(045),C(070) MsGet oEdit2 Var M->Z1_DESCOPE Picture "@!" Valid(!Empty(M->Z1_DESCOPE)) Size C(130),C(007) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(031),C(002) Say "Oper/Eqp:" Size C(030),C(006) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(046),C(002) Say "Equipe:" Size C(020),C(006) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(046),C(051) Say "Descr.:" Size C(019),C(006) COLOR CLR_BLACK PIXEL OF oDlg
	
	If nOpc==3 .Or. nOpc==4 //Inclui ou ALterar
		nOpc1:=GD_INSERT+GD_DELETE+GD_UPDATE
	Else
		nOpc1:=0
	Endif
	
	oGetDados := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc1,cLinhaOk,cTudoOk,cIniCpos,;
	aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDlg,aHeader,aCols)
	
	oEdit2:Disable()
	oEdit2:Refresh()
	If nOpc == 2 .Or. nOpc == 5
		oEdit1:Disable()
		oEdit1:Refresh()
		oEdit2:Disable()
		oEdit2:Refresh()
		oGetDados:Disable()
	ElseIf nOpc == 4
		oEdit1:Disable()
		oEdit1:Refresh()
		oEdit2:Enable()
		oEdit2:Refresh()
	Endif
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||_nOpc:=1,if(TudoOk(),oDlg:End(),_nOpc := 0)},{||_nOpc:=2,oDlg:End()}) VALID _nOpc != 0
	
	If _nOpc = 1 //Botao Confirma
		If nOpc = 3
			If Len(oGetDados:Acols) > 0
				//Gravacao dos Dados da Tabela SZD
				DbSelectArea("SZ1")
				RecLock("SZ1",.T.)
				For nCntFor := 1 TO SZD->(FCount())
					SZ1->&(FieldName(nCntFor)) := M->&(FieldName(nCntFor))
				Next
				MsUnLock()        
				
				If M->Z1_TIPO == 'E'
					//Gravacao dos Dados da Tabela SZE
					For _nx:=1 to Len(oGetDados:Acols)
						If !oGetDados:Acols[_nx,Len(oGetDados:Acols[_nx])]
							DbSelectArea("SZF")
							RecLock("SZF",.T.)
							For nInd := 1 To (SZC->(Fcount()))
								nPos := AScan(aHeader, {|x| Alltrim(X[2]) = Alltrim(FieldName(nInd))})
								If nPos > 0
									FieldPut(nInd,oGetDados:Acols[_nx,nPos])
								Endif
							Next nInd
							SZF->ZF_CODOPER := M->Z1_CODOPER
							MsUnLock()
							_nk++
						Endif
					Next
				Endif
			Endif
		ElseIf nOpc = 4
			_nk:=1
			//Deleta o Anterior
			DbSelectArea("SZF")
			DbSetOrder(1)
			If DbSeek(xFilial("SZF")+M->Z1_CODOPER)
				While !Eof() .And. SZF->ZF_CODOPER = M->Z1_CODOPER
					RecLock("SZF",.F.)
					Delete
					MsUnLock()
					DbSkip()
				Enddo
				If M->Z1_TIPO == 'E'
					For _nx:=1 to Len(oGetDados:Acols)
						If !oGetDados:Acols[_nx,Len(oGetDados:Acols[_nx])]
							RecLock("SZF",.T.)
							For nInd := 1 To (SZF->(Fcount()))
								nPos := AScan(aHeader, {|x| Alltrim(X[2]) = Alltrim(FieldName(nInd))})
								If nPos > 0
									FieldPut(nInd,oGetDados:Acols[_nx,nPos])
								Endif
							Next nInd
							SZF->ZF_CODOPER := M->Z1_CODOPER
							MsUnLock()
						Endif
					Next
				Endif
			Endif
		ElseIf nOpc = 5
			If MsgYesNo("Confirma a Exclusao ?")
				If SZ1->Z1_TIPO == 'E' 
					DbSelectArea("SZF")
					DbSetOrder(1)
					If DbSeek(xFilial("SZF")+M->Z1_CODOPER)
						While !Eof() .And. SZF->ZF_CODOPER = M->Z1_CODOPER
							RecLock("SZF",.F.)
							Delete
							MsUnLock()
							DbSkip()
						Enddo
					Endif
				ElseIf SZ1->Z1_TIPO == 'O' 
					If SZF->(dbSetOrder(2), dbSeek(xFilial("SZF")+M->Z1_CODOPER))
						MsgStop("Operador Nao pode ser excluido, porque faz parte de equipe de operadores. ")
						Return .f.
					Endif
				Endif
				
				
				DbSelectArea('SZ1')
				RecLock("SZ1",.F.)
				Delete
				MsUnLock()
			Endif
		Endif
	Endif
Endif
DbSelectArea("SZ1")
DbSetOrder(1)
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


Static Function fVldTipo(cTipo)
If cTipo=="O" .And. INCLUI
	M->Z1_TIPO := cTipo         
	If INCLUI
		M->Z1_CODOPER := Space(06)
	Endif
	oEdit1:Enable()
	oEdit1:Refresh()
	oEdit1:SetFocus()
	oEdit2:Disable()
	oEdit2:Refresh()
	oGetDados:Disable()
ElseIf cTipo=='E' .And. INCLUI
	M->Z1_TIPO := cTipo         
	M->Z1_CODOPER := fPrxGrupo()
	oEdit1:Disable()
	oEdit1:Refresh()
	oEdit2:Enable()
	oEdit2:Refresh()
	oEdit2:SetFocus()
	oGetDados:Enable()
Else
	MsgStop("Atenção Tipo Só Pode Ser O ou E !")
Endif                 
oGetDados:Refresh()
Return .t.         

Static Function fNomFu()
If INCLUI 
	nReg := SZ1->(Recno())
	If SZ1->(dbSetOrder(1), dbSeek(xFilial("SZ1")+M->Z1_CODOPER))
		MsgStop("Atenção Funcionário Já Cadastrado Como Operador !")
		SZ1->(dbGoTo(nReg))
		Return .f.
	Endif
Endif
If SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+M->Z1_CODOPER))
	M->Z1_DESCOPE := SRA->RA_NOME
Else
	MsgStop("Funcionário Não Localizado !")
	Return .f.
Endif                  
oGetDados:Disable()
Return .t.

Static Function fPrxGrupo()
Local aArea := GetArea()

cQry := " SELECT "
cQry += "   MAX(Z1_CODOPER) GRUPO  "
cQry += "   FROM "+RetSqlName("SZ1")+" SZ1 "
cQry += "  WHERE D_E_L_E_T_ = '' "
cQry += "    AND Z1_TIPO = 'E' "

//Fecha Alias caso encontre
If Select("QRY") <> 0 ; QRY->(dbCloseArea()) ; EndIf

//Cria alias temporario
TcQuery cQry New Alias "QRY"

cProxNum := Soma1(QRY->GRUPO,6)

QRY->(dbCloseArea())

RestArea(aArea)
Return cProxNum



Static Function TudoOk()
If INCLUI .Or. ALTERA
	If Len(oGetDados:aCols)>0
		For _nX := 1 To Len(oGetDados:aCols)
			If !oGetDados:aCols[_nX,Len(oGetDados:aHeader)+1]
				cMatricula := oGetDados:aCols[_nX,Ascan(oGetDados:aHeader,{|x|Alltrim(x[2])=="ZF_OPERADO"})]
				
				If !Empty(cMatricula) .And. !SZ1->(dbSetOrder(1), dbSeek(xFilial("SZ1")+cMatricula)) .Or. SZ1->Z1_TIPO == 'E'
					MsgStop("Operador " + cMatricula + " Nao Localizado ou Trata-se de Codigo de Equipe, Nao e Permitido !")
					Return .f.
				Endif
				
				For _nZ := _nX+1 To Len(oGetDados:aCols)
					If !oGetDados:aCols[_nZ,Len(oGetDados:aHeader)+1]
						If !Empty(cMatricula) .And. cMatricula == oGetDados:aCols[_nZ,Ascan(oGetDados:aHeader,{|x|Alltrim(x[2])=="ZF_OPERADO"})]
							MsgStop("Atencao Operador Em Duplicidade - Codigo: " + cMatricula)
							Return .f.
						Endif
					Endif
				Next
			Endif
		Next
	Endif
Endif
Return .t.


