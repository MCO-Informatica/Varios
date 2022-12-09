#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MT100TOK
// Autor 		Alexandre Dalpiaz
// Data 		23/02/2011
// Descricao  	ponto de entrada no MATA103 (validação do documento de entrada)
//				Verifica se foi informada a data de entrada da nota fiscal no PE MT140CPO para gravar no PE SF1140I
// Uso         	LaSelva
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT100TOK()
////////////////////////
Local _lRet   := .t.
Local _aAlias := GetArea()
Local nPosTes := aScan( aHeader,{|x| AllTrim(x[2])=="D1_TES"} )
                           
If FunName() $ ('MATA920','LS_ROMA','LS_LANCA','SPEDNFE')
	Return(.t.)
EndIf
	
//Acrescentado por Rodrigo: verificador de nfs já existente no romaneio.

DbSelectArea('SD2')
DbSetOrder(3)                                                 

If alltrim(cEspecie) == 'PP' .and. (cFormul <> 'S' .or. right(SC7->C7_COND,1) <> 'X' .or. right(cCondicao,1) <> 'X' .or. !(GetMv('LS_PPECONS') $ SC7->C7_TES + '/' + GdFieldGet('D1_TES',1)))
	MsgBox('Verificar Espécie do Documento e/ou Condição de Pagamento e/ou TES do Pedido de compras e/ou do Documento','Documento de entrada NÃO FISCAL','ALERT')
	Return(.f.)
ElseIf alltrim(cEspecie) <> 'PP' .and. (right(SC7->C7_COND,1) == 'X' .or. right(cCondicao,1) == 'X' .or. (GetMv('LS_PPECONS') $ SC7->C7_TES + '/' + GdFieldGet('D1_TES',1)))
	MsgBox('Verificar Espécie do Documento e/ou Condição de Pagamento e/ou TES do Pedido de compras e/ou do Documento','Documento de entrada FISCAL','ALERT')
	Return(.f.)                  
EndIf

If !l103Auto .and. inclui .and. cFormul == 'N' .and. cA100For < '000010' .and. cLoja <> xFilial('SF1')
	
	If DbSeek(cLoja + cNFiscal + cSerie,.f.)
	
		DbSelectArea("PA6")
		DbSetOrder(1)
		If ca100for < '000009' .and. DbSeek(xFilial('PA6') + SD2->D2_PEDIDO + SD2->D2_FILIAL,.F.)
			
			MsgAlert("Nota pertence a um romaneio. Gerar Pré-nota pela rotina de encerramento do romaneio.", "ATENÇÃO!!!!")
			_lRet := .f.
			
		EndIf
		
	Else
		MsgAlert('Nota fiscal entre filiais/coligadas não emitida na filial de origem','ATENÇÃO!!!','ALERT')
		_lRet := .f.
	EndIf
EndIf

If !l103Auto .and. _lRet .and. SED->ED_MSBLQL == '1'
	_cTexto := 'Natureza utilizada (' + SED->ED_CODIGO + ')está bloqueada.' + _cEnter
	_cTexto += 'Verifique com o depto Fiscal ou Controladoria a natureza correta para esta operação!' + _cEnter
	_cTexto += 'A natureza utilizada na nota fiscal é incluida automaticamente pela natureza' + _cEnter
	_cTexto += 'utilizada no cadastro do fornecedor ou do cliente' + _cEnter
	MsgBox(_cTexto,'ATENÇÃO!!!','ALERT')
	Return(.f.)
EndIf

If _lRet .and. !U_LS_F1VLCOND(3,dDemissao,cCondicao,cEspecie)
	Return(.f.)
EndIf

If _lRet
	_cQuery := "DELETE FROM " + RetSqlName('SFT')
	_cQuery += _cEnter + "WHERE FT_FILIAL 	= '" + xFilial('SFT') + "'"
	_cQuery += _cEnter + "AND FT_NFISCAL 	= '" + cNFiscal + "'"
	_cQuery += _cEnter + "AND FT_SERIE 		= '" + cSerie + "'"
	_cQuery += _cEnter + "AND FT_CLIEFOR 	= '" + cA100For + "'"
	_cQuery += _cEnter + "AND FT_LOJA 		= '" + cLoja+ "'"
	TcSqlExec(_cQuery)
	
	_cQuery := "DELETE FROM " + RetSqlName('SF3')
	_cQuery += _cEnter + "WHERE F3_FILIAL 	= '" + xFilial('SFT') + "'"
	_cQuery += _cEnter + "AND F3_NFISCAL 	= '" + cNFiscal + "'"
	_cQuery += _cEnter + "AND F3_SERIE 		= '" + cSerie + "'"
	_cQuery += _cEnter + "AND F3_CLIEFOR 	= '" + cA100For + "'"
	_cQuery += _cEnter + "AND F3_LOJA 		= '" + cLoja+ "'"
	TcSqlExec(_cQuery)
	
	_cQuery := "DELETE FROM " + RetSqlName('SE2')
	_cQuery += _cEnter + "WHERE E2_MSFIL 	= '" + xFilial('SF1') + "'"
	_cQuery += _cEnter + "AND E2_NUM 		= '" + cNFiscal + "'"
	_cQuery += _cEnter + "AND E2_PREFIXO 	= '" + left(cSerie,1) + xFilial('SF1') + "'"
	_cQuery += _cEnter + "AND E2_FORNECE 	= '" + cA100For + "'"
	_cQuery += _cEnter + "AND E2_LOJA 		= '" + cLoja + "'"
	_cQuery += _cEnter + "AND E2_ORIGEM 	= 'MATA100'"
	TcSqlExec(_cQuery)
	
	If !l103Auto 
		
		Do While empty(__dDtRecebe) .and. (inclui .or. altera)
			
			If MsgBox('Data de recebimento da nota fiscal não informada. Corrigir?','ATENÇÃO!!!','YESNO')
				
				U_DlgDtRec()
				
			Else
				
				MsgBox('Data de recebimento da nota fiscal não informada. Documento não pode ser incluido sem essa informação. Corrija ou abandone a inclusão da Nota Fisal!!','ATENÇÃO!!!','ALERT')
				_lRet := .f.
				Exit
				
			EndIf
			
		EndDo
		
	EndIf

EndIf

RestArea(_aAlias)

Return(_lRet)