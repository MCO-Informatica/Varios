#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"
#DEFINE _cEnter Chr(13)+Chr(10)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_PC_XML()
///////////////////////
Conout("*** La Selva - User Function LS_PC_XML - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

/*
Processa({||CBSMAIL()})
*/
_cPerg  	:= "LS_PC_XML "
ValidPerg()
_lRet 		:= .t.
lAuto		:= .F. // VARIAVEL QUE IRA DEFINIR SE O PROCESSO É AUTOMATICO (.T.) OU MANUAL (.F.)
Do While _lRet
	_lRet := Pergunte(_cPerg, .t.)
	If !_lRet
		Return()
	EndIf

	mv_par04   := alltrim(mv_par04)
	_cError    := ""
	_cWarning  := ""
	_cCadastro := ""
	_oXml 	   := NIL
	_aXMLs	   := Directory(mv_par04 + '\Recebidos\*.XML')
	aSort(_aXMLs,,,{|x,y| x[1] < y[1]})
	
	If empty(mv_par06)
		MsgBox('Favor informar email','Atenção!!!','Alert')
	ElseIf !empty(mv_par01) .and. mv_par01 < '5'
		MsgBox('Favor informar um CFOP válido para importar','Atenção!!!','Alert')
	ElseIf empty(mv_par02) .and. mv_par05 <> 4
		MsgBox('Favor informar condição de pagamento','Atenção!!!','Alert')
	ElseIf (mv_par03 > '499' .or. empty(mv_par03)) .and. mv_par05 <> 4
		MsgBox('Favor informar um TES válido','Atenção!!!','Alert')
	ElseIf empty(mv_par04) 
		MsgBox('Favor informar o caminho dos arquivos a importar.' + _cEnter + _cEnter + 'Obs.: dentro da pasta informada deve existir uma pasta chamada RECEBIDOS onde deve estar os arquivos XML a importar.','Atenção!!!','Alert')
	ElseIf empty(_aXMLs)
		MsgBox('Nenhum arquivo XML para importar. Verifique o caminho informado.' + _cEnter + _cEnter + 'Obs.: dentro da pasta informada deve existir uma pasta chamada RECEBIDOS onde deve estar os arquivos XML a importar.','ATENÇÃO!!!','INFO')
	Else
		Exit
	EndIf
EndDo

_cErros   := mv_par04 + '\Erros\' + replace(dtoc(date()),'/','-')
_cImport  := mv_par04 + '\Importados\' + replace(dtoc(date()),'/','-')
MakeDir(_cErros)
MakeDir(_cImport)

If MsgBox('Existe(m) ' + alltrim(str(len(_aXMLs))) + ' arquivo(s) XML para processar.','Confirma Importação?','YESNO')
	Processa({|| ProcXML()})
EndIf
Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ProcXML()
/////////////////////////

Local _nI
Local _oNFE

Public cEmails	:= ""

_aPedidos 		:= {}
_aErros   		:= {}
_aNaoCad  		:= {}
_aBLoq    		:= {}

Conout("*** La Selva - Static Function - PROCXML - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

ProcRegua(len(_aXMLs)+1)

For _nI := 1 to len(_aXMLs)
	
	_cOrigem  	:= mv_par04 + '\Recebidos\' + _aXMLs[_nI,1]
	_cDestino 	:= '\PC_XML\' + _aXMLs[_nI,1]
	copy file &_cOrigem to &_cDestino
	
	__oXml 		:= XmlParserFile( _cDestino, "_", @_cError, @_cWarning )			// acessando o CONTEUDO do meu nodo ""

//	IF TYPE("__oXml") <> "O"
	IF TYPE("__oXml") <> "O"
		Conout("*** LS_PC_XML - Não há XML para processamento variável '__oXml' não é um objeto")
		RETURN
	ENDIF          

IF TYPE("__oXml:_NFEProc") <> "O"
_oNFe  	:= __oXml:_NFE	// objeto com informações do emitente
ELSE
_oNFe  	:= __oXml:_NFEProc:_NFE	// objeto com informações do emitente
//_oNFe  	:=	_oNFe

ENDIF	
	
//	_oIde	  	:= __oXml:_NFEProc:_NFE:_InfNFE:_Ide								// objeto com informações do emitente
	_oIde	  	:= _oNfe:_InfNFE:_Ide								// objeto com informações do emitente
	_cNatOper	:= _oIde:_NatOp:Text
	
//	_oEmit  	:= __oXml:_NFEProc:_NFE:_InfNFE:_Emit								// objeto com informações do emitente
	_oEmit  	:= _oNfe:_InfNFE:_Emit								// objeto com informações do emitente
	_cCNPJE 	:= _oEmit:_CNPJ:Text												// CNPJ emitente
	_cIEE   	:= _oEmit:_IE:Text													// IE emitente
	_cNomeE 	:= _oEmit:_XNome:Text												// nome emitente
		
//	_oDest  	:= __oXml:_NFEProc:_NFE:_InfNFE:_Dest								// objeto com informações do cliente
	_oDest  	:= _oNfe:_InfNFE:_Dest								// objeto com informações do cliente
	_cCNPJD 	:= _oDest:_CNPJ:Text												// CNPJ destinatario
	_cIED   	:= _oDest:_IE:Text													// IE destinatario
	_cNomeD 	:= _oDest:_XNome:Text												// nome destinatario
//	_nTotProd	:= val(__oXml:_NFEProc:_NFE:_InfNFE:_Total:_ICMSTot:_vProd:Text)	// valor total dos protheus - thiago wip
	_nTotProd	:= val(_oNfe:_InfNFE:_Total:_ICMSTot:_vProd:Text)	// valor total dos protheus - thiago wip
//	_nDescT 	:= val(__oXml:_NFEProc:_NFE:_InfNFE:_Total:_ICMSTot:_vDesc:Text)	// desconto - thiago wip
	_nDescT 	:= val(_oNfe:_InfNFE:_Total:_ICMSTot:_vDesc:Text)	// desconto - thiago wip
//	_nTotNf 	:= val(__oXml:_NFEProc:_NFE:_InfNFE:_Total:_ICMSTot:_vNf:Text)  	// valor total da NF - thiago wip
	_nTotNf 	:= val(_oNfe:_InfNFE:_Total:_ICMSTot:_vNf:Text)  	// valor total da NF - thiago wip
	_dVenc  	:= ctod('')                                			  				// vencimento
	_cDup   	:= ''               								  				// numero da duplicata
	_nVDupl 	:= 0                     							  				// valor da duplicata
//	If type('__oXml:_NFEProc:_NFE:_InfNFE:_Cobr:_Dup') <> 'U'                   	
	If type('_Nfe:_InfNFE:_Cobr:_Dup') <> 'U'                   	
//		_oDupl  := __oXml:_NFEProc:_NFE:_InfNFE:_Cobr:_Dup							// objeto com informações das duplicatas
		_oDupl  := _oNfe:_InfNFE:_Cobr:_Dup							// objeto com informações das duplicatas
		If type('_oDupl:_DVenc') == 'U'
			_dVenc := ctod('')
		Else
			_dVenc  := stod(strtran(_oDupl:_DVenc:Text,'-','')) 					// vencimento
		EndIf
		if __oXml:_NFEProc:_versao:text = "3.10"
			_cDup   := _oDupl[len(_oDupl)]:_NDUP:Text												// numero da duplicata
			_nVDupl := val(_oDupl[len(_oDupl)]:_VDup:Text)
		else
			_cDup   := _oDupl:_NDUP:Text												// numero da duplicata
			_nVDupl := val(_oDupl:_VDup:Text)
		endif
	EndIf
	
//	_oNF    := __oXml:_NFEProc:_NFE:_InfNFE:_IDE		 							// objeto com informações da nota fiscal
	_oNF    := _oNfe:_InfNFE:_IDE		 							// objeto com informações da nota fiscal
	_cNfisc := strzero(val(_oNF:_nNF:Text),9)										// nro da nota fiscal
	_cSerie := _oNF:_Serie:Text									   					// serie da NF
	if __oXml:_NFEProc:_versao:text == "2.00"
		_dEmiss := stod(strtran(_oNF:_DEmi:Text,'-',''))								// emissao da nf
	else
		_dEmiss := stod(strtran(_oNF:_DHEmi:Text,'-',''))								// emissao da nf
	endif
	_aXMLs[_nI,1] := 'NFE_' + _cNfisc + '_' + _cSerie + '_' + dtos(_dEmiss) + '_' + replace(replace(replace(left(_cNomeE,15),' ',''),'-',''),'S.A.','') + '.xml'
	fRename(_cOrigem, mv_par04 + '\Recebidos\' + _aXMLs[_nI,1])
	_cOrigem  := mv_par04 + '\Recebidos\' + _aXMLs[_nI,1]
	
	_cQuery := "SELECT A2_COD, A2_LOJA
	_cQuery += _cEnter + " FROM " + RetSqlName('SA2') + " (NOLOCK) "
	_cQuery += _cEnter + " WHERE A2_CGC 								= '" + _cCNPJE + "'"
//	_cQuery += _cEnter + " AND REPLACE(REPLACE(A2_INSCR,'.',''),'-','') = '" + _cIEE + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ 								= ''"
	_cQuery += _cEnter + " AND A2_MSBLQL  								= '2'"
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'FORN', .F., .T.)
	_cFornece 	:= FORN->A2_COD
	_cLoja 		:= FORN->A2_LOJA
	DbCloseArea()
	
	If empty(_cFornece)
		aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'Fornecedor não localizado. Verificar CNPJ e Inscr. Estadual (emitente)', _cNomeD, tran(_cCNPJE,'@R 99.999.999/9999-99'), _cIED, _cNomeE, tran(_cCNPJE,'@R 99.999.999/9999-99'), _cIEE})
		loop
	EndIf
	
	_cQuery := "SELECT * FROM sigamat_copia (NOLOCK)"
	_cQuery += _cEnter + " WHERE ativo 														= 1"
	_cQuery += _cEnter + " AND M0_CGC 														= '" + _cCNPJD + "'"
	_cQuery += _cEnter + " AND M0_CODFIL 													NOT IN ('02') "
	_cQuery += _cEnter + " AND REPLACE(REPLACE(REPLACE(inscriest,'.',''),'/',''),'-','')	= '" + _cIED + "'"
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SIGAMAT', .F., .T.)
	_cFilial := SIGAMAT->M0_CODFIL
	DbCloseArea()
	
	If empty(_cFilial)
		aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'Loja não localizada. Verifiar CNPJ e Inscr. Estadual (destinatário)', _cNomeD, tran(_cCNPJD,'@R 99.999.999/9999-99'), _cIED, _cNomeE, tran(_cCNPJE,'@R 99.999.999/9999-99'), _cIEE})
		fErase(_cDestino)
		
		_cDestino  := _cErros + '\Loja_nao_localizada_' + _aXMLs[_nI,1]
		copy file &_cOrigem to &_cDestino
		If file(_cDestino)
			fErase(_cOrigem)
		EndIf
		_lItemOK := .f.
		
		loop
	EndIf
	
	IF lAUTO 		// PROCESSO AUTOMATICO

	    // Verifico se a natureza da operação é de Acerto de Consignação
		IF "Acerto" $_cNatOper .or. "acerto"$_cNatOper .or. "ACERTO"$_cNatOper
			lAcerto := .T.
		ELSE
			lAcerto := .F.
		ENDIF
	
		IF lACERTO	// DEVE GERAR ACERTO
			MV_PAR02	:= GETMV("LS_CPGXML1")
			MV_PAR03	:= GETMV("LS_TESXML1")
			MV_PAR05	:= 4
		ELSE		// DEVE GERAR PEDIDO DE COMPRAS
			MV_PAR02 	:= GETMV("LS_CPGXML2")
			MV_PAR03	:= GETMV("LS_TESXML2")
			MV_PAR05	:= 3
		ENDIF
	ENDIF

	_cPedido := ''
	If mv_par05 <> 4	
		_cQuery := "SELECT DISTINCT C7_NUM"
		_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " SC7 (NOLOCK)"
		_cQuery += _cEnter + " WHERE C7_FORNECE 	= '" + _cFornece + "'"
		_cQuery += _cEnter + " AND C7_LOJA 			= '" + _cLoja + "'"
		_cQuery += _cEnter + " AND C7_OBS 			= 'NF Nro: " + _cNfisc + '/' + _cSerie + "'"
		_cQuery += _cEnter + " AND C7_FILIAL 		= '" + _cFilial + "'"
		_cQuery += _cEnter + " AND D_E_L_E_T_ 		= ''"
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'PC', .F., .T.)
		_cPedido := PC->C7_NUM
		DbCloseArea() 
	EndIf
	
	If !empty(_cPedido)
		aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'PC já gerado para esta NF (' + _cPedido + ')', _cNomeD, tran(_cCNPJD,'@R 99.999.999/9999-99'), _cIED, _cNomeE, tran(_cCNPJE,'@R 99.999.999/9999-99'), _cIEE})
		fErase(_cDestino)
		
		_cDestino  := _cErros + '\Pedido_ja_gerado_' + _aXMLs[_nI,1]
		copy file &_cOrigem to &_cDestino
		If file(_cDestino)
			fErase(_cOrigem)
		EndIf
		_lItemOK := .f.
		
		loop
	EndIf
	
    DbSelectArea('SF1')
    DbSetOrder(1)
    If DbSeek(_cFilial + _cNfisc + _cSerie + _cFornece + _cLoja,.f.)
		aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'NF já incluida (Pedido: ' + _cPedido + ')', _cNomeD, tran(_cCNPJD,'@R 99.999.999/9999-99'), _cIED, _cNomeE, tran(_cCNPJE,'@R 99.999.999/9999-99'), _cIEE})
		fErase(_cDestino)
		
		_cDestino  := _cErros + '\NF_já_incluída_' + _aXMLs[_nI,1]
		copy file &_cOrigem to &_cDestino
		If file(_cDestino)
			fErase(_cOrigem)
		EndIf
		_lItemOK := .f.
		
		loop
	EndIf
	
	IncProc('NF: ' + _cNfisc + '/' + _cSerie + ' - ' + left(_cNomeE,15))
	
