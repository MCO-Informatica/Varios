#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"

//Função para Baixa de títulos não compensados regularmente por compensação, sem contabilização (MOTIVO BNC)
User Function csfin31()

Local lJob 		:= ( Select( "SX6" ) == 0 )
Local nI		:= 0
Local cSql		:= ''
Local cTrb		:= GetNextAlias()
Local cTmp		:= GetNextAlias()
Local cBco 		:= ' '
Local cAge 		:= ' '
Local cCta 		:= ' '
Local aBaixa 	:= {}
Local aParam 	:= {}
Local aFaVlAtuCR := {}
Local aSE1Dados := {}
Local aRet      := {}
Local nDifNf 	:= 0
Local aSe1NF 	:= {}
Local ntotbai 	:= 0
Local ndif 		:= 0
Local nDias 	:= 0
Local cEmisLi 	:= ''
Local nstatus 	:= 0 //1 -A partir de uma data,2 - pedido,3 - período
Local cPedido   := ""
Local nTotDif   := 0

Local cJobMod 	:= 'FIN'
Local cJobEmp	:= '01'
Local cJobFil	:= '02'

Local cEmisDe := '20180101'
Local cEmisAt := ''
Local cPedErp := ''  			//Pedidos testados => '9FBSMI','9HMKWS','9HDCS5','9FBKGU','9FB8Q4'

	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )
	EndIf

	nDias := 30
	if !empty(cPedErp)
	   nstatus := 2
	   cEmisLi := cEmisDe
	elseif !empty(cEmisAt)
	   nstatus := 3
	   cEmisLi := cEmisAt
	else
	   nstatus := 1
	   cEmisLi := DtoS(dDatabase+nDias)
	endif

	while cEmisDe <= cEmisLi

		cEmisAt := dtos( stod(cEmisDe) + nDias )
		if nstatus == 2
		   Conout( "INICIO EXECUÇÃO BxTitSComp - PEDIDO "+cPedErp )
		else
		   if cEmisAt > cEmisLi
		      cEmisAt := cEmisLi
		   endif
		   Conout( "INICIO EXECUÇÃO BxTitSComp - EMISSÃO TITULO DE "+DtoC(StoD(cEmisDe))+" ATÉ "+DtoC(StoD(cEmisAt)) )
		endif

		cSql := "SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_DATA,E5_VALOR,E1_PEDIDO,E1_EMISSAO,E1_VALOR,E1_SALDO,VLRBAI,E1_VALOR-VLRBAI DIF FROM ( "
		cSql += "SELECT DISTINCT B.E5_PREFIXO ,B.E5_NUMERO,B.E5_PARCELA,B.E5_TIPO,B.E5_DATA,B.E5_VALOR,( "
		cSql += "SELECT SUM(DECODE(C.E5_TIPODOC,'ES ',-1,1)*C.E5_VALOR) FROM "+RetSqlName("SE5")+" C "
		cSql += "WHERE C.E5_FILIAL = B.E5_FILIAL AND C.E5_PREFIXO = B.E5_PREFIXO AND C.E5_NUMERO = B.E5_NUMERO AND "
		cSql += "C.E5_PARCELA = B.E5_PARCELA  AND C.E5_TIPO = B.E5_TIPO AND C.D_E_L_E_T_ = ' ' AND C.E5_TIPODOC != ' ') VLRBAI,"
		cSql += "A.E1_PEDIDO,A.E1_EMISSAO,A.E1_VALOR,A.E1_SALDO "
		cSql += "FROM "+RetSqlName("SE5")+" B "
		cSql += "INNER JOIN "+RetSqlName("SE1")+" A ON A.E1_FILIAL = B.E5_FILIAL AND A.E1_PREFIXO = B.E5_PREFIXO AND "
		cSql += "A.E1_NUM = B.E5_NUMERO AND A.E1_PARCELA = B.E5_PARCELA  AND A.E1_TIPO = B.E5_TIPO AND A.D_E_L_E_T_ = ' ' "
		cSql += "WHERE B.E5_FILIAL = ' ' AND B.E5_TIPO = 'NCC' "
		if nstatus == 2
			cSql += "AND A.E1_PEDIDO = '"+cPedErp+"' "
		else
			cSql += "AND B.E5_DATA >= '"+cEmisDe+"' AND B.E5_DATA <= '"+cEmisAt+"' "	
		endif
		cSql += "AND B.D_E_L_E_T_ = ' ' AND B.E5_VALOR = 0.01 "
		cSql += ") "
		cSql += "WHERE E1_VALOR - VLRBAI > 0 and E1_SALDO = 0 "
		cSql += "ORDER BY E1_PEDIDO "

		cSql := ChangeQuery( cSql )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTrb,.F.,.T.)

		While !(cTrb)->( Eof() )

			nTotDif := 0
			cPedido := (cTrb)->e1_pedido
			While !(cTrb)->( Eof() ) .and. cPedido == (cTrb)->e1_pedido
				nTotDif += (cTrb)->dif
				(cTrb)->( dbSkip() )
			end

			Conout( "PROCESSAMENTO BxTitSComp PEDIDO: "+cPedido )

			if nTotDif > 0

				cSql := "SELECT SUM(DECODE(E5_TIPODOC,'ES ',-1,1)*E5_VALOR) TOTBAI FROM "+RetSqlName("SE1")+" SE1 "
				cSql += "INNER JOIN "+RetSqlName("SE5")+" SE5 ON E5_FILIAL = E1_FILIAL AND E5_PREFIXO = E1_PREFIXO AND "
				cSql += "E5_NUMERO = E1_NUM AND E5_PARCELA = E1_PARCELA  AND E5_TIPO = E1_TIPO AND SE5.D_E_L_E_T_ = ' ' "
				cSql += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND E1_PEDIDO = '"+cPedido+"' AND E1_TIPO = 'NF' "
				cSql += "AND SE1.D_E_L_E_T_ = ' ' AND E5_TIPODOC != ' ' "
				cSql += "AND E5_HISTOR = 'Inconsistência na programação - SIS-278' "
				cSql := ChangeQuery( cSql )
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
				nTotBai := (cTmp)->totbai
				(cTmp)->( dbCloseArea() )
				FErase( cTmp + GetDBExtension() )

				ndif := nTotDif - nTotBai
				if ndif <= 0
				   //msginfo("Baixa já realizada para "+(cTrb)->e5_prefixo+(cTrb)->e5_numero+(cTrb)->e5_parcela+(cTrb)->e5_tipo)
				   loop
				endif

				cSql := "SELECT E1_SALDO,R_E_C_N_O_ RECE1 FROM "+RetSqlName("SE1")+" SE1 "
				cSql += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
				cSql += "AND E1_PEDIDO = '"+cPedido+"' AND E1_TIPO = 'NF' "
				cSql += "AND E1_SALDO > 0 AND D_E_L_E_T_ = ' ' ORDER BY E1_PARCELA"
				cSql := ChangeQuery( cSql )
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)

				nDifNf := 0
				aSe1NF := {}
				While !(cTmp)->( Eof() )
					nDifNf += (cTmp)->e1_saldo
					if nDifNf <= ndif
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
						aBaixa := { "BNC", se1->e1_saldo, cBco,cAge,cCta, dDataBase, dDataBase } //BNC (BX. NÃO CON)
						aParam	:= {}
						aFaVlAtuCR := FaVlAtuCr("SE1",dDataBase)
						aSE1Dados := {}
						AAdd( aSE1Dados, { aSe1NF[nI], "Inconsistência na programação - SIS-278", aClone( aFaVlAtuCR ) } )
						aRet := U_CSFA530( 1, {aSe1NF[nI]}, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
						SE5->(MSUNLOCK())
						SE1->(MSUNLOCK())
						SA1->(MSUNLOCK())

					Next

				endif

			endif

		end

		(cTrb)->( dbCloseArea() )
		FErase( cTrb + GetDBExtension() )

		Conout( "FIM EXECUÇÃO BxTitSComp - EMISSÃO TITULO DE "+DtoC(StoD(cEmisDe))+" ATÉ "+DtoC(StoD(cEmisAt)) )

		cEmisDe := cEmisAt

	end

Return
