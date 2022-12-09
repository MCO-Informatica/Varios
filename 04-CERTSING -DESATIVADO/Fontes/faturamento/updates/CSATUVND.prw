#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'

/*

1 - Fazer Replace no campo A1_VEN = "VA0001" em todos os registros da SA1.
2 - Executar CSATUVND()
3 - Alterar Ponto de Entrada MTA410T.PRW

*/
User Function CSATUVND()
	
	//-- Informa o servidor que nao ira consumir licensas.
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO 'FAT' TABLES 'SA1', 'SC5', 'SA3'
	
		processa( {|| ProcAtuVnd() }, "CSATUVND", "Processando aguarde...", .f.)
		
	RESET ENVIRONMENT
	
Return



Static Function ProcAtuVnd()

	Local cQuery := ""
	Local cTmp   := GetNextAlias()
	
	cQuery := " SELECT a1.A1_COD, " 
	cQuery += "        a1.A1_NOME, "
	cQuery += "        c5.C5_NUM, " 
	cQuery += "        c5.C5_CLIENTE, " 
	cQuery += "        c5.C5_EMISSAO, "
	cQuery += "        c5.C5_VEND1 "
	cQuery += " FROM   " + RetSqlName("SA1") + " a1 " 
	cQuery += "        INNER JOIN " + RetSqlName("SC5") + " c5 " 
	cQuery += "                ON a1.A1_COD = c5.C5_CLIENT "  
	cQuery += "        INNER JOIN " + RetSqlName("SA3") + " a3 " 
	cQuery += "                ON a3.A3_COD = c5.C5_VEND1 " 
	cQuery += " WHERE  c5.C5_EMISSAO BETWEEN '20160101' AND '20181231' "
	cQuery += "        AND (a3.A3_XCANAL = '000001' OR a3.A3_XCANAL = '000003') "
	cQuery += "        AND a1.D_E_L_E_T_ = ' ' "
	cQuery += "        AND c5.D_E_L_E_T_ = ' ' "
	cQuery += "        AND a3.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER  BY c5.C5_CLIENTE, c5.C5_EMISSAO "
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cTmp, .F., .T. ) 
	
	
	(cTmp)->(dbGoTop())
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	
	Conout("### INICIANDO ATUALIZAÇÂO [CSATUCND]")
	While (cTmp)->(!Eof())
		
		IF SA1->( DbSeek( xFilial("SA1") + (cTmp)->C5_CLIENTE ) )
			
			If SA1->A1_VEND == (cTmp)->C5_VEND1
				(cTmp)->(dbSkip())
				Loop
			Else
				RecLock("SA1",.F.)
					SA1->A1_VEND := (cTmp)->C5_VEND1
				SA1->(MsUnLock())
			EndIf
			
		EndIf
		
		(cTmp)->(dbSkip())
		
	Enddo
	Conout("### ATUALIZACAO REALIZADA COM SUCESSO [CSATUCND]")
	
Return