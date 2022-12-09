#INCLUDE "PROTHEUS.CH"

//+--------------------------------------------------------------------+
//| DESCRIÇÃO: RELATÓRIO ADAPTADO PARA CERTISIGN CERTIFICADORA DIGITAL |
//| EVOLUÇÃO.: INSERIDO OS PARÂMETROS DATA DE BAIXA DE/ATE.            |
//| .........: INSERIDO OS PARÂMETROS NA QUERY.                        |
//| .........: INSERIDO A COLUNA NATUREZA.                             |
//| AUTOR....: ROBSON GONÇALVES e GIOVANNI RODRIGUES                   |
//| DATA.....: 14/05/2014                                              |
//+--------------------------------------------------------------------+

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR940	³ Autor ³ Nilton Pereira        ³ Data ³ 02.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de titulos a receber com rentencao PIS/Cofins/CSLL ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR940(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINR940()

Local cDesc1    := If( cPaisLoc $ "ANG|PTG", "Imprime A Relação Dos Títulos A Receber Que Sofreram Retenção De Impostos", ;
                                  "Imprime a relacao dos titulos a receber que sofreram retencao de Impostos" )
Local cDesc2    := ""
Local cDesc3    := ""
Local wnrel
Local cString   := "SE1" //Contas a Receber
Local nRegEmp   := SM0->(RecNo())
Local aTam	    := TAMSX3("E1_NUM")

Private titulo  := ""
Private cabec1  := ""
Private cabec2  := ""
Private aLinha  := {}
Private aReturn := { If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" ), 1,If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" ), 1, 2, 1, "",1 }
Private aOrd    := { If( cPaisLoc $ "ANG|PTG", "Por Código Cliente", "Por Codigo Cliente" ),"Por Nome Cliente"}
Private cPerg	 := "RFINR940"
Private nJuros  := 0
Private nLastKey:= 0
Private nomeprog:= "RFINR940"
Private tamanho := "G"

CriaSX1( cPerg )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("RFINR940",.T.)})
			