//	_aDet   	:= aClone(__oXml:_NFEProc:_NFE:_InfNFE:_Det)				// array com detalhes do XML
	_aDet   	:= aClone(_oNfe:_InfNFE:_Det)				// array com detalhes do XML
	
	_aItens 	:= {}														// array com detalhes processados
	_lItemOk	:= .t.														// flag para verificação dos itens
	
	For _nJ := 1 to iif(Type('_aDet') == 'A', len(_aDet), 1)
		
		If Type('_aDet') == 'A'
			
			If type('_aDet[_nJ]:_InfadProd:Text') == 'C'
				_cEdic  := padl(alltrim(strtran(upper(_aDet[_nJ]:_InfadProd:Text),'EDICAO','')),4,'0')	// informações do produto
//				_cEdic  := Strzero(Val(Alltrim(strtran(upper(_aDet[_nJ]:_InfadProd:Text),'EDICAO',''))),5)	// informações do produto
			Else
				_cEdic  := ''
			EndIf
			_cCF    	:= _aDet[_nJ]:_Prod:_CFOP:Text    					// CFOP
			_cProd  	:= _aDet[_nJ]:_Prod:_CProd:Text						// código do produto DINAP
			_cNCM   	:= _aDet[_nJ]:_Prod:_NCM:Text    					// NCM
			_nQuant 	:= val(_aDet[_nJ]:_Prod:_QCom:Text)					// quantidade
			_cUM		:= _aDet[_nJ]:_Prod:_UCom:Text    					// unidade de medida
			_nVUnit 	:= val(_aDet[_nJ]:_Prod:_VUnCom:Text)				// valor unitario
			_nVTot  	:= val(_aDet[_nJ]:_Prod:_VProd:Text)				// valor total
			_cDesc  	:= _aDet[_nJ]:_Prod:_XProd:Text						// descrição do produto
			_cEan   	:= _aDet[_nJ]:_Prod:_cEan:Text						// EAN
			_nDescI 	:= 0
			_nDescIP	:= 0
			If type('_aDet[_nJ]:_Prod:_vDesc:Text') == 'C'
				_nDescI := val(_aDet[_nJ]:_Prod:_vDesc:Text)/val(_aDet[_nJ]:_Prod:_QCom:Text)	// desconto no produto
				_nDescIP:= round((100*val(_aDet[_nJ]:_Prod:_vDesc:Text))/_nVTot,2)				// percentagem de desconto no produto
 			EndIf
			
		Else
			
