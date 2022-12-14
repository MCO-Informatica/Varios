#Include "Protheus.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIDA006
Rotina para manuten??o do cadastro do c?digo sequencial do produto.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		12/08/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function HCIDA006()

	Private cCadastro := "Cadastro de Unidade de Negocio"
	
	Private aRotina := { {"Pesquisar"	,"AxPesqui",0,1},;
	                     {"Visualizar"	,"u_fHDA006(2)",0,2},;
	                     {"Incluir"		,"u_fHDA006(3)",0,3},;
	                     {"Alterar"		,"u_fHDA006(4)",0,4},;
	                     {"Excluir"		,"u_fHDA006(5)",0,5}}
	
	Private cString := "SX5"
	
	dbSelectArea(cString)
	dbSetOrder(1)
	dbSetFilter({|| X5_TABELA = 'TM'},"X5_TABELA = 'TM'") // filtrar apenas a tabela DJ (tipo de operacoes)
	
	mBrowse(6,1,22,75,cString)

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} fHDA006
fun??o para manuten??o do cadastro do c?digo sequencial do produto.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		12/08/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function fHDA006(_nOpc)

	Local cCadastro  	:= "Unidade de Negocio"
	Local oDlg          := Nil
	Local _lOk       	:= .F.

	Private _alEncho	:= {}
	Private _aAlter	 	:= Iif(_nOpc==3,{"X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"},{"X5_DESCRI","X5_DESCSPA","X5_DESCENG"})
	Private _oEnchoice	:= Nil
	Private aTELA[0][0],aGETS[0]
	
	SX5->(RegToMemory("SX5",_nOpc == 3))
	
	AADD(_alEncho,"X5_CHAVE")
	AADD(_alEncho,"X5_DESCRI")
	AADD(_alEncho,"X5_DESCSPA")	
	AADD(_alEncho,"X5_DESCENG")	
	AADD(_alEncho,"NOUSER")
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 215,598 OF oMainWnd PIXEL
	
		_oEnchoice	:= Enchoice("SX5",SX5->(Recno()),_nOpc,,,,_alEncho,{003,003,090,298},_aAlter,,,,,oDlg,,.T.)
		
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| _lOk := .T., oDlg:End()},{||oDlg:End()}) CENTERED
	
	IF _lOk // confirmou
		SX5->(dbSetOrder(1))
		IF SX5->(dbSeek(XFilial("SX5")+"TM"+M->X5_CHAVE))
			If _nOpc == 5
				If RecLock("SX5", .F., .T.)
					SX5->( dbDelete() )
					SX5->( MsUnLock() )
				EndIf
			Else
				If RecLock("SX5",.F.)
					SX5->X5_DESCRI	:= M->X5_DESCRI
					SX5->X5_DESCSPA	:= M->X5_DESCSPA
					SX5->X5_DESCENG	:= M->X5_DESCENG
					SX5->(msUnlock())
				EndIf
			EndIf
		ELSE
			If RecLock("SX5",.T.)
				SX5->X5_FILIAL	:= xFilial("SX5")
				SX5->X5_TABELA	:= "TM"
				SX5->X5_CHAVE	:= M->X5_CHAVE
				SX5->X5_DESCRI	:= M->X5_DESCRI
				SX5->X5_DESCSPA	:= M->X5_DESCSPA
				SX5->X5_DESCENG	:= M->X5_DESCENG
				SX5->(msUnlock())
			EndIf
		ENDIF
	ENDIF
	
Return()