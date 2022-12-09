#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

// Programa: mt100agr
// Autor...: Alexandre Dalpiaz
// Data....: 01/10/10
// Funcao..: Após a inclusão da nota de entrada e gravação dos títulos
// 			 Verifica se existe alguma PA/NDF em aberto para o fornecedor
//			 Lista títulos em aberto para o usuário que está classificando a pré-nota
//			 Bloqueia os títulos referentes à pré-nota classificada
//			 Envia email para o responsável pela liberação dos títulos (financeiro) com cópia para o classficador (fiscal)
//			 grava nos títulos o email do classificador para avisá-lo de que o título foi liberado
//
//
//			MV_PCNFE  obriga pedido de compras na nota fiscal
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function mt100agr()
////////////////////////
Local aRet
If inclui
	U_SX5NOTA()
	DbSelectArea('SM0')
	_cCnpj := SM0->M0_CGC
	Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
	_cFiliais := ''
	DbGotop()
	Do While !eof()
		_cFiliais += SM0->M0_CODFIL + ','
		DbSkip()
	EndDo
	Set Filter To
	DbSeek(cEmpAnt+cFilAnt)
	_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')
	
	_cQuery := "UPDATE " + RetSqlName('SX5')
	_cQuery += _cEnter + "SET X5_DESCRI = NF, X5_DESCSPA = NF, X5_DESCENG = NF"
	_cQuery += _cEnter + "FROM ("
	_cQuery += _cEnter + "SELECT X5_CHAVE CHAVE, MAX(X5_DESCRI) NF"
	_cQuery += _cEnter + "FROM " + RetSqlName('SX5') + " SX5 (NOLOCK)"
	_cQuery += _cEnter + "WHERE X5_TABELA = '01'"
	_cQuery += _cEnter + "AND X5_CHAVE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + "AND SX5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND X5_FILIAL IN " + _cFiliais
	_cQuery += _cEnter + "GROUP BY X5_CHAVE"
	_cQuery += _cEnter + ") A"
	_cQuery += _cEnter + "WHERE X5_TABELA = '01'"
	_cQuery += _cEnter + "AND X5_CHAVE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND X5_FILIAL IN " + _cFiliais
	_cQuery += _cEnter + "AND X5_CHAVE = CHAVE"
	
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SF1')
	_cQuery += _cEnter + " SET F1_DTPRNOT = '" + dtos(date()) + "'"
	_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F1_FILIAL = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + " AND F1_DOC = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + " AND F1_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + " AND F1_FORNECE = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND F1_LOJA = '" + SF1->F1_LOJA + "' AND F1_DTPRNOT = ''"
	_cQuery += _cEnter + " AND R_E_C_N_O_ = '" + rtrim(str(SF1->(Recno()))) + "'"
	TcSqlExec(_cQuery)
EndIf

_cQuery := "UPDATE " + RetSqlName('SD1')
_cQuery += _cEnter + " SET D1_CLASFIS = B1_ORIGEM + F4_SITTRIB"
_cQuery += _cEnter + " FROM " + RetSqlName('SB1') + " SB1 (NOLOCK), " + RetSqlName('SF4') + " SF4 (NOLOCK)
_cQuery += _cEnter + " WHERE B1_COD = D1_COD"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND " + RetSqlName('SD1') + ".D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND SF4.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND F4_CODIGO = D1_TES"
_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
TcSqlExec(_cQuery)

_cQuery := "UPDATE " + RetSqlName('SFT')
_cQuery += _cEnter + " SET FT_CLASFIS = D1_CLASFIS
_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + " WHERE " + RetSqlName('SFT') + ".D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND FT_NFISCAL = D1_DOC"
_cQuery += _cEnter + " AND FT_SERIE = D1_SERIE"
_cQuery += _cEnter + " AND FT_FILIAL = D1_FILIAL"
_cQuery += _cEnter + " AND FT_ITEM = D1_ITEM"
_cQuery += _cEnter + " AND FT_CLIEFOR = '" + SF1->F1_FORNECE + "'"
_cQuery += _cEnter + " AND FT_LOJA = '" + SF1->F1_LOJA + "'"
_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
TcSqlExec(_cQuery)

