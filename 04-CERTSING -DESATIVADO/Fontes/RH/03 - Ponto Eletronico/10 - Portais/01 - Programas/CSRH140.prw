#Include "Protheus.ch"
#Include "TopConn.ch"

#Define cPERG		'ADCNOTURNO'
#Define cCAMINHO	'c:\temp\adcnoturno.xml'

/*/{Protheus.doc} CSRH130
Adicional Noturno de banco de horas Certisign. Gera em CSV uma lista dos banco de horas ordenado por pelas negativas,
depois horas positivas ordenada por ordem de valorização - 55%, 75%, 100%.
Opção de Adicional Noturno, Composição de acumulado, Acumulado e todos.
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH140()
	private oFWMsExcel	//Variavel para gerar Excel
	private oExcel		//Variavel para gerar Excel

 	AjustaSx1() 				//Criar pergunte caso não exista no SX1
	if pergunte(cPERG, .T.) 	//Exibe para o usuário tela de parâmetros
		Processa( {|| Proc140() }, "Aguarde...", "Gerando conferência adicional noturno.",.F.)
	endif
Return

/*/{Protheus.doc} Proc140()
Executa o processamento
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Proc140()
	local aLista 		:= {}	//Lista do banco de horas
	local cAlias     	:= GetNextAlias() //Alias resevardo para consulta SQL
	local cChaveAnt		:= ''	//Chave Anterior para verificar quebra da lista
	local cQuery  		:= '' 	//Query SQL
	local lExeChange 	:= .T. //Executa o change Query
	local nRec 			:= 0 	//Numero Total de Registros da consulta SQL
	local cChave 	  	:= ''
	local dDataOrdem 	:= ctod('//')

	ProcRegua(0)	//Inicia barra de progressão infinita
	U_CriarDir(cCAMINHO)	//Cria diretorio caso não exista
	cQuery := MontaQry() //Monta consulta SQL para lista banco de horas

	If U_MontarSQL(cAlias, @nRec, cQuery, lExeChange) //Caso a consulta retorno registro faça:
		oFWMsExcel := FWMSExcel():New() //Criando o objeto que irá gerar o conteúdo do Excel

		SP8->(dbSetOrder(1)) //P8_FILIAL+P8_MAT+P8_ORDEM+Dtos(P8_DATA)+Str(P8_HORA,5,2)
		SPC->(dbSetOrder(1)) //PC_FILIAL+PC_MAT+PC_PD+DTOS(PC_DATA)+PC_TPMARCA+PC_CC+PC_DEPTO+PC_POSTO+PC_CODFUNC

		CabAba1()

		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		While (cAlias)->(!EOF()) //Enquanto não for fim de arquivo

			if (cAlias)->(P8_FILIAL+P8_MAT+P8_ORDEM) == cChaveAnt //Verifica se mudou de funcionario para iniciar quebra
				(cAlias)->(DbSkip())
			endif
			aAux := ARRAY(13)
			aAux[01] := (cAlias)->P8_FILIAL
			aAux[02] := (cAlias)->P8_MAT
			aAux[03] := (cAlias)->P8_ORDEM

			dDataOrdem := stod(left((cAlias)->P8_PAPONTA,8)) + (val((cAlias)->P8_ORDEM)-1)
			aAux[04] := dtoc(dDataOrdem)


			if SPC->(dbSeek( (cAlias)->(P8_FILIAL+P8_MAT)+'025'+dtos(dDataOrdem)))
				aAux[05] := replace(StrZero(SPC->PC_QUANTC  , ZeroEsquer(SPC->PC_QUANTC, .F.), 2 ),'.',':')  //9
			else
				aAux[05] :=  '00:00'
			endif


			if SP8->(dbSeek((cAlias)->(P8_FILIAL+P8_MAT+P8_ORDEM)))
				nHora 	:= 6
				cChave := (cAlias)->(P8_FILIAL+P8_MAT+P8_ORDEM)
				while SP8->(!EoF()) .And. SP8->(P8_FILIAL+P8_MAT+P8_ORDEM) == cChave
					if ALLTRIM(SP8->P8_TPMCREP) != 'D'
						aAux[nHora] := replace(StrZero(SP8->P8_HORA  , ZeroEsquer(SP8->P8_HORA, .F.), 2 ),'.',':')
						nHora++
					endif
					SP8->(dbSkip())
				end
			endif

			aAdd( aLista, aAux )

			cChaveAnt := (cAlias)->(P8_FILIAL+P8_MAT+P8_ORDEM) //Carrega chave anterior
			(cAlias)->(DbSkip())
		EndDo

		ListaAba( aLista	, .F., "Adicional Noturno","Adicional Noturno", 12) //Monta lista no excel do Adicional Noturno
		GrvExcel() //Fecha o componente do excel e abre para o usuário manipular.

		(cAlias)->(DbCloseArea()) //Fecha alias temporario da consulta SQL.
	endif

