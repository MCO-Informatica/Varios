#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

#DEFINE REL_TIPO	001
#DEFINE REL_DESC	002
#DEFINE REL_PREF	003
#DEFINE REL_TTIP	004
#DEFINE REL_VENC	005
#DEFINE REL_FORN	006
#DEFINE REL_LOJA	007
#DEFINE REL_NOME	008
#DEFINE REL_VALOR	009


/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatório		                                         !
+------------------+---------------------------------------------------------+
!Modulo            ! Financeiro	                                             !
+------------------+---------------------------------------------------------+
!Nome              ! RelFluxo		                                         !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório de Fluxo Financeiro           				 !
+------------------+---------------------------------------------------------+
!Autor             ! Luiz Alberto				                             !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 03/07/2021                                              !
+------------------+---------------------------------------------------------+
*/ 

User Function RelFluxo()
Private cPerg := PadR("RELFLX2",10)

AjustaSX1(cPerg)
If ( !Pergunte(cPerg) )
	Return
Else      
	oReport := RFlx()
	oReport:PrintDialog()
Endif

Return   

Static Function RFlx()
	Local oReport
	Local oSection
	
	oReport := TReport():New("RelFlx","Relatório de Fluxo","",{|oReport| fFlxDados(oReport)},"Relação de Notas Fiscais")	
    oReport:LPARAMPAGE 	:= 	.T.
	oReport:nfontbody	:=	10
	oReport:cfontbody	:=	"Arial"

					
	oSection  := TRSection():New(oReport,"Relação",{"SE2"})

	TRCell():New(oSection,"E2_VENCREA" 	,"QRY", "Data"			, nil, 10, .F., {|| })
	TRCell():New(oSection,"E2_NOMFOR" 	,"QRY", "Detalhe"		, nil, 40, .F., {|| })
	TRCell():New(oSection,"E2_SALDO" 	,"QRY", "Valor"			, "@E 9,999,999,999,999.99", 16, .F., {|| })

	oSection:SetTotalInLine(.F.)

Return(oReport)

/*
+--------------------------------------------------------------------------+
! Função    ! R05Print   ! Autor ! Cleverson Funaki   ! Data !  19/03/15   !
+-----------+------------+-------+--------------------+------+-------------+
! Parâmetros! oReport - Objeto TReport configurado                         !
+-----------+--------------------------------------------------------------+
! Descricao ! Função de impressão do relatório.                            !
+-----------+--------------------------------------------------------------+
*/
Static Function fFlxDados(oReport)
Local oSection  := oReport:Section(1)
Local cQry := ""