_cQuery := "UPDATE " + RetSqlName('CD2')
_cQuery += _cEnter + " SET CD2_ORIGEM = B1_ORIGEM"
_cQuery += _cEnter + " FROM " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + " WHERE B1_COD = CD2_CODPRO"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND " + RetSqlName('CD2') + ".D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND CD2_ORIGEM = ''"
_cQuery += _cEnter + " AND CD2_TPMOV = 'E'"
_cQuery += _cEnter + " AND CD2_FILIAL = '" + SF1->F1_FILIAL + "'"
_cQuery += _cEnter + " AND CD2_DOC = '" + SF1->F1_DOC + "'"
_cQuery += _cEnter + " AND CD2_SERIE = '" + SF1->F1_SERIE + "'"
If SF1->F1_TIPO $ 'NCIP'
	_cQuery += _cEnter + " AND CD2_CODFOR = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND CD2_LOJFOR = '" + SF1->F1_LOJA + "'"
Else
	_cQuery += _cEnter + " AND CD2_CODCLI = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND CD2_LOJCLI = '" + SF1->F1_LOJA + "'"
EndIf

TcSqlExec(_cQuery)

// função no fonte LASP004
MsAguarde( {|| U_SldSZ9Prv(!inclui .and. !altera)}, 'Aguarde - Atualizando SZ9/saldos previstos......')

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////   ROTINA PARA RESERVA E TRANSFERENCIA DAS REVISTAS IMPORTADAS PARA O ESTOQUE DO SAC - FILIAL 20 QUANDO HOUVER RESERVA DE ASSINATURAS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
U_SZRReser('INCLUI')
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

_nTitulo := Posicione('SE2',6,xFilial('SE2') + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC,'E2_NUM')

If empty(_nTitulo) .or. SF1->F1_TIPO == 'D' .or. !('/PAGANT/' $ upper(GetMv('LS_GERFINA')))  // /PAGANT/ - código para ativação da rotina de bloqueio de títulos
	Return()
EndIf
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 			 Verifica se existe alguma PA/NDF em aberto para o fornecedor
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_cQuery := "SELECT E2_MSFIL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VALOR, E2_SALDO, E2_EMISSAO, E2_TIPO"
_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
_cQuery += _cEnter + " WHERE E2_TIPO 		IN ('PA','NDF')"
_cQuery += _cEnter + " AND E2_SALDO 		> 0 "
_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + " AND E2_FORNECE 		= '" + SE2->E2_FORNECE + "'"
_cQuery += _cEnter + " AND E2_LOJA 			= '" + SE2->E2_LOJA + "'"
_cQuery += _cEnter + " AND E2_MATRIZ 		= '" + cFilAnt + "'"

