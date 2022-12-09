

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HCIR016  ³ Autor ³ Aline Catarina        ³ Data ³ 30/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pick-List (Pedido de Venda)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBS		 | Ulizado como base para alteração o programa MATR775.prx    |±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HCIR016()

Local oReport
Private lPyme      := Iif(Type("__lPyme") <> "U",__lPyme,.F.)	
Private lAglutGrad := .F.

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	U_HCIR016R3()
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 30/01/07 ³Aline Catarina ³Alteracoes p/ impressao do Pick-List        |±±            
±±³     	 |		  		 |do Pedido de Vendas.						  |±±     
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local cCodProd 	 := ""
Local cDescProd	 := ""
Local cLote		 := ""
Local cSubLote	 := ""
Local nTotQuant	 := 0
Local dDtValid   := dDatabase
Local cNPedido	 := ""
Local cLocal	 := ""
Local cPotenci	 := ""

#IFDEF TOP
	Local cAliasSC6 := GetNextAlias()
#ELSE
	Local cAliasSC6 := "SC6"
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("HCIR016","PICK-LIST","HCR016", {|oReport| ReportPrint(oReport,cAliasSC6)},"Emissao de produtos a serem separados pela expedicao, para determinada faixa de Pedido de Vendas.") 
oReport:SetPortrait() 
oReport:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1("HCR016")
Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPickList := TRSection():New(oReport,"PICK-LIST",{"SC6","SB1","SB2","SB4"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oPickList:SetTotalInLine(.F.)

TRCell():New(oPickList,"CCODPROD"	,/*Tabela*/	,RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| IIF(lAglutGrad ,Substr(cCodProd,1,ntamref),cCodProd)	})
TRCell():New(oPickList,"CDESCPROD"	,/*Tabela*/	,RetTitle("B1_DESC"	),PesqPict("SB1","B1_DESC"	),TamSx3("B1_DESC"	)[1],/*lPixel*/,{|| cDescProd 												})
TRCell():New(oPickList,"B1_UM"		,"SB1"		,RetTitle("B1_UM"	),PesqPict("SB1","B1_UM"	),TamSx3("B1_UM"	)[1],/*lPixel*/,{|| SB1->B1_UM												})
TRCell():New(oPickList,"NTOTQUANT"	,/*Tabela*/	,RetTitle("C6_QTDVEN"),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotQuant 												})
TRCell():New(oPickList,"CLOCAL"		,/*Tabela*/	,RetTitle("C6_LOCAL"),PesqPict("SC6","C6_LOCAL"	),TamSx3("C6_LOCAL"	)[1],/*lPixel*/,{|| cLocal													})
If !lPyme
	TRCell():New(oPickList,"B2_LOCALIZ"	,"SB2"		,RetTitle("B2_LOCALIZ"),PesqPict("SB2","B2_LOCALIZ"),TamSx3("B2_LOCALIZ")[1],/*lPixel*/,{|| SB2->B2_LOCALIZ	})
	TRCell():New(oPickList,"CLOTE"		,/*Tabela*/	,RetTitle("C6_LOTECTL"),PesqPict("SC6","C6_LOTECTL"),TamSx3("C6_LOTECTL")[1],/*lPixel*/,{|| cLote				})
	TRCell():New(oPickList,"CSUBLOTE"	,/*Tabela*/	,RetTitle("C6_NUMLOTE"),PesqPict("SC6","C6_NUMLOTE"),TamSx3("C6_NUMLOTE")[1],/*lPixel*/,{|| cSubLote			})
	TRCell():New(oPickList,"DDTVALID"	,/*Tabela*/	,RetTitle("C6_DTVALID"),PesqPict("SC6","C6_DTVALID"),TamSx3("C6_DTVALID")[1],/*lPixel*/,{|| dDtValid			})
	TRCell():New(oPickList,"CPOTENCI"	,"SC6"		,RetTitle("C6_POTENCI"),PesqPict("SC6","C6_POTENCI"),TamSx3("C6_POTENCI")[1],/*lPixel*/,{|| cPotenci			})
EndIf
TRCell():New(oPickList,"cNPedido",/*Tabela*/,RetTitle("C6_NUM"),PesqPict("SC6","C6_NUM"),TamSx3("C6_NUM")[1],/*lPixel*/,{|| cNPedido })

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Marco Bianchi         ³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSC6)

