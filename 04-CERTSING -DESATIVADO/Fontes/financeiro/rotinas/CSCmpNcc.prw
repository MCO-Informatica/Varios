#Include 'Protheus.ch'
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'
//--------------------------------------------------------------------------
// Rotina | CSCmpNcc | Autor | Rafael Beghini        | Data | 06.09.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para compensar os pedidos que possuem pend�ncia
//        | no caso 01 PR para N registros de NCC que n�o compensam.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSCmpNcc()
    Local aRET   := {}
    Local aPAR   := {}
    Local cWhen1 := "IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) ) == '1'"
    Local cWhen2 := "IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) ) == '2'"
    Local lProc  := .F.

    Private aPedidos := {}

    aAdd(aPAR,{9,"Selecione a op��o, processar pedido �nico ou por arquivo",200,7,.T.})
    aAdd(aPAR,{3,"Tipo",1,{"Pedido �nico","Ler arquivo"},50,"",.T.})
    aAdd(aPAR,{1,"Ped SITE",Space(10),"","","",cWhen1,0,.F.})
    aAdd(aPAR,{6,"Buscar arquivo",Space(80),"","",cWhen2,50,.F.,"Arquivo Texto|*.TXT","C:\temp"})

    IF ParamBox(aPAR,"Compensa NCC...",@aRET)
        lProc := IIf( ValType( Mv_par02 ) == 'C', Subs(Mv_par02,1,1), LTrim( Str( Mv_par02, 1, 0 ) ) ) == '2'
        
        IF lProc
            Processa({|| aPedidos := A010Txt( aRET ) },"Lendo arquivo Texto...")
            Processa({|| A010Proc( aPedidos ) },"Realizando a compensa��o...")           
        Else
            aPedidos := { aRET[ 3 ] }
            Processa({|| A010Proc( aPedidos ) },"Realizando a compensa��o...")
        EndIF
        MsgAlert('Processo finalizado com sucesso.','[CSCmpNcc]')
    Else
        MsgAlert('Processo cancelado pelo usu�rio','[CSCmpNcc]')
    EndIF
Return
//--------------------------------------------------------------------------
// Rotina | A010Proc | Autor | Rafael Beghini        | Data | 06.09.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para montar o Array aPEDIDOS conforme o txt
//--------------------------------------------------------------------------
Static Function A010Txt( aRET )
    Local cFile := aRET[ 4 ]
    Local aTRB  := {}

    IF !File(cFile)
        MsgAlert("Arquivo texto: "+cFile+" n�o localizado",'[CSCmpNcc]')
        Return
    Endif

    FT_FUSE(cFile)              //ABRIR
    FT_FGOTOP()                 //PONTO NO TOPO
    ProcRegua(FT_FLASTREC())    //QTOS REGISTROS LER

    While !FT_FEOF()
        IncProc()
        // Capturar dados
        aADD( aTRB , FT_FREADLN() ) //LENDO LINHA 
        FT_FSKIP()   
    EndDo

    FT_FUSE() //fecha o arquivo txt