//			_oDet   := __oXml:_NFEProc:_NFE:_InfNFE:_Det
			_oDet   := _oNfe:_InfNFE:_Det
			If type('_oDet:_InfadProd:Text') == 'C'
				_cEdic  := padl(alltrim(strtran(upper(_oDet:_InfadProd:Text),'EDICAO','')),4,'0')	// informações do produto
//				_cEdic  := Strzero(Val(alltrim(strtran(upper(_oDet:_InfadProd:Text),'EDICAO',''))),5)	// informações do produto
			Else
				_cEdic  := ''
			EndIf
			_cCF    	:= _oDet:_Prod:_CFOP:Text 		   					// CFOP
			_cProd  	:= _oDet:_Prod:_CProd:Text							// código do produto DINAP
			_cNCM   	:= _oDet:_Prod:_NCM:Text    						// NCM
			_nQuant 	:= val(_oDet:_Prod:_QCom:Text)						// quantidade
			_cUM		:= _oDet:_Prod:_UCom:Text    						// unidade de medida
			_nVUnit 	:= val(_oDet:_Prod:_VUnCom:Text)					// valor unitario
			_nVTot  	:= val(_oDet:_Prod:_VProd:Text)						// valor total
			_cDesc  	:= _oDet:_Prod:_XProd:Text							// descrição do produto
			_cEan 		:= ''
			If type('_oDet:_Prod:_cEan:Text') == 'C'
				_cEan   := _oDet:_Prod:_cEan:Text							// EAN
			EndIf
			_nDescI 	:= 0
			_nDescIP	:= 0
			If type('_oDet:_Prod:_vDesc:Text') == 'C'
				_nDescI := val(_oDet:_Prod:_vDesc:Text)/val(_oDet:_Prod:_QCom:Text)		// desconto no produto
				_nDescIP:= round((100*val(_oDet:_Prod:_vDesc:Text))/_nVTot,2)			// percentagem de desconto no produto
			EndIf
			
		EndIf
		
		If _cCF < '5'
			aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'Nota fiscal de entrada do emissor. Não processada. (CFOP: ' + _cCF + ')', _cNomeD, tran(_cCNPJD,'@R 99.999.999/9999-99'), _cIED, _cNomeE, tran(_cCNPJE,'@R 99.999.999/9999-99'), _cIEE})
			fErase(_cDestino)
			
			_cDestino  := _cErros + '\Nota_Fiscal_de_Entrada_Fornecedor_' + _aXMLs[_nI,1]
			copy file &_cOrigem to &_cDestino
			If file(_cDestino)
				fErase(_cOrigem)
			EndIf
			_lItemOK := .f.
			Exit
			
		ElseIf !empty(mv_par01)
			If substr(_cCF,2,3) <> substr(mv_par01,2,3)
				aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'CFOP (' + _cCF + ') diferente do parâmetro (' + mv_par01 + ')', _cNomeD, tran(_cCNPJD,'@R 99.999.999/9999-99'), _cIED, _cNomeE, tran(_cCNPJE,'@R 99.999.999/9999-99'), _cIEE})
				_cDestino  := _cErros + '\CFOP_Nao_Importado_' + _cCF + '_' + _aXMLs[_nI,1]
				copy file &_cOrigem to &_cDestino
				If file(_cDestino)
					fErase(_cOrigem)
				EndIf
				_lItemOK := .f.
				Exit
			EndIf
		EndIf
		
		_cQuery := "SELECT B1_FAMPROJ, SUBSTRING(B1_COD,1, LEN(RTRIM(B1_COD))-4) , B1_COD, B1_EDICAO, B1_MSBLQL"
		_cQuery += _cEnter + " FROM " + RetSqlName('SB1') + " (NOLOCK) "
		_cQuery += _cEnter + " WHERE D_E_L_E_T_ 		= ''"

		If (!empty(_cEan)) .And. (!empty(_cEdic))
			_cQuery += _cEnter + " AND ( B1_CODBAR 		= '" + Alltrim(_cEan) + "0" + Alltrim(_cEdic) + "' OR B1_CODBAR 		= '" + Alltrim(_cEan) + "' )"
		Else
			If !empty(_cEan)
				_cQuery += _cEnter + " AND B1_CODBAR 		= '" + Alltrim(_cEan) + "'"
			Else
				_cQuery += _cEnter + " AND (B1_FAMPROJ 		= '" + _cProd + "' OR B1_CODBAR = '" + _cProd + "' OR B1_REFEREN = '" + _cProd + "')"
			EndIF
		EndIf

		If !empty(_cEdic)
			_cQuery += _cEnter + " AND B1_EDICAO 	= '" + _cEdic + "'"
		EndIf 