Local nTamRef  	 := Val(Substr(GetMv("MV_MASCGRD"),1,2))
Local lRet       := .F.
Local cProdRef	 := ""
Local lSkip		 := .F.    


#IFNDEF TOP
	Local cCondicao := ""
	Local cKey 		:= ""
	Local cIndexSC6 := ""
#ELSE	
	Local cWhere := ""
#ENDIF               

oReport:Section(1):Cell("CCODPROD" 	):SetBlock({|| cCodProd		})
oReport:Section(1):Cell("CDESCPROD"	):SetBlock({|| cDescProd	})
oReport:Section(1):Cell("CLOTE"		):SetBlock({|| cLote   		})
oReport:Section(1):Cell("CSUBLOTE"	):SetBlock({|| cSubLote		})
oReport:Section(1):Cell("NTOTQUANT"	):SetBlock({|| nTotQuant	})
oReport:Section(1):Cell("CLOCAL"	):SetBlock({|| cLocal		})
oReport:Section(1):Cell("DDTVALID"	):SetBlock({|| dDtValid		})
oReport:Section(1):Cell("cNPedido"	):SetBlock({|| cNPedido		})
oReport:Section(1):Cell("CPOTENCI"	):SetBlock({|| cPotenci		})

nTotQuant := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	If TcSrvType() <> "AS/400"
		oReport:Section(1):BeginQuery()
		BeginSql Alias cALiasSC6
		SELECT SC6.R_E_C_N_O_ SC6REC,
		SC6.C6_NUM,SC6.C6_FILIAL,SC6.C6_QTDVEN,SC6.C6_PRODUTO,
		SC6.C6_LOCAL,SC6.C6_GRADE,SC6.C6_LOTECTL,SC6.C6_POTENCI,
		SC6.C6_NUMLOTE,SC6.C6_DTVALID
		FROM %Table:SC6% SC6
		WHERE (SC6.C6_QTDVEN > 0) AND
			SC6.C6_NUM >= %Exp:mv_par01% AND
			SC6.C6_NUM <= %Exp:mv_par02% AND
			SC6.C6_FILIAL = %xFilial:SC6% AND
			SC6.%Notdel%
			ORDER BY SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_PRODUTO,SC6.C6_LOTECTL,
				SC6.C6_NUMLOTE,SC6.C6_DTVALID
		EndSql
		oReport:Section(1):EndQuery()		
				
	Else
#ENDIF	         
		dbSelectArea(cAliasSC6)
		cIndexSC6  := CriaTrab(nil,.f.)
		cKey :="C6_FILIAL+C6_NUM+C6_CLI+C6_LOJA+C6_PRODUTO+C6_LOTECTL+C6_NUMLOTE+DTOS(C6_DTVALID)"		
		cCondicao := "C6_FILIAL = '" + xFilial("SC6") + "' .And. "
		cCondicao += "(C6_QTDVEN > 0) .And. "
		cCondicao += "C6_NUM >= '"+mv_par01+"' .And. " 
		cCondicao += "C6_NUM <= '"+mv_par02+"'" 

		IndRegua(cAliasSC6,cIndexSC6,cKey,,cCondicao,"Selecionando Registros...")	   
		#IFNDEF TOP
			DbSetIndex(cIndexSC6+OrdBagExt())
		#ENDIF                           
		
#IFDEF TOP
	Endif
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oReport:Section(1),"SB2",1,{|| xFilial("SB1")+cCodProd+cLocal})