cQry += "	SELECT '01' TIPO, 'Contas Pagas' DTIPO, E2_PREFIXO, E2_TIPO, E2_BAIXA E2_VENCREA, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR " + CRLF	
cQry += "	FROM " + RetSqlName("SE2") + " DPF " + CRLF	
cQry += "	WHERE E2_FILIAL = '" + xFilial("SE2") + "' " + CRLF	
cQry += "	AND E2_BAIXA >= '" + DtoS(MV_PAR01) + "' " + CRLF	
cQry += "	AND DPF.D_E_L_E_T_ = '' " + CRLF	
cQry += "	UNION ALL " + CRLF	
cQry += "	SELECT '02' TIPO, 'Salarios' DTIPO, E2_PREFIXO, E2_TIPO, E2_BAIXA E2_VENCREA, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR " + CRLF	
cQry += "	FROM " + RetSqlName("SE2") + " SAL " + CRLF	
cQry += "	WHERE E2_FILIAL = '" + xFilial("SE2") + "' " + CRLF	
cQry += "	AND E2_BAIXA >= '" + DtoS(MV_PAR01) + "' " + CRLF	
cQry += "	AND E2_NATUREZ = '" + MV_PAR03 + "' " + CRLF	
cQry += "	AND SAL.D_E_L_E_T_ = '' " + CRLF	
cQry += "	UNION ALL " + CRLF	
cQry += "	SELECT '03' TIPO, 'Retirada Socios' DTIPO, E2_PREFIXO, E2_TIPO, E2_BAIXA E2_VENCREA, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR " + CRLF	
cQry += "	FROM " + RetSqlName("SE2") + " PRO " + CRLF	
cQry += "	WHERE E2_FILIAL = '" + xFilial("SE2") + "' " + CRLF	
cQry += "	AND E2_BAIXA >= '" + DtoS(MV_PAR01) + "' " + CRLF	
cQry += "	AND E2_NATUREZ = '" + MV_PAR04 + "' " + CRLF	
cQry += "	AND PRO.D_E_L_E_T_ = '' " + CRLF	
cQry += "	UNION ALL " + CRLF	
cQry += "	SELECT '04' TIPO, 'Creditos Clientes' DTIPO, E1_PREFIXO, E1_TIPO, E1_BAIXA E2_VENCREA, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_VALOR " + CRLF	
cQry += "	FROM " + RetSqlName("SE1") + " CLI " + CRLF	
cQry += "	WHERE E1_FILIAL = '" + xFilial("SE1") + "' " + CRLF	
cQry += "	AND E1_BAIXA >= '" + DtoS(MV_PAR01) + "' " + CRLF	
cQry += "	AND E1_TIPO = 'NF' " + CRLF	
cQry += "	AND CLI.D_E_L_E_T_ = '' " + CRLF	
cQry += "	UNION ALL " + CRLF	
cQry += "	SELECT '05' TIPO, 'Previsão de Gastos' DTIPO, E2_PREFIXO, E2_TIPO, E2_VENCREA, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_SALDO " + CRLF	
cQry += "	FROM " + RetSqlName("SE2") + " PGA " + CRLF	
cQry += "	WHERE E2_FILIAL = '" + xFilial("SE2") + "' " + CRLF	
cQry += "	AND E2_BAIXA = '' " + CRLF	
cQry += "	AND E2_TIPO IN('NF') " + CRLF	
cQry += "	AND PGA.D_E_L_E_T_ = '' " + CRLF	
cQry += "	UNION ALL " + CRLF	
cQry += "	SELECT '06' TIPO, 'Previsão Entradas' DTIPO, E1_PREFIXO, E1_TIPO, E1_VENCREA E2_VENCREA, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_SALDO " + CRLF	
cQry += "	FROM " + RetSqlName("SE1") + " PRE_ENT " + CRLF	
cQry += "	WHERE E1_FILIAL = '" + xFilial("SE1") + "' " + CRLF	
cQry += "	AND E1_SALDO > 0 " + CRLF	
cQry += "	AND E1_TIPO IN('NF') " + CRLF	
cQry += "	AND PRE_ENT.D_E_L_E_T_ = '' " + CRLF	
cQry += "	ORDER BY TIPO, E2_VENCREA  " + CRLF	

TCQUERY cQry NEW ALIAS "TRB"         

TcSetField("TRB", "E2_VENCREA", "D", 8, 0)

aDados := {}    

While TRB->(!Eof())

	If TRB->TIPO $ '01*02*03*05'
		SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+TRB->E2_FORNECE+TRB->E2_LOJA))

		cNome := AllTrim(SA2->A2_NOME) + " - " + AllTrim(SA2->A2_NREDUZ)
	ElseIf TRB->TIPO $ '04*06'
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+TRB->E2_FORNECE+TRB->E2_LOJA))

		cNome := AllTrim(SA1->A1_NOME) + " - " + AllTrim(SA1->A1_NREDUZ)
	Endif

	AAdd(aDados,{TRB->TIPO,;
                TRB->DTIPO,;
                TRB->E2_PREFIXO,;
                TRB->E2_TIPO,;
                TRB->E2_VENCREA,;
                TRB->E2_FORNECE,;
                TRB->E2_LOJA,;
				cNome,;
				TRB->E2_VALOR})
    
    TRB->(dbSkip(1))
EndDo
TRB->(DbCloseArea())

oReport:SetMeter(Len(aDados))

aTotais := {0,0,0,0,0,0,0}
nTotGer := 0.00

cTipo := aDados[1,1]	// Tipo Impressao
cdTipo := aDados[1,2]	// Tipo Impressao
_nI := 1
lSaldo := (MV_PAR02<>0)
nSaldo := MV_PAR02
While _nI <= Len(aDados)

	oReport:IncMeter()
	
	If oReport:Cancel() 
		Exit 
	EndIf 

	oSection:Init()

	If _nI == 1 .And. lSaldo
		oSection:Cell("E2_VENCREA"):SetValue(dDataBase)
		oSection:Cell("E2_NOMFOR"):SetValue("S A L D O  I N I C I A L...........:")
		oSection:Cell("E2_SALDO"):SetValue(nSaldo)
		oReport:SkipLine()
		oReport:SkipLine()
	Else
		oSection:Cell("E2_VENCREA"):SetValue(aDados[_nI	,REL_VENC])
		oSection:Cell("E2_NOMFOR"):SetValue(aDados[_nI	,REL_NOME])
		oSection:Cell("E2_SALDO"):SetValue(aDados[_nI	,REL_VALOR])
	Endif

	aTotais[Val(aDados[_nI,REL_TIPO])] += aDados[_nI,REL_VALOR]

	nTotGer += aDados[_nI,REL_VALOR]

	oSection:PrintLine()

	_nI++
	If _nI > Len(aDados) .Or. cTipo <> aDados[_nI,REL_TIPO] 
		oReport:SkipLine()
		nLin := oReport:Row()
		oReport:PrintText('Total ' + cdTipo, nLin  ) //"TOTAL DO PRODUTO: "
		oReport:PrintText( Transform(aTotais[Val(cTipo)], "@E 9,999,999,999.99"), nLin, oSection:Cell("E2_SALDO"):ColPos() )
        oReport:SkipLine()					
        oReport:SkipLine()					
		oReport:SkipLine()

		If _nI <= Len(aDados)
			cTipo 	:= aDados[_nI,REL_TIPO] 
			cDTipo 	:= aDados[_nI,REL_DESC] 
		Endif
	Endif