/*
		If !empty(_cEan)
			_cQuery += _cEnter + " AND B1_CODBAR 		= '" + _cEan + "'"
		Else
			If !empty(_cEdic)
				_cQuery += _cEnter + " AND B1_EDICAO 	= '" + _cEdic + "'"
			EndIf 
			_cQuery += _cEnter + " AND B1_FAMPROJ 		= '" + _cProd + "'"
		EndIf
*/

		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'PROD', .F., .T.)
		
		If empty(PROD->B1_COD)
			If aScan(_aNaoCad, {|_x| _x[1] == _cProd }) == 0
				aAdd(_aNaoCad,{_cProd, _cDesc, _cEdic,_cNfisc + ' / ' + _cSerie, strzero(_nJ,3), _cNomeE, tran(_cCNPJE,'@R 99.999.999/9999-99')})
			EndIf
			_lItemOK := .f.

		ElseIf PROD->B1_MSBLQL =='1'

			If aScan(_aBloq, {|_x| _x[1] == _cProd }) == 0
				aAdd(_aBloq,{_cProd, _cDesc, _cEdic,_cNfisc + ' / ' + _cSerie, strzero(_nJ,3), _cNomeE, tran(_cCNPJE,'@R 99.999.999/9999-99')})
			EndIf
			_lItemOK := .f.

		EndIf
		
		aAdd(_aItens,{_cEdic, _cCF, PROD->B1_COD, _cNCM, _nQuant, _cUM, _nVunit, _nVTot, _cDesc, _nDescI, _nDescIP})
		
		IF EMPTY(ALLTRIM(cEmails))
			cEmails := MV_PAR06 // atualizo variavel com os emails dos pedidos, o parametro MV_PAR06 está perdendo a configuração
		ENDIF
		
		DbCloseArea()
	Next
	
	If !_lItemOK
		loop
	EndIf
	
	_lOk := GeraPC()
	
	If _lOk
		
		_cOrigem  :=  mv_par04 + '\Recebidos\' + _aXMLs[_nI,1]
		_cDestino := '\PC_XML\' + _aXMLs[_nI,1]
		fErase(_cDestino)
		
		_cDestino  := _cImport + '\' + _aXMLs[_nI,1]
		copy file &_cOrigem to &_cDestino
		If file(_cDestino)
			fErase(_cOrigem)
		EndIf
	EndIf
	  
	/*
	// envia um email para cada XML lido
	If !empty(_aPedidos) .or. !empty(_aErros) .or. !empty(_aNaoCad) .or. !empty(_aBloq)
		_cRecebe := ''
		mv_par06 := IIF(TYPE("MV_PAR06")!="C",alltrim(cEmails)+";",alltrim(mv_par06) + ';')
		For _nI  := 1 to len(mv_par06)
			If substr(mv_par06,_nI,1) $ ' /,;#*'
				_cRecebe += '@laselva.com.br;'
			Else
				_cRecebe += substr(mv_par06,_nI,1)
			EndIf
		Next     
		_cRecebe := left(_cRecebe,len(_cRecebe)-1)
	
		aSort(_aPedidos	,,,{|x,y| x[7]+x[8] < y[7]+y[8]})
		aSort(_aErros	,,,{|x,y| x[8] 		< y[8]})
		aSort(_aBloq	,,,{|x,y| x[5] 		< y[5]})
		aSort(_aNaoCad	,,,{|x,y| x[5] 		< y[5]})
		IncProc('Enviando email')
		Email()
	EndIf
    
	// LIMPO ARRAYS PARA INICIAR PROCESSO NOVAMENTE
	_aPedidos := {}
	_aErros   := {}
	_aNaoCad  := {}
	_aBLoq    := {}
	*/
	
Next

// MANDA UM EMAIL COM TODOS OS XML PROCESSADOS 
If !empty(_aPedidos) .or. !empty(_aErros) .or. !empty(_aNaoCad) .or. !empty(_aBloq)
	_cRecebe := ''
	mv_par06 := IIF(TYPE("MV_PAR06")!="C",alltrim(cEmails)+";",alltrim(mv_par06) + ';')
	For _nI  := 1 to len(mv_par06)
		If substr(mv_par06,_nI,1) $ ' /,;#*'
			_cRecebe += '@laselva.com.br;'
		Else
			_cRecebe += substr(mv_par06,_nI,1)
		EndIf
	Next     
	_cRecebe := left(_cRecebe,len(_cRecebe)-1)

	aSort(_aPedidos	,,,{|x,y| x[7]+x[8] < y[7]+y[8]})
	aSort(_aErros	,,,{|x,y| x[8] 		< y[8]})
	aSort(_aBloq	,,,{|x,y| x[5] 		< y[5]})
	aSort(_aNaoCad	,,,{|x,y| x[5] 		< y[5]})
	IncProc('Enviando email')
	Email()
EndIf

If len(_aXMLs) > 1
	_cMsg := 'Foram processados ' + alltrim(str(len(_aXMLs))) + ' arquivos XML.' + _cEnter
Else
	_cMsg := alltrim(str(len(_aXMLs))) + ' arquivo XML foi processado.' + _cEnter
EndIf

If len(_aPedidos) > 1
	_cMsg += 'Foram gerados ' + alltrim(str(len(_aPedidos))) + ' pedidos.' + _cEnter
ElseIf len(_aPedidos) == 1
	_cMsg += '1 pedido foi gerado.' + _cEnter
Else
	_cMsg += 'Nenhum pedido foi gerado.' + _cEnter
EndIf

If len(_aNaoCad) > 1
	_cMsg += alltrim(str(len(_aNaoCad))) + ' produtos não estão cadastrados.' + _cEnter
ElseIf len(_aNaoCad) == 1
	_cMsg += '1 produto não está cadastrado.' + _cEnter
EndIf

If len(_aBloq) > 1
	_cMsg += alltrim(str(len(_aBloq))) + ' produtos estão bloqueados.' + _cEnter
ElseIf len(_aBloq) == 1
	_cMsg += '1 produto está bloqueado.' + _cEnter
EndIf

If len(_aErros) > 1
	_cMsg += alltrim(str(len(_aErros))) + ' pedidos não foram gerados devido a erros.'
ElseIf len(_aErros) == 1
	_cMsg += '1 pedido não foi gerado devido a erro.'
EndIf

IF lAUTO
	CONOUT(_cMsg)
ELSE
	MsgBox(_cMsg,'Pedidos XML','ALERT')