Return()



Static Function MontaQry()
	local cRetorno := ''

	cRetorno += " SELECT "
	cRetorno += " 		P8_FILIAL  "
	cRetorno += " 	, 	P8_MAT  "
	cRetorno += " 	, 	RA_NOME  "
	cRetorno += " 	, 	P8_DATA "
	cRetorno += " 	, 	P8_ORDEM "
	cRetorno += " 	, 	P8_HORA HORA "
	cRetorno += " 	, 	P8_CC  "
	cRetorno += " 	, 	P8_PAPONTA  "
	cRetorno += " FROM  "
	cRetorno += " 	"+RetSqlName("SP8")+" SP8 "
	cRetorno += " LEFT JOIN "+RetSqlName("SRA")+" SRA ON "
	cRetorno += " 	SRA.D_E_L_E_T_ = ' ' "
	cRetorno += " 	AND SRA.RA_FILIAL = P8_FILIAL "
	cRetorno += " 	AND SRA.RA_MAT = P8_MAT "
	cRetorno += " WHERE  "
	cRetorno += " 	SP8.D_E_L_E_T_ = ' ' "
	cRetorno += " 	AND (P8_HORA >= 22 OR (P8_HORA >= 0 AND P8_HORA <= 5 )) "
	cRetorno += " 	AND P8_TPMCREP <> 'D' "
	cRetorno += " 	AND P8_DATA BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
	cRetorno += " 	AND P8_ORDEM <> '' "
	cRetorno += " 	AND P8_PAPONTA <> '' "
	cRetorno += " GROUP BY "
	cRetorno += " 	P8_FILIAL, P8_CC, P8_MAT, RA_NOME, P8_ORDEM, P8_DATA, P8_HORA, P8_PAPONTA "
	cRetorno += " ORDER BY  "
	cRetorno += " 	P8_FILIAL, P8_CC, P8_MAT, RA_NOME, P8_ORDEM, P8_DATA, P8_HORA, P8_PAPONTA "

Return cRetorno

/*/{Protheus.doc} zTstExc1
Função que cria um exemplo de FWMsExcel
@author Atilio
@since 06/08/2016
@version 1.0
	@example
	u_zTstExc1()
/*/

Static Function CabAba1()

	//Aba 02 - Produtos
	oFWMsExcel:AddworkSheet("Adicional Noturno")

	//Criando a Tabela
	oFWMsExcel:AddTable( "Adicional Noturno","Adicional Noturno")
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","Filial",1) //1
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","Matrícula",1) //2
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","Ordem",1)//3
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","Data",1)//3
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","H. Apontada",1)//4
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","1E",1)//5
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","1S",1)//6
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","2E",1)//7
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","2S",1)//8
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","3E",1)//9
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","3S",1)//10
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","4E",1)//11
	oFWMsExcel:AddColumn("Adicional Noturno","Adicional Noturno","4S",1)//12
Return


