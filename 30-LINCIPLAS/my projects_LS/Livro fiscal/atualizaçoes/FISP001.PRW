#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFISP001  บAutor  ณ Antonio Carlos     บ Data ณ  11/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao dos registros do Livro Fiscal (SF3) referente   บฑฑ
ฑฑบ          ณ as Filias/Coligadas que possuem mesmo CNPJ.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FISP001()
///////////////////////
Local cCadastro	:= "Importa Livro Fiscal"

Private _cFilOr	:= Space(2)
Private _cFilDe	:= Space(2)

Private _dData1	:= CTOD("  /  /  ")
Private _dData2	:= CTOD("  /  /  ")

DEFINE MSDIALOG oDlg FROM 000,000 TO 300,400 TITLE cCadastro PIXEL
@ 05,05 TO 140,200 PIXEL

@ 010,010 SAY "Esta rotina tem o objetivo de importar os registros referente ao Livro Fiscal"	PIXEL OF oDlg
@ 020,010 SAY "das Filias/Coligadas que possuem o mesmo CNPJ." 									PIXEL OF oDlg

@ 040,050 SAY "Filial Origem : " PIXEL OF oDlg
@ 040,090 MSGET oFilOr VAR _cFilOr SIZE 15,10 PIXEL OF oDlg  Picture '@!'

@ 060,050 SAY "Filial Destino: " PIXEL OF oDlg
@ 060,090 MSGET oFilDe VAR _cFilDe SIZE 15,10 PIXEL OF oDlg Picture '@!'

@ 080,050 SAY "Data de : " PIXEL OF oDlg
@ 080,090 MSGET oData1 VAR _dData1 SIZE 60,10 PIXEL OF oDlg

@ 100,050 SAY "Data ate: " PIXEL OF oDlg
@ 100,090 MSGET oData2 VAR _dData2 SIZE 60,10 PIXEL OF oDlg

@ 120,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION (Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Processando registros.", .T. ) )
@ 120,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc(lEnd)
/////////////////////////////

Local 	nTotRec		:= 0
Local   cCgcOr      := Posicione("SM0", 1, '01'+_cFilOr, "M0_CGC")
Local   cCgcDe      := Posicione("SM0", 1, '01'+_cFilDe, "M0_CGC")

If Empty(_cFilOr) .Or. Empty(_cFilDe) .Or. Empty(_dData1) .Or. Empty(_dData2)
	
	MsgStop("Preencha os campos corretamente!")
	Return(.F.)
	
ElseIf Alltrim(cCgcOr) <> Alltrim(cCgcDe)
	
	MsgStop("As filiais devem possuir o mesmo CNPJ!")
	Return(.F.)

ElseIf _cFilDe == _cFilOr
	
	MsgStop("As filiais devem ser diferentes!")
	Return(.F.)
EndIf

_cQuery := "SELECT 'DELETE FROM " + RetSqlName('SF3') + " WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,SF3D.R_E_C_N_O_) CAMPO"
_cQuery += _cEnter + "FROM " + RetSqlName('SF3') + " SF3O(NOLOCK)"
_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SF3') + " SF3D (NOLOCK)"
_cQuery += _cEnter + "ON SF3D.F3_FILIAL = '" + _cFilDe + "'"
_cQuery += _cEnter + "AND SF3D.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND SF3D.F3_SERIE = SF3O.F3_SERIE "
_cQuery += _cEnter + "AND SF3D.F3_CLIEFOR = SF3O.F3_CLIEFOR"
_cQuery += _cEnter + "AND SF3D.F3_LOJA = SF3O.F3_LOJA"
_cQuery += _cEnter + "AND SF3D.F3_NFISCAL = SF3O.F3_NFISCAL"
_cQuery += _cEnter + "WHERE SF3O.F3_FILIAL = '" + _cFilOr + "'"
_cQuery += _cEnter + "AND SF3O.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND SF3O.F3_ENTRADA BETWEEN '" + dtos(_dData1) + "' AND '" + dtos(_dData2) + "'"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SF3', .F., .T.)

Count To nTotRec
ProcRegua(nTotRec)
DbGoTop()
Do While !eof()
	IncProc("Apagando Livros (SF3) na filial " + _cFilDe)
	TcSqlExec(_SF3->CAMPO)
	DbSkip()
EndDo

DbCloseArea()

_cQuery := "SELECT 'DELETE FROM " + RetSqlName('SFT') + " WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,SFTD.R_E_C_N_O_) CAMPO"
_cQuery += _cEnter + "FROM " + RetSqlName('SFT') + " SFTO(NOLOCK)"
_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SFT') + " SFTD (NOLOCK)"
_cQuery += _cEnter + "ON SFTD.FT_FILIAL = '" + _cFilDe + "'"
_cQuery += _cEnter + "AND SFTD.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND SFTD.FT_TIPOMOV = SFTO.FT_TIPOMOV
_cQuery += _cEnter + "AND SFTD.FT_SERIE = SFTO.FT_SERIE "
_cQuery += _cEnter + "AND SFTD.FT_CLIEFOR = SFTO.FT_CLIEFOR"
_cQuery += _cEnter + "AND SFTD.FT_LOJA = SFTO.FT_LOJA"
_cQuery += _cEnter + "AND SFTD.FT_NFISCAL = SFTO.FT_NFISCAL"
_cQuery += _cEnter + "WHERE SFTO.FT_FILIAL = '" + _cFilOr + "'"
_cQuery += _cEnter + "AND SFTO.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND SFTO.FT_ENTRADA BETWEEN '" + dtos(_dData1) + "' AND '" + dtos(_dData2) + "'"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SFT', .F., .T.)

Count To nTotRec
ProcRegua(nTotRec)
DbGoTop()
Do While !eof()
	IncProc("Apagando Livros (SFT) na filial " + _cFilDe)
	TcSqlExec(_SFT->CAMPO)
	DbSkip()
EndDo

DbCloseArea()

_cQuery := "SELECT *"
_cQuery += _cEnter + "FROM " + RetSqlName('SF3') + " (NOLOCK)"
_cQuery += _cEnter + "WHERE F3_FILIAL = '" + _cFilOr + "'"
_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND F3_ENTRADA BETWEEN '" + dtos(_dData1) + "' AND '" + dtos(_dData2) + "'"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMPA', .F., .T.)

DbSelectArea('SX3')
DbSetOrder(1)
DbSeek('SF3')
Do While SX3->X3_ARQUIVO == 'SF3' .and. !eof()
	If SX3->X3_TIPO == 'D' .and. SX3->X3_CONTEXT <> 'V'
		TcSetField("TMPA",SX3->X3_CAMPO,'D',8,0)       
	EndIf
	DbSkip()
EndDo

DbSelectArea('TMPA')
Count To nTotRec
ProcRegua(nTotRec)
DbGoTop()

Do While TMPA->( !Eof() )
	
	IncProc("Inserindo Livros (SF3) na filial -" + _cFilDe)
	
	RecLock("SF3",.T.)
	
	For _nI := 1 To FCount()
		If FieldName(_nI) == 'F3_FILIAL'
			SF3->F3_FILIAL := _cFilDe
		Else			
			_cCampoD := 'SF3->' + FieldName(_nI)
			_cCampoO := 'TMPA->' + FieldName(_nI)
			&_cCampoD := &_cCampoO
		EndIf
	Next 
	SF3->F3_REPROC := 'N'

	SF3->( MsUnLock() )
		
	DbSelectArea('TMPA')
	TMPA->( DbSkip() )
	
EndDo
DbCloseArea()
                
_cQuery := "SELECT *"
_cQuery += _cEnter + "FROM " + RetSqlName('SFT') + " (NOLOCK)"
_cQuery += _cEnter + "WHERE FT_FILIAL = '" + _cFilOr + "'"
_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND FT_ENTRADA BETWEEN '" + dtos(_dData1) + "' AND '" + dtos(_dData2) + "'"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMPA', .F., .T.)

DbSelectArea('SX3')
DbSeek('SFT')
Do While SX3->X3_ARQUIVO == 'SFT' .and. !eof()
	If SX3->X3_TIPO == 'D' .and. SX3->X3_CONTEXT <> 'V'
		TcSetField("TMPA",SX3->X3_CAMPO,'D',8,0)       
	EndIf
	DbSkip()
EndDo

DbSelectArea('TMPA')
Count To nTotRec
ProcRegua(nTotRec)
DbGoTop()

Do While TMPA->( !Eof() )
	
	IncProc("Inserindo Livros (SFT) na filial " + _cFilDe)
	
	RecLock("SFT",.T.)
	
	For _nI := 1 To FCount()
		If FieldName(_nI) == 'FT_FILIAL'
			SFT->FT_FILIAL := _cFilDe
		Else
			_cCampoD := 'SFT->' + FieldName(_nI)
			_cCampoO := 'TMPA->' + FieldName(_nI)
			&_cCampoD := &_cCampoO
		EndIf
	Next 

	SFT->( MsUnLock() )
		
	DbSelectArea('TMPA')
	TMPA->( DbSkip() )
	
EndDo

MsgInfo("Processamento realizado com sucesso!")

DbCloseArea()

Return Nil
