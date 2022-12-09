#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMR003    º Autor ³ Adriano Leonardo º Data ³ 07/02/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de forecast por matéria-prima.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCOMR003()
	Local _nCont
	Local _aSavArea := GetArea()
	Local _nMes		:= Month(dDataBase)
	Local _nAno		:= Year(dDataBase)
	Private _cRotina:= "RCOMR003"
	Private cPerg	:= "RCOMR003"
	Private _aStru 	:= {}
	Private _cAlias := GetNextAlias()
	Private _cArquivo
	Private nEstru	:= 0
	Private _aItem	:= {}
	Private _aItens	:= {}
	Private _nLin	:= 50 
	Private oFont01	:= TFont():New( "Arial",,14,,.T.,,,,.F.,.F. ) //Arial 14 - Negrito
	Private oFont02	:= TFont():New( "Arial",,09,,.F.,,,,.F.,.F. ) //Arial 09 - Normal
	Private oFont03	:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F. ) //Arial 09 - Negrito
	Private oFont04	:= TFont():New( "Arial",,11,,.T.,,,,.F.,.F. ) //Arial 11 - Negrito
	Private _cEnter	:= CHR(13) + CHR(10)
	Private _aPosMes:= {}
	Private _aMeses	:= {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
	Private _aCabCol:= {}
	Private _nAnoIni:=_nAno
	Private _nAnoFim:=_nAno

	ValidPerg() 

	If Pergunte(cPerg,.T.)
		If MV_PAR03 > 12
			Alert("Período máximo: 12 meses.","Alerta!") 
			return
		ElseIf MV_PAR03 = 0
			Alert("Campo Nº de Meses obrigatório!.","Alerta!") 
			return
		Else

			For _nCont := 1 To MV_PAR03
				AAdd(_aPosMes,{_nMes,_nAno})
				AAdd(_aCabCol,_aMeses[_nMes] + "/" + SubStr(AllTrim(Str(_nAno)),3,2))
				_nMes++

				If _nMes>12
					_nMes := 1
					_nAno++
				EndIf
			Next

			_nAnoFim := _nAno

			AADD(_aStru,{"TR_COD"      	,"C",  Len(CriaVar("B1_COD"))	,0}) //Cod.Prod.
			AADD(_aStru,{"TR_QTD"    	,"N",  TamSX3("Z2_QTM01")[01]	,0}) //Quantidade
			AADD(_aStru,{"TR_MES"    	,"N",  2								,0}) //Mês
			AADD(_aStru,{"TR_ANO"    	,"N",  4								,0}) //Ano
			AADD(_aStru,{"TR_TIPO"    	,"C",  Len(CriaVar("B1_TIPO"))								,0}) //Tipo
			AADD(_aStru,{"TR_DESCINT"    	,"C",  Len(CriaVar("B1_DESCINT"))								,0}) //Tipo

			_cArq   := CriaTrab(_aStru,.T.)
			dbUseArea(.T.,,_cArq,_cAlias,.F.,.F.)

			//IndRegua(_cAlias,_cArq,"TR_COD+TR_ANO+TR_MES+TR_TIPO",,,"Criando arquivo temporário...")  -Release 17 nao aceitou misturar tipo N com C no indice
			IndRegua(_cAlias,_cArq,"TR_COD",,,"Criando arquivo temporário...")

			Processa({ |lEnd| Selecao(@lEnd) 	},"Forecast matéria-prima","Processando forecast!"					,.T.)	
			Processa({ |lEnd| Aglutinar(@lEnd) 	},"Forecast matéria-prima","Processando dados!"						,.T.)			
			Processa({ |lEnd| GeraPDF(@lEnd) 	},"Forecast matéria-prima","Gerando relatório... Por favor aguarde!",.T.)  

		EndIf

	EndIf

	RestArea(_aSavArea)

Return()

Static Function Selecao()
	Local aProdErro := {}
	Local nErros := 0   
	Local _nMes , i   
	Local cPAEstru  := ""  
	Local nI       := 0  
	Local aPI      := {}
	Local aPI2		:= {}    
	Local lEMPE    := ( MV_PAR07 == 2 )
	Local cChvEmMp	:= ""

	If !lEMPE
		_cQry := "SELECT B1_TIPO, B1_DESCINT, Z2_PRODUTO, Z2_ANO, SUM(Z2_QTM01) [Z2_QTM01], SUM(Z2_QTM02) [Z2_QTM02], SUM(Z2_QTM03) [Z2_QTM03], SUM(Z2_QTM04) [Z2_QTM04], SUM(Z2_QTM05) [Z2_QTM05], SUM(Z2_QTM06) [Z2_QTM06], SUM(Z2_QTM07) [Z2_QTM07], SUM(Z2_QTM08) [Z2_QTM08], SUM(Z2_QTM09) [Z2_QTM09], SUM(Z2_QTM10) [Z2_QTM10], SUM(Z2_QTM11) [Z2_QTM11], SUM(Z2_QTM12) [Z2_QTM12] FROM " + RetSqlName("SZ2") + " SZ2 " + _cEnter
		_cQry += "INNER JOIN " + RetSqlName("SB1") + " SB1 " + _cEnter
		_cQry += "ON SB1.B1_COD=SZ2.Z2_PRODUTO " + _cEnter
		_cQry += "AND SB1.D_E_L_E_T_='' " + _cEnter
		_cQry += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' " + _cEnter
		//_cQry += "AND SB1.B1_MSBLQL<>'1' " + _cEnter
		_cQry += "AND SZ2.D_E_L_E_T_='' " + _cEnter
		_cQry += "AND SZ2.Z2_FILIAL='" + xFilial("SZ2") + "' " + _cEnter
		_cQry += "AND SZ2.Z2_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'" + _cEnter 
		_cQry += "AND SB1.B1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'" + _cEnter // LFSS - 09-08-2017 - 76 - Seleção de produtos
		_cQry += "AND SZ2.Z2_TOPICO='F' " + _cEnter
		_cQry += "AND SZ2.Z2_ANO BETWEEN " + AllTrim(Str(_nAnoIni)) + " AND " + AllTrim(Str(_nAnoFim)) + " " + _cEnter
		_cQry += "INNER JOIN " + RetSqlName("SA1") + " SA1 " + _cEnter
		_cQry += "ON SA1.D_E_L_E_T_='' " + _cEnter
		_cQry += "AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
		_cQry += "AND SZ2.Z2_CLIENTE=SA1.A1_COD " + _cEnter
		_cQry += "AND SZ2.Z2_LOJA=SA1.A1_LOJA " + _cEnter
		//_cQry += "AND SA1.A1_MSBLQL<>'1' " + _cEnter
		_cQry += "GROUP BY B1_TIPO,B1_DESCINT, SZ2.Z2_PRODUTO, Z2_ANO " 
	Else 

		_cQry := " SELECT B1_TIPO, B1_DESCINT, Z2_PRODUTO, Z2_ANO, SUM(Z2_QTM01) [Z2_QTM01], " + _cEnter
		_cQry += " SUM(Z2_QTM02) [Z2_QTM02], SUM(Z2_QTM03) [Z2_QTM03], SUM(Z2_QTM04) [Z2_QTM04], "+ _cEnter
		_cQry += " SUM(Z2_QTM05) [Z2_QTM05], SUM(Z2_QTM06) [Z2_QTM06], SUM(Z2_QTM07) [Z2_QTM07],"+ _cEnter
		_cQry += " SUM(Z2_QTM08) [Z2_QTM08], SUM(Z2_QTM09) [Z2_QTM09], SUM(Z2_QTM10) [Z2_QTM10], "+ _cEnter
		_cQry += " SUM(Z2_QTM11) [Z2_QTM11], SUM(Z2_QTM12) [Z2_QTM12] "+ _cEnter 
		_cQry += " FROM "+RetSqlName("SZ2")+" SZ2 "+ _cEnter

		_cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 "+ _cEnter 
		_cQry += " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+ _cEnter 
		_cQry += " AND SB1.B1_COD = SZ2.Z2_PRODUTO "+ _cEnter 
		_cQry += " AND SB1.D_E_L_E_T_ = ' ' "+ _cEnter 

		_cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1 "+ _cEnter 
		_cQry += " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+ _cEnter
		_cQry += " AND SA1.A1_COD = SZ2.Z2_CLIENTE "+ _cEnter 
		_cQry += " AND SA1.A1_LOJA = SZ2.Z2_LOJA "+ _cEnter 
		//_cQry += " AND SA1.A1_MSBLQL != '1' "+ _cEnter 
		_cQry += " AND SA1.D_E_L_E_T_= ' ' "+ _cEnter

		_cQry += " WHERE SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "+ _cEnter  
		_cQry += " AND SZ2.Z2_PRODUTO BETWEEN '' AND 'zzzzzzzzz' "+ _cEnter
		_cQry += " AND SZ2.Z2_TOPICO='F' "+ _cEnter 
		_cQry += " AND SZ2.Z2_ANO BETWEEN " + AllTrim(Str(_nAnoIni)) + " AND " + AllTrim(Str(_nAnoFim)) + " " + _cEnter 
		_cQry += " AND SZ2.D_E_L_E_T_= ' ' " + _cEnter
		_cQry += " GROUP BY B1_TIPO,B1_DESCINT, B1_COD, Z2_ANO, Z2_PRODUTO "+ _cEnter 

		/*_cQry := " SELECT G1_COD, G1_COMP, B1_TIPO, B1_DESCINT, Z2_PRODUTO, Z2_ANO, SUM(Z2_QTM01) [Z2_QTM01], "+ _cEnter
		_cQry += " SUM(Z2_QTM02) [Z2_QTM02], SUM(Z2_QTM03) [Z2_QTM03], SUM(Z2_QTM04) [Z2_QTM04]," + _cEnter
		_cQry += " SUM(Z2_QTM05) [Z2_QTM05], SUM(Z2_QTM06) [Z2_QTM06], SUM(Z2_QTM07) [Z2_QTM07]," + _cEnter
		_cQry += " SUM(Z2_QTM08) [Z2_QTM08], SUM(Z2_QTM09) [Z2_QTM09], SUM(Z2_QTM10) [Z2_QTM10],"+ _cEnter
		_cQry += " SUM(Z2_QTM11) [Z2_QTM11], SUM(Z2_QTM12) [Z2_QTM12] " + _cEnter
		_cQry += " FROM " + RetSqlName("SG1") + " SG1 "+ _cEnter

		_cQry += " INNER JOIN " + RetSqlName("SB1") + " SB1 "+ _cEnter
		_cQry += " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+ _cEnter
		_cQry += " AND SB1.B1_COD = G1_COMP " + _cEnter			
		//_cQry += " AND SB1.B1_TIPO IN ('EM','MP') " + _cEnter	   
		_cQry += " AND SB1.D_E_L_E_T_='' " + _cEnter			

		_cQry += " INNER JOIN " + RetSqlName("SZ2") + " SZ2 ON Z2_PRODUTO = G1_COD " + _cEnter			
		_cQry += " AND SZ2.Z2_FILIAL='" + xFilial("SZ2") + "' " + _cEnter   
		_cQry += " AND SZ2.Z2_TOPICO='F' " + _cEnter
		_cQry += " AND SZ2.Z2_ANO BETWEEN " + AllTrim(Str(_nAnoIni)) + " AND " + AllTrim(Str(_nAnoFim)) + " " + _cEnter
		_cQry += " AND SZ2.D_E_L_E_T_='' " + _cEnter	   

		_cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 " + _cEnter
		_cQry += " ON SA1.D_E_L_E_T_='' " + _cEnter
		_cQry += " AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
		_cQry += " AND SZ2.Z2_CLIENTE=SA1.A1_COD " + _cEnter
		_cQry += " AND SZ2.Z2_LOJA=SA1.A1_LOJA " + _cEnter
		_cQry += " AND SA1.A1_MSBLQL<>'1' " + _cEnter

		_cQry += " WHERE SG1.G1_COMP BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + _cEnter 
		_cQry += " AND SG1.D_E_L_E_T_ = '' " + _cEnter
		_cQry += " GROUP BY G1_COD,G1_COMP, B1_TIPO,B1_DESCINT, B1_COD, Z2_ANO, Z2_PRODUTO " 	           		
		_cQry += " ORDER BY Z2_PRODUTO, G1_COMP " */
	EndIf

	memowrite("RCOMR003.txt",_cQry)

	_cAliasTmp := GetNextAlias()

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)

	dbSelectArea(_cAliasTmp)

	_nQtdReg	:= 0
	_nReg		:= 0

	ProcRegua(_nQtdReg := Contar(_cAliasTmp,"!EOF()"))

	_cString := ""

	dbSelectArea(_cAliasTmp)
	dbGoTop()   

	While (_cAliasTmp)->(!EOF())

		_nReg++

		_nPerc := (_nReg * 100)/_nQtdReg

		IncProc("Avaliando estruturas: " + AllTrim(Str(Round(_nPerc,2))) + "%")

		For _nMes := 1 To MV_PAR03

			If AvalMes(_aPosMes[_nMes,1],(_cAliasTmp)->Z2_ANO)==0
				Loop
			EndIf

			nEstru		:= 0
			_cCpoMes	:= "Z2_QTM" + StrZero(_aPosMes[_nMes,1],02)

			If (_cAliasTmp)->(&_cCpoMes)==0
				Loop
			EndIf


			If nErros == 0

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄr ao¿
				//³Para ME Mercadoria de Revenda, apenas acrescentar ao³
				//³array para serem listados                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDeoÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄr aoÙ  

				If lEMPE
					cAliasSG1 := GetNextAlias()

					cQry	:= " SELECT B1_TIPO, B1_DESCINT,B1_QE, G1_COD, (" + cValtoChar((_cAliasTmp)->(&_cCpoMes)) + " * G1_QUANT / 100) QTDMP,G1_COMP,G1_QUANT FROM "+RetSqlName("SG1")+" G1 "+CRLF  

					cQry	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 " +CRLF
					cQry	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
					cQry	+= " AND SB1.B1_COD = G1.G1_COMP "+CRLF
					cQry	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

					cQry	+= " WHERE G1.G1_FILIAL = '"+xFilial("SG1")+"' "+CRLF
					cQry	+= " AND G1.G1_COD = '"+(_cAliasTmp)->Z2_PRODUTO+"' " +CRLF
					cQry	+= " AND G1.D_E_L_E_T_ = ' ' "  +CRLF
					cQry	+= " ORDER BY B1_TIPO, B1_DESCINT "+CRLF

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasSG1,.T.,.F.)

					While (cAliasSG1)->(!Eof())

						/*If (Alltrim((cAliasSG1)->G1_COD)+Alltrim((cAliasSG1)->G1_COMP)+Alltrim(_cCpoMes) $ cChvEmMp)
						(cAliasSG1)->(dbskip())
						Loop
						Else
						cChvEmMp	+= Alltrim((cAliasSG1)->G1_COD)+Alltrim((cAliasSG1)->G1_COMP)+Alltrim(_cCpoMes)+"|"					
						EndIf*/

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄõÿÿÿ¿
						//³Caso seja um PI, deve guardar o codigo para processar e considerar sua estrutura³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄõÿÿÿÙ
						If Alltrim((cAliasSG1)->B1_TIPO) != 'PA' //Ignorar PA na estrutura

							nQtd := (cAliasSG1)->QTDMP

							If 	(cAliasSG1)->B1_TIPO == 'PI' 

								If MV_PAR05 != 1 ;
								.And. (Alltrim((cAliasSG1)->G1_COMP) >= Alltrim(MV_PAR01) ); 
								.And. (Alltrim((cAliasSG1)->G1_COMP) <= Alltrim(MV_PAR02) )
								

									dbSelectArea(_cAlias)
									RecLock(_cAlias,.T.)
									TR_COD := (cAliasSG1)->G1_COMP
									TR_QTD := Round(nQtd,0)
									TR_MES := _aPosMes[_nMes,1]
									TR_ANO := _aPosMes[_nMes,2]
									TR_TIPO := (cAliasSG1)->B1_TIPO					
									TR_DESCINT := (cAliasSG1)->B1_DESCINT					
									(_cAlias)->(MsUnlock())

								EndIf

								CalcPI2((cAliasSG1)->G1_COMP, nQtd, _aPosMes[_nMes,1], _aPosMes[_nMes,2] )  

							ElseIf Alltrim((cAliasSG1)->B1_TIPO) $ "EM|MP" 							

								If Alltrim((cAliasSG1)->G1_COD) == Alltrim((_cAliasTmp)->Z2_PRODUTO) ;
								.And. (Alltrim((cAliasSG1)->G1_COMP) >= Alltrim(MV_PAR01) ); 
								.And. (Alltrim((cAliasSG1)->G1_COMP) <= Alltrim(MV_PAR02) );
								.And. (Alltrim((cAliasSG1)->B1_TIPO) $ "EM|MP")


									//Inicio a gravação da tabela temporária
									dbSelectArea(_cAlias)
									RecLock(_cAlias,.T.)
									TR_COD := (cAliasSG1)->G1_COMP
									TR_QTD := Round(nQtd,0)
									TR_MES := _aPosMes[_nMes,1]
									TR_ANO := _aPosMes[_nMes,2]
									TR_TIPO := (cAliasSG1)->B1_TIPO					
									TR_DESCINT := (cAliasSG1)->B1_DESCINT					

									(_cAlias)->(MsUnlock())
								EndIf
							EndIf

						EndIf 

						(cAliasSG1)->(DbSkip())
					EndDo

					If Select(cAliasSG1) > 0
						(cAliasSG1)->(DbCloseArea())
					EndIf 

				ElseIf(_cAliasTmp)->B1_TIPO == "ME"

					RecLock(_cAlias,.T.)
					TR_COD := (_cAliasTmp)->Z2_PRODUTO
					TR_QTD := (_cAliasTmp)->(&_cCpoMes)
					TR_MES := _aPosMes[_nMes,1]
					TR_ANO := _aPosMes[_nMes,2]
					TR_TIPO := (_cAliasTmp)->B1_TIPO				
					TR_DESCINT := (_cAliasTmp)->B1_DESCINT					
					(_cAlias)->(MsUnlock())


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Demais produtos verificar estrutura³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDeoÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Else
					cQry := " select B1_TIPO, B1_DESCINT,B1_QE, "
					//cQry += " (" + cValtoChar((_cAliasTmp)->(&_cCpoMes)) + " / B1_QE) QTDEMB, "
					cQry += " (" + cValtoChar((_cAliasTmp)->(&_cCpoMes)) + " * G1_QUANT / 100) QTDMP,G1_COMP,G1_QUANT from " + RetSqlName("SG1") + " G1 "
					cQry += " INNER JOIN " + RetSqlName("SB1") + " B1 ON B1_COD = G1_COMP AND B1.D_E_L_E_T_ = '' " 
					cQry += " WHERE G1_COD = '" + (_cAliasTmp)->Z2_PRODUTO + "'AND B1.B1_TIPO <> 'MO' AND G1.D_E_L_E_T_ = ''"
					cQry += " order by B1.B1_TIPO,B1.B1_DESCINT "

					memowrite("SG1RCOMR003.txt",cQry)

					cAliasSG1 := 'AliasSG1'
					If SELECT("AliasSG1") > 0
						AliasSG1->(DbCloseArea()) 
					Endif
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasSG1,.T.,.F.)

					dbSelectArea(cAliasSG1)
					dbGoTop()

					aPI := {} //Limpar para receber os pis do proximo produto

					While (cAliasSG1)->(!EOF())

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄõÿÿÿ¿
						//³Caso seja um PI, deve guardar o codigo para processar e considerar sua estrutura³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄõÿÿÿÙ
						If 	(cAliasSG1)->B1_TIPO <> 'PA' //Ignorar PA na estrutura

							nQtd := (cAliasSG1)->QTDMP

							If 	(cAliasSG1)->B1_TIPO == 'PI' //Nao listar PI, somente os componenntes de sua estrutura - Deo 13/03/18				
								If MV_PAR05 <> 1 // deve apresentar o PI no relatório
									dbSelectArea(_cAlias)
									RecLock(_cAlias,.T.)
									TR_COD := (cAliasSG1)->G1_COMP
									TR_QTD := Round(nQtd,0)
									TR_MES := _aPosMes[_nMes,1]
									TR_ANO := _aPosMes[_nMes,2]
									TR_TIPO := (cAliasSG1)->B1_TIPO					
									TR_DESCINT := (cAliasSG1)->B1_DESCINT					
									(_cAlias)->(MsUnlock())

								EndIf
								CalcPI((cAliasSG1)->G1_COMP, nQtd, _aPosMes[_nMes,1], _aPosMes[_nMes,2] )  
							ElseIf MV_PAR05 == 1
								If Alltrim((cAliasSG1)->B1_TIPO) $ "EM|MP|ME"
									dbSelectArea(_cAlias)
									RecLock(_cAlias,.T.)
									TR_COD := (cAliasSG1)->G1_COMP
									TR_QTD := Round(nQtd,0)
									TR_MES := _aPosMes[_nMes,1]
									TR_ANO := _aPosMes[_nMes,2]
									TR_TIPO := (cAliasSG1)->B1_TIPO					
									TR_DESCINT := (cAliasSG1)->B1_DESCINT					
									(_cAlias)->(MsUnlock())
								EndIf
							Else		
								//Inicio a gravação da tabela temporária
								dbSelectArea(_cAlias)
								RecLock(_cAlias,.T.)
								TR_COD := (cAliasSG1)->G1_COMP
								TR_QTD := Round(nQtd,0)
								TR_MES := _aPosMes[_nMes,1]
								TR_ANO := _aPosMes[_nMes,2]
								TR_TIPO := (cAliasSG1)->B1_TIPO					
								TR_DESCINT := (cAliasSG1)->B1_DESCINT					
								(_cAlias)->(MsUnlock())
							EndIf    
						Else	
							cPAEstru += "PRODUTO " + (_cAliasTmp)->Z2_PRODUTO + " TEM NA ESTRUTURA " + (cAliasSG1)->B1_DESCINT+" - " +(cAliasSG1)->B1_TIPO + CHR(13)+CHR(10)    
						EndIf 

						(cAliasSG1)->(dbskip())

					EndDo

				EndIf
			EndIf  
		Next _nMes

		dbSelectArea(_cAliasTmp)
		dbSkip()
	EndDo

	If !Empty(cPAEstru)
		Aviso("Atençao!", "Existem produtos do tipo PA na estrutura. Estes produtos foram ignorados" + cPAEstru, {"Ok"})
	EndIf 

	If nErros > 0
		nLinha:=005
		ncoluna := 005
		Alert('Atenção! Há produtos com quantidade/embalagem zerados:') 
		DEFINE MSDIALOG oDlg2 TITLE "Produtos c/ QE Zerados" FROM 000, 000  TO 600, 800 COLORS 0, 16777215 PIXEL
		@ nLinha,ncoluna LISTBOX oList2 VAR cList1 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
		'Cód',;
		'Descrição',;
		'Quant. Embalagem';
		SIZE 395,295   PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio
		oList2:SetArray(aProdErro)
		oList2:bLine	:= {|| {	aProdErro[oList2:nAt,1],; 	//
		aProdErro[oList2:nAt,2],;
		aProdErro[oList2:nAt,3]}}
		oList2:Refresh()
		ACTIVATE MSDIALOG oDlg2 CENTERED 
	Else

		dbSelectArea(_cAliasTmp)
		(_cAliasTmp)->(dbCloseArea())
	EndIf