Enddo
nSalAtu     := MV_PAR05
nSaldoFinal := (nSaldo + nSalAtu)
nSaldoFinal -= (aTotais[1]+aTotais[2]+aTotais[3]+aTotais[5])
nSaldoFinal += (aTotais[4]+aTotais[6])

oReport:SkipLine()
oReport:SkipLine()
nLin := oReport:Row()
oReport:PrintText('S A L D O  A T U A L ...............: ', nLin  ) //"TOTAL DO PRODUTO: "
oReport:PrintText( Transform(nSalAtu, "@E 9,999,999,999.99"), nLin, oSection:Cell("E2_SALDO"):ColPos() )
oReport:SkipLine()					
oReport:SkipLine()					
oReport:SkipLine()					
oReport:SkipLine()
nLin := oReport:Row()
oReport:PrintText('S A L D O  F I N A L ...............: ', nLin  ) //"TOTAL DO PRODUTO: "
oReport:PrintText( Transform(nSaldoFinal, "@E 9,999,999,999.99"), nLin, oSection:Cell("E2_SALDO"):ColPos() )
oReport:SkipLine()					
oSection:Finish()
Return

Static Function AjustaSX1(cPerg)
Local	aRegs   := {},;
		_sAlias := Alias(),;
		nX

		aAdd(aRegs,{cPerg,'01','Data Inicial       ?','','','mv_ch1','D', 08,0,0,'G',''		,'mv_par01','','','','','','',''})
		aAdd(aRegs,{cPerg,'02','Saldo Inicial      ?','','','mv_ch2','N', 12,2,0,'G',''		,'mv_par02','','','','','','','@E 9,999,999,999.99'})
		aAdd(aRegs,{cPerg,'03','Natureza Salarios  ?','','','mv_ch3','C', 10,0,0,'G',''		,'mv_par03','','','','','','SED',''})
		aAdd(aRegs,{cPerg,'04','Natureza ProLabore ?','','','mv_ch4','C', 10,0,0,'G',''		,'mv_par04','','','','','','SED',''})
		aAdd(aRegs,{cPerg,'05','Saldo Atual        ?','','','mv_ch5','N', 12,2,0,'G',''		,'mv_par05','','','','','','','@E 9,999,999,999.99'})

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For nX:=1 to Len(aRegs)
			If	( ! SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02])) )
				If	RecLock('SX1',.T.)
					Replace SX1->X1_GRUPO  		With aRegs[nx][01]
					Replace SX1->X1_ORDEM   	With aRegs[nx][02]
					Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
					Replace SX1->X1_PERSPA		With aRegs[nx][04]
					Replace SX1->X1_PERENG		With aRegs[nx][05]
					Replace SX1->X1_VARIAVL		With aRegs[nx][06]
					Replace SX1->X1_TIPO		With aRegs[nx][07]
					Replace SX1->X1_TAMANHO		With aRegs[nx][08]
					Replace SX1->X1_DECIMAL		With aRegs[nx][09]
					Replace SX1->X1_PRESEL		With aRegs[nx][10]
					Replace SX1->X1_GSC			With aRegs[nx][11]
					Replace SX1->X1_VALID		With aRegs[nx][12]
					Replace SX1->X1_VAR01		With aRegs[nx][13]
					Replace SX1->X1_DEF01		With aRegs[nx][14]
					Replace SX1->X1_DEF02		With aRegs[nx][15]
					Replace SX1->X1_DEF03		With aRegs[nx][16]
					Replace SX1->X1_DEF04		With aRegs[nx][17]
					Replace SX1->X1_DEF05		With aRegs[nx][18]
					Replace SX1->X1_F3   		With aRegs[nx][19]
					Replace SX1->X1_PICTURE		With aRegs[nx][20]
					SX1->(MsUnlock())
				Else
					Help('',1,'REGNOIS')
				EndIf	
			Endif
		Next nX

Return