MsAguarde( {|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SE2PA', .F., .F.)},"Procurando PA's e DNF's em aberto...")

TcSetField("SE2PA","E2_EMISSAO"	,"D"	,8	,0)

DbGoTop()
_aTitulos := {}
_cPA_NDF := ''
Do While !eof()
	_cPA_NDF += SE2PA->E2_MSFIL + ' ' + SE2PA->E2_PREFIXO + ' ' + SE2PA->E2_NUM + ' ' + SE2PA->E2_PARCELA + ' ' + SE2PA->E2_TIPO + ' '
	_cPA_NDF += dtoc(SE2PA->E2_EMISSAO) + ' ' + tran(SE2PA->E2_VALOR,'@EZ 99,999,999.99') + ' ' + tran(SE2PA->E2_SALDO,'@EZ 99,999,999.99') + _cEnter
	aAdd(_aTitulos,{SE2PA->E2_MSFIL, SE2PA->E2_PREFIXO, SE2PA->E2_NUM, SE2PA->E2_TIPO, dtoc(SE2PA->E2_EMISSAO), tran(SE2PA->E2_VALOR,'@E@Z 999,999,999.99'), tran(SE2PA->E2_SALDO,'@E@Z 999,999,999.99')})
	DbSkip()
EndDo

If !empty(_cPA_NDF)
	_lRet := .f.
	_cPA_NDF := 'Filial Prefixo Numero Parcela Tipo Emissão Valor Saldo' + _cEnter + _cEnter + _cPA_NDF + _cEnter + _cEnter
	_cPA_NDF += "O(s) título(s) não pode(rão) ser baixado(s) enquanto houverem títulos de PA's e/ou NDF's em aberto." + _cEnter
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//			 Lista títulos em aberto para o usuário que está classificando a pré-nota
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//MsgBox(_cPA_NDF ,"PA's e/ou NDF's em aberto",'ALERT')
	
	_aUsuario  := U_fUser(1, .t., __cUserId)		// usuário que está classificando a pré-nota
	_cCc       := alltrim(_aUsuario[1,14])			// email
	_cUsuario  := alltrim(_aUsuario[1,4])			// nome completo do usuário
	
	_aItenNF := {}
	
	DbSelectArea('SD1')
	DbSeek(xFilial('SD1') + SF1->F1_DOC + SF1->F1_SERIE +  SF1->F1_FORNECE + SF1->F1_LOJA,.f.)
	_cPedido := SD1->D1_PEDIDO
	Do While !eof() .and. xFilial('SD1') + SF1->F1_DOC + SF1->F1_SERIE +  SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE +  SD1->D1_FORNECE + SD1->D1_LOJA
		aAdd(_aItenNF,{SD1->D1_ITEM, SD1->D1_COD, Posicione('SB1',1,xFilial('SB1') + SD1->D1_COD,'B1_DESC'), alltrim(tran(SD1->D1_QUANT,'@E 999,999,999.99')), alltrim(tran(SD1->D1_VUNIT,'@E 999,999,999.99')), alltrim(tran(SD1->D1_TOTAL,'@E 999,999,999.99'))})
		DbSkip()
	EndDo
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// Procura aprovadores do pedido de compras, em primeiro nível, para informar do bloqueio e posterior desbloqueio
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_cQuery := "SELECT AL_USER, MIN(AL_NIVEL) NIVEL
	_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " SC7 (NOLOCK), " + RetSqlName('SAL') + " SAL (NOLOCK)"
	_cQuery += _cEnter + " WHERE C7_NUM 		= '" + _cPedido + "'"
	_cQuery += _cEnter + " AND AL_COD 			= C7_APROV"
	_cQuery += _cEnter + " AND C7_FILENT 		= '" + xFilial('SF1') + "'"
	_cQuery += _cEnter + " AND SAL.D_E_L_E_T_ 	= '' "
	_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ 	= '' "
	_cQuery += _cEnter + " GROUP BY AL_USER"
	_cQuery += _cEnter + " ORDER BY NIVEL"
	
	MsAguarde( {|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SC7PA', .F., .F.)},"Buscando aprovadores...")
	
	_cNivel  := SC7PA->NIVEL
	_cAprov1 := ''
	_cAprov2 := ''
	Do While !eof() .and. _cNivel == SC7PA->NIVEL
		_aAprov := U_fuser(1,.t.,SC7PA->AL_USER)
		If !empty(_aUsuario[1,14])
			_cAprov1 += alltrim(_aAprov[1,14]) + ';'
		EndIf
		_cAprov2 += alltrim(_aAprov[1,04]) + '; '
		DbSkip()
	EndDo
	DbCloseArea()
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//			 Bloqueia os títulos referentes à pré-nota classificada
	//			 grava nos títulos o email do classificador para avisá-lo de que o título foi liberado
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_cQuery := "UPDATE " + RetSqlName('SE2')
	_cQuery += _cEnter + " SET E2_HORASPB = 'BLOCK', E2_NUMTIT = '" + _cAprov1 + _cCC + "'"
	_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E2_FORNECE = '" + SE2->E2_FORNECE + "'"
	_cQuery += _cEnter + " AND E2_LOJA = '" + SE2->E2_LOJA + "'"
	_cQuery += _cEnter + " AND E2_FILIAL = ''"
	_cQuery += _cEnter + " AND E2_MSFIL = '" + xFilial('SF1') + "'"
	_cQuery += _cEnter + " AND E2_NUM = '" + SE2->E2_NUM + "'"
	_cQuery += _cEnter + " AND E2_PREFIXO = '" + SE2->E2_PREFIXO + "'"
	
	TcSqlExec(_cQuery)
	
	_cUsuarios := Substr(GetMv('LS_GERFINA'),2)
	_aUsuarios := {}
	Do While !empty(_cUsuarios)
		_cUser     := left(_cUsuarios,6)
		_aUsuario  := U_fUser(1, .t., _cUser)
		If !empty(_aUsuario)
			aAdd(_aUsuarios,aClone(_aUsuario))
		EndIf
		_cUsuarios := Substr(_cUsuarios,8)
	EndDo
	_cMsg    := "Solicitação de Liberação confirmada" + _cEnter + _cEnter
	_cMsg    += "Usuário(s) com poder de liberação " + _cEnter + _cEnter
	_cRecebe := ''
	For _nI := 1 to len(_aUsuarios)
		_cMsg    += alltrim(_aUsuarios[_nI,1,4]) + ' - ' + alltrim(_aUsuarios[_nI,1,13]) + ' ' + alltrim(_aUsuarios[_nI,1,12]) + _cEnter
		_cRecebe += alltrim(_aUsuarios[_nI,1,14]) + iif(_nI == len(_aUsuarios),'',';')
	Next
	
	MsAguarde({|| eMail()},'Enviando email...')
	
EndIf

SE2PA->(DbCloseArea())
DbSelectArea('SE2')

If GdFieldGet('D1_TES',1) $ '008/206/203'
	_cEmail := ''
	If SF1->F1_FILIAL $ '01/55'
		_cEmail := 'ebernardo@laselva.com.br;fmarrano@laselva.com.br'
	Else
		_cQuery := "SELECT TOP 1 CASE WHEN ISNULL(email,'helpdesk@laselva.com.br') = '' THEN 'helpdesk@laselva.com.br' ELSE ISNULL(email,'helpdesk@laselva.com.br') END AS EMAIL"
		_cQuery += _cEnter + " FROM SIGA.dbo.sigamat_copia "
		_cQuery += _cEnter + " WHERE M0_CODFIL = '" + SF1->F1_FILIAL + "'"
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'EMAIL', .F., .T.)
		_cEmail := EMAIL->EMAIL
		DbCloseArea()
	EndIf
	
	aRet := TCSPExec ("exec informatica.dbo.trigger_sf1_perdas",SF1->F1_FILIAL, dtos(date()), dtos(date()), _cEmail)
	
EndIf


Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SldSZ9Prv( lExclusao )
////////////////////////////////////

Local _cCnpj	:= ''
Local _nI		:= 0
Local aArea  	:= GetArea()

For _nI := 1 to len(aCols)
	
	If !GdDeleted(_nI) .and. Posicione('SF4',1, xFilial("SF4") + GdFieldGet('D1_TES',_nI),'F4_ESTOQUE') == "S";
	                   .And. alltrim(SF4->F4_CF) $ '1102,2102,3102,1910,2910,3910,1403,2403,3403,1949,2949,3949' // cfops de compra e bonificação com estoque proprio.
	
		DbSelectArea("SZ9")
		DbSetOrder(3)
		RecLock("SZ9",!DbSeek(xFilial("SZ9") +  GdFieldGet('D1_COD',_nI),.f.))
		SZ9->Z9_FILIAL	:= xFilial("SZ9")
		SZ9->Z9_PRODUTO	:= GdFieldGet('D1_COD',_nI)
		SZ9->Z9_QUANT   += GdFieldGet('D1_QUANT',_nI) * iif(lExclusao,-1,1)
		MsUnLock()

	EndIf	
	
Next

RestArea( aArea )
Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//			 Envia email para o responsável pela liberação dos títulos (financeiro) com cópia para o classficador (fiscal)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Email()
///////////////////////

Enter       := chr(13)
cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= 'siga@laselva.com.br'   ///_cCC //+ ';adalpiaz@laselva.com.br'	'siga@laselva.com.br'   ///
cAssunto  	:= "Solicitação para liberação de pagamento"

_cHtml	 	:= ""

_cHtml += '<html>'
_cHtml += '<head>'
_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">' + cAssunto + '</h3></font>'
_cHtml += '</head>'
_cHtml += '<body bgcolor = white text=black  >'
_cHtml += '<hr width=100% noshade>' + _cEnter


_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'

_cNota := " O usuário " + alltrim(_cUsuario) + ' (' + alltrim(cUserName)  + ") incluiu (classificou) a Nota Fiscal de entrada: " + _cEnter + _cEnter
_cNota += " Número " + SF1->F1_DOC + "     Série " + SF1->F1_SERIE + "    Emissão: " + dtoc(SF1->F1_EMISSAO) + _cEnter
_cNota += " Valor total:  R$  " + tran(SF1->F1_VALBRUT,'@E 999,999,999.99') + _cEnter
_cNota += " Filial:  " + cFilAnt + ' - ' + Posicione('SM0',1, '01' + cFilAnt,'M0_FILIAL') + _cEnter + _cEnter + _cEnter

_aSizes := {'06','10','40','10','10','10'}
_aAlign := {'','','','','RIGHT','RIGHT'}
_aLabel := {'Item','Produto','Descrição','Quantidade','Valor Unitário','Valor Total'}

If !empty(_cPedido)
	_cNota += " Esta nota refere-se ao pedido de compras número " + _cPedido + "." + _cEnter
EndIf

If !empty(_cAprov1)
	_cNota += " O pedido foi aprovado por: " + _cAprov2 + _cEnter
EndIf
_cNota += _cEnter

_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> ' + _cNota + '</font></b>'+ _cEnter+_cEnter

_cHtml += '</TABLE>'
_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
_cHtml += '	<TR VALIGN=TOP>                  '

For _nI := 1 To Len(_aSizes)
	_cHtml += '		<TD WIDTH=' + _aSizes[_nI] + '%>'
	_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nI]),'<h3 align = '+ _aAlign[_nI] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nI] + '<B></P></font> '
	_cHtml += '		</TD>'
	_cNota += _aLabel[_nI] + ' '