Return() 


Static Function CalcPI(cProdPI, nQtdPI, nMesPro, nAnoPro )
	Local cQry := "" 
	Local cAliSG1 := GetNextAlias() 
	Local nQtdCalc := 0

	cQry := " select B1_TIPO, B1_DESCINT,B1_QE, "
	cQry += " (" + cValtoChar(nQtdPI) + " * G1_QUANT / 100) QTDMP,G1_COMP,G1_QUANT from " + RetSqlName("SG1") + " G1 "
	cQry += " INNER JOIN " + RetSqlName("SB1") + " B1 ON B1_COD = G1_COMP AND B1.D_E_L_E_T_ = '' "
	cQry += " WHERE G1_COD = '" + cProdPI + "' AND B1.B1_TIPO <> 'MO' AND G1.D_E_L_E_T_ = '' "
	cQry += " order by B1.B1_TIPO,B1.B1_DESCINT "

	If SELECT(cAliSG1) > 0
		(cAliSG1)->(DbCloseArea()) 
	Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliSG1,.T.,.F.)

	dbSelectArea(cAliSG1)
	dbGoTop()

	While (cAliSG1)->(!EOF())

		nQtdCalc := (cAliSG1)->QTDMP   

		If (cAliSG1)->B1_TIPO == 'PI' 
			If MV_PAR05 <> 1 
				dbSelectArea(_cAlias)
				RecLock(_cAlias,.T.)
				TR_COD := (cAliSG1)->G1_COMP
				TR_QTD := Round(nQtdCalc,0)
				TR_MES := nMesPro
				TR_ANO := nAnoPro
				TR_TIPO := (cAliSG1)->B1_TIPO					
				TR_DESCINT := (cAliSG1)->B1_DESCINT					
				(_cAlias)->(MsUnlock())

			EndIf
			CalcPI((cAliSG1)->G1_COMP, nQtdCalc, nMesPro, nAnoPro )
		ElseIf MV_PAR05 == 1

			If Alltrim((cAliSG1)->B1_TIPO) $ "EM|ME|MP"
				dbSelectArea(_cAlias)
				RecLock(_cAlias,.T.)
				TR_COD := (cAliSG1)->G1_COMP
				TR_QTD := Round(nQtdCalc,0)
				TR_MES := nMesPro
				TR_ANO := nAnoPro
				TR_TIPO := (cAliSG1)->B1_TIPO					
				TR_DESCINT := (cAliSG1)->B1_DESCINT					
				(_cAlias)->(MsUnlock())
			EndIf
		Else
			dbSelectArea(_cAlias)
			RecLock(_cAlias,.T.)
			TR_COD := (cAliSG1)->G1_COMP
			TR_QTD := Round(nQtdCalc,0)
			TR_MES := nMesPro
			TR_ANO := nAnoPro
			TR_TIPO := (cAliSG1)->B1_TIPO					
			TR_DESCINT := (cAliSG1)->B1_DESCINT					
			(_cAlias)->(MsUnlock())		
		EndIf
		(cAliSG1)->(dbskip())

	EndDo

	(cAliSG1)->(DbCloseArea())                

