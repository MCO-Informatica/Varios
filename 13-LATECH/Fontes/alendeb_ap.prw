#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#INCLUDE "topconn.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function alendeb()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NORDEM,TAM,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CNATUREZA,CSTRING,LCONTINUA,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,WNREL,NTOTJUR,NVALJUR,_CNUMDEB")
SetPrvt("CNOMECLI,CENDCLI,CBAIRRO,CCEP,CMUNCLI,CESTCLI")
SetPrvt("CCGCCLI,CINSCCLI,CCOBCLI,CCEPCOB,CBAIRROCOB,CMUNCOB")
SetPrvt("CESTCOB,NLIN,CTIPOTIT,CNUMNF,CTIPO,NVALDUP")
SetPrvt("CPARCELA,DVENCTO,DPAGTO,NLININI,NOPC,CCOR")
SetPrvt("_APERGUNTAS,_NLACO,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "topconn.ch"

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DUPLI    ³ Autor ³                       ³ Data ³ 05/12/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota de Debito                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Exclusivo para Clientes Microsiga,                         ³±±
±±³          ³ Alterado para o Cliente Kenia Textil                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_cli_de            // Cliente de                           ³
//³ mv_cli_ate           // Cliente Ate                          ³
//³ mv_venc_de           // Vencimento de                        ³
//³ mv_venc_ate          // Vencimento ate                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem     := 0
tam        := "P"
limite     := 80
titulo     := PADC("NOTA DE DEBITO",71)
cDesc1     := PADC("Este programa ira emitir Notas de Debito. ",71)
cDesc2     := ""
cDesc3     := ""
cNatureza  := ""
cString    := "SE1"
lContinua  :=  .T.
aReturn    :=  { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog   := "KNOTDEB"
nLastKey   :=  0
cPerg      := "NTDEB1"
wnrel      := "NDEB"
nTotJur    := 0
nValJur    := 0
			   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
perguntas()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,tam)

#IFNDEF WINDOWS
	If LastKey() == 27 .or. nLastKey == 27
		__Return()()
	Endif
#ENDIF

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VerImp()

#IFNDEF WINDOWS
	If LastKey() == 27 .OR. nLastKey == 27
		__Return()()
	Endif
#ENDIF

#IFDEF WINDOWS
	RptStatus({|| Duplicata()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	RptStatus({|| Execute(Duplicata)})
	__Return()()
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	Function Duplicata
Static Function Duplicata()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento da Nota de Debito                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE1")                // * Contas a Receber
dbSetOrder(2)
dbSeek(xFilial("SE1")+mv_par01+mv_par02,.T.)

SetRegua(LastRec())

While !Eof() .and. SE1->E1_FILIAL  == xFilial("SE1");
			 .and. SE1->E1_CLIENTE+SE1->E1_LOJA == mv_par01+mv_par02
											   
	alert("entrei no while do E1")
	
	#IFNDEF WINDOWS
		IF LastKey()==286
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ELSE
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de titulo           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !SE1->E1_TIPO == "NDC"
		dbSkip()
		Loop
	Endif

	 _cNumDeb := GetSx8Num("NDB")
	 confirmSx8()

	 @ 000, 000 PSAY Chr(18)
	 @ 002, 062 PSAY Dtoc(dDataBase)    // Data de Emissao
	 @ 004, 020 PSAY _cNumDeb           // Numero Seq da Nota de Debito
	 @ 004, 015 PSAY _cNumDeb
	 @ 004, 050 PSAY Dtoc(dDataBase+20) // Data de Vencto N Debito
	  
	dbSelectArea("SA1")                 // * Cadastro de Clientes
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+mv_par01+mv_par02,.T.)

	cNomeCli   := SA1->A1_NOME               // Nome do Cliente
	cEndCli    := SA1->A1_END                // Endereco do Cliente
	cBairro    := SA1->A1_BAIRRO             // Bairro
	cCEP       := SA1->A1_CEP                // CEP do Cliente
	cMunCli    := SA1->A1_MUN                // Municipio do Cliente
	cEstCli    := SA1->A1_EST                // Estado do Cliente
	cCGCCli    := SA1->A1_CGC                // CGC do Cliente
	cInscCli   := SA1->A1_INSCR              // Inscricao estadual do Cliente
	cCobCli    := SA1->A1_ENDCOB             // Endereco de Cobranca do Cliente
	cCepCob    := SA1->A1_CEPC               // Cep de Cobranca
	cBairroCob := SA1->A1_BAIRROC            // Bairro de cobranca
	cMunCob    := SA1->A1_MUNC               // Municipio de cobranca
	cEstCob    := SA1->A1_ESTC               // Estado de cobranca
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Dados do Cliente      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  alert("impressao dados clientes")
	  @ 014, 020 PSAY cNomeCli
	  @ 015, 020 PSAY cEndCli
	  @ 015, 050 PSAY cBairro
	  @ 016, 020 PSAY cMunCli
	  @ 016, 050 PSAY cEstCli
	  @ 016, 063 PSAY TRANSFORM(cCEP,"@R 99999-999")
	  @ 017, 020 PSAY cMunCli
	  @ 018, 020 PSAY cCGCCli     PICTURE "@R 99.999.999/9999-99"
	  @ 018, 050 PSAY cInscCli // PICTURE "@R 999.999.999.999"
	  @ 021, 020 PSAY cCobCli  
	  @ 021, 050 PSAY cBairroCob
	  @ 022, 020 PSAY cMunCob 
	  @ 022, 050 PSAY cEstCob 
	  @ 022, 065 PSAY TRANSFORM(cCepCob,"@R 99999-999")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Levantamento dos Dados da Nota de Debito                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   nLin := 30
//     DbGoTo(nRecAnt)   // Retorna o registro corrente
	   
	   dbSelectArea("SE1")
	   cTipoTit := SE1->E1_TIPO
	   
	   While SE1->E1_TIPO == cTipoTit 
	   alert("while selecionando os titulos")
		   cNumNF     :=SE1->E1_NUM             // Numero da Titulo          
		   cTipo      :=SE1->E1_TIPO            // Tipo do Titulo      
		   nValDup    :=SE1->E1_VALOR           // Valor do Titulo   
		   cParcela   :=SE1->E1_PARCELA         // Numero da Parcela
		   dVencto    :=SE1->E1_VENCTO          // Vencimento da Parcela  
		   dPagto     :=SE1->E1_BAIXA           // Data de Pagamento        
  
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³                IMPRESSAO DOS TITULOS                         ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   
		alert("impressao dos titulos")
		   @ nLin, 015 PSAY cNumNF  
		   @ nLin, 022 PSAY cTipo   
		   @ nLin, 030 PSAY nValDup  PICTURE "@E 999,999,999.99"
		   @ nLin, 040 PSAY DTOC(dVencto)
		   @ nLin, 040 PSAY DTOC(dPagto) 
		 
		   nLin := nLin + 1
		   DbSkip()
		
		alert("impressao do proximo titulo")
	   EndDo
		  alert("sai da impressao") 
		  
	   @ 36, 000 PSAY ""
	   SETPRC (0,0)
	   alert("termino da impressao")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Avan‡o da R‚gua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IncRegua()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino da Impressao da Duplicata              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
	  exit
   
 
Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fechamento do Programa da Duplicata                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE1")
dbSetOrder(1)

Set Device To Screen

dbCommitAll()

If aReturn[5] == 1
	Set Printer TO
	ourspool(wnrel)
Endif

MS_FLUSH()

__Return()()


/*/

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³ Luiz Carlos Vieira    ³ Data ³ 30/09/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica posicionamento de papel na Impressora             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Lincoln                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,003 PSAY "*"
		
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 PSAY "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device To Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				__Return()()
		EndCase
	End
Endif

__Return()()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Pergunta ³ Autor ³ Marcos Gomes          ³ Data ³ 01/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria grupo de Perguntas caso nao exista no SX1             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP - especifico Kenia                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Pergunta
Static Function Pergunta()
		  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_cli_de            // Cliente de                           ³
//³ mv_cli_ate           // Cliente Ate                          ³
//³ mv_venc_de           // Vencimento de                        ³
//³ mv_venc_ate          // Vencimento ate                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerguntas := {}             
		  // 01     02       03                  04     05  06 7 8  9      10                               11           12        13 14        15        16 17    18     19 20     21        22 23 24 25  26 
AADD(_aPerguntas,{"NTDEB1    ","01","Cliente de         ?","mv_ch1","C",06,0,0,"G","                               ","mv_par01","            ","","","              ","","","       ","","","           ","","","","","SA1",})
AADD(_aPerguntas,{"NTDEB1    ","02","Cliente Ate        ?","mv_ch2","C",06,0,0,"G","                               ","mv_par02","            ","","","              ","","","       ","","","           ","","","","","SA1",})
AADD(_aPerguntas,{"NTDEB1    ","03","Vencimento de      ?","mv_ch3","D",08,0,0,"G","                               ","mv_par03","            ","","","              ","","","       ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"NTDEB1    ","04","Vencimento Ate     ?","mv_ch4","D",08,0,0,"G","                               ","mv_par04","            ","","","              ","","","       ","","","           ","","","","","   ",})

DbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
   If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
	 RecLock("SX1",.T.)
	 SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
	 SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
	 SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
	 SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
	 SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
	 SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
	 SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
	 SX1->X1_Presel    := _aPerguntas[_nLaco,08]
	 SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
	 SX1->X1_Valid     := _aPerguntas[_nLaco,10]
	 SX1->X1_Var01     := _aPerguntas[_nLaco,11]
	 SX1->X1_Def01     := _aPerguntas[_nLaco,12]
	 SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
	 SX1->X1_Var02     := _aPerguntas[_nLaco,14]
	 SX1->X1_Def02     := _aPerguntas[_nLaco,15]
	 SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
	 SX1->X1_Var03     := _aPerguntas[_nLaco,17]
	 SX1->X1_Def03     := _aPerguntas[_nLaco,18]
	 SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
	 SX1->X1_Var04     := _aPerguntas[_nLaco,20]
	 SX1->X1_Def04     := _aPerguntas[_nLaco,21]
	 SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
	 SX1->X1_F3        := _aPerguntas[_nLaco,26]
	 MsUnLock()
   EndIf
NEXT
__Return()




Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