Next
_cNota += _cEnter + _cEnter

For _nI := 1 To Len(_aItenNF)
	
	_cHtml += '	<TR VALIGN=TOP>'
	
	For _nJ := 1 to len(_aItenNF[_nI])
		_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
		_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aItenNF[_nI,_nJ]+'</P></font>'
		_cHtml += '		</TD>'
		_cNota += _aItenNF[_nI,_nJ] + ' '
	Next
	_cNota += _cEnter
Next
_cNota += _cEnter

_cHtml += '	</TR>'
_cHtml += '</TABLE>' + _cEnter + _cEnter

_cTitNF :=  'O fornecedor ' + alltrim(Posicione('SA2',1,xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,'A2_NOME'))
_cTitNF += " possui Títulos de PA's e/ou NDF's em aberto, conforme relação abaixo." + _cEnter + _cEnter

_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> ' + _cTitNF + '</font></b>'
_cTitNF += _cEnter + _cEnter

_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
_cHtml += '	<TR VALIGN=TOP>                  '

_aSizes := {'10','10','10','10','10','10','10'}
_aAlign := {'','','','','','RIGHT','RIGHT'}
_aLabel := {'Filial','Prefixo','Título','Tipo','Emissão','Valor','Saldo'}

For _nI := 1 To Len(_aSizes)
	_cHtml += '		<TD WIDTH=' + _aSizes[_nI] + '%>'
	_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nI]),'<h3 align = '+ _aAlign[_nI] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nI] + '<B></P></font> '
	_cHtml += '		</TD>'
	_cTitNF += _aLabel[_nI] + ' '
Next
_cTitNF += _cEnter + _cEnter

For _nI := 1 To Len(_aTitulos)
	
	_cHtml += '	<TR VALIGN=TOP>'
	
	For _nJ := 1 to len(_aTitulos[_nI])
		_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
		_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aTitulos[_nI,_nJ]+'</P></font>'
		_cHtml += '		</TD>'
		_cTitNF += _aTitulos[_nI,_nJ] + ' '
	Next
	_cTitNF += _cEnter
Next
_cTitNF += _cEnter

_cHtml += '	</TR>'

_cHtml += '</TABLE>'
_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'

_cParcelas := "Parcelas: " + _cEnter+ _cEnter

_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> ' + _cParcelas+ '</font></b>'

_aSizes := {'10','10','10','10','10','10'}
_aAlign := {'','','','','','RIGHT'}
_aLabel := {'Filial','Prefixo','Título','Parcela','Vencimento','Valor'}
_aTitulos := {}

DbSelectArea('SE2')
DbSetOrder(6)
DbSeek(xFilial('SE2') + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DUPL + SF1->F1_PREFIXO ,.f.)
Do While !eof() .and. xFilial('SE2') + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DUPL + SF1->F1_PREFIXO == SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM + SE2->E2_PREFIXO
	_cParcelas += SE2->E2_MSFIL + ' ' + SE2->E2_PREFIXO + ' ' + SE2->E2_NUM + ' ' + SE2->E2_PARCELA + ' ' + dtoc(SE2->E2_VENCREA) + ' ' + tran(SE2->E2_VALOR,'@E@Z 999,999,999.99') + _cEnter
	aAdd(_aTitulos,{SE2->E2_MSFIL, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, dtoc(SE2->E2_VENCREA), tran(SE2->E2_VALOR,'@E@Z 999,999,999.99')})
	DbSkip()
