#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIR014   º Autor ³Aline Catarina      ºData  ³  26/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de Orcamentos/Propostas                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function HCIR014()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1			:= "Este programa tem como objetivo imprimir os orcamentos liberados"
Local cDesc2			:= "de valvulas de acordo com os parametros informados pelo usuario."
Local cDesc3			:= "Impressao de Orcamentos/Propostas"
Local cPict				:= ""
Local titulo			:= "Impressao de Orcamentos/Propostas"
Local nLin				:= 80
Local aRegs				:= {}
Local Cabec1			:= "Data: "
Local Cabec2			:= "NºProposta  Referencia                                           Valor  Representante  Observacao"
Local imprime			:= .T.
Local aOrd				:= {}
Private lEnd			:= .F.
Private lAbortPrint		:= .F.
Private limite			:= 80
Private tamanho			:= "M"
Private nomeprog		:= "HCIR014" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo			:= 18
Private aReturn			:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey		:= 0
Private cPerg			:= "HCR014"
Private cbtxt			:= Space(10)
Private cbcont			:= 00
Private CONTFL			:= 01
Private m_pag			:= 01
Private wnrel			:= "nomeprog" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString			:= "SCJ"

AjuSX1(cPerg)

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local dEmissao := Date()
Local cCliente := ""
Local nTotProp := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

cTemp := "TMPSCJ"
cQuery := " SELECT SCJ.CJ_EMISSAO, SCJ.CJ_NUM, SCJ.CJ_CLIENTE, SCJ.CJ_LOJA, SCJ.CJ_NUMCOT, SUM(SCK.CK_VALOR) AS VLRTOT, "
cQuery += " SCJ.CJ_VEND, SCJ.CJ_OBS, "
If mv_par10 == 1
	cQuery += " SA1.A1_NOME NOMECLI"
else
	cQuery += " SA1.A1_NREDUZ NOMECLI"
EndIf
cQuery += " FROM "+RetSqlName("SCJ")+" SCJ, "+RetSqlName("SCK")+" SCK, "+RetSqlName("SA1")+" SA1 "
cQuery += " WHERE SCJ.CJ_FILIAL = SCK.CK_FILIAL "
cQuery += " AND SCJ.CJ_NUM = SCK.CK_NUM "          
cQuery += " AND SA1.A1_COD = SCJ.CJ_CLIENTE "          
cQuery += " AND SA1.A1_LOJA = SCJ.CJ_LOJA "          
cQuery += " AND SCJ.CJ_FILIAL = '" + xFilial("SCJ") + "' "
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
cQuery += " AND SCJ.CJ_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery += "	AND SCJ.CJ_CLIENTE BETWEEN '" + ( mv_par03 ) + "' AND '" + ( mv_par05 ) + "' "
cQuery += "	AND SCJ.CJ_LOJA BETWEEN '" + ( mv_par04) + "' AND '" + ( mv_par06 ) + "' "		
cQuery += "	AND SCJ.CJ_VEND BETWEEN '" + ( mv_par07) + "' AND '" + ( mv_par08 ) + "' "	
cQuery += "	AND SCJ.CJ_DIVISAO = '" + cValToChar(mv_par09) + "' "	
cQuery += "	AND SCJ.D_E_L_E_T_ = ' '           "
cQuery += "	AND SCK.D_E_L_E_T_ = ' '           "
cQuery += " GROUP BY SCJ.CJ_EMISSAO, SCJ.CJ_CLIENTE, SCJ.CJ_LOJA, SCJ.CJ_NUM, SCJ.CJ_NUMCOT,SCJ.CJ_VEND, SCJ.CJ_OBS, "    
If mv_par10 == 1
	cQuery += " SA1.A1_NOME"
else
	cQuery += " SA1.A1_NREDUZ"
EndIf
                                                                                  
dbUseArea ( .T., "TOPCONN", TcGenQry(,,cQuery), cTemp, .F., .T.)
TcSetField(cTemp,"CJ_EMISSAO"	,"D",8,0) 
 
//dbGotop()
//dbEval( {|| nCount++ } )
dbGotop()
//SetRegua(nCount) 

