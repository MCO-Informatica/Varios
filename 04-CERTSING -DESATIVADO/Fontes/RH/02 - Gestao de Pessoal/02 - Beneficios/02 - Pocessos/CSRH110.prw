#Include 'Protheus.ch'

#Define cTIPO_FORNECEDOR_MEDICO '1'
#Define cTIPO_FORNECEDOR_ODONTO '2'

#Define cAMIL_ODONTO 	'001'
#Define cALLIANZ_MEDICO 	'01/02'

#Define cORIGEM_TITULAR 		'1'
#Define cORIGEM_DEPENDENTE 	'2'
#Define cORIGEM_AGREGADO 	'3'

User Function CSRH110()
	private oProcess := nil
	
	if msgYesNo( 'Deseja iniciar o processo de acerto do cadastro de plano de saúde? Esse procedimento é irreversivel, por favor realizar backup das tabelas RHK, RHL e RHL', 'Ajustar plano de saúde' )
		oProcess:=	MsNewProcess():New( {|| ProcPlano() } , 'Ajuste nos planos de saúdes' , 'Tabelas alteradas, RHK, RHL e RHM' )     //"Efetuando Conversão da Base"
		oProcess:Activate()
		msgInfo ( 'Operação concluída', 'Ajustar plano de saúde' )
	else
		msgInfo ( 'Operação cancelada', 'Ajustar plano de saúde' )
	endif
Return

Static Function ProcPlano()
	oProcess:SetRegua1(10)
			
	AjustarTit()
	AjustarDep()
	AjustarAgr()
	AjustarHis()
Return

