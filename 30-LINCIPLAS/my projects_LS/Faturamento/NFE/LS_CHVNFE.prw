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
User Function LS_CHVNFE()
///////////////////////

/*
Processa({||CBSMAIL()})
*/
_cPerg  	:= "LS_PC_XML "
//ValidPerg()
_lRet 		:= .t.
lAuto		:= .F. // VARIAVEL QUE IRA DEFINIR SE O PROCESSO É AUTOMATICO (.T.) OU MANUAL (.F.)
//Do While _lRet
//	_lRet := Pergunte(_cPerg, .t.)
//	If !_lRet
//		Return()
//	EndIf

mv_par04   := "G:\Livros\IntegraSuperPedidos" //alltrim(mv_par04)
_cError    := ""
_cWarning  := ""
_cCadastro := ""
_oXml 	   := NIL
_aXMLs	   := Directory(mv_par04 + '\importados\todos\*.XML')
aSort(_aXMLs,,,{|x,y| x[1] < y[1]})

//EndDo

//_cErros   := mv_par04 + '\Erros\' + replace(dtoc(date()),'/','-')
//_cImport  := mv_par04 + '\Importados\' + replace(dtoc(date()),'/','-')
//MakeDir(_cErros)
//MakeDir(_cImport)

//If MsgBox('Existe(m) ' + alltrim(str(len(_aXMLs))) + ' arquivo(s) XML para processar.','Confirma Importação?','YESNO')
Processa({|| ProcXML()})
//EndIf
Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ProcXML()
/////////////////////////

Local _nI

Public cEmails	:= ""

_aPedidos 		:= {}
_aErros   		:= {}
_aNaoCad  		:= {}
_aBLoq    		:= {}

ProcRegua(len(_aXMLs)+1)