dbSelectArea(cAliasSC6)
dbGoTop()
oReport:SetMeter(RecCount())
oReport:Section(1):Init()
While !oReport:Cancel() .And. (cAliasSC6)->(!Eof()) .And. (cALiasSC6)->C6_FILIAL = xFilial("SC6")

	//	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//	³ Valida o produto conforme a mascara         ³     
	//	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet:=ValidMasc((cAliasSC6)->C6_PRODUTO,MV_PAR03)
	If !lRet .and. !lSkip   
		MsgAlert("Máscara do produto não encontrada, processo finalizado.")   
		dbCloseArea() 
	   	Return(.F.)
	EndIf
	
	If lRet

		cCodProd := (cAliasSC6)->C6_PRODUTO
		cLote	 := (cAliasSC6)->C6_LOTECTL
		cSubLote := (cAliasSC6)->C6_NUMLOTE              
		dDtValid := (cAliasSC6)->C6_DTVALID
		cNPedido := (cAliasSC6)->C6_NUM
		cLocal   := (cAliasSC6)->C6_LOCAL
		cPotenci := (cAliasSC6)->C6_POTENCI
		
		lSkip := .F.
		lAglutGrad := (!lPyme .And. (cAliasSC6)->C6_GRADE == "S" .and. MV_PAR04 == 1) 
		If lAglutGrad
			cProdRef 	:=Substr(cCodProd,1,nTamRef)
			SB4->(DbSeek(xFilial("SB4") + cProdRef))
			cDescProd:= SB4->B4_DESC
		Else
			SB1->(DbSeek(xFilial("SB1") + (cAliasSC6)->C6_PRODUTO))
			cDescProd:= SB1->B1_DESC
		Endif
		dbSelectArea(cAliasSC6)
		If MV_PAR04 == 1
			nTotQuant := 0
			While (cAliasSC6)->(!Eof()) .And.;
				If(lAglutGrad,(cProdRef == Substr((cAliasSC6)->C6_PRODUTO,1,nTamRef)),cCodProd == (cAliasSC6)->C6_PRODUTO) .And.;
				(cLote == (cAliasSC6)->C6_LOTECTL .And. cSubLote == (cAliasSC6)->C6_NUMLOTE) .And. ;
				(cAliasSC6)->C6_NUM == cNPedido
				
				nTotQuant += (cAliasSC6)->C6_QTDVEN
				(cAliasSC6)->(dbSkip())
				lSkip := .T.
			Enddo
		Else
			IF !lPyme .And. (cAliasSC6)->C6_GRADE == "S" .and. MV_PAR04 == 1
				cProdRef 	:=Substr(cCodProd,1,nTamRef)
				nTotQuant	:=0
				While (cAliasSC6)->(!Eof()) .And. cProdRef == Substr((cAliasSC6)->C6_PRODUTO,1,nTamRef) .And. (cAliasSC6)->C6_GRADE == "S" .And.;
					(cLote == (cAliasSC6)->C6_LOTECTL .And. cSubLote == (cAliasSC6)->C6_NUMLOTE) .And. ;
					(cAliasSC6)->C6_NUM == cNPedido 
					nTotQuant += (cAliasSC6)->C6_QTDVEN
					(cAliasSC6)->(dbSkip())
					lSkip := .T.
				End
			Endif
		Endif
		
		If !(lAglutGrad .Or. MV_PAR04 == 1)
			nTotQuant :=(cAliasSC6)->C6_QTDVEN
		EndIf
		
		oReport:Section(1):PrintLine()
		
	EndIf

	dbSelectArea(cAliasSC6)
	If !lSkip	
		dbSkip()
	EndIf	
	
End
oReport:Section(1):Finish()


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ HCIR016R3³ Autor ³ Claudinei M. Benzi    ³ Data ³ 23.05.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pick-List (Pedido de Venda)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ HCIR016(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Edson   M.   ³30/03/99³XXXXXX³Passar o tamanho na SetPrint.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Aline Catarin³30/01/07³XXXXXX³Alteracoes p/ impressao do Pick-List    |±±            
±±³ 			 |		  |		 |do Pedido de Vendas.					  |±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function HCIR016R3
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel		:= "HCIR016"
LOCAL tamanho	:= "M"
LOCAL titulo	:= OemToAnsi("Pick-List (Pedido de Venda)")	
LOCAL cDesc1	:= OemToAnsi("Emiss„o de produtos a serem separados pela expedicao, para")	
LOCAL cDesc2	:= OemToAnsi("determinada faixa de pedidos de venda.")
LOCAL cDesc3	:= ""
LOCAL cString	:= "SC6"
LOCAL cPerg  	:= "HCR016"

PRIVATE aReturn		:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
PRIVATE nomeprog	:= "HCIR016"
PRIVATE nLastKey 	:= 0
PRIVATE nBegin		:= 0
PRIVATE aLinha		:= {}
PRIVATE li			:= 80
PRIVATE limite		:= 132
PRIVATE lRodape		:= .F.
PRIVATE m_pag       :=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1(cPerg)
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                      ³
//³ mv_par01	     	  Do Pedido                           ³
//³ mv_par02	     	  Ate o Pedido                        ³
//³ mv_par03	     	  Mascara                             ³
//³ mv_par04	     	  Aglutina itens grade                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C775Imp(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,;
			@cDesc2,@cDesc3)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C775IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR775			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C775Imp(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,;
						cDesc3)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL cabec1 	 := OemToAnsi("Codigo          Desc. do Material              UM Quantidade  Amz Endereco       Lote      SubLote  Validade   Potencia    Pedido") 
