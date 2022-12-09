#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"
#INCLUDE "FIVEWIN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIMR555
Rotina para impressão do relatório de Ordem de produção.

@author 	PPereira | Paulo Fernandes
@since 		19/11/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function HCIMR555()

Local _cPerg		:= "HCIMR555  "
Local aOrd    		:= {}//{"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
Local _cDestino		:= ""

Private cpTamanho	:= "G"
Private cpTitulo	:= "Gera Planilha de Ordem de Produção"
Private cpDesc1		:= "Este programa destina-se a geração de planilha de ordem de produção."
Private cpDesc2		:= ""
Private cpDesc3		:= ""
Private cpWnRel		:= "HCIMR555"
Private aReturn		:= {"Zebrado",1,"Administracao",2,2,1,"",1}
Private nLastKey	:= 00
Private lEnd		:= .F.
Private _lItemNeg	:= .F.


SA7->(dbSetOrder(1))

AjustaSX1(_cPerg)
If Pergunte(_cPerg,.T.)
	_cDestino	:= cGetFile(, "Selecione o Destino do arquivo",0,"",.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)
	If !Empty(_cDestino)
		Processa({||_fImpExc(_cDestino)},cpTitulo,,.T.)
	Endif
EndIf

Return()


//-------------------------------------------------------------------
/*/{Protheus.doc} _fImpExc
Função para realizar a impressão via Planilha em Excel.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fImpExc(_cDestino)

Local _cNumOp		:= ""
Local _cPrd			:= ""
Local _cNumOp
Local _cPedido
Local _cItemPV
Local _cCli
Local _cLoja
Local _cPedCli
Local _cItCli
Local _cEntreg
Local _cReduz
Local _cCodCli
Local _cDesCli
Local _cProd
Local _cnCTR:= 0
Local _aStruct := {}

Private _cTitulo	:= "Ordem de Produção"
Private _cAliasTmp	:= GetNextAlias()
Private _cArqTRAB	:= GetNextAlias()

Private aArray		:= {}
Private _nArqOk		:= 0
Private _nArqNOk	:= 0


_fQryTmp(_cArqTRAB)


ProcRegua(RecCount(_cArqTRAB))

(_cArqTRAB)->(dbGoTop())


If TCCanOpen(_cAliasTmp)
	MsErase(_cAliasTmp)
EndIf


cChaveArq := "C2_NUM+C2_ITEM+C2_SEQUEN+G2_OPERAC"
_aStruct := (_cArqTRAB)->(Dbstruct())
MsCreate(_cAliasTmp, _aStruct, 'TOPCONN' )
DbUseArea( .T., 'TOPCONN', _cAliasTmp, _cAliasTmp, .T., .F. )
IndRegua(_cAliasTmp,_cAliasTmp,cChaveArq)

DbSelectArea(_cArqTRAB)
While (_cArqTRAB)->(!Eof())
	
	IncProc("Processando Registros Temporarios "+Time())
	_cNumOp  := (_cArqTRAB)->C2_NUM
	_cPedido := (_cArqTRAB)->C2_PEDIDO
	_cItemPV := (_cArqTRAB)->C2_ITEMPV
	_cProd   := (_cArqTRAB)->C2_PRODUTO
	
	DbSelectArea("SC6")
	SC6->(DbSetorder(1))
	SC6->(DbSeek(xFilial("SC6")+_cPedido+_cItemPV+_cProd))
	_cCli    := SC6->C6_CLI
	_cLoja   := SC6->C6_LOJA
	_cPedCli := SC6->C6_PV
	_cItCli  := SC6->C6_ITEMCLI
	_cEntreg := SC6->C6_ENTREG
	DbSelectArea("SA1")
	SA1->(DbSetorder(1))
	SA1->(DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA))
	_cReduz := SA1->A1_NREDUZ
	While (_cArqTRAB)->C2_NUM == _cNumOp
		Reclock(_cAliasTmp,.T.)
		For _cnCTR:= 1 TO Len(_aStruct)
			(_cAliasTmp)->&(_aStruct[_cnCTR][01]) := (_cArqTRAB)->&(_aStruct[_cnCTR][01])
		Next
		(_cAliasTmp)->(MsUnlock())
		
		IF Empty((_cArqTRAB)->C2_PEDIDO)
			DbSelectArea("SA7")
			SA7->(DbSetorder(1))
			SA7->(DbSeek(xFilial("SA7")+_cCli+_cLoja+(_cArqTRAB)->C2_PRODUTO))
			Reclock(_cAliasTmp,.F.)
			(_cAliasTmp)->C2_PEDIDO  := _cPedido
			(_cAliasTmp)->C2_ITEMPV  := _cItemPV
			(_cAliasTmp)->C6_CLI     := _cCli
			(_cAliasTmp)->C6_LOJA    := _cLoja
			(_cAliasTmp)->C6_PV      := _cPedCli
			(_cAliasTmp)->C6_ITEMCLI := _cItCli
			(_cAliasTmp)->C6_ENTREG  := _cEntreg
			(_cAliasTmp)->A1_NREDUZ  := _cReduz
			(_cAliasTmp)->A7_CODCLI  := SA7->A7_CODCLI
			(_cAliasTmp)->A7_DESCCLI := SA7->A7_DESCCLI
			(_cAliasTmp)->(MsUnlock())
		EndIf
		DbSelectArea(_cArqTRAB)
		(_cArqTRAB)->(DbSkip())
	End
End



HCIEXCEL(_cDestino)

If TCCanOpen(_cAliasTmp)
	MsErase(_cAliasTmp)
EndIf


Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fCriaArq
Função para criar o arquivo XLS.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fCriaArq(_cNumOP,_cXml,_cDestino,_cAtribM)

Local _cArq		:= "OP_" + _cNumOP + "_" + DtoS(Date()) + "_" + _cAtribM + "_" + StrTran(Time(),":") + ".XLS"
Local _nHandle	:= 0
Local _lOk		:= .F.

_nHandle	:= FCreate(_cDestino+AllTRim(_cArq))
If _nHandle <= 0
	Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Não foi possível criar o arquivo no diretório especificado. Favor verificar as permissões do usuário ou caracteres especiais no nome do funcionário!") + CRLF + "Nomenclatura do arquivo a ser gerado: "+ _cArq,{"Ok"},2)
	_nArqNOk++
Else
	_lOk	:= .T.
	FWrite(_nHandle,_cXml)
	FClose(_nHandle)
EndIf

Return(_lOk)



//-------------------------------------------------------------------
/*/{Protheus.doc} _fQryTmp
Função para filtro da Ordem de Produção conforme preenchimento dos parâmetros.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fQryTmp(_cArqTRAB)