Return 



Static Function CalcPI2(cProdPI, nQtdPI, nMesPro, nAnoPro )
	Local cQry := "" 
	Local cAliSG1 := GetNextAlias() 
	Local nQtdCalc := 0

	cQry := " select B1_TIPO, B1_DESCINT,B1_QE, G1_COD, "
	cQry += " (" + cValtoChar(nQtdPI) + " * G1_QUANT / 100) QTDMP,G1_COMP,G1_QUANT from " + RetSqlName("SG1") + " G1 "
	cQry += " INNER JOIN " + RetSqlName("SB1") + " B1 ON B1_COD = G1_COMP AND B1.D_E_L_E_T_ = '' "
	cQry += " WHERE G1_COD = '" + cProdPI + "' AND B1.B1_TIPO <> 'MO' AND G1.D_E_L_E_T_ = '' "
	cQry += " order by B1.B1_TIPO,B1.B1_DESCINT "

	If SELECT(cAliSG1) > 0
		(cAliSG1)->(DbCloseArea()) 
	Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliSG1,.T.,.F.)

	dbSelectArea(cAliSG1)
	dbGoTop()

	While (cAliSG1)->(!EOF())

		nQtdCalc := (cAliSG1)->QTDMP   

		If (cAliSG1)->B1_TIPO == 'PI' 
			If MV_PAR05 != 1; 
			.And. Alltrim((cAliSG1)->G1_COD) == Alltrim(cProdPI) ;
			.And. (Alltrim((cAliSG1)->G1_COMP) >= Alltrim(MV_PAR01) ); 
			.And. (Alltrim((cAliSG1)->G1_COMP) <= Alltrim(MV_PAR02) )

				dbSelectArea(_cAlias)
				RecLock(_cAlias,.T.)
				TR_COD := (cAliSG1)->G1_COMP
				TR_QTD := Round(nQtdCalc,0)
				TR_MES := nMesPro
				TR_ANO := nAnoPro
				TR_TIPO := (cAliSG1)->B1_TIPO					
				TR_DESCINT := (cAliSG1)->B1_DESCINT					
				(_cAlias)->(MsUnlock())

			EndIf
			CalcPI2((cAliSG1)->G1_COMP, nQtdCalc, nMesPro, nAnoPro )

		ElseIf Alltrim((cAliSG1)->B1_TIPO) $ "EM|MP"
			If Alltrim((cAliSG1)->G1_COD) == Alltrim(cProdPI) ;
			.And. (Alltrim((cAliSG1)->G1_COMP) >= Alltrim(MV_PAR01) ); 
			.And. (Alltrim((cAliSG1)->G1_COMP) <= Alltrim(MV_PAR02) )

				dbSelectArea(_cAlias)
				RecLock(_cAlias,.T.)
				TR_COD := (cAliSG1)->G1_COMP
				TR_QTD := Round(nQtdCalc,0)
				TR_MES := nMesPro
				TR_ANO := nAnoPro
				TR_TIPO := (cAliSG1)->B1_TIPO					
				TR_DESCINT := (cAliSG1)->B1_DESCINT					

				(_cAlias)->(MsUnlock())
			EndIf
		EndIf
		(cAliSG1)->(dbskip())

	EndDo

	(cAliSG1)->(DbCloseArea())                

