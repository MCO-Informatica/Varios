#INCLUDE "TMKR034.CH"
#INCLUDE "PROTHEUS.CH"
//#INCLUDE "TMKDEF.CH"
#INCLUDE "REPORT.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Tmkr034  ³ Autor ³ Rafael M. Quadrotti   ³ Data ³ 22.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Relatorio de atendimento telemarketing                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMKR034(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ANALISTA     ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Hanna Caroline³03/08/06³R4    ³Relatorio Personalizavel                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Tmkb034()

Local oReport						//Objeto do relatorio
Local aArea := GetArea()			//Area atual para restauracao posterior 

TMKR034R3()

/*If !FindFunction("TRepInUse") .OR. !TRepInUse()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa versao anterior do fonte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ Mv_Par01           // Entidade                               ³
	//³ Mv_Par02           // Tipo Atendimento ATIVO RECEPTIVO AMBOS ³
	//³ Mv_Par03           // Status Plan. Pend. Encerr. Todas       ³
	//³ Mv_Par04           // Da Data                                ³
	//³ Mv_Par05           // Ate a Data                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("TMK034",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := Tkr034RptDef()
	oReport:PrintDialog()
EndIf
  */
RestArea( aArea )
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Tmkr034  ³ Autor ³ Rafael M. Quadrotti   ³ Data ³ 22.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Relatorio de atendimento telemarketing                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMKR034(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ANALISTA     ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Armando Tessar³07/10/02³ 609  ³Reescrita total do fonte                ³±±
±±³Andrea Farias ³01/07/04³ 710  ³Revisao do fonte e alteracao de layout  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Tmkr034R3()

Local oPrint				//Objeto do relatorio

If !Pergunte("TMK034",.T.)
	Return(.F.)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ Mv_Par01           // Entidade                               ³
//³ Mv_Par02           // Tipo Atendimento ATIVO RECEPTIVO AMBOS ³
//³ Mv_Par03           // Status Plan. Pend. Encerr. Todas       ³
//³ Mv_Par04           // Da Data                                ³
//³ Mv_Par05           // Ate a Data                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrint := TMSPrinter():New( STR0015 )		// "Atendimento Telemarketing"
oPrint:SetPortrait()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se as configuracoes de impressora foram definidas para ³
//³que o objeto possa ser trabalhado.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(oPrint:IsPrinterActive())
     Aviso(STR0039,STR0038,{"OK"})  //"Impressora" "As configurações da impressora não foram encontradas. Por favor, verifique as configurações para utilizar este relatório. "
     oPrint:Setup()
     Return (.F.)
EndIf


Processa( { |lEnd| ImpTmkr034(@lEnd, oPrint) }, STR0015, STR0018)		// "Atendimento Telemarketing", "Pesquisando dados..."

oPrint:Preview()  	// Visualiza antes de imprimir

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ImpTmkr034³ Autor ³ Armando M. Tessaroli  ³ Data ³ 22/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Relatorio de atendimento televendas (Beta)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMKR034(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ANALISTA     ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Armando Tessar³07/10/02³ 609  ³Reescrita total do fonte                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpTmkr034(lEnd, oPrint)

Local nPag		:= 1		// Controle do numero de pagina
Local nLinha	:= 150		// Controle de linha de impressao
Local nCont		:= 0		// Controle
Local oFontC10				// Fonte
Local oFontC08				// Fonte
Local oFontC20				// Fonte titulo do relatorio
Local oFontN08				// Fonte
Local lCompart	:= SUC->(FieldPos("UC_CHAORIG")) > 0
Local cFileLogo := ""		// Bitmap (Logo) para relatorio

#IFDEF TOP
	Local aSetField		:= {}		// Parametros para SetField do alias principal
	Local cCampos		:= ""		// Campos do alias principal para select
	Local cQuery		:= ""		// Armazena a expressao da query para top
	Local nI			:= 0		// Contador
#ENDIF

cFileLogo  := "LGRL"+SM0->M0_CODIGO+FWGETCODFILIAL+".BMP"

If !File( cFileLogo )
	cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao dos fontes utilizados no relatorio.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFontC10 := TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFontC08 := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFontC20 := TFont():New("Courier New",20,20,,.T.,,,,.T.,.F.)
oFontN08 := TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oPrint:SetLandscape() 	//  SetPortrait

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do pergunte³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Tk34ImpSX1(oPrint,"TMK034",@nLinha,oFontC10,oFontC08,oFontN08)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime os atendimentos para a entidade atual.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SUC")
DbSetOrder(3)
ProcRegua(RecCount())

#IFDEF TOP
	
	TkSelect("SUC", @cCampos, @aSetField)
	
	cQuery :=	" SELECT	" + cCampos +;
				" FROM " + RetSqlName("SUC") + " SUC" +;
				" WHERE	SUC.UC_FILIAL = '" + xFilial("SUC") + "' AND" +;
				" 		SUC.UC_DATA BETWEEN '" + DtoS(Mv_Par04) + "' AND '" + DtoS(Mv_Par05) + "' AND" +;
				" 		SUC.UC_CODCANC = '' AND"
	
	If !Empty(Mv_Par01)
		cQuery += "		SUC.UC_ENTIDAD = '" + Mv_Par01 + "' AND"
	Endif
	
	If Mv_Par02 <> 3	// Ambos
		cQuery += "		(SUC.UC_OPERACA = '" + Str(Mv_Par02,1) + "' OR"		// Ativo ou Receptivo
		cQuery += "		SUC.UC_OPERACA = '') AND"
	Endif
	
	If Mv_Par03 <> 4	// Todas
		cQuery += "		SUC.UC_STATUS = '" + Str(Mv_Par03,1) + "' AND"		// Plan. Pend. Encerr.
	Endif

	If !Empty(Mv_Par06)
		cQuery += "		SUC.UC_OPERADO = '" + MV_PAR06 + "' AND"		// Operador
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente chamados que nao sao compartilhamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCompart
		cQuery += " 	SUC.UC_CHAORIG = '' AND"
	EndIf
	
	cQuery +=	" 		SUC.D_E_L_E_T_ = ' ' " +;
				" ORDER BY " + SqlOrder(IndexKey())
	
	cQuery := ChangeQuery(cQuery)
	// MemoWrite("TMKR034.SQL", cQuery)
	DbSelectArea("SUC")
	DbCloseArea()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SUC', .F., .T.)
	
	For nI := 1 To Len(aSetField)
		TCSetField("SUC", aSetField[nI][1], aSetField[nI][2], aSetField[nI][3], aSetField[nI][4])
	Next nI
	
#ELSE
	DbSeek (xFilial("SUC")+DtoS(Mv_Par04), .T.)
#ENDIF

	
While	(!Eof()) 							.AND.;
		SUC->UC_FILIAL == xFilial("SUC") 	.AND.;
		SUC->UC_DATA >= Mv_Par04 			.AND.;
		SUC->UC_DATA <= Mv_Par05
	
	nCont++
	IncProc(STR0018 + STR(nCont,7))
	
	If lEnd
		Exit
	Endif
	
	#IFNDEF TOP
		If !Empty(SUC->UC_CODCANC)
			DbSkip()
			Loop
		Endif
		
		If !Empty(Mv_Par01) .AND. SUC->UC_ENTIDAD <> AllTrim(Mv_Par01)
			DbSkip()
			Loop
		Endif
		
		If Mv_Par02 <> 3 .AND. (SUC->UC_OPERACA <> Str(Mv_Par02,1) .OR. Empty(SUC->UC_OPERACA)) //1 = Receptivo 2 = Ativo
			DbSkip()
			Loop
		Endif
		
		
		If Mv_Par03 <> 4 .AND. SUC->UC_STATUS <> Str(Mv_Par03,1)	// 1=Planejada 2=Pendente 3=Encerrada 4=Todas 
			DbSkip()
			Loop
		Endif
		
		// Filtro Operador

		If !Empty(MV_PAR06)
			If MV_PAR06 <> SUC->UC_OPERADO
				DbSkip()
				Loop
			Endif
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao seleciono chamados que sao compartilhamentos         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCompart .AND. !Empty(SUC->UC_CHAORIG)
			DbSkip()
			Loop
		EndIf
		
	#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime o cabeçalho do atendimento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Tk034Cab(oPrint,@nPag,@nLinha,oFontC10,oFontC08,oFontN08,oFontC20,cFileLogo)  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime os itens de cada atendimento da entidade.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Tk034Itens(oPrint,@nLinha,nPag,oFontC10,oFontC08,oFontN08)
	
	DbSelectArea("SUC")
	DbSkip()
	
End



#IFDEF TOP
	DbSelectArea("SUC")
	DbCloseArea()
	ChkFile("SUC")
#ENDIF

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Tk034Cab ³ Autor ³ Rafael M. Quadrotti   ³ Data ³ 23.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Relatorio de atendimentos telemarketing (teste MsPrint)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tk034Cab(oPrint,nPag,nLinha,oFontC10,oFontC08,oFontN08)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±³          ³ ExpN2 = Contador de paginas                                ³±±
±±³          ³ ExpN3 = Contador de Linhas                                 ³±±
±±³          ³ ExpO4 = Fontes para impressao.                             ³±±
±±³          ³ ExpO5 = Fontes para impressao.                             ³±±
±±³          ³ ExpO6 = Fontes para impressao.                             ³±±
±±³          ³ ExpO7 = Fontes para impressao.                             ³±±
±±³          ³ ExpC8 = Logo do relatorio                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Call Center                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tk034Cab(oPrint	,nPag		,nLinha		,oFontC10,;
						oFontC08,oFontN08	,oFontC20	,cFileLogo)

Local aLinhas	:= {}							//Vetor do campo memo
Local nCont		:= 0							//Contador auxiliar
Local nLinAux	:= 0							//Variavel auxiliar para armazenar a linha atual
Local cTexto	:= ""							//Texto que identifica o tipo de atendimento
Local nLenAux	:= 0							//Quantidade de linhas do memo

nLinha+=50
oPrint:EndPage()			// Finaliza a pagina
oPrint:StartPage()			// Inicializo nova pagina
nLinha := 150
nPag++

//imprimir o cabecalho.
If nLinha > 2200 .OR. nPag == 1	// Limite para que exista espaco para impressao de todo o cabecalho 2185
	oPrint:EndPage()			// Finaliza a pagina
	oPrint:StartPage()			// Inicializo nova pagina
	nLinha := 150
	nPag++
Endif 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Cabecalho       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:SayBitmap(nLinha,0050, cFileLogo,474,117)
oPrint:Say(nLinha,1200	,STR0046,oFontC20 ) //"Atendimentos TMK"
oPrint:Say(nLinha,2500	,STR0047 + DTOC(dDataBase),oFontN08 ) //"Emissão : "
oPrint:Say(nLinha+50,2500,STR0048 + Time(),oFontN08 )//"Hora    : "
nLinha+=200

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Box Cabecalho.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Box( nLinha, 0030, nLinha+450, 3100 )

nLinha+=50
oPrint:Say(nLinha,0050,STR0019,oFontN08) 			//"Atendimento"
oPrint:Say(nLinha,0290,": "+SUC->UC_CODIGO,oFontC10)
oPrint:Say(nLinha,1600,STR0025,oFontN08) 			//"Contato"
oPrint:Say(nLinha,1800,":  "+SUC->UC_CODCONT,oFontC10)
oPrint:Say(nLinha,2000,Posicione("SU5",1,xFilial("SU5")+SUC->UC_CODCONT,"U5_CONTAT"),oFontC10)
nLinha+=50

oPrint:Say(nLinha,0050,STR0020,oFontN08) 			//"Data"
oPrint:Say(nLinha,0290,": "+DtoC(SUC->UC_DATA) + " - " + DiaExtenso(SUC->UC_DATA),oFontC10)
oPrint:Say(nLinha,1600,STR0040,oFontN08) 			//"Fone Comercial 1"
oPrint:Say(nLinha,1800,":  "+Transform(Posicione("SU5",1,xFilial("SU5")+SUC->UC_CODCONT,"U5_FCOM1"),"@R 9999-9999"),oFontC10)
nLinha+=50

oPrint:Say(nLinha,0050,STR0021,oFontN08) 			//"Ligacao"
If VAL(SUC->UC_OPERACA) == 1
	cTexto := 'Receptivo'
Else
	cTexto := 'Ativo'
Endif	
oPrint:Say(nLinha,0290,": "+cTexto,oFontC10)		

oPrint:Say(nLinha,1600,"Entidade",oFontN08 )			// 
oPrint:Say(nLinha,1800,":  "+SubStr(Posicione("SX2",1,SUC->UC_ENTIDAD,"X2NOME()"),1,32),oFontC10 )
nLinha+=50
//1=Planejada;2=Pendente;3=Encerrada                                                                                              
oPrint:Say(nLinha,0050,STR0022,oFontN08) 			// "Status"
Do Case
	Case VAL(SUC->UC_STATUS) == 1
		cTexto := 'Planejada'

	Case VAL(SUC->UC_STATUS) == 2
		cTexto := 'Pendente'

	Case VAL(SUC->UC_STATUS) == 3
		cTexto := 'Encerrada'
EndCase
oPrint:Say(nLinha,0290,": "+cTexto,oFontC10)		// Planejada, Pendente, Encerrada

oPrint:Say(nLinha,1600,STR0041,oFontN08 )			// "Descricao da Entidade"
oPrint:Say(nLinha,1800,":  "+SubStr(TkEntidade(SUC->UC_ENTIDAD,SUC->UC_CHAVE,1),1,35),oFontC10 )
nLinha+=50

oPrint:Say(nLinha,0050,STR0026,oFontN08) 			//"Operador"
oPrint:Say(nLinha,0290,": "+SUC->UC_OPERADO,oFontC10)
oPrint:Say(nLinha,0500,Posicione("SU7",1,xFilial("SU7")+SUC->UC_OPERADO,"U7_NOME"),oFontC10)

oPrint:Say(nLinha,1600,STR0023,oFontN08) 			//"Retorno"
oPrint:Say(nLinha,1800,":  "+DtoC(SUC->UC_PENDENT) + " - " + IIf(!Empty(SUC->UC_PENDENT),DiaExtenso(SUC->UC_PENDENT),""),oFontC10)

oPrint:Say(nLinha,2300,STR0024,oFontN08) 			//"Hora"
oPrint:Say(nLinha,2450,SUC->UC_HRPEND,oFontC10)
nLinha+=50

oPrint:Say(nLinha,0050,STR0027,oFontN08) 			//"Midia"
oPrint:Say(nLinha,0290,": "+SUC->UC_MIDIA,oFontC10)
oPrint:Say(nLinha,0500,Posicione("SUH",1,xFilial("SUH")+SUC->UC_MIDIA,"UH_DESC"),oFontC10)

oPrint:Say(nLinha,1600,STR0009,oFontN08 )			// "Endereco"
oPrint:Say(nLinha,1800,":  "+SubStr(TkEntidade(SUC->UC_ENTIDAD,SUC->UC_CHAVE,2),1,40),oFontC10 )
nLinha+=50

oPrint:Say(nLinha,0050,STR0028,oFontN08) 			//"Comunicacao"
oPrint:Say(nLinha,0290,": "+SUC->UC_TIPO,oFontC10)
oPrint:Say(nLinha,0500,Posicione("SUL",1,xFilial("SUL")+SUC->UC_TIPO,"UL_DESC"),oFontC10)

oPrint:Say(nLinha,1600,STR0042,oFontN08) 			//"Bairro"
oPrint:Say(nLinha,1800,":  "+SubStr(TkEntidade(SUC->UC_ENTIDAD,SUC->UC_CHAVE,10),1,40),oFontC10)
nLinha+=50

oPrint:Say(nLinha,0050,STR0029,oFontN08) 			//"Campanha"
oPrint:Say(nLinha,0290,": "+SUC->UC_CODCAMP,oFontC10)
oPrint:Say(nLinha,0500,Posicione("SUO",1,xFilial("SUO")+SUC->UC_CODCAMP,"UO_DESC"),oFontC10)

oPrint:Say(nLinha,1600,STR0011,oFontN08)			// "Município"
oPrint:Say(nLinha,1800,":  "+SubStr(TkEntidade(SUC->UC_ENTIDAD,SUC->UC_CHAVE,3),1,32),oFontC10 )

oPrint:Say(nLinha,2300,STR0012,oFontN08)			// "Estado"
oPrint:Say(nLinha,2450,TkEntidade(SUC->UC_ENTIDAD,SUC->UC_CHAVE,4),oFontC10 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao da Observacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLinha+=50
nLinAux:=nLinha
aLinhas := TkMemo(SUC->UC_CODOBS, 180)

nLenAux := Len(aLinhas)
For nCont := 1 TO nLenAux
	If nCont == 1
		oPrint:Say( nLinha, 0050,STR0043 ,oFontN08)//"Observação"
		nLinha += 50
		oPrint:Say( nLinha, 0050, aLinhas[nCont],oFontC08 )
		nLinha += 50
	Else
		oPrint:Say( nLinha, 0050, aLinhas[nCont],oFontC08 )
		nLinha += 50
	Endif 
			
Next nCont

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tk034ItensºAutor  ³Rafael M. Quadrotti º Data ³  06/25/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Itens do relatorio de atendimento televendas               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpO1 = Objeto de Impressao                                º±±
±±º          ³ ExpN1 = Contador de Linhas                                 º±±
±±º          ³ ExpN2 = Contador de paginas                                º±±
±±º          ³ ExpA1 = Array contendo a estrutura do dicionario SUC       º±±
±±º          ³ ExpA2 = Array contendo a estrutura do dicionario SUD       º±±
±±º          ³ ExpN3 = Flag de verificacao para impressao de box          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6-Call Center                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tk034Itens(oPrint,nLinha,nPag,oFontC10,oFontC08,oFontN08)

Local aArea		:= {}     	//Array com dados da area atual

If nLinha > 2200 
	oPrint:EndPage()			// Finaliza a pagina
	oPrint:StartPage()			// Inicializo nova pagina
	nLinha := 150
	nPag++
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime os itens do atendimento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aArea:= GetArea()
DbSelectArea("SUD")
DbSetOrder(1)
If DbSeek(xFilial("SUD") + SUC->UC_CODIGO)
		
	While	(!EOF()) .AND. (SUD->UD_CODIGO = SUC->UC_CODIGO)
		nLinha+=50
		If nLinha > 2350 .OR. nPag == 1	// Limite para que exista espaco para impressao de todo o cabecalho 2185
			oPrint:Line( nLinha, 0130, nLinha, 3100 )	// Horizontal para fechar o quadro
			oPrint:EndPage()			// Finaliza a pagina
			oPrint:StartPage()			// Inicializo nova pagina
			nLinha := 150
			nPag++
		Endif
        
		//Primeira Linha
		nLinha+=50
		oPrint:Line( nLinha	, 0130, nLinha	, 3100 )	// Horizontal cima 
		oPrint:Line( nLinha	, 0130, nLinha+50, 0130 )	// Vertical 01
		oPrint:Say(nLinha+10,0140,STR0031	,oFontN08) 	//"Assunto"
		oPrint:Say(nLinha+10,0400,STR0044,oFontN08) 	//"Produto"
		oPrint:Say(nLinha+10,1110,STR0032	,oFontN08) 	//"Ocorrencia"
		oPrint:Say(nLinha+10,1910,STR0033	,oFontN08) 	//"Acao"
		oPrint:Line( nLinha	, 3100,nLinha+50, 3100 )	// Vertical 01
		nLinha+=50
		oPrint:Line( nLinha, 0130, nLinha, 3100 )	// Horizontal acima dos itens

		oPrint:Line( nLinha, 0130, nLinha+50, 0130 )		// Vertical 01
		oPrint:Say(nLinha+10,0140,SubStr(Posicione("SX5",1,xFilial("SX5")+"T1"+SUD->UD_ASSUNTO,"X5DESCRI()"),1,12),oFontC08)
		
		oPrint:Line( nLinha, 0390, nLinha+50, 0390 )		// Vertical meio
		oPrint:Say(nLinha+10,0400, Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_DESC"),oFontC08)
		
		oPrint:Line( nLinha, 1100, nLinha+50, 1100 )		// Vertical meio
		oPrint:Say(nLinha+10,1110,Posicione("SU9",2,xFilial("SU9")+SUD->UD_OCORREN,"U9_DESC"),oFontC08)

		oPrint:Line( nLinha, 1900, nLinha+50, 1900 )		// Vertical meio
		oPrint:Say(nLinha+10,1910,Posicione("SUQ",1,xFilial("SUQ")+SUD->UD_SOLUCAO,"UQ_DESC"),oFontC08)
		
		oPrint:Line( nLinha, 3100, nLinha+50, 3100 )		// Vertical 01

        //Segunda Linha		
		nLinha+=50
		oPrint:Line( nLinha, 0130, nLinha, 3100 )		// Horizontal acima do Responsavel
		oPrint:Line( nLinha	,0130, nLinha+50, 0130 )	//Vertical 01
		oPrint:Say(nLinha+10,0140,STR0034,oFontN08) 	//"Responsavel"
		oPrint:Say(nLinha+10,1110,STR0035,oFontN08) 	//"Data Acao"
		oPrint:Say(nLinha+10,1610,STR0022,oFontN08) 	//"Status"
		oPrint:Say(nLinha+10,2110,STR0045,oFontN08) 	//"Execucao"
		oPrint:Line( nLinha	, 3100,nLinha+50, 3100 )	// Vertical 01
		nLinha+=50
		oPrint:Line( nLinha, 0130, nLinha, 3100 )		// Horizontal 
		oPrint:Line( nLinha	,0130,nLinha+50, 0130 )	// Vertical 01

		PswOrder(1)
		If PswSeek(SUD->UD_OPERADO)
			aTeste := PswRet()
			oPrint:Say(nLinha+10,0140,PswRet()[1][4],oFontC08)
		Endif
		
		oPrint:Line( nLinha, 1100, nLinha+50, 1100 )		// Vertical 01
		oPrint:Say(nLinha+10,1110,DtoC(SUD->UD_DATA),oFontC08)
		
		oPrint:Line( nLinha, 1600, nLinha+50, 1600 )		// Vertical meio
		oPrint:Say(nLinha+10,1610,IIF(SUD->UD_STATUS=="1" .AND. !Empty(SUD->UD_STATUS),STR0002,STR0036),oFontC08) //"PENDENTE"###"ENCERRADO"

		oPrint:Line( nLinha, 2100, nLinha+50, 2100 )		// Vertical meio
		oPrint:Say(nLinha+10,2110,DtoC(SUD->UD_DTEXEC),oFontC08)

		oPrint:Line( nLinha, 3100, nLinha+50, 3100 )		// Vertical 01
		nLinha+=50
		oPrint:Line( nLinha, 0130, nLinha, 3100 )			// Horizontal 
	    
	    //Terceira Linha
		If !Empty(SUD->UD_OBS)
//			nLinha+=50
//			oPrint:Line( nLinha, 0130, nLinha, 3100 )			// Horizontal  
			oPrint:Line( nLinha, 0130, nLinha+50, 0130 )		// Vertical 01
			oPrint:Say(nLinha+10,0140,STR0037 + SubStr(Posicione("SX5",1,xFilial("SX5")+"T1"+SUD->UD_ASSUNTO,"X5DESCRI()"),1,12),oFontN08) //"OBSERVAÇÕES DE "
			oPrint:Line( nLinha, 0700, nLinha+50, 0700 )		// Vertical meio
			oPrint:Say(nLinha+10,0710,SUD->UD_OBS,oFontC08)
			oPrint:Line( nLinha, 3100, nLinha+50, 3100 )		// Vertical 02
			nLinha+=50
			oPrint:Line( nLinha, 0130, nLinha, 3100 )	// Horizontal
		Endif
		DbSkip()
	End
Endif
RestArea(aArea)



Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Tk34IMPSX1³ Autor ³ Rafael M. Quadrotti   ³ Data ³ 08.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprime folha de Parametros. (Especifico p/ Rel. Graficos)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Tk34IMPSX1()		  		                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 			                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ap6 Call Center                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tk34ImpSX1(oPrint,cPerg,nLinha,oFontC10,oFontC08,oFontN08)

Local nLi 		:= 245				//Linha inicial
Local cConteudo := ""				//Conteudo da pergunta

DbSelectArea("SX1")
DbSetOrder(1)
DbSeek(PadR(cPerg,Len(X1_GRUPO))+'01')

oPrint:Line( nLi,30,nLi,3000 )   	// HORIZONTAL

nLi := 300

While (!Eof()) .AND. SX1->X1_GRUPO == PadR(cPerg, Len(X1_GRUPO))
	
  	If SX1->X1_GSC == "G"
		cConteudo := cValToChar( &(SX1->X1_VAR01) )
	Elseif SX1->X1_GSC == "C"
		If __LANGUAGE == "PORTUGUESE"
			cConteudo := &("SX1->X1_DEF"+STRZERO(&(SX1->X1_VAR01),2))
		Elseif __LANGUAGE == "SPANISH"
			cConteudo := &("SX1->X1_DEFSPA"+Str(&(SX1->X1_VAR01),1))
		Elseif __LANGUAGE == "ENGLISH"
			cConteudo := &("SX1->X1_DEFENG"+Str(&(SX1->X1_VAR01),1))
		Endif
	Endif
	
	oPrint:Say(nLi,100,STR0017,oFontC10)		// "Pergunta"
	oPrint:Say(nLi,280,SX1->X1_ORDEM,oFontC10)
	oPrint:Say(nLi,348,": ",oFontC10)
	If __LANGUAGE == "PORTUGUESE"
		oPrint:Say(nLi,380,SX1->X1_PERGUNT,oFontC10)
	Elseif __LANGUAGE == "SPANISH"
		oPrint:Say(nLi,380,SX1->X1_PERSPA,oFontC10)
	Elseif __LANGUAGE == "ENGLISH"
		oPrint:Say(nLi,380,SX1->X1_PERENG,oFontC10)
	Endif
	oPrint:Say(nLi,1200,cConteudo,oFontC10)
	DbSelectArea("SX1")
	DbSetOrder(1)
	DbSKip()
	nLi += 80
End

oPrint:Line( nLi+80,30,nLi+80,3000 )   	// horizontal
nLinha := 2300

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tkr034RptDef ºAutor  ³Hanna               º Data ³  03/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para informar as celulas que serao utilizadas no rela-  º±±
±±º          ³latorio                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TMKR034                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data/Bops/Ver ºManutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Hanna    ³15/09/06º107543ºAlterada a referencia do campo U5_CONTAT       º±±
±±º Hanna    ³20/09/06º107440ºInclusao de Strings diferentes para as secoes  º±±
±±º          ³        º      ºInclusao do arquivo SUN (motivo encerramento)  º±±
±±³ Fernando ³11/10/06|811   |Foi modificada a funcao Tkr034RptDef para      ³±±
±±³			 |	      |		 |criacao de string a ser visualizada na opcao   ³±±
±±³			 |		  |		 |Personalizar do relatorio TMKR034              ³±±                               
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄ  |ÄÄÄÄÄÄ|ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ---Ù±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tkr034RptDef()
Local oReport				// Objeto do relatorio
Local oSection1				// Objeto da secao 1
Local oSection2				// Objeto da secao 2
Local cAlias1	:= "SUC"	// Define o Alias
Local cAlias2	:= "SU7"	// Define o Alias
Local cAlias3	:= "SUD"	// Define o Alias

#IFDEF TOP
	cAlias1		:= GetNextAlias()						// Pega o proximo Alias Disponivel
	cAlias2		:= cAlias1
	cAlias3		:= cAlias1
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera a tela com os dados para a confirmação da geracao do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//"Atendimento Telemarketing"
// "Relatorio de Atendimentos Telemarketing"
DEFINE REPORT oReport NAME "TMKR034" TITLE STR0015 PARAMETER "TMK034" ACTION {|oReport| Tkr034PrtRpt( oReport, cAlias1 ) } DESCRIPTION STR0016

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, informando que o arquivo principal utlizado eh o SL3 e o complementar o SB1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport TITLE STR0051 TABLES "SUC","SU5","SUH","SUL","SUN" COLUMNS 2		//"  Telemarketing"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "UC_CODIGO"	OF oSection1 ALIAS "SUC"
DEFINE CELL NAME "CONTATO"		OF oSection1 ALIAS "SUC" SIZE 36 TITLE STR0025 BLOCK {|| UC_CODCONT + " - " + SU5->U5_CONTAT }
DEFINE CELL NAME "UCDATA"		OF oSection1 ALIAS "SUC" SIZE 20 TITLE STR0020 BLOCK {|| DTOC(UC_DATA) + " - " + TKR034RetVal( UC_DATA ) }
DEFINE CELL NAME "U5_FCOM1"		OF oSection1 ALIAS "SU5"
DEFINE CELL NAME "UC_OPERACA"	OF oSection1 ALIAS "SUC"
DEFINE CELL NAME "X2NOME"		OF oSection1 SIZE 32 TITLE STR0006 BLOCK {|| Posicione("SX2",1,UC_ENTIDAD,"X2NOME()") }
DEFINE CELL NAME "UC_STATUS"	OF oSection1 ALIAS "SUC" BLOCK {|| TKR034RetSta( cAlias1 ) }
DEFINE CELL NAME "UH_DESC"	 	OF oSection1 ALIAS "SUH" BLOCK {|| TkEntidade(UC_ENTIDAD,UC_CHAVE,1) }
DEFINE CELL NAME "UC_OPERADO"	OF oSection1 ALIAS "SUC" SIZE 20 BLOCK {|| UC_OPERADO + " - " + (cAlias2)->U7_NOME }
DEFINE CELL NAME "UC_PENDENT"	OF oSection1 SIZE 20 TITLE STR0023 BLOCK {|| DTOC(UC_PENDENT) + " - " + TKR034RetVal( UC_PENDENT ) }
DEFINE CELL NAME "UC_HRPEND"	OF oSection1
DEFINE CELL NAME "UC_MIDIA" 	OF oSection1 ALIAS "SUC" SIZE 50 BLOCK {|| UC_MIDIA + Posicione("SUH",1,xFilial("SUH") + UC_MIDIA,"UH_DESC") }
DEFINE CELL NAME "ENDERECO"		OF oSection1 SIZE 40 TITLE STR0009 BLOCK {|| TkEntidade(UC_ENTIDAD,UC_CHAVE,2) }
DEFINE CELL NAME "COMUNICA"		OF oSection1 SIZE 40 TITLE STR0028 BLOCK {|| UC_TIPO + " - " + Posicione("SUL",1,xFilial("SUL") + UC_TIPO,"UL_DESC") }
DEFINE CELL NAME "BAIRRO"		OF oSection1 SIZE 40 TITLE STR0042 BLOCK {|| TkEntidade(UC_ENTIDAD,UC_CHAVE,10) }
DEFINE CELL NAME "CAMPANHA" 	OF oSection1 SIZE 40 TITLE STR0029 BLOCK {|| Posicione("SUO",1,xFilial("SUO") + UC_CODCAMP,"UO_DESC") }
DEFINE CELL NAME "MUNICI" 		OF oSection1 SIZE 40 TITLE STR0011 BLOCK {|| TkEntidade( UC_ENTIDAD,UC_CHAVE,3) }	// "Cidade"
DEFINE CELL NAME "ESTADO" 		OF oSection1 SIZE 2	 TITLE STR0012 BLOCK {|| TkEntidade( UC_ENTIDAD,UC_CHAVE,4) }	// "Estado"
DEFINE CELL NAME "UC_CODOBS" 	OF oSection1 ALIAS "SUC" TITLE STR0030 SIZE 180 BLOCK {|| MSMM( UC_CODOBS ) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao2 (que sera filha da secao1) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection2 OF oSection1 TITLE STR0050 TABLES "SUD","SB1","SU9","SUQ"	//"Itens - Atendimento Telemarketing"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "X5DESCRI"		OF oSection2 TITLE STR0031 SIZE 12 BLOCK {|| Posicione("SX5",1,xFilial("SX5") + "T1" + UD_ASSUNTO,"X5DESCRI()") }
DEFINE CELL NAME "UD_PRODUTO"	OF oSection2 ALIAS "SUD"
DEFINE CELL NAME "PRODUTO"		OF oSection2 TITLE STR0041 SIZE 60 BLOCK {|| Posicione("SB1",1,xFilial("SB1") + UD_PRODUTO, "B1_DESC") }
DEFINE CELL NAME "U9_DESC"		OF oSection2 ALIAS "SU9" BLOCK {|| UD_OCORREN }
DEFINE CELL NAME "UQ_DESC"		OF oSection2 ALIAS "SUQ" BLOCK {|| Posicione("SU9",2,xFilial("SU9")+UD_OCORREN,"U9_DESC") }
DEFINE CELL NAME "OPERADOR"		OF oSection2 TITLE STR0026 SIZE 20 BLOCK {|| TKR034RetPSW(cAlias3) }
DEFINE CELL NAME "UD_DATA"		OF oSection2 ALIAS "SUD"
DEFINE CELL NAME "UD_STATUS"	OF oSection2 ALIAS "SUD"
DEFINE CELL NAME "UD_DTEXEC"	OF oSection2 ALIAS "SUD"
DEFINE CELL NAME "UD_OBS"		OF oSection2 ALIAS "SUD" SIZE 180 BLOCK {|| UD_OBS }
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao3 (que sera filha da secao2) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:SetLineStyle()
oSection1:PageBreak()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKR034PrtºAutor  ³Hanna Caroline      º Data ³  04/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para impressao do relatorio personalizavel           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ANALISTA     ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Hanna Caroline³20/09/06³107440³Posicionado o SUN para imprimir o motivo³±±
±±³Tatiana Campos³29/03/07³121872³Alterada a variavel cQuery por conter %%³±±
±±³              ³        ³      ³e duplicar o caracter quando o parametro³±±
±±³              ³        ³      ³entidade era preenchido.                ³±±
±±³Norbert Waage ³09/04/07³123341³Alterada a variavel cQuery para que so- ³±±
±±³              ³        ³      ³mente ao final da definicao dos parame- ³±±
±±³              ³        ³      ³tros adicionais sejam utilizados os to- ³±±
±±³              ³        ³      ³kens '%'.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TKR034PrtRpt(oReport, cAlias1)
Local cQuery		:= ""								// Primeira Query
Local oSection1		:= oReport:Section(1)		   		// Define a secao 1 do relatorio
Local oSection2		:= oSection1:Section(1)				// Define que a secao 2 serah filha da secao 1
Local oSection3     := oSection2:Section(1)				// Define que a secao 3 serah filha da secao 1
Local cFiltro		:= ""								// Filtro para DBF
Local lCompart		:= SUC->(FieldPos("UC_CHAORIG")) > 0
	
DbSelectArea("SUC")
DbSetOrder(1)

#IFDEF TOP

	If !Empty(Mv_Par01)
		cQuery += " UC_ENTIDAD = '" + MV_PAR01 + "' AND "
	Endif
	
	If Mv_Par02 <> 3	// Ambos
		cQuery += "	( UC_OPERACA = '" + Str(MV_PAR02,1) + "' OR"		// Ativo ou Receptivo
		cQuery += "	UC_OPERACA = '')AND "
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente chamados que nao sao compartilhamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCompart
		cQuery += "	SUC.UC_CHAORIG = '' AND "
	EndIf
	
	If Mv_Par03 <> 4	// Todas
		cQuery += "	UC_STATUS = '" + Str(MV_PAR03,1) + "' AND "		// Plan. Pend. Encerr.
	Endif

	cQuery := "%"+cQuery+"%"
	
	MakeSqlExpr("TMKR034")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializa a secao 1³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BEGIN REPORT QUERY oSection1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query da secao 1³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BeginSql alias cAlias1
		SELECT	UC_CODIGO,	UC_CODCONT,	UC_DATA,	UC_CODOBS,
				UC_OPERADO,	UC_OPERACA,	UC_STATUS,	UC_STATUS,
				UC_PENDENT,	UC_HRPEND,	UC_MIDIA,	UC_TIPO,
				UC_CODCAMP,	UC_ENTIDAD,	UC_CHAVE,	UC_CODENCE,
				U7_NOME,	UD_OPERADO,	UD_DATA,	UD_STATUS,	UD_DTEXEC,	
				UD_OBS,		UD_SOLUCAO,	UD_PRODUTO,	UD_ASSUNTO,	
				UD_OCORREN
		FROM	%table:SUC% SUC, %table:SU7% SU7, %table:SUD% SUD
		WHERE	UC_FILIAL	= 	%xfilial:SUC%			AND 
				UD_FILIAL	= 	%xfilial:SUD%			AND 
				U7_FILIAL	= 	%xfilial:SU7%			AND 
				UC_DATA 	>=	%exp:DtoS(mv_par04)%	AND
				UC_DATA 	<=	%exp:DtoS(mv_par05)%  	AND
				UC_OPERADO	=	U7_COD					AND
				UC_CODIGO	=	UD_CODIGO				AND
				UC_CODCANC	=	' '						AND
				%exp:cQuery%
				SUC.%notDel%							AND
				SU7.%notDel%							AND
				SUD.%notDel%							
		ORDER BY %Order:SUC%
	EndSql
	END REPORT QUERY oSection1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Baseada na query da secao1, utiliza filtro para saber quando deve sair do laco de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection2:SetParentQuery()
	oSection2:SetParentFilter( { | cParam | (cAlias1)->UC_CODIGO == cParam},{|| (cAlias1)->UC_CODIGO } )

	TRPosition():New(oSection1,"SUL",1,{|| xFilial("SUL") + (cAlias1)->UC_TIPO } )
	TRPosition():New(oSection1,"SUH",1,{|| xFilial("SUH") + (cAlias1)->UC_MIDIA } )
	TRPosition():New(oSection1,"SUO",1,{|| xFilial("SUO") + (cAlias1)->UC_CODCAMP } )
	TRPosition():New(oSection1,"SU5",1,{|| xFilial("SU5") + (cAlias1)->UC_CODCONT })  
	TRPosition():New(oSection1,"SUN",1,{|| xFilial("SUN") + (cAlias1)->UC_CODENCE })  
	
	TRPosition():New(oSection2,"SU9",1,{|| xFilial("SU9") + (cAlias1)->UD_OCORREN } )
	TRPosition():New(oSection2,"SUQ",1,{|| xFilial("SUQ") + (cAlias1)->UD_SOLUCAO } )
	
#ELSE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr("TMK034")

	cFiltro := "UC_FILIAL = '" + xFilial("SUC") + "'"   
	cFiltro += " .AND. Empty(UC_CODCANC) "
	cFiltro += " .AND. DTOS(UC_DATA) >= '" + DTOS(MV_PAR04) + "' .AND. DTOS(UC_DATA) <= '" + DTOS(MV_PAR05) + "'"

	If !Empty(MV_PAR01)
		cFiltro += ".AND. UC_ENTIDAD = '" + MV_PAR01 + "'"
	Endif
	
	If MV_PAR02 <> 3	// Ambos
		cFiltro += ".AND.( UC_OPERACA = '" + Str(MV_PAR02,1) + "' OR"		// Ativo ou Receptivo
		cFiltro += "	UC_OPERACA = '') "
	Endif
	
	If MV_PAR03 <> 4	// Todas
		cFiltro += "	.AND. UC_STATUS = '" + Str(MV_PAR03,1) + "'"		// Plan. Pend. Encerr.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente chamados que nao sao compartilhamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCompart
		cFiltro += "	.AND. UC_CHAORIG = ''"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua o filtro de acordo com a expressao (somente do SL3), pois o SB1 nao esta sendo utilizado ainda ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:SetFilter( cFiltro )
	
	oSection2:SetRelation({|| xFilial("SUD") + SUC->UC_CODIGO },"SUD",1,.T. )
	oSection2:SetParentFilter({|cParam| SUD->UD_CODIGO == cParam},{|| SUC->UC_CODIGO })

	TRPosition():New(oSection1,"SUL",1,{|| xFilial("SUL") + SUC->UC_TIPO } )
	TRPosition():New(oSection1,"SUH",1,{|| xFilial("SUH") + SUC->UC_MIDIA } )
	TRPosition():New(oSection1,"SUO",1,{|| xFilial("SUO") + SUC->UC_CODCAMP } )
	TRPosition():New(oSection1,"SU5",1,{|| xFilial("SU5") + SUC->UC_CODCONT })  
	TRPosition():New(oSection1,"SU7",1,{|| xFilial("SU7") + SUC->UC_OPERADO }) 
	TRPosition():New(oSection1,"SUN",1,{|| xFilial("SUN") + SUC->UC_CODENCE })   
	
	TRPosition():New(oSection2,"SU9",2,{|| xFilial("SU9") + SUD->UD_OCORREN } )
	TRPosition():New(oSection2,"SUQ",1,{|| xFilial("SUQ") + SUD->UD_SOLUCAO } )
	TRPosition():New(oSection2,"SB1",1,{|| xFilial("SB1") + SUD->UD_PRODUTO } )
#ENDIF	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a impressao dos dados, de acordo com o filtro ou query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKR034RetValºAutor  ³Hanna Caroline    º Data ³  04/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para retorno do dia em extenso                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TKR034RetVal( cCampo )
Local cRet := ""			// Retorno da funcao

If !Empty( cCampo )
	cRet := DiaExtenso( cCampo )
Endif

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKR034RetPSWºAutor  ³Hanna Caroline    º Data ³  04/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para retornar o nome do operador de acordo com o PSS º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TKR034RetPSW(cAlias3)
Local cRet := ""			// Retorno da funcao
PswOrder(1)
If PswSeek( (cAlias3)->UD_OPERADO )
	cRet	:= PswRet()[1][4]
Endif
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKR034RetStaºAutor  ³Hanna Caroline    º Data ³  11/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para retornar o status do atendimento                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TKR034RetSta(cAlias1)
Local cRet := ""			// Retorno da funcao
Do Case
	Case VAL((cAlias1)->UC_STATUS) == PLANEJADA
		cRet := STR0001

	Case VAL((cAlias1)->UC_STATUS) == PENDENTE
		cRet := STR0002

	Case VAL((cAlias1)->UC_STATUS) == ENCERRADA
		cRet := STR0003
EndCase
Return cRet