Pergunte("RFINR940",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := If( cPaisLoc $ "ANG|PTG", "Títulos A Receber Com Retenção De Impostos", ;
                                    "Titulos a Receber com retencao de Impostos" )

cabec1 := "Codigo         Nome do Cliente                CGC"
cabec2 := "     Prf Numero      Pc  Tipo  Dt Emissao Dt.Vencto   Valor Original    Natureza          Valor IRFF       Valor ISS      Valor INSS       Valor PIS    Valor COFINS      Valor CSLL   Valor Liquido   Data Baixa" 
//                                                               999.999.999,99    XXXXXXXXXX    999.999.999,99
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros    ³
//³ mv_par01       // Do Cliente            ³
//³ mv_par02       // Ate o Cliente         ³
//³ mv_par03       // Da loja               ³
//³ mv_par04       // Ate a loja            ³
//³ mv_par05       // Da DaTa               ³
//³ mv_par06       // Ate Data              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RFINR940"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,"",.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| FA940Imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA940Imp ³ Autor ³ Nilton Pereira        ³ Data ³ 29.07.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de impressao dos titulos com rentecao de impostos   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA940Imp(lEnd,WnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock                                ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³			 ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA940Imp(lEnd,WnRel,cString)

Local CbCont
Local CbTxt
Local cCGCAnt
Local cChaveSe1
Local lContinua	:= .T.
Local nTitCli	:= 0
Local nTitRel	:= 0
Local nVlCliOri	:= 0
Local nVlCliIns	:= 0
Local nVlCliLiq	:= 0
Local nVlTotOri	:= 0
Local nVlTotIns	:= 0
Local nVlTotPis	:= 0
Local nVlTotCof	:= 0
Local nVlTotCsl	:= 0
Local nVlTotIrf	:= 0 
Local nVlCliIrf	:= 0
Local nVlTotIss	:= 0 
Local nVlCliIss	:= 0
Local nVlTotSes	:= 0 
Local nVlCliSes	:= 0
Local nVlCliPis	:= 0
Local nVlCliCof	:= 0
Local nVlCliCsl	:= 0
Local nVlTotLiq	:= 0
Local aCampos	:= {}                                   
Local cCodCli	:= ""
Local cLojCli	:= ""
Local cNomCli	:= ""                       
Local aTamNum	:= TAMSX3("E1_NUM")
Local nOrdem	:= aReturn[8]   
Local nValBase := 0
Local lPendRet := .F.
Local lTitRtImp:= .F.
Local lContrAbt := !Empty( SE1->( FieldPos( "E1_SABTPIS" ) ) ) .And. !Empty( SE1->( FieldPos( "E1_SABTCOF" ) ) ) .And. ; 
						 !Empty( SE1->( FieldPos( "E1_SABTCSL" ) ) ) 
Local nValorLiq := 0

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPis		:= 0
Local nCofins	:= 0
Local nCsll		:= 0		
Local lQuery	:= .F.

//Controla o Pis Cofins e Csll na RA (1 = Controla retenção de impostos no RA; ou 2 = Não controla retenção de impostos no RA(default))
Local lRaRtImp  := If (FindFunction("FRaRtImp"),FRaRtImp(),.F.)

#IFDEF TOP
	lQuery	:= .T.
#ELSE
	Local nIndexSE1
#ENDIF

aCampos	:= {	{"CODIGO"	,"C",06,0 },;
				{"LOJA"	,"C",02,0 },;
				{"NOMECLI"	,"C",40,0 },;
				{"CGC"		,"C",14,0 },;
				{"PREFIXO"	,"C",03,0 },;
				{"NUM"		,"C",aTamNum[1],0 },;
				{"PARCELA"	,"C",TamSx3("E1_PARCELA")[1],0 },;
				{"RECISS"	,"C",03,0 },;
				{"TIPO"		,"C",03,0 },;
				{"EMISSAO"	,"D",08,0 },;
				{"VENCTO"	,"D",08,0 },;
				{"NATUREZA" ,"C",10,0 },;
				{"VALBASE"  ,"N",17,2 },;
				{"VALINSS"	,"N",17,2 },;
				{"VALPIS"	,"N",17,2 },;
				{"VALCOF"	,"N",17,2 },;
				{"VALCSLL"	,"N",17,2 },;
				{"VALIRRF"	,"N",17,2 },;
				{"VALISS"	,"N",17,2 },;
				{"SABTCOF"	,"N",17,2 },;
				{"SABTCSL"	,"N",17,2 },;
				{"SABTPIS"	,"N",17,2 },;
				{"BAIXA"    ,"D",08,0 },;
				{"MOEDA"    ,"N",02,0 }}
				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= ""
cbcont	:= 1
li 		:= 80
m_pag 	:= 1

dbSelectArea("SE1")

If nOrdem == 1  //Por Codigo
	dbSetOrder(6)
Else            //Por Nome
	dbSetOrder(2)
Endif

cChaveSe1 := IndexKey()

If lQuery
	If nOrdem == 1  //Por Codigo
		cOrder := "CODIGO,LOJA,PREFIXO,NUM,PARCELA,TIPO"
	Else            //Por Nome
		cOrder := "NOMECLI,PREFIXO,NUM,PARCELA,TIPO"
	Endif
	
	cQuery := "SELECT A1_COD CODIGO,A1_LOJA LOJA,A1_NOME NOMECLI,A1_CGC CGC,A1_RECISS RECISS,E1_PREFIXO PREFIXO, E1_NATUREZ NATUREZA,"
	cQuery += " E1_NUM NUM,E1_PARCELA PARCELA,E1_TIPO TIPO,E1_EMISSAO EMISSAO,E1_VENCREA VENCTO,"
	cQuery += " E1_IRRF VALIRRF,E1_ISS VALISS,E1_INSS VALINSS,"
	cQuery += " E1_PIS VALPIS,E1_COFINS VALCOF,E1_CSLL VALCSLL,E1_BAIXA BAIXA, E1_MOEDA MOEDA,"	
	cQuery += " E1_VALOR VALBASE,E1_SALDO VALSALDO "

	If lContrAbt
		cQuery += " ,E1_SABTPIS SABTPIS,E1_SABTCOF SABTCOF, E1_SABTCSL SABTCSL"
	Endif

	cQuery += " FROM "+RetSqlName("SE1")+" SE1 INNER JOIN "
	cQuery +=         RetSqlName("SA1")+" SA1 "
	cQuery += " ON SE1.E1_CLIENTE  =  SA1.A1_COD"
	cQuery += " AND SE1.E1_LOJA  =  SA1.A1_LOJA"
	cQuery += " WHERE SE1.E1_CLIENTE  between '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery += " AND SE1.E1_LOJA     between '" + mv_par03 + "' AND '" + mv_par04 + "'"
	cQuery += " AND (E1_PIS > 0 OR E1_COFINS > 0"
	cQuery += " OR E1_CSLL > 0 OR E1_IRRF > 0 "
	cQuery += " OR E1_INSS > 0 OR E1_ISS > 0)"
	cQuery += " AND SE1.E1_BAIXA between '" + DTOS( mv_par09 ) + "' AND '" + DTOS(mv_par10 ) + "'"
	cQuery += " AND SE1.E1_VENCREA  between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
	cQuery += " AND SE1.E1_EMISSAO  between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
	cQuery += " AND SE1.E1_EMISSAO  <= '"      + DTOS(dDataBase) + "' AND "
	cQuery += RetSQLCond("SE1,SA1")

	cQuery += " ORDER BY "+ cOrder
	cQuery := ChangeQuery(cQuery) 

	dbSelectArea("SE1")
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
ELSE
	cIndexSe1 := CriaTrab(nil,.f.)
	IndRegua("SE1",cIndexSe1,cChaveSe1,,FR940IndR(),If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." ))  //"Selecionando Registros..."
	nIndexSE1 := RetIndex("SE1")
	dbSetIndex(cIndexSe1+OrdBagExt())
	dbSetOrder(nIndexSE1+1)
	dbSeek(xFilial("SE1"))

	cArqTrab := CriaTrab( aCampos )
	dbUseArea( .T.,, cArqTrab, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
	If nOrdem == 1  //Por Codigo
		IndRegua("TRB",cArqTrab,"CODIGO+LOJA",,,)
	Else            //Por Nome
		IndRegua("TRB",cArqTrab,"NOMECLI",,,)
	Endif
	dbSetIndex( cArqTrab +OrdBagExt())

	dbSelectArea("SE1")				

	While !Eof()   // SE1        
	
		dbSelectArea("SA1")			
		dbSetOrder(1)
		
		If dbSeek(xFilial()+SE1->(E1_CLIENTE+E1_LOJA))
			
			nValBase	:= SE1->E1_VALOR
			
			dbSelectArea("TRB")
			RecLock("TRB",.T.)	
			TRB->CODIGO		:= SA1->A1_COD
			TRB->LOJA		:= SA1->A1_LOJA
			TRB->NOMECLI	:= SA1->A1_NOME 
			TRB->CGC			:= SA1->A1_CGC
			TRB->RECISS		:= SA1->A1_RECISS
			TRB->PREFIXO	:= SE1->E1_PREFIXO
			TRB->NUM			:= SE1->E1_NUM
			TRB->PARCELA	:= SE1->E1_PARCELA
			TRB->TIPO		:= SE1->E1_TIPO
			TRB->EMISSAO	:= SE1->E1_EMISSAO
			TRB->VENCTO		:= SE1->E1_VENCREA
			TRB->NATUREZA  := SE1->E1_NATUREZ
			TRB->VALBASE	:= nValBase
			TRB->VALINSS	:= SE1->E1_INSS

			If lPccBxCr
				//Funcao que retorna o valor dos impostos retidos
            FVPccBxCr(TRB->(PREFIXO+NUM+PARCELA+TIPO+CODIGO+LOJA),@nPis,@nCofins,@nCsll)
				TRB->VALPIS		:= nPis
				TRB->VALCOF		:= nCofins
				TRB->VALCSLL	:= nCsll
				TRB->SABTCOF   := 0
				TRB->SABTCSL   := 0
				TRB->SABTPIS   := 0
			Else
				TRB->VALPIS		:= SE1->E1_PIS
				TRB->VALCOF		:= SE1->E1_COFINS
				TRB->VALCSLL	:= SE1->E1_CSLL   
	
				If lContrAbt
					TRB->SABTCOF   := SE1->E1_SABTCOF
					TRB->SABTCSL   := SE1->E1_SABTCSL
					TRB->SABTPIS   := SE1->E1_SABTPIS	
				Else
					TRB->SABTCOF   := 0
					TRB->SABTCSL   := 0
					TRB->SABTPIS   := 0
				Endif
			Endif
			
			TRB->VALIRRF	:= SE1->E1_IRRF
			TRB->VALISS		:= SE1->E1_ISS 
			TRB->BAIXA		:= SE1->E1_BAIXA
			TRB->MOEDA		:= SE1->E1_MOEDA
			MSUnlock()             
		Endif
		dbSelectArea("SE1")
		dbSkip()
	EndDo
	dbSelectArea("TRB")
	dbGoTop()
ENDIF

SetRegua(TRB->(Reccount()))

While !Eof() 
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi(If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )) //"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF
	IncRegua()
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF

	If TRB->RECISS == "2" .And. GetNewPar("MV_DESCISS",.F.) == .T. .And.;
		(TRB->VALIRRF+TRB->VALINSS+TRB->VALPIS+TRB->VALCOF+TRB->VALCSLL) == 0
		TRB->(dbSkip())
		Loop
	EndIf
	
	nTitCli		:= 0
	nVlCliOri	:= 0
	nVlCliIns	:= 0
	nVlCliLiq	:= 0
	nVlCliPis	:= 0
	nVlCliCof	:= 0
	nVlCliCsl	:= 0
	nVlCliSes	:= 0
	nVlCliIrf	:= 0
	nVlCliIss	:= 0
	nValBase		:= 0

	@li,  0 PSAY Alltrim(TRB->CODIGO)+" - "+Alltrim(TRB->LOJA)
	@li, 15 PSAY Substr(TRB->NOMECLI,1,30)
	@li, 46 PSAY TRB->CGC Picture IIF(Len(Alltrim(TRB->CGC)) == 11 , "@R 999.999.999-99","@R 99.999.999/9999-99")
	li++

	cCodCli		:= TRB->CODIGO
	cLojCli		:= TRB->LOJA
	cNomCli		:= TRB->NOMECLI                       
	cCGCAnt		:= TRB->CGC    
		
	li++
	While !EOF() .And. cCodCli+cLojCli == TRB->(CODIGO+LOJA) .And. 	cNomCli == TRB->NOMECLI                       
		
		lPendRet  := .F. 
		lTitRtImp := .F.

		If ChkAbtImp(TRB->PREFIXO,TRB->NUM,TRB->PARCELA,TRB->MOEDA,"V",TRB->BAIXA) > 0
			lTitRtImp := .T.
		EndIf

		If	lContrAbt .And. (TRB->SABTCOF + TRB->SABTCSL +	TRB->SABTPIS) > 0
			lPendRet := .T.
		Endif			

		If	lTitRtImp .and. !lPendRet
			nPis		:= TRB->VALPIS
			nCofins	:= TRB->VALCOF
			nCsll		:= TRB->VALCSLL			
			nValorLiq:= TRB->(VALBASE - VALIRRF - VALINSS - VALPIS- VALCOF - VALCSLL)
		Else
			nPis		:= 0
			nCofins	:= 0
			nCsll		:= 0
			nValorLiq:= TRB->(VALBASE - VALIRRF - VALINSS)
		Endif			

		If lPccBxCr
			nPis		:= 0
			nCofins	:= 0
			nCsll		:= 0
			If TRB->VALSALDO == TRB->VALBASE //Ainda não houve baixa, exibo os valores que serão retidos através de AB-
				nPis		:= TRB->VALPIS
				nCofins	:= TRB->VALCOF
				nCsll		:= TRB->VALCSLL	
			Else
				FVPccBxCr (TRB->(PREFIXO+NUM+PARCELA+TIPO+CODIGO+LOJA),@nPis,@nCofins,@nCsll) 
				If lRaRtImp .AND. (TRB->TIPO $ MVRECANT)				
					nValorLiq:= TRB->(VALBASE - VALIRRF - VALINSS )					
				Else
					nValorLiq:= TRB->(VALBASE - VALIRRF - VALINSS - nPis - nCofins - nCsll)					
				EndIf
			EndIf	
		Endif

		If TRB->RECISS == "1" .And. GetNewPar("MV_DESCISS",.F.) == .T.
			nValorLiq -= TRB->VALISS
		EndIf
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
	
		@li, 05 PSAY TRB->PREFIXO
		@li, 09 PSAY TRB->NUM
		
		@LI, 021 PSAY TRB->PARCELA
		@li, 025 PSAY TRB->TIPO

		#IFDEF TOP
			@li, 031 PSAY STOD(TRB->EMISSAO)
			@li, 042 PSAY STOD(TRB->VENCTO)
			@li, 053 PSAY TRB->VALBASE		Picture tm (TRB->VALBASE ,15)			
		#ELSE
			@li, 031 PSAY TRB->EMISSAO
			@li, 042 PSAY TRB->VENCTO
			@li, 053 PSAY TRB->VALBASE		Picture tm (TRB->VALBASE ,15)
		#ENDIF     
		
		@li, 072 PSAY TRB->NATUREZA	
		@li, 085 PSAY TRB->VALIRRF		Picture tm (TRB->VALIRRF ,15)
		@li, 101 PSAY IIf(TRB->RECISS=="2",0,TRB->VALISS)			Picture tm (TRB->VALISS  ,15)
		@li, 117 PSAY TRB->VALINSS  	Picture tm (TRB->VALINSS ,15)

		@li, 133 PSAY nPis		Picture tm (nPis  ,15)
		@li, 149 PSAY nCofins	Picture tm (nCofins  ,15)
		@li, 165 PSAY nCsll		Picture tm (nCsll ,15)

		@li, 181 PSAY nValorLiq Picture tm (nValorLiq  ,15)

		If (nPis + nCofins + nCsll) > 0 .And. !lPendRet .And. !lTitRtImp
			@li, 197 PSAY "A"
		EndIf		
		
		#IFDEF TOP
			@li, 199 PSAY STOD(TRB->BAIXA)
		#ELSE
			@li, 199 PSAY TRB->BAIXA
		#ENDIF

		li++
		nTitCli++
		nVlCliOri += TRB->VALBASE
		nVlCliLiq += nValorLiq
		nVlCliIns += TRB->VALINSS
		nVlCliPis += nPis
		nVlCliCof += nCofins
		nVlCliCsl += nCsll
		nVlCliIrf += TRB->VALIRRF                  
		nVlCliIss += IIf(TRB->RECISS=="2",0,TRB->VALISS)
		dbSkip()
	Enddo	
	li++
	IF nVlCliOri > 0 
		SubTot940(nTitCli,nVlCliOri,nVlCliIns,nVlCliLiq,cNomCli,cCgcAnt,nVlCliPis,nVlCliCof,nVlCliCsl,nVlCliSes,nVlCliIrf,nVlCliIss)
	Endif

	nTitRel	 += nTitCli
	nVlTotOri += nVlCliOri
	nVlTotLiq += nVlCliLiq
	nVlTotIns += nVlCliIns       
	nVlTotPis += nVlCliPis
	nVlTotCof += nVlCliCof
	nVlTotCsl += nVlCliCsl
	nVlTotIrf += nVlCliIrf
	nVlTotIss += nVlCliIss
Enddo

IF li != 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	TotGeR940(nVlTotOri,nVlTotIns,nVlTotPis,nVlTotCof,nVlTotCsl,nVlTotLiq,nTitRel,nVlTotIrf,nVlTotIss,nVlTotSes)

	If lPendRet
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
		@li, 001 PSAY If( cPaisLoc $ "ANG|PTG", "A = os valores de pis,cofins e csll deste titulo foram retidos noutro título.", "A = Os valores de Pis,Cofins e Csll deste titulo foram retidos em outro titulo." )	 //"A = Os valores de Pis,Cofins e Csll deste titulo foram retidos em outro titulo."
		@li++
	Endif
	Roda(cbcont,cbtxt,"G")
EndIF

Set Device To Screen

If !lQuery
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndexSE1)
		FErase (cIndexSE1+OrdBagExt())
	Endif
	dbSetOrder(1)
	TRB->(dbCloseArea())
	fErase( cArqTrab + GetDBExtension() )
	fErase( cArqTrab + OrdBagExt() )

ELSE
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	dbSetOrder(1)
	TRB->(dbCloseArea())
ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot940 ³ Autor ³ Nilton Pereira        ³ Data ³ 02.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprimir SubTotal do Relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot940()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function SubTot940(nTitCli,nVlCliOri,nVlCliIns,nVlCliLiq,cNomCli,cCgcAnt,nVlCliPis,nVlCliCof,nVlCliCsl,nVlCliSes,nVlCliIrf,nVlCliIss)

@li,000 PSAY Replicate("-",220)                              
li+=1     
@li,000 PSAY If( cPaisLoc $ "ANG|PTG", "Total cliente  - ", "Total Cliente  - " ) + Substr(cNomCli,1,09)  //"Total Cliente  - "

@li,030 PSAY " ("+ALLTRIM(STR(nTitCli))+" "+IiF(nTitCli > 1,If( cPaisLoc $ "ANG|PTG", "Títulos", "TITULOS" ),If( cPaisLoc $ "ANG|PTG", "Título", "TITULO" ))+")" //"TITULOS"###"TITULO"

@li,053 PSAY nVlCliOri		Picture TM(nVlCliOri,15)
@li,085 PSAY nVlCliIrf		Picture TM(nVlCliIrf,15)
@li,101 PSAY nVlCliIss		Picture TM(nVlCliIss,15)
@li,117 PSAY nVlCliIns		Picture TM(nVlCliIns,15)
@li,133 PSAY nVlCliPis		Picture TM(nVlCliLiq,15)
@li,149 PSAY nVlCliCof		Picture TM(nVlCliLiq,15)
@li,165 PSAY nVlCliCsl		Picture TM(nVlCliLiq,15)
@li,181 PSAY nVlCliLiq		Picture TM(nVlCliLiq,15)

li++
@li,000 PSAY Replicate("-",220)
li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TotGeR940³ Autor ³ Nilton Pereira        ³ Data ³ 02.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ TotGeR940()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Finr940                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function TotGeR940(nVlTotOri,nVlTotIns,nVlTotPis,nVlTotCof,nVlTotCsl,nVlTotLiq,nTitRel,nVlTotIrf,nVlTotIss,nVlTotSes)

@li,000 PSAY Replicate("_",220)
li+= 2
@li,000 PSAY If( cPaisLoc $ "ANG|PTG", "Total geral      ----> ", "TOTAL GERAL      ----> " ) //"TOTAL GERAL      ----> "
@li,030 PSAY "("+ALLTRIM(STR(nTitRel))+" "+IIF(nTitRel > 1,If( cPaisLoc $ "ANG|PTG", "Títulos", "TITULOS" ),If( cPaisLoc $ "ANG|PTG", "Título", "TITULO" ))+")"	 //"TITULOS"###"TITULO"
@li,053 PSAY nVlTotOri	   Picture TM(nVlTotOri,15)
@li,085 PSAY nVlTotIrf		Picture TM(nVlTotIrf,15)
@li,101 PSAY nVlTotIss		Picture TM(nVlTotIss,15)
@li,117 PSAY nVlTotIns	   Picture TM(nVlTotIns,15)
@li,133 PSAY nVlTotPis		Picture TM(nVlTotPis,15)
@li,149 PSAY nVlTotCof		Picture TM(nVlTotCof,15)
@li,165 PSAY nVlTotCsl		Picture TM(nVlTotCsl,15)
@li,181 PSAY nVlTotLiq	   Picture TM(nVlTotLiq,15)
li++
@li,000 PSAY Replicate("_",220)
li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FR940IndR ³ Autor ³ Nilton Pereira        ³ Data ³ 01.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio	                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Finr940                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#IFNDEF TOP
	Static Function FR940IndR()
	Local cFiltro
	
	cFiltro := ' E1_FILIAL=="'+xFilial("SE1")+'".AND.'
	cFiltro += ' E1_CLIENTE>="'+mv_par01+'" .AND. E1_CLIENTE<="'+mv_par02+'" .AND.'
	cFiltro += ' E1_LOJA>="'+mv_par03+'" .AND. E1_LOJA<="'+mv_par04+'" .AND.'
	cFiltro += ' (E1_PIS > 0 .OR. E1_COFINS > 0 .OR.' 
	cFiltro += ' E1_CSLL > 0 .OR. E1_IRRF > 0 .OR.'
	cFiltro += ' E1_INSS > 0 .OR. E1_ISS > 0) .AND.'                 
	cFiltro += ' DTOS(E1_BAIXA) >= "'+DTOS(mv_par09)+ '".And.DTOS(E1_BAIXA) <= "'+DTOS(mv_par10)+'".AND.'
	cFiltro += ' DTOS(E1_VENCREA) >="'+DTOS(mv_par07)+'".And.DTOS(E1_VENCREA)<="'+DTOS(mv_par08)+'".AND.'
	cFiltro += ' DTOS(E1_EMISSAO) >="'+DTOS(mv_par05)+'".And.DTOS(E1_EMISSAO)<="'+DTOS(mv_par06)+'".AND.'
	cFiltro += ' DTOS(E1_EMISSAO) <="'+DTOS(dDataBase)+'"'

	Return cFiltro
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ChkAbtImp ³ Autor ³ Ricardo A. Canteras   ³ Data ³10/08/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Soma titulos de abatimento relacionado aos impostos         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ChkAbtImp()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Prefixo,Numero,Parcela,Moeda,Saldo ou Valor,Data            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINR940                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ChkAbtImp(cPrefixo,cNumero,cParcela,nMoeda,cCpo,dData)

Local cAlias:=Alias()
Local nRec:=RecNo()
Local nTotAbImp := 0

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr := 0

dData :=IIF(dData==NIL,dDataBase,dData)
nMoeda:=IIF(nMoeda==NIL,1,nMoeda)

cCampo	:= IIF( cCpo == "V", "E1_VALOR" , "E1_SALDO" )

If Select("__SE1") == 0
	ChkFile("SE1",.F.,"__SE1")
Else
	dbSelectArea("__SE1")
Endif

dbSetOrder( 1 )
dbSeek( xFilial("SE1")+cPrefixo+cNumero+cParcela )

While !Eof() .And. E1_FILIAL == xFilial("SE1") .And. E1_PREFIXO == cPrefixo .And.;
		E1_NUM == cNumero .And. E1_PARCELA == cParcela
	If E1_TIPO != 'AB-' .And. E1_TIPO $ MVCSABT+"/"+MVCFABT+"/"+MVPIABT
		nTotAbImp +=xMoeda(&cCampo,E1_MOEDA, nMoeda,dData) 
	Endif
	dbSkip()
Enddo

dbSetOrder( 1 )

dbSelectArea( cAlias )
dbGoTo( nRec )                     

Return ( nTotAbImp )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FPccBxCr	ºAutor  ³Mauricio Pequim Jr. º Data ³  03/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para obter valor total de PCC retido na baixa CR    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico - PCC Baixa CR                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                    
STATIC Function FVPccBxCr(cChave,nPis,nCofins,nCsll)

Local aArea := GetArea()

DEFAULT cChave := ""
DEFAULT nPis	:= 0
DEFAULT nCofins:= 0
DEFAULT nCsll	:= 0		

If !Empty(cChave)
	dbSelectArea("SE5")
	dbSetOrder(7) //Prefixo+Numero+Parcela+Tipo+CliFor+Loja+SeqBx
	If MsSeek(xFilial("SE5")+cChave)
		While !Eof() .and. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == xFilial("SE5")+cChave

			IF SE5->E5_SITUACA != 'C' .and. !TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) 
				If Empty(SE5->E5_PRETPIS)
					nPis	+= SE5->E5_VRETPIS					
				Endif
				If Empty(SE5->E5_PRETCOF)
					nCofins	+= SE5->E5_VRETCOF					
				Endif
				If Empty(SE5->E5_PRETCSL)
					nCsll	+= SE5->E5_VRETCSL					
				Endif
			Endif
			dbSkip()
		Enddo
	Else
		nPis		:= 0
		nCofins	:= 0
		nCsll		:= 0		
	Endif			
Endif

RestArea(aArea)

Return

Static Function CriaSX1( cPerg )
	PutSX1(cPerg,"01","Do Cliente ?"    ,"¿Del Cliente ?"   ,"From customer ?"  ,"MV_CH1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","S","001","","","")
	PutSX1(cPerg,"02","Ate o Cliente ?" ,"¿Al Cliente ?"    ,"To customer ?"    ,"MV_CH2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","S","001","","","")
	PutSX1(cPerg,"03","Da Loja ?"       ,"¿De la tienda ?"  ,"From unit ?"      ,"MV_CH3","C",2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","XM0","S","002","","","")
	PutSX1(cPerg,"04","Ate a Loja ?"    ,"¿A la tienda ?"   ,"To unit ?"        ,"MV_CH4","C",2,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","XM0","S","002","","","")
	PutSX1(cPerg,"05","Da Emissao ?"    ,"¿De la emision ?" ,"From issue date ?","MV_CH5","D",8,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","","")
	PutSX1(cPerg,"06","Ate a Emissao ?" ,"¿A la emision ?"  ,"To issue date ?"  ,"MV_CH6","D",8,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","","")
	PutSX1(cPerg,"07","De Vencimento ?" ,"¿De vencimiento ?","From due date ?"  ,"MV_CH7","D",8,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","","")
	PutSX1(cPerg,"08","Ate Vencimento ?","¿A vencimiento ?" ,"To due date ?"    ,"MV_CH8","D",8,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","","")
	PutSX1(cPerg,"09","Da Baixa ?"      ,"¿De baixa ?"      ,"Da baixa ?"       ,"MV_CH9","D",8,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","","")
	PutSX1(cPerg,"10","Ate Baixa ?"     ,"¿Ate baixa ?"     ,"Ate baixa ?"      ,"MV_CHA","D",8,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","","")
Return