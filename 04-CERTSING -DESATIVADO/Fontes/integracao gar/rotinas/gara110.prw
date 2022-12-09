#INCLUDE "PROTHEUS.CH"

STATIC __ProcStat := {}
STATIC aEntry	  := {}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. Tessaroliº Data ³  23/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa reservado para realizar as funcoes do GARA110 nos  º±±
±±º          ³novos modelos de notas fiscais.                             º±±
±±º          ³Importa cliente, pedido e gera RA no financeiro, depois     º±±
±±º          ³fatura servico e mercadoria para entrega futura, integrado  º±±
±±º          ³com o GAR via WS                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GARA110(aDadosSA1, aDadosSC5, aDadosSC6, aDadosSE1, aParcsSE1)

Local aRet			:= {}
Local aAuxSE1		:= ()
Local nTotalSE1		:= 0
Local nPC5_TipMov	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_TIPMOV" } )
Local nPC5_TipVou	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_TIPVOU" } )
Local nPE1_TipMov	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_TIPMOV" } )
Local nPA1_Cgc		:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_CGC" } )
Local nPC5_Cnpj		:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_CNPJ" } )
Local nPE1_Cnpj		:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_CNPJ" } )
Local nPC5_TotPed	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_TOTPED" } )
Local nPE1_Valor	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_VALOR" } )
Local nPC5_CHVBPAG	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_CHVBPAG" } )
Local nPA1_Inscr	:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_INSCR" } )
Local nRecSF2Sfw	:= 0
Local nRecSF2Hrd	:= 0
Local cNotaSfw		:= ""
Local cNotaHrd		:= ""
Local nI,nJ
Local aRetTraPMSP	:= {}
Local aRetEspPMSP	:= {}
Local aRetTrans		:= {}
Local aRetEspelho	:= {}
Local nTime			:= 0
Local cRandom		:= ""
Local cQuery		:= ""
Local nErroSC9		:= 0
Local Tempini
Local Tempfim
Local TempTot
Default aParcsSE1	:= {}


Tempini := TIME()
conout("------- [GARA110] INICIO DO PROCESSAMENTO DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+Tempini+"]")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a integridade e consiste o campo TIPO DE MOVIMENTO    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nPC5_CHVBPAG == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000028" )
	Aadd( aRet, "9999999999" )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Empty(aDadosSC5[nPC5_CHVBPAG][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000029" )
	Aadd( aRet, "9999999999" )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif
/*
If Len(AllTrim(aDadosSC5[nPC5_CHVBPAG][2])) < 6
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000158" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif
*/

If nPC5_TipMov == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000001" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Empty(aDadosSC5[nPC5_TipMov][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000002" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If nPE1_TipMov == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000003" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Empty(aDadosSE1[nPE1_TipMov][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000004" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If aDadosSC5[nPC5_TipMov][2] <> aDadosSE1[nPE1_TipMov][2]
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000005" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a integridade e consiste o campo CNPJ                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPA1_Cgc == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000006" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Empty(aDadosSA1[nPA1_Cgc][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000007" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If nPA1_Inscr == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000150" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If nPC5_Cnpj == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000008" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Empty(aDadosSC5[nPC5_Cnpj][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000009" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If nPE1_Cnpj == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000010" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Empty(aDadosSE1[nPE1_Cnpj][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000011" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If (aDadosSA1[nPA1_Cgc][2] <> aDadosSE1[nPE1_Cnpj][2]) .OR. (aDadosSA1[nPA1_Cgc][2] <> aDadosSC5[nPC5_Cnpj][2]) .OR. (aDadosSE1[nPE1_Cnpj][2] <> aDadosSC5[nPC5_Cnpj][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000012" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a integridade e consiste o campo VALOR TOTAL do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPC5_TotPed == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000013" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Empty(aDadosSC5[nPC5_TotPed][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000014" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If nPE1_Valor == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000015" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Empty(aDadosSE1[nPE1_Valor][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000016" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	U_AddProcStat("P",aRet)
	Return 
Endif

If Len(aParcsSE1) == 0
	If aDadosSE1[nPE1_Valor][2] <> aDadosSC5[nPC5_TotPed][2]
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000017" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, "" )
		U_AddProcStat("P",aRet)
		Return 
	Endif
Else
	// Verifica a estrutura do array das parcelas do SE1 que deve estar igua ao array do titulo principal
	For nI := 1 To Len(aParcsSE1)
		aAuxSE1 := {}
		aAuxSE1 := Aclone(aParcsSE1)
		If Len(aAuxSE1) <> Len(aDadosSE1)
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000018" )
			Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
			Aadd( aRet, "" )
			U_AddProcStat("P",aRet)
			Return 
		Endif
		For nJ := 1 To Len(aAuxSE1)
			If Len(aAuxSE1[nJ]) <> Len(aDadosSE1[nJ])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000019" )
				Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
				Aadd( aRet, "" )
				U_AddProcStat("P",aRet)
				Return 
			Endif
			If aAuxSE1[nJ][1] $ "E1_TIPMOV,E1_EMISSAO,E1_VENCTO,E1_VALOR,E1_HIST,E1_ADM"
				If aAuxSE1[nJ][1] <> aDadosSE1[nJ][1]
					aRet := {}
					Aadd( aRet, .F. )
					Aadd( aRet, "000020" )
					Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
					Aadd( aRet, "" )
					U_AddProcStat("P",aRet)	
					Return 
				Endif
			Else
				If aAuxSE1[nJ][1] <> aDadosSE1[nJ][1] .OR. aAuxSE1[nJ][2] <> aDadosSE1[nJ][2]
					aRet := {}
					Aadd( aRet, .F. )
					Aadd( aRet, "000021" )
					Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
					Aadd( aRet, "" )
					U_AddProcStat("P",aRet)
					Return 
				Endif
			Endif
			
			If AllTrim(aAuxSE1[nJ][1]) == "E1_VALOR"
				nTotalSE1 += aAuxSE1[nJ][2]
			Endif
			
		Next nJ
	Next nI
	If nTotalSE1 <> aDadosSC5[nPC5_TotPed][2]
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000022" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, "" )
		U_AddProcStat("P",aRet)
		Return 
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico as regras para os campos condicionais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRet := {}
aRet := U_GARCondic("A1_PFISICA", aDadosSA1, aDadosSC5[nPC5_CHVBPAG][2])
If !aRet[1]
	U_AddProcStat("P",aRet)
	Return 
Endif

aRet := {}
aRet := U_GARCondic("E1_ADM", aDadosSE1, aDadosSC5[nPC5_CHVBPAG][2])
If !aRet[1]
	U_AddProcStat("P",aRet)
	Return 
Endif

aRet := {}
aRet := U_GARCondic("E1_PORTADO", aDadosSE1, aDadosSC5[nPC5_CHVBPAG][2])
If !aRet[1]
	U_AddProcStat("P",aRet)
	Return 
Endif

aRet := {}
aRet := U_GARCondic("C5_TIPVOU", aDadosSC5, aDadosSC5[nPC5_CHVBPAG][2])
If !aRet[1]
	U_AddProcStat("P",aRet)
	Return 
Endif

aRet := {}
aRet := U_GARCondic("C5_CODVOU", aDadosSC5, aDadosSC5[nPC5_CHVBPAG][2])
If !aRet[1]
	U_AddProcStat("P",aRet)
	Return 
Endif

aRet := {}
aRet := U_GARCondic("C5_MOTVOU", aDadosSC5, aDadosSC5[nPC5_CHVBPAG][2])
If !aRet[1]
	U_AddProcStat("P",aRet)
	Return 
Endif
aRet := {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agora comeca a executar as rotinas de inclusão dos dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRet := {}
conout("------- [GARA110] INICIO DA VALIDACAO CLIENTE DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
aRet := GAR110Cli(aDadosSA1,aDadosSC5[nPC5_CHVBPAG][2])
conout("------- [GARA110] FIM DA VALIDACAO CLIENTE NF FUTURA DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
//If InTransact()
//	// Esqueceram transacao aberta ... Fecha fazendo commit ... 
//	Conout("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***")
//	EndTran()
//Endif
If !aRet[1]
	U_AddProcStat("P",aRet)
	Return 
Endif

aRet := {}
conout("-------  [GARA110] INICIO DA INCLUSAO DO PV DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
aRet := GAR110Ped(aDadosSC5, aDadosSC6, aDadosSE1)
conout("-------  [GARA110] FIM DA INCLUSAO DO PV DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
If !aRet[1] .or. aRet[2] == "000030"
	U_AddProcStat("P",aRet)
	Return 
Endif

// ESTA PARTE FOI RETIRADA DO FONTE PARA PARAR DE GERAR TITULO DO TIPO RA
// A PARTIR DESTA ALTERACAO O SISTEMA VAI DEIXAR O TITULO GERADO PELA NOTA EM ABERTO
// ESTE TITULO SERAH BAIXADO POSTERIORMENTE PELO PROCESSAMENTO DO CNAB
// ISTO FOI SOLICITADO PELO EDSON E REUNIAO DE START DO PROCESSO EM 18/06/2010 DE MANHA + BIANCA
/*
aRet := {}
Do Case
	Case aDadosSC5[nPC5_TipMov][2] $ "1,3,4,5"			// 1=Boleto;3=Cartao Debito;4=DA;5=DDA
		aRet := {}
		aRet := GAR110Fin(aDadosSE1)
		If !aRet[1]
			U_AddProcStat("P",aRet)
			Return 
		Endif
		
	Case aDadosSC5[nPC5_TipMov][2] $ "6"					// 6=Voucher
		nPC5_TIPVOU := Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_TIPVOU" } )
		If nPC5_TIPVOU > 0 .AND. aDadosSC5[nPC5_TIPVOU][2] <> "1"		// 1=Corporativo;2=Sup. Garantia;3=SAC Substituicao;4=Cortesia;5=Funcionário;6=Teste
			aRet := {}
			aRet := GAR110Fin(aDadosSE1)
			If !aRet[1]
				U_AddProcStat("P",aRet)
				Return 
			Endif
			If Len(aParcsSE1) > 0
				For nI := 1 To Len(aDadosSE1)
					aAuxSE1 := {}
					aAuxSE1 := Aclone( aParcsSE1[nI] )
					aRet := {}
					aRet := GAR110Fin(aAuxSE1)
					If !aRet[1]
						U_AddProcStat("P",aRet)
						Return 
					Endif
				Next nI
			Endif
		Endif
		
	Case aDadosSC5[nPC5_TipMov][2] $ "2"					// 2=Cartao de Credito

		// Continua o processo, normal !  
		
	OtherWise
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000024" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, "" )
		U_AddProcStat("P",aRet)
		Return 
		
Endcase
*/




// -------------------------------------------------------------
// Seta retorno intermediario de processamento de Pedido OK 
// -------------------------------------------------------------
aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000023" ) // "Inclusão efetuada com sucesso..."
Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
Aadd( aRet, "" )
U_AddProcStat("P",aRet)
// -------------------------------------------------------------

// Etapa 02 : Geracao da Nota Prefeitura e/ou nota futura

conout("------- [GARA110] INICIO DO FATURAMENTO DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
// Reposiciona o pedido de vendas antes de realizar a liberacao para garantir que o pedido estah correto

//SC5->( DbSetOrder(5) )		// C5_FILIAL + C5_CHVBPAG
SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
SC5->( !DbSeek( xFilial("SC5")+aDadosSC5[nPC5_CHVBPAG][2] ) )

aRet := {}
aRet := GAR110Lib()
If !aRet[1]
	U_AddProcStat("F",aRet)
	Return
Endif

// Reposiciona o pedido de vendas antes de realizar o faturamento para garantir que o pedido estah correto

//SC5->( DbSetOrder(5) )		// C5_FILIAL + C5_CHVBPAG
SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada

SC5->( DbSeek( xFilial("SC5")+aDadosSC5[nPC5_CHVBPAG][2] ) )

aRet := {}

aRet := GAR110Fat(@nRecSF2Sfw, @nRecSF2Hrd)

conout("------- [GARA110] FIM DO FATURAMENTO DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")

If !aRet[1]
//	conout("Retorno Falso Geracao Nota")
	U_AddProcStat("F",aRet)
	Return
Endif

// Reposiciona o pedido de vendas para garantir que estamos falando do mesmo pedido

//SC5->( DbSetOrder(5) )		// C5_FILIAL + C5_CHVBPAG
SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada

SC5->( DbSeek( xFilial("SC5")+aDadosSC5[nPC5_CHVBPAG][2] ) )

// Verifica se o pedido foi TOTALMENTE faturado, pois estah ficando pedido liberado e sem ser faturado
// isso acontece e nao estah sendo gerado nenhum LOG de erro, o pedido se perde no tempo e no espaco...
cQuery	:=	" SELECT  COUNT(*) QTDSC9 " +;
			" FROM    " + RetSQLName("SC9") +;
			" WHERE   C9_FILIAL = '" + xFilial("SC9") + "' AND " +;
			"         C9_PEDIDO = '" + SC5->C5_NUM + "' AND " +;
			"         C9_NFISCAL = ' ' AND " +;
			"         C9_SERIENF = ' ' AND " +;
			"         D_E_L_E_T_ = ' ' "
PLSQuery( cQuery, "SC9TMP" )
nErroSC9 := SC9TMP->QTDSC9
SC9TMP->( DbCloseArea() )

// Se por um acaso o pedido naum foi totalmente faturado, eu estorno ele todo e devolvo uma mensagem de erro
If nErroSC9 > 0
	If !RollBackGAR()
		UserException("Pedido GAR com erro no faturamento."+CRLF+"Tentativa de RollBackGAR sem sucesso.")
	Endif
	
	U_ResetStat()
	
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000159" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "Casos de pedido que ficou sem faturar e perdeu o rastreamento." )
	
	U_AddProcStat("P",aRet)
	U_AddProcStat("F",aRet)
	
	Return 
Endif

// ESTA PARTE DE TRATAMETNO DO FINANCEIRO SERVE APENAS PARA COMPENSAR O TITULO NA NOTA COM O TITULO RA
// COMO AGORA NAUM GERA MAIS RA ENTAO NAO TEM NADA PRA COMPENSAR
/*
aRet := {}
aRet := GAR110Fin()
If !aRet[1]
	U_AddProcStat("F",aRet)
	Return
Endif
*/

If nRecSF2Sfw > 0

	// Se chegou uma nota de serviço executa a transmissao para a PMSP
	
	SF2->( DbGoto(nRecSF2Sfw) )
	
	// A Totvs nao disponibilizou a transmição da RPS para a prefeitura via WEBSERVICES.
	// Esta funcao sempre vai retornar TRUE ateh que a funcao da tranmissão seja criada
	conout("------- [GARA110] INICIO DA TRANSMISSAO SFW DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	aRetTraPMSP := U_TransPMSP(SF2->F2_DOC,SF2->F2_SERIE,aDadosSC5[nPC5_CHVBPAG][2])
	conout("------- [GARA110] FIM DA TRANSMISSAO SFW DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")

	If !aRetTraPMSP[1]
		// Se nao transmitiu, envio para o JOB de retransmissao
		conout("------- [GARA110] INICIO DA RETRANSMISSAO SFW DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		U_RetranPMSP(aRetTraPMSP,SF2->F2_DOC,SF2->F2_SERIE,aDadosSC5[nPC5_CHVBPAG][2])                   
		conout("------- [GARA110] FIM DA RETRANSMISSAO SFW DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	Endif

	// Gera o arquivo espelho da nota de servico 
	conout("------- [GARA110] INICIO DO ESPELHO SFW DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	aRetEspPMSP := U_GARR020(aRetTraPMSP,.T.)
	conout("------- [GARA110] FIM DO ESPELHO SFW DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	
	If aRetEspPMSP[1]
		// Se o espelho foi gerado, recupera URI do espelho
		cNotaSfw := aRetEspPMSP[4]
	Endif

Endif

If nRecSF2Hrd > 0
	
	// Se chegou nota de hardware, transmite e gera espelho tb

	SF2->( DbGoto(nRecSF2Hrd) )
	
	// Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
	conout("------- [GARA110] INICIO DA TRANSMISSAO HRD DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,aDadosSC5[nPC5_CHVBPAG][2])              
	conout("------- [GARA110] FIM DA TRANSMISSAO HRD DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		
	// 000132 - Codigo referente a dados com erro, naum adiante tentar retransmitir.
	// os demais codigos sao referentes a falhas na comunicacao.
	If !aRetTrans[1]
		
		// Se nao transmitiu, envio para o JOB de retransmissao
		conout("------- [GARA110] INICIO DA RETRANSMISSAO HRD DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		U_RetranNFE(aRetTrans,SF2->F2_DOC,SF2->F2_SERIE,aDadosSC5[nPC5_CHVBPAG][2])
		conout("------- [GARA110] FIM DA RETRANSMISSAO HRD DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		
	Endif
	
	// TESTE - REMOVER DEPOIS... 
	// Espera um minuto
	// WaitTime(60)
	// TESTE - REMOVER DEPOIS... 
	
	nTime := Seconds()
//	Mystatus("ESPELHO -- Iniciando ...")
	
	While .T.
		conout("------- [GARA110] INICIO DO ESPELHO HRD DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
		// Gera o arquivo espelho da nota fiscal 
		SF2->( DbGoto(nRecSF2Hrd) )
		
		SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
		SC6->( DbSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
		
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		SC5->( DbSeek( xFilial("SC5")+SC6->C6_NUM ) )
		

		If aRetTrans[2] == "000169"
			lDeneg := .T.			
			U_NFDENG02()

			aRetEspelho := U_NFDENG03(aRetTrans,@cRandom)
			
		else
			lDeneg := .F.				 
			aRetEspelho := U_GARR010(aRetTrans,@cRandom)
		EndIf
		conout("------- [GARA110] FIM DO ESPELHO HRD DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		
		If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
			
			If aRetTrans[1] .AND. (!SF2->F2_FIMP $ "D")
				SF2->( DbGoto(nRecSF2Hrd) )
				SF2->( RecLock("SF2",.F.) )
				If lDeneg
					SF2->F2_FIMP := "D"
				Else
					SF2->F2_FIMP := "S"
				EndIf
				SF2->( MsUnLock() )
			EndIf
			
			// Enviou / Gerou certinho ? Pode sair 
		//	Mystatus("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
			Exit
		Else
		//	Mystatus("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
		Endif
		
		If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
			// Ocorrencia 000134, pode sair 
			// ( Impressao fora de job , uso com remote por exemplo ) 
		//	Mystatus("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
			Exit
		Endif
		
		If !aRetTrans[1]
			// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
		//	Mystatus("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
			Exit
		Endif
		
		// Verifica quanto tempo esta tentando enviar ... 
		// Se passou da 00:00, recalcula tempo 
		nWait := Seconds()-nTime
		If nWait < 0 
			nWait += 86400
		Endif

		If nWait > GetNewPar("MV_TIMESP", 120 )
			// Passou de 2 minutos tentando ? Desiste ! 
			conout("------- [GARA110] SAIU DA TENTATIVA DE ENVIANDO O ESPELHO HRD DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
		//	Mystatus("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
			EXIT
		Endif

		// Espera um pouco ( 5 segundos ) para tentar novamente
		
		conout("-------[GARA110] AGUARDANDO 5 SEGUNDOS DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
		Sleep(5000)
		conout("-------[GARA110] PASSOU OS 5 SEGUNDOS DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
	//	Mystatus("ESPELHO -- dormindo 5 segundos... zzzzz...  : "+str(Seconds()-nTime))
		
	EndDo
//	Mystatus("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))
	
	If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
		// Se gerou espelho, recupera URI do espelho 
		cNotaHrd := aRetEspelho[4]
	Endif	
	
Endif

// Agora monta o retorno baseado nos status de processamento 
aRet := {}

// Esta tudo certo, retorna OK + as URIs ...
Aadd( aRet, .T. )
Aadd( aRet, "000096" ) // NFS gerada com sucesso...
Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )

// Monta string com as informacoes detalhadas de nota de prefeitura 
cRetInfo := ''

If nRecSF2Sfw > 0
	cRetInfo += IIF(aRetTraPMSP[1],"T","F")+","
	cRetInfo += aRetTraPMSP[2]+","
	cRetInfo += cNotaSfw+","
Else
	cRetInfo += ',,,'
Endif

// agora acrescenta dados da sefaz
If nRecSF2Hrd > 0
	cRetInfo += IIF(aRetTrans[1].AND.aRetEspelho[1],"T","F")+","
	cRetInfo += IIF(!aRetTrans[1],aRetTrans[2],aRetEspelho[2])+","
	cRetInfo += cNotaHrd+","
Else
	//cRetInfo += ',,,'
	cRetInfo += ',,,'
Endif

// Acrescenta a linguica de retorno no 4. elemento
Aadd( aRet, cRetInfo )

// Retorno de processamento de nota futura 
U_AddProcStat("F",aRet)
                                                             
Tempfim := TIME()
TempTot := ELAPTIME(Tempini,Tempfim)
conout("------- [GARA110] FIM DO PROCESSAMENTO DO PEDIDO GAR "+aDadosSC5[nPC5_CHVBPAG][2]+" ------- ["+Dtoc(Date())+"-"+Tempfim+"]-Tempo Total-"+TempTot)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GAR110Cli(aDadosSA1, cPedGar)

Local aAutoSA1		:= {}
Local nI			:= 0
Local nPA1_CGC		:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_CGC" } )
Local nPA1_INSCR	:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_INSCR" } )
Local nPA1_PESSOA	:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_PESSOA" } )
Local nPA1_EST		:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_EST" } )
Local nPA1_COD_MUN	:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_COD_MUN" } )
Local nPA1_MUN		:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_MUN" } )
Local nPA1_NUMERO	:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_NUMERO" } )
Local nPA1_END		:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_END" } )
Local nPA1_CEP		:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_CEP" } )
Local nPA1_BAIRRO	:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_BAIRRO" } )
Local nPA1_PAIS		:= Ascan( aDadosSA1, { |x| AllTrim(x[1])=="A1_PAIS" } )
//Local cCodCli		:= ""
Local aRet			:= {}
Local aAutoErr		:= {}
Local cAutoErr		:= ""
Local cCampo		:= ""
Local cGrpTrib		:= ""

SX3->( DbSetOrder(2) )
For nI := 1 To Len(aDadosSA1)
	If aDadosSA1[nI][1] $ "A1_NUMERO"
		Loop
	Endif
	If Valtype(aDadosSA1[nI][2]) == "C"
		If SX3->( DbSeek( aDadosSA1[nI][1] ) )
			aDadosSA1[nI][2] := PadR(AllTrim(aDadosSA1[nI][2]),SX3->X3_TAMANHO)
		Endif
	Endif
Next nI

If nPA1_CGC == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000025" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_CGC][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000026" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

// Segue a mesma regra da importacao do sistema antigo para manter compatibilidade.
aDadosSA1[nPA1_CGC][2] := CheckCgc(aDadosSA1[nPA1_CGC][2])

If nPA1_PESSOA == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000109" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_PESSOA][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000110" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_EST == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000111" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_EST][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000112" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_COD_MUN == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000113" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_COD_MUN][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000114" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_MUN == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000115" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_MUN][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000116" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_CEP == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000138" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_CEP][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000139" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_BAIRRO == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000140" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_BAIRRO][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000141" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_BAIRRO == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000142" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_BAIRRO][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000143" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_BAIRRO == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000144" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_BAIRRO][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000145" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_END == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000146" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_END][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000147" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPA1_PAIS == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000142" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSA1[nPA1_PAIS][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000143" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If aDadosSA1[nPA1_EST][2] <> "SP" .AND. aDadosSA1[nPA1_COD_MUN][2] == "50308"
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000149" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

PA7->( DbSetOrder(1) )		// PA7_FILIAL + PA7_CODCEP
If PA7->( !DbSeek( xFilial("PA7")+aDadosSA1[nPA1_CEP][2] ) )
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000151" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If aDadosSA1[nPA1_COD_MUN][2] <> PA7->PA7_CODMUN
	aDadosSA1[nPA1_COD_MUN][2] := PA7->PA7_CODMUN
Endif

CC2->( DbSetOrder(1) )		// CC2_FILIAL+CC2_EST+CC2_CODMUN
//If CC2->( DbSeek( xFilial("CC2")+aDadosSA1[nPA1_EST][2]+aDadosSA1[nPA1_COD_MUN][2] ) )
If CC2->( DbSeek( xFilial("CC2")+PA7->PA7_ESTADO+PA7->PA7_CODMUN ) )
	aDadosSA1[nPA1_MUN][2] := CC2->CC2_MUN
Else
	CC2->( RecLock("CC2",.T.) )
	CC2->CC2_FILIAL	:= xFilial("CC2")
	CC2->CC2_EST	:= PA7->PA7_ESTADO
	CC2->CC2_CODMUN	:= PA7->PA7_CODMUN
	CC2->CC2_MUN	:= PA7->PA7_MUNIC
	CC2->( MsUnLock() )
	aDadosSA1[nPA1_MUN][2] := CC2->CC2_MUN
Endif

/*
// Elimina as duplicidades do cadastro de CEP para evitar erro de inclusao do MSExecAuto()
PA7->( DbSetOrder(1) )		// PA7_FILIAL + PA7_CODCEP
If PA7->( DbSeek( xFilial("PA7")+aDadosSA1[nPA1_CEP][2] ) )
	PA7->( DbSkip() )
Endif
While	PA7->( !Eof() ) .AND.;
		PA7->PA7_FILIAL == xFilial("PA7") .AND.;
		PA7->PA7_CODCEP == aDadosSA1[nPA1_CEP][2]
	PA7->( RecLock("PA7",.F.) )
	PA7->( DbDelete() )
	PA7->( MsUnLock() )
	PA7->( DbSkip() )
End

PA7->( DbSetOrder(1) )		// PA7_FILIAL + PA7_CODCEP
If PA7->( DbSeek( xFilial("PA7")+aDadosSA1[nPA1_CEP][2] ) )
	PA7->( RecLock("PA7",.F.) )
Else
	PA7->( RecLock("PA7",.T.) )
	PA7->PA7_FILIAL	:= xFilial("PA7")
	PA7->PA7_CODCEP	:= aDadosSA1[nPA1_CEP][2]
Endif

PA7->PA7_LOGRA	:= aDadosSA1[nPA1_END][2]
PA7->PA7_BAIRRO	:= aDadosSA1[nPA1_BAIRRO][2]
PA7->PA7_MUNIC	:= aDadosSA1[nPA1_MUN][2]
PA7->PA7_ESTADO	:= aDadosSA1[nPA1_EST][2]
PA7->PA7_CODPAI	:= aDadosSA1[nPA1_PAIS][2]
PA7->PA7_CODMUN	:= aDadosSA1[nPA1_COD_MUN][2]

PA7->( MsUnLock() )
*/

// Tratamento para o grupo de tributacao para o cliente
Do Case
	Case aDadosSA1[nPA1_EST][2] == "SP"
		cGrpTrib := "001"
		
	Case !Empty(aDadosSA1[nPA1_EST][2]) .AND. aDadosSA1[nPA1_EST][2] <> "SP" .AND. aDadosSA1[nPA1_PESSOA][2] == "F" .AND. ( Empty(aDadosSA1[nPA1_INSCR][2]) .OR. Upper(AllTrim(aDadosSA1[nPA1_INSCR][2])) == "ISENTO" )
		cGrpTrib := "002"
		
	Case !Empty(aDadosSA1[nPA1_EST][2]) .AND. aDadosSA1[nPA1_EST][2] <> "SP" .AND. aDadosSA1[nPA1_PESSOA][2] == "F" .AND. !Empty(aDadosSA1[nPA1_INSCR][2]) .AND. Upper(AllTrim(aDadosSA1[nPA1_INSCR][2])) <> "ISENTO"
		cGrpTrib := "003"
		
	Case !Empty(aDadosSA1[nPA1_EST][2]) .AND. aDadosSA1[nPA1_EST][2] <> "SP" .AND. aDadosSA1[nPA1_PESSOA][2] == "J" .AND. ( Empty(aDadosSA1[nPA1_INSCR][2]) .OR. Upper(AllTrim(aDadosSA1[nPA1_INSCR][2])) == "ISENTO" )
		cGrpTrib := "002"
		
	Case !Empty(aDadosSA1[nPA1_EST][2]) .AND. aDadosSA1[nPA1_EST][2] <> "SP" .AND. aDadosSA1[nPA1_PESSOA][2] == "J" .AND. !Empty(aDadosSA1[nPA1_INSCR][2]) .AND. Upper(AllTrim(aDadosSA1[nPA1_INSCR][2])) <> "ISENTO"
		cGrpTrib := "003"
		
	Otherwise
		cGrpTrib := "999"
	
Endcase


Private lMsErroAuto		:= .F.	// variavel interna da rotina automatica MSExecAuto()
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()

SA1->( DbSetOrder(3) )		// A1_FILIAL+A1_CGC
If SA1->( DbSeek( xFilial("SA1")+aDadosSA1[nPA1_CGC][2] ) )
	
	If !U_GarCliLock(SA1->A1_COD)
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000157" )
		Aadd( aRet, cPedGar )
		Aadd( aRet, "" )
		Return(aRet)
	Endif
	
	lNovo := .F.
	SA1->( RecLock("SA1",.F.) )
	SA1->A1_MSBLQL := "2"
	SA1->( MsUnLock() )
Else
	lNovo := .T.
//	cCodCli := GetSXENum("SA1", "A1_COD")
//	ConfirmSX8()
Endif

If lNovo
	Aadd(aAutoSA1, {"A1_FILIAL",	xFilial("SA1"),		NIL} )
//	Aadd(aAutoSA1, {"A1_COD",		cCodCli,			NIL} )
	Aadd(aAutoSA1, {"A1_LOJA",		"01",				NIL} )
Endif

Aadd(aAutoSA1, {"A1_CONTA",		GetNewPar("MV_XCTACON", "110301001"),	NIL} )
Aadd(aAutoSA1, {"A1_NATUREZ",	GetNewPar("MV_XNATCLI", "FT010010"),	NIL} )
Aadd(aAutoSA1, {"A1_RISCO",		"A",									NIL} )
Aadd(aAutoSA1, {"A1_LC",		999999999.99,							NIL} )
Aadd(aAutoSA1, {"A1_CLASSE",	"A",									NIL} )
Aadd(aAutoSA1, {"A1_LCFIN",		999999999.99,							NIL} )
Aadd(aAutoSA1, {"A1_MOEDALC",	1,										NIL} )
Aadd(aAutoSA1, {"A1_VENCLC",	CtoD("31/12/2030"),						NIL} )
Aadd(aAutoSA1, {"A1_GRPTRIB",	cGrpTrib,								NIL} )
Aadd(aAutoSA1, {"A1_STATVEN",	"1",									NIL} )
If aDadosSA1[nPA1_PESSOA][2] == "J"
	Aadd(aAutoSA1, {"A1_ALIQIR",	1.5,									NIL} )
	Aadd(aAutoSA1, {"A1_RECIRRF",	"1",									NIL} )
Endif

// Caso os campo opcionais venha em branco, o sistema assume o valor defult
If Ascan(aAutoSA1, { |x| AllTrim(x[1])=="A1_RECISS" } ) == 0
	Aadd(aAutoSA1, {"A1_RECISS",	"2",	NIL} )		//	C	1		Recolhe ISS
Endif
If Ascan(aAutoSA1, { |x| AllTrim(x[1])=="A1_SUFRAMA" } ) == 0
	Aadd(aAutoSA1, {"A1_SUFRAMA",	"",		NIL} )		//	C	12		SUFRAMA
Endif
If Ascan(aAutoSA1, { |x| AllTrim(x[1])=="A1_INCISS" } ) == 0
	Aadd(aAutoSA1, {"A1_INCISS",	"S",	NIL} )		//	C	1		ISS no Preco
Endif
If Ascan(aAutoSA1, { |x| AllTrim(x[1])=="A1_ALIQIR" } ) == 0
	Aadd(aAutoSA1, {"A1_ALIQIR",	0,		NIL} )		//	N	5	2	Aliq. IRRF
Endif
If Ascan(aAutoSA1, { |x| AllTrim(x[1])=="A1_RECINSS" } ) == 0
	Aadd(aAutoSA1, {"A1_RECINSS",	"N",	NIL} )		//	C	1		Rec. INSS
Endif
If Ascan(aAutoSA1, { |x| AllTrim(x[1])=="A1_RECCOFI" } ) == 0
	Aadd(aAutoSA1, {"A1_RECCOFI",	"N",	NIL} )		//	C	1		Rec.COFINS
Endif
If Ascan(aAutoSA1, { |x| AllTrim(x[1])=="A1_RECCSLL" } ) == 0
	Aadd(aAutoSA1, {"A1_RECCSLL",	"N",	NIL} )		//	C	1		Rec. CSLL
Endif
If Ascan(aAutoSA1, { |x| AllTrim(x[1])=="A1_RECPIS" } ) == 0
	Aadd(aAutoSA1, {"A1_RECPIS",	"N",	NIL} )		//	C	1		Rec. PIS
Endif

If lNovo
	Aadd(aAutoSA1, {"A1_OBSERV",	"FONTE: " + ProcName( 1 ) + " - INCLUIDO EM "+DtoC(Date())+" AS "+Time(),	NIL} )
Else
	Aadd(aAutoSA1, {"A1_OBSERV",	"FONTE: " + ProcName( 1 ) + " - ALTERADO EM "+DtoC(Date())+" AS "+Time(),	NIL} )
Endif

Aadd( aAutoSA1, { "A1_CEP", Alltrim(aDadosSA1[nPA1_CEP][2]), NIL } )

For nI := 1 To Len(aDadosSA1)
	
	// Nao grava nunca
	If PadR(aDadosSA1[nI][1],10) $	"A1_DDI    ,A1_TELEX  ,A1_NUMERO ,A1_CEP    "
		Loop
	Endif
	
	// Nao grava se for alteracao
//	If !lNovo .AND. AllTrim(aDadosSA1[nI][1]) $	"A1_PESSOA,A1_TIPO,A1_CGC,A1_INSCRM,A1_PFISICA,A1_RECISS,A1_SUFRAMA" +;
//													"A1_INCISS,A1_ALIQIR,A1_RG,A1_RECINSS,A1_RECCOFI,A1_RECCSLLA1_RECPIS"
//		Loop
//	Endif
	
	If Ascan( aAutoSA1, { |x| AllTrim(x[1])==AllTrim(aDadosSA1[nI][1]) } ) == 0
		If AllTrim(aDadosSA1[nI][1]) == "A1_END"
			// Junta o numero com o endereco
			Aadd( aAutoSA1, { aDadosSA1[nI][1], AllTrim(aDadosSA1[nI][2])+ ", "+Alltrim(aDadosSA1[nPA1_NUMERO][2]), NIL } )
		Else
			Aadd( aAutoSA1, { aDadosSA1[nI][1], aDadosSA1[nI][2], NIL } )
		Endif
	Endif
Next

aRet := {}
aRet := U_GARX3OK("SA1",aAutoSA1,cPedGar)
If !aRet[1]
	Return(aRet)
Endif
aRet := {}

If lNovo
	MSExecAuto({|x, y| MATA030(x, y)}, aAutoSA1, 3)
	If lMsErroAuto
		cAutoErr := "SA1 --> Erro de inclusão de clientes na rotina padrão do sistema Protheus MSExecAuto({|x, y| MATA030(x, y)}, aAutoSA1, 3)" + CRLF + CRLF
		aAutoErr := GetAutoGRLog()
		For nI := 1 To Len(aAutoErr)
			cAutoErr += aAutoErr[nI] + CRLF
		Next nI
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000027" )
		Aadd( aRet, cPedGar )
		Aadd( aRet, cAutoErr )
		Return(aRet)
	Else
		SA1->( RecLock("SA1",.F.) )
		For nI := 1 To Len(aAutoSA1)
			cCampo := aAutoSA1[nI][1]
			&("SA1->"+cCampo) := aAutoSA1[nI][2]
		Next nI
		SA1->( MsUnLock() )
	Endif
Else
	
	SA1->( RecLock("SA1",.F.) )
	For nI := 1 To Len(aAutoSA1)
		cCampo := aAutoSA1[nI][1]
		&("SA1->"+cCampo) := aAutoSA1[nI][2]
	Next nI
	SA1->( MsUnLock() )
	
	U_GarCliUnLock(SA1->A1_COD)
	
Endif

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000023" )
Aadd( aRet, cPedGar )
Aadd( aRet, "" )

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GAR110Ped(aDadosSC5, aDadosSC6, aDadosSE1)

Local aAutoSC5		:= {}
Local aAutoSC6		:= {}	// Recebe todos os itens para o MSExecAuto
Local aSC6Item		:= {}	// Recebe item a item do SC6 enviado pela WS
Local aAuxSC6		:= {}	// Recebe item a item do SC6 que sera agrupado no aAutoSC6
Local nI			:= 0
Local nJ			:= 0
Local nPC5_CHVBPAG	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_CHVBPAG" } )
Local nPC5_TOTPED	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_TOTPED" } )
Local nPC5_TIPMOV	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_TIPMOV" } )
Local nPC5_TIPVOU	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_TIPVOU" } )
Local nPC5_CNPJ		:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_CNPJ" } )
Local nPC5_CONDPAG	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_CONDPAG" } )
Local nPC5_MENNOTA	:= Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_MENNOTA" } )
Local nPC5_VEND1	:= 0
Local nPC6_PROGAR	:= 0
Local nPC6_QTDVEN	:= 0
Local nPC6_VALOR	:= 0
Local nTCalcPed		:= 0
Local aProdutos		:= {}
Local nPE1_VALOR	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_VALOR" } )
Local nPE1_ADM		:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_ADM" } )
Local aRet			:= {}
Local aAutoErr		:= {}
Local cAutoErr		:= ""
Local nPrv1			:= 0
Local nValor		:= 0
Local nQtdVen		:= 0
Local nValDif		:= 0
Local cItem			:= ""
Local cTes			:= ""
Local cTesSv		:= "903" 		// Tes de Servico
Local cTesMr		:= "502" 		// Tes de Mercadoria
Local cCategoSFW	:= "('" + StrTran(GetNewPar("MV_GARSFT", "2"),",","','") + "')"
Local cCategoHRD	:= "('" + StrTran(GetNewPar("MV_GARHRD", "1"),",","','") + "')"
Local cCF			:= ""
Local cQuery		:= ""
Local aStruSC6		:= SC6->( DbStruct() )
Local aDados		:= {}
Local cCampo		:= ""
Local cItemSC6		:= ""
Local nK			:= 0
Local nValor		:= 0
Local cAdm			:= ""
Local cPedBpag	:= ""
Local nQtdVen		:= 0
Local cProGar		:= ""
Local lCombo		:= .F.
Local cFilOld 	:= cFilAnt
Local cAtivCbo		:= Alltrim(GetNewPar("MV_XCBOAT", "0"))

Private	aHeader		:= {}

Aadd( aHeader, {"","C6_TES"} )

SX3->( DbSetOrder(2) )
For nI := 1 To Len(aDadosSC5)
	If Valtype(aDadosSC5[nI][2]) == "C"
		If SX3->( DbSeek( aDadosSC5[nI][1] ) )
			aDadosSC5[nI][2] := PadR(AllTrim(aDadosSC5[nI][2]),SX3->X3_TAMANHO)
		Endif
	Endif
Next nI


For nI := 1 To Len(aDadosSC6)
	If Valtype(aDadosSC6[nI][2]) == "C"
		If SX3->( DbSeek( aDadosSC6[nI][1] ) )
			aDadosSC6[nI][2] := PadR(AllTrim(aDadosSC6[nI][2]),SX3->X3_TAMANHO)
		Endif
	Endif
Next nI

For nI := 1 To Len(aDadosSE1)
	If Valtype(aDadosSE1[nI][2]) == "C"
		If SX3->( DbSeek( aDadosSE1[nI][1] ) )
			aDadosSE1[nI][2] := PadR(AllTrim(aDadosSE1[nI][2]),SX3->X3_TAMANHO)
		Endif
	Endif
Next nI

If nPC5_CHVBPAG == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000028" )
	Aadd( aRet, "9999999999" )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSC5[nPC5_CHVBPAG][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000029" )
	Aadd( aRet, "9999999999" )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPC5_CNPJ == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000008" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSC5[nPC5_CNPJ][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000009" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPC5_CONDPAG == 0
	Aadd( aDadosSC5, "C5_CONDPAG", "000" )
Else
	If aDadosSC5[nPC5_TIPMOV][2] == "2"
		cQuery := "SELECT E4_CODIGO FROM " + RetSqlName("SE4") + " WHERE E4_PGBPAG = " + aDadosSC5[nPC5_CONDPAG][2]
		PLSQuery( cQuery, "SE4TMP" )
		If SE4TMP->( !Eof() )
			aDadosSC5[nPC5_CONDPAG][2] := SE4TMP->E4_CODIGO
		Else
			aDadosSC5[nPC5_CONDPAG][2] := "000"
		Endif
		SE4TMP->( DbCloseArea() )
	Else
		aDadosSC5[nPC5_CONDPAG][2] := "000"
	Endif
Endif

If nPC5_MENNOTA == 0
	Aadd( aDadosSC5, { "C5_MENNOTA", "" } )
	nPC5_MENNOTA := Ascan( aDadosSC5, { |x| AllTrim(x[1])=="C5_MENNOTA" } )
Endif

If Empty(aDadosSC5[nPC5_MENNOTA][2])
	nValor	:= IIF(nPE1_VALOR>0,aDadosSE1[nPE1_VALOR][2],0)
	cAdm	:= IIF(nPE1_ADM>0,aDadosSE1[nPE1_ADM][2],"")
	cPedBpag:= IIF(nPC5_CHVBPAG>0,aDadosSC5[nPC5_CHVBPAG][2],"")
	nQtdVen	:= 1
	If Len(aDadosSC6) > 0
		aSC6Item := Aclone(aDadosSC6[1])
		nPC6_PROGAR	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_PROGAR" } )
	Endif
	cProGar	:= IIF(nPC6_PROGAR>0,aSC6Item[nPC6_PROGAR][2],"")
	
	aDadosSC5[nPC5_MENNOTA][2] := MakeMens(cProGar,nQtdVen,nValor,cAdm,cPedBpag)
Endif

aDadosSC5[nPC5_MENNOTA][2] := "NF EMITIDA NOS TERMOS DO ARTIGO 129 DO RICMS 00 " + AllTrim(aDadosSC5[nPC5_MENNOTA][2])

// Segue a mesma regra da importacao do sistema antigo para manter compatibilidade.
aDadosSC5[nPC5_CNPJ][2] := CheckCgc(aDadosSC5[nPC5_CNPJ][2])

//SC5->( DbSetOrder(5) )		// C5_FILIAL+C5_CHVBPAG
SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
If SC5->( DbSeek( xFilial("SC5")+aDadosSC5[nPC5_CHVBPAG][2] ) )
	aRet := {}
	Aadd( aRet, .T. )
	Aadd( aRet, "000030" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "Ja existe Pedido  de venda para Pedido Gar informado" )
	Return(aRet)
Else
	Private lMsErroAuto		:= .F.	// variavel interna da rotina automatica MSExecAuto()
	Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()
Endif

Aadd(aAutoSC5, {"C5_FILIAL",	xFilial("SC5"),								NIL} )
Aadd(aAutoSC5, {"C5_TIPO",		"N",										NIL} )
Aadd(aAutoSC5, {"C5_CLIENTE",	SA1->A1_COD,								NIL} )
Aadd(aAutoSC5, {"C5_LOJACLI",	SA1->A1_LOJA,								NIL} )
Aadd(aAutoSC5, {"C5_TIPOCLI",	IIF(Empty(SA1->A1_TIPO),"F",SA1->A1_TIPO),	NIL} )
Aadd(aAutoSC5, {"C5_XNATURE",	GetNewPar("MV_XNATCLI", "FT010010"),		NIL} )
Aadd(aAutoSC5, {"C5_VEND1",		"",											NIL} )
Aadd(aAutoSC5, {"C5_MOEDA",		1,											NIL} )
Aadd(aAutoSC5, {"C5_TIPLIB",	"1",										NIL} )
Aadd(aAutoSC5, {"C5_TPCARGA",	"2",										NIL} )
Aadd(aAutoSC5, {"C5_MSBLQL",	"2",										NIL} )
Aadd(aAutoSC5, {"C5_GERAWMS",	"1",										NIL} )
If aDadosSC5[nPC5_TIPMOV][2] == "2"
	Aadd(aAutoSC5, {"C5_XBANDEI",	aDadosSE1[nPE1_ADM][2],					NIL} )
Endif

For nI := 1 To Len(aDadosSC5)
	If Ascan( aAutoSC5, { |x| AllTrim(x[1])==AllTrim(aDadosSC5[nI][1]) } ) == 0
		Aadd( aAutoSC5, { aDadosSC5[nI][1], aDadosSC5[nI][2], NIL } )
	Endif
Next


For nJ := 1 To Len(aDadosSC6)
	aSC6Item := Aclone(aDadosSC6[nJ])

	nPC6_PROGAR	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_PROGAR" } )
	If nPC6_PROGAR == 0
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000031" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, "" )
		Return(aRet)
	Endif
	
	If Empty(aSC6Item[nPC6_PROGAR][2])
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000032" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, "" )
		Return(aRet)
	Endif
	
	nPC6_QTDVEN	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_QTDVEN" } )
	If nPC6_QTDVEN == 0
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000033" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, "" )
		Return(aRet)
	Endif
	
	If Empty(aSC6Item[nPC6_QTDVEN][2])
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000034" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, "" )
		Return(aRet)
	Endif
	
	aProdutos 	:= {}
	lCombo 		:= .F.
	conout("------------SEPARA OS ITENS NO CADASTRO DE COMBO")
	DbSelectArea("SZI")                       

	SZI->( DbSetOrder(3) ) //SZI_FILIAL + SZI_PROGAR
	SZI->( DbGoTop() )
	If 	cAtivCbo == "1"
	 	If SZI->( DbSeek( xFilial("SZI") + alltrim(aSC6Item[nPC6_PROGAR][2])))
		 	While (SZI->ZI_FILIAL+alltrim(SZI->ZI_PROGAR) == xFilial("SZI") + aSC6Item[nPC6_PROGAR][2]) .AND. SZI->(!Eof())
		 		If (aDadosSC5[nPC5_TOTPED][2] == SZI->ZI_PREVEN) .and. SZI->ZI_ATIVO <> '2'
					DbSelectArea("SZJ")
					SZJ->( DbSetOrder(1) )	//SZJ_FILIAL + SZJ_COMBO
					If SZJ->( DbSeek( xFilial("SZJ") + alltrim(SZI->ZI_COMBO)) )
						While SZJ->(!Eof()) .And. SZJ->ZJ_COMBO == SZI->ZI_COMBO
							Aadd( aProdutos, {SZJ->ZJ_CODPROD, SZJ->ZJ_PRETAB} )
							SZJ->(DbSkip())
						End
						lCombo := .T.
						Exit
					EndIf
	        	EndIf
	        	SZI->(DbSkip())
	        End
	    Else
	    	conout("Produto -"+alltrim(aSC6Item[nPC6_PROGAR][2])+"- nao localizado no cadastro de combo.")
	    EndIf
	EndIf
	If !lCombo
		PA8->( DbSetOrder(1) )		// PA8_FILIAL + PA8_CODBPG
		PA8->( DbSeek( xFilial("PA8")+aSC6Item[nPC6_PROGAR][2] ) )
		If PA8->( Found() ) .AND. AllTrim(PA8->PA8_FILIAL+PA8->PA8_CODBPG) == AllTrim(xFilial("PA8")+aSC6Item[nPC6_PROGAR][2])
			SB1->( DbSetOrder(1) )		// B1_FILIAL+B1_COD
			If SB1->( DbSeek( xFilial("SB1")+PA8->PA8_CODMP8 ) )
				If SB1->B1_TIPO == "KT"
					SG1->( DbSetOrder(1) )
					If SG1->( DbSeek( xFilial("SG1")+SB1->B1_COD ) ) .AND. !Empty(SG1->G1_COMP)
						While	SG1->( !Eof() ) .AND.;
								SG1->G1_FILIAL == xFilial("SG1") .AND.;
								SG1->G1_COD == SB1->B1_COD
							If !Empty(SG1->G1_COMP) 
								Aadd( aProdutos, {SG1->G1_COMP, 0} )
							Endif
							
							SG1->( DbSkip() )
						End
					Else
						Aadd( aProdutos, {SB1->B1_COD, 0} )
					Endif
				Else
					Aadd( aProdutos, {SB1->B1_COD, 0} )
				Endif
			Else
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000035" )
				Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			SB1->( DbSetOrder(1) )		// B1_FILIAL+B1_COD
			If SB1->( DbSeek( xFilial("SB1")+aSC6Item[nPC6_PROGAR][2] ) )
			    IF !alltrim(SB1->B1_COD) $'MR010001|MR010002'
					Aadd( aProdutos, {SB1->B1_COD, 0} )
				ELSE	
			        Aadd( aProdutos, {'MR010003', 0} )
			    Endif
			Else
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet,	"000036" )
				Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Endif
	EndIf
	
	For nK := 1 to Len(aProdutos)
		SB1->( DbSetOrder(1) )		// B1_FILIAL+B1_COD
		SB1->( DbSeek( xFilial("SB1")+aProdutos[nK,1] ) )
		
		If !Empty(SB1->B1_CODVEN)
			nPC5_VEND1 := Ascan( aAutoSC5, { |x| Alltrim(x[1])=="C5_VEND1" } )
			If nPC5_VEND1 > 0 .AND. Empty(aAutoSC5[nPC5_VEND1][2])
				aAutoSC5[nPC5_VEND1][2] := SB1->B1_CODVEN
			Endif
		Endif
		
		If (lcombo .and. aProdutos[nK,2]==0)
	
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000037" )
			Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
			Aadd( aRet, "" )
			Return(aRet)
	
		ElseIF (!lcombo .and. SB1->B1_PRV1 == 0)
		
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000037" )
			Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
			Aadd( aRet, "" )
			Return(aRet)
		
		Endif
		
		If Empty(SB1->B1_TS)
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000038" )
			Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		cTes := ""
		
		// Se o tipo de pagamento for VOUCHER e naum for CORPORATIVO, ajusta o TES para emissao da nota
		If aDadosSC5[nPC5_TIPMOV][2] == "6" .AND. aDadosSC5[nPC5_TIPVOU][2] <> "1"
			Do Case
				Case aDadosSC5[nPC5_TIPVOU][2] == "2"		// 2=Sup. Garantia
					IF SA1->A1_EST <> SM0->M0_ESTCOB .AND. (!Empty(SA1->A1_INSCR) .OR. AllTrim(SA1->A1_INSCR) <> "ISENTO")
						cTes := GetNewPar("MV_TSVOU2F", "605")		// FORA do estado
					Else
						cTes := GetNewPar("MV_TSVOU2D", "606")		// DENTRO do estado
					Endif
					
				Case aDadosSC5[nPC5_TIPVOU][2] == "3"		// 3=SAC Substituicao
					IF SA1->A1_EST <> SM0->M0_ESTCOB .AND. (!Empty(SA1->A1_INSCR) .OR. AllTrim(SA1->A1_INSCR) <> "ISENTO")
						cTes := GetNewPar("MV_TSVOU3F", "563")		// FORA do estado
					Else
						cTes := GetNewPar("MV_TSVOU3D", "607")		// DENTRO do estado
					Endif
					
				Case aDadosSC5[nPC5_TIPVOU][2] == "4"		// 4=Cortesia
					IF SA1->A1_EST <> SM0->M0_ESTCOB .AND. (!Empty(SA1->A1_INSCR) .OR. AllTrim(SA1->A1_INSCR) <> "ISENTO")
						cTes := GetNewPar("MV_TSVOU4F", "608")		// FORA do estado
					Else
						cTes := GetNewPar("MV_TSVOU4D", "609")		// DENTRO do estado
					Endif
					
				Case aDadosSC5[nPC5_TIPVOU][2] == "5"		// 5=Funcionário
					cTes := GetNewPar("MV_TESVOU5", "609")
					
				Case aDadosSC5[nPC5_TIPVOU][2] == "6"		// 6=Teste
					IF SA1->A1_EST <> SM0->M0_ESTCOB .AND. (!Empty(SA1->A1_INSCR) .OR. AllTrim(SA1->A1_INSCR) <> "ISENTO")
						cTes := GetNewPar("MV_TSVOU6F", "567")		// FORA do estado
					Else
						cTes := GetNewPar("MV_TSVOU6D", "610")		// DENTRO do estado
					Endif
				
			Endcase
		Endif
		
		// Este trecho do programa para calculo da TES foi retirado do programa CCDEDI03 de importacao de pedido
		If Empty(cTes)
			cTes := U_VerTes(SB1->B1_COD,IIF(Empty(SA1->A1_TIPO),"F",SA1->A1_TIPO),SA1->A1_EST,cTes)
		Endif
		
		If Empty(cTes)
			If SB1->B1_CATEGO $ cCategoSFW
				cTes := cTesSv
			Else
				cTes := cTesMr
			Endif
		Endif
		
		SF4->( DbSetOrder(1) )
		If SF4->( !DbSeek( xFilial("SF4")+cTes ) )
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000039" )
			Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If Empty(SF4->F4_CF)
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000040" )
			Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If Empty(SF4->F4_SITTRIB)
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000041" )
			Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
			Aadd( aRet, "" )
			Return(aRet)
		Endif		
		
		cItem	:= StrZero(Len(aAutoSC6)+1,2)
		nQtdVen	:= aSC6Item[nPC6_QTDVEN][2]        
		nPrv1   := Iif(lCombo, aProdutos[nK,2], SB1->B1_PRV1)
		nValor	:= Iif(lCombo, aSC6Item[nPC6_QTDVEN][2] * aProdutos[nK,2], aSC6Item[nPC6_QTDVEN][2] * SB1->B1_PRV1)
		cCF		:= IIF( SA1->A1_EST==SM0->M0_ESTCOB,SF4->F4_CF,"6"+SubStr(SF4->F4_CF,2) )
		
		Aadd(aAuxSC6, {"C6_FILIAL",		xFilial("SC5"),		 			NIL} )
		Aadd(aAuxSC6, {"C6_ITEM",		cItem,							NIL} )
		Aadd(aAuxSC6, {"C6_PRODUTO",	SB1->B1_COD,		 			NIL} )
		Aadd(aAuxSC6, {"C6_DESCRI",		SB1->B1_DESC,					NIL} )
		Aadd(aAuxSC6, {"C6_QTDVEN",		nQtdVen,			 			NIL} )
		Aadd(aAuxSC6, {"C6_QTDLIB",		0,					 			NIL} )
		Aadd(aAuxSC6, {"C6_PRCVEN",		nPrv1,				  			NIL} )
		Aadd(aAuxSC6, {"C6_VALOR",		nValor,				  			NIL} )
		Aadd(aAuxSC6, {"C6_TES",		cTes,				 			NIL} )
		Aadd(aAuxSC6, {"C6_UM",			SB1->B1_UM,		   				NIL} )
		Aadd(aAuxSC6, {"C6_LOCAL",		SB1->B1_LOCPAD,					NIL} )
		Aadd(aAuxSC6, {"C6_CLI",		SA1->A1_COD,	   				NIL} )
		Aadd(aAuxSC6, {"C6_LOJA",		SA1->A1_LOJA,		 			NIL} )
		Aadd(aAuxSC6, {"C6_ENTREG",		Date(),							NIL} )
		Aadd(aAuxSC6, {"C6_PRUNIT",		nPrv1,							NIL} )
		Aadd(aAuxSC6, {"C6_CODISS",		SB1->B1_CODISS,					NIL} )
		Aadd(aAuxSC6, {"C6_CLASFIS",	SB1->(B1_ORIGEM+B1_CLASFIS),	NIL} )
		Aadd(aAuxSC6, {"C6_TPOP", 		"F",							NIL} )
		Aadd(aAuxSC6, {"C6_QTDEMP",		nQtdVen,						NIL} )
		Aadd(aAuxSC6, {"C6_SUGENTR",	Date(),							NIL} )
		Aadd(aAuxSC6, {"C6_MSBLQL",		"",								NIL} )
		
		For nI := 1 To Len(aSC6Item)
			If Ascan( aAuxSC6, { |x| AllTrim(x[1])==AllTrim(aSC6Item[nI][1]) } ) == 0
				Aadd( aAuxSC6, { aSC6Item[nI][1], aSC6Item[nI][2], 	NIL } )
			Endif
		Next nI

		Aadd( aAutoSC6, Aclone(aAuxSC6) )
		aAuxSC6 := {}
		
	Next nK
	
Next nJ

If Empty(aAutoSC5[nPC5_VEND1][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet,	"000042" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

// Calcula o valor total apurado no pedido de vendas
nTCalcPed := 0
For nI := 1 To Len(aAutoSC6)
	aSC6Item	:= {}
	aSC6Item	:= Aclone(aAutoSC6[nI])
	nPC6_VALOR	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_VALOR" } )
	If nPC6_VALOR > 0
		nTCalcPed += aSC6Item[nPC6_VALOR][2]
	Endif
Next nI

// Guarda o valor de tabela para futura analise
Aadd(aAutoSC5, {"C5_TOTORI", nTCalcPed, NIL} )

If nPC5_TOTPED == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000043" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

// Se houve diferenca de valores, calcula o percentual de ajuste e iguala os valores
If aDadosSC5[nPC5_TOTPED][2] <> nTCalcPed .And. !lCombo
	
	// Calculando o percentual de valores
	nPerAju := aDadosSC5[nPC5_TOTPED][2] / nTCalcPed
	
	// Ajustando os valores dos produtos
	aAuxSC6 := {}
	For nI := 1 To Len(aAutoSC6)
		aSC6Item	:= {}
		aSC6Item	:= Aclone(aAutoSC6[nI])
		nPC6_VALOR	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_VALOR" } )
		nPC6_QTDVEN	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_QTDVEN" } )
		nPC6_PRCVEN	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_PRCVEN" } )
		nPC6_PRUNIT	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_PRUNIT" } )
		
		aSC6Item[nPC6_PRCVEN][2] := aSC6Item[nPC6_PRCVEN][2] * nPerAju
		aSC6Item[nPC6_PRUNIT][2] := aSC6Item[nPC6_PRCVEN][2]
		aSC6Item[nPC6_VALOR][2]  := Round(aSC6Item[nPC6_PRCVEN][2] * aSC6Item[NPC6_QTDVEN][2], 2)
		Aadd( aAuxSC6, aSC6Item )
	Next nI
	aAutoSC6 := {}
	aAutoSC6 := Aclone( aAuxSC6 )
	
	// Recalculando os valores ajustados para conferencia
	nTCalcPed := 0
	For nI := 1 To Len(aAutoSC6)
		aSC6Item	:= {}
		aSC6Item	:= Aclone(aAutoSC6[nI])
		nPC6_VALOR	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_VALOR" } )
		If nPC6_VALOR > 0
			nTCalcPed += aSC6Item[nPC6_VALOR][2]
		Endif
	Next nI
	
	// Conferindo se os valores ajustados possui diferença de arredondamento
	If aDadosSC5[nPC5_TOTPED][2] <> nTCalcPed
		
		nValDif := aDadosSC5[nPC5_TOTPED][2] - nTCalcPed
		
		// Ajustando as diferencas de arredondamento
		aAuxSC6 := {}
		For nI := 1 To Len(aAutoSC6)
			aSC6Item	:= {}
			aSC6Item	:= Aclone(aAutoSC6[nI])
			nPC6_VALOR	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_VALOR" } )
			nPC6_QTDVEN	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_QTDVEN" } )
			nPC6_PRCVEN	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_PRCVEN" } )
			nPC6_PRUNIT	:= Ascan( aSC6Item, { |x| AllTrim(x[1])=="C6_PRUNIT" } )
			
			// Tenta ajustar o arredondamento somente para quantidade 1, pois se for maior que 1 o ajuste nao bate
			If nValDif <> 0 .AND. nValDif > (aSC6Item[nPC6_PRCVEN][2]*-1) .AND. aSC6Item[NPC6_QTDVEN][2] == 1
				aSC6Item[nPC6_PRCVEN][2] := aSC6Item[nPC6_PRCVEN][2] + nValDif
				aSC6Item[nPC6_PRUNIT][2] := aSC6Item[nPC6_PRCVEN][2]
				aSC6Item[nPC6_VALOR][2]  := Round(aSC6Item[nPC6_PRCVEN][2] * aSC6Item[NPC6_QTDVEN][2], 2)
				nValDif := 0
			Endif
			Aadd( aAuxSC6, aSC6Item )
		Next nI
		aAutoSC6 := {}
		aAutoSC6 := Aclone( aAuxSC6 )
	Endif 
	
	If nValDif <> 0
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000044" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, "" )
		Return(aRet)
	Endif
	
Endif

aRet := {}
aRet := U_GARX3OK("SC5",aAutoSC5,aDadosSC5[nPC5_CHVBPAG][2])
If !aRet[1]
	Return(aRet)
Endif
aRet := {}

For nI := 1 To Len(aAutoSC6)
	aAuxSC6	:= Aclone(aAutoSC6[nI])
	aRet	:= {}
	aRet	:= U_GARX3OK("SC6",aAuxSC6,aDadosSC5[nPC5_CHVBPAG][2])
	If !aRet[1]
		Return(aRet)
	Endif
Next nI
aRet := {}

//Renato Ruy - 13/08/2018
//Tratamento sera incluido em todas rotinas para compatibilizacao de CFOP.
If AllTrim(SA1->A1_EST)=="RJ"
	STATICCALL( VNDA190, FATFIL, nil ,"01" )
Endif

MSExecAuto({|x,y,z| MATA410(x,y,z)}, aAutoSC5, aAutoSC6, 3)

If cFilOld <> cFilAnt
	STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
Endif


If lMsErroAuto
	cAutoErr := "SC5, SC6 --> Erro de inclusão de pedido de vendas na rotina padrão do sistema Protheus MSExecAuto({|x,y,z| MATA410(x,y,z)}, aAutoSC5, aAutoSC6, 3)" + CRLF + CRLF
	aAutoErr := GetAutoGRLog()
	For nI := 1 To Len(aAutoErr)
		cAutoErr += aAutoErr[nI] + CRLF
	Next nI
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000045" )
	Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
	Aadd( aRet, cAutoErr )
	Return(aRet)
Else
	DbSelectArea("SC5")
	//DbSetOrder(5)
	SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
	If DbSeek(xFilial("SC5") + aDadosSC5[nPC5_CHVBPAG][2])
		
		RecLock("SC5", .F.)
			SC5->C5_XORIGPV = '2'
		SC5->(MsUnlock())
    EndIf
Endif

cQuery	:=	" SELECT  SC5.R_E_C_N_O_ SC5REC, SC6.R_E_C_N_O_ SC6REC " +;
			" FROM    " + RetSQLName("SC5") + " SC5, " + RetSQLName("SC6") + " SC6 " +;
			" WHERE   SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " +;
			"         SC5.C5_CHVBPAG = '" + aDadosSC5[nPC5_CHVBPAG][2] + "' AND " +;
			"         SC5.D_E_L_E_T_ = ' ' AND " +;
			"         SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
			"         SC6.C6_NUM = SC5.C5_NUM AND " +;
			"         SC5.D_E_L_E_T_ = ' ' " +;
			" ORDER BY SC6.C6_NUM "

PLSQuery( cQuery, "SC6TMP" )

While SC6TMP->( !Eof() )
	
	SC5->( DbGoTo(SC6TMP->SC5REC) )
	SC6->( DbGoTo(SC6TMP->SC6REC) )
	
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1")+SC6->C6_PRODUTO ) )
	
	SA1->( DbSetOrder(1) )
	SA1->( DbSeek( xFilial("SA1")+SC5->(C5_CLIENT+C5_LOJAENT) ) )
	
	cTES := ""
	If SB1->B1_CATEGO $ cCategoHRD
		cTES := MaTesInt(2,"52",SC5->C5_CLIENT,SC5->C5_LOJAENT,If(SC5->C5_TIPO$'DB',"F","C"),SC6->C6_PRODUTO,"C6_TES")
	ElseIf SB1->B1_CATEGO $ cCategoSFW
		cTES := MaTesInt(2,"51",SC5->C5_CLIENT,SC5->C5_LOJAENT,If(SC5->C5_TIPO$'DB',"F","C"),SC6->C6_PRODUTO,"C6_TES")
	Endif
	
	If Empty(cTES)
		cTES := SC6->C6_TES
	Endif
	
	SC6->( RecLock("SC6",.F.) )
	If SB1->B1_CATEGO $ cCategoHRD
		SC6->C6_XOPER	:= "52"
	ElseIf SB1->B1_CATEGO $ cCategoSFW
		SC6->C6_XOPER	:= "51"
	Endif
	SC6->C6_TES		:= cTES
	SC6->C6_CLASFIS	:= SubStr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
	SC6->C6_CF		:= IIF( SA1->A1_EST==SM0->M0_ESTCOB,SF4->F4_CF,"6"+SubStr(SF4->F4_CF,2) )
	SC6->( MsUnLock() )
	
	// Se for servico, paro aqui e pego o proximo
	If SB1->B1_CATEGO $ cCategoSFW
		SC6TMP->( DbSkip() )
		Loop
	Endif
	
	cTES := MaTesInt(2,"53",SC5->C5_CLIENT,SC5->C5_LOJAENT,If(SC5->C5_TIPO$'DB',"F","C"),SC6->C6_PRODUTO,"C6_TES")
	
	If Empty(cTES)
		cTES := SC6->C6_TES
	Endif
	
	// Se for um hardware, replica para a outr TES
	aDados := {}
	For nI := 1 To Len(aStruSC6)
		cCampo := aStruSC6[nI][1]
		Aadd( aDados, { cCampo, &("SC6->"+cCampo) } )
	Next nI
	
	cQuery	:=	" SELECT MAX(C6_ITEM) C6_ITEM FROM " + RetSQLName("SC6") + " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM = '" + SC6->C6_NUM + "' AND D_E_L_E_T_ = ' ' "
	PLSQuery( cQuery, "SC6AUX" )
	If SC6AUX->( !Eof() )
		cItemSC6 := StrZero(Val(SC6AUX->C6_ITEM)+1,2)
	Else
		cItemSC6 := "01"
	Endif
	SC6AUX->( DbCloseArea() )
	
	SC6->( RecLock("SC6",.T.) )
	For nI := 1 To Len(aDados)
		cCampo := aDados[nI][1]
		Do Case
			Case cCampo == "C6_ITEM"
				SC6->C6_ITEM := cItemSC6
			Case cCampo == "C6_XOPER"
				SC6->C6_XOPER := "53"
			Otherwise
				&("SC6->"+cCampo) := aDados[nI][2]
		Endcase
	Next nI
	SC6->( MsUnLock() )
	
	SC6->( RecLock("SC6",.F.) )
	SC6->C6_TES		:= cTES
	SC6->C6_CLASFIS	:= SubStr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
	SC6->C6_CF		:= IIF( SA1->A1_EST==SM0->M0_ESTCOB,SF4->F4_CF,"6"+SubStr(SF4->F4_CF,2) )
	SC6->( MsUnLock() )
	
	SC6TMP->( DbSkip() )
	
End
SC6TMP->( DbCloseArea() )

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000023" )
Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
Aadd( aRet, "" )

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GAR110Fin(aDadosSE1)

Local aAutoSE1		:= {}
Local nI			:= 0
Local cNumTit		:= 0
Local aRet			:= {}
Local aAutoErr		:= {}
Local dEmissao		:= CtoD("//")
Local dVencto		:= CtoD("//")
Local nValor		:= 0
Local nPE1_EMISSAO	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_EMISSAO" } )
Local nPE1_VENCTO	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_VENCTO" } )
Local nPE1_VALOR	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_VALOR" } )
Local nPE1_TIPMOV	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_TIPMOV" } )
Local nPE1_PORTADO	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_PORTADO" } )
Local nPE1_AGEDEP	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_AGEDEP" } )
Local nPE1_CONTA	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_CONTA" } )
Local nPE1_PEDGAR	:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_PEDGAR" } )
Local nPE1_ADM		:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_ADM" } )
Local nPE1_CNPJ		:= Ascan( aDadosSE1, { |x| AllTrim(x[1])=="E1_CNPJ" } )
Local nRecSE1		:= 0

Default aDadosSE1	:= {}

// Se veio em branco eh porque somente compensa RA com DP
If Len(aDadosSE1) == 0
	//SE1->( DbSetOrder(23) )		// E1_FILIAL+E1_PEDGAR+E1_TIPO
	SE1->(DbOrderNickName("SE1_23"))//Alterado por LMS em 03-01-2013 para virada
	SE1->( DbSeek( xFilial("SE1")+SC5->C5_CHVBPAG+"RA" ) )
	While	SE1->( !Eof() ) .AND.;
			SE1->E1_FILIAL == xFilial("SE1") .AND.;
			SE1->E1_PEDGAR == SC5->C5_CHVBPAG .AND.;
			SE1->E1_TIPO == "RA "
		
		nRecSE1 := SE1->( RecNo() )
		FA330Comp()
		SE1->( DbGoto(nRecSE1) )
		
		SE1->( DbSkip() )
	End
	
	aRet := {}
	Aadd( aRet, .T. )
	Aadd( aRet, "" )
	Aadd( aRet, "" )
	Aadd( aRet, "" )
	Return(aRet)
Endif


SX3->( DbSetOrder(2) )
For nI := 1 To Len(aDadosSE1)
	If Valtype(aDadosSE1[nI][2]) == "C"
		If SX3->( DbSeek( aDadosSE1[nI][1] ) )
			aDadosSE1[nI][2] := PadR(AllTrim(aDadosSE1[nI][2]),SX3->X3_TAMANHO)
		Endif
	Endif
Next nI

If nPE1_PEDGAR == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000117" )
	Aadd( aRet, "9999999999" )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_PEDGAR][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000118" )
	Aadd( aRet, "9999999999" )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPE1_EMISSAO == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000046" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_EMISSAO][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000047" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Else
	dEmissao := aDadosSE1[nPE1_EMISSAO][2]
Endif

If nPE1_VENCTO == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000048" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_VENCTO][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000049" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Else
	dVencto := aDadosSE1[nPE1_VENCTO][2]
Endif

If nPE1_VALOR == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000050" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_VALOR][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000051" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Else
	nValor := aDadosSE1[nPE1_VALOR][2]
Endif

If nPE1_TIPMOV == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000104" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_TIPMOV][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000105" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If nPE1_CNPJ == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000010" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_CNPJ][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000011" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

// Valida o banco e ajusta o tamanho das variaveis
SA6->( DbSetOrder(1) )		// A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON

If nPE1_PORTADO == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000160" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_PORTADO][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000161" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Else
	aDadosSE1[nPE1_PORTADO][2] := PadR(aDadosSE1[nPE1_PORTADO][2],Len(SA6->A6_COD))
Endif

If nPE1_AGEDEP == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000162" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_AGEDEP][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000163" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Else
	aDadosSE1[nPE1_AGEDEP][2] := PadR(aDadosSE1[nPE1_AGEDEP][2],Len(SA6->A6_AGENCIA))
Endif

If nPE1_CONTA == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000164" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If Empty(aDadosSE1[nPE1_CONTA][2])
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000165" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Else
	aDadosSE1[nPE1_CONTA][2] := PadR(aDadosSE1[nPE1_CONTA][2],Len(SA6->A6_NUMCON))
Endif

If SA6->( !DbSeek( xFilial("SA6")+aDadosSE1[nPE1_PORTADO][2]+aDadosSE1[nPE1_AGEDEP][2]+aDadosSE1[nPE1_CONTA][2] ) )
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000166" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

If SA6->A6_BLOCKED == "1"		// 1=Sim;2=Nao - conta bloqueada
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000167" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, "" )
	Return(aRet)
Endif

// Segue a mesma regra da importacao do sistema antigo para manter compatibilidade.
aDadosSE1[nPE1_CNPJ][2] := CheckCgc(aDadosSE1[nPE1_CNPJ][2])

Private lMsErroAuto		:= .F.	// variavel interna da rotina automatica MSExecAuto()
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()

// 1=Boleto;2=Cartao Credito;3=Cartao Debito;4=DA;5=DDA;6=Voucher


// ESTE TRATAMETNO FOI RETIRADO NA ALTERACAO DO ESCOPO ONDE O BANCO, AGENCIA E CONTA
// PASSARA A SER ENVIADOS PELO GAR CFE INFORMADO PELA BIANCA E SOLICITADO PELO EDSON
/*
Do Case
	Case aDadosSE1[nPE1_TIPMOV][2] == "1"
		cBanco		:= PadR(GetNewPar("MV_BCOBOL","341"),3)
		cAgencia	:= PadR(GetNewPar("MV_AGEBOL","2901"),5)
		cConta		:= PadR(GetNewPar("MV_CTABOL","04814-6"),10)
		
	Case aDadosSE1[nPE1_TIPMOV][2] == "2" .AND. aDadosSE1[nPE1_ADM][2] == "RED"
		cBanco		:= PadR(GetNewPar("MV_BCORED","341"),3)
		cAgencia	:= PadR(GetNewPar("MV_AGERED","2901"),5)
		cConta		:= PadR(GetNewPar("MV_CTARED","04814-6"),10)
		
	Case aDadosSE1[nPE1_TIPMOV][2] == "2" .AND. aDadosSE1[nPE1_ADM][2] == "VIS"
		cBanco		:= PadR(GetNewPar("MV_BCOVIS","237"),3)
		cAgencia	:= PadR(GetNewPar("MV_AGEVIS","33910"),5)
		cConta		:= PadR(GetNewPar("MV_CTAVIS","016038-5"),10)
		
	Case aDadosSE1[nPE1_TIPMOV][2] == "2" .AND. aDadosSE1[nPE1_ADM][2] == "AME"
		cBanco		:= PadR(GetNewPar("MV_BCOAME","237"),3)
		cAgencia	:= PadR(GetNewPar("MV_AGEAME","33910"),5)
		cConta		:= PadR(GetNewPar("MV_CTAAME","016038-5"),10)
		
	Case aDadosSE1[nPE1_TIPMOV][2] $ "3,4,5"		// Cartao de debito, DA, DDA
		Do Case
			Case aDadosSE1[nPE1_PORTADO][2] == "341"
				cBanco		:= PadR("341",3)
				cAgencia	:= PadR("2901",5)
				cConta		:= PadR("04814-6",10)
			Case aDadosSE1[nPE1_PORTADO][2] == "237"
				cBanco		:= PadR("237",3)
				cAgencia	:= PadR("33910",5)
				cConta		:= PadR("016038-5",10)
			Case aDadosSE1[nPE1_PORTADO][2] == "001"
				cBanco		:= PadR("001",3)
				cAgencia	:= PadR("3221",5)
				cConta		:= PadR("6662-1",10)
		Endcase
		
	Case aDadosSE1[nPE1_TIPMOV][2] == "6"		// Voucher
		cBanco		:= PadR(GetNewPar("MV_BCOBOL","341"),3)
		cAgencia	:= PadR(GetNewPar("MV_AGEBOL","2901"),5)
		cConta		:= PadR(GetNewPar("MV_CTABOL","04814-6"),10)
		
Endcase
*/



cNumTit := GetSXENum("SE1", "E1_NUM")
ConfirmSX8()

Aadd(aAutoSE1, {"E1_FILIAL",	xFilial("SE1"),					NIL} )
Aadd(aAutoSE1, {"E1_PREFIXO",	GetNewPar("MV_PREFSE1","ADT"),	NIL} )
Aadd(aAutoSE1, {"E1_NUM",		cNumTit,						NIL} )
Aadd(aAutoSE1, {"E1_PARCELA",	"A",							NIL} )
If aDadosSE1[nPE1_TIPMOV][2] == "6"		// Diferente de Voucher
	Aadd(aAutoSE1, {"E1_TIPO",		"NCC",						NIL} )
Else
	Aadd(aAutoSE1, {"E1_TIPO",		"RA",						NIL} )
Endif


// 1=Boleto;2=Cartao Credito;3=Cartao Debito;4=DA;5=DDA;6=Voucher

Do Case
	Case aDadosSE1[nPE1_TIPMOV][2] == "1"
		Aadd(aAutoSE1, {"E1_NATUREZ", "FT050001", NIL} )		// RA - BOLETO BANCÁRIO	RA - RECEBIMENTO ANTECIPADO
		
	Case aDadosSE1[nPE1_TIPMOV][2] $ "3,4,5"
		Do Case
			Case aDadosSE1[nPE1_PORTADO][2] == "341"
				Aadd(aAutoSE1, {"E1_NATUREZ", "FT050051", NIL} )		// RA - TRANSFERÊNCIA BANCÁRIA - ITAU	RA - RECEBIMENTO ANTECIPADO
			Case aDadosSE1[nPE1_PORTADO][2] == "237"
				Aadd(aAutoSE1, {"E1_NATUREZ", "FT050052", NIL} )		// RA - TRANSFERÊNCIA BANCÁRIA - BRADESCO	RA - RECEBIMENTO ANTECIPADO
			Case aDadosSE1[nPE1_PORTADO][2] == "001"
				Aadd(aAutoSE1, {"E1_NATUREZ", "FT050053", NIL} )		// RA - TRANSFERÊNCIA BANCÁRIA - BANCO DO BRASIL	RA - RECEBIMENTO ANTECIPADO
			OtherWise
				Aadd(aAutoSE1, {"E1_NATUREZ", "FT050051", NIL} )		// RA - TRANSFERÊNCIA BANCÁRIA - ITAU	RA - RECEBIMENTO ANTECIPADO
		Endcase
		
	Case aDadosSE1[nPE1_TIPMOV][2] == "6"
		Aadd(aAutoSE1, {"E1_NATUREZ", "FT010030", NIL} )		// 	NCC - NOTA DE CREDITO (VOUCHER)	NOTA DE CRÉDITO AO CLIENTE
		
	OtherWise
		Aadd(aAutoSE1, {"E1_NATUREZ", "FT050001", NIL} )		// RA - BOLETO BANCÁRIO	RA - RECEBIMENTO ANTECIPADO
		
Endcase

Aadd(aAutoSE1, {"E1_PORTADO",	aDadosSE1[nPE1_PORTADO][2],	NIL} )
Aadd(aAutoSE1, {"E1_AGEDEP",	aDadosSE1[nPE1_AGEDEP][2],	NIL} )
Aadd(aAutoSE1, {"E1_CONTA",		aDadosSE1[nPE1_CONTA][2],	NIL} )
Aadd(aAutoSE1, {"E1_CLIENTE",	SA1->A1_COD,			NIL} )
Aadd(aAutoSE1, {"E1_LOJA",		SA1->A1_LOJA,			NIL} )
Aadd(aAutoSE1, {"E1_NOMCLI",	SA1->A1_NOME,			NIL} )
Aadd(aAutoSE1, {"E1_VEND1",		"",						NIL} )
Aadd(aAutoSE1, {"E1_VEND2",		"",						NIL} )
Aadd(aAutoSE1, {"E1_VEND3",		"",						NIL} )
Aadd(aAutoSE1, {"E1_VEND4",		"",						NIL} )
Aadd(aAutoSE1, {"E1_VEND5",		"",						NIL} )
Aadd(aAutoSE1, {"E1_COMIS1",	0,						NIL} )
Aadd(aAutoSE1, {"E1_COMIS2",	0,						NIL} )
Aadd(aAutoSE1, {"E1_COMIS3",	0,						NIL} )
Aadd(aAutoSE1, {"E1_COMIS4",	0,						NIL} )
Aadd(aAutoSE1, {"E1_COMIS5",	0,						NIL} )
Aadd(aAutoSE1, {"E1_ORIGPV",	"1",					NIL} )
Aadd(aAutoSE1, {"E1_EMISSAO",	dEmissao,				NIL} )
Aadd(aAutoSE1, {"E1_VENCTO",	dVencto,				NIL} )
Aadd(aAutoSE1, {"E1_VENCREA",	DataValida(dVencto),	NIL} )
Aadd(aAutoSE1, {"E1_VALOR",		nValor,					NIL} )
Aadd(aAutoSE1, {"E1_EMIS1",		dEmissao,				NIL} )
Aadd(aAutoSE1, {"E1_SALDO",		nValor,					NIL} )
Aadd(aAutoSE1, {"E1_VENCORI",	dVencto,				NIL} )
Aadd(aAutoSE1, {"E1_VLCRUZ",	nValor,					NIL} )
Aadd(aAutoSE1, {"E1_PEDIDO",	SC5->C5_NUM,			NIL} )
Aadd(aAutoSE1, {"E1_STATUS",	"A",					NIL} )
Aadd(aAutoSE1, {"E1_ORIGEM",	"GARA110",				NIL} )
Aadd(aAutoSE1, {"E1_FLUXO",		"S",					NIL} )
Aadd(aAutoSE1, {"E1_TIPODES",	"1",					NIL} )
Aadd(aAutoSE1, {"E1_FILORIG",	xFilial("SE1"),			NIL} )
Aadd(aAutoSE1, {"E1_MULTNAT",	"2",					NIL} )
Aadd(aAutoSE1, {"E1_MSFIL",		xFilial("SE1"),			NIL} )
Aadd(aAutoSE1, {"E1_MSEMP",		"01",					NIL} )
Aadd(aAutoSE1, {"E1_PROJPMS",	"2",					NIL} )
Aadd(aAutoSE1, {"E1_DESDOBR",	"2",					NIL} )
Aadd(aAutoSE1, {"E1_MODSPB",	"1",					NIL} )
Aadd(aAutoSE1, {"E1_CREDIT",	GetNewPar("MV_E1CREDI",	"110301001"),	NIL} )
Aadd(aAutoSE1, {"E1_CCC",		GetNewPar("MV_E1CCC",	"V07100303"),	NIL} )
Aadd(aAutoSE1, {"E1_ITEMC",		GetNewPar("MV_E1ITEMC",	"11010004"),	NIL} )
Aadd(aAutoSE1, {"E1_CLVLCR",	GetNewPar("MV_E1CLVLC",	"000000000"),	NIL} )
Aadd(aAutoSE1, {"E1_MSBLQL",	"2",									NIL} )
Aadd(aAutoSE1, {"E1_APLVLMN",	"1",									NIL} )

For nI := 1 To Len(aDadosSE1)
	If Ascan( aAutoSE1, { |x| AllTrim(x[1])==AllTrim(aDadosSE1[nI][1]) } ) == 0
		Aadd( aAutoSE1, { aDadosSE1[nI][1], aDadosSE1[nI][2], NIL } )
	Endif
Next

aRet := {}
aRet := U_GARX3OK("SE1",aAutoSE1,aDadosSE1[nPE1_PEDGAR][2])
If !aRet[1]
	Return(aRet)
Endif
aRet := {}

MSExecAuto({|x, y| FINA040(x, y)}, aAutoSE1, 3)

If lMsErroAuto
	
	// Se deu erro na inclusão do titulo, vou eliminar o pedido para incluir novamente na proxima vez.
	Begin Transaction
	//SC5->( DbSetOrder(5) )		// C5_FILIAL+C5_CHVBPAG
	SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
	If SC5->( DbSeek( xFilial("SC5")+aDadosSE1[nPE1_PEDGAR][2] ) )
		
		SC5->( RecLock("SC5", .F.) )
		SC5->( DbDelete() )
		SC5->( MsUnLock() )
		
		SC6->( DbSetOrder(1) )
		SC6->( DbSeek( xFilial("SC6")+SC5->C5_NUM ) )
		While	SC6->( !Eof() ) .AND.;
				SC6->C6_FILIAL == xFilial("SC6") .AND.;
				SC6->C6_NUM == SC5->C5_NUM
			
			SC6->( RecLock("SC6", .F.) )
			SC6->( DbDelete() )
			SC6->( MsUnLock() )
			
			SC6->( DbSkip() )
		End
		
	Endif
	
	End Transaction
	
	cAutoErr := "SE1 --> Erro de inclusão no financeiro na rotina padrão do sistema Protheus MSExecAuto({|x, y| FINA040(x, y)}, aAutoSE1, 3)" + CRLF + CRLF
	aAutoErr := GetAutoGRLog()
	For nI := 1 To Len(aAutoErr)
		cAutoErr += aAutoErr[nI] + CRLF
	Next nI
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000106" )
	Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
	Aadd( aRet, cAutoErr )
	Return(aRet)
Else
	SE5->( DbSetOrder(1) )		// E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	SE5->( DbSeek( xFilial("SE5")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) )
	While	SE5->( !Eof() ) .AND.;
			SE5->E5_FILIAL	== xFilial("SE5") .AND.;
			SE5->E5_PREFIXO	== SE1->E1_PREFIXO .AND.;
			SE5->E5_NUMERO	== SE1->E1_NUM .AND.;
			SE5->E5_PARCELA	== SE1->E1_PARCELA .AND.;
			SE5->E5_TIPO	== SE1->E1_TIPO
		
		SE5->( RecLock("SE5",.F.) )
		SE5->E5_HIST := "RA DO PEDIDO GAR " + AllTrim(aDadosSE1[nPE1_PEDGAR][2])
		SE5->( MsUnLock() )
		
		SE5->( DbSkip() )
	End
Endif

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000023" )
Aadd( aRet, aDadosSE1[nPE1_PEDGAR][2] )
Aadd( aRet, "" )
	
Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CHECKCGC  ³ Autor ³Henio Brasil Claudino  ³ Data ³ 19.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida a formatacao do Cnpj ou Cpf enviados no arquivo Txt  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CheckCGC(cCnpj)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Pesquisa a existencia do Cliente na base                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cCnpjCpf:= cCnpj

If !Empty(cCnpj)
	// Verifica se e' CPF
	If Len(Alltrim(cCnpj))<11
		cCnpjCpf:= Strzero(Val(cCnpj),11)
		// Se nao for CPF e' CNPJ
	ElseIf Len(Alltrim(cCnpj))>11 .and. Len(Alltrim(cCnpj))<=14
		cCnpjCpf:= Strzero(Val(cCnpj),14)
	EndIf
Endif
Return(cCnpjCpf)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GAR110Lib()

Local aAutoSC5		:= {}
Local aAutoSC6		:= {}
Local aItemSC6		:= {}
Local aStructSC5	:= SC5->( DbStruct() )
Local aStructSC6	:= SC6->( DbStruct() )
Local nI			:= 0
Local cCampo		:= ""
Local cAutoErr		:= ""
Local aAutoErr		:= {}
Local lLibAll		:= .T.
Local nPC5_LIBEROK	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O Pedido de Vendas jah vem validado e posicionado, agora verifico se estah liberado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC5->C5_LIBEROK <> "S"
	
	For nI := 1 To Len(aStructSC5)
		cCampo := aStructSC5[nI][1]
		If !Empty(&("SC5->"+cCampo))
			Aadd( aAutoSC5, { cCampo, &("SC5->"+cCampo), NIL } )
		Endif
	Next nI
	
	SC6->( DbSetOrder(1) )
	SC6->( DbSeek( xFilial("SC6")+SC5->C5_NUM ) )
	While	SC6->( !Eof() ) .AND.;
			SC6->C6_FILIAL == xFilial("SC6") .AND.;
			SC6->C6_NUM == SC5->C5_NUM
			
			If Empty(SC6->C6_NOTA) .and. SC6->C6_QTDEMP > 0
				MaAvalSC6("SC6",4,"SC5")
	   		EndIf
			
		For nI := 1 To Len(aStructSC6)
			cCampo := Alltrim(aStructSC6[nI][1])
			Do Case
				Case cCampo == "C6_QTDLIB" .OR. cCampo == "C6_QTDEMP"
					If SC6->C6_XOPER == "53" .OR. !Empty(SC6->C6_NOTA)
						Aadd( aItemSC6, { cCampo, 0, NIL } )
						lLibAll := .F.
					Else
						Aadd( aItemSC6, { cCampo, SC6->C6_QTDVEN, NIL } )
					Endif
					
				Case cCampo $ "C6_CF"
				
				Otherwise
					If !Empty(&("SC6->"+cCampo))
						Aadd( aItemSC6, { cCampo, &("SC6->"+cCampo), NIL } )
					Endif
				
			Endcase
		Next nI
		
		Aadd( aAutoSC6, aItemSC6 )
		aItemSC6 := {}
		
		SC6->( DbSkip() )
	End
	
	// Se liberou todos os itens do pedido, marco como liberado total
	nPC5_LIBEROK := Ascan( aAutoSC5, { |x| AllTrim(x[1])=="C5_LIBEROK"} )
	If lLibAll
		If nPC5_LIBEROK > 0
			aAutoSC5[nPC5_LIBEROK][2] := "S"
		Else
			Aadd( aAutoSC5, {"C5_LIBEROK", "S", Nil} )
		Endif
	Endif
	
	Private lMsErroAuto		:= .F.	// variavel interna da rotina automatica MSExecAuto()
	Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()
	
	MSExecAuto({|x,y,z| MATA410(x,y,z)}, aAutoSC5, aAutoSC6, 4)
	
	If lMsErroAuto
		cAutoErr := "SC5, SC6 --> Erro de inclusão de pedido de vendas na rotina padrão do sistema Protheus MSExecAuto({|x,y,z| MATA410(x,y,z)}, aAutoSC5, aAutoSC6, 4)" + CRLF + CRLF
		aAutoErr := GetAutoGRLog()
		For nI := 1 To Len(aAutoErr)
			cAutoErr += aAutoErr[nI] + CRLF
		Next nI
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000045" )
		Aadd( aRet, aDadosSC5[nPC5_CHVBPAG][2] )
		Aadd( aRet, cAutoErr )
		Return(aRet)
	Endif
	
	SC9->( DbSetOrder(1) )		// C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	If SC9->( DBSeek( xFilial("SC9")+SC5->C5_NUM ) )
//		Mystatus("CHECK - Liberacao do SC9 OK ")
	Else
//		Mystatus("CHECK - Liberacao do SC9 NAO GEROU !!!!")
	Endif
	
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza arquivo de liberados para desbloquear CREDITO e ESTOQUE       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SC9->( DbSetOrder(1) )		// C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
If SC9->( DBSeek( xFilial("SC9")+SC5->C5_NUM ) )
	While	SC9->( !Eof() ) .AND.;
			SC9->C9_FILIAL == xFilial("SC9") .AND.;
			SC9->C9_PEDIDO == SC5->C5_NUM
		
		If !Empty(SC9->C9_BLEST) .OR. !Empty(SC9->C9_BLCRED)
			SC9->( RecLock("SC9"), .F. )
			SC9->C9_BLEST	:= ""
			SC9->C9_BLCRED	:= ""
			SC9->( MsUnLock() )
		Endif
		
		SC9->( DbSkip() )
	End
Else

//	Mystatus("*** ERRO NA CHAVE SC9 ?? ["+xFilial("SC9")+SC5->C5_NUM+"]")

	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000098" )
	Aadd( aRet, SC5->C5_CHVBPAG )
	Aadd( aRet, "" )
	Return(aRet)
Endif

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000099" )
Aadd( aRet, SC5->C5_CHVBPAG )
Aadd( aRet, "" )

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GAR110Fat(nRecSF2Sfw, nRecSF2Hrd)

Local lEnd			:= .F.
Local cQuery		:= ""
Local cQuerySfw		:= ""
Local cQueryHrd		:= ""
Local cCategoSFW	:= "('" + StrTran(GetNewPar("MV_GARSFT", "2"),",","','") + "')"
Local cCategoHRD	:= "('" + StrTran(GetNewPar("MV_GARHRD", "1"),",","','") + "')"
Local cNota			:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faturamento de Software - NOTA FISCAL DE SERVICO - PREFEITURA DE SAO PAULO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuerySfw:=	" SELECT  COUNT(*) B1_QTDPRO " +;
			" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SC9") + " SC9, " + RetSQLName("SB1") + " SB1 " +;
			" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
			"         SC6.C6_PEDGAR = '" + SC5->C5_CHVBPAG + "' AND " +;
			"         SC6.C6_XOPER = '51' AND " +;
			"         SC6.D_E_L_E_T_ = ' ' AND " +;
			"         SC9.C9_FILIAL = '" + xFilial("SC9") + "' AND " +;
			"         SC9.C9_PEDIDO = SC6.C6_NUM AND " +;
			"         SC9.C9_ITEM = SC6.C6_ITEM AND " +;
			"         SC9.D_E_L_E_T_ = ' ' AND " +;
			"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND " +;
			"         SB1.B1_COD = SC6.C6_PRODUTO AND " +;
			"         SB1.B1_CATEGO IN " + cCategoSFW + " AND " +;
			"         SB1.D_E_L_E_T_ = ' ' "
PLSQuery( cQuerySfw, "SB1TMP" )
If SB1TMP->B1_QTDPRO > 0
	
	conout(" ------ [GARA110] INICIO GERACAO NF SFW PEDIDO GAR "+SC5->C5_CHVBPAG+" INICIO EM "+DtoC(date())+"  as  "+Time())
	cNota := Ma460Proc("SC9",GetNewPar("MV_GARSSFW","RP2"),.F.,.F.,.F.,.F.,.F.,3,3,"","ZZZZZZ",.F.,0,"","ZZZZZZ",.F.,.F.,"",@lEnd,"2")
	conout(" ------ [GARA110] FIM GERACAO NF SFW PEDIDO GAR "+SC5->C5_CHVBPAG+" FIM EM "+DtoC(date())+"  as  "+Time())
	
	//'SPR', 'SP2'
	SE1->( DbSetOrder(1) )
	SE1->( DbSeek( xFilial("SE1")+&(GetMV("MV_1DUPREF"))+SF2->F2_DOC ) )
	While	SE1->( !Eof() ) .AND.;
			SE1->E1_FILIAL == xFilial("SE1") .AND.;
			SE1->E1_PREFIXO == &(GetMV("MV_1DUPREF")) .AND.;
			SE1->E1_NUM == SF2->F2_DOC
		SE1->( RecLock("SE1",.F.) )
		SE1->E1_PEDGAR	:= SC5->C5_CHVBPAG
		SE1->E1_CNPJ	:= SC5->C5_CNPJ
		SE1->E1_TIPMOV	:= SC5->C5_TIPMOV
		SE1->( MsUnLock() )
		SE1->( DbSkip() )
	End
	
	// Salva o recno do arquivo para imprimir mais tarde.
	nRecSF2Sfw := SF2->( RecNo() )
	
Endif
SB1TMP->( DbCloseArea() )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faturamento de Hardware - NOTA FISCAL DE PRODUTO - SEFAZ                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQueryHrd:=	" SELECT  COUNT(*) B1_QTDPRO " +;
			" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SC9") + " SC9, " + RetSQLName("SB1") + " SB1 " +;
			" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
			"         SC6.C6_PEDGAR = '" + SC5->C5_CHVBPAG + "' AND " +;
			"         SC6.C6_XOPER = '52' AND " +;
			"         SC6.D_E_L_E_T_ = ' ' AND " +;
			"         SC9.C9_FILIAL = '" + xFilial("SC9") + "' AND " +;
			"         SC9.C9_PEDIDO = SC6.C6_NUM AND " +;
			"         SC9.C9_ITEM = SC6.C6_ITEM AND " +;
			"         SC9.D_E_L_E_T_ = ' ' AND " +;
			"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND " +;
			"         SB1.B1_COD = SC6.C6_PRODUTO AND " +;
			"         SB1.B1_CATEGO IN " + cCategoHRD + " AND " +;
			"         SB1.D_E_L_E_T_ = ' ' "
PLSQuery( cQueryHrd, "SB1TMP" )
If SB1TMP->B1_QTDPRO > 0
	
	conout(" ------ [GARA110] INICIO GERACAO NF FUTURA HRD PEDIDO GAR "+SC5->C5_CHVBPAG+" INICIO EM "+DtoC(date())+"  as  "+Time())
	cNota := Ma460Proc("SC9",GetNewPar("MV_GARSHRD","2  "),.F.,.F.,.F.,.F.,.F.,3,3,"","ZZZZZZ",.F.,0,"","ZZZZZZ",.F.,.F.,"",@lEnd,"1")
	conout(" ------ [GARA110] FIM GERACAO NF FUTURA HRD PEDIDO GAR "+SC5->C5_CHVBPAG+" FIM EM "+DtoC(date())+"  as  "+Time())
	
	//'SPR', 'SP2'
	SE1->( DbSetOrder(1) )
	SE1->( DbSeek( xFilial("SE1")+&(GetMV("MV_1DUPREF"))+SF2->F2_DOC ) )
	While	SE1->( !Eof() ) .AND.;
			SE1->E1_FILIAL == xFilial("SE1") .AND.;
			SE1->E1_PREFIXO == &(GetMV("MV_1DUPREF")) .AND.;
			SE1->E1_NUM == SF2->F2_DOC
		SE1->( RecLock("SE1",.F.) )
		SE1->E1_PEDGAR	:= SC5->C5_CHVBPAG
		SE1->E1_CNPJ	:= SC5->C5_CNPJ
		SE1->E1_TIPMOV	:= SC5->C5_TIPMOV
		SE1->( MsUnLock() )
		SE1->( DbSkip() )
	End
	
	// Salva o recno do arquivo para imprimi mais tarde.
	nRecSF2Hrd := SF2->( RecNo() )
Endif
SB1TMP->( DbCloseArea() )

If nRecSF2Sfw == 0 .AND. nRecSF2Hrd == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000136" )
	Aadd( aRet, SC5->C5_CHVBPAG )
	Aadd( aRet, "Query de serviço-> " + cQuerySfw + CRLF + "Query de Produto-> " +cQueryHrd )
	Return(aRet)
Endif

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000101" )
Aadd( aRet, SC5->C5_CHVBPAG )
Aadd( aRet, "" )

Return(aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma460Proc ³ Autor ³Eduardo Riera          ³ Data ³28.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gauge de Processamento da Geracao da Nota Fiscal            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias da MarkBrowse                                  ³±±
±±³          ³ExpC2: Serie da Nota Fiscal a ser considerada               ³±±
±±³          ³ExpL3: Mostra Lanc.Ctb.                                     ³±±
±±³          ³ExpL4: Aglut.Lancamentos                                    ³±±
±±³          ³ExpL5: Lct.Ctb.On-Line                                      ³±±
±±³          ³ExpL6: Lct.Ctb.Custo On-Line                                ³±±
±±³          ³ExpL7: Reajusta na mesma nota                               ³±±
±±³          ³ExpN8: Calc.Acr.Fin                                         ³±±
±±³          ³ExpN9: Arred.Prc.Unit                                       ³±±
±±³          ³ExpCA: Agregador de Liberacao Inicial                       ³±±
±±³          ³ExpCB: Agregador de Liberacao Final                         ³±±
±±³          ³ExpLC: Aglutina Pedido Iguais                               ³±±
±±³          ³ExpND: Valor Minimo para faturamento                        ³±±
±±³          ³ExpNE: Transportadora Inicial                               ³±±
±±³          ³ExpNF: Transportadora Final                                 ³±±
±±³          ³ExpNG: Atualiza Amarracao Cliente x Produto                 ³±±
±±³          ³ExpNH: Cupom Fiscal                                         ³±±
±±³          ³ExpNI: Condicao a Ser Avaliada                              ³±±
±±³          ³ExpLJ: Flag de cancelamento do usuario                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma460Proc(cTabela,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,cAgregI,cAgregF,lJunta,nFatMin,cTranspI,cTranspF,lAtuSA7,lECF,cCondicao,lEnd,cCatego)

Local aArea    		:= GetArea()
Local aAreaSC9 		:= SC9->(GetArea())
Local aFiltro  		:= {}
Local nItemNf  		:= a460NumIt(cSerie)
Local nIndSC9  		:= 0
Local nIndBrw  		:= 0
Local nPosKey  		:= 0
Local nCntFor  		:= 0
Local nTotal   		:= 0
Local nNrVend  		:= Fa440CntVen()
Local nPrcVen  		:= 0
Local nRecDAK  		:= 0
Local cArqSC9  		:= ""
Local cArqBrw  		:= ""
Local cFilSC9  		:= ""
Local cQrySC9  		:= ""
Local cFilBrw  		:= ""
Local cQryBrw  		:= ""
Local cKeySC9  		:= "C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO"
Local cAuxKey  		:= ""
Local cMarca   		:= ThisMark()
Local cCursor1 		:= cTabela
Local cCursor2 		:= "SC9"
Local cCursor3 		:= "SC9"
Local cVendedor		:= ""
Local cFldQry  		:= ""
Local cNota	   		:= ""
Local cTipo9   		:= ""
Local cPedido  		:= ""
Local cSavFil  		:= cFilAnt
Local lInverte 		:= ThisInv()
Local lLibGrupo		:= SuperGetMv("MV_LIBGRUPO")=="S"
Local lQuery   		:= .F.
Local lQuebra  		:= .F.
Local lConfirma		:= .T.
Local lExecuta 		:= .T.
Local lTxMoeda 		:= .F.
Local lAcima   		:= .F.
Local lFilDAK   	:= OsVlEntCom()<>1 .And. cTabela == "DAK"
Local lM461VTot		:= ExistBlock("M461VTOT")
Local lGeraVTot		:= .T.
Local aPvlNfs  		:= {}
Local aQuebra  		:= {}
Local aQuebra2 		:= {}
Local aQuebra3 		:= {}
Local aNfCodISS		:= {}
Local bWhile1  		:= {|| !Eof() }
Local bWhile2  		:= {|| !Eof() }
Local bWhile3  		:= {|| !Eof() }
Local lCond9		:= GetNewPar("MV_DATAINF",.F.)
Local cCategoSFW	:= "('" + StrTran(GetNewPar("MV_GARSFT", "2"),",","','") + "')"
Local cCategoHRD	:= "('" + StrTran(GetNewPar("MV_GARHRD", "1"),",","','") + "')"

#IFDEF TOP
	Local cDbMs    := ""
#ENDIF	

lCond9   := IIf(ValType(lCond9)<>"L",.F.,lCond9)

If ( lExecuta )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a data de execucao                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If GetNewPar("MV_NFCHGDT",.F.)
		If MsDate()==Date()+1
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realiza a Selecao do SC9 e da Tabela da Markbrowse se esta existir      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP     
	
		cDbMs := UPPER(TcGetDb())
	
		If ( TcSrvType()<>"AS/400" .And. cDbMs<>"POSTGRES" )
			cAuxKey := cQrySC9
			cQrySC9 := ""
			cCursor1:= "MA460PROC"
			cCursor2:= cCursor1
			cCursor3:= cCursor2
			lQuery := .T.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Montagem dos campos do SC9                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC9")
			For nCntFor := 1 To FCount()
				cQrySC9 += ","+FieldName(nCntFor)
			Next nCntFor
			Do Case
				Case "ORACLE"==Upper(TcGetDb())
					cQrySC9 := "SELECT DISTINCT /*+FIRST_ROWS*/ "+SubStr(cQrySC9,2)
				Case "CACHE"==Upper(TcGetDb())
					cQrySC9 := "SELECT "+SubStr(cQrySC9,2)
				OtherWise
					cQrySC9 := "SELECT DISTINCT "+SubStr(cQrySC9,2)
			EndCase
			cQrySC9 += ",SC9.R_E_C_N_O_ C9RECNO "
			cQrySC9 += ",SC5.R_E_C_N_O_ C5RECNO "
			cQrySC9 += ",SC6.R_E_C_N_O_ C6RECNO, SC6.C6_QTDENT, SC6.C6_QTDVEN "
			cQrySC9 += ",SE4.R_E_C_N_O_ E4RECNO "
			cQrySC9 += ",SB1.R_E_C_N_O_ B1RECNO "
			cQrySC9 += ",SB2.R_E_C_N_O_ B2RECNO "
			cQrySC9 += ",SF4.R_E_C_N_O_ F4RECNO "
			cQrySC9 += ",SF4.F4_ISS F4ISS "
			cQrySC9 += ",SC5.C5_MOEDA "
			cQrySC9 += ",SC5.C5_DATA1 "			
			cQrySC9 += cFldQry
			If ( lJunta )
				cVendedor := "1"
				For nCntfor := 1 To nNrVend
					cQrySC9 += ",SC5.C5_VEND"+cVendedor
					If SC5->(FieldPos("C5_CODRL"+cVendedor)) > 0
						cQrySC9 += ",SC5.C5_CODRL"+cVendedor
					EndIf					
					cVendedor := Soma1(cVendedor,1)
				Next nCntFor
				cQrySC9 += ",SC5.C5_TIPO,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_LOJAENT,SC5.C5_REAJUST,SC5.C5_CONDPAG,SC5.C5_INCISS,SC5.C5_TRANSP,"
				If SC5->(FieldPos("C5_CLIENT"))>0
					cQrySC9 += "SC5.C5_CLIENT,"
				EndIf
				If SC5->(FieldPos("C5_FORNISS"))>0
					cQrySC9 += "SC5.C5_FORNISS,"
				EndIf				
				If SC5->(FieldPos("C5_RECISS"))>0
					cQrySC9 += "SC5.C5_RECISS,"
				EndIf
				cQrySC9 += "SE4.E4_TIPO,SB2.B2_LOCAL "
			Else
				cQrySC9 += ",SB2.B2_LOCAL "
			EndIf
			cQrySC9 += "FROM "+RetSqlName("SC9")+" SC9 ,"
			If ( cTabela <> "SC9" )
				cQrySC9 += RetSqlName(cTabela)+" "+cTabela+","
				If ( lFilDAK )
					cQrySC9 += RetSqlName("DAI")+" DAI,"
				Endif	
			EndIf
			cQrySC9 += RetSqlName("SC5")+" SC5 ,"
			cQrySC9 += RetSqlName("SC6")+" SC6 ,"
			cQrySC9 += RetSqlName("SE4")+" SE4 ,"
			cQrySC9 += RetSqlName("SB1")+" SB1 ,"
			cQrySC9 += RetSqlName("SB2")+" SB2 ,"
			cQrySC9 += RetSqlName("SF4")+" SF4  "
			cQrySC9 += "WHERE "
			cQrySC9 += " SC9.C9_BLCRED='"+Space(Len(SC9->C9_BLCRED))+"'"
			cQrySC9 += " AND SC9.C9_BLEST='"+Space(Len(SC9->C9_BLEST))+"'"
			cQrySC9 += " AND SC9.C9_BLWMS IN('  ','05','06','07') "
			cQrySC9 += " AND SC9.C9_PEDIDO ='"+SC5->C5_NUM+"'"
			cQrySC9 += " AND SC9.C9_AGREG>='"+cAgregI+"'"
			cQrySC9 += " AND SC9.C9_AGREG<='"+cAgregF+"'"
			cQrySC9 += " AND SC9.D_E_L_E_T_=' ' "
			cQrySC9 += " AND SC5.C5_FILIAL="+IIF(lFilDAK,OsFilQry("SC5","DAI.DAI_FILPV"),"'"+xFilial("SC5")+"'")
			cQrySC9 += " AND SC5.C5_NUM=SC9.C9_PEDIDO"
			cQrySC9 += " AND SC5.C5_TRANSP>='"+cTranspI+"'"
			cQrySC9 += " AND SC5.C5_TRANSP<='"+cTranspF+"'"
			cQrySC9 += " AND SC5.D_E_L_E_T_=' '"
			cQrySC9 += " AND SC6.C6_FILIAL="+IIf(lFilDAK,OsFilQry("SC6","DAI.DAI_FILPV"),"'"+xFilial("SC6")+"'")
			cQrySC9 += " AND SC6.C6_NUM=SC9.C9_PEDIDO"
			cQrySC9 += " AND SC6.C6_ITEM=SC9.C9_ITEM"
			cQrySC9 += " AND SC6.C6_PRODUTO=SC9.C9_PRODUTO"
			cQrySC9 += " AND SC6.D_E_L_E_T_=' '"
			cQrySC9 += " AND SE4.E4_FILIAL="+IIf(lFilDAK,OsFilQry("SE4","DAI.DAI_FILPV"),"'"+xFilial("SE4")+"'")
			cQrySC9 += " AND SE4.E4_CODIGO=SC5.C5_CONDPAG "
			cQrySC9 += " AND SE4.D_E_L_E_T_=' '"
			cQrySC9 += " AND SB1.B1_FILIAL="+IIf(lFilDAK,OsFilQry("SB1","DAI.DAI_FILPV"),"'"+xFilial("SB1")+"'")
			cQrySC9 += " AND SB1.B1_COD=SC9.C9_PRODUTO"
			If cCatego == "2"
				cQrySC9 += " AND SB1.B1_CATEGO IN " + cCategoSFW
				cQrySC9 += " AND SC6.C6_XOPER = '51'"
			Else
				cQrySC9 += " AND SB1.B1_CATEGO IN " + cCategoHRD
				cQrySC9 += " AND SC6.C6_XOPER = '52'"
			Endif
			cQrySC9 += " AND SB1.D_E_L_E_T_=' '"
			cQrySC9 += " AND SB2.B2_FILIAL="+IIf(lFilDAK,OsFilQry("SB2","DAI.DAI_FILPV"),"'"+xFilial("SB2")+"'")
			cQrySC9 += " AND SB2.B2_COD=SC9.C9_PRODUTO"
			cQrySC9 += " AND SB2.B2_LOCAL=SC9.C9_LOCAL"
			cQrySC9 += " AND SB2.D_E_L_E_T_=' '"
			cQrySC9 += " AND SF4.F4_FILIAL="+IIf(lFilDAK,OsFilQry("SF4","DAI.DAI_FILPV"),"'"+xFilial("SF4")+"'")
			cQrySC9 += " AND SF4.F4_CODIGO=SC6.C6_TES"
			cQrySC9 += " AND SF4.D_E_L_E_T_=' '"

			cQrySC9 := ChangeQuery(cQrySC9)
			//MEMOWRIT("\MATA461A.SQL",cQrySC9)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC9),cCursor3,.F.,.T.)
			aEval(SC9->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cCursor3,x[1],x[2],x[3],x[4]),Nil)})
		Else
	#ENDIF
	
		If ( cTabela <> "SC9" )
			cArqBrw := CriaTrab(,.F.)
			IndRegua(cTabela,cArqBrw,(cTabela)->(IndexKey()),,cFilBrw)
			nIndBrw := RetIndex(cTabela)
			#IFNDEF TOP
				dbSetOrder(1)
				Eval(bFiltraBrw)
				nIndBrw += Len(aFiltro[5])
				dbSetIndex(cArqBrw+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndBrw+1)
			dbGotop()
		EndIf
		cArqSC9 := CriaTrab(,.F.)
		IndRegua("SC9",cArqSC9,cKeySC9,,cFilSC9)
		nIndSC9 := RetIndex("SC9")
		#IFNDEF TOP        
			If cTabela == "SC9"
				dbSetOrder(1)
				Eval(bFiltraBrw)
				nIndSC9 += Len(aFiltro[5])
			Endif	
			dbSetIndex(cArqSC9+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndSC9+1)
		dbGotop()
		#IFDEF TOP
		EndIf
		#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica as condicoes de quebra de nota fiscal                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFilDAK
		aadd(aQuebra2,{"DAI->DAI_FILPV",})
	EndIf
	If ( lJunta )
		aadd(aQuebra,{"SC9->C9_AGREG",})
		aadd(aQuebra,{"SC9->C9_CARGA",})
		aadd(aQuebra,{"SC9->C9_SEQCAR",})
		aadd(aQuebra,{"SC5->C5_TIPO",})
		aadd(aQuebra,{"SC5->C5_CLIENTE",})
		aadd(aQuebra,{"SC5->C5_LOJACLI",})
		If SC5->(FieldPos("C5_CLIENT"))>0
			aadd(aQuebra,{"SC5->C5_CLIENT",})
		EndIf
		aadd(aQuebra,{"SC5->C5_LOJAENT",})
		aadd(aQuebra,{"SC5->C5_REAJUST",})
		aadd(aQuebra,{"SC5->C5_CONDPAG",})
		aadd(aQuebra,{"SC5->C5_INCISS",})
		aadd(aQuebra,{"SC5->C5_TRANSP",})
		If SC5->(FieldPos("C5_FORNISS"))<>0
			aadd(aQuebra,{"SC5->C5_FORNISS",})
		EndIf
		cVendedor := "1"
		For nCntfor := 1 To nNrVend
			aadd(aQuebra,{"SC5->C5_VEND"+cVendedor,})
			If SC5->(FieldPos("C5_CODRL"+cVendedor))>0
				aadd(aQuebra,{"SC5->C5_CODRL"+cVendedor,})
			EndIf
			cVendedor := Soma1(cVendedor,1)
		Next nCntFor
		If SC5->(FieldPos("C5_RECISS"))>0
			aadd(aQuebra,{"SC5->C5_RECISS",})
		EndIf
	Else
		aadd(aQuebra,{"SC9->C9_CARGA",})
		aadd(aQuebra,{"SC9->C9_SEQCAR",})
		aadd(aQuebra,{"SC9->C9_AGREG",})
		aadd(aQuebra,{"SC9->C9_PEDIDO",})
	EndIf                           
	If SC9->(FieldPos("C9_CODISS")) > 0 .And. GetNewPar("MV_NFEQUEB",.F.)
		aadd(aQuebra3,{"SC9->C9_CODISS",})
	Endif
	If SC9->(FieldPos("C9_RETOPER")) > 0 .And. SB1->(FieldPos("B1_RETOPER")) > 0
		aadd(aQuebra,{"SC9->C9_RETOPER",})
	Endif
	If ( lQuery )
		aEval(aQuebra,{|x| x[1]:= SubStr(x[1],6)})
		aEval(aQuebra2,{|x| x[1]:= SubStr(x[1],6)})
		aEval(aQuebra3,{|x| x[1]:= SubStr(x[1],6)})
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa o Arquivo do Browse                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cCursor1)
	While Eval(bWhile1)
		Do Case
		Case cCursor2 == "DAI" .And. cTabela == "DAK"
			DAK->(dbSkip())
			nRecDAK := DAK->(Recno())
			DAK->(dbSkip(-1))
		
			dbSelectArea(cCursor2)
			dbSetOrder(1)
			DbSeek(xFilial("DAI")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
		Case cCursor2 == "SC9" .And. cTabela == "DAK"
		
			DAK->(dbSkip())
			nRecDAK := DAK->(Recno())
			DAK->(dbSkip(-1))
		
			If !lQuery
				dbSelectArea(cCursor3)
				dbSetOrder(nIndSC9+1)
				DbSeek(xFilial("SC9")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
			EndIf				
		EndCase
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processa a tabela vinculada ao browse                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		dbSelectArea(cCursor2)
		While Eval(bWhile2)
			If cTabela == "DAK"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a Filial nal qual deve ser gerada a Nota Fiscal de Saida       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFilDAK
					If cFilAnt <> (cCursor2)->DAI_FILPV
						cFilAnt := (cCursor2)->DAI_FILPV
						MaNFSEnd()
						MaNFSInit()
					EndIf
				EndIf
				If !lQuery
					dbSelectArea(cCursor3)
					dbSetOrder(nIndSC9+1)
					DbSeek(xFilial("SC9")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
					If cCursor2 <> cCursor3
						(cCursor2)->(dbSkip())
					EndIf
				EndIf				
			EndIf
			dbSelectArea(cCursor3)
			While Eval(bWhile3)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona Registros                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !lQuery )
					dbSelectArea("SB1")
					dbSetOrder(1)
					DbSeek(xFilial("SB1")+SC9->C9_PRODUTO)

					dbSelectArea("SC5")
					dbSetOrder(1)
					DbSeek(xFilial("SC5")+SC9->C9_PEDIDO)

					dbSelectArea("SC6")
					dbSetOrder(1)
					DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

					dbSelectArea("SB2")
					dbSetOrder(1)
					DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

					dbSelectArea("SF4")
					dbSetOrder(1)
					DbSeek(xFilial("SF4")+SC6->C6_TES)

					dbSelectArea("SE4")
					dbSetOrder(1)
					DbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
				EndIf	
				dbSelectArea(cCursor3)	
				lConfirma := .T.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza os itens de Quebra                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aEval(aQuebra,{|x| x[2] := &(x[1])})
				aEval(aQuebra2,{|x| x[2] := &(x[1])})
				aEval(aQuebra3,{|x| x[2] := &(x[1])})				
				If !Empty(aQuebra3)
					If lQuery
						If !Empty((cCursor3)->C9_CODISS)
							aAdd(aNfCodISS,(cCursor3)->C9_CODISS)
						EndIf
					Else
						If !Empty(SC9->C9_CODISS)
							aAdd(aNfCodISS,SC9->C9_CODISS)
						EndIf
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Inicializa as variaveis de quebra do SC9                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
				If lQuery
					cPedido := (cCursor3)->C9_PEDIDO
					If lJunta
						cTipo9  := (cCursor3)->E4_TIPO
					EndIf
				Else
					cPedido := SC9->C9_PEDIDO
					If lJunta
						cTipo9  := SE4->E4_TIPO
					EndIf
				EndIf					
				
				// Verifica se bloqueia faturamento quando o 1o vencto < emissao da NF
				// na cond.pgto tipo 9. MV_DATAINF(T = Bloqueia , F = Fatura)
				// Bloqueia faturamento se a moeda nao estiver cadastrada				
				If lQuery
					If ( lCond9 .And. (cCursor3)->C5_DATA1 < (dtos(Date())) .And. !Empty((cCursor3)->C5_DATA1) );
						.Or. ( xMoeda( 1, (cCursor3)->C5_MOEDA, 1, Date() ) = 0)
						lConfirma:= .F.						
					EndIf            
				Else
					If ( lCond9 .And. SC5->C5_DATA1 < Date() .And. !Empty(SC5->C5_DATA1) );
						.Or. ( xMoeda( 1, SC5->C5_MOEDA, 1, Date() ) = 0)
						lConfirma:= .F.
					EndIf
				EndIf				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetua a selecao dos registros                                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !lQuery )
					If !( SC9->C9_AGREG >= cAgregI .And. SC9->C9_AGREG <= cAgregF .And.;
							SC5->C5_TRANSP >= cTranspI .And. SC5->C5_TRANSP <= cTranspF .And.;
							IIf(cTabela=="SC9",IsMark("C9_OK",cMarca,lInverte),.T.) .And.;
							SC9->C9_BLCRED==Space(Len(SC9->C9_BLCRED)) .And.;
							SC9->C9_BLWMS$"05/06/07/  " .And.;
							SC9->C9_BLEST==Space(Len(SC9->C9_BLEST)) )
						lConfirma:= .F.
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Avalia a Expressao cCondicao                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !Empty(cCondicao) )
					If ( !(&cCondicao) )
						lConfirma := .F.
					EndIf
				EndIf
				If ( lConfirma )
					nPrcVen := C9_PRCVEN
					If ( !lQuery )
						dbSelectArea("SC5")
					EndIf
					If ( C5_MOEDA <> 1 )
						nPrcVen := a410Arred(xMoeda(nPrcVen,C5_MOEDA,1,Date(),8),"D2_PRCVEN")
					EndIf
					If ( !lQuery )
						dbSelectArea("SC9")
					EndIf
					If nPrcVen <> 0
						aadd(aPvlNfs,{ C9_PEDIDO,;
							C9_ITEM,;
							C9_SEQUEN,;
							C9_QTDLIB,;
							nPrcVen,;
							C9_PRODUTO,;
							If(lQuery,F4ISS=="S",SF4->F4_ISS=="S"),;
							If(lQuery,C9RECNO,SC9->(RecNo())),;
							If(lQuery,C5RECNO,SC5->(RecNo())),;
							If(lQuery,C6RECNO,SC6->(RecNo())),;
							If(lQuery,E4RECNO,SE4->(RecNo())),;
							If(lQuery,B1RECNO,SB1->(RecNo())),;
							If(lQuery,B2RECNO,SB2->(RecNo())),;
							If(lQuery,F4RECNO,SF4->(RecNo())),;
							If(lQuery,B2_LOCAL,SB2->B2_LOCAL),;
							If(cTabela<>"DAK",0,If(lQuery,DAKRECNO,DAK->(RecNo()))),;
							C9_QTDLIB2})
					Else
						lTxMoeda := .T.
					EndIf
				EndIf
				dbSelectArea(cCursor3)
				dbSkip()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona Registros                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !lQuery )
					dbSelectArea("SB1")
					dbSetOrder(1)
					DbSeek(xFilial("SB1")+SC9->C9_PRODUTO)

					dbSelectArea("SC5")
					dbSetOrder(1)
					DbSeek(xFilial("SC5")+SC9->C9_PEDIDO)

					dbSelectArea("SC6")
					dbSetOrder(1)
					DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

					dbSelectArea("SB2")
					dbSetOrder(1)
					DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

					dbSelectArea("SF4")
					dbSetOrder(1)
					DbSeek(xFilial("SF4")+SC6->C6_TES)

					dbSelectArea("SE4")
					dbSetOrder(1)
					DbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a quebra                                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lQuebra := .F.
				If ( aScan(aQuebra,{|x| If(x[2] <> Nil,&(x[1])<>x[2],.F.) }) <> 0 )				
					lQuebra := .T.
				ElseIf ( aScan(aQuebra2,{|x| If(x[2] <> Nil,&(x[1])<>x[2],.F.) }) <> 0 )
					lQuebra := .T.
				ElseIf ( aScan(aQuebra3,{|x| If(x[2] <> Nil,&(x[1])<>x[2].And.!Empty(&(x[1])).And.!Empty(x[2]),.F.) }) <> 0 ) .Or.;
				       ( If(!Empty(aNfCodISS).And.!Empty(If(lQuery,(cCursor3)->C9_CODISS,SC9->C9_CODISS)),aScan(aNfCodISS,If(lQuery,(cCursor3)->C9_CODISS,SC9->C9_CODISS)) == 0,.F.) )
					//Quando nao for NF Conjugada faz a quebra pelo codigo do ISS
					aNfCodIss:= {}
					lQuebra  := .T.
				EndIf

				If ( lJunta )
					If ( !lQuery )
						dbSelectArea("SE4")
					EndIf
					If ( E4_TIPO=="9" .Or. cTipo9=="9" )
						If cPedido <> (cCursor3)->C9_PEDIDO
							lQuebra := .T.
						EndIf
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetua a Geracao da Nfs                                                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cCursor3)
				If ( lQuebra .Or. ( !Eval(bWhile3) .And. !Eval(bWhile2) ) )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica a quebra por numero de itens de nota fiscal                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aEval(aPvlNfs,{|x| nTotal += a410Arred(If(x[4]<>0,x[4],1)*x[5],"D2_TOTAL")})
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ponto de entrada para verificar o valor total da nota                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lM461VTot
						lGeraVTot := ExecBlock("M461VTOT",.F.,.F.,{nTotal,aPvlNfs[Len(aPvlNfs),11]})
						If ValType(lGeraVTot) <> "L"
							lGeraVTot := .T.
						Endif	
					Endif	
		
					If ( nTotal > nFatMin .And. !Empty(aPvlNfs) .And. lGeraVTot )
						dbSelectArea("SC9")
						cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)						
					EndIf
					nTotal  := 0
					aPvlNfs := {}
					aNfCodISS:= {}					
				EndIf
				dbSelectArea(cCursor3)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Controle de cancelamento do usuario                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lEnd
					Exit
				EndIf
			EndDo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Controle de cancelamento do usuario                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If lFilDAK
				cFilAnt := cSavFil
			Endif	
			
			If lEnd
				Exit
			EndIf			
		EndDo
		If ( cCursor1 <> cCursor2 )
			If (cCursor2 == "DAI" .Or. cCursor2 == "SC9") .And. cTabela == "DAK"
				dbSelectArea("DAK")
				DAK->(MSGoTo(nRecDAK))
			Else
				dbSelectArea(cCursor1)
				dbSkip()
			Endif	
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Controle de cancelamento do usuario                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lEnd
			Exit
		EndIf
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a entrada da rotina                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( lQuery )
		dbSelectArea(cCursor3)
		dbCloseArea()
		dbSelectArea("SC9")
	Else
		RetIndex("SC9")
		dbClearFilter()
		FErase(cArqSC9+OrdBagExt())
		If cTabela <> "SC9"
			RetIndex(cCursor1)
			dbClearFilter()
			FErase(cArqBrw+OrdBagExt())
		EndIf
		Eval(bFiltraBrw)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cSavFil
RestArea(aAreaSC9)
RestArea(aArea)
Return(cNota)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa330Comp³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 18/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca‡„o dos titulos para compensa‡„o					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa330Comp() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fA330Comp(cAlias,cCampo,nOpcE,oDlgPae,cLoteFat,cOrigem,aNumLay)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local nValorComp	:= 0
Local nSeq			:= 0
Local nValBX		:= 0			// Valor da baixa na moeda 1
Local nValBX2		:= 0			// Valor da baixa na moeda do tit principal
Local nX
Local cAdiantamento
Local cDadosTitulo
Local cArquivo
Local cPadrao	:= "596"
Local lContabil	:= .F.
Local lPadrao
Local lDigita
Local dEmissao	:= SE1->E1_EMISSAO
Local lMarcado	:= .F.
Local aBaixas	:= {}
Local nTotAbat	:= 0
Local nTotAbtIni	:= 0		//Abatimento do titulo de Partida
Local nTitIni	:= SE1->(Recno())
Local nDecs		:= 2
Local nSalTit	:= 0
Local nDecs1	:= MsDecimais(1)
Local cVarQ		:= "  "
Local lFa330Cmp	:= ExistBlock( "FA330CMP" )
Local nSldReal	:= 0
Local nLinha	:= 0
Local nTit		:= 0
Local nA		:= 0
Local cKeyAbt	:= ""
Local nSe1Rec	:= 0
Local nAcresc	:= 0
Local nDecres	:= 0
Local nIndexAtu	:= SE1->(IndexOrd())
Local nVlrCompe // Criadaa para exibir o conteudo do Help correto quando o usuario
// pressionar F1 sobre o campo
Local lDeleted	:= .F.
Local lfa330Bx	:= Existblock("FA330BX")
Local aArea		:={}
Local lVldDtFin	:= .T.
Local aDiario	:= {}
Local nTotComp	:= 0
Local nValComp	:= 0
Local nValPre	:= 0

Default cOrigem :=""
DEFAULT aNumLay := {}

PRIVATE aTitulos	:={}
PRIVATE aRecNo 		:= {}
PRIVATE aRegSE1 	:= {}
PRIVATE aBaixaSE5 	:= {}
PRIVATE	cPrefixo 	:= SE1->E1_PREFIXO
PRIVATE	cNum		:= SE1->E1_NUM
PRIVATE	cTipoTit 	:= SE1->E1_TIPO
PRIVATE	cCliente 	:= SE1->E1_CLIENTE
PRIVATE	cLoja 		:= SE1->E1_LOJA
PRIVATE	cSaldo		:= CriaVar("E1_SALDO")
PRIVATE	nValor		:= CriaVar("E1_SALDO")
PRIVATE	cParcela 	:= SE1->E1_PARCELA
PRIVATE	nMoeda		:= SE1->E1_MOEDA
PRIVATE	dBaixa		:= Date()
PRIVATE	nValTot		:= 0
PRIVATE	nSeqBx 		:= 0
PRIVATE	nPosSaldo	:=0
PRIVATE	nPosValor	:=0
PRIVATE	cBanco		:= Criavar("E1_PORTADO")
Private lCredito 	:= .F.
Private nPosATit 	:= 0
Private aRLocks		:= {}
Private cLote		:= ""

nVlrCompe	:= nValor

If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .or. cOrigem =="MATA465"
	lCredito := .T.
Endif

If !FA330Lock(,SE1->(Recno()))
	Return
Endif

aArea:=GetArea()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se vier do mata465 ou da LOCXNF, forca os valores dos parametros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("FIN330",.F.)
MV_PAR01 := 1 				// Considera Loja  Sim/Nao
MV_PAR02 := 1 				// Considera Cliente Original/Outros
MV_PAR03 :=	SE1->E1_CLIENTE // Do Cliente
MV_PAR04 :=	SE1->E1_CLIENTE // Ate Cliente
MV_PAR05 := 2				// Compensa Titulos Transferidos S/[N]
MV_PAR06 := 2				// Calcula Comissao sobre valores de NCC
MV_PAR07 := 2				// Mostra Lancto Contabil
MV_PAR08 := 2				//Considera abatimentos para compensar
MV_PAR09 := 2				// Contabiliza On-Line
MV_PAR10 := 2				//Considera Filiais abaixo
MV_PAR11 := "  " 			//Filial De
MV_PAR12 := "zz"			//Filial Ate
MV_PAR13 := 2				// Calcula Comissao sobre valores de RA
MV_PAR14 := 2				// Reutiliza taxas informadas

RestArea(aArea)

If ExistBlock("F330DTFIN")
	lVldDtFin := ExecBlock("F330DTFIN",.F.,.F.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVldDtFin .and. !DtMovFin()
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permite que t¡tulos j  baixados possam ser acessados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SE1->E1_SALDO == 0
//	Help(" ",1,"FA330JABAI")
	Return (.T.)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos provisorios nao sao compensaveis como titulo principal.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoTit $ MVPROVIS
	// Help(" ",1,"NOCMPPROV",,STR0042+chr(13)+STR0043,1,0 )   //"Nao é permitida a compensacao a partir de"###"um titulo provisorio"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(nIndexAtu)
	DeleteObject(oOk)
	DeleteObject(oNo)
	FA330aUnlock()
	Return (.T.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura aTxMoedas         ³
//³ [1] -> Nome Moeda          	³
//³ [2] -> Taxa a Ser Utilizada	³
//³ [3] -> Picture          	³
//³ [4] -> Taxa do dia atual    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("aTxMoedas") <> "A"  .Or. MV_PAR14 == 2
	aTxMoedas:={}
EndIf

If Len(aTxMoedas) == 0
	Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1"),1})
	
	For nA := 2	To MoedFin()
		cMoedaTx :=	Str(nA,IIf(nA <= 9,1,2))
		If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
			nVlMoeda := RecMoeda(Date(),nA)
			Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),nVlMoeda,PesqPict("SM2","M2_MOEDA"+cMoedaTx),nVlMoeda })
		Else
			Exit
		Endif
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoIniLan("000016")

While .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo a ser compensado			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpca  :=0
	nTotAbtIni := SumAbatRec(cPrefixo,cNum,cParcela,SE1->E1_MOEDA,"S",dBaixa)
	If mv_par08 == 1
		nSaldo := (SE1->E1_SALDO - nTotAbtIni + SE1->E1_SDACRES - SE1->E1_SDDECRE)
	ELSE
		nSaldo := SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE
	Endif
	nRecno := SE1->(Recno())
	
	cDadostitulo := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	
	cPrefixo	:= SE1->E1_PREFIXO
	cNum		:= SE1->E1_NUM
	cParcela	:= SE1->E1_PARCELA
	cTipoTit	:= SE1->E1_TIPO
	cCliente	:= SE1->E1_CLIENTE
	cLoja		:= SE1->E1_LOJA
	nVlrCompe	:= SE1->E1_SALDO
	dBaixa		:= Date()	
	
	nValor	:= nVlrCompe
	nValPre	:= nVlrCompe
	
	//SE1->( DbSetOrder(23) )		// E1_FILIAL+E1_PEDGAR+E1_TIPO
	
	SE1->(DbOrderNickName("SE1_23"))//Alterado por LMS em 03-01-2013 para virada
	SE1->( DbSeek( xFilial("SE1")+SC5->C5_CHVBPAG ) )
	While	SE1->( !Eof() ) .AND.;
			SE1->E1_FILIAL == xFilial("SE1") .AND.;
			SE1->E1_PEDGAR == SC5->C5_CHVBPAG
		
		If AllTrim(SE1->E1_TIPO) == "RA" .OR. SE1->E1_SALDO == 0
			SE1->( DbSkip() )
			Loop
		Endif
			
		If SE1->E1_SALDO < nValPre
			nValComp := SE1->E1_SALDO
			nValPre  := nValPre - SE1->E1_SALDO
		Else
			nValComp := nValPre
		Endif
		
		aAdd( aTitulos, {	SE1->E1_PREFIXO,;
							SE1->E1_NUM,;
							SE1->E1_PARCELA,;
							SE1->E1_TIPO,;
							SE1->E1_LOJA,;
							Transform(xMoeda(SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE- Iif(  Type("nTotAbat") <> "N" ,0,nTotAbat),SE1->E1_MOEDA,nMoeda,,5,Fa340TxMd(SE1->E1_MOEDA,0),Fa340TxMd(nMoeda,0)),"@E 9999,999,999.99"),;
							Transform(nValComp,"@E 9999,999,999.99"),;
							.T.,;
							nValComp,;
							Transform(xMoeda(SE1->E1_SDACRES,SE1->E1_MOEDA,nMoeda,,5,Fa340TxMd(SE1->E1_MOEDA,0),Fa340TxMd(nMoeda,0)),"@E 9999,999,999.99"),;
							Transform(xMoeda(SE1->E1_SDDECRE,SE1->E1_MOEDA,nMoeda,,5,Fa340TxMd(SE1->E1_MOEDA,0),Fa340TxMd(nMoeda,0)),"@E 9999,999,999.99"),;
							SE1->E1_HIST,; 
							SE1->E1_FILIAL} )
		aAdd( aRecNo, SE1->(RecNo()) )
		
		nTotComp += nValComp
		If nTotComp >= nVlrCompe
			Exit
		Endif
		
		SE1->( DbSkip() )
	End
	
	If Len(aTitulos) == 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recupera a Integridade dos dados	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		dbSetOrder(nIndexAtu)
		dbGoTo(nTitIni)
		
		FA330aUnlock()
		
		Return(.F.)
	Endif
	
	nOpcA := 1
	If nOpcA == 1
		If lFa330Cmp
			ExecBlock("FA330Cmp",.F.,.F.)
		Endif
		nValTot := 0
		For nX:=1 to Len(aTitulos)
			If aTitulos[nX,8]
				nValtot+=Fa330VTit(aTitulos[nX,7])
			Endif
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Vlr. Informado e'igual ao calculado.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Str(nValtot,17,2) != Str(nValor,17,2) .and. nValor != 0;
			.and. nOpca == 1
			// Help(" ",1,"FA330COMP")
			Return(.F.)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Vlr. Informado e'compativel com o Saldo.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nValor := nValTot
		If Str(nValor,17,2) > Str(nSaldo,17,2)
			// Help(" ",1,"FA330IVAL")
			Return(.F.)
		EndIf
		DbSelectArea("SE1")
		nOrdSE1	:= IndexOrd()
		dbGotop()
		lPadrao:=VerPadrao(cPadrao)
		VALOR := 0
		ABATIMENTO := 0
		aRegSE1 := {}
		aBaixaSE5 := {}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio da prote‡„o via TTS								  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
		For nTit := 1 to Len(aTitulos)
			nPosATit := nTit  // Variavel de posicao do titulo no array
			If aTitulos[nTit,8]
				lMarcado := .T.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso o titulo esteja selecionado para compensa‡„o...    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF lMarcado
				lMarcado := .F.
				IF lPadrao .and. !lContabil .and. mv_par09 == 1
					nTotal := 0
					lContabil := .t.
					nHdlPrv:=HeadProva(cLote,"FINA330",Substr(cUsuario,7,6),@cArquivo)
				Endif
				dbSelectArea("SE1")
				dbGoTo(aRecNo[nTit])
				aAdd(aRegSE1, aRecNo[nTit])
				cAdiantamento := E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_LOJA
				If (SE1->E1_TIPO == MV_CRNEG) .and. (SE1->E1_SALDO > aTitulos[nTit,9]) .AND. ((aTitulos[nTit,9]+nTotAbtIni) == F330SldPri(nRecNo))
					aTitulos[nTit,9] := aTitulos[nTit,9] + nTotAbtIni
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valor da baixa na moeda 1 							  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					nValBx := aTitulos[nTit,9]
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,10])
						nDecres := Fa330VTit(aTitulos[nTit,11])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif
				Else
					nValBx := Fa330VTit(aTitulos[nTit,7])
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,11])
						nDecres := Fa330VTit(aTitulos[nTit,12])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif
				Endif
				IF lPadrao
					If cPaisLoc == "BRA"
						nValorComp += Round(NoRound(xMoeda(nValBX,nMoeda,1,,3,Fa340TxMd(nMoeda,0)),3),2)
					Else
						nValorComp += xMoeda(nValBX,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])
					EndIf
				EndIf
				dbSelectArea("SE1")
				dbGoTo(nRecNo)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Guardo dados do titulo principal para utilizar   ³
				//³ no historico da contabiliza‡Æo                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				STRLCTPAD := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valor da Baixa na moeda do titulo principal 	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					nValBx2 := aTitulos[nTit,9]
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,10])
						nDecres := Fa330VTit(aTitulos[nTit,11])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif
				Else
					nValBx2 := Fa330VTit(aTitulos[nTit,7])
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,11])
						nDecres := Fa330VTit(aTitulos[nTit,12])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif
				Endif
				
				Fa330Grv(lPadrao,nValBx2,cAdiantamento,StrZero(nSeq,2),aRecno[nTit],@aBaixas,cOrigem,lCredito,mv_par09,nAcresc,nDecres,aBaixaSE5,nTotAbtIni)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no adiantamento para contabiliza‡„o    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE1")
				dbGoTo(aRecNo[nTit])
				If lCredito .and. mv_par08 == 1
					nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE)
				Else
					nTotAbat := 0
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Acerta o saldo do adiantamento	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Reclock("SE1")
				If cPaisLoc == "BRA"
					If nValBx == Fa330VTit(aTitulos[nTit,6])
						SE1->E1_SALDO := 0
						SE1->E1_SDACRES := 0
						SE1->E1_SDDECRE := 0
					Else
						SE1->E1_SALDO	-= Round(Noround(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE1->E1_MOEDA,,3,Fa340TxMd(nMoeda,0),Fa340TxMd(SE1->E1_MOEDA,0)),3),2)
						SE1->E1_SDACRES	-= Round(Noround(xMoeda(nAcresc               ,nMoeda,SE1->E1_MOEDA,,3,Fa340TxMd(nMoeda,0),Fa340TxMd(SE1->E1_MOEDA,0)),3),2)
						SE1->E1_SDDECRE	-= Round(Noround(xMoeda(nDecres               ,nMoeda,SE1->E1_MOEDA,,3,Fa340TxMd(nMoeda,0),Fa340TxMd(SE1->E1_MOEDA,0)),3),2)
					Endif
					SE1->E1_VALLIQ := nValBx
					If STR(SE1->E1_SALDO,17,2) == STR(nTotAbat,17,2)
						SE1->E1_SALDO := 0
					Endif
					SE1->E1_MOVIMEN:= Date()
				Else
					If nValBx == Fa330VTit(aTitulos[nTit,6])
						SE1->E1_SALDO := 0
						SE1->E1_SDACRES := 0
						SE1->E1_SDDECRE := 0
					Else
						nDecs := MsDecimais(SE1->E1_MOEDA)
						nSalTit := SE1->E1_SALDO - Round(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE1->E1_MOEDA,Date(),nDecs+1,aTxMoedas[nMoeda][2],aTxMoedas[SE1->E1_MOEDA][2]),nDecs)
						SE1->E1_SALDO   := Iif(nSalTit <= 0,0,nSalTit)
					EndIf
					SE1->E1_MOVIMEN := Date()
					SE1->E1_VALLIQ  += Round(xMoeda(nValBx-nAcresc+nDecres,nMoeda,1,Date(),nDecs1+1,aTxMoedas[nMoeda][2]),nDecs1)
				EndIf
				SE1->E1_BAIXA := dBaixa
				SE1->E1_STATUS:= IIF(SE1->E1_STATUS != "R",Iif(SE1->E1_SALDO > 0.01,"A","B"),"R")
				MsUnlock()
				nSE1Rec := SE1->(Recno())
				cKeyAbt := SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
				// Efetua a baixa dos titulos de abatimento
				If lCredito .AND. SE1->E1_SALDO - nTotAbat <= 0   //Se nao for titulo de adiantamento
					If Select("__SE1") == 0
						SumAbatRec("","","",1,"")
					Endif
					dbSelectArea("__SE1")
					__SE1->(dbSetOrder(2))
					__SE1->(dbSeek(xFilial("SE1")+cKeyAbt))
					While !EOF() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA==xFilial("SE1")+cKeyAbt
						IF E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+;
							MVCFABT+"/"+MVCSABT
							RecLock("__SE1")
							Replace E1_SALDO	  With 0
							Replace E1_BAIXA	  With If(E1_BAIXA <= dBaixa, dBaixa, E1_BAIXA)
							Replace E1_STATUS   With "B"
						EndIF
						dbSkip()
					Enddo
					__SE1->(dbSetOrder(1))
				Endif
				dbSelectArea("SE1")
				dbGoto(nSE1Rec)
				VALOR2 := 0
				VALOR3 := 0
				VALOR4 := 0
				VALOR5 := 0
				VALOR6 := 0
				
				If lCredito
					VALOR2 := SE1->E1_IRRF
					VALOR3 := SE1->E1_PIS
					VALOR4 := SE1->E1_COFINS
					VALOR5 := SE1->E1_CSLL
					VALOR6 := SE1->E1_INSS
				Endif
				
				IF lPadrao .and. mv_par09 == 1
					nTotal+=DetProva(nHdlPrv,cPadrao,"FINA330",cLote)
				Endif
				
				VALOR2 := 0
				VALOR3 := 0
				VALOR4 := 0
				VALOR5 := 0
				VALOR6 := 0
				
				dbSelectArea ("SE1")
				dbSetOrder(1)
				If lfa330Bx
					Execblock("FA330BX",.f.,.f.)
				Endif
			Endif
		Next
		nRegSE5 := SE5->(Recno())
		nRegSE1 := SE1->(Recno())
		/*
		If GetMv("MV_COMISCR") == "S" .and. GetMv("MV_TPCOMIS") == "O"
			dbSelectArea("SE1")
			dbSetOrder(2)
			dbGoto(nRecNo)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se calcula comissao sobre valores       ³
			//³ de NCC ou RA que compuseram a compenca‡Æo Receb. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par06 == 2 .Or. mv_par13 == 2
				For nLinha:= Len(aBaixas) to 1 Step -1
					lDeleted := .F.
					// Verifica se ha a 5 dimensao na matriz de valores baixados
					If Len(aBaixas[nLinha][1]) >= 5
						If mv_par06 == 2
							If MV_CRNEG $ SubStr(aBaixas[nLinha][1][5],nTamTit+1,nTamTip)
								ADEL(aBaixas,nLinha)
								ASIZE(aBaixas,Len(aBaixas)-1)
								lDeleted := .T.
							Endif
						Endif
						If mv_par13 == 2 .And. !lDeleted
							If MVRECANT $ SubStr(aBaixas[nLinha][1][5],nTamTit+1,nTamTip)
								ADEL(aBaixas,nLinha)
								ASIZE(aBaixas,Len(aBaixas)-1)
							Endif
						Endif
					Endif
				Next
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula comissao, se houver vendedor		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aBaixas) > 0
				AeVal(aBaixas,{|x|Fa440CalcB(x,.F.,.F.,"FINA070")})
			EndIf
		Endif
		*/
		
		If lPadrao .and. mv_par09 == 1
			VALOR2 := SE1->E1_IRRF
			VALOR3 := SE1->E1_PIS
			VALOR4 := SE1->E1_COFINS
			VALOR5 := SE1->E1_CSLL
			VALOR6 := SE1->E1_INSS
			
			SE5->(dbGoBottom())
			SE5->(dbSkip())
			SE1->(dbGoBottom())
			SE1->(dbSkip())
			VALOR := nValorComp
			nSldReal := Round(NoRound(xMoeda(nSaldo,nMoeda,1,,3,Fa340TxMd(nMoeda,0)),3),2)
			ABATIMENTO := IIF(STR(nSldReal,17,2) == STR(nValorComp,17,2),nTotAbat,0)
			REGVALOR := nRecno		// Variavel para usu rio reposicionar o registro do RA
			nTotal+=DetProva(nHdlPrv,cPadrao,"FINA330",cLote)
			RodaProva(nHdlPrv,nTotal)
			
			If cPaisLoc == 'PTG'
				For nX := 1 To Len(aBaixaSE5)
					AAdd(aDiario,{"SE5",aBaixaSE5[nX],cCodDiario,"E5_NODIA","E5_DIACTB"})
				Next nX
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDigita := IIF( mv_par07 == 1,.t., .f. )
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.,,,,,,aDiario)
			
			VALOR  := 0
			VALOR2 := 0
			VALOR3 := 0
			VALOR4 := 0
			VALOR5 := 0
			VALOR6 := 0
			
		Endif
		SE5->(dbGoTo(nRegSE5))
		SE1->(dbGoTo(nRegSE1))
		
		//integracao com modulo PCO
		Fa330IntPco(nRecno, aRegSE1, aBaixaSE5)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Final  da protecao via TTS	                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		End Transaction
		
	Endif
	Exit
EndDo

cPrefixo := CriaVar("E1_PREFIXO")
cNum		:= CriaVar("E1_NUM")
cTipoTit := CriaVar("E1_TIPO")
cCliente := CriaVar("E1_CLIENTE")
cLoja 	:= CriaVar("E1_LOJA")
cSaldo	:= CriaVar("E1_SALDO")
nValor	:= CriaVar("E1_SALDO")
cParcela := CriaVar("E1_PARCELA")
nMoeda	:= 1
nValor	:= 0
nValTot	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoFinLan("000016")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(nIndexAtu)
dbGoTo(nTitIni)

FA330aUnlock()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA330Lock(cChave,nRecno,lHelp,cfilOrig)

Local aArea		:= {}
Local lRet		:= .F.                           

DEFAULT lHelp	:=	.F.
   
If nRecno <> Nil             
	SE1->(MsGoto(nRecno))
Else                               
	aArea	:=	getArea()
	SE1->(DbSetOrder(1))
	SE1->(DbSeek(cfilorig+cChave))
Endif                         
	
	
If SE1->(MsRLock())
	AAdd(aRLocks, SE1->(Recno()))
	lRet	:=	.T.
ElseIf lHelp                                       
	
//	MsgAlert(STR0060)

Endif	
If Len(aArea) > 0
	RestArea(aArea)
Endif	

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa330IntPco ºAutor ³Paulo Carnelossi    º Data ³  22/11/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³funcao que gera os lancamentos no sigapco (PcoDetLan())     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fa330IntPco(nRecSE1, aRecnoSE1, aBaixasSE5)
Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local nX

If SuperGetMV("MV_PCOINTE",.F.,"2")=="1"

	dbSelectArea("SE1")
	dbGoto(nRecSE1) //titulo principal apos a compensacao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava lançamento no PCO ref titulo principal apos a compensacao    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PCODetLan("000016","01","FINA330")
	
	For nX := 1 TO Len(aRecnoSE1) // ARRAY COM REGISTROS TITULOS COMPENSADOS
	
		//grava lcto ref. titulo compensado
		dbSelectArea("SE1")	
		dbGoto(aRecnoSE1[nX])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref titulo compensado apos a compensacao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000016","02","FINA330")
	
		//grava lctos das baixas referente titulo principal e titulo compensado
		dbSelectArea("SE5")
		
		dbGoto(aBaixasSE5[(nX*2)-1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref baixa (Mov.Bancaria-SE5) do titulo principal apos a compensacao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000016","03","FINA330")
	
		dbGoto(aBaixasSE5[(nX*2)])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref baixa do titulo compensado (Mov.Bancaria-SE5)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000016","04","FINA330")
	
	Next

EndIf
	
RestArea(aAreaSE5)
RestArea(aAreaSE1)
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA330aUnlock()
AEval(aRLocks,{|x,y| SE1->(MsRUnlock(x))})  
aRLocks:={}
Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330VTit ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 22/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo ou valor do titulo a ser compensado		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina330													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function Fa330VTit(aTitulo,cTipoTit,cValor)
LOCAL nValor
cValor := IIF (cValor == NIL,aTitulo,cValor)	
nValor := DesTrans(cValor)
Return nValor


/*
Encapsulamento para retornos de processo
Um processo do ERP pode ter mais de um retorno
cada retorno "aRet" é empilhado, com um tipo de operacao realizada
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Acrescenta um status de retorno de processamento
User Function AddProcStat(cTipo,aTmpRet)
aadd(__ProcStat,{ cTipo , aclone(aTmpRet) }  )
Return 

// Retorna clone do array de retornos
User Function GetProcStat()
Return aclone(__ProcStat)

// Reseta array de retornos para novo processamento
User Function ResetStat()
__ProcStat := {}
Return


Static Function WaitTime(nSecs)
Local nX

For nX := 1 to nSecs
//	Mystatus("Aguardando ... "+str(nX,2))
	Sleep(1000)
Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Microsiga           º Data ³  03/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MakeMens(cProGar,nQtdVen,nPrcVen,cCartao,cPedBpag)

Local cMensagem := ""
Local cDescri	:= ""
Local nValor	:= nQtdVen * nPrcVen
Local cTipoProd := ""

PA8->( DbSetOrder(1) )
PA8->( DbSeek( xFilial("PA8")+cProGar ) )

SB1->( DbSetOrder(1) )
SB1->( DbSeek( xFilial("SB1")+PA8->PA8_CODMP8 ) )

cTipoProd	:= SB1->B1_TIPO
cDescri		:= SB1->B1_DESC

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Trata o Nome da Operadora de Cartao de Credito                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cCartao 	:= IIF( cCartao=='AME', "Amex",			cCartao)
cCartao 	:= IIF( cCartao=='RED', "Mastercard",	cCartao)
cCartao 	:= IIF( cCartao=='VIS', "Visa",			cCartao)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Processo de Montagem de Mensagem, para SC5 com base no Produto      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If cTipoProd <> "MR"
	//29/06/20 - Removida descrição do produto - Jira PROT-52
	//cMensagem:= AllTrim(cDescri) + ";"
	cMensagem:= Space(1) + "Qtde:"
	cMensagem+= Space(1) + AllTrim(Transform(nQtdVen, "@E 999,999,999.99")) + ";"
	cMensagem+= Space(1) + "Preço Unitário:"
	cMensagem+= Space(1) + AllTrim(Transform(nPrcVen, "@E 999,999,999.99")) + ";"
	cMensagem+= Space(1) + "Valor Total:"
	cMensagem+= Space(1) + AllTrim(Transform(nValor,  "@E 9,999,999,999.99")) + ";"
	cMensagem+= Space(1) + "NF Liquidada - Pedido Bpag: " + cPedBpag
Else
	cMensagem:= "NF Liquidada - Pedido Bpag: " + cPedBpag 			// + " Pgto Cartao: " + cCartao
Endif

If !Empty(cCartao)
	cMensagem+= "Pgto Cartao: " + cCartao
Endif

Return(cMensagem)



/* --------------------------------------------------------------------------
Casca para lock de numero de pedido GAR para processo
Atualmente utiliza license Server, com lockbyname
-------------------------------------------------------------------------- */

USER Function GarCliLock(cCodCli)
Return LockByName("GARCLI_"+Alltrim(cCodCli))

USER Function GarCliUnlock(cCodCli)
UnLockByName("GARCLI_"+Alltrim(cCodCli))
Return


/* --------------------------------------------------------------------------
Descasca a transacao gerada pelos pacotes enviados pelo GAR e elimina todos
os registros do banco para que este pedido possa ser reenviado ao Webservices.
-------------------------------------------------------------------------- */
Static Function RollBackGAR(cChvBPag)

Local cPedido		:= SC5->C5_NUM
Local cQuery		:= ""
Local lOk	 		:= .T.

Default cChvBPag	:= ""

// Fecha todas as transacoes que estiverem aberta fazendo commit ... 
If InTransact()
	EndTran()
Endif

// Se a chave veio em branco eh porque jah estou posicionado no registro do SC5 referente ao pedido do GAR.
If !Empty(cChvBPag)
	// Reposiciona o pedido de vendas para garantir que estamos falando do mesmo pedido

	//SC5->( DbSetOrder(5) )		// C5_FILIAL + C5_CHVBPAG
	SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
	SC5->( DbSeek( xFilial("SC5")+cChvBPag ) )
	cPedido  := SC5->C5_NUM
	cChvBPag := SC5->C5_CHVBPAG
Else
	cPedido  := SC5->C5_NUM
	cChvBPag := SC5->C5_CHVBPAG
Endif


// VERIFICA SE TEM ALGUMA NOTA EMITIDA PARA ESTE PEDIDO ENTES DE EFETUAR O ROLLBACK
// SE TIVER NOTA EMITIDA NAO PODE FAZER ROLLBACK PORQUE VAI DEIXAR BURACO NA SEQUENCIA
// TAMBEM NAO PODE EXCLUIR UMA NOTA PORQUE ELA PODE TER SIDO ENVIADA AO SEFAZ.
cQuery	:=	" SELECT  COUNT(*) QTDSC9 " +;
			" FROM    " + RetSQLName("SC9") +;
			" WHERE   C9_FILIAL = '" + xFilial("SC9") + "' AND " +;
			"         C9_PEDIDO = '" + cPedido + "' AND " +;
			"         C9_NFISCAL <> ' ' AND " +;
			"         D_E_L_E_T_ = ' ' "

PLSQuery( cQuery, "SC9TMP" )
lOk := (SC9TMP->QTDSC9 == 0)
SC9TMP->( DbCloseArea() )

If !lOk
	Return(.F.)
Endif


// Verifica se tem movimento bancario para eliminar
cQuery	:=	" SELECT  R_E_C_N_O_ " +;
			" FROM    " + RetSQLName("SE5") +;
			" WHERE   E5_FILIAL = '" + xFilial("SE5") + "' AND " +;
			"         E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO IN ( " +;
			"         SELECT  E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO " +;
			"         FROM    " + RetSQLName("SE1") +;
			"         WHERE   E1_FILIAL = '" + xFilial("SE1") + "' AND " +;
			"                 E1_PEDGAR = '"+cChvBPag+"' AND " +;
			"                 D_E_L_E_T_ = ' ' ) AND " +;
			"         D_E_L_E_T_ = ' ' "

PLSQuery( cQuery, "SE5TMP" )
SE5TMP->( DbGoTop() )

While SE5TMP->( !Eof() )
	
	SE5->( DbGoTo( SE5TMP->R_E_C_N_O_ ) )
	
	SE5->( RecLock("SE5",.F.) )
	SE5->( DbDelete() )
	SE5->( MsUnLock("SE5") )
	
	SE5TMP->( DbSkip() )
End
SE5TMP->( DbCloseArea() )


// Verifica se tem titulos no financeiro para eliminar
cQuery	:=	" SELECT  R_E_C_N_O_ " +;
			" FROM    " + RetSQLName("SE1") +;
			" WHERE   E1_FILIAL = '" + xFilial("SE1") + "' AND " +;
			"         E1_PEDGAR = '"+cChvBPag+"' AND " +;
			"         D_E_L_E_T_ = ' ' "

PLSQuery( cQuery, "SE1TMP" )
SE1TMP->( DbGoTop() )

While SE1TMP->( !Eof() )
		
	SE1->( DbGoTo( SE1TMP->R_E_C_N_O_ ) )
	
	SE1->( RecLock("SE1",.F.) )
	SE1->( DbDelete() )
	SE1->( MsUnLock("SE1") )
	
	SE1TMP->( DbSkip() )
End
SE1TMP->( DbCloseArea() )


// Verifica se tem itens no pedido de vendas para eliminar
cQuery	:=	" SELECT  R_E_C_N_O_ " +;
			" FROM    " + RetSQLName("SC6") +;
			" WHERE   C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
			"         C6_NUM = '"+cPedido+"' AND " +;
			"         D_E_L_E_T_ = ' ' "

PLSQuery( cQuery, "SC6TMP" )
SC6TMP->( DbGoTop() )

While SC6TMP->( !Eof() )
	
	SC6->( DbGoTo( SC6TMP->R_E_C_N_O_ ) )
	
	SC6->( RecLock("SC6",.F.) )
	SC6->( DbDelete() )
	SC6->( MsUnLock("SC6") )
	
	SC6TMP->( DbSkip() )
End
SC6TMP->( DbCloseArea() )


// Verifica se tem cabecalho do pedido de vendas para eliminar
cQuery	:=	" SELECT  R_E_C_N_O_ " +;
			" FROM    " + RetSQLName("SC5") +;
			" WHERE   C5_FILIAL = '" + xFilial("SC5") + "' AND " +;
			"         C5_NUM = '"+cPedido+"' AND " +;
			"         D_E_L_E_T_ = ' ' "

PLSQuery( cQuery, "SC5TMP" )
SC5TMP->( DbGoTop() )

While SC5TMP->( !Eof() )
	
	SC5->( DbGoTo( SC5TMP->R_E_C_N_O_ ) )
	
	SC5->( RecLock("SC5",.F.) )
	SC5->( DbDelete() )
	SC5->( MsUnLock("SC5") )
	
	SC5TMP->( DbSkip() )
End
SC5TMP->( DbCloseArea() )

Return(.T.)


// Verifica se tem do pedido liberado para faturamento
cQuery	:=	" SELECT  R_E_C_N_O_ " +;
			" FROM    " + RetSQLName("SC9") +;
			" WHERE   C9_FILIAL = '" + xFilial("SC9") + "' AND " +;
			"         C9_PEDIDO = '" + cPedido + "' AND " +;
			"         D_E_L_E_T_ = ' ' "

PLSQuery( cQuery, "SC9TMP" )
SC9TMP->( DbGoTop() )

While SC9TMP->( !Eof() )
	
	SC9->( DbGoTo( SC9TMP->R_E_C_N_O_ ) )
	
	SC9->( RecLock("SC9",.F.) )
	SC9->( DbDelete() )
	SC9->( MsUnLock("SC9") )
	
	SC9TMP->( DbSkip() )
End
SC9TMP->( DbCloseArea() )

Return(.T.)


/*
Funcao de notificacao de status de processamento
Monsta msg no log de console
Atualiza informacoes da thread do Protheus Monitor
*/

STATIC Function Mystatus(cMsg)
Local cStatus := "["+dtos(date())+" "+time()+"] "
Local cEcho := cStatus + "[Thread "+alltrim(str(ThreadId(),10))+"] "

PtInternal(1,cStatus+cMsg)
//conout(cEcho+cMsg)

Return                          