Static Function AjustarTit()
	Local cAlias     	:= GetNextAlias() //Alias resevardo para consulta SQL
	Local cQuery  	:= '' 	//Query SQL
	Local lExeChange 	:= .T. //Executa o change Query
	Local nRec 		:= 0 	//Numero Total de Registros da consulta SQL
	Local cChave 		:= ''

	cQuery += "SELECT "
	cQuery += "	 RHK_FILIAL "
	cQuery += "	,RHK_MAT    "
	cQuery += "	,RHK_TPFORN "
	cQuery += "	,RHK_CODFOR "
	cQuery += "	,RHK_TPPLAN "
	cQuery += "	,RHK_PLANO  "
	cQuery += "	,RHK_PD     "
	cQuery += "	,RHK_PDDAGR "
	cQuery += "	,RHK_PERINI "
	cQuery += "	,RHK_PERFIM "
	cQuery += "	,RHK_TPCALC "
	cQuery += "	,RHK_CDPSAG "
	cQuery += "FROM RHK010  "
	cQuery += "WHERE        "
	cQuery += "	RHK_PERFIM = ' ' "
	cQuery += "GROUP BY     "
	cQuery += "	 RHK_FILIAL "
	cQuery += "	,RHK_MAT    "
	cQuery += "	,RHK_TPFORN "
	cQuery += "	,RHK_CODFOR "
	cQuery += "	,RHK_TPPLAN "
	cQuery += "	,RHK_PLANO  "
	cQuery += "	,RHK_PD     "
	cQuery += "	,RHK_PDDAGR "
	cQuery += "	,RHK_PERINI "
	cQuery += "	,RHK_PERFIM "
	cQuery += "	,RHK_TPCALC "
	cQuery += "	,RHK_CDPSAG "

	If U_MontarSQL(cAlias, @nRec, cQuery, lExeChange)
		RHK->(dbSetOrder(1))
		//Deleta todos os registros encontrado
		oProcess:SetRegua2(nRec)	
		oProcess:IncRegua1('1 - Deletando registros na tabela RHK')									
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF())
			cChave := (cAlias)->(RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR)
			oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHK_FILIAL+' - '+(cAlias)->RHK_MAT)
			if RHK->(dbSeek(cChave)) 
				while RHK->(!EoF()) .and. cChave == RHK->(RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR)					
					RecLock('RHK', .F.)
					RHK->(dbDelete())
					RHK->(MsUnLock())
					RHK->(DbSkip())
				end
			endif
			(cAlias)->(DbSkip())
		EndDo
		
		//Inclui novamente sem duplicidade.
		oProcess:SetRegua2(nRec)
		oProcess:IncRegua1('2 - Incluindo registros tabela RHK')
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF())
			cChave := (cAlias)->(RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR)
			oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHK_FILIAL+' - '+(cAlias)->RHK_MAT)
			if !RHK->(dbSeek(cChave)) 
				RecLock('RHK', .T.)
				RHK->RHK_FILIAL	:= (cAlias)->RHK_FILIAL	
				RHK->RHK_MAT		:= (cAlias)->RHK_MAT
				RHK->RHK_TPFORN	:= (cAlias)->RHK_TPFORN
				RHK->RHK_CODFOR	:= (cAlias)->RHK_CODFOR
				RHK->RHK_TPPLAN	:= (cAlias)->RHK_TPPLAN
				RHK->RHK_PLANO	:= (cAlias)->RHK_PLANO
				RHK->RHK_PD		:= (cAlias)->RHK_PD
				RHK->RHK_PDDAGR	:= (cAlias)->RHK_PDDAGR
				RHK->RHK_PERINI	:= (cAlias)->RHK_PERINI
				RHK->RHK_PERFIM	:= (cAlias)->RHK_PERFIM
				RHK->RHK_TPCALC	:= (cAlias)->RHK_TPCALC
				RHK->RHK_CDPSAG	:= (cAlias)->RHK_CDPSAG		
				RHK->(MsUnLock()) 		
			endif
			(cAlias)->(DbSkip())
		EndDo
		
		//Deleta planos obsoletos
		oProcess:SetRegua2(nRec)
		oProcess:IncRegua1('3 - Deletando planos obsoletos RHK')
		RHK->(dbGoTop()) //Posiciona no primeiro registro
		While RHK->(!EOF())
			oProcess:IncRegua2('Filial - Matricula: '+RHK->RHK_FILIAL+' - '+RHK->RHK_MAT)
			
			if 			(RHK->RHK_TPFORN == cTIPO_FORNECEDOR_MEDICO .and. allTrim(RHK->RHK_CODFOR) $ cALLIANZ_MEDICO) ;
				.or.   (RHK->RHK_TPFORN == cTIPO_FORNECEDOR_ODONTO .and. allTrim(RHK->RHK_CODFOR) $ cAMIL_ODONTO)
				RecLock('RHK', .F.)
				RHK->(dbDelete())
				RHK->(MsUnLock()) 		
			endif
			RHK->(DbSkip())
		EndDo		
		
		(cAlias)->(DbCloseArea())
	endif

Return