While !EOF() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	dEmissao := (cTemp)->CJ_EMISSAO
	While !EOF() .AND. ((cTemp)->CJ_EMISSAO = dEmissao) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

  		//IncRegua()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1+DtoC((cTemp)->CJ_EMISSAO),Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
	
		cCliente := (cTemp)->CJ_CLIENTE+(cTemp)->CJ_LOJA   
		nTotProp := 0
		nLin++
		@nLin,00 PSAY	"Cliente/Loja: "+(cTemp)->CJ_CLIENTE+"/"+(cTemp)->CJ_LOJA+"  "+(cTemp)->NOMECLI                 
		nLin++
		@nLin,00 PSAY	"------------------------------------------------------------------------------------------------------------------------------------"                 
		While !EOF()	.AND. ((cTemp)->CJ_EMISSAO = dEmissao); 
						.AND. ((cTemp)->CJ_CLIENTE+(cTemp)->CJ_LOJA = cCliente) 

			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1+DtoC((cTemp)->CJ_EMISSAO),Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
	
			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. 
			nLin++		
			@nLin,00 PSAY	(cTemp)->CJ_NUM
			@nLin,12 PSAY   SubStr((cTemp)->CJ_NUMCOT,1,40)		
			@nLin,55 PSAY  	Transform((cTemp)->VLRTOT,"@E 999,999,999.99")
			@nLin,71 PSAY  	(cTemp)->CJ_VEND          
			@nLin,86 PSAY  	SubStr((cTemp)->CJ_OBS,1,40)
			If (Len(AllTrim((cTemp)->CJ_NUMCOT)) > 40) .OR. (Len(AllTrim((cTemp)->CJ_OBS)) > 40)     
				@nLin++
				@nLin,12 PSAY	AllTrim(SubStr((cTemp)->CJ_NUMCOT,41,40)) 
				@nLin,86 PSAY  	AllTrim(SubStr((cTemp)->CJ_OBS,41,40))			
			EndIf		
			dbSkip() // Avanca o ponteiro do registro no arquivo
			nTotProp++
		EndDo		
		nLin++
		@nLin,00 PSAY	"------------------------------------------------------------------------------------------------------------------------------------"                 
		nLin++               
		@nLin,00 PSAY	"Total de Propostas: "+Str(nTotProp)
        nLin++
	EndDo 
	nLin 	:= 60
	dEmissao:= (cTemp)->CJ_EMISSAO
EndDo
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()                     

Return          

Static Function AjuSX1(cPerg)     
DbSelectArea("SX1")                                  
SX1->(DbSetOrder(1)) // x1_grupo 
If !SX1->(DbSeek(cPerg))                                                      
	PutSx1(cPerg, "01", "Data     De      ?", "", "", "MV_CH1", "D",08,0,0,"G","",   "","","","mv_par01","","","",      "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
	PutSx1(cPerg, "02", "Data     Até     ?", "", "", "MV_CH2", "D",08,0,0,"G","",   "","","","mv_par02","","","",      "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
	PutSx1(cPerg, "03", "Cliente  De      ?", "", "", "MV_CH3", "C",06,0,0,"G","","SA1","","","mv_par03","","","","      ","","","","","","","","","","","","","","","","","SA1","","","","","","","","")
	PutSx1(cPerg, "04", "Loja     De      ?", "", "", "MV_CH4", "C",02,0,0,"G","",   "","","","mv_par04","","","",    "  ","","","","","","","","","","","","","","","","",   "","","","","","","","","")
	PutSx1(cPerg, "05", "Cliente  Até     ?", "", "", "MV_CH5", "C",06,0,0,"G","","SA1","","","mv_par05","","","","ZZZZZZ","","","","","","","","","","","","","","","","","SA1","","","","","","","","")
	PutSx1(cPerg, "06", "Loja     Até     ?", "", "", "MV_CH6", "C",02,0,0,"G","",   "","","","mv_par06","","","",    "ZZ","","","","","","","","","","","","","","","","",   "","","","","","","","","")
	PutSx1(cPerg, "07", "Vendedor De      ?", "", "", "MV_CH7", "C",06,0,0,"G","","SA3","","","mv_par07","","","","      ","","","","","","","","","","","","","","","","","SA3","","","","","","","","")
	PutSx1(cPerg, "08", "Vendedor Até     ?", "", "", "MV_CH8", "C",06,0,0,"G","","SA3","","","mv_par08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","SA3","","","","","","","","")
	PutSx1(cPerg, "09", "Divisao          ?", "", "", "MV_CH9", "C",01,0,0,"C","",   "","","","mv_par09","1-Válvula","","","", "2-Flanges/Conexões", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
	PutSx1(cPerg, "10", "Dados do cliente ?", "", "", "MV_CH10","C",01,0,0,"C","",   "","","","mv_par10","Razão Social","","","", "Nome Reduzido", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
	
	//³ mv_par01 -> Indica a data inicial do orcamento a processar                     ³
	//³ mv_par02 -> Indica a data final do orcamento a processar                       ³
	//³ mv_par03 -> Indica o codigo inicial do cliente a processar                     ³
	//³ mv_par04 -> Indica o codigo inicial da loja do cliente a processar             ³
	//³ mv_par05 -> Indica o codigo final do cliente a processar                       ³
	//³ mv_par06 -> Indica o codigo final da loja do cliente a processar               ³
	//³ mv_par07 -> Indica o codigo inicial do vendedor a processar                    ³
	//³ mv_par08 -> Indica o codigo final do vendedor a processar                      ³
	//³ mv_par09 -> Indica o codigo da divisao a processar, onde: 1-Valvula e 2-Flanges/Conexoes ³	
	//³ mv_par09 -> Indica o opção de descrição do cliente a ser impresso, onde: R-Razão Social e N-Nome Fantasia ³	
	
EndIf                                    
Return                                  