EndDo
DbSetOrder(1)
_cParcelas += _cEnter + _cEnter

_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
_cHtml += '	<TR VALIGN=TOP>                  '

For _nI := 1 To Len(_aSizes)
	_cHtml += '		<TD WIDTH=' + _aSizes[_nI] + '%>'
	_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nI]),'<h3 align = '+ _aAlign[_nI] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nI] + '<B></P></font> '
	_cHtml += '		</TD>'
Next

For _nI := 1 To Len(_aTitulos)
	
	_cHtml += '	<TR VALIGN=TOP>'
	
	For _nJ := 1 to len(_aTitulos[_nI])
		_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
		_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aTitulos[_nI,_nJ]+'</P></font>'
		_cHtml += '		</TD>'
	Next
Next
_cHtml += '	</TR>'

_cHtml += '</TABLE>'
_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'


_cHtml += '</P>'

lConectou := .f.
lEnviado := .f.
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	_crecebe := 'adalpiaz@laselva.com.br'
	SEND MAIL FROM _cCC TO _cRecebe CC _cAprov1 + _cCC SUBJECT cAssunto BODY _cHtml RESULT lEnviado
	
	If !lEnviado
		GET MAIL ERROR cHtml
		Conout( "ERRO SMTP EM: " + cAssunto )
		_cAviso := "ERRO SMTP EM: " + cHtml + _cEnter + _cEnter + 'Para: ' + _cRecebe + _cEnter + 'Cópia para: ' + _cAprov1 + _cEnter + _cEnter
		_cAviso += _cPA_NDF + _cNota + _cParcelas
		If __cUserId $ GetMv('LA_PODER')
			Aviso('NÃO FOI POSSÍVEL ENVIAR E-MAIL', _cAviso ,{'OK'})
		EndIf
		
	Else
		DISCONNECT SMTP SERVER
		Conout( cAssunto )
		If __cUserId $ GetMv('LA_PODER')
			Aviso('E-MAIL ENVIADO COM SUCESSO', 'SUCESSO' ,{'OK'})
		EndIf
	Endif
	
Else
	
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
	If __cUserId $ GetMv('LA_PODER')
		MsgBox( "ERRO SMTP EM: " + cHtml + _cEnter + _cEnter + 'Para: ' + _cRecebe + _cEnter + 'Cópia para: ' + _cAprov1, 'NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL','ALERT')
	EndIf
Endif

Return