Return 




Static Function Aglutinar()
	Local _nPosMes			
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	_cProd := (_cAlias)->TR_COD
	_aItem := {(_cAlias)->TR_COD,0,0,0,0,0,0,0,0,0,0,0,0,(_cAlias)->TR_TIPO,(_cAlias)->TR_DESCINT}
	_aItens:= {}

	While (_cAlias)->(!EOF())

		If _cProd <> (_cAlias)->TR_COD
			aAdd(_aItens,_aItem)
			_aItem := {(_cAlias)->TR_COD,0,0,0,0,0,0,0,0,0,0,0,0,(_cAlias)->TR_TIPO, (_cAlias)->TR_DESCINT}
		EndIf

		For _nPosMes := 1 To Len(_aPosMes)
			If (_aPosMes[_nPosMes,1] == (_cAlias)->TR_MES) .And. (_aPosMes[_nPosMes,2] == (_cAlias)->TR_ANO)
				_aItem[_nPosMes+1] +=(_cAlias)->TR_QTD
				Exit
			EndIf
		Next

		_cProd := (_cAlias)->TR_COD

		dbSelectArea(_cAlias)
		(_cAlias)->(dbSkip())
	EndDo

	aAdd(_aItens,_aItem)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())

Return()


Static Function GeraPDF()

	_cFile		:= _cRotina+DtoS(dDataBase)+Replace(Time(),":","")
	_nTipoImp	:= IMP_PDF
	_lPropTMS	:= .F.
	_lDsbSetup	:= .T.
	_lTReport	:= .F.
	_cPrinter	:= ""
	_lServer	:= .F.
	_lPDFAsPNG	:= .T.
	_lRaw		:= .F.
	_lViewPDF	:= .T.
	_nQtdCopy	:= 1                 
	_lGerExcel  := IIf(MV_PAR06 == 1, .T., .F.)  
	_cArExcel   := GetTempPath()+'RelMatForecast'+ DtoS(MsDate())+STRTRAN(Time(), ":", "")+'.xml'

	If _lGerExcel   
		oExcelPrv := FWMsExcelEx():New()
		oExcelPrv:AddworkSheet("Rel Materiais")
		oExcelPrv:AddTable("Rel Materiais","Relatório de Materiais - Base Forecast")
	Else
		oPrn := FWMsPrinter():New(_cFile, _nTipoImp, _lPropTMS, /*_cDiretory*/, _lDsbSetup, _lTReport,, _cPrinter, _lServer, _lPDFAsPNG, _lRaw, _lViewPDF, _nQtdCopy)

		oPrn:SetResolution(72)
		oPrn:SetLandScape()	// Orientação do Papel (Paisagem)
		oPrn:SetPaperSize(9)
		oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior

		oPrn:StartPage()
	EndIf

	ImpCab()
	ImpItens()

	If _lGerExcel   
		oExcelPrv:Activate()
		oExcelPrv:GetXMLFile(_cArExcel)   

		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(_cArExcel)     //Abre uma planilha
		oExcel:SetVisible(.T.)                 //Visualiza a planilha
		oExcel:Destroy()       
	Else
		oPrn:EndPage()
		oPrn:Preview()    
	EndIf