ENDIF

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraPc()
////////////////////////
Conout("*** La Selva - Static Function GERAPC - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_cFilAnt	:= cFilAnt
cFilAnt  	:= _cFilial
cNumEmp  	:= cEmpAnt + cFilAnt

_C7_NUM 	:= GetNumSC7()

Do While .T.
	DbSelectArea("SC7")
	DbSetOrder(1)
	If DbSeek(xFilial("SC7") + _C7_NUM,.f.)
		ConfirmSX8()
		_C7_NUM := GetSxeNum("SC7","C7_NUM")
	Else
		Exit
	EndIf
EndDo
_cCond  := Posicione('SA2',1, xFilial('SA2') + _cFornece + _cLoja,'A2_COND')
_aCabPc := {}
aAdd(_aCabPc, {"C7_NUM"     , _C7_NUM								, Nil})
aAdd(_aCabPc, {"C7_EMISSAO"	, _dEmiss								, Nil})
aAdd(_aCabPc, {"C7_FORNECE"	, _cFornece							 	, Nil})
aAdd(_aCabPc, {"C7_LOJA"	, _cLoja								, Nil})
aAdd(_aCabPc, {"C7_FILENT"	, cFilAnt								, Nil})
aAdd(_aCabPc, {"C7_COND"   	, iif(!empty(mv_par02),mv_par02,_cCond)	, Nil})
aAdd(_aCabPc, {"C7_CONTATO"	, ''									, Nil})

_aCabNF := {}
aAdd(_aCabNF,{"F1_TIPO"		, "N" 									, Nil })	
aAdd(_aCabNF,{"F1_FORMUL"	, "N" 									, Nil })
aAdd(_aCabNF,{"F1_DOC"		, _cNfisc								, Nil })  
aAdd(_aCabNF,{"F1_SERIE"	, _cSerie								, Nil }) 
aAdd(_aCabNF,{"F1_EMISSAO"	, _dEmiss								, Nil }) 
aAdd(_aCabNF,{"F1_FORNECE"	, _cFornece								, Nil }) 
aAdd(_aCabNF,{"F1_LOJA"		, _cLoja								, Nil })    
aAdd(_aCabNF,{"F1_ESPECIE"  , "NFE"									, Nil })  
aAdd(_aCabNF,{"F1_COND"		, iif(!empty(mv_par02),mv_par02,_cCond)	, Nil })

_aItensPc := {}
_aItensNF := {}

For _nk := 1 to len(_aItens)
	_aItem := {}
	
	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1") + _aItens[_nK,3]) )
	
	aAdd(_aItem, {"C7_ITEM"		, strzero(_nk,4)  						, Nil})
	aAdd(_aItem, {"C7_PRODUTO"	, SB1->B1_COD							, Nil})
	aAdd(_aItem, {"C7_QUANT"	, _aItens[_nK,5]						, Nil})
	aAdd(_aItem, {"C7_UM"    	, SB1->B1_UM       						, Nil})
	aAdd(_aItem, {'C7_PRECO'	, _aItens[_nK,7]						, NIL})
	aAdd(_aItem, {'C7_TOTAL' 	, _aItens[_nK,5] * _aItens[_nK,7]		, NIL})
	If !empty(mv_par03)
		aAdd(_aItem, {'C7_TES'  , mv_par03                         	, NIL})
	EndIf
	aAdd(_aItem, {"C7_DATPRF" 	, date()								, Nil})
	aAdd(_aItem, {"C7_OBS"    	, 'NF Nro: ' + _cNfisc + '/' + _cSerie	, Nil})
	aAdd(_aItem, {"C7_VLDESC"  	, _aItens[_nK,10]*_aItens[_nK,5]       	, Nil})
	
	aAdd(_aItensPc,aClone(_aItem))

	_aItem := {}
	aAdd(_aItem,{"D1_ITEM"		, strzero(_nk,4)						, Nil})    
	aAdd(_aItem,{"D1_COD"		, SB1->B1_COD							, Nil})
	aAdd(_aItem,{"D1_UM"		, SB1->B1_UM 							, Nil})   	
	aAdd(_aItem,{"D1_QUANT"		, _aItens[_nK,5]						, Nil})    
	aAdd(_aItem,{"D1_VUNIT"		, _aItens[_nK,7]						, Nil})    
	aAdd(_aItem,{"D1_TOTAL"		, _aItens[_nK,5] * _aItens[_nK,7]		, Nil})    
	aAdd(_aItem,{"D1_LOCAL"		, '01'									, Nil})   
	If !empty(mv_par03) .and. mv_par05 == 1
		aAdd(_aItem, {'D1_TES'  , mv_par03                         		, NIL})
	EndIf
	aAdd(_aItem, {"D1_VALDESC" 	, _aItens[_nK,10]*_aItens[_nK,5]       	, Nil})
	aAdd(_aItensNF,aClone(_aItem))

Next

lMsErroAuto := .f.

If mv_par05 == 1	// documento de entrada
	_cCadastro := 'Documento de Entrada'
	MsAguarde({|| MATA103(_aCabNF, _aItensNF)},"Aguarde...","Gerando Nota Fiscal " + _cNfisc + '/' + _cSerie,.T.)
	
	Pergunte(_cPerg,.f.)
	mv_par04 := alltrim(mv_par04)
	If !lMsErroAuto
		aAdd(_aPedidos , {cFilAnt, 'DocEntrada', _cNfisc + '/' + _cSerie, dtoc(_dEmiss), dtoc(_dVenc), tran(_nVDupl,'@E 999,999.99'),SA2->A2_COD, SA2->A2_LOJA, SA2->A2_NOME})
	Else
		MsgBox('Ocorreu um erro na importação do XML da nota fiscal ' + _cNfisc + '/' + _cSerie,'ATENÇÃO!!!','ALERT')
		//aAdd(_aErros,{NOTA FISCAL		, DATA		, DESCRITIVO DO ERRO								, NOME	DEST	, CNPJ	DESTINATARIO			, IE	, NOME EMIT	, CNPJ EMITENTE				IE EMITENTE 	})
		aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'Ocorreu um erro ao gerar o Doc.Entrada'	, _cNomeD	, tran(_cCNPJD,'@R 99.999.999/9999-99')	, _cIED	, _cNomeE	, tran(_cCNPJE,'@R 99.999.999/9999-99')	, _cIEE})
		MostraErro()
	EndIf
	
ElseIf mv_par05 == 2	// pré-nota
	
	_cCadastro := 'Pré-Nota'
	MsAguarde({|| MATA140(_aCabNF, _aItensNF)},"Aguarde...","Gerando pré-nota " + _cNfisc + '/' + _cSerie,.T.)
	
	Pergunte(_cPerg,.f.)
	mv_par04 := alltrim(mv_par04)
	If !lMsErroAuto
		aAdd(_aPedidos , {cFilAnt, 'Pré-Nota',_cNfisc + '/' + _cSerie, dtoc(_dEmiss), dtoc(_dVenc), tran(_nVDupl,'@E 999,999.99'),SA2->A2_COD, SA2->A2_LOJA, SA2->A2_NOME})
	Else
		MsgBox('Ocorreu um erro na importação do XML da nota fiscal ' + _cNfisc + '/' + _cSerie,'ATENÇÃO!!!','ALERT')
		aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'Ocorreu um erro ao gerar Pré-Nota'	, _cNomeD	, tran(_cCNPJD,'@R 99.999.999/9999-99')	, _cIED	, _cNomeE	, tran(_cCNPJE,'@R 99.999.999/9999-99')	, _cIEE})
		MostraErro()
	EndIf
	
ElseIf mv_par05 == 3	// pedido de compras
	
	_cCadastro := 'Pedido de compras'
	MsAguarde({|| MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,_aCabPc,_aItensPc,3,.F.),'Gerando Pedido de compras ' + _C7_NUM})
	IF !lAUTO
		Pergunte(_cPerg,.f.)
	ENDIF
	mv_par04 := alltrim(mv_par04)
	If !lMsErroAuto
		aAdd(_aPedidos , {cFilAnt, _C7_NUM, _cNfisc + '/' + _cSerie, dtoc(_dEmiss), dtoc(_dVenc), tran(_nVDupl,'@E 999,999.99'),SA2->A2_COD, SA2->A2_LOJA, SA2->A2_NOME})
	Else
		MsgBox('Ocorreu um erro na importação do XML da nota fiscal ' + _cNfisc + '/' + _cSerie,'ATENÇÃO!!!','ALERT')
		aAdd(_aErros,{_cNfisc + ' / ' +  _cSerie, dtoc(_dEmiss), 'Ocorreu um erro na importação do Pedido de Compras'	, _cNomeD	, tran(_cCNPJD,'@R 99.999.999/9999-99')	, _cIED	, _cNomeE	, tran(_cCNPJE,'@R 99.999.999/9999-99')	, _cIEE})
		MostraErro()
	EndIf
	