For _nI := 1 to len(_aXMLs)
	
	_cOrigem  	:= mv_par04 + '\importados\todos\' + _aXMLs[_nI,1]
	_cDestino 	:= '\PC_XML\TODOS\' + _aXMLs[_nI,1]
	copy file &_cOrigem to &_cDestino
	
	__oXml 		:= XmlParserFile( _cDestino, "_", @_cError, @_cWarning )			// acessando o CONTEUDO do meu nodo ""
	
	_oIde	  	:= __oXml:_NFEProc:_NFE:_InfNFE:_Ide								// objeto com informações do emitente
	_cNatOper	:= _oIde:_NatOp:Text
	
	_cChaveNFe	:= __oXml:_NFEProc:_ProtNFe:_infprot:_chnfe:text					// Retorna a chave da Nota Fiscal
	
	_oEmit  	:= __oXml:_NFEProc:_NFE:_InfNFE:_Emit								// objeto com informações do emitente
	_cCNPJE 	:= _oEmit:_CNPJ:Text												// CNPJ emitente
	_cIEE   	:= _oEmit:_IE:Text													// IE emitente
	_cNomeE 	:= _oEmit:_XNome:Text												// nome emitente
	
	_oDest  	:= __oXml:_NFEProc:_NFE:_InfNFE:_Dest								// objeto com informações do cliente
	_cCNPJD 	:= _oDest:_CNPJ:Text												// CNPJ destinatario
	_cIED   	:= _oDest:_IE:Text													// IE destinatario
	_cNomeD 	:= _oDest:_XNome:Text												// nome destinatario
	_nTotProd	:= val(__oXml:_NFEProc:_NFE:_InfNFE:_Total:_ICMSTot:_vProd:Text)	// valor total dos protheus - thiago wip
	_nDescT 	:= val(__oXml:_NFEProc:_NFE:_InfNFE:_Total:_ICMSTot:_vDesc:Text)	// desconto - thiago wip
	_nTotNf 	:= val(__oXml:_NFEProc:_NFE:_InfNFE:_Total:_ICMSTot:_vNf:Text)  	// valor total da NF - thiago wip
	_dVenc  	:= ctod('')                                			  				// vencimento
	_cDup   	:= ''               								  				// numero da duplicata
	_nVDupl 	:= 0                     							  				// valor da duplicata
	If type('__oXml:_NFEProc:_NFE:_InfNFE:_Cobr:_Dup') <> 'U'
		_oDupl  := __oXml:_NFEProc:_NFE:_InfNFE:_Cobr:_Dup							// objeto com informações das duplicatas
		If type('_oDupl:_DVenc') == 'U'
			_dVenc := ctod('')
		Else
			_dVenc  := stod(strtran(_oDupl:_DVenc:Text,'-','')) 					// vencimento
		EndIf
		_cDup   := _oDupl:_NDUP:Text												// numero da duplicata
		_nVDupl := val(_oDupl:_VDup:Text)											// valor da duplicata
	EndIf
	
	_oNF    := __oXml:_NFEProc:_NFE:_InfNFE:_IDE		 							// objeto com informações da nota fiscal
	_cNfisc := strzero(val(_oNF:_nNF:Text),9)										// nro da nota fiscal
	_cSerie := _oNF:_Serie:Text									   					// serie da NF
	_dEmiss := stod(strtran(_oNF:_DEmi:Text,'-',''))								// emissao da nf
	
	_aXMLs[_nI,1] := 'NFE_' + _cNfisc + '_' + _cSerie + '_' + dtos(_dEmiss) + '_' + replace(replace(replace(left(_cNomeE,15),' ',''),'-',''),'S.A.','') + '.xml'
	fRename(_cOrigem, mv_par04 + '\importados\todos\' + _aXMLs[_nI,1])
	_cOrigem  	:= mv_par04 + '\importados\todos\' + _aXMLs[_nI,1]
	
	_cQuery := "SELECT A2_COD, A2_LOJA
	_cQuery += _cEnter + " FROM " + RetSqlName('SA2') + " (NOLOCK) "
	_cQuery += _cEnter + " WHERE A2_CGC 								= '" + _cCNPJE + "'"
	_cQuery += _cEnter + " AND REPLACE(REPLACE(A2_INSCR,'.',''),'-','') = '" + _cIEE + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ 								= ''"
	_cQuery += _cEnter + " AND A2_MSBLQL  								= '2'"
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'FORN', .F., .T.)
	_cFornece 	:= FORN->A2_COD
	_cLoja 		:= FORN->A2_LOJA
	DbCloseArea()

	_cFilial	:= "90"
	
	DbSelectArea('SF1')
	DbSetOrder(1)
	If DbSeek(_cFilial + _cNfisc + _cSerie + space(len(space(3))-len(_cSerie)) + _cFornece + _cLoja,.f.)
		
		IF EMPTY(ALLTRIM(SF1->F1_CHVNFE))
			//MSGBOX("SF1 - CHAVE EM BRANDO - "+SF1->F1_DOC)
			reclock("SF1",.F.)
			SF1->F1_CHVNFE := _cChaveNFe
			msUnlock()
		ENDIF
	ELSE
		MSGBOX("SF1 - NOTA FISCAL NÃO ENCONTRADA " + _CNFISC)
	EndIf
	
	DbSelectArea('SF3')
	DbSetOrder(6)
	//F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT
	If DbSeek(_cFilial + _cSerie + space(len(space(3))-len(_cSerie)) + _cNfisc + _cFornece + _cLoja,.f.)
		WHILE SF3->F3_NFISCAL == _CNFISC .AND. SF3->F3_SERIE == CSERIE .AND. SF3->F3_CLIEFOR == _CFORNECE .AND. SF3->F3_LOJA == _CLOJA
			
			IF EMPTY(ALLTRIM(SF3->F3_CHVNFE))
				//MSGBOX("SF3 - CHAVE EM BRANDO - "+SF3->F3_NFISCAL)
				reclock("SF1",.F.)
				SF1->F1_CHVNFE := _cChaveNFe
				msUnlock()
			ENDIF
		ENDDO
	ELSE
		//MSGBOX("SF3 - NOTA FISCAL NÃO ENCONTRADA " + _CNFISC)
	EndIf
	
	DbSelectArea('SFT')
	DbSetOrder(1)
	//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
	If DbSeek(_cFilial +"E"+ _cSerie + space(len(space(3))-len(_cSerie)) + _cNfisc + _cFornece + _cLoja,.f.)
		
		IF EMPTY(ALLTRIM(SFT->FT_CHVNFE))
			//MSGBOX("SFT - CHAVE EM BRANDO - "+SFT->FT_NFISCAL)
			reclock("SFT",.F.)
			SFT->FT_CHVNFE := _cChaveNFe
			msUnlock()
		ENDIF
	ELSE
		MSGBOX("SFT - NOTA FISCAL NÃO ENCONTRADA " + _CNFISC)
	EndIf
	
Next
/*
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
*/

Return()