Return()

Static Function ImpCab()
	Local nX := 0            

	If _lGerExcel   
		oExcelPrv:AddColumn("Rel Materiais","Relatório de Materiais - Base Forecast","Tipo",1,1) 
		oExcelPrv:AddColumn("Rel Materiais","Relatório de Materiais - Base Forecast","Codigo",1,1)
		oExcelPrv:AddColumn("Rel Materiais","Relatório de Materiais - Base Forecast","Item",1,1)
		oExcelPrv:AddColumn("Rel Materiais","Relatório de Materiais - Base Forecast","Ped.Compras",2,2)
		oExcelPrv:AddColumn("Rel Materiais","Relatório de Materiais - Base Forecast","Saldo Disp.",2,2)
		oExcelPrv:AddColumn("Rel Materiais","Relatório de Materiais - Base Forecast","Qtde. Tot",2,2)  

		For nX := 1 to MV_PAR03 
			oExcelPrv:AddColumn("Rel Materiais","Relatório de Materiais - Base Forecast",_aCabCol[nX],2,2)
		Next

		oExcelPrv:SetCelBold(.T.)
		oExcelPrv:SetCelFont('Arial')
		oExcelPrv:SetCelItalic(.T.)  
	Else
		_nLin := 0040

		oPrn:SayAlign( _nLin, 0003, "Relatório de Materiais - Base Forecast " + iIf(!Empty(MV_PAR01),"      Produto: " + MV_PAR01 + " ate " + MV_PAR02,""), oFont01, 0760-0003,0000,,2,1)
		oPrn:SayAlign( _nLin, 0650, DtoC(Date())+' '+Time()	, oFont02, 0120		,0000,,1,1)
		_nLin += 0015

		oPrn:Line(_nLin, 0001, _nLin, 2300, ,"-8")

		_nLin += 0015

		//Adiciono os rótulos das colunas
		oPrn:SayAlign( _nLin, 0003, "Item"			, oFont02, 0160-0003,0000,,0,1)
		//oPrn:SayAlign( _nLin, 0150, "Tipo"			, oFont02, 0170-0150,0000,,0,1)
		oPrn:SayAlign( _nLin, 0160, "Ped.Compras"	, oFont02, 0220-0170,0000,,1,1)  // LFSS 09-08-2017 - 76 - oPrn:SayAlign( _nLin, 0170, "Saldo Atual"	, oFont02, 0230-0170,0000,,1,1)
		oPrn:SayAlign( _nLin, 0220, "Saldo Disp."	, oFont02, 0280-0230,0000,,1,1)
		oPrn:SayAlign( _nLin, 0280, "Qtde. Tot"		, oFont02, 0050		,0000,,1,1)
		nCol := 0290 
		For nX := 1 to MV_PAR03
			oPrn:SayAlign( _nLin, nCol+(40*nX), _aCabCol[nX]	, oFont02, 0040		,0000,,1,1)
		Next

		_nLin += 0010

		oPrn:Line(_nLin, 0001, _nLin, 2300, ,"-8")

		_nLin += 0010
	EndIf

