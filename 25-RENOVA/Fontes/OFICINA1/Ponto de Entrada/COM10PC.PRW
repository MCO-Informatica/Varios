#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TopConn.ch"

/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Funcao: COM10PC                 Autor: Marcio Hernandes     Data: 15/08/2018 +
+ Uso: 	PE chamado pela rotina de importação de XML (Portal XML) ACOMR07       +
+------------------------------------------------------------------------------+
+ Projeto: Template XML                                                        +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function COM10PC()
Local cSql  	:= ""
Local aRet		:= {}
Local cAliasTRB := GetNextAlias()
Local cFornece 	:= PARAMIXB[1]
Local cLoja		:= PARAMIXB[2]
Local cProdNF	:= PARAMIXB[3]
Local cProdSB1	:= PARAMIXB[4]
Local nQuant	:= PARAMIXB[5]
Local nValor	:= PARAMIXB[6]
Local nPos		:= 0
Local nInd		:= 0
Local cFilCond	:= ""

Default aCom10PC	:= {}

// a estrutura do array passado no Parametro 7 não é definida na rotina chamadora, é definida aqui no PE.
// Desta forma fica livre a implementação

If Len(aCom10PC) >  0
	// Verifica se tem algum item no array com saldo para atender este item
	If Empty(cProdSB1)
		nPos := aScan(aCom10PC,{|x| x[4] >= nQuant .AND. x[5] = nValor } )
	Else	
		nPos := aScan(aCom10PC,{|x| x[3] = cProdSB1 .AND. x[4] >= nQuant .AND. x[5] = nValor } )
	Endif	
	
	If nPos > 0
		// Acerta o Saldo do item no Array e retorna este Pedido/Item
		aCom10PC[nPos,4] := aCom10PC[nPos,4] - nQuant
		// Estutura do aCom10PC - {Pedido,Item,Produto,Produto,Saldo,Preco}
		aRet := {{aCom10PC[nPos,1],aCom10PC[nPos,2],aCom10PC[nPos,4],.F.,aCom10PC[nPos,3] }} // o flag indica se a quantidade deve ser consistida pelo fonte para o qual este PE retorna
	Else
		// Se não encontrou, pegar os pedidos já utilizados para excluir da query
		cFilCond := " SC7.C7_NUM||SC7.C7_ITEM NOT IN ("
		For nInd := 1 To Len(aCom10PC)
			cFilCond += "'"+aCom10PC[nInd,1]+aCom10PC[nInd,2]+"',"
		Next
		cFilCond := Subs(cFilCond,1,Len(cFilCond)-1)
		cFilCond += ") AND "
	Endif
Endif

If nPos = 0	
	cSql := "SELECT SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_QUANT-SC7.C7_QUJE-SC7.C7_QTDACLA SALDO, SC7.C7_PRODUTO, SC7.C7_PRECO FROM "+RetSqlName("SC7")+" SC7 "
	cSql += " WHERE SC7.C7_FILIAL = '"+cFilAnt+"' AND "
	cSql += " SC7.C7_FORNECE = '"+cFornece+"' AND "
	cSql += " SC7.C7_LOJA    = '"+cLoja   +"' AND "
	If .NOT. Empty(cProdSB1)
		cSql += " SC7.C7_PRODUTO = '"+cProdSB1+"' AND "
	Endif	
	cSql += " SC7.C7_QUANT-SC7.C7_QUJE-SC7.C7_QTDACLA  = "+Str(nQuant)+"   AND "
	cSql += " SC7.C7_PRECO   = "+Str(nValor)+"  AND "
	cSql += " SC7.C7_RESIDUO = ' ' AND "
	cSql += " SC7.C7_ENCER = ' ' AND "
	
	If .NOT. Empty(cFilCond)
		cSql += cFilCond
	Endif

	cSql += " SC7.D_E_L_E_T_ = ' ' "
	
	cSql += " ORDER BY SC7.C7_DATPRF "
				
	TcQuery cSql NEW Alias (cAliasTRB)

	If .NOT. Eof()
		aRet := {{(cAliasTRB)->C7_NUM,(cAliasTRB)->C7_ITEM,(cAliasTRB)->SALDO,.F.,If(Empty(cProdSB1),(cAliasTRB)->C7_PRODUTO,cProdSB1)}} // o flag indica se a quantidade deve ser consistida pelo fonte para o qual este PE retorna
		// Salva o Pedido/Item/Saldo no Array de Pedidos Já usados que será consultado na próxima chamada deste PE.
		aAdd(aCom10PC,{(cAliasTRB)->C7_NUM,(cAliasTRB)->C7_ITEM,If(Empty(cProdSB1),(cAliasTRB)->C7_PRODUTO,cProdSB1),(cAliasTRB)->SALDO-nQuant,(cAliasTRB)->C7_PRECO} )
	Endif

	DbCloseArea()
Endif

Return aRet	

