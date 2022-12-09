#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TK260ROT º Autor ³ Luiz Alberto     º Data ³ 29/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Substitui Chamada de Tela de Contatos no Browse do Cliente
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   
User Function TK260ROT                         
Local aRetorno := {}

//aadd(aRetorno,{"Contagem *",'U_FContPROS',0,4})
aadd(aRetorno,{"Relatorio",'U_RelPros',0,4})
aadd(aRetorno,{"Tornar Cliente", "U_MPROSP" , 0, 3} )

Return(aRetorno)                          

/*
User Function FContPROS()
Local aArea := GetArea()
Local oObjBrw := GetObjBrow()

If Empty(oObjBrw:OFWFILTER:AFILTER)
	MsgStop("Atenção a Contagem só Será Executada se a Tela Possuir Algum tipo de Filtro !")
	RestArea(aArea)
	Return .t.
Endif

Processa( {|| ContaRegs(oObjBrw,Alias())   },"Aguarde Contado Registros ..." )

RestArea(aArea)
Return .t.

Static Function ContaRegs(oObjBrowse,cAlias)
Local aArea    := getArea()
Local bFiltro  := nil
Local lFat     := .F.
Local cFiltro  := oObjBrowse:oFWFilter:GetExprADVPL()
Local cFiltOld := &(cAlias)->( dbFilter() )
Local lRet     := .T.
Local aRetorno := {}
Local cParams  := ""


//Restaura filtros anteriores
If !Empty( cFiltro )
	bFiltro  := &('{||' + cFiltro + '}')
	&(cAlias)->(dbSetFilter(bFiltro, cFiltro))
	lFat := !(&(cAlias)->(Eof()))
Else
	&(cAlias)->(dbClearFilter())
EndIf
nContagem := 0
If lFat	// Existe Filtro
	&(cAlias)->(dbGoTop())	
	Count To nContagem
	&(cAlias)->(dbGoTop())	
Endif

cFiltros := 'Expressão: ' + cFiltro + CRLF + CRLF
For nFiltro := 1 To Len(oObjBrowse:OFWFILTER:AFILTER)
	If oObjBrowse:OFWFILTER:AFILTER[nFiltro,6]
		cFiltros += 'Filtro (' + Str(nFiltro,2) + ') ' + oObjBrowse:OFWFILTER:AFILTER[nFiltro][1] + CRLF
	Endif
Next

Aviso("Filtros","Contagem Executado com os Filtros: "+CRLF+CRLF+cFiltros+CRLF+"Contagem do Filtro Atual: " + Str(nContagem,6) + " Registro(s) Contado(s)...",{"Ok"},3)

RestArea(aArea)
Return .t.

*/

User Function MPROSP()
Local nOpca := 0 
Local aParam := {}
Local cProsp:= SUS->US_COD 
Local cLoja:= SUS->US_LOJA

nReg := Recno()
SUS->(dbGoTo(nReg))
                    
//adiciona codeblock a ser executado no inicio, meio e fim
aAdd( aParam, {|| U_MPROSP1() } )
aAdd( aParam, {|| U_M030INC() } ) // Processa Ponto de Entrada Para Replicar


if SUS->US_STATUS == "6"     // Status não pode ser = CLIENTE
   MsgAlert("Este Prospect já se tornou cliente!")
   return .F.
endif

nOpc := AxInclui("SA1",,3,,"U_MPROSP1",,,,"U_M030INC")
If nOpc = 1
	// Verifica se existem Orçamentos em Aberto com o Cliente ainda com Status de Prospect e Converte todos para o Novo
	// Codigo de Cliente.

	c_UPDQry  := "  UPDATE "+RETSQLNAME("SUA")"
	c_UPDQry  += "  SET UA_CLIENTE  = '"+SA1->A1_COD+"', "
	c_UPDQry  += "      UA_LOJA     = '"+SA1->A1_LOJA+"', "
	c_UPDQry  += "      UA_XCLIENT  = '"+SA1->A1_COD+"', "
	c_UPDQry  += "      UA_XLOJAEN  = '"+SA1->A1_LOJA+"', "
	c_UPDQry  += "      UA_CLIPROS  = '1', "
	c_UPDQry  += "      UA_PROSPEC  = 'F' "
	c_UPDQry  += "	WHERE UA_CLIPROS = '2' "                                                         
	c_UPDQry  += "  AND UA_CLIENTE = '"+cProsp+"'"
	c_UPDQry  += "  AND UA_LOJA = '"+cLoja+"'"
	c_UPDQry  += "  AND D_E_L_E_T_='' "
	                                           
	TcSqlExec(c_UPDQry)
		
   	// mudo o US_STATUS para cliente (6) e faço as amarrações de contatos com o novo cliente.
   	DbselectArea("SUS")
   	Posicione("SUS",1,xFilial("SUS")+cProsp+cLoja,"US_LOJA")
   	RecLock("SUS",.f.)
	SUS->US_STATUS := "6"
	SUS->US_CODCLI := SA1->A1_COD
	SUS->US_LOJACLI := SA1->A1_LOJA
	SUS->US_DTCONV := dDatabase //database do sistema
   	MsUnlock()
   
Endif 

Return .T.

//executa antes da transação
USER Function MPROSP1()
Local aArea := GetArea()

cCodCli := Space(06)
cLojCli := Space(02)

If SUS->(FieldPos("US_FILREL")) > 0 .And. !Empty(SUS->US_FILREL)	// Se Houver Relação com Outro Cliente (Filial) Então Irá Alterar o Código do Cliente

	cQuery := "SELECT MAX(A1_LOJA) as RESULT "
	cQuery += "FROM "+RetSqlName('SA1')+" WHERE A1_COD = '"+SUS->US_FILREL+"' AND D_E_L_E_T_ = '' "
	TcQuery cQuery NEW ALIAS 'RES'

	cCodCli := SUS->US_FILREL
	cLojCli	:= Soma1(RES->RESULT,2)
	
	RES->(dbCloseArea())
	RestArea(aArea)
	
Endif

//todos os campos que quero que retorne no cadastro
M->A1_FILIAL     := SUS->US_FILIAL
If !Empty(cCodCli)
	M->A1_COD		:= cCodCli
	M->A1_LOJA     	:= cLojCli
Endif
M->A1_NOME   		:= SUS->US_NOME
M->A1_NREDUZ 		:= SUS->US_NREDUZ 
M->A1_TIPO 			:= SUS->US_TIPO
M->A1_END 			:= SUS->US_END
M->A1_EST 			:= SUS->US_EST
M->A1_BAIRRO 		:= SUS->US_BAIRRO
M->A1_CEP 			:= SUS->US_CEP
M->A1_DDI 			:= SUS->US_DDI
M->A1_DDD 			:= SUS->US_DDD
M->A1_TEL 			:= SUS->US_TEL
M->A1_MUN 			:= SUS->US_MUN
M->A1_CGC 			:= SUS->US_CGC
M->A1_INSCR			:= SUS->US_INSCR
M->A1_REGIAO		:= SUS->US_REGIAO
M->A1_PAIS			:= SUS->US_PAIS
M->A1_COD_MUN		:= SUS->US_COD_MUN
M->A1_NATUREZ		:= SUS->US_NATUREZ
M->A1_CNAE			:= SUS->US_CNAE
M->A1_EMAIL			:= SUS->US_EMAIL 
M->A1_SATIV1 		:= SUS->US_SATIV
M->A1_ESTADO 		:= Tabela('12',SUS->US_EST)
M->A1_PESSOA 		:= SUS->US_PESSOA
M->A1_RISCO			:= 'E'				// RISCO E PARA TODOS OS PROSPECTS CONVERTIDOS EM CLIENTES, INDEPENDENTE DO GRUPO DE EMPRESA.
M->A1_VEND			:= SUS->US_VEND
M->A1_ENDCOB		:= SUS->US_END
M->A1_BAIRROC 		:= SUS->US_BAIRRO
M->A1_ESTC			:= SUS->US_EST
M->A1_CEPC			:= SUS->US_CEP
M->A1_MUNC			:= SUS->US_MUN
M->A1_ENDENT		:= SUS->US_END
M->A1_BAIRROE		:= SUS->US_BAIRRO
M->A1_ESTE			:= SUS->US_EST
M->A1_CEPE			:= SUS->US_CEP
M->A1_MUNE			:= SUS->US_MUN       
M->A1_CONTRIB 		:= SUS->US_CONTRIB
Return .T.           

