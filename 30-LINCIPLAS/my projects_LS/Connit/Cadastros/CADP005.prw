#Include "rwmake.CH"
#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADP005ºAutor  ³Antonio Carlos         º Data ³  18/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsavel pela inclusão dos itens da tabela SBZ    º±±
±±º          ³(Reparte) na inclusao/alteração do Produto.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LASELVA COMERCIO DE LIVROS E ARTIGOS DE CONVENINENCIA LTDA º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	01/10/2012 - alexandre - rotina SB1LIBERA: contempla campos BZ_PERFIL e B1_MSBLQL -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CADP005(cCodigo,cDescr,cLocal,dEncalh,cGrup,cPrc1,cPrc2,cEdica,cMsblql,cOrigem)
/////////////////////////////////////////////////////////////////////////////////////////////


LjMsgRun("Aguarde... Gerando Reparte...",, {|| GravaSBZ(cCodigo,cDescr,cLocal,dEncalh,cGrup,cPrc1,cPrc2,cEdica,cMsblql,cOrigem) })

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaSBZ(cCodigo,cDescr,cLocal,dEncalh,cGrup,cPrc1,cPrc2,cEdica,cMsblql,cOrigem)
////////////////////////////////////////////////////////////////////////////////////////////////

Local aArea			:= GetArea()
Local _aItemSBZ		:= {}

Local	aFilial		:= {}
Local	cStrFilia	:= ""
Local	cStrFil		:= ""
Local   cTe 		:= ''
Local 	cTs 		:= ''
Local 	cTeC 		:= ''
Local 	cTsC 		:= ''
Local 	cTeF 		:= ''
Local 	cTsF 		:= ''
Local 	lOk			:= .F.
Local _dULMES := GetMv("MV_ULMES")
lOCAL _Ddata:=(DATE() - 30)

IF _dULMES >= _Ddata
_dULMES := _Ddata
endif

If lCopia
	
	If Select('QRY') > 0
		DbSelectArea('QRY')
		DbCloseArea()
	EndIf
	
	cQry := " SELECT BZ_FILIAL, BZ_COD, BZ_LOCPAD, BZ_TE, BZ_TS, BZ_TEC, BZ_TSC, BZ_TE_FORN, BZ_TS_FORN, BZ_EMIN, BZ_EMAX, BZ_DESC, BZ_UPRC, BZ_PERFIL, BZ_PRV1"
	cQry += " FROM "+RetSqlName("SBZ")+" SBZ WITH (NOLOCK) "
	cQry += " WHERE BZ_COD 		= '" + SB1->B1_COD + "' AND "
	cQry += " SBZ.D_E_L_E_T_ 	= '' "
	cQry += " ORDER BY BZ_FILIAL "
	
	TcQuery cQry NEW ALIAS "QRY"
	
	Do While !Eof()
		Aadd(_aItemSBZ,{QRY->BZ_FILIAL, cCodigo, IIF(EMPTY(QRY->BZ_LOCPAD),SB1->B1_LOCPAD,QRY->BZ_LOCPAD), QRY->BZ_TE, QRY->BZ_TS, QRY->BZ_TEC, QRY->BZ_TSC, QRY->BZ_TE_FORN, QRY->BZ_TS_FORN, QRY->BZ_EMIN, QRY->BZ_EMAX, cDescr, QRY->BZ_PRV1, QRY->BZ_UPRC, QRY->BZ_PERFIL, cOrigem})
		DbSkip()
	EndDo
	DbCloseArea()
ELSE // Thiago Queiroz - Deve criar automaticamente os registros na tabela SBZ // THIAGO SBZ
	//CADP014( _cCodigo, cGrup, cBloq )
	U_CADP014(SB1->B1_COD, SB1->B1_GRUPO, SB1->B1_MSBLQL)
EndIf

ChkFile("SM0")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona filiais.   					       		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_lGeraRepart := .f.

If SB1->B1_MSBLQL == '1'
	If !IsInCallStack('U_SB1LIBERA')
		_lGeraRepart := MsgBox('Produto bloqueado. Gerar reparte?','ATENÇÃO!!!','YESNO')
	Else
		_lGeraRepart := .T.
	EndIf
Else
	_lGeraRepart := .T.
EndIf

_cQuery := "SELECT *"
_cQuery += _cEnter + " FROM SIGA.dbo.sigamat_copia "
_cQuery += _cEnter + " WHERE ativo_pdv = 1"
_cQuery += _cEnter + " ORDER BY M0_CODFIL"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SM0', .F., .T.)

