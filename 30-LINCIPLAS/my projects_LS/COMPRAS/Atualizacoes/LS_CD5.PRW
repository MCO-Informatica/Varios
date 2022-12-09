#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PROGRAMA CUSTOMIZADO CRIADO PARA PREENCHER CAMPOS CUSTOMIZADOS QUE SÃO UTILIZADOS PARA PREENCHER CAMPOS PADRÕES NO DOCUMENTO DE ENTRADA
// CUSTOMIZAÇÃO SÓ NÃO FOI CANCELADA PARA NÃO TER QUE CRIAR UMA OUTRA CUSTOMIZAÇÃO QUE GRAVARIA APENAS O CAMPO MEMO COM AS INFORMAÇÕES ADICIONAIS
// POIS TODOS OS CAMPOS, COM EXCEÇÃO DO "B/L - " + CD5->CD5_LOCALI, CONSTA NO DOCUMENTO DE ENTRADA
// THIAGO QUEIROZ - SUPERTECH - 13/01/2016
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CD5()
//////////////////////

Private cString := 'CD5'

dbSelectArea('CD5')
dbSetOrder(1)

AxCadastro(cString,"Complemento de Importações",'.t.','.t.') //VldAlt(inclui,altera),VldExc(exclui))

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function TudoOK()
////////////////////////

MSGAlert("OK");

Return .F.

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// chamada pelo botão na tela de visualização da NFE (mt103but)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_103CD5(_xEdita)
///////////////////////////////
Local _aArea 	:= GetArea()
Local _nOpca 	:= 0
Local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})

DbSelectArea('CD5')
DbSetOrder(1)
If DbSeek(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA,.F.)
	altera := .t.
	inclui := .f.
	RegToMemory('CD5',.T.)
	If _xEdita == 'A'
		_nOpca := AxAltera('CD5',CD5->(Recno()),4)
	Else
		AxVisual('CD5',CD5->(Recno()),4)
	EndIf
ElseIf _xEdita == 'A'
	altera := .f.
	inclui := .t.
	
	RegToMemory('CD5',.T.)
	_nOpca := AxInclui('CD5',CD5->(Recno()),3)
	
Else
	MsgBox('Nota Fiscal já enviada a SEFAZ. Não pode ser alterada.','ATENÇÃO!!!','ALERT')
EndIf

If _nOpca == 1
	DbSetOrder(4)
	_cTpImp  := CD5->CD5_TPIMP
	_cDocImp := CD5->CD5_DOCIMP
	_cAcDraw := CD5->CD5_ACDRAW
	_cNDI    := CD5->CD5_NDI
	_dDtDI   := CD5->CD5_DTDI
	_cLocDes := CD5->CD5_LOCDES
	_cUFDes  := CD5->CD5_UFDES
	_dDtDes  := CD5->CD5_DTDES
	_cCodExp := CD5->CD5_CODEXP
	_cLojExp := CD5->CD5_LOJEXP
	_cSqAdic := CD5->CD5_SQADIC
	_cCodFab := CD5->CD5_CODFAB
	_cLojFab := CD5->CD5_LOJFAB  
	_nPLiqdo := CD5->CD5_PLIQDO
	_nPBruto := CD5->CD5_PBRUTO
	_cLocali := CD5->CD5_LOCALI
	_cLocal  := CD5->CD5_LOCAL
	_cTransp := CD5->CD5_TRANSP
	_nVolume := CD5->CD5_VOLUME
	_cEspeci := CD5->CD5_ESPECI        
	_cEspec  := CD5->CD5_ESPEC
	_cNADIC  := CD5->CD5_NADIC
	//_nI := 1
	For _nI := 1 to len(aCols)
		_cSqAdic := Soma1(_cSqAdic)
		DbSelectArea('CD5')
		DbSetOrder(4)
		RecLock('CD5',!DbSeek(xFilial('CD5') + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA+aCols[_nI][nPosItem],.f.))
		CD5->CD5_FILIAL  := SF1->F1_FILIAL
		CD5->CD5_DOC     := SF1->F1_DOC
		CD5->CD5_SERIE   := SF1->F1_SERIE
		CD5->CD5_FORNECE := SF1->F1_FORNECE
		CD5->CD5_LOJA    := SF1->F1_LOJA
		CD5->CD5_ITEM    := aCols[_nI][nPosItem] //strzero(_nI,4)
		CD5->CD5_TPIMP   := _cTpImp
		CD5->CD5_DOCIMP  := _cDocImp
		CD5->CD5_ACDRAW  := _cAcDraw
		CD5->CD5_NDI     := _cNDI
		CD5->CD5_DTDI    := _dDtDI
		CD5->CD5_LOCDES  := _cLocDes
		CD5->CD5_UFDES   := _cUFDes
		CD5->CD5_DTDES   := _dDtDes
		CD5->CD5_CODEXP  := _cCodExp
		CD5->CD5_LOJEXP  := _cLojExp
		CD5->CD5_SQADIC  := _cSqAdic
		CD5->CD5_CODFAB  := _cCodFab
		CD5->CD5_LOJFAB  := _cLojFab
		CD5->CD5_PLIQDO  := _nPLiqdo
		CD5->CD5_PBRUTO  := _nPBruto
		CD5->CD5_LOCALI  := _cLocali
		CD5->CD5_LOCAL   := _cLocal
		CD5->CD5_TRANSP  := _cTransp
		CD5->CD5_VOLUME  := _nVolume
		CD5->CD5_ESPECI  := _cEspeci
		CD5->CD5_ESPEC   := _cEspec
		CD5->CD5_NADIC   := _cNADIC  
		MsUnLock()
	Next   
	DbSetOrder(1)

	_cMemo := "DI  - " + CD5->CD5_DOCIMP + _cEnter
	_cMemo += "B/L - " + CD5->CD5_LOCALI + _cEnter
	_cMemo += "LOCAL DES.: - " + CD5->CD5_LOCDES + _cEnter
	_cMemo += "PESO LIQ - " + alltrim(tran(CD5->CD5_PBRUTO,'@E 999,999.99')) + _cEnter
	_cMemo += "PESO BRUTO - " + alltrim(tran(CD5->CD5_PLIQDO ,'@E 999,999.99'))
	
	RecLock('SF1',.f.)
	SF1->F1_TRANSP  := CD5->CD5_TRANSP
	SF1->F1_VOLUME1 := CD5->CD5_VOLUME
	SF1->F1_ESPECI1 := CD5->CD5_ESPECI
	SF1->F1_PBRUTO  := CD5->CD5_PBRUTO
	SF1->F1_PESOL   := CD5->CD5_PLIQDO
	SF1->F1_PLIQUI  := CD5->CD5_PLIQDO
	SF1->F1_DADOSAD := upper(alltrim(_cMemo))
	If SF1->(FieldPos("F1_MENPAD"))>0
		SF1->F1_MENPAD := iif(empty(_cMemo),'','SF1')
	Else
		SF1->F1_CPROVA := iif(empty(_cMemo),'','SF1')
	EndIf
	MsUnLock()
EndIf
RestArea(_aArea)

Return()
