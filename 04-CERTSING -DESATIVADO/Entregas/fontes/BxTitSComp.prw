#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"

User Function BxTitSComp()  //Baixa títulos não compensados regularmente sem contabilização

Local lJob 		:= ( Select( "SX6" ) == 0 )
Local nI		:= 0
Local cSql		:= ''
Local cTrb		:= GetNextAlias()
Local cTmp		:= GetNextAlias()
Local aRet      := {}
Local cBco := ' '
Local cAge := ' '
Local cCta := ' '
Local aBaixa := {}
Local aFaVlAtuCR := {}
Local aSE1Dados := {}
Local aParam := {}

Local nDifNf := 0
Local aSe1NF := {}

Default cJobEmp	:= '01'
Default cJobFil	:= '02'
Default cJobMod	:= 'FIN'
Default cPedErp	:= ''
Default cEmisDe := '20200101'
Default cEmisAt := '20200131'

Conout( "PREPARAÇÃO EXECUÇÃO BxTitSComp" )

If lJob
	RpcSetType( 3 )
	RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )
EndIf

Conout( "INICIO EXECUÇÃO BxTitSComp - EMISSÃO TITULO DE "+DtoC(StoD(cEmisDe))+" ATÉ "+DtoC(StoD(cEmisAt)) )

cSql := "SELECT E5_PREFIXO ,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_DATA,VLRBAI,E1_PEDIDO,E1_VALOR,E1_SALDO,E1_VALOR-VLRBAI DIF FROM ( "
cSql += "SELECT DISTINCT B.E5_PREFIXO ,B.E5_NUMERO,B.E5_PARCELA,B.E5_TIPO,B.E5_DATA,( "
cSql += "SELECT SUM(DECODE(C.E5_TIPODOC,'ES ',-1,1)*C.E5_VALOR) FROM "+RetSqlName("SE5")+" C "
cSql += "WHERE C.E5_FILIAL = B.E5_FILIAL AND C.E5_PREFIXO = B.E5_PREFIXO AND C.E5_NUMERO = B.E5_NUMERO AND "
cSql += "C.E5_PARCELA = B.E5_PARCELA  AND C.E5_TIPO = B.E5_TIPO AND C.D_E_L_E_T_ = ' ' AND C.E5_TIPODOC != ' ') VLRBAI,"
cSql += "A.E1_PEDIDO,A.E1_VALOR,A.E1_SALDO "
cSql += "FROM "+RetSqlName("SE5")+" B "
cSql += "INNER JOIN "+RetSqlName("SE1")+" A ON A.E1_FILIAL = B.E5_FILIAL AND A.E1_PREFIXO = B.E5_PREFIXO AND "
cSql += "A.E1_NUM = B.E5_NUMERO AND A.E1_PARCELA = B.E5_PARCELA  AND A.E1_TIPO = B.E5_TIPO AND A.D_E_L_E_T_ = ' ' "
cSql += "WHERE B.E5_FILIAL = ' ' AND B.E5_TIPO = 'NCC' AND B.E5_DATA >= '"+cEmisDe+"' AND B.E5_DATA <= '"+cEmisAt+"' AND "
cSql += "B.D_E_L_E_T_ = ' ' AND B.E5_VALOR = 0.01 "
cSql += ") "
cSql += "WHERE E1_VALOR - VLRBAI > 0 and E1_SALDO = 0"

cSql := ChangeQuery( cSql )
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTrb,.F.,.T.)

While !(cTrb)->( Eof() )

	cSql := "SELECT E1_SALDO,R_E_C_N_O_ RECE1 FROM "+RetSqlName("SE1")+" WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
	cSql += "AND E1_PEDIDO = '"+(cTrb)->e1_pedido+"' AND E1_TIPO='NF' "
	cSql += "AND E1_SALDO > 0 AND D_E_L_E_T_ = ' ' ORDER BY E1_PARCELA"
	
	cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)

	nDifNf := 0
	aSe1NF := {}
	While !(cTmp)->( Eof() )
	    nDifNf += (cTmp)->e1_saldo
		if nDifNf <= (cTrb)->dif
			AAdd( aSe1NF, (cTmp)->RECE1 )
		endif
		(cTmp)->( dbSkip() )
	end

	(cTmp)->( dbCloseArea() )
	FErase( cTmp + GetDBExtension() )

	if len(aSe1NF) > 0
			
		For nI := 1 to len(aSe1NF)
			SE1->( dbGoTo( aSe1NF[nI] ) )

			cBco := ' '
			cAge := ' '
			cCta := ' '
			aBaixa := { "BNC", SE1->E1_SALDO, cBco,cAge,cCta, dDataBase, dDataBase } //BNC (BX. NÃO CON)
			aParam	:= {}
			aFaVlAtuCR := FaVlAtuCr("SE1",dDataBase)
			aSE1Dados := {}
			AAdd( aSE1Dados, { aSe1NF[nI], "Inconsistência na programação", aClone( aFaVlAtuCR ) } )
			aRet := U_CSFA530( 1, {aSe1NF[nI]}, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
			SE5->(MSUNLOCK())
			SE1->(MSUNLOCK())
			SA1->(MSUNLOCK())

		Next

	endif

	(cTrb)->( dbSkip() )
end

(cTrb)->( dbCloseArea() )
FErase( cTrb + GetDBExtension() )

Conout( "FIM EXECUÇÃO BxTitSComp" )

Return
