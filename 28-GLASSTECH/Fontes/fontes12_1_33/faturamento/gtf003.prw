#include "Protheus.ch"
/* 
Retorna Saldo da dívida do cliente
cFil	 - verifica os saldos da filial especificada, se não enviar parametro vai verificar todas as filiais
cCliente - código do cliente
cLoja	 - Loja do cliente, se não enviar, retornará os valores referentes ao grupo do cliente
cQualRet - V - Retorna Valor; S - Retorna saldo
dDtBase  - data base que limita até que vencimento quer os saldos do cliente
lSoVenc  - verifica se vai ver os saldos até uma data base determinada
*/
User function gtf003(cFil,cCliente,cLoja,cQualRet,dDtBase,lSoVenc)

	Local nRet 	  := 0
	local cSql	  := ""

	Default cQualRet:= 'S'
	Default lSoVenc := .t.
	Default dDtBase := dDatabase

	cSql := "select sum(valor) valor,sum(saldo) saldo from ("
	cSql += "select e1_filial,e1_prefixo,e1_num,e1_parcela,e1_tipo,e1_valor,e1_saldo,"
	cSql += "e1_valor * case when e1_tipo in ('RA','NCC') then -1 else case when substring(e1_tipo,3,1) = '-' then -1 else 1 end end valor, "
	cSql += "e1_saldo * case when e1_tipo in ('RA','NCC') then -1 else case when substring(e1_tipo,3,1) = '-' then -1 else 1 end end saldo "
	cSql += "from "+RetSQLName("SE1")+" "
	cSql += "where "
	if !empty(cFil)
		cSql += "e1_filial = '"+cFil+"' and "
	endif
	cSql += "e1_cliente = '"+cCliente+"' "
	if !empty(cLoja)
		cSql += " and e1_loja = '"+cLoja+"' "
	endif
	if lSoVenc
		cSql += "and e1_vencrea <= '"+dtos(dDtBase)+"' "
	endif
	cSql += "and d_e_l_e_t_ = ' ' and e1_tipo != 'PR' and e1_saldo > 0 ) a"
	cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
	if !trb->( Eof() )
		if cQualRet == 'S'
			nRet := trb->saldo
		else
			nRet := trb->valor
		endif
	endif
	trb->( DbCloseArea() )

Return nRet