ElseIf mv_par05 == 4		// acerto de consignação
	
	_cCadastro	:= 'Acerto de consignação'
	_cNumFec 	:= GetSxeNum("SZA","ZA_NUMFEC")
	Do While .T.
		DbSelectArea("SZA")
		DbSetOrder(1)
		If DbSeek(xFilial("SZA") + _cNumFec)
			RollBackSX8()
			_cNumFec := GetSxeNum("SZA","C5_NUM")
		Else
			ConfirmSX8()
			Exit
		EndIf
	EndDo
	
	//Grava a SZA
	DbSelectArea("SZA")
	Reclock("SZA",.T.)
	SZA->ZA_FILIAL		:= xFilial("SZB")
	SZA->ZA_NUMFEC		:= _cNumFec
	SZA->ZA_FORNECE		:= _cFornece
	SZA->ZA_LOJAFOR		:= _cLoja
	SZA->ZA_EMISSAO		:= Date()
	SZA->ZA_USUARIO		:= IIF(lAuto,"Automatico",cUserName)
	SZA->ZA_STATUS  	:= "A"
	SZA->ZA_DATADE  	:= _dEmiss
	SZA->ZA_DATAATE 	:= _dEmiss
	SZA->ZA_PORCDES		:= round((100*_nTotNF)/_nTotProd,1)  
	SZA->( MsUnlock() )
	
	//Grava a SZB
	nItem := "00001"
	For _nI := 1 To Len(_aItens)
		RecLock("SZB",.T.)
		SZB->ZB_FILIAL	:= xFilial("SZB")
		SZB->ZB_ITEM   	:= nItem
		SZB->ZB_NUMFEC	:= _cNumFec
		SZB->ZB_PRODUTO	:= _aItens[_nI,3]
		SZB->ZB_SALDOPT := 0 					//_aItemSZB[_nI,3]
		SZB->ZB_ESTOQUE := 0 					//_aItemSZB[_nI,4]
		SZB->ZB_VALPROD := _aItens[_nI,7]  //]0 //_aItemSZB[_nI,5]								// ZB_VALPROD
		SZB->ZB_PORCDES := _aItens[_nI,11] // 0 //_aItemSZB[_nI,6] // porcentagem de desconto 	// ZB_PORCDES
		SZB->ZB_QTDPAG  := _aItens[_nI,5]
		SZB->ZB_FORNECE := _cFornece
		SZB->ZB_LOJA  	:= _cLoja
		SZB->ZB_DESPROD	:= _aItens[_nI,10] // 0 // desconto do produto							// ZB_DESPROD
		MsUnLock()
		nItem := Soma1(nItem)
		
	Next _nI
	
	DbSelectArea("SZC")
	SZC->( DbSetOrder(1) )
	RecLock("SZC",!(DbSeek(xFilial("SZC")+_cFornece+_cLoja)))
	SZC->ZC_FILIAL	:= xFilial("SZC")
	SZC->ZC_FORNECE	:= _cFornece
	SZC->ZC_LOJAFOR	:= _cLoja
	SZC->ZC_DTACERT	:= _dEmiss
	SZC->( MsUnLock() )

	aAdd(_aPedidos , {cFilAnt, _cNumFec, 'Acerto NF: '+ _cNfisc + '/' + _cSerie, dtoc(_dEmiss), dtoc(_dVenc), tran(_nVDupl,'@E 999,999.99'),SA2->A2_COD, SA2->A2_LOJA, SA2->A2_NOME})
	
EndIf

cFilAnt := _cFilAnt

Return(!lMsErroAuto)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Email()
///////////////////////
Conout("*** La Selva - Static Function EMAIL - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= 'protheus@laselva.com.br'
cAssunto  	:= "Pedidos de compras XML"
//cRecebe   := mv_par06

_aSizes 	:= {'10','10','15','10','10','10'}
_aAlign 	:= {'','','','','','RIGHT'}
_aLabel 	:= {'Filial',iif(mv_par05 == 1,'Doc. Entrada',iif(mv_par05 == 2,'Pré-NOta',iif(mv_par05 == 3,'Pedido','Acerto'))),'Nota Fiscal','Emissão','Vencimento','Valor Duplicata'}

_cHtml		:= ""

_cHtml 		+= '<html>'
_cHtml 		+= '<head>'
_cHtml 		+= '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">' + cAssunto + '</h3></font>'
_cHtml 		+= '</head>'
_cHtml 		+= '<body bgcolor = white text=black  >'
_cHtml 		+= '<hr width=100% noshade>' + _cEnter

If len(_aPedidos) > 0
	_cHtml += '<b><font size="3" color="#0000FF" face="Verdana">' + _cCadastro + ' gerados: </font></b>'+ _cEnter + _cEnter
	_cFornece := ""
	For _nL := 1 To Len(_aPedidos)
		
		If _cFornece <> _aPedidos[_nL,7] + _aPedidos[_nL,8]
			_cFornece := _aPedidos[_nL,7] + _aPedidos[_nL,8]
			_cHtml += '	</TR>'
			
			_cHtml += '</TABLE>'
			_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
			_cHtml += '<b><font size="2" color="#0000FF" face="Verdana"> Fornecedor: ' + _aPedidos[_nL,7] + '/' + _aPedidos[_nL,8] + ' - ' + _aPedidos[_nL,9] + ' </font></b>'+ _cEnter + _cEnter
			
			_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
			_cHtml += '	<TR VALIGN=TOP>                  '
			
			For _nK := 1 To Len(_aSizes)
				_cHtml += '		<TD WIDTH=' + _aSizes[_nK] + '%>'
				_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nK]),'<h3 align = '+ _aAlign[_nK] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nK] + '<B></P></font> '
				_cHtml += '		</TD>'
			Next
			
		EndIf
		
		_cHtml += '	<TR VALIGN=TOP>'
		
		For _nJ := 1 to len(_aSizes)
			_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
			_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aPedidos[_nL,_nJ]+'</P></font>'
			_cHtml += '		</TD>'
		Next
	Next
	_cHtml += '	</TR>'
	
	_cHtml += '</TABLE>'
	_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
	
EndIf

_aSizes := {'8','7','30','20','15','10'}
_aAlign := {'','','','','',''}
_aLabel := {'Nota Fiscal','Emissão','Descrição do Erro','Loja','CNPJ','Inscr Estadual'}

If len(_aErros) > 0
	_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Notas fiscais com erro na importação: </font></b>'+ _cEnter + _cEnter
	
	_cFornece := ""
	For _nL := 1 To Len(_aErros)
		
		If _cFornece <> _aErros[_nL,8]
			_cFornece := _aErros[_nL,8]
			_cHtml += '	</TR>'
			
			_cHtml += '</TABLE>'
			_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
			_cHtml += '<b><font size="2" color="#0000FF" face="Verdana"> Fornecedor: ' + alltrim(_aErros[_nL,7]) + '  CNPJ: ' + _aErros[_nL,8] + '   Inscr. Estadual: ' + _aErros[_nL,9] + ' </font></b>'+ _cEnter + _cEnter
			
			_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
			_cHtml += '	<TR VALIGN=TOP>                  '
			
			For _nK := 1 To Len(_aSizes)
				_cHtml += '		<TD WIDTH=' + _aSizes[_nK] + '%>'
				_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nK]),'<h3 align = '+ _aAlign[_nK] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nK] + '<B></P></font> '
				_cHtml += '		</TD>'
			Next
			
		EndIf
		
		_cHtml += '	<TR VALIGN=TOP>'
		
		For _nJ := 1 to len(_aSizes)
			_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
			_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aErros[_nL,_nJ]+'</P></font>'
			_cHtml += '		</TD>'
		Next
		
	Next
	
	_cHtml 	+= '	</TR>'
	
	_cHtml 	+= '</TABLE>'
	_cHtml 	+= '<P STYLE="margin-bottom: 0cm"><BR>'
	
