#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ RNGCTA1B บ Autor ณ Fabio Jadao Caires  บ Data ณ  Out/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescr.    ณ Ponto de entrada para adicionar opcoes ao menu da tela de  บฑฑ
ฑฑบ          ณ manutencao d contratos.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRenova                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTA100MNU()

Local nOpAlt 	:= 0
Local nX    := 0
Local nQtdeItensMenu := Len(aRotina)
Local aRotRetorno  := {}


If FunName() == 'CNTA100'
	For nX:=1 To nQtdeItensMenu
		If UPPER( aRotina[nX][2] ) <> 'CN100CTRADIA'
			Aadd( aRotRetorno, aRotina[nX] )
		EndIf
	Next nX
	
	If !Empty(aRotRetorno)
		aRotina := Aclone( aRotRetorno )
	EndIF
EndIf

nOpAlt 	:= Iif(VerSenha(58),58,77) //Permissใo de altera็ใo

ADD OPTION aRotina TITLE "Alterar (especial)"	ACTION "U_RNGCTA1B()"	OPERATION MODEL_OPERATION_UPDATE	ACCESS nOpAlt 	//-- Alterar
aAdd(aRotina, {"Consulta aprovacao"	 , 	'U_AprCN9()'   ,0,2,0,nil})
AaDd(aRotina, {"Reenvia p/ aprovacao", 	'U_EnvCTWF()'   ,0,2,0,NIL})// incluido em 04/12/2020 couto

Return aRotina
          
/*
================================================================
Programa.: 	CTAPOSIC
Autor....:	Pedro Augusto
Data.....: 	02/09/2013 บฑฑ
Descricao: 	PE que cria uma tela de consulta do processo de
aprovacao do contrato.
Uso......: 	SERVENG
================================================================
*/
User Function AprCN9()
LOCAL oDlg, oGet
LOCAL nAcols := 0,nOpca := 0
LOCAL cCampos
LOCAL cSituaca := "",lBloq := .F.
LOCAL oBold
Local _cSituac:= CN9->CN9_SITUAC
Local nCntFor:=""

If Empty(CN9->CN9_APROV)
	Aviso("Atencao","Este Documento nao possui controle de aprovacao via Workflow.",{"Voltar"})
	dbSelectArea("CN9")
	Return nOpca
EndIf

If _cSituac == '09' //Em revisใo
	_cTipo := "RV"
Else
	_cTipo := "CT" //Aprova็ใo para inclusใo de contrato situac = 04
Endif

ChkFile("SCR",.F.,"TMP")
//_cUsuario 	:= UsrFullName(CN9->CN9_XUSER)// COMENTADO PORQUE O CAMPO JA CARREGA O NOME DO USUARIO E NAO O CODIGO
_cUsuario 	:= CN9->CN9_XUSER
aCols := {}
aHeader := {}

dbSelectArea("TMP")
dbSetOrder(1)
dbSeek(xFilial("SCR")+_cTipo+CN9->CN9_NUMERO+CN9->CN9_REVISA,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a entrada de dados do arquivo                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aTELA[0][0],aGETS[0],Continua,nUsado:=0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz a montagem do aHeader com os campos fixos.               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cCampos := "CR_NIVEL/CR_OBS/CR_DATALIB"
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SCR")
While !EOF() .And. (x3_arquivo == "SCR")
	IF AllTrim(x3_campo)$cCampos
		nUsado++
		AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
		If AllTrim(x3_campo) == "CR_NIVEL"
			AADD(aHeader,{ OemToAnsi("Usuario"),"bCR_NOME", "@",;    //
			15, 0, "","","C","",""} )
			nUsado++
			AADD(aHeader,{ OemToAnsi("Situacao"),"bCR_SITUACA", "@",;    //
			20, 0, "","","C","",""} )
			nUsado++
			AADD(aHeader,{ OemToAnsi("Usuario Lib."),"bCR_NOMELIB", "@",;    //
			15, 0, "","","C","",""} )
			nUsado++
		EndIf
	Endif
	dbSkip()
End
dbSelectArea("TMP")
While	!Eof() .And. CR_FILIAL+CR_TIPO+Alltrim(CR_NUM) == xFilial("SCR")+_cTipo+Alltrim(CN9->CN9_NUMERO+CN9->CN9_REVISA)
	aadd(aCols,Array(nUsado +1))
	nAcols ++
	For nCntFor := 1 To nUsado
		If aHeader[nCntFor][02] == "bCR_NOME"
			aCols[nAcols][nCntFor] := UsrFullName(TMP->CR_USER)
		ElseIf aHeader[nCntFor][02] == "bCR_SITUACA"
			Do Case
				Case TMP->CR_STATUS == "01"
					cSituaca   := IIF(lBloq,"Bloqueado","Aguardando Lib")
				Case TMP->CR_STATUS == "02"
					cSituaca := OemToAnsi("Em Aprovacao") //
				Case TMP->CR_STATUS == "03"
					cSituaca := OemToAnsi("Aprovado")  //
				Case TMP->CR_STATUS == "04"
					cSituaca := OemToAnsi("Bloqueado") //
					lBloq := .T.
				Case TMP->CR_STATUS == "05"
					cSituaca := OemToAnsi("Nivel Liberado ") //
			EndCase
			aCols[nAcols][nCntFor] := cSituaca
		ElseIf aHeader[nCntFor][02] == "bCR_NOMELIB"
			aCols[nAcols][nCntFor] := IIF(EMPTY(TMP->CR_USERLIB),"",UsrFullName(TMP->CR_USERLIB))
		ElseIf ( aHeader[nCntFor][10] != "V")
			aCols[nAcols][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
		EndIf
	Next nCntFor
	aCols[nAcols][nUsado+1] := .F.
	dbSkip()
EndDo

If Empty(aCols)
	Aviso("Atencao",OemToAnsi("Este contrato nao possui registros de aprova็ใo."),{"Voltar"})
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	dbSelectArea("CN9")
	Return nOpca
EndIf

Continua := .F.
nOpca := 0
DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
DEFINE MSDIALOG oDlg TITLE OEMTOANSI("Aprova็ใo de contrato") From 109,95 To 400,600 OF oMainWnd PIXEL
@ 15,6 SAY OemToAnsi("Contrato") Of oDlg FONT oBold PIXEL SIZE 46,9 //
@ 14,32 MSGET (CN9->CN9_NUMERO+CN9->CN9_REVISA) Picture "@"  When .F. PIXEL SIZE 80,9 Of oDlg FONT oBold
@ 15,123 SAY OemToAnsi("Usuแrio")  Of oDlg PIXEL SIZE 33,9 FONT oBold //
@ 14,148 MSGET _cUsuario Picture "@" When .F. of oDlg PIXEL SIZE 93,9 FONT oBold
@ 132,8 SAY OemToAnsi("Situa็ใo :") Of oDlg PIXEL SIZE 52,9 //''
@ 132,38 SAY cSituaca Of oDlg PIXEL SIZE 120,9 FONT oBold
@ 132,205 BUTTON "Fechar" SIZE 35 ,10  FONT oDlg:oFont ACTION (oDlg:End()) Of oDlg PIXEL  //''
oGet := MSGetDados():New(38,3,120,250,1,,,"XXX")
@ 126,2   TO 127,250 LABEL '' OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

dbSelectArea("TMP")
dbCloseArea("TMP")

dbSelectArea("SCP")
Return nOpca