Local _cQuery	:= ""

_cQuery := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD , C2_PRODUTO, C2_LOCAL, C2_EMISSAO, C2_QUANT, C2_UM, C2_PEDIDO,C2_ITEMPV,C2_DATPRF, C2_ROTEIRO,"
_cQuery += "		G2_CODIGO,G2_OPERAC, G2_DESCRI, G2_RECURSO,G2_CTRAB,  G2_SETUP, G2_TEMPAD,"
_cQuery += "		C5_TIPO, C6_CLI, C6_LOJA, C6_PV, C6_ITEMCLI, C6_ENTREG, A1_NREDUZ, A7_CODCLI, A7_DESCCLI,"
_cQuery += " 		H1_DESCRI,"
_cQuery += " 		H8_HRINI AS HR_INIPREV, H8_DTINI AS DT_INIPREV, H8_HRFIM AS HR_FIMPREV,H8_DTFIM AS DT_FIMPREV,"
_cQuery += " 		H6_HORAINI AS HR_INIREAL, H6_DATAINI AS DT_INIREAL, H6_HORAFIN AS HR_FIMREAL, H6_DATAFIN AS DT_FIMREAL,"
_cQuery += " 		B1_DESC,"
_cQuery += " 		HB_NOME"
_cQuery += " FROM "+RetSqlName("SC2")+" SC2 "

_cQuery += " LEFT JOIN "+RetSqlName("SG2")+" SG2 "
_cQuery += " ON SG2.G2_FILIAL = '" + xFilial("SG2") + "' "
_cQuery += " AND SG2.G2_PRODUTO = SC2.C2_PRODUTO"
_cQuery += " AND SG2.G2_CODIGO = SC2.C2_ROTEIRO"
_cQuery += " AND SG2.D_E_L_E_T_ = '' "

_cQuery += " LEFT JOIN "+RetSqlName("SC6")+" SC6 "
_cQuery += " ON SC6.C6_FILIAL = '" + xFilial("SC6") + "' "
_cQuery += " AND SC6.C6_NUM = SC2.C2_PEDIDO "
_cQuery += " AND SC6.C6_ITEM = SC2.C2_ITEMPV "
//_cQuery += " AND SC6.C6_PRODUTO = SC2.C2_PRODUTO "
_cQuery += " AND SC6.D_E_L_E_T_ = ' ' "

_cQuery += " LEFT JOIN "+RetSqlName("SC5")+" SC5 "
_cQuery += " ON SC5.C5_FILIAL = '" + xFilial("SC5") + "' "
_cQuery += " AND SC5.C5_NUM = SC6.C6_NUM "
_cQuery += " AND SC5.D_E_L_E_T_ = ' ' "

_cQuery += " LEFT JOIN "+RetSqlName("SA1")+" SA1 "
_cQuery += " ON SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
_cQuery += " AND SA1.A1_COD = SC6.C6_CLI "
_cQuery += " AND SA1.A1_LOJA = SC6.C6_LOJA "
_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "

_cQuery += " LEFT JOIN "+RetSqlName("SA7")+" SA7 "
_cQuery += " ON SA7.A7_FILIAL = '" + xFilial("SA7") + "' "
_cQuery += " AND SA7.A7_CLIENTE = SC6.C6_CLI "
_cQuery += " AND SA7.A7_LOJA = SC6.C6_LOJA "
_cQuery += " AND SA7.A7_PRODUTO = SC6.C6_PRODUTO "
_cQuery += " AND SA7.D_E_L_E_T_ = ' ' "

_cQuery += " LEFT JOIN "+RetSqlName("SH1")+" SH1 "
_cQuery += " ON SH1.H1_FILIAL = '" + xFilial("SH1") + "' "
_cQuery += " AND SH1.H1_CODIGO = SG2.G2_RECURSO"
_cQuery += " AND SH1.D_E_L_E_T_ = '' "

_cQuery += " LEFT JOIN "+RetSqlName("SH8")+" SH8 "
_cQuery += " ON SH8.H8_FILIAL = '" + xFilial("SH8") + "' "
_cQuery += " AND SUBSTR(SH8.H8_OP,1,6) = SC2.C2_NUM"
_cQuery += " AND SUBSTR(SH8.H8_OP,7,2) = SC2.C2_ITEM"
_cQuery += " AND SUBSTR(SH8.H8_OP,9,3) = SC2.C2_SEQUEN"
_cQuery += " AND SH8.H8_ROTEIRO = SC2.C2_ROTEIRO"
_cQuery += " AND SH8.H8_OPER    = SG2.G2_OPERAC"
_cQuery += " AND SH8.D_E_L_E_T_ = ''  "

_cQuery += " LEFT JOIN "+RetSqlName("SH6")+" SH6 "
_cQuery += " ON SH6.H6_FILIAL =  '" + xFilial("SH6") + "' "
_cQuery += " AND SUBSTR(SH6.H6_OP,1,6) = SC2.C2_NUM"
_cQuery += " AND SUBSTR(SH6.H6_OP,7,2) = SC2.C2_ITEM"
_cQuery += " AND SUBSTR(SH6.H6_OP,9,3) = SC2.C2_SEQUEN"
_cQuery += " AND SH6.H6_PRODUTO = SC2.C2_PRODUTO"
_cQuery += " AND SH6.H6_OPERAC = SG2.G2_OPERAC"
_cQuery += " AND SH6.D_E_L_E_T_ = ''    "

_cQuery += " LEFT JOIN "+RetSqlName("SB1")+" SB1 "
_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "' "
_cQuery += " AND B1_COD = SC2.C2_PRODUTO "
_cQuery += " AND SB1.D_E_L_E_T_ = ' ' "

_cQuery += " LEFT JOIN "+RetSqlName("SHB")+" SHB "
_cQuery += " ON SHB.HB_FILIAL = '" + xFilial("SHB") + "' "
_cQuery += " AND SHB.HB_COD = SG2.G2_CTRAB"
_cQuery += " AND SHB.D_E_L_E_T_ = '' "


_cQuery += " WHERE "
_cQuery += " SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
if mv_par17=1
    _cQuery += " SC2.C2_QUANT<>SC2.C2_QUJE AND "
endif    
if mv_par17=2
    _cQuery += " SC2.C2_QUANT=SC2.C2_QUJE AND "
endif    
If	Len(ALLTRIM(MV_PAR01)) > TAMSX3("C2_NUM")[1]
	_cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN  >= '" + TRIM(mv_par01) + "' AND "
	_cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN  <= '" + TRIM(mv_par02) + "' AND "
Else
	_cQuery += "SC2.C2_NUM >= '" + mv_par01 + "' AND "
	_cQuery += "SC2.C2_NUM <= '" + mv_par02 + "' AND "
EndIf
_cQuery += " SC2.C2_EMISSAO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' AND"
_cQuery += " SC2.C2_DATPRF BETWEEN '" + Dtos(mv_par05) + "' AND '" + Dtos(mv_par06) + "' AND"
_cQuery += " SC6.C6_CLI BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND"
_cQuery += " SC2.C2_PRODUTO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND"
_cQuery += " SC2.C2_PEDIDO BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' AND"
_cQuery += " SG2.G2_RECURSO BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "' AND"
_cQuery += " SG2.G2_CTRAB BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "' AND SC2.C2_PEDIDO != ' ' "

_cQuery += " UNION "

_cQuery += "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD , C2_PRODUTO, C2_LOCAL, C2_EMISSAO, C2_QUANT, C2_UM, C2_PEDIDO,C2_ITEMPV,C2_DATPRF, C2_ROTEIRO,"
_cQuery += "		G2_CODIGO, G2_OPERAC, G2_DESCRI, G2_RECURSO,G2_CTRAB,  G2_SETUP, G2_TEMPAD,"
_cQuery += "		'' AS C5_TIPO, '' AS C6_CLI, '' AS C6_LOJA, '' AS C6_PV, '' AS C6_ITEMCLI, '' AS C6_ENTREG, '' AS A1_NREDUZ, '' AS A7_CODCLI, '' AS A7_DESCCLI,"
_cQuery += " 		H1_DESCRI,"
_cQuery += " 		H8_HRINI AS HR_INIPREV, H8_DTINI AS DT_INIPREV, H8_HRFIM AS HR_FIMPREV,H8_DTFIM AS DT_FIMPREV,"
_cQuery += " 		H6_HORAINI AS HR_INIREAL, H6_DATAINI AS DT_INIREAL, H6_HORAFIN AS HR_FIMREAL, H6_DATAFIN AS DT_FIMREAL,"
_cQuery += " 		B1_DESC,"
_cQuery += " 		HB_NOME"
_cQuery += " FROM "+RetSqlName("SC2")+" SC2 "

_cQuery += " LEFT JOIN "+RetSqlName("SG2")+" SG2 "
_cQuery += " ON SG2.G2_FILIAL = '" + xFilial("SG2") + "' "
_cQuery += " AND SG2.G2_PRODUTO = SC2.C2_PRODUTO"
_cQuery += " AND SG2.G2_CODIGO = SC2.C2_ROTEIRO"
_cQuery += " AND SG2.D_E_L_E_T_ = '' "


_cQuery += " LEFT JOIN "+RetSqlName("SH1")+" SH1 "
_cQuery += " ON SH1.H1_FILIAL = '" + xFilial("SH1") + "' "
_cQuery += " AND SH1.H1_CODIGO = SG2.G2_RECURSO"
_cQuery += " AND SH1.D_E_L_E_T_ = '' "

_cQuery += " LEFT JOIN "+RetSqlName("SH8")+" SH8 "
_cQuery += " ON SH8.H8_FILIAL = '" + xFilial("SH8") + "' "
_cQuery += " AND SUBSTR(SH8.H8_OP,1,6) = SC2.C2_NUM"
_cQuery += " AND SUBSTR(SH8.H8_OP,7,2) = SC2.C2_ITEM"
_cQuery += " AND SUBSTR(SH8.H8_OP,9,3) = SC2.C2_SEQUEN" 
_cQuery += " AND SH8.H8_ROTEIRO = SC2.C2_ROTEIRO"
_cQuery += " AND SH8.H8_OPER = SG2.G2_OPERAC"
_cQuery += " AND SH8.D_E_L_E_T_ = ''  "

_cQuery += " LEFT JOIN "+RetSqlName("SH6")+" SH6 "
_cQuery += " ON SH6.H6_FILIAL =  '" + xFilial("SH6") + "' "
_cQuery += " AND SUBSTR(SH6.H6_OP,1,6) = SC2.C2_NUM"
_cQuery += " AND SUBSTR(SH6.H6_OP,7,2) = SC2.C2_ITEM"
_cQuery += " AND SUBSTR(SH6.H6_OP,9,3) = SC2.C2_SEQUEN"
_cQuery += " AND SH6.H6_PRODUTO = SC2.C2_PRODUTO"
_cQuery += " AND SH6.H6_OPERAC = SG2.G2_OPERAC"
_cQuery += " AND SH6.D_E_L_E_T_ = ''    "

_cQuery += " LEFT JOIN "+RetSqlName("SB1")+" SB1 "
_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "' "
_cQuery += " AND B1_COD = SC2.C2_PRODUTO "
_cQuery += " AND SB1.D_E_L_E_T_ = ' ' "

_cQuery += " LEFT JOIN "+RetSqlName("SHB")+" SHB "
_cQuery += " ON SHB.HB_FILIAL = '" + xFilial("SHB") + "' "
_cQuery += " AND SHB.HB_COD = SG2.G2_CTRAB"
_cQuery += " AND SHB.D_E_L_E_T_ = '' "


_cQuery += " WHERE "
_cQuery += " SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
if mv_par17=1
    _cQuery += " SC2.C2_QUANT<>SC2.C2_QUJE AND "
endif    
if mv_par17=2
    _cQuery += " SC2.C2_QUANT=SC2.C2_QUJE AND "
endif    
If	Len(ALLTRIM(MV_PAR01)) > TAMSX3("C2_NUM")[1]
	_cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN  >= '" + TRIM(mv_par01) + "' AND "
	_cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN  <= '" + TRIM(mv_par02) + "' AND "
Else
	_cQuery += "SC2.C2_NUM >= '" + mv_par01 + "' AND "
	_cQuery += "SC2.C2_NUM <= '" + mv_par02 + "' AND "
EndIf
_cQuery += " SC2.C2_EMISSAO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' AND"
_cQuery += " SC2.C2_DATPRF BETWEEN '" + Dtos(mv_par05) + "' AND '" + Dtos(mv_par06) + "' AND"
_cQuery += " SC2.C2_PRODUTO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND"
_cQuery += " SC2.C2_PEDIDO BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' AND"
_cQuery += " SG2.G2_RECURSO BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "' AND"
_cQuery += " SG2.G2_CTRAB BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "' AND SC2.C2_PEDIDO = ' ' "

//Ordem
_cQuery += " ORDER BY C2_NUM,C2_ITEM,C2_SEQUEN,G2_OPERAC"

TcQuery _cQuery New Alias &(_cArqTRAB)

TCSetField (_cArqTRAB, "C2_DATPRF"	, "D", TAMSX3("C2_DATPRF")[1]	, TAMSX3("C2_DATPRF")[1] )
TCSetField (_cArqTRAB, "C6_ENTREG"	, "D", TAMSX3("C6_ENTREG")[1]	, TAMSX3("C6_ENTREG")[1] )
TCSetField (_cArqTRAB, "C2_EMISSAO", "D", TAMSX3("C2_EMISSAO")[1]	, TAMSX3("C2_EMISSAO")[1] )
TCSetField (_cArqTRAB, "DT_INIPREV", "D", TAMSX3("C2_EMISSAO")[1]	, TAMSX3("C2_EMISSAO")[1] )
TCSetField (_cArqTRAB, "DT_FIMPREV", "D", TAMSX3("C2_EMISSAO")[1]	, TAMSX3("C2_EMISSAO")[1] )
TCSetField (_cArqTRAB, "DT_INIREAL", "D", TAMSX3("C2_EMISSAO")[1]	, TAMSX3("C2_EMISSAO")[1] )
TCSetField (_cArqTRAB, "DT_FIMREAL", "D", TAMSX3("C2_EMISSAO")[1]	, TAMSX3("C2_EMISSAO")[1] )


Return()


//-------------------------------------------------------------------
/*/{Protheus.doc} AjustaSX1
Função para ajuste das perguntas do relatório.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function AjustaSX1(_cPerg)

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

aHelpPor := {'Nr OP inicial a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Nr OP inicial a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Nr OP inicial a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"01","O.P. De ?","¿De O.P. ?","From Product.Order ?","mv_ch1","C",13,0,0,"G","","SC2","","","mv_par01","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Nr OP final a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Nr OP final a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Nr OP final a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"02","O.P. Ate ?","¿A O.P. ?","To Product.Order ?","mv_ch2","C",13,0,0,"G","","SC2","","","mv_par02","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Data Emissão inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Data Emissão inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Data Emissão inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"03","Data Emissão De ?","¿De Fecha ?","From Date ?","mv_ch3","D",8,0,0,"G","","","","","mv_par03","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Data Emissão final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Data Emissão final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Data Emissão final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"04","Data Emissão Ate ?","¿A Fecha ?","To Date ?","mv_ch4","D",8,0,0,"G","","","","","mv_par04","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Data Entrega inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Data Entrega inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Data Entrega inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"05","Data Entrega De ?","¿De Fecha ?","From Date ?","mv_ch5","D",8,0,0,"G","","","","","mv_par05","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Data Emissão final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Data Emissão final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Data Emissão final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"06","Data Entrega Ate ?","¿A Fecha ?","To Date ?","mv_ch6","D",8,0,0,"G","","","","","mv_par06","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Cliente inicial a ser considerado  ','na filtragem da ordem de produção.  '}
aHelpEng := {'Cliente inicial a ser considerado  ','na filtragem da ordem de produção.  '}
aHelpSpa := {'Cliente inicial a ser considerado  ','na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"07","Cliente De ?","¿Produto De ?","Produto De ?","mv_ch7","C",06,0,0,"G","","SA1","","","mv_par07","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Cliente final a ser considerado  ','na filtragem da ordem de produção.  '}
aHelpEng := {'Cliente final a ser considerado  ','na filtragem da ordem de produção.  '}
aHelpSpa := {'Cliente final a ser considerado  ','na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"08","Cliente Ate ?","¿Produto Ate ?","Produto Ate ?","mv_ch8","C",06,0,0,"G","","SA1","","","mv_par08","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Produto inicial a ser considerado  ','na filtragem da ordem de produção.  '}
aHelpEng := {'Produto inicial a ser considerado  ','na filtragem da ordem de produção.  '}
aHelpSpa := {'Produto inicial a ser considerado  ','na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"09","Produto De ?","¿Produto De ?","Produto De ?","mv_ch9","C",15,0,0,"G","","SB1","","","mv_par09","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Produto final a ser considerado  ','na filtragem da ordem de produção.  '}
aHelpEng := {'Produto final a ser considerado  ','na filtragem da ordem de produção.  '}
aHelpSpa := {'Produto final a ser considerado  ','na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"10","Produto Ate ?","¿Produto Ate ?","Produto Ate ?","mv_ch10","C",15,0,0,"G","","SB1","","","mv_par10","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Pedido de Venda inicial a ser   ','considerado na filtragem da ordem de produção.  '}
aHelpEng := {'Pedido de Venda inicial a ser   ','considerado na filtragem da ordem de produção.  '}
aHelpSpa := {'Pedido de Venda inicial a ser   ','considerado na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"11","Pedido De ?","¿Pedido De ?","Pedido De ?","mv_ch11","C",06,0,0,"G","","SC5","","","mv_par11","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Pedido de Venda final a ser   ','considerado na filtragem da ordem de produção.  '}
aHelpEng := {'Pedido de Venda final a ser   ','considerado na filtragem da ordem de produção.  '}
aHelpSpa := {'Pedido de Venda final a ser   ','considerado na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"12","Pedido Ate ?","¿Pedido Ate ?","Pedido Ate ?","mv_ch12","C",06,0,0,"G","","SC5","","","mv_par12","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Recurso inicial a ser considerado  ',' na filtragem da ordem de produção.  '}
aHelpEng := {'Recurso inicial a ser considerado  ',' na filtragem da ordem de produção.  '}
aHelpSpa := {'Recurso inicial a ser considerado  ',' na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"13","Recurso De ?","¿Recurso De?","Recurso De ?","mv_ch13","C",06,0,0,"G","","SH1","","","mv_par13","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Recurso final a ser considerado  ',' na filtragem da ordem de produção.  '}
aHelpEng := {'Recurso final a ser considerado  ',' na filtragem da ordem de produção.  '}
aHelpSpa := {'Recurso final a ser considerado  ',' na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"14","Recurso Ate ?","¿Recurso Ate?","Recurso Ate ?","mv_ch14","C",06,0,0,"G","","SH1","","","mv_par14","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Centro de Trabalho inicial a ser considerado  ',' na filtragem da ordem de produção.  '}
aHelpEng := {'Centro de Trabalho inicial a ser considerado  ',' na filtragem da ordem de produção.  '}
aHelpSpa := {'Centro de Trabalho inicial a ser considerado  ',' na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"15","C.Trabalho De ?","¿C.Trabalho De?","C.Trabalho De ?","mv_ch15","C",06,0,0,"G","","SHB","","","mv_par15","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Centro de Trabalho final a ser considerado  ',' na filtragem da ordem de produção.  '}
aHelpEng := {'Centro de Trabalho final a ser considerado  ',' na filtragem da ordem de produção.  '}
aHelpSpa := {'Centro de Trabalho final a ser considerado  ',' na filtragem da ordem de produção.  '}
PutSx1(_cPerg,"16","C.Trabalho Ate ?","¿C.Trabalho Ate?","C.Trabalho Ate ?","mv_ch16","C",06,0,0,"G","","SHB","","","mv_par16","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIEXCEL  ºAutor  ³Microsiga           º Data ³  11/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function HCIEXCEL(cDestino)
Local oExcel
Local oExcelApp
Local aDados   		:= {}
Local cArq	   		:= ""
Local nI       		:= 0
Local nX       		:= 0
Local cDirTmp  		:= "d:\temp"
Local cPlan			:= ""
Local cTab			:= ""
Local aColumns		:= {"Nro. OP","ITEM OP","Seq. OP"  ,"Produto"   ,"Descrição Produto","Local"   ,"Emissão"   ,"Qtde.Prod.","UM"   ,"PV Interno","Item PV"  ,"Cliente","Loja Cliente","Nome Cliente","PV Cliente","Item PV Cliente","Entrega"  ,"Prod.Cliente","Desc.Prod.Cliente","Operação" ,"Desc.Operação","Recurso"   ,"Desc.Recurso","C.Trabalho","Descr.C.Trabalho","Tempo Setup","Tempo Padrão","Dt.Inic.Prev","Hr.Inic.Prev","Dt.Final Prev","Hr.Final Prev","Dt.Inic.Real","Hr.Inic.Real","Dt.Final Real","Hr.Final Real","Roteiro"}
Local aCampos		:= {"C2_NUM" ,"C2_ITEM","C2_SEQUEN","C2_PRODUTO","B1_DESC"          ,"C2_LOCAL","C2_EMISSAO","C2_QUANT"  ,"C2_UM","C2_PEDIDO" ,"C2_ITEMPV","C6_CLI" ,"C6_LOJA"     ,"A1_NREDUZ"   ,"C6_PV"     ,"C6_ITEMCLI"     ,"C6_ENTREG","A7_CODCLI"   ,"A7_DESCCLI"       ,"G2_OPERAC","G2_DESCRI"    ,"G2_RECURSO","H1_DESCRI"   ,"G2_CTRAB"  ,"HB_NOME"         ,"G2_SETUP"   ,"G2_TEMPAD"   ,"DT_INIPREV"  ,"HR_INIPREV"  ,"DT_FIMPREV"   ,"HR_FIMPREV"   ,"DT_INIREAL"  ,"HR_INIREAL"  ,"DT_FIMREAL"   ,"HR_FIMREAL"   ,"C2_ROTEIRO"}
Local lDataCpo		:=.F.
Local lStringCpo	:=.F.
//Cria objeto
oExcel := FWMSEXCEL():New()

//Inclui nova Planilha no Arquivo
cPlan	:= "Ordem de Produção"
oExcel:AddworkSheet(cPlan)

//Adiciona Tabela
cTab	:= "Planilha gerada por "+Alltrim(cUserName)+" em "+DtoC(Date())+" as "+Time()
oExcel:AddTable(cPlan,cTab)

// Cria Cabecalho das informações
dbSelectArea("SX3")
dbSetOrder(2)						// X3_CAMPO
For nI := 1 To Len(aColumns)
	oExcel:AddColumn(cPlan,cTab,aColumns[nI],1,1)
Next nI

DbSelectArea(_cAliasTmp)
(_cAliasTmp)->(dbGoTop())

ProcRegua(RecCount(_cAliasTmp))

//Cria linhas com os dados
While (_cAliasTmp)->(!EOF())
	
	IncProc("Gerando o Arquivo de Saida Excel "+Time())
	aDados	:= {}
	
	For nX := 1 To Len(aCampos)
		lDataCpo:=.F.
		lStringCpo:=.F.
		
		SX3->(dbSeek(aCampos[nX]))
		If aCampos[nX] $ "DT_INIPREV|DT_FIMPREV|DT_INIREAL|DT_FIMREAL"
			lDataCpo:=.T.
		Endif
		If aCampos[nX] $ "HR_INIPREV|HR_FIMPREV|HR_INIREAL|HR_FIMREAL"
			lStringCpo:=.T.
		Endif
		aadd(aDados, IF(SX3->X3_TIPO=="C" .Or. lStringCpo,(_cAliasTmp)->(FieldGet(FieldPos(aCampos[nX]))),IF(SX3->X3_TIPO=="D" .Or. lDataCpo,DTOC((_cAliasTmp)->(FieldGet(FieldPos(aCampos[nX])))),STR((_cAliasTmp)->(FieldGet(FieldPos(aCampos[nX]))),SX3->X3_TAMANHO,SX3->X3_DECIMAL))))
	Next nX
	
	oExcel:AddRow(cPlan,cTab,aDados)
	
	(_cAliasTmp)->(dbSkip())
End

IncProc("Transferindo o Arquivo para Pasta "+Time())

oExcel:Activate()

//Cria nome para arquivo
cArq := CriaTrab( NIL, .F. ) + ".xml"
cArq := "Matriz_de_Etiquetas_" + DtoS(Date()) + "_" + StrTran(Time(),":") + ".XML"
oExcel:GetXMLFile( cArq )

//Copia arquivo para diretório temporário do usuário
//e realiza abertura do mesmo
If __CopyFile( cArq, cDestino+"\"+ cArq )
	ApMsgInfo( "Planilha gerada as "+Time()+ " na pasta "+cDestino )
Else
	MsgInfo( "Arquivo não copiado para temporário do usuário." )
Endif

Return