LOCAL cabec2	 := ""
LOCAL lContinua  := .T.
LOCAL lFirst 	 := .T.
LOCAL cPedAnt	 := ""
LOCAL nI		 := 0
LOCAL aTam    	 := {}
LOCAL cMascara 	 := GetMv("MV_MASCGRD")
LOCAL nTamRef  	 := Val(Substr(cMascara,1,2))
LOCAL cbtxt      := SPACE(10)
LOCAL cbcont	 := 0
LOCAL nTotQuant	 := 0
LOCAL aStruSC6   := {}
LOCAL nSC6       := 0
LOCAL cFilter    := ""
LOCAL cAliasSC6  := "SC6"
LOCAL cIndexSC6  := "" 
LOCAL cKey 	     := ""
LOCAL lQuery     := .F.
LOCAL lRet       := .F.
LOCAL cProdRef	 := ""
LOCAL lSkip		 := .F.    
LOCAL cCodProd 	 := ""
LOCAL nQtdIt   	 := 0
LOCAL cDescProd	 := ""
LOCAL cGrade   	 := ""
LOCAL cUnidade 	 := ""
LOCAL cLocaliza	 := ""
LOCAL cLote	 	 := ""
LOCAL cLocal 	 := ""                
LOCAL cSubLote   := ""
LOCAL dDtValid   := dDatabase
LOCAL nPotencia  := 0
Local lPyme      := Iif(Type("__lPyme") <> "U",__lPyme,.F.)
Local nX         := 0
Local cName      := ""
Local cQryAd     := ""
Local cNPedido	 := ""
Local lAglutGrad := .F.

If lPyme
	cabec1 	 := OemToAnsi("Codigo          Desc. do Material              UM Quantidade  Amz Pedido") 
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("PICK-LIST")	// 
// "Codigo          Desc. do Material              UM Quantidade  Amz Endereco       Lote      SubLote  Dat.de Validade Potencia"
//            1         2         3         4         5         6         7         8         9        10        11        12        13      
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
#IFDEF TOP
	If TcSrvType() <> "AS/400"
	    cAliasSC6:= "C775Imp"
	    aStruSC6  := SC6->(dbStruct())		
		lQuery    := .T.
		cQuery := "SELECT SC6.R_E_C_N_O_ SC6REC,"
		cQuery += "SC6.C6_NUM,SC6.C6_FILIAL,SC6.C6_QTDVEN,SC6.C6_PRODUTO, "
		cQuery += "SC6.C6_LOCAL,SC6.C6_GRADE,SC6.C6_LOTECTL,SC6.C6_POTENCI,"
		cQuery += "SC6.C6_NUMLOTE,SC6.C6_DTVALID"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esta rotina foi escrita para adicionar no select os campos do SC6 usados no filtro do usuario ³
		//³quando houver, a rotina acrecenta somente os campos que forem adicionados ao filtro testando  ³
	    //³se os mesmo ja existem no selec ou se forem definidos novamente pelo o usuario no filtro.     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aReturn[7])
			For nX := 1 To SC6->(FCount())
		 		cName := SC6->(FieldName(nX))
				If AllTrim( cName ) $ aReturn[7]
					If aStruSC6[nX,2] <> "M"
						If !cName $ cQuery .And. !cName $ cQryAd
							cQryAd += ",SC6."+ cName
						EndIf
					EndIf
				EndIf
			Next nX
		EndIf
		cQuery += cQryAd
		
		cQuery += " FROM "
		cQuery += RetSqlName("SC6") + " SC6 "
		cQuery += "WHERE "                   
		cQuery += "( SC6.C6_QTDVEN > 0) AND "
		cQuery += "SC6.C6_NUM >= '"+mv_par01+"' AND " 
		cQuery += "SC6.C6_NUM <= '"+mv_par02+"' AND " 
		cQuery += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
		cQuery += "SC6.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_PRODUTO,SC6.C6_LOTECTL,"
		cQuery += "SC6.C6_NUMLOTE,SC6.C6_DTVALID"
				
		cQuery := ChangeQuery(cQuery)
    	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)

		For nSC6 := 1 To Len(aStruSC6)
			If aStruSC6[nSC6][2] <> "C" .and.  FieldPos(aStruSC6[nSC6][1]) > 0
				TcSetField(cAliasSC6,aStruSC6[nSC6][1],aStruSC6[nSC6][2],aStruSC6[nSC6][3],aStruSC6[nSC6][4])
			EndIf
		Next nSC6
	Else
