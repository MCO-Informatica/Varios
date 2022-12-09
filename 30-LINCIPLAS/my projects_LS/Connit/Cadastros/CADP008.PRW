#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
+=====================================================+
|Programa: CADP008|Autor: Antonio Carlos |01/08/09    |
+=====================================================+
|Descrição: Programa utilizado na inclusão de uma nova|
|edição para produtos do grupo Revistas               |
+=====================================================+
|Uso: Laselva                                         |
+=====================================================+
*/

User Function CADP008()

Local cCadastro	:= "Replica de Produtos - Nova Edicao"
Private _cProdd	:= Space(15)
Private _cProdp	:= Space(15)
Private oDlg

DEFINE MSDIALOG oDlg FROM 000,000 TO 220,400 TITLE cCadastro PIXEL

@ 05,05 TO 080,200 PIXEL

@ 010,010 SAY "Esta rotina e responsavel pela inclusao no cadastro de produtos para o " PIXEL OF oDlg
@ 020,010 SAY "de Revistas no caso de novas edicoes.                                  " PIXEL OF oDlg

@ 040,050 SAY "Produto de : " PIXEL OF oDlg
@ 040,090 MSGET oProd1 VAR _cProdd SIZE 60,10 F3 "SB1" VALID ExistCpo("SB1") PIXEL OF oDlg

@ 060,050 SAY "Produto para : " PIXEL OF oDlg
@ 060,090 MSGET oProd2 VAR _cProdp PICTURE "@!" SIZE 60,10 VALID !Empty(_cProdp) PIXEL OF oDlg

@ 090,055 	BUTTON "Processa"	SIZE 040,015 OF oDlg PIXEL ACTION( LjMsgRun("Processando",, {|| AtuDados() }) )
@ 090,110 	BUTTON "Fechar"  	SIZE 040,015 OF oDlg PIXEL ACTION( oDlg:End() )

ACTIVATE MSDIALOG oDlg CENTERED

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// *************************************************************************************************************** //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// *************************************************************************************************************** //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuDados()

Local aArea	:= GetArea()
Local aTemp		:= {}
Local aRetUsu	:= {}
Local _aItemSBZ	:= {}
Local _nCont	:= 0

Private cCTGrpUser	:= ""

DbSelectArea("SB1")
SB1->( DbSetOrder(1) )
If SB1->( DbSeek(xFilial("SB1")+_cProdp) )
	MsgStop("Produto ja cadastrado!")
	Return(.F.)
EndIf

PswOrder(2)
If PSWSEEK(cUserName,.T.)
	PswOrder(3)
	aRetUsu := PswRet()
	For nX := 1 to Len(aRetUsu[1][10])
		//cCTGrpUser += "/" + CTGrpUser(aRetUsu[1][10][nX]) + "/"
		cCTGrpUser += "/" + IIF(!EMPTY(ALLTRIM(CTGrpUser(aRetUsu[1][10][nX]))),CTGrpUser(aRetUsu[1][10][nX]),aRetUsu[1][10][nX]) + "/"
	Next nX
EndIf

If ("PRODUTOS" $ cCTGrpUser) .Or. ("000027" $ cCTGrpUser) .Or.("Administrador" $ cUserName)
	
	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) )
	If SB1->( DbSeek(xFilial("SB1")+_cProdd) )
		
		cGrup := SB1->B1_GRUPO
		
		For I:= 1 To Fcount()
			Aadd(aTemp,{ FieldName(I), FieldGet(I) })
		Next
		
		RecLock("SB1", .T.)
		For I := 1 To FCount()
			If aTemp[I,1] == "B1_COD"
				FieldPut(I,_cProdp)
			Else
				FieldPut(I,aTemp[I,2])
			Endif
		Next
		SB1->( MsUnlock() )
		
		cQry := " SELECT BZ_FILIAL, BZ_COD, BZ_LOCPAD, BZ_TE, BZ_TS, BZ_TEC, BZ_TSC, BZ_TE_FORN, BZ_TS_FORN, BZ_EMIN, BZ_EMAX, BZ_DESC, BZ_PERFIL, BZ_SUPPLY "
		cQry += " FROM "+RetSqlName("SBZ")+" SBZ WITH (NOLOCK) "
		cQry += " WHERE BZ_COD = '"+_cProdd+"' AND "
		cQry += " SBZ.D_E_L_E_T_ = '' "
		cQry += " ORDER BY BZ_FILIAL "
		
		TcQuery cQry NEW ALIAS "QRY"
		
		DbSelectArea("QRY")
		QRY->( DbGoTop() )
		If QRY->( !Eof() )
			While QRY->( !Eof() )
				
				Aadd(_aItemSBZ,{QRY->BZ_FILIAL,;
				_cProdp,;
				QRY->BZ_LOCPAD,;
				QRY->BZ_TE,;
				QRY->BZ_TS,;  
				QRY->BZ_TEC,;
				QRY->BZ_TSC,;
				QRY->BZ_TE_FORN,;
				QRY->BZ_TS_TSC,;
				QRY->BZ_EMIN,;
				QRY->BZ_EMAX,;
				Posicione("SB1",1,xFilial("SB1")+_cProdp,"B1_DESC"),;
				QRY->BZ_PERFIL,;
				QRY->BZ_SUPPLY} )
				
				QRY->( DbSkip() )
				
			EndDo
			
		EndIf
		
		DbCloseArea()
		ChkFile("SM0")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona filiais.   					       		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SM0")
		SM0->( DbSetOrder(1) )
		SM0->( DbGoTop() )
		While SM0->( !Eof() ) .And. SM0->M0_CODIGO == "01"
			
			nPos := aScan(_aItemSBZ,{|x| x[1] == SM0->M0_CODFIL })
			
			If nPos > 0
				RecLock("SBZ",.T.)
				SBZ->BZ_FILIAL		:= _aItemSBZ[nPos,1]
				SBZ->BZ_COD 		:= _aItemSBZ[nPos,2]
				SBZ->BZ_LOCPAD		:= _aItemSBZ[nPos,3]
				SBZ->BZ_TE			:= _aItemSBZ[nPos,4]
				SBZ->BZ_TS			:= _aItemSBZ[nPos,5]
				SBZ->BZ_TEC			:= _aItemSBZ[nPos,6]
				SBZ->BZ_TSC         := _aItemSBZ[nPos,7]
				SBZ->BZ_TE_FORN     := _aItemSBZ[nPos,8]
				SBZ->BZ_TS_FORN     := _aItemSBZ[nPos,9]
				SBZ->BZ_EMIN		:= _aItemSBZ[nPos,10]
				SBZ->BZ_EMAX		:= _aItemSBZ[nPos,11]
				SBZ->BZ_DESC		:= _aItemSBZ[nPos,12]
				SBZ->BZ_PERFIL		:= _aItemSBZ[nPos,13]
				SBZ->BZ_PERFIL		:= _aItemSBZ[nPos,14]
				SBZ->( MsUnLock() )
			Else
				
				RecLock("SBZ",.T.)
				SBZ->BZ_FILIAL := SM0->M0_CODFIL
				SBZ->BZ_COD    := _cProdp
				SBZ->BZ_DESC   := Posicione("SB1",1,xFilial("SB1")+_cProdp,"B1_DESC")
				SBZ->BZ_LOCPAD := "01"
				
				Do Case
					Case SM0->M0_CODFIL == "01" .And. cGrup $ ('0004/0003/0005/0006/0007')
						cTe :=  '017'
					Case Substr(SM0->M0_CGC,1,8) = '53928891' .And. cGrup $ ('0004/0003/0005/0006/0007')
						cTe := '009'
					Case Substr(SM0->M0_CGC,1,8) = '53928891' .And. cGrup $ ('0001/0002/0008/0009')
						cTe := '010'
					Case Substr(SM0->M0_CGC,1,8) <> '53928891' .And. cGrup $ ('0001/0002/0008/0009')
						cTe := '064'
					Case Substr(SM0->M0_CGC,1,8) <> '53928891' .And. cGrup $ ('0004/0003/0005/0006/0007')
						cTe := '063'
					Case Substr(SM0->M0_CGC,1,8) = '53928891' .And. cGrup $ ('0010')
						cTe := '101'
					Case Substr(SM0->M0_CGC,1,8) <> '53928891' .And. cGrup $ ('0010')
						cTe := '103'
					OtherWise
						cTe := '002'
				EndCase
				
				SBZ->BZ_TE := cTe
				
				Do Case
					Case SM0->M0_CODFIL == "01" .And. cGrup $ ('0004/0003/0005/0006/0007')
						cTs :=  '525'
					Case Substr(SM0->M0_CGC,1,8) = '53928891' .And. cGrup $ ('0004/0003/0005/0006/0007')
						cTs := '517'
					Case Substr(SM0->M0_CGC,1,8) = '53928891' .And. cGrup $ ('0001/0002/0008/0009')
						cTs := '518'
					Case Substr(SM0->M0_CGC,1,8) <> '53928891' .And. cGrup $ ('0001/0002/0008/0009')
						cTs := '582'
					Case Substr(SM0->M0_CGC,1,8) <> '53928891' .And. cGrup $ ('0004/0003/0005/0006/0007')
						cTs := '581'
					Case Substr(SM0->M0_CGC,1,8) = '53928891' .And. cGrup $ ('0010')
						cTs := '613'
					Case Substr(SM0->M0_CGC,1,8) <> '53928891' .And. cGrup $ ('0010')
						cTs := '601'
					OtherWise
//						cTs := '611'
						cTs := '706'
				EndCase
				
				SBZ->BZ_TS := cTs
				
				SBZ->( MsUnlock() )
				
			EndIf
			
			If cGrup $ GetMv("MV_DIASENC")
				RecLock("SZ7",.T.)
				SZ7->Z7_FILIAL	:= SM0->M0_CODFIL
				SZ7->Z7_COD		:= _cProdp
				SZ7->Z7_ENCALHE	:= SB1->B1_ENCALHE
				SZ7->( MsUnlock() )
			EndIf
			
			RecLock("SB2",.T.)
			SB2->B2_FILIAL	:= SM0->M0_CODFIL
			SB2->B2_COD		:= _cProdp
			SB2->B2_LOCAL	:= "01"
			SB2->( MsUnlock() )
			
			SM0->( DbSkip() )
			
		EndDo
		
		MsgInfo("Processamento concluido com sucesso!")
		
	Else
		
		MsgStop("Produto inexistente!")
		
	EndIf
	
Else
	
	MsgStop("Usuario sem permissao para executar rotina!")
	
EndIf

RestArea(aArea)

Return
