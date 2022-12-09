#include "rwmake.ch"        
/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    Ё MINUTCOD Ё Autor Ё  Rosane Rodrigues     Ё Data Ё 25/07/02 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao Ё Minuta da empresa CODAY                                    Ё╠╠
╠╠цддддддддддеддддддддддддддбддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function Minutcod()    

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis utilizadas no programa atraves da funcao    Ё
//Ё SetPrvt, que criara somente as variaveis definidas pelo usuario,    Ё
//Ё identificando as variaveis publicas do sistema utilizadas no codigo Ё
//Ё Incluido pelo assistente de conversao do AP5 IDE                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetPrvt("WNREL,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LCONTINUA,NLASTKEY,ARETURN,NOMEPROG,CPERG,NLIN")
SetPrvt("NLINOT,EXTENSO,_CNOTA,_CPREF,")

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cabec1    := ""
cabec2    := ""
cabec3    := ""
tamanho   := "G"
limite    := 220
titulo    := "Minuta Coday"
cDesc1    := "Este programa ira emitir a Minuta da CODAY"
cDesc2    := ""
cDesc3    := ""
cString   := "SE1"
lContinua := .T.
nLastKey  := 0
aReturn   := { "Especial", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "MINUTCOD"
wnrel     := "MINUTCOD"
_cNota    := " "
_cPref    := " "

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para Impressao do Cabecalho e Rodape    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

nLin     := -33
nLiNot   := 0

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas, busca o padrao da NFSAI  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cPerg := "MINUTA    "
validperg()
Pergunte(cPerg, .F.)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
//Ё mv_par01             // Da Nota                              Ё
//Ё mv_par02             // Ate a Nota                           Ё
//Ё mv_par03             // Serie                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .OR. nLastKey == 27
	Return
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Salva posicoes para movimento da regua de processamento      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 24/07/02 ==>    RptStatus({|| Execute(RptDetail)})
Return

//
Static Function RptDetail()

SetRegua(RecCount())

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁPosiciona o SE1 para buscar os dados da duplicata             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea("SE1")
dbSetOrder(1)
Set Softseek On
dbSeek(xFilial("SE1")+mv_par03+mv_par01)
Set Softseek off
SetPrc(0,0)

@ 0, 000 PSAY Chr(18)                // Descompressao de Impressao

While !eof() .and. SE1->E1_FILIAL == xFilial() .and. SE1->E1_NUM <= mv_par02
	
	If SE1->E1_PREFIXO # mv_par03
		dbSkip()
		Loop
	Endif
	
	If SE1->E1_NUM == _cNota .AND. SE1->E1_PREFIXO == _cPref
		dbSkip()
		Loop
	Endif
	
	nLin   := nLin + 33
	nLiNot := 15
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se houve interrup┤└o pelo operador      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддды
	
	#IFNDEF WINDOWS
		IF LastKey()==286
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ELSE
		IF lAbortPrint
			@nLin+nLiNot,001 Say "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ENDIF
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza barra de Status                         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддды
	
	IncRegua()
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁPosiciona o SA1(Cliente) para buscar os Dados                Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+SE1->E1_PEDIDO)
	
	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xFilial("SA4")+SC5->C5_TRANSP)
	
	dbSelectArea("SE1")
	nLiNot := 10
	@nLin+nLiNot,005 PSAY "Nota Fiscal : "
	@nLin+nLiNot,019 PSAY SE1->E1_NUM
	@nLin+nLiNot,035 PSAY "Data Emissao da NF : "
	@nLin+nLiNot,056 PSAY SE1->E1_EMISSAO
	nLiNot := 11
	@nLin+nLiNot,005 PSAY Replicate("=",80)
	nLiNot := 13
	@nLin+nLiNot,005 PSAY "CLIENTE : " + SA1->A1_NOME
	nLiNot := 14
	@nLin+nLiNot,005 PSAY "ENDERECO : " + SA1->A1_END + space(05) + "CEP : " + SUBSTR(SA1->A1_CEP,1,5) + "-" + SUBSTR(SA1->A1_CEP,6,3)
	nLiNot := 15
	@nLin+nLiNot,005 PSAY "CIDADE : " + SA1->A1_MUN + space(05) + "ESTADO : " + SA1->A1_EST
	nLiNot := 16
	@nLin+nLiNot,005 PSAY "TRANSPORTADORA : " + SA4->A4_NOME + space(03) + "TELEFONE : " + SA4->A4_TEL
	nLiNot := 18
	@nLin+nLiNot,005 PSAY "Numero de Volumes : "
	@nLin+nLiNot,025 PSAY (SC5->C5_VOLUME1+SC5->C5_VOLUME2+SC5->C5_VOLUME3+SC5->C5_VOLUME4)
	nLiNot := 19
	@nLin+nLiNot,005 PSAY "Peso Bruto : "
	@nLin+nLiNot,018 PSAY SC5->C5_PBRUTO
	nLiNot := 22
	@nLin+nLiNot,005 PSAY "Numero de Coleta : ____________________"
	@nLin+nLiNot,050 PSAY "Atendente : _______________ "
	nLiNot := 25
	@nLin+nLiNot,005 PSAY "Sao Paulo, ____ de ______________ de ______"
	nLiNot := 28
	@nLin+nLiNot,005 PSAY "Assinatura : _____________________________________"
	
	_cNota  := SE1->E1_NUM
	_cPref  := SE1->E1_PREFIXO
	
	dbSelectArea("SE1")
	dbSkip()
EndDo


@ prow()+9,000 say " "
dbSelectArea("SE1")
dbSetOrder(1)
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
/*/
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠зддддддддддбдддддддддбдддддддбддддддддддддддддддбддддддбдддддддддд©╠
╠ЁFuncao    ЁVALIDPERGЁ Autor Ё Rosane Rodrigues Ё Data Ё 23.07.02 Ё╠
╠цддддддддддедддддддддадддддддаддддддддддддддддддаддддддадддддддддд╢╠
╠ЁDescricao Ё Verifica perguntas, incluindo-as caso nao existam    Ё╠
╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠
╠ЁUso       Ё SX1                                                  Ё╠
╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддды╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
/*/
Static Function VALIDPERG
ssAlias      := Alias()
cPerg        := PADR(cPerg,10)
aRegs        := {}
dbSelectArea("SX1")
dbSetOrder(1)
AADD(aRegs,{cPerg,"01","Da Nota       ?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Nota    ?"," "," ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Serie         ?"," "," ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(ssAlias)
Return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё      FIM DO PROGRAMA                                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