#ENDIF	         
		dbSelectArea(cString)
		cIndexSC6  := CriaTrab(nil,.f.)
		cKey :="C6_FILIAL+C6_NUM+C6_CLI+C6_LOJA+C6_PRODUTO+C6_LOTECTL+C6_NUMLOTE+DTOS(C6_DTVALID)"		
		cFilter := "C6_FILIAL = '" + xFilial("SC6") + "' .And. "
		cFilter += "(C6_QTDVEN > 0) .And. "
		cFilter += "C6_NUM >= '"+mv_par01+"' .And. " 
		cFilter += "C6_NUM <= '"+mv_par02+"'" 

		IndRegua(cAliasSC6,cIndexSC6,cKey,,cFilter,"Selecionando Registros...")	   
		#IFNDEF TOP
			DbSetIndex(cIndexSC6+OrdBagExt())
		#ENDIF                           
		SetRegua(RecCount())		// Total de Elementos da regua
		DbGoTop()
		
#IFDEF TOP
	Endif
#ENDIF	

While (cAliasSC6)->(!Eof())
	//	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//	³ Valida o produto conforme a mascara         ³
	//	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet:=ValidMasc((cAliasSC6)->C6_PRODUTO,MV_PAR03)
	If lRet .and. !Empty(aReturn[7])    
		lRet := &(aReturn[7])
	Endif
	If !lRet .and. !lSkip   
		MsgAlert("Máscara do produto não encontrada, processo finalizado.")   
		dbCloseArea() 
	   	Return(.F.)
	EndIf	
	If lRet
		IF lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif 
		If !lQuery
			IncRegua()
		EndIf	
		IF li > 55 .or. lFirst
			lFirst  := .f.
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			lRodape := .T.
		Endif
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1") + (cAliasSC6)->C6_PRODUTO)
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2") + (cAliasSC6)->C6_PRODUTO + (cAliasSC6)->C6_LOCAL )
		cCodProd := (cAliasSC6)->C6_PRODUTO
		nQtdIt   := (cAliasSC6)->C6_QTDVEN
		cDescProd:= Subs(SB1->B1_DESC,1,30)
		cGrade   := (cAliasSC6)->C6_GRADE
		cUnidade := SB1->B1_UM		             
		cLocaliza:= SB2->B2_LOCALIZ                      
		cLote	 := (cAliasSC6)->C6_LOTECTL
		cLocal 	 := (cAliasSC6)->C6_LOCAL                
		cSubLote := (cAliasSC6)->C6_NUMLOTE              
		dDtValid := (cAliasSC6)->C6_DTVALID
		nPotencia:= (cAliasSC6)->C6_POTENCI
		cNPedido := (cAliasSC6)->C6_NUM
		lSkip := .F.
		lAglutGrad := (!lPyme .And. cGrade == "S" .and. MV_PAR04 == 1) 
		If lAglutGrad
			cProdRef 	:=Substr(cCodProd,1,nTamRef)
			SB4->(DbSeek(xFilial("SB4") + cProdRef))
			cDescProd:= Subs(SB4->B4_DESC,1,30)
		Endif
		If MV_PAR04 == 1
			nTotQuant := 0
			While (cAliasSC6)->(!Eof()) .And.;
				If(lAglutGrad,(cProdRef == Substr((cAliasSC6)->C6_PRODUTO,1,nTamRef)),cCodProd == (cAliasSC6)->C6_PRODUTO) .And.;
				(cLote == (cAliasSC6)->C6_LOTECTL .And. cSubLote == (cAliasSC6)->C6_NUMLOTE) .And. ;
				(cAliasSC6)->C6_NUM == cNPedido 
				
				nTotQuant += (cAliasSC6)->C6_QTDVEN
				(cAliasSC6)->(dbSkip())
				lSkip := .T.
			Enddo
		Else
			IF !lPyme .And. cGrade == "S" .and. MV_PAR04 == 1
				cProdRef 	:=Substr(cCodProd,1,nTamRef)
				nTotQuant	:=0
				While (cAliasSC6)->(!Eof()) .And. cProdRef == Substr((cAliasSC6)->C6_PRODUTO,1,nTamRef) .And. (cAliasSC6)->C6_GRADE == "S" .And.;
					(cLote == (cAliasSC6)->C6_LOTECTL .And. cSubLote == (cAliasSC6)->C6_NUMLOTE) .And. ;
					(cAliasSC6)->C6_NUM == cNPedido 
					nTotQuant += (cAliasSC6)->C6_QTDVEN
					(cAliasSC6)->(dbSkip())
					lSkip := .T.
				End
			Endif
		Endif
		@ li, 00 Psay IIF(lAglutGrad ,Substr(cCodProd,1,ntamref),cCodProd)  Picture "@!"
		@ li, 16 Psay cDescProd	Picture "@!"
		@ li, 47 Psay cUnidade Picture "@!"
		@ li, 50 Psay IIF(lAglutGrad .Or. MV_PAR04 == 1,nTotQuant,nQtdIt) Picture "@E 999,999.99"
		@ li, 62 Psay cLocal
		If !lPyme
			@ li, 66 Psay cLocaliza
			@ li, 81 Psay cLote	Picture "@!"
			@ li, 91 Psay cSubLote	Picture "@!"
			@ li,101 Psay dDtValid	Picture PesqPict("SC6","C6_DTVALID")
			@ li,113 PSay nPotencia Picture PesqPict("SC6","C6_POTENCI")
			@ li,123 Psay cNPedido Picture "@!"
		Else
			@ li,66 Psay cNPedido Picture "@!"
		EndIf	
		
		li++
	EndIf

	dbSelectArea(cAliasSC6)
	If !lSkip	
		dbSkip()
	EndIf	
	