EndIf

_aSizes 	:= {'15','25','10','15','5'}
_aAlign 	:= {'','','','',''}
_aLabel 	:= {'Código Fornecedor','Produto','Edição','Nota Fiscal','Item'}

If len(_aNaoCad) > 0
	_cHtml 	+= '<b><font size="3" color="#0000FF" face="Verdana"> Produtos não cadastrados: </font></b>'+ _cEnter + _cEnter
	
	_cFornece := ""
	For _nL := 1 To Len(_aNaoCad)
		
		If _cFornece <> _aNaoCad[_nL,len(_aNaoCad[_nL])]
			_cFornece := _aNaoCad[_nL,len(_aNaoCad[_nL])]
			_cHtml += '	</TR>'
			
			_cHtml += '</TABLE>'
			_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
			_cHtml += '<b><font size="2" color="#0000FF" face="Verdana"> Fornecedor: ' + alltrim(_aNaoCad[_nL,len(_aNaoCad[_nL])-1]) + '  CNPJ: ' + _aNaoCad[_nL,len(_aNaoCad[_nL])] + ' </font></b>'+ _cEnter + _cEnter
			
			_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
			_cHtml += '	<TR VALIGN=TOP>                  '
			
			For _nK := 1 To Len(_aSizes)
				_cHtml += '		<TD WIDTH=' + _aSizes[_nK] + '%>'
				_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nK]),'<h3 align = '+ _aAlign[_nK] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nK] + '<B></P></font> '
				_cHtml += '		</TD>'
			Next
			
		EndIf
		
		_cHtml += '	<TR VALIGN=TOP>'
		
		For _nJ := 1 to len(_aSizes)
			_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
			_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aNaoCad[_nL,_nJ]+'</P></font>'
			_cHtml += '		</TD>'
		Next
		
	Next
	_cHtml += '	</TR>'
	
	_cHtml += '</TABLE>'
	_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
	
EndIf

If len(_aBloq) > 0
	_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Produtos bloqueados: </font></b>'+ _cEnter + _cEnter
	
	_cFornece := ""
	For _nL := 1 To Len(_aBloq)
		
		If _cFornece <> _aBloq[_nL,len(_aBloq[_nL])]
			_cFornece := _aBloq[_nL,len(_aBloq[_nL])]
			_cHtml += '	</TR>'
			
			_cHtml += '</TABLE>'
			_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
			_cHtml += '<b><font size="2" color="#0000FF" face="Verdana"> Fornecedor: ' + alltrim(_aBloq[_nL,len(_aBloq[_nL])-1]) + '  CNPJ: ' + _aBloq[_nL,len(_aBloq[_nL])] + ' </font></b>'+ _cEnter + _cEnter
			
			_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
			_cHtml += '	<TR VALIGN=TOP>                  '
			
			For _nK := 1 To Len(_aSizes)
				_cHtml += '		<TD WIDTH=' + _aSizes[_nK] + '%>'
				_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nK]),'<h3 align = '+ _aAlign[_nK] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nK] + '<B></P></font> '
				_cHtml += '		</TD>'
			Next
			
		EndIf
		
		_cHtml += '	<TR VALIGN=TOP>'
		
		For _nJ := 1 to len(_aSizes)
			_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
			_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aBloq[_nL,_nJ]+'</P></font>'
			_cHtml += '		</TD>'
		Next
		
	Next
	
	_cHtml += '	</TR>'
	
	_cHtml += '</TABLE>'
	_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
	
EndIf

_cHtml += '</P>'

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	
	//_cRecebe := "thiago.queiroz@laselva.com.br;"+_cRecebe

	If GetNewPar("MV_RELAUTH",.F.)
		_lRetAuth := MailAuth(cAccount,cPassword)
		Conout(If(_lRetAuth,"Autenticou","Não Autenticou"))
	Else
		_lRetAuth := .T.
	EndIf
	
	If _lRetAuth                           

		SEND MAIL FROM cEnvia TO _cRecebe SUBJECT cAssunto BODY _cHtml RESULT lEnviado
	
		If !lEnviado
			cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
			GET MAIL ERROR cHtml
			Conout( "ERRO SMTP EM: " + cAssunto )
			If !REC->(eof())
				RecLock('REC',.F.)
				REC->EMAIL := .T.
				MsUnLock()
			EndIf
		Else
			DISCONNECT SMTP SERVER
			Conout( cAssunto )
		Endif
	Else
		DISCONNECT SMTP SERVER
	Endif	
Else
	
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
	MsgAlert(cHtml)
	If !REC->(eof())
		RecLock('REC',.F.)
		REC->EMAIL := .T.
		MsUnLock()
	EndIf
Endif

