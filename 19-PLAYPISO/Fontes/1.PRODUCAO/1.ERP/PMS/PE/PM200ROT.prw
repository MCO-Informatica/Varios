#include "protheus.ch"

User Function PM200ROT()
	
	Local aret := {{ "revisao", "U_xPMS210Rvs"  , 0 , 1,,.F.}}

Return aret

User Function xPMS210Rvs(cAlias,nReg,nOpcx)
Local oDlg
Local lGravaOk  := .F.
Local lContinua := .T.
Local bCampo    := {|n| FieldName(n) }
Local oMemo
Local nx        := 0
Local cNextVer  := ""
Local lTudoOk   := ExistBLock('PMA210Ok')
Local bOk
Local lLancaPco := .F.
Local cEncerra  := ""

Private M->AFE_MEMO	:= CriaVar("AFE_MEMO")
//Variaveis para serem utilizadas na integracao com o PCO
Private M->AF8_FASE	:=	AF8->AF8_FASE
Private cFaseAnt		:=	AF8->AF8_FASE

PRIVATE 	cSavScrVT,;
			cSavScrVP,;
			cSavScrHT,;
			cSavScrHP,;
			CurLen,;
			nPosAtu:=0,;
			nPosAnt:=9999,;
			nColAnt:=9999

If !PmsChkUser(AF8->AF8_PROJET, , Padr(AF8->AF8_PROJET, Len(AFC->AFC_EDT)), ;
              "  ", 3, "ESTRUT", AF8->AF8_REVISA)
	Aviso('STR0056', 'STR0057', {'STR0058'}, 2)
	Return
EndIf

// verifica se o projeto nao esta reservado
If AF8->AF8_STATUS=="2"
	Help("  ",1,"PMSA2101")
	lContinua := .F.
EndIf

// verifica se a fase do projeto pode gerar revisao
If lContinua .and. !PmsVldFase("AF8",AF8->AF8_PROJET,"71")
	lContinua := .F.
EndIf

// trava o registro do AF8
If !SoftLock("AF8")
	lContinua := .F.
Endif

//PcoIniLan('000352')

If lContinua

	// carrega as variaveis de memoria AFE
	dbSelectArea("AFE")
	RegToMemory("AFE",.T.)
	M->AFE_PROJET	:= AF8->AF8_PROJET
	M->AFE_DATAI	:= MsDate()
	M->AFE_HORAI	:= Time()
	M->AFE_NOME		:= UsrRetName(RetCodUsr())
	M->AFE_REVISA	:= AF8->AF8_REVISA
	M->AFE_DESCRI	:= AF8->AF8_DESCRI
	M->AFE_USERI	:= RetCodUsr()

	If nOpcx == 3
		Inclui := .T.
	EndIf

	If AFE->(FieldPos("AFE_FASE")) > 0 .And. AFE->(FieldPos("AFE_FASEOR")) > 0
		M->AFE_FASE   := AF8->AF8_FASE
		M->AFE_FASEOR := AF8->AF8_FASE
	EndIf

	// inicia lancamento do PCO
	PcoIniLan('000351')
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 8,0 TO 30,78 OF oMainWnd
		nOpc	:=	EnChoice( "AFE", nReg, nOpcx, , , , ,{16,1,90,307},)
		@ 97,2 Say "Comentarios" of oDlg Pixel  //
		@ 105,2 GET oMemo VAR M->AFE_MEMO MEMO SIZE 306,55 VALID MEMOVALID() PIXEL OF oDlg

	If lTudoOk
		bOk	:=	{|| M->AF8_FASE :=M->AFE_FASE, lGravaOk:=(M->AFE_FASE==AF8->AF8_FASE .Or. PmsFasePco(@cEncerra)) .And. ExecBlock('PMA210Ok',.F.,.F.,{'1'}),oDlg:End()}
	Else
		bOk	:=	{|| M->AF8_FASE :=M->AFE_FASE, lGravaOk:=(M->AFE_FASE==AF8->AF8_FASE .Or. PmsFasePco(@cEncerra)) ,oDlg:End()}
	Endif
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,{|| oDlg:End()}) CENTERED

	If lGravaOk
		Begin Transaction

			// estorna fase atual no PCO
			lLancaPco	:=	.F.
			If M->AFE_FASE<>AF8->AF8_FASE
				lLancaPco	:=	.T.
				PmsLancPco(2)
			Endif
			cNextVer := Soma1(AF8->AF8_REVISA)

			// verifica se a versao nao existe e pega a proxima
			dbSelectArea("AFE")
			dbSetOrder(1)
			While dbSeek(xFilial()+AF8->AF8_PROJET+cNextVer)
				cNextVer := Soma1(cNextVer)
			End
			RecLock("AFE",.T.)
			For nx := 1 TO FCount()
				FieldPut(nx,M->&(EVAL(bCampo,nx)))
			Next nx
			AFE->AFE_FILIAL := xFilial("AFE")
			AFE->AFE_REVISA := cNextVer
//			AFE->AFE_MEMO   := M->AFE_MEMO
			// Define como projeto normal.
			AFE->AFE_TIPO   := "1"
			MsUnlock()
			MaPmsRevisa(AF8->(RecNo()),,,cNextVer)
			RecLock("AF8",.F.)
			AF8->AF8_STATUS := "2"
			AF8->AF8_ENCPRJ := cEncerra

			If AFE->(FieldPos("AFE_FASE")) > 0 .And. AFE->(FieldPos("AFE_FASEOR")) > 0
				AF8->AF8_FASE := M->AFE_FASE
			EndIf

			MsUnlock()

			// lanca nova fase no PCO
			If lLancaPco
				PmsLancPco(1)
			Endif
		End Transaction
		PcoFinLan('000351')
		PcoFreeBlq('000351')
	EndIf
	MsUnlockAll()
EndIf

Return .F.