End

IF lRodape
	roda(cbcont,cbtxt,"M")
Endif

If lQuery   
    dbSelectArea(cAliasSC6)
	dbCloseArea()  
	dbSelectArea("SC6")
Else
	RetIndex("SC6")   
	Ferase(cIndexSC6+OrdBagExt())
	dbSelectArea("SC6")
	dbClearFilter()
	dbSetOrder(1)
	dbGotop()
Endif	

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Aline Catarina      º Data ³30/01/07     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HCIR016                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)        
DbSelectArea("SX1")                                  
SX1->(DbSetOrder(1)) // x1_grupo 
If !SX1->(DbSeek(cPerg))                                                      
	PutSx1(cPerg, "01", "Do pedido            ?", "", "", "mv_ch1", "C",06,0,0,"G","","SC5","",  "", "mv_par01",    "", "", "",          "      ",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","SC5", "", "", "", "", "", "", "", "")
	PutSx1(cPerg, "02", "Até pedido           ?", "", "", "mv_ch2", "C",06,0,0,"G","","SC5","",  "", "mv_par02",    "", "", "",          "ZZZZZZ",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","SC5", "", "", "", "", "", "", "", "")
	PutSx1(cPerg, "03", "Máscara do Produto   ?", "", "", "mv_ch3", "C",15,0,0,"G","",   "","", "S", "mv_par03",    "", "", "", "***************",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",   "", "", "", "", "", "", "", "", "")
	PutSX1(cPerg, "04", "Aglutinar prod.Grade ?", "", "", "mv_ch4", "N",01,0,2,"C","",   "","", "S", "mv_par04", "Sim", "", "",                "", "Não", "", "")
EndIf
Return