Return()

Static Function ImpItens()
	Local _nCont   
	Local cTipo := ''   
	Local nX := 0  
	Local cLocEst	:= SuperGetMv("ES_ARMAEST",.T.,'01/03') 		// Data minima a ser considerada para processamento 
	Local cLocSB2   := '' 
	Local nLocEst	:= 0    

	For nLocEst := 1 To Len(cLocEst)  
		cLocSB2 += Iif(!Empty(cLocSB2), "', '", '') + SubStr(cLocEst, nLocEst, 2) 
		nLocEst+=2
	Next nLocEst

	ASort(_aItens, , , {|x,y|x[14]+x[15] < y[14]+y[15]})	
	For _nCont := 1 To Len(_aItens)

		dbSelectArea("SB1")
		dbSetOrder(1)
		If SB1->(msSeek(xFilial("SB1")+_aItens[_nCont,01]))
			_cQrySb2 := "SELECT ISNULL(SUM(B2_QATU),0) [B2_QATU],ISNULL(SUM(B2_SALPEDI),0) [B2_SALPEDI], "+CRLF

			If MV_PAR08 == 1
				_cQrySb2 += " ISNULL(SUM(B2_QATU-B2_QEMP-B2_RESERVA)-B1_ESTSEG,0) [B2_DISP] "+CRLF
			Else
				_cQrySb2 += " ISNULL(SUM(B2_QATU-B2_QEMP-B2_RESERVA),0) [B2_DISP] "+CRLF
			EndIf

			_cQrySb2 += " FROM " + RetSqlName("SB2") + " SB2 " // LFSS - 09-08-2017 - 76 - _cQrySb2 := "SELECT ISNULL(SUM(B2_QATU),0) [B2_QATU], ISNULL(SUM(B2_QATU-B2_QEMP-B2_RESERVA),0) [B2_DISP] FROM " + RetSqlName("SB2") + " SB2 "

			_cQrySb2 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
			_cQrySb2 += " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
			_cQrySb2 += " AND SB1.B1_COD = SB2.B2_COD "+CRLF
			_cQrySb2 += " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

			_cQrySb2 += "WHERE SB2.D_E_L_E_T_=' ' "+CRLF
			_cQrySb2 += "AND SB2.B2_FILIAL='" + xFilial("SB2") + "' "+CRLF
			_cQrySb2 += "AND SB2.B2_COD='" + SB1->B1_COD + "' "+CRLF
			_cQrySb2 += "AND SB2.B2_LOCAL IN ('"+cLocSB2+"') " +CRLF
			_cQrySb2 += " GROUP BY B1_ESTSEG "

			_cAliasSb2 := 'AliasSb2'
			If SELECT("AliasSb2") > 0
				AliasSb2->(DbCloseArea()) 
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySb2),_cAliasSb2,.T.,.F.)

			dbSelectArea(_cAliasSB2)
			_nSalPdi    :=(_cAliasSB2)->B2_SALPEDI // LFSS - 09-08-2017 - 76 - Saldo dos pedidos de compras 
			_nSldAtu	:=(_cAliasSB2)->B2_QATU
			_nSldDisp	:=(_cAliasSB2)->B2_DISP

			dbSelectArea(_cAliasSB2)
			(_cAliasSB2)->(dbCloseArea())
			_nTotQtd := 0

			For nX := 1 to MV_PAR03
				_nTotQtd += _aItens[_nCont,nX+1]
			Next                                                                                                 


			If MV_PAR04 == 3 .Or. ( MV_PAR04 == 1 .And. _nTotQtd > 0 .And. _nSldDisp <= _nTotQtd ) .Or. (MV_PAR04 == 2 .And. (_nTotQtd == 0 .Or. _nSldDisp > _nTotQtd)  )
				If SB1->B1_TIPO != cTipo
					_nLin+=5  

					If _lGerExcel
					Else  
						oPrn:SayAlign( _nLin, 0003, SB1->B1_TIPO												, oFont04, 0150-0003,0000,,0,1) //Descrição interna do produto
						_nLin+=15   
					EndIf
				EndIf
				cTipo := SB1->B1_TIPO

				If _lGerExcel 
					Do Case
						Case MV_PAR03 == 1  
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2]}) 
						Case MV_PAR03 == 2  
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3]}) 
						Case MV_PAR03 == 3  
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4]}) 
						Case MV_PAR03 == 4  
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5]}) 
						Case MV_PAR03 == 5
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5], _aItens[_nCont,6]}) 
						Case MV_PAR03 == 6
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5], _aItens[_nCont,6], _aItens[_nCont,7]})
						Case MV_PAR03 == 7 
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5], _aItens[_nCont,6], _aItens[_nCont,7], _aItens[_nCont,8]})
						Case MV_PAR03 == 8  
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5], _aItens[_nCont,6], _aItens[_nCont,7], _aItens[_nCont,8], _aItens[_nCont,9]})
						Case MV_PAR03 == 9 
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5], _aItens[_nCont,6], _aItens[_nCont,7], _aItens[_nCont,8], _aItens[_nCont,9], _aItens[_nCont,10]})
						Case MV_PAR03 == 10 
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5], _aItens[_nCont,6], _aItens[_nCont,7], _aItens[_nCont,8], _aItens[_nCont,9], _aItens[_nCont,10], _aItens[_nCont,11]})
						Case MV_PAR03 == 11  
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5], _aItens[_nCont,6], _aItens[_nCont,7], _aItens[_nCont,8], _aItens[_nCont,9], _aItens[_nCont,10], _aItens[_nCont,11], _aItens[_nCont,12]})
						Case MV_PAR03 == 12
						oExcelPrv:AddRow("Rel Materiais","Relatório de Materiais - Base Forecast",{SB1->B1_TIPO, _aItens[_nCont,1], SB1->B1_DESCINT,Transform(int(_nSalPdi),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(int(_nSldDisp),"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/),Transform(_nTotQtd,"@E 999,999,999"), _aItens[_nCont,2], _aItens[_nCont,3], _aItens[_nCont,4], _aItens[_nCont,5], _aItens[_nCont,6], _aItens[_nCont,7], _aItens[_nCont,8], _aItens[_nCont,9], _aItens[_nCont,10], _aItens[_nCont,11], _aItens[_nCont,12], _aItens[_nCont,13]})
					EndCase

				Else
					oPrn:SayAlign( _nLin, 0003, SB1->B1_DESCINT												, oFont02, 0160-0003,0000,,0,1) //Descrição interna do produto
					oPrn:SayAlign( _nLin, 0160, Transform(int(_nSalPdi)			,"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/)		, oFont02, 0220-0160,0000,,1,1) //Saldo Atual // LFSS - 09-08-2017 - 76 - oPrn:SayAlign( _nLin, 0170, Transform(_nSldAtu			,PesqPict("SB2","B2_QATU"))		, oFont02, 0230-0170,0000,,1,1) //Saldo Atual
					oPrn:SayAlign( _nLin, 0220, Transform(int(_nSldDisp)		,"@E 999,999,999"/*PesqPict("SB2","B2_QATU")*/)		, oFont02, 0280-0220,0000,,1,1) //Saldo disponível
					oPrn:SayAlign( _nLin, 0280, Transform(_nTotQtd				,"@E 999,999,999")				, oFont02, 0050,0000,,1,1)
					nCol := 0290 
					For nX := 1 to MV_PAR03
						oPrn:SayAlign( _nLin, nCol+(40*nX), Transform(_aItens[_nCont,(nX+1)],PesqPict("SZ2","Z2_QTM01"))	, oFont02, 0040		,0000,,1,1)
					Next      

					If _nLin > 600
						oPrn:EndPage()
						oPrn:StartPage()				
						ImpCab()
					Else
						_nLin += 15
					EndIf					
				EndIf
			EndIf

			//Verifico se haverá quebra de página
		EndIf
	Next	
Return()

Static Function ValidPerg()

	Local _sAlias	:= GetArea()
	Local aRegs		:= {}
	Local _x		:= 1
	Local _y		:= 1
	cPerg			:= PADR(cPerg,10)

	AADD(aRegs,{cPerg,"01","De produto?	"			,"","","mv_ch1","C",TamSx3("B1_COD")[01],TamSx3("B1_COD")[02],0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
	AADD(aRegs,{cPerg,"02","Até produto? "			,"","","mv_ch2","C",TamSx3("B1_COD")[01],TamSx3("B1_COD")[02],0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
	AADD(aRegs,{cPerg,"03","Nº de Meses: (até 12)"	,"","","mv_ch3","N",02,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Necessidade Compra:"	,"","","mv_ch4","N",01,0,0,"C","","MV_PAR04","Com Necessidade","Com Necessidade","Com Necessidade","","","Sem Necessidade","Sem Necessidade","Sem Necessidade","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Somente EM/ME/MP?"		,"","","mv_ch5","N",01,0,0,"C","","MV_PAR05","Sim","Sim","Sim","","","Todos","Todos","Todos","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Exporta Excel?"			,"","","mv_ch6","N",01,0,0,"C","","MV_PAR06","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Tipo Base Relatorio?"	,"","","mv_ch7","N",01,0,0,"C","","MV_PAR07","PA/ME","PA/ME","PA/ME","","","MP/EM","MP/EM","MP/EM","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Cons.Estoque Seg. ?"	,"","","mv_ch8","N",01,0,0,"C","","MV_PAR08","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","",""})

	For _x := 1 To Len(aRegs)
		dbSelectArea("SX1")
		SX1->(dbSetOrder(1))
		If !SX1->(MsSeek(cPerg+aRegs[_x,2],.T.,.F.))
			RecLock("SX1",.T.)		
			For _y := 1 To FCount()
				If _y <= Len(aRegs[_x])
					FieldPut(_y,aRegs[_x,_y])
				Else
					Exit
				EndIf
			Next
			SX1->(MsUnlock())
		EndIf
	Next

	RestArea(_sAlias)

Return()

Static Function AvalMes(_nMesTmp,_nAnoTmp)

	Local _nRet		:= 0
	Local _nPosMes	:= 1
	Default _nMesTmp:= 0
	Default _nAnoTmp:= 0

	For _nPosMes := 1 To Len(_aPosMes)
		If (_aPosMes[_nPosMes,1] == _nMesTmp) .And. (_aPosMes[_nPosMes,2] == _nAnoTmp)
			_nRet := _nPosMes
			Exit
		EndIf
	Next

Return(_nRet)