Static Function AjustarDep()
	Local cAlias     	:= GetNextAlias() //Alias resevardo para consulta SQL
	Local cQuery  	:= '' 	//Query SQL
	Local lExeChange 	:= .T. //Executa o change Query
	Local nRec 		:= 0 	//Numero Total de Registros da consulta SQL
	Local cChave 		:= ''

	cQuery := " SELECT	"
	cQuery += " 	 RHL_FILIAL "
	cQuery += " 	,RHL_MAT    "
	cQuery += " 	,RHL_TPFORN "
	cQuery += " 	,RHL_CODFOR "
	cQuery += " 	,RHL_CODIGO "
	cQuery += " 	,RHL_TPPLAN "
	cQuery += " 	,RHL_PLANO  "
	cQuery += " 	,RHL_PERINI "
	cQuery += " 	,RHL_PERFIM "
	cQuery += " 	,RHL_TPCALC "
	cQuery += " FROM RHL010     "
	cQuery += " WHERE           "
	cQuery += " 	RHL_PERFIM = ' '             "
	cQuery += " 	AND RHL_CODFOR <> '001'      "
	cQuery += " GROUP BY        "
	cQuery += " 	 RHL_FILIAL "
	cQuery += " 	,RHL_MAT    "
	cQuery += " 	,RHL_TPFORN "
	cQuery += " 	,RHL_CODFOR "
	cQuery += " 	,RHL_CODIGO "
	cQuery += " 	,RHL_TPPLAN "
	cQuery += " 	,RHL_PLANO  "
	cQuery += " 	,RHL_PERINI "
	cQuery += " 	,RHL_PERFIM "
	cQuery += " 	,RHL_TPCALC "

	If U_MontarSQL(cAlias, @nRec, cQuery, lExeChange)
		RHL->(dbSetOrder(1))
		//Deleta todos os registros encontrado
		oProcess:SetRegua2(nRec)	
		oProcess:IncRegua1('4 - Deletando registros na tabela RHL')											
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF())
			cChave := (cAlias)->(RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO)
			oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHL_FILIAL+' - '+(cAlias)->RHL_MAT)			
			if RHL->(dbSeek(cChave)) 
				while RHL->(!EoF()) .and. cChave == RHL->(RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO)
					RecLock('RHL', .F.)
					RHL->(dbDelete())
					RHL->(MsUnLock())
					RHL->(DbSkip())
				end
			endif
			(cAlias)->(DbSkip())
		EndDo
		
		//Inclui novamente sem duplicidade.
		oProcess:SetRegua2(nRec)	
		oProcess:IncRegua1('5 - Incluindo registros na tabela RHL')											
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF())
			cChave := (cAlias)->(RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO)
			oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHL_FILIAL+' - '+(cAlias)->RHL_MAT)
			if !RHL->(dbSeek(cChave)) 
				RecLock('RHL', .T.)
				RHL->RHL_FILIAL	:= (cAlias)->RHL_FILIAL
				RHL->RHL_MAT		:= (cAlias)->RHL_MAT
				RHL->RHL_TPFORN	:= (cAlias)->RHL_TPFORN
				RHL->RHL_CODFOR	:= (cAlias)->RHL_CODFOR
				RHL->RHL_CODIGO	:= (cAlias)->RHL_CODIGO
				RHL->RHL_TPPLAN	:= (cAlias)->RHL_TPPLAN
				RHL->RHL_PLANO	:= (cAlias)->RHL_PLANO
				RHL->RHL_PERINI	:= (cAlias)->RHL_PERINI
				RHL->RHL_PERFIM	:= (cAlias)->RHL_PERFIM
				RHL->RHL_TPCALC	:= (cAlias)->RHL_TPCALC
				RHL->(MsUnLock()) 		
			endif
			(cAlias)->(DbSkip())
		EndDo
		
		//Deleta registros obsoletos
		oProcess:SetRegua2(nRec)
		oProcess:IncRegua1('6 - Deletando planos obsoletos RHL')
		RHL->(dbGoTop()) //Posiciona no primeiro registro
		While RHL->(!EOF())
			oProcess:IncRegua2('Filial - Matricula: '+RHL->RHL_FILIAL+' - '+RHL->RHL_MAT)
			if 			(RHL->RHL_TPFORN == cTIPO_FORNECEDOR_MEDICO .and. allTrim(RHL->RHL_CODFOR) $ cALLIANZ_MEDICO) ;
				.or.   (RHL->RHL_TPFORN == cTIPO_FORNECEDOR_ODONTO .and. allTrim(RHL->RHL_CODFOR) $ cAMIL_ODONTO)
				RecLock('RHL', .F.)
				RHL->(dbDelete())
				RHL->(MsUnLock()) 		
			endif
			RHL->(DbSkip())
		EndDo		
		
		(cAlias)->(DbCloseArea())
	endif
Return

Static Function AjustarAgr()
	Local cAlias     	:= GetNextAlias() //Alias resevardo para consulta SQL
	Local cQuery  	:= '' 	//Query SQL
	Local lExeChange 	:= .T. //Executa o change Query
	Local nRec 		:= 0 	//Numero Total de Registros da consulta SQL
	Local cChave 		:= ''

	cQuery += " SELECT "
	cQuery += " 	 RHM_FILIAL "
	cQuery += " 	,RHM_MAT    "
	cQuery += " 	,RHM_TPFORN "
	cQuery += " 	,RHM_CODFOR "
	cQuery += " 	,RHM_CODIGO "
	cQuery += " 	,RHM_DTNASC "
	cQuery += " 	,RHM_CPF    "
	cQuery += " 	,RHM_TPPLAN "
	cQuery += " 	,RHM_PLANO  "
	cQuery += " 	,RHM_PERINI "
	cQuery += " 	,RHM_PERFIM "
	cQuery += " 	,RHM_NOME   "
	cQuery += " 	,RHM_TPCALC "
	cQuery += " FROM RHM010     "
	cQuery += " WHERE           "
	cQuery += " 	RHM_PERFIM = ' '        "
	cQuery += " 	AND RHM_CODFOR <> '001' "
	cQuery += " GROUP BY	    "
	cQuery += " 	 RHM_FILIAL "
	cQuery += " 	,RHM_MAT    "
	cQuery += " 	,RHM_TPFORN "
	cQuery += " 	,RHM_CODFOR "
	cQuery += " 	,RHM_CODIGO "
	cQuery += " 	,RHM_DTNASC "
	cQuery += " 	,RHM_CPF    "
	cQuery += " 	,RHM_TPPLAN "
	cQuery += " 	,RHM_PLANO  "
	cQuery += " 	,RHM_PERINI "
	cQuery += " 	,RHM_PERFIM "
	cQuery += " 	,RHM_NOME   "
	cQuery += " 	,RHM_TPCALC "

	If U_MontarSQL(cAlias, @nRec, cQuery, lExeChange)
		RHM->(dbSetOrder(1))
		//Deleta todos os registros encontrado
		oProcess:SetRegua2(nRec)	
		oProcess:IncRegua1('7 - Deletando registros na tabela RHM')											
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF())
			cChave := (cAlias)->(RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO)
			oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHM_FILIAL+' - '+(cAlias)->RHM_MAT)			
			if RHM->(dbSeek(cChave)) 
				while RHM->(!EoF()) .and. cChave == RHM->(RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO)
					RecLock('RHM', .F.)
					RHM->(dbDelete())
					RHM->(MsUnLock())
					RHM->(DbSkip())
				end
			endif
			(cAlias)->(DbSkip())
		EndDo
		
		//Inclui novamente sem duplicidade.
		oProcess:SetRegua2(nRec)	
		oProcess:IncRegua1('8 - Incluindo registros na tabela RHM')									
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF())
			cChave := (cAlias)->(RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO)
			oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHM_FILIAL+' - '+(cAlias)->RHM_MAT)
			if !RHM->(dbSeek(cChave)) 
				RecLock('RHM', .T.)
				RHM->RHM_FILIAL	:= (cAlias)->RHM_FILIAL
				RHM->RHM_MAT		:= (cAlias)->RHM_MAT
				RHM->RHM_TPFORN	:= (cAlias)->RHM_TPFORN
				RHM->RHM_CODFOR	:= (cAlias)->RHM_CODFOR
				RHM->RHM_CODIGO	:= (cAlias)->RHM_CODIGO
				RHM->RHM_DTNASC	:= StoD((cAlias)->RHM_DTNASC)
				RHM->RHM_CPF		:= (cAlias)->RHM_CPF
				RHM->RHM_TPPLAN	:= (cAlias)->RHM_TPPLAN
				RHM->RHM_PLANO	:= (cAlias)->RHM_PLANO
				RHM->RHM_PERINI	:= (cAlias)->RHM_PERINI
				RHM->RHM_PERFIM	:= (cAlias)->RHM_PERFIM
				RHM->RHM_NOME		:= (cAlias)->RHM_NOME
				RHM->RHM_TPCALC	:= (cAlias)->RHM_TPCALC
				RHM->(MsUnLock()) 		
			endif
			(cAlias)->(DbSkip())
		EndDo

		//Deleta registros obsoletos
		oProcess:SetRegua2(nRec)
		oProcess:IncRegua1('9 - Deletando planos obsoletos RHM')
		RHM->(dbGoTop()) //Posiciona no primeiro registro
		While RHM->(!EOF())
			oProcess:IncRegua2('Filial - Matricula: '+RHM->RHM_FILIAL+' - '+RHM->RHM_MAT)
			if 			(RHM->RHM_TPFORN == cTIPO_FORNECEDOR_MEDICO .and. allTrim(RHM->RHM_CODFOR) $ cALLIANZ_MEDICO) ;
				.or.   (RHM->RHM_TPFORN == cTIPO_FORNECEDOR_ODONTO .and. allTrim(RHM->RHM_CODFOR) $ cAMIL_ODONTO)
				RecLock('RHM', .F.)
				RHM->(dbDelete())
				RHM->(MsUnLock()) 		
			endif
			RHM->(DbSkip())
		EndDo		

		
		(cAlias)->(DbCloseArea())
	endif