Do While !Eof()
	
	nPos := aScan(_aItemSBZ,{|x| x[1] == _SM0->M0_CODFIL })
	
	If nPos > 0
		
		If !SBZ->(DbSeek(_aItemSBZ[nPos,1] + _aItemSBZ[nPos,2],.f.))
			RecLock("SBZ",.T.)
			SBZ->BZ_FILIAL		:= _aItemSBZ[nPos,1]
			SBZ->BZ_COD 		:= _aItemSBZ[nPos,2]
			SBZ->BZ_LOCPAD		:= _aItemSBZ[nPos,3]
			SBZ->BZ_TE			:= _aItemSBZ[nPos,4]
			SBZ->BZ_TS			:= _aItemSBZ[nPos,5]
			SBZ->BZ_TEC			:= _aItemSBZ[nPos,6]
			SBZ->BZ_TSC			:= _aItemSBZ[nPos,7]
			SBZ->BZ_TE_FORN		:= _aItemSBZ[nPos,8]
			SBZ->BZ_TS_FORN		:= _aItemSBZ[nPos,9]
			SBZ->BZ_EMIN		:= _aItemSBZ[nPos,10]
			SBZ->BZ_EMAX		:= _aItemSBZ[nPos,11]
			SBZ->BZ_DESC		:= _aItemSBZ[nPos,12]
			SBZ->BZ_PRV1		:= _aItemSBZ[nPos,13]
			SBZ->BZ_UPRC		:= _aItemSBZ[nPos,14]
			SBZ->BZ_PERFIL		:= _aItemSBZ[nPos,15]
			SBZ->BZ_ORIGEM		:= _aItemSBZ[nPos,16]
			SBZ->( MsUnLock() )
		EndIf
		
	Else
		_lNovo := SBZ->(DbSeek(_SM0->M0_CODFIL + cCodigo,.f.))
		If RecLock("SBZ",!_lNovo) .and. _lGeraRepart
			SBZ->BZ_FILIAL	:= _SM0->M0_CODFIL
			SBZ->BZ_COD		:= cCodigo
			SBZ->BZ_DESC	:= cDescr
			SBZ->BZ_LOCPAD	:= cLocal
			If !_lNovo
				SBZ->BZ_PRV1	:= cPrc1
			EndIf
			
			If _SM0->M0_CODFIL $ "01/55"
				_cTipEmp := "M"
			ElseIf Substr(_SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ")
				_cTipEmp := "F"
			Else
				_cTipEmp := "C"
			EndIf
			
			DbSelectArea("SZQ")
			SZQ->( DbSetOrder(1) )
			If SZQ->( DbSeek(cGrup+_cTipEmp) )
				
				If 	_cTipEmp == "M"
					
					cTe  := SZQ->ZQ_TE
					cTs  := SZQ->ZQ_TS
					
					cTeC := SZQ->ZQ_TEC
					cTsC := SZQ->ZQ_TSC
					
					cTeF := SZQ->ZQ_TE_FORN
					cTsF := SZQ->ZQ_TS_FORN
					
				ElseIf _cTipEmp == "F"
					
					cTe  := SZQ->ZQ_TE
					cTs  := SZQ->ZQ_TS
					
					cTeF := SZQ->ZQ_TE_FORN
					cTsF := SZQ->ZQ_TS_FORN
					
				Else
					
					cTeC := SZQ->ZQ_TEC
					cTsC := SZQ->ZQ_TSC
					
					cTeF := SZQ->ZQ_TE_FORN
					cTsF := SZQ->ZQ_TS_FORN
					
				EndIf
				
			Else
				cTe := "002"
//				cTs := "611"
				cTs := "706"
			EndIf
			
			/*
			########################################
			#                                        #
			#    Grava os TES na tabela SBZ          #
			#                                        #
			########################################*/
			
			If _cTipEmp == "M"
				
				SBZ->BZ_TE := cTe
				SBZ->BZ_TS := cTs
				
				SBZ->BZ_TEC := cTeC
				SBZ->BZ_TSC := cTsC
				
				SBZ->BZ_TE_FORN := cTeF
				SBZ->BZ_TS_FORN := cTsF
				
				lOk := .T.
				
			ElseIf _cTipEmp = "F"
				
				SBZ->BZ_TE := cTe
				SBZ->BZ_TS := cTs
				
				SBZ->BZ_TE_FORN := cTeF
				SBZ->BZ_TS_FORN := cTsF
				
				lOk := .T.
				
			Else
				
				SBZ->BZ_TE 	:= cTeC
				SBZ->BZ_TS 	:= cTsC
				
				SBZ->BZ_TE_FORN := cTeF
				SBZ->BZ_TS_FORN := cTsF
				
				lOk := .T.
				
			EndIf
			
			SBZ->( MsUnlock() )
		EndIf
		
	EndIf
	
	If !cGrup $ "0015/0100"				// Alterado 0010 para 0015 - Solicitacao Helio - 20/05/14 - Richard
		
		If !SB2->(DbSeek(_SM0->M0_CODFIL + cCodigo,.f.))
			RecLock("SB2",.T.)
			SB2->B2_FILIAL	:= _SM0->M0_CODFIL
			SB2->B2_COD		:= cCodigo
			SB2->B2_LOCAL	:= "01"
			SB2->( MsUnlock() )
		EndIf

                /// Modificado em 23/03/15

		If !SB9->(DbSeek(_SM0->M0_CODFIL + cCodigo,.f.))				// Incluida a criação do SB9 - Solicitacao Helio - 20/05/14 - Richard
			RecLock("SB9",.T.)
			SB9->B9_FILIAL	:= _SM0->M0_CODFIL
			SB9->B9_COD		:= cCodigo
			SB9->B9_LOCAL	:= "01"
			SB9->B9_DATA	:=  _dULMES   //SB1->B1_DTCAD//M->B1_DTCAD   //CtoD("31/12/1999")
			SB9->( MsUnlock() )
		EndIf
		
	EndIf
	
	DbSelectArea('_SM0')
	DbSkip()
	
EndDo
DbCloseArea()

If lOk
	If !IsInCallStack('U_SB1LIBERA')
		MSGInfo("O reparte foi gerado com sucesso!")
	EndIf
Else
	If !IsInCallStack('U_SB1LIBERA')
		MSGInfo("Este produto já possui reparte ou está bloqueado!" )
	EndIf
Endif

RestArea(aArea)

Return Nil

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function SB1libera()
/////////////////////////

_lOk := .f.
_cTe := '   '
_cTs := '   '
_cGt := '      '
_cGN := '          '
_cProd := 'Copie do Excel e cole neste espaço, uma planilha com as seguintes colunas:' + _cEnter + _cEnter
_cProd += 'Filial	Produto		Est Máx		Est Min		Perfil		Bloquear (B)' + _cEnter + _cEnter
_cProd += 'ONDE: ' + _cEnter + _cEnter
_cProd += 'Filial = código da filial específica ou ** para todas as filiais' + _cEnter
_cProd += 'Produto = códido do produto' + _cEnter
_cProd += 'Est Máx e Est Mín: repartes máximo e mínimo (0 e 0 para zerar ou ** e ** para não alterar)' + _cEnter
_cProd += 'Perfil = código do perfil (## para limpar ou ** para não alterar)' + _cEnter
_cProd += 'Bloquear = B p/ bloquear produto (diferente de B, não faz nada )' + _cEnter + _cEnter
_cProd += 'APAGAR ESTE TEXTO EXPLICATIVO'

_lAltera := .f.
DEFINE MSDIALOG oDlg TITLE 'Liberação/Gera Reparte por aquivo' FROM 000,000 TO 500,650 OF oMainWnd PIXEL

@ 020,008 Say "Tipo de entrada padrão:" 	Size 051,008 PIXEL OF oDlg
@ 020,070 MsGet oTe     Var _cTe   		  	Size 020,009 PIXEL OF oDlg F3 'SF4' Valid empty(_cTe) .or. (_cTe < '500' .and. ExistCpo('SF4',_cTe)) when __cUserId $ GetMv('LS_GFISCAL') + '/' + GetMv('LA_PODER')
@ 035,008 Say "Tipo de saída padrão:" 		Size 051,008 PIXEL OF oDlg
@ 035,070 MsGet oTs  	Var _cTs  			Size 020,009 PIXEL OF oDlg F3 'SF4' Valid empty(_cTs) .or. (_cTs > '500' .and. ExistCpo('SF4',_cTs)) when __cUserId $ GetMv('LS_GFISCAL') + '/' + GetMv('LA_PODER')
@ 050,008 Say "Grupo de Tributação:"  		Size 051,008 PIXEL OF oDlg
@ 050,070 MsGet oGt  	Var _cGt  			Size 030,009 PIXEL OF oDlg F3 '21' Valid empty(_cGt) .or. ExistCpo('SX5','21'+_cGt) when __cUserId $ GetMv('LS_GFISCAL') + '/' + GetMv('LA_PODER')
@ 065,008 Say "Código NCM:"           		Size 051,008 PIXEL OF oDlg
@ 065,070 MsGet oGN  	Var _cGN  			Size 050,009 PIXEL OF oDlg F3 'SYD' Valid empty(_cGN) .or. ExistCpo('SYD',_cGN) when __cUserId $ GetMv('LS_GFISCAL') + '/' + GetMv('LA_PODER')
@ 080,008 Get oProd 	Var _cProd MEMO		Size 300,120 PIXEL OF oDlg

@ 208,005 Say 'Reparte zerado: somente códigos separados por ";"' 			Size 151,008 PIXEL OF oDlg
@ 208,200 Button "&Gerar Reparte" 											Size 080,012 PIXEL OF oDlg ACTION(_lOk := .t., oDlg:End())
@ 220,005 Say 'Reparte específico: Filial;Produto;Est Máx;Est Min;Perfil;Bloquear(B)?"' 		Size 250,008 PIXEL OF oDlg
@ 220,200 Button "&Altera Reparte"											Size 080,012 PIXEL OF oDlg ACTION(_lOk := .t., _lAltera := .t., oDlg:End())
@ 232,200 Button "&Cancela"													Size 080,012 PIXEL OF oDlg ACTION(_lOk := .f., oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !_lOk
	Return()
EndIf

_cProd := strtran(alltrim(_cProd),chr(9),';')
If !_lAltera
	_cProd := strtran(alltrim(_cProd),chr(10),'')
	_cProd := strtran(_cProd,chr(13),';')
EndIf
_cProd := strtran(_cProd,',',';')
_cProd := strtran(_cProd,'.',';')
_cProd := strtran(_cProd,' ',';')
_cProd := strtran(_cProd,'/',';')
_cProd := strtran(_cProd,':',';')
_cProd := strtran(_cProd,'-',';')

Do While at(';;',_cProd) > 0
	_cProd := strtran(_cProd,';;',';')
EndDo
_aProds := {}
_cErros := 'Produto não cadastrado: ' + _cEnter + _cEnter

If !_lAltera
	
	Do While len(alltrim(_cProd)) > 0
		_nPosic := at(';',_cProd)
		If _nPosic == 0
			aAdd(_aProds,substr(_cProd,1))
		Else
			If !DbSeek(xFilial('SB1') + alltrim(substr(_cProd,1,_nPosic-1)),.f.)
				_cErros += substr(_cProd,1,_nPosic-1) + _cEnter
			Else
				aAdd(_aProds,alltrim(substr(_cProd,1,_nPosic-1)))
			EndIf
			_cProd := substr(alltrim(_cProd),_nPosic+1)
		EndIf
	EndDo
	
Else
	
	Do While len(alltrim(_cProd)) > 0
		_nPosic1 := at(chr(13),_cProd)
		_nPosic1 := iif(_nPosic1 == 0, len(alltrim(_cProd))+1,_nPosic1)
		If _nPosic1 == 0
			_cReparte := alltrim(substr(_cProd,1))
		Else
			_cReparte := alltrim(substr(_cProd,1,_nPosic1-1))
			_aReparte := {}
			Do While len(_cReparte) > 0
				_nPosic2 := at(';',_cReparte)
				If _nPosic2 == 0
					aAdd(_aReparte,substr(_cReparte,1))
					exit
				Else
					aAdd(_aReparte,substr(_cReparte,1,_nPosic2-1))
				EndIf
				_cReparte := substr(alltrim(_cReparte),_nPosic2+1)
			EndDo
		EndIf
		
		If !DbSeek(xFilial('SB1') + alltrim(_aReparte[2]),.f.)
			If at(_aReparte[2],_cErros) == 0
				_cErros += 'Filial - ' + _aReparte[1] + ' - Produto: ' + _aReparte[2] + _cEnter
			EndIf
		Else
			aAdd(_aProds,aClone(_aReparte))
		EndIf
		
		_cProd := iif(_nPosic1 == 0,'',alltrim(substr(alltrim(_cProd),_nPosic1+1)))
		_cProd := strtran(alltrim(_cProd),chr(10),'')
	EndDo
	
EndIf

lcopia := .f.
Processa({||RunProc()})

If !empty(_cErros)
	Aviso('Repartes automático',_cErros,{'OK'},3,'Erros de liberações')
EndIf
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////
ProcRegua(len(_aProds))
_cErros += _cEnter + 'Reparte não cadastrado:' + _cEnter + _cEnter
If _lAltera
	
	For _nI := 1 to len(_aProds)
		If alltrim(_aProds[_nI,1]) <> '**' .and. !SBZ->(DbSeek(alltrim(_aProds[_nI,1]) + alltrim(_aProds[_nI,2]),.f.))
			SB1->(DbSeek(xFilial('SB1') + alltrim(_aProds[_nI,2]),.f.))
			U_cadp005(SB1->B1_COD, SB1->B1_DESC,SB1->B1_LOCPAD,,SB1->B1_GRUPO)
		EndIf
		If alltrim(_aProds[_nI,1]) <> '**' .and. !SBZ->(DbSeek(alltrim(_aProds[_nI,1]) + alltrim(_aProds[_nI,2]),.f.))
			_cErros += 'Filial - ' + alltrim(_aProds[_nI,1]) + ' Produto: ' + alltrim(_aProds[_nI,2])
		Else
			_cQuery := "UPDATE " + RetSqlName('SBZ')
			_cQuery += _cEnter + " SET "
			If _aProds[_nI,4] <> '**' .and. _aProds[_nI,3] <> '**'
				_cQuery += _cEnter + " BZ_EMIN = " + alltrim(str(min(val(_aProds[_nI,4]), val(_aProds[_nI,3])))) + ", "
				_cQuery += _cEnter + " BZ_EMAX = " + alltrim(str(max(val(_aProds[_nI,4]), val(_aProds[_nI,3]))))
			EndIf
			If _aProds[_nI,5] <> '**'
				If _aProds[_nI,4] <> '**' .and. _aProds[_nI,3] <> '**'
					_cQuery += _cEnter + ", "
				EndIf
				_cQuery += _cEnter + "BZ_PERFIL = '" + iif(alltrim(_aProds[_nI,5]) == '##','',alltrim(_aProds[_nI,5])) + "'"
			EndIf
			_cQuery += _cEnter + " WHERE BZ_COD = '" + alltrim(_aProds[_nI,2]) + "'"
			If alltrim(_aProds[_nI,1]) <> '**'
				_cQuery += _cEnter + " AND BZ_FILIAL = '" + alltrim(_aProds[_nI,1]) + "'"
			EndIf
			TcSqlExec(_cQuery)
			
			If len(_aProds[_nI]) >= 6 .and. upper(_aProds[_nI,6]) $ 'B'
				_cQuery := "UPDATE " + RetSqlName('SB1')
				_cQuery += _cEnter + " SET B1_MSBLQL = '1'"
				_cQuery += _cEnter + " WHERE B1_COD = '" + alltrim(_aProds[_nI,2]) + "'"
				TcSqlExec(_cQuery)
			EndIf
			
		EndIf
	Next
	
Else
	For _nI := 1 to len(_aProds)
		IncProc()
		DbSelectArea('SB1')
		If DbSeek(xFilial('SB1') + alltrim(_aProds[_nI]),.f.) .and. SB1->B1_MSBLQL == '1'
			RecLock('SB1',.f.)
			If !empty(_cTe)
				SB1->B1_TE     := _cTe
			EndIf
			If !empty(_cTs)
				SB1->B1_TS     := _cTs
			EndIf
			If !empty(_cGt)
				SB1->B1_GRTRIB := _cGt
			EndIf
			If !empty(_cGN)
				SB1->B1_POSIPI := _cGN
			EndIf
			If !empty(SB1->B1_TE) .and. !empty(SB1->B1_TS) .and. !empty(SB1->B1_GRTRIB) .and. !empty(SB1->B1_POSIPI)
				SB1->B1_MSBLQL := '2'
			Else
				_cErros += alltrim(SB1->B1_COD) + ' (NÃO LIBERADO: B1_TE = ' + SB1->B1_TE + ', B1_TS = ' + SB1->B1_TS + ', B1_GRTRIB = ' + SB1->B1_GRTRIB + ', B1_GRTRIB = ' + SB1->B1_GRTRIB + ');' + _cEnter
			EndIf
			MsUnLock()
			
			If SM0->M0_CODFIL $ "01/55"
				_cTipEmp := "M"
			ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ")
				_cTipEmp := "F"
			Else
				_cTipEmp := "C"
			EndIf
			U_cadp005(SB1->B1_COD, SB1->B1_DESC,SB1->B1_LOCPAD,,SB1->B1_GRUPO)
		EndIf
	Next
EndIf
Return()