Return( aTRB )
//--------------------------------------------------------------------------
// Rotina | A010Proc | Autor | Rafael Beghini        | Data | 06.09.2018
//--------------------------------------------------------------------------
// Descr. | Rotina que executa a compensa��o
//--------------------------------------------------------------------------
Static Function A010Proc( aPedidos )
    Local dEmisDe  	 := StoD('20150101')
    Local cPedido    := ''
    Local cSql       := ''
    Local cTrbSql    := ''
    Local cEstorno   := ''
    Local cPedSITE   := ''
    Local lVldSldNF  := .F.
    Local lVldSldRes := .F.
    Local aSe1CAN    := {}
    Local aSe1NF     := {}
    Local nX         := 0

    ProcRegua( Len(aPedidos) )    //QTOS REGISTROS LER
    For nLin := 1 To Len( aPedidos )
        IncProc()
        cPedSITE := rTrim( aPedidos[ nLin ] )
        BeginSql Alias "CMPNCC"
            SELECT
                C5_NUM PEDIDO,
                C5_EMISSAO EMISSAO_PED,
                C5_XNPSITE CODSITE,
                C5_CHVBPAG CODGAR,
                nvl((SELECT MAX (SZ5.Z5_DATVAL) FROM %Table:SZ5% SZ5 WHERE Z5_FILIAL=%xFilial:SZ5% AND Z5_PEDGAR=C5_CHVBPAG AND C5_CHVBPAG>' '  AND SZ5.D_E_L_E_T_=' '),' ')  AS DATVAL,
                nvl((SELECT MAX (SZ5.Z5_DATEMIS) FROM %Table:SZ5% SZ5 WHERE Z5_FILIAL=%xFilial:SZ5% AND Z5_PEDGAR=C5_CHVBPAG AND C5_CHVBPAG>' ' AND SZ5.D_E_L_E_T_=' '),' ')  AS DATEMIS,
                C5_TIPMOV TIPMOV,
                C5_TIPVOU TIPVOU,
                C5_XNATURE NATUREZA,
                nvl((SELECT MIN (SE1.E1_EMISSAO) FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR'),' ')  AS EMIS_PR,
                nvl((SELECT MIN (SE1.E1_EMISSAO) FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC' AND SE1.E1_PREFIXO IN ('RCP','VDI','RCO')),' ') AS EMIS_NCC,  
                nvl((SELECT MIN (SE1.E1_EMISSAO) FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NF'),' ')  AS EMIS_NF,  
                nvl((SELECT SUM(E1_VALOR)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR'),0)  AS VALOR_PR,
                nvl((SELECT SUM(E1_VALOR)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC' AND SE1.E1_PREFIXO IN ('RCP','VDI','RCO')),0) AS VALOR_NCC,
                nvl((SELECT SUM(E1_VALOR)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NF'),0)  AS VALOR_NF,
                nvl((SELECT SUM(E1_SALDO)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='PR'),0) AS SALDO_PR,
                nvl((SELECT SUM(E1_SALDO)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NCC' AND SE1.E1_PREFIXO IN ('RCP','VDI','RCO')),0) AS SALDO_NCC,
                nvl((SELECT SUM(E1_SALDO)        FROM %Table:SE1% SE1 WHERE E1_FILIAL=%xFilial:SE1% AND E1_PEDIDO=C5_NUM AND SE1.D_E_L_E_T_=' ' AND SE1.E1_TIPO='NF'),0)  AS SALDO_NF,
                C5_XCARTAO CARTAO,
                C5_XCODAUT CODAUT,
                C5_XDOCUME DOCUMENTO,
                C5_XNPARCE PARCELA,
                C5_XLINDIG LINHA_DIG,
                C5_XNUMVOU NUMVOU,
                C5_XRECPG RECIBO,
                C5_XNFHRD NF_HRD,
                C5_XNFSFW NF_SFW,
                C5_TOTPED TOTPED, 
                C5_NOTA   NOTA   
            FROM
                %Table:SC5% SC5
            WHERE
                C5_FILIAL = %xFilial:SC5% 
                AND C5_EMISSAO >= %Exp:DtoS(dEmisDe)%  
                AND C5_XNPSITE = %Exp:cPedSITE%  
                AND SC5.D_E_L_E_T_ = ' '   
        EndSql

        While CMPNCC->( !Eof() )   

            cPedido  := CMPNCC->PEDIDO
            lVldData := .T.                                                                                                  
        
            lVldSldRes := .F. //se está no select é porque existe um erro ou falta compesação. Então Força a compensação independente de saldo ou parcela	                                                                                                                             
            lVldSldNF  := .F. //iif(	CMPNCC->SALDO_PR>0 .and.(CMPNCC->VALOR_NF-CMPNCC->VALOR_PR>=-0.02 .AND. CMPNCC->VALOR_NF-CMPNCC->VALOR_PR<=0.02),.F.,.T.)//Se saldo do PR maior que Zero, Ignora Saldo da NF. Considera o Valor o que irá forçar a substituição do PR pela NF
        
            //VERIFICA NECESSIDADE DE PROCURA DE BAIXAS INDEVIDAS POR CANCELAMENTO
            cSql := "		SELECT SE1.R_E_C_N_O_ RECE1, SE5.R_E_C_N_O_ RECE5 , SE5.E5_SEQ SEQ"
            cSql += "		FROM "+RetSqlName("SE5")+ " SE5 
            
            cSql += "	         LEFT JOIN "+RetSqlName("SE5")+ " ESTORNO ON "
            cSql += "	         ESTORNO.E5_FILIAL='"+xFilial("SE5")+"' AND  "
            cSql += "	         ESTORNO.E5_DATA>='"+DtoS(dEmisDe)+"'  AND "
            cSql += "	         ESTORNO.D_E_L_E_T_=' ' AND "
            cSql += "	         ESTORNO.E5_MOTBX='CAN' AND "
            cSql += "	         ESTORNO.E5_FILIAL=SE5.E5_FILIAL AND "
            cSql += "	         ESTORNO.E5_PREFIXO=SE5.E5_PREFIXO AND "
            cSql += "	         ESTORNO.E5_NUMERO= SE5.E5_NUMERO AND "
            cSql += "	         ESTORNO.E5_PARCELA=SE5.E5_PARCELA AND "
            cSql += "	         ESTORNO.E5_TIPO=SE5.E5_TIPO AND "
            cSql += "	         ESTORNO.E5_CLIFOR=SE5.E5_CLIFOR AND "
            cSql += "	         ESTORNO.E5_LOJA=SE5.E5_LOJA AND "
            cSql += "	         ESTORNO.E5_SEQ=SE5.E5_SEQ AND "
            cSql += "	         ESTORNO.E5_TIPODOC='ES', "

            cSql += "	    	 "+RetSqlName("SE1") +" SE1  "
            cSql += "		WHERE "
            cSql += "		SE5.E5_FILIAL='"+xFilial("SE5")+"' "
            cSql += "		AND SE5.E5_DATA>='"+DtoS(dEmisDe)+"' "
            cSql += "		AND SE5.D_E_L_E_T_=' ' "
            cSql += "		AND SE5.E5_SITUACA=' ' "
            cSql += "		AND SE5.E5_MOTBX='CAN' AND SE5.E5_HISTOR =SE5.E5_PREFIXO||SE5.E5_NUMERO||SE5.E5_PARCELA||SE5.E5_TIPO||'CAN' "  
            cSql += "		AND SE1.E1_FILIAL='"+xFilial("SE1")+"' "
            cSql += "		AND SE1.E1_PREFIXO=SE5.E5_PREFIXO "
            cSql += "		AND SE1.E1_NUM=SE5.E5_NUMERO "
            cSql += "		AND SE1.E1_PARCELA=SE5.E5_PARCELA "
            cSql += "		AND SE1.E1_TIPO=SE5.E5_TIPO "
            cSql += "		AND SE1.E1_CLIENTE=SE5.E5_CLIFOR "
            cSql += "		AND SE1.E1_LOJA=SE5.E5_LOJA "
            cSql += "		AND SE1.E1_PEDIDO='"+cPedido+"' "
            cSql += "		AND SE1.D_E_L_E_T_=' ' "
            cSql += "		AND ESTORNO.E5_DATA IS NULL "

            cTrbSql := GetNextAlias()
            PLSQuery( cSql, CTrbSql )
        
            aSe1CAN := {}
        
            While !(cTrbSql)->(Eof())
                AAdd( aSe1CAN, {(cTrbSql)->RECE1,(cTrbSql)->RECE5,(cTrbSql)->SEQ} )
                (cTrbSql)->(DbSkip())
            End

            (cTrbSql)->(DbCloseArea())
        
            If Len(aSe1CAN)>0
            
                For nX := 1 to Len(aSe1CAN)
                
                    cEstorno := aSe1CAN[ nX, 3 ]
                    
                    //VERIFICA SE CANCELAMENTO FOI CONTABILIZADO
                    DbSelectArea("SE5")
                    SE5->( dbGoTo( aSe1CAN[ nX, 2 ]) )
                    
                    //Atualiza campo de controle de contabilização para que no estorno seja criado um novo registro no E5. 
                    //Por padrão este campo fica fazio se o motivo o baixa for não gerar movimento bancário. Porem, para efeito de posição de 
                    //títulos a receber se faz necessário conhecer a data da baixa e a data de cancelamento da baixa. 

                    Reclock("SE5",.F.)
                    SE5->E5_LOTE:='8850'
                    MSUNLOCK()
                    
                    //Estorna a baixa do título
                    //Manter SE1 POSICIONADO
                    DbSelectArea("SE1")
                    SE1->( dbGoTo( aSe1CAN[ nX, 1 ]) )
                    
                    FaBaixaCR(	{0,0,0}, {},.F.,.F., .F.,cEstorno,.F.)
                
                    SE5->(MSUNLOCK())
                    SE1->(MSUNLOCK())
                    SA1->(MSUNLOCK())  
                    
                    cEstorno := NIL
                    
                    IF SE1->E1_TIPO<>'NCC'
                        lVldData := .F. //Deve usar a data base para compensação
                    Endif    
                Next

            Endif	 
        
            // Localiza as NFs do pedido para Substituição dos PR ou Compensação das NCCs
            cSql := "SELECT R_E_C_N_O_ RECE1 "
            cSql += " FROM "+RetSqlName("SE1")
            cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
            cSql += " E1_TIPO ='NF' AND"
            cSql += " E1_PEDIDO = '"+cPedido+"' AND "
            if lVldSldNF //considera saldo da NF 
                cSql += " E1_SALDO > 0 AND "
            Endif
            cSql += " D_E_L_E_T_ = ' ' "
                
            cTrbSql:=GetNextAlias()
            PLSQuery( cSql, CTrbSql )
            
            aSe1NF := {}
            
            While !(cTrbSql)->(Eof())
                AAdd( aSe1Nf, {cPedido,(cTrbSql)->RECE1} )
                (cTrbSql)->(DbSkip())
            End

            (cTrbSql)->(DbCloseArea())
        
            If Len(aSe1Nf)>0
                //verifica se deve substituir as PR e Compensar as NCC
                //User funtion do M460fin
                //aparan[1] Array com Pedido e Recnos do SE1
                //aparan[2] //Valida database para movimentação financeira, default (.f.) Database, Se .T. Será considerada a maior data de emissao para movimentação entre (NF e NCC), (NF e PR) e (NCC e PR)
                //aparan[3] //Valida apenas saldo residual 0,01, defult(.t.)., Se .f. vai compesar todos os valores em aberto para NCC e NF. 
                            //Cuidado pois (.f.) impacta diretamente na comparação entre o saldo no contas a receber e saldo das contas contábeis. Existe risco de Compensação indevida
                //aparan[4] //Ignora parcela e saldo do PR. defult(.t.)., Se .f. força a subsituição do PR pela NF.
                U_VldRecPg( aSe1Nf,lVldData,lVldSldRes,lVldSldNF )
            Endif
                
            CMPNCC->( dbSkip() )
        EndDo
        IF Select('CMPNCC') > 0
            CMPNCC->( dbCloseArea() )
        EndIF
    Next nLin

Return

//FUN��O UTILIZADA PARA MUDAR A DATA DE VENCIMENTO
//FOI NECESS�RIA QUANDO O NUMERO DE PARCELAS DO C5 N�O ATUALIZOU
//O VENCIMENTO CORRETO DO SE1
Static Function A030Proc(cOpc, aRET, aPedidos)
	Local cSQL := ''
	Local cTRB := ''
	Local cPEDIDO := rTrim( aRET[ 4 ] )
	Local nLin := 0
		
	IF cOpc == '1' //Executa por pedido
		cSQL += "SELECT E1.R_E_C_N_O_ RECE1," + CRLF
		cSQL += "       To_Number(C5_XNPARCE) As PARCELA" + CRLF
		cSQL += "FROM " + RetSqlName('SE1') + " E1 " + CRLF
		cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5" + CRLF
		cSQL += "               ON C5_FILIAL = E1_FILIAL" + CRLF
		cSQL += "                  AND C5_NUM = E1_PEDIDO" + CRLF
		cSQL += "                  AND C5.D_E_L_E_T_ = ' '" + CRLF
		cSQL += "WHERE  E1_FILIAL = '" + xFilial('SE1') + "' " + CRLF
		cSQL += "       AND E1_TIPO = 'NF'" + CRLF
		cSQL += "       AND E1_PEDIDO = '" + cPEDIDO + "'" + CRLF
		cSQL += "       AND E1_SALDO > 0" + CRLF
		cSQL += "       AND E1.D_E_L_E_T_ = ' '" + CRLF
		
		cTRB := GetNextAlias()
		cSQL := ChangeQuery( cSQL )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
		
		IF .NOT. (cTRB)->( EOF() ) 
			While .NOT. (cTRB)->( EOF() )
				SE1->( dbGoTo( (cTRB)->RECE1 ) )
				SE1->( RecLock('SE1',.F.) )
				SE1->E1_VENCTO  := MonthSum( SE1->E1_EMISSAO, (cTRB)->PARCELA )
				SE1->E1_VENCREA := DataValida( MonthSum( SE1->E1_EMISSAO, (cTRB)->PARCELA ), .T. )
				SE1->( MsUnlock() )
			
				(cTRB)->( dbSkip() )
			End
		EndIF
		(cTRB)->( dbCloseArea() )
		FErase( cTRB + GetDBExtension() )
	Else //Executa por lote (Importa��o arquivo)
		ProcRegua( Len(aPedidos) )    //QTOS REGISTROS LER
		For nLin := 1 To Len( aPedidos )
			IncProc()
			cSQL := ""
			cSQL += "SELECT E1.R_E_C_N_O_ RECE1," + CRLF
			cSQL += "       To_Number(C5_XNPARCE) As PARCELA" + CRLF
			cSQL += "FROM " + RetSqlName('SE1') + " E1 " + CRLF
			cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5" + CRLF
			cSQL += "               ON C5_FILIAL = E1_FILIAL" + CRLF
			cSQL += "                  AND C5_NUM = E1_PEDIDO" + CRLF
			cSQL += "                  AND C5.D_E_L_E_T_ = ' '" + CRLF
			cSQL += "                  AND C5_XNPARCE <> ' '" + CRLF
			cSQL += "WHERE  E1_FILIAL = '" + xFilial('SE1') + "' " + CRLF
			cSQL += "       AND E1_TIPO = 'NF'" + CRLF
			cSQL += "       AND E1_PEDIDO = '" + rTrim( aPedidos[nLin] ) + "'" + CRLF
			cSQL += "       AND E1_SALDO > 0" + CRLF
			cSQL += "       AND E1.D_E_L_E_T_ = ' '" + CRLF
			
			cTRB := GetNextAlias()
			cSQL := ChangeQuery( cSQL )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
			
			IF .NOT. (cTRB)->( EOF() ) 
				While .NOT. (cTRB)->( EOF() )
					SE1->( dbGoTo( (cTRB)->RECE1 ) )
					SE1->( RecLock('SE1',.F.) )
					SE1->E1_VENCTO  := MonthSum( SE1->E1_EMISSAO, (cTRB)->PARCELA )
					SE1->E1_VENCREA := DataValida( MonthSum( SE1->E1_EMISSAO, (cTRB)->PARCELA ), .T. )
					SE1->( MsUnlock() )
				
					(cTRB)->( dbSkip() )
				End
			EndIF
			(cTRB)->( dbCloseArea() )
			FErase( cTRB + GetDBExtension() )
		Next nLin
	EndIF
	MsgInfo('Processo finalizado')
Return