Return


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg ()
////////////////////////////
Conout("*** La Selva - Static Function VALIDPERG - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

Private _cAlias := Alias ()
Private _aRegs  := {}

aAdd(_aRegs,{_cPerg, "01", "CFOP (do fornecedor)       ","","","mv_ch1", "C",04,  0,  0, "G", "Vazio() .or. ExistCpo('SX5','13'+mv_par01)" 	, "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "13","",""})
aAdd(_aRegs,{_cPerg, "02", "Condição de pagamento      ","","","mv_ch2", "C",03,  0,  0, "G", "ExistCpo('SE4',mv_par02)" 					, "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SE4","",""})
aAdd(_aRegs,{_cPerg, "03", "TES (de entrada)           ","","","mv_ch3", "C",03,  0,  0, "G", "ExistCpo('SF4',mv_par03)"			 		, "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF4","",""})
aAdd(_aRegs,{_cPerg, "04", "Caminho dos arqs XML (Raiz)","","","mv_ch4", "C",60,  0,  0, "G", "NaoVazio()" 									, "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "05", "Gerar:                     ","","","mv_ch5", "N",01,  0,  0, "C", "" 											, "mv_par05", "Doc. Entrada", "", "", "", "", "Pré-Nota", "", "", "", "", "Pedido Compras", "", "", "", "", "Acer. Consignação", "", "", "", "", "", "", "", "", "","",""})
aAdd(_aRegs,{_cPerg, "06", "Emails (sem domínio):      ","","","mv_ch6", "C",60,  0,  0, "C", "NaoVazio()" 									, "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","",""})

DbSelectArea("SX1")
DbSetOrder(1)
For _i := 1 to Len (_aRegs)
	RecLock ("SX1", !DbSeek (_cPerg + _aRegs [_i, 2]))
	For _j := 1 to FCount ()
		If _j <= Len (_aRegs [_i]) .and. !(left (fieldname (_j), 6) $ "X1_CNT/X1_PRESEL")
			FieldPut (_j, _aRegs [_i, _j])
		Endif
	Next
	MsUnlock ()
Next
DbSelectArea (_cAlias)

Return



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_EXCEL()
/////////////////////////
Conout("*** La Selva - User Function LS_EXCEL - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

ALERT('1')
waitrun('C:\Program Files\Microsoft Office\Office12\EXCEL.EXE V:\PROTHEUS_DATA\planilhas\kardex.xlsx')
ALERT('5')

#define SW_HIDE 			0 // Escondido
#define SW_SHOWNORMAL       1 // Normal
#define SW_NORMAL           1 // Normal
#define SW_SHOWMINIMIZED    2 // Minimizada
#define SW_SHOWMAXIMIZED    3 // Maximizada
#define SW_MAXIMIZE         3 // Maximizada
#define SW_SHOWNOACTIVATE   4 // Na Ativação
#define SW_SHOW             5 // Mostra na posição mais recente da janela
#define SW_MINIMIZE         6 // Minimizada
#define SW_SHOWMINNOACTIVE  7 // Minimizada
#define SW_SHOWNA           8 // Esconde a barra de tarefas
#define SW_RESTORE          9 // Restaura a posição anterior
#define SW_SHOWDEFAULT      10// Posição padrão da aplicação
#define SW_FORCEMINIMIZE    11// Força minimização independente da aplicação executada
#define SW_MAX              11// Maximizada
Return()

Static Function CBSMAIL() //

/*
Private _nTMsgs    := ""
Private _nMsgs     := ""
Private _cTo       := ""
Private _cAccount  := "alexandre.dalpiaz@laselva.com.br"
Private _cServer   := "pop.mailcorp.net.br"
Private _cPassword := "mary4989"
Private _lConectou := .F.
Private _cBody     := ""
Private _cFrom     := ""
Private _cCc       := ""
Private _cBcc      := ""
Private _cSubject  := ""
Private _cPath     := 'C:\SUPERPEDIDOS'
Private _aFiles    := {}


Connect POP Server _cServer Account _cAccount Password _cPassword Result _lConectou
POP Message Count _nTMsgs

If !_lConectou
Alert ("Erro na conecção com Servidor " + cServer)
Else
For _nMsgs := 1 to _nTMsgs
Receive Mail Message _nMsgs from _cFrom to _cTo CC _cCc BCC _cBcc Subject _cSubject Body _cBody Attachment _aFiles Save IN (_cPath)
A := 0
Next
EndIf

If _lConectou
Disconnect POP Server Result _lDisConectou
If !_lDisConectou
Alert ("Erro ao disconectar do Servidor de e-mail - " + _cServer)
EndIf
EndIf

Return()
*/

Local oMessage
Local oPopServer
Local aAttInfo
Local cPopServer 	:= "pop.mailcorp.net.br"
Local cAccount 		:= "alexandre.dalpiaz@laselva.com.br"
Local cPwd 			:= "mary4989"
Local nPortPop 		:= 110
Local nPopResult 	:= 0
Local nMessages 	:= 0
Local nMessage 		:= 0
Local lMessageDown 	:= .F.
Local nCount 		:= 0
Local nAtach 		:= 0
Local nMessageDown 	:= 0

Conout("*** La Selva - Static Function CBSMAIL - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

oPopServer := TMailManager():New()
oPopServer:Init(cPopServer , "pop.mailcorp.net.br", cAccount, cPwd, nPortPop)
If ( (nPopResult := oPopServer:PopConnect()) == 0)
	//Conta quantas mensagens há no servidor
	oPopServer:GetNumMsgs(@nMessages)
	ProcRegua(nMessages)
	If( nMessages > 0 )
		oMessage := TMailMessage():New()
		//Verifica todas mensagens no servidor
		For nMessage := nMessages to nMessages-50 step -1
			
			IncProc(str(nMessage) + ' / ' + str(nMessages))
			
			oMessage:Clear()
			nPopResult := oMessage:Receive( oPopServer, nMessage)
			If (nPopResult == 0 ) //Recebido com sucesso?
				nCount := 0
				lMessageDown := .F.
				//Verifica todos anexos da mensagem e os salva
				_nAnexos := oMessage:getAttachCount()
				For nAtach := 1 to _nAnexos
					aAttInfo:= oMessage:getAttachInfo(nAtach)
					If upper(right(aAttInfo[1],3)) == 'XML'   
						//ALERT(aAttInfo[1])
						lSave := oMessage:SaveAttach(nAtach, "\" + upper(aAttInfo[1])) 
						//If lSave
							oMessage:DeleteMsg( nAtach )
						//EndIf
					EndIf
				Next
			EndIf
			If lMessageDown
				nMessageDown++
			EndIf
		Next
	EndIf
	oPopServer:PopDisconnect()
EndIf
Return

//////////////////////////////////////////////////////////////////////////////////////////////
// Rotina automatica para execução via schedule/agendador de tarefas do windows             //
//////////////////////////////////////////////////////////////////////////////////////////////
User Function APCXML()

alParams	:= {.T.,"01","01",.T.,.F.,""} //{.F.,"","",.F.,.F.,""}

If alParams[1]
	RpcSetType(3)
	RpcSetEnv(alParams[2],alParams[3])
Else
	alAreaSM0 := SM0->(GetArea())
	llJob:=.T.
EndIf

/*
aAdd(_aRegs,{_cPerg, "01", "CFOP (do fornecedor)       ","","","mv_ch1", "C",04,  0,  0, "G", "Vazio() .or. ExistCpo('SX5','13'+mv_par01)" 	, "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "13","",""})
aAdd(_aRegs,{_cPerg, "02", "Condição de pagamento      ","","","mv_ch2", "C",03,  0,  0, "G", "ExistCpo('SE4',mv_par02)" 					, "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SE4","",""})
aAdd(_aRegs,{_cPerg, "03", "TES (de entrada)           ","","","mv_ch3", "C",03,  0,  0, "G", "ExistCpo('SF4',mv_par03)"			 		, "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF4","",""})
aAdd(_aRegs,{_cPerg, "04", "Caminho dos arqs XML (Raiz)","","","mv_ch4", "C",60,  0,  0, "G", "NaoVazio()" 									, "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "05", "Gerar:                     ","","","mv_ch5", "N",01,  0,  0, "C", "" 											, "mv_par05", "Doc. Entrada", "", "", "", "", "Pré-Nota", "", "", "", "", "Pedido Compras", "", "", "", "", "Acer. Consignação", "", "", "", "", "", "", "", "", "","",""})
aAdd(_aRegs,{_cPerg, "06", "Emails (sem domínio):      ","","","mv_ch6", "C",60,  0,  0, "C", "NaoVazio()" 									, "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","",""})
*/

mv_par01	:= "" 						// CFOP (FORNECEDOR) - NÃO UTILIZADO PARA O PROCESSO AUTOMATICO
mv_par02	:= "" //GETMV("LS_CPGXML") 	// CONDIÇÃO DE PAGAMENTO
mv_par03	:= "" //GETMV("LS_TESXML") 	// TES DE ENTRADA
mv_par04   	:= GETMV("LS_DIRXML") 		// CAMINHO DO ARQUIVO XML
mv_par05	:= "" //GETMV("LS_TPXML")  	// TIPO DE PROCESSAMENTO
mv_par06	:= GETMV("LS_MAILXML") 		// EMAILS 
lAUTO		:= .T.
_cError    	:= ""
_cWarning  	:= ""
_cCadastro 	:= ""
_oXml 	   	:= NIL
cPerg  		:= "LS_PC_XML "
_aXMLs	   	:= Directory(mv_par04 + '\Recebidos\*.XML')
aSort(_aXMLs,,,{|x,y| x[1] < y[1]})

_cErros   	:= mv_par04 + '\Erros\' + replace(dtoc(date()),'/','-')
_cImport  	:= mv_par04 + '\Importados\' + replace(dtoc(date()),'/','-')
MakeDir(_cErros)
MakeDir(_cImport)

ProcXML()

Return