Static Function GrvExcel()

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cCAMINHO)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cCAMINHO) 	//Abre uma planilha
	oExcel:SetVisible(.T.) 				//Visualiza a planilha
	oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas

Return()

Static Function ListaAba(aLista, lVazio, cSheet, cTable, nTam)
	local i := 0

	default nTam := 0

	default lVazio := .F.

	if len(aLista) > 0
		for i := 1 to len(aLista)
			nTam := len(aLista[i])
			//Criando as Linhas... Enquanto não for fim da query
			oFWMsExcel:AddRow(cSheet, cTable, aLista[i])
		next i
	endif

	if lVazio
		oFWMsExcel:AddRow(cSheet, cTable, array(nTam))
	endif
Return

Static Function ZeroEsquer(nVal, lTotNegativo)
	local nRetorno := 0
	local nTamanho := len(cValToChar(int(nVal)))
	local nSinal 	 := iif(lTotNegativo, 1, 0)

	if nTamanho == 0 .Or. nTamanho == 1 .Or. nTamanho == 2
		nRetorno := 5+nSinal
	else
		nRetorno := nTamanho+3
	endif
Return nRetorno


Static Function AjustaSx1()
	xPutSx1( cPERG, "01","Data De?"		, "Data De?"	, "Data De?"	,"mv_ch1", "D",08,0,0,"G",""			,""	,"","","mv_par01","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "02","Data Até?"	, "Data Até?"	, "Data Até?"	,"mv_ch2", "D",08,0,0,"G",""			,""	,"","","mv_par02","","","","","","","","","","","","","","","","",,,)
Return

Static Function xPutSx1(	cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
							cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
							cF3, cGrpSxg,cPyme,;
							cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
							cDef02,cDefSpa2,cDefEng2,;
							cDef03,cDefSpa3,cDefEng3,;
							cDef04,cDefSpa4,cDefEng4,;
							cDef05,cDefSpa5,cDefEng5,;
							aHelpPor,aHelpEng,aHelpSpa,cHelp)

	local aArea	:= GetArea()
	local cKey
	local lPort	:= .f.
	local lSpa		:= .f.
	local lIngl 	:= .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme   	:= Iif( cPyme   	== Nil, " ", cPyme  	)
	cF3     	:= Iif( cF3     	== NIl, " ", cF3   	)
	cGrpSxg	:= Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01  	:= Iif( cCnt01  	== Nil, "" , cCnt01	)
	cHelp    	:= Iif( cHelp   	== Nil, "" , cHelp  	)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt	:= If(! "?" $ cPergunt 	.And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
	  	cPerSpa  	:= If(! "?" $ cPerSpa 	.And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
	  	cPerEng   	:= If(! "?" $ cPerEng 	.And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

	 	Reclock( "SX1" , .T. )

		Replace X1_GRUPO		With cGrupo
		Replace X1_ORDEM   	With cOrdem
		Replace X1_PERGUNT 	With cPergunt
		Replace X1_PERSPA 	With cPerSpa
		Replace X1_PERENG 	With cPerEng
		Replace X1_VARIAVL 	With cVar
		Replace X1_TIPO    	With cTipo
		Replace X1_TAMANHO 	With nTamanho
		Replace X1_DECIMAL 	With nDecimal
		Replace X1_PRESEL 	With nPresel
		Replace X1_GSC    	With cGSC
		Replace X1_VALID   	With cValid
		Replace X1_VAR01   	With cVar01
		Replace X1_F3      	With cF3
		Replace X1_GRPSXG 	With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
		Replace X1_HELP With cHelp
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		MsUnlock()
	Else
		lPort 	:= ! "?" $ X1_PERGUNT	.And. ! Empty(SX1->X1_PERGUNT)
		lSpa 	:= ! "?" $ X1_PERSPA 	.And. ! Empty(SX1->X1_PERSPA)
		lIngl	:= ! "?" $ X1_PERENG 	.And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )
Return