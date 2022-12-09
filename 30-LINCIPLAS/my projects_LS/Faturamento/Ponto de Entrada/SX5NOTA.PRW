#INCLUDE "RWMAKE.CH"
#INCLUDE "protheus.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SX5NOTA  ³ Autor ³ Antonio Carlos         ³ Data ³ 19/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ "Filtro nas series da Nota Fiscal                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Preparacao da Nota Fiscal  (MATA460/MATA103/MATA140)        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SX5NOTA()

Local aArea	:= GetArea()
Local _cNota:=""
// ATUALIZA A TABELA DE NOTAS FISCAIS PARA CNPJs QUE TEM MAIS DE UMA FILIAL
               
If FunName(0) $ "MATA103/MATA140" .and. alltrim(cEspecie) == 'PP' 
	Return(alltrim(SX5->X5_CHAVE) == 'Y')
ElseIf FunName(0) $ "MATA410/MATA460A/MATA461" .and. right(SC5->C5_CONDPAG,1) == 'X' 
	Return(alltrim(SX5->X5_CHAVE) == 'X')	
ElseIf cFilAnt == 'C4'
	Return(.t.)
ElseIf alltrim(SX5->X5_CHAVE) $ 'X/Y'
	Return(.F.)
EndIf

cNfSaida    := Alltrim(GetMv("MV_SERIE02")) //Serie NF de Saida
cNfEntrada  := Alltrim(GetMv("MV_SERIE01")) //Serie NF de Entrada
DbSelectArea('SM0')
_cCnpj := SM0->M0_CGC
Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
_cFiliais := ''
_cQueryF  := ''
DbGotop()
Do While _cCnpj == SM0->M0_CGC .AND. !eof()
	
	_cQueryF += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(NFE_ID)),9))+1)),9) NOTA"
	_cQueryF += _cEnter + "FROM SPED050 (NOLOCK)"
	_cQueryF += _cEnter + "WHERE ID_ENT = dbo.FN_GETIDSPED" +" ('" + SM0->M0_CODFIL + "')"
	_cQueryF += _cEnter + "AND LEFT(NFE_ID,1) = '" + GetMv('FS_LASSER') +"'"
	_cQueryF += _cEnter + "AND D_E_L_E_T_ = ''"
	_cQueryF += _cEnter + "AND LEN(RTRIM(NFE_ID))>9"
	_cQueryF += _cEnter + "AND DATE_NFE > '201303'"
	If SM0->M0_CODFIL == 'GE'
		_cQueryF += _cEnter + " AND NFE_ID < '8  000045000' "
	EndIf
	_cQueryF += _cEnter + "UNION"
	
	_cFiliais += SM0->M0_CODFIL + ','
	DbSkip()
EndDo
Set Filter To
DbSeek(cEmpAnt+cFilAnt)
_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')

_cSeries := strtran(cNfSaida + cNfEntrada,'--','-')
_cSeries := FormatIn(substr(left(_cSeries,len(_cSeries)-1),2),'-')

_cQuery2 := _cEnter + "SELECT MAX(NOTA) NOTA"
_cQuery2 += _cEnter + "FROM"
_cQuery2 += _cEnter + "("
_cQuery2 += _cQueryF
_cQuery2 += _cEnter + "SELECT TOP 1 RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(F2_DOC)),9))+1)),9) NOTA"
_cQuery2 += _cEnter + "FROM " + RetSqlName('SF2') + " SF2 (NOLOCK)"
_cQuery2 += _cEnter + "WHERE F2_FILIAL IN " + _cfiliais
_cQuery2 += _cEnter + "AND F2_SERIE = '" + GetMv('FS_LASSER') + "'"
_cQuery2 += _cEnter + "AND F2_EMISSAO > '201303'"
If SM0->M0_CODFIL == 'GE'
	_cQuery2 += _cEnter + " AND F2_DOC < '000045000' "
EndIf
_cQuery2 += _cEnter + " AND len(F2_DOC) = 9 "
_cQuery2 += _cEnter + " AND F2_PDV = '' "
_cQuery2 += _cEnter + " AND SF2.D_E_L_E_T_ = '' "
_cQuery2 += _cEnter + " GROUP BY SF2.D_E_L_E_T_, F2_DOC "
_cQuery2 += _cEnter + " ORDER BY F2_DOC DESC"

_cQuery2 += _cEnter + ") A"

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery2),"_NF", .T., .T.)
_cNota := _NF->NOTA
DbCloseArea()
_cNota := iif(empty(_cNota),'000000001',_cNota)

_cQuery := "UPDATE " + RetSqlName('SX5')
_cQuery += _cEnter   + "SET X5_DESCRI = informatica.dbo.Ti_StrZero('" + _cNota + "'+0,9), X5_DESCSPA ='" + _cNota + "', X5_DESCENG ='" + _cNota + "'"
_cQuery += _cEnter   + "WHERE X5_TABELA = '01'"
_cQuery += _cEnter   + "AND X5_FILIAL IN " + _cFiliais
_cQuery += _cEnter   + "AND X5_CHAVE = '" + GetMv('FS_LASSER') + "'"
_cQuery += _cEnter   + "AND D_E_L_E_T_ = ''"


nResult := TcSqlExec(_cQuery)

_lRet       := .f.

DbSelectArea('SX5')

If FunName(0) $ "MATA103/MATA140" //Geracao da NF de Entrada
	
	If alltrim(cEspecie) == 'SPED' .and. '-' + Alltrim(SX5->X5_CHAVE) + '-' == '-9-' .or. (__cUserId $ GetMv('LA_PODER') .and. alltrim(SX5->X5_CHAVE) == 'ZZZ')
		_lRet := .T.
	ElseIf alltrim(cEspecie) <> 'SPED'
		If '-' + Alltrim(SX5->X5_CHAVE) + '-' $ '-' + Alltrim(GetMv("MV_SERIE01")) + '-' .or. (__cUserId $ GetMv('LA_PODER') .and. alltrim(SX5->X5_CHAVE) == 'ZZZ')
			_lRet := .T.
		EndIf
	EndIf
	
Else
	
	If '-' + Alltrim(SX5->X5_CHAVE) + '-' $ '-' + Alltrim(GetMv("MV_SERIE02")) + '-' .or. (__cUserId $ GetMv('LA_PODER') .and. alltrim(SX5->X5_CHAVE) == 'ZZZ') //Geracao da NF de Saida
		_lRet := .T.
	EndIf
	
EndIf

RestArea(aArea)

Return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | NFSVLNUM º Autor ³Fabiano Pereira     º Data ³  14/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para validacao do numero de nota fiscal digitado na 	  º±±
±±º          ³   geracao de nota fiscal de saida.					      º±±
±±º          ³                                                    	  	  º±±
±±º          ³Retorno Logio .T. -> Numero valido                   	  	  º±±
±±º          ³              .F. -> Numero invalido                	  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - Frigorifico Mercosul	                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// *********************************************************************
User Function _MTVALRPS() //NFSVLNUM()
// *********************************************************************
Local _lRet		:=	.T.
Local _cNumero	:=	ParamIxb[1]
//Local _cSerie	:=	ParamIxb[2]

/*
If alltrim(_cSerie) == '9' .and. alltrim(cEspecie) <> 'SPED'
MsgBox('Espécie do documento informada inválida. Alterado automaticamente para espécie SPED')
cEspecie := 'SPED '
EndIf
*/
alert('teste')

Return(_lRet)