Return



Static Function AjustarHis()
	Local cAlias     	:= GetNextAlias() //Alias resevardo para consulta SQL
	Local cQuery  	:= '' 	//Query SQL
	Local lExeChange 	:= .T. //Executa o change Query
	Local nRec 		:= 0 	//Numero Total de Registros da consulta SQL
	Local cChave 		:= ''

	//Seleciona todos históricos de exclusão.
	cQuery += " SELECT * FROM RHN010 WHERE RHN_OPERAC = '2' AND D_E_L_E_T_ = ' '"

	If U_MontarSQL(cAlias, @nRec, cQuery, lExeChange)
		
		//Deleta todos os registros encontrado
		oProcess:SetRegua2(nRec)	
		oProcess:IncRegua1('10 - Deletando com base no histórico')									
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF())
			if (cAlias)->RHN_ORIGEM == cORIGEM_TITULAR 
				RHK->(dbSetOrder(1))
				cChave := (cAlias)->(RHN_FILIAL+RHN_MAT+RHN_TPFORN+RHN_CODFOR)
				oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHN_FILIAL+' - '+(cAlias)->RHN_MAT)
				if RHK->(dbSeek(cChave)) 
					while RHK->(!EoF()) .and. cChave == RHK->(RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR)					
						RecLock('RHK', .F.)
						RHK->(dbDelete())
						RHK->(MsUnLock())
						RHK->(DbSkip())
					end
				endif
			elseIf (cAlias)->RHN_ORIGEM == cORIGEM_DEPENDENTE
				RHL->(dbSetOrder(1))
				cChave := (cAlias)->(RHN_FILIAL+RHN_MAT+RHN_TPFORN+RHN_CODFOR+RHN_CODIGO)
				oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHN_FILIAL+' - '+(cAlias)->RHN_MAT)
				if RHL->(dbSeek(cChave)) 
					while RHL->(!EoF()) .and. cChave == RHL->(RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO)					
						RecLock('RHL', .F.)
						RHL->(dbDelete())
						RHL->(MsUnLock())
						RHL->(DbSkip())
					end
				endif			
			elseIf (cAlias)->RHN_ORIGEM == cORIGEM_AGREGADO
				RHM->(dbSetOrder(1))
				cChave := (cAlias)->(RHN_FILIAL+RHN_MAT+RHN_TPFORN+RHN_CODFOR+RHN_CODIGO)
				oProcess:IncRegua2('Filial - Matricula: '+(cAlias)->RHN_FILIAL+' - '+(cAlias)->RHN_MAT)
				if RHM->(dbSeek(cChave)) 
					while RHM->(!EoF()) .and. cChave == RHM->(RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO)					
						RecLock('RHM', .F.)
						RHM->(dbDelete())
						RHM->(MsUnLock())
						RHM->(DbSkip())
					end
				endif
			endIf
			(cAlias)->(DbSkip())
		EndDo
				
		(cAlias)->(DbCloseArea())
	endif

Return