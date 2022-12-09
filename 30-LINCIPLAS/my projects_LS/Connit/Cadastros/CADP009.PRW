#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
+=====================================================+
|Programa: CADP009|Autor: Antonio Carlos |01/08/09    |
+=====================================================+
|Descrição: Programa utilizado copia de repartes      |
+=====================================================+
|Uso: Laselva                                         |
+=====================================================+
*/

User Function CADP009()

Local cCadastro	:= "Cópia de Repartes"
Private _cProdd	:= Space(15)
Private _cProdp	:= Space(15) 
Private oDlg

	DEFINE MSDIALOG oDlg FROM 000,000 TO 220,400 TITLE cCadastro PIXEL

	@ 05,05 TO 080,200 PIXEL			

	@ 010,010 SAY "Esta rotina é responsável pela cópia de repartes de um produto para outro " PIXEL OF oDlg 

	@ 040,050 SAY "Produto de : " PIXEL OF oDlg
	@ 040,090 MSGET oProd1 VAR _cProdd PICTURE "@!" SIZE 60,10 F3 "SB1" VALID ExistCpo("SB1") PIXEL OF oDlg
	
	@ 060,050 SAY "Produto para : " PIXEL OF oDlg
	@ 060,090 MSGET oProd2 VAR _cProdp PICTURE "@!" SIZE 60,10 F3 "SB1" VALID ExistCpo("SB1") PIXEL OF oDlg

	@ 090,055 	BUTTON "Processa"	SIZE 040,015 OF oDlg PIXEL ACTION( LjMsgRun("Processando",, {|| AtuDados() }) ) 
	@ 090,110 	BUTTON "Fechar"  	SIZE 040,015 OF oDlg PIXEL ACTION( oDlg:End() ) 
  		
	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function CTGrpUser(cCodGrup)

Local cNameGrp
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

Static Function AtuDados()

Local aArea	:= GetArea()
Local aTemp		:= {}
Local aRetUsu	:= {}
Local _aItemSBZ	:= {}
Local _nCont	:= 0

Private cCTGrpUser	:= ""

PswOrder(2)
If PSWSEEK(cUserName,.T.)
	PswOrder(3)
	aRetUsu := PswRet()
	For nX := 1 to Len(aRetUsu[1][10])
		//cCTGrpUser += "/" + CTGrpUser(aRetUsu[1][10][nX]) + "/"
		cCTGrpUser += "/" + IIF(!EMPTY(ALLTRIM(CTGrpUser(aRetUsu[1][10][nX]))),CTGrpUser(aRetUsu[1][10][nX]),aRetUsu[1][10][nX]) + "/"
	Next nX
EndIf

If("PRODUTOS" $ cCTGrpUser) .Or. ("000027" $ cCTGrpUser) .Or. ("Administrador" $ cUserName) .or. __cUserId $ GetMv('LA_PODER')

	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) )
	If SB1->( DbSeek(xFilial("SB1")+_cProdd) ) 
	
		cQry := " SELECT BZ_FILIAL, BZ_COD, BZ_LOCPAD, BZ_TE, BZ_TS, BZ_EMIN, BZ_EMAX, BZ_DESC, BZ_PERFIL, BZ_SUPPLY "
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
					QRY->BZ_EMIN,;
					QRY->BZ_EMAX,;
					QRY->BZ_PERFIL,;
					QRY->BZ_SUPPLY})
				QRY->( DbSkip() )
			EndDo	
		EndIf

		DbCloseArea()
	
		For _nI := 1 To Len(_aItemSBZ)
		
			DbSelectArea("SBZ")
			SBZ->( DbSetOrder(1) )
			If SBZ->( DbSeek(_aItemSBZ[_nI,1]+_aItemSBZ[_nI,2]) )
				RecLock("SBZ",!SBZ->( DbSeek(_aItemSBZ[_nI,1]+_aItemSBZ[_nI,2]) ))
				SBZ->BZ_EMIN	:= _aItemSBZ[_nI,3]
				SBZ->BZ_EMAX	:= _aItemSBZ[_nI,4]	
				SBZ->BZ_PERFIL	:= _aItemSBZ[_nI,5]	
				SBZ->BZ_SUPPLY	:= _aItemSBZ[_nI,6]	
				SBZ->( MsUnLock() )
			EndIf
		 		
		Next _nI
		
		MsgInfo("Processamento concluido com sucesso!")
	
	Else

		MsgStop("Produto inexistente!")

	EndIf
	
Else
	
	MsgStop("Usuario sem permissao para executar rotina!")    

EndIf	

RestArea(aArea)

Return