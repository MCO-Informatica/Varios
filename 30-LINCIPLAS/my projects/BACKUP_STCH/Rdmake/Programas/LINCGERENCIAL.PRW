#include "rwmake.ch"
#include "topconn.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LINC01    º Autor ³ RODRIGO DEMETRIOS  º Data ³  03/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO GERENCIAL                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LINC01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cDesc1       := "Este Programa Tem Como Objetivo Imprimir Relatório "
cDesc2       := "De Acordo Com os Parametros Informados Pelo Usuario."
cDesc3       := "Relatorio Gerencial"
cPict        := ""
titulo       := "Relatorio Gerencial"
nLin         := 80
imprime      := .T.
//aOrd         := {"Analitico:Data e Cliente","Sintético:Data"}
lEnd         := .F.
lAbortPrint  := .F.
CbTxt        := ""
limite       := 80
tamanho      := "M"
nomeprog     := "LINC01" // Coloque aqui o nome do programa para impressao no cabecalho
nTipo        := 15
aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey     := 0
_cPerg       := "TESTE"
cbtxt        := Space(10)
cbcont       := 00
CONTFL       := 01
m_pag        := 01
wnrel        := "LINC01" // Coloque aqui o nome do arquivo usado para impressao em disco
cString      := "SD2"
_nTotNcc     := 0
_nTotal      := 0
nOrdem       := 1
CABEC1       := "DATA EMISSAO     VALOR"
CABEC2       := ""

dbSelectArea("SD2")
dbSetOrder(1)

ValidPerg() // Valida as Perguntas

pergunte(_cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif


RptStatus({|| RFIN17() },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³EMFAT02   º Autor ³ ANDRE ELIAS        º Data ³  05/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RFIN17()


_dEMISSAODe  := mv_par01             // Data Vencto de
_dEMISSAOAte := mv_par02
_dEntregade  := mv_par03
_dEntregaate := mv_par04            // Data Vencto Ate

//         1         2         3         4         5         6         7         8         9         0         11        12        13
//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//DATA EMISSAO     VALOR
//99/99/99         99.999.999,99

dbSelectArea("SC6")
//dbSetOrder(1)
cFilTrab   := CriaTrab("",.F.)
cCondicao  := "C6_FILIAL=='"+xFilial("SC6")+"'.And."
cCondicao  += "Dtos(C6_ENTREG)>='"+Dtos(MV_PAR03)+"'.And.Dtos(C6_ENTREG)<='"+Dtos(MV_PAR04)+"'"
IndRegua("SC6",cFilTrab,"C6_FILIAL+DTOS(C6_ENTREG)",,cCondicao,"Filtrando")    // "Selecionando Registros..."
_nTotPed    := 0
_nPedAberto := 0          
_nPedFat    := 0 
_nValIPI    := 0
DbGoTop()
SetRegua(RecCount())

While !Eof() 
	IncRegua()
		IF (C6_TES $ '501/502/504/506/507/528/534/535/536/541/542/543/545/547/552/554/555/557/559/561/562/564') // .AND. C6_BLQ <> 'R '  //arrumar o filtro para somar somente o necessario.
	
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbseek(xfilial("SB1") + SC6->C6_PRODUTO )
		
		dbSelectArea("SC6")	 			                                                 //BUSCA VALOR DO IPI NO PRODUTO....
			_nPedAberto := _nPedAberto  + (((C6_QTDVEN-C6_QTDENT) * SC6->C6_PRCVEN) + ((((C6_QTDVEN-C6_QTDENT) * SC6->C6_PRCVEN) * SB1->B1_IPI)/100))
			_nPedFat    := _nPedFat     + ((C6_QTDENT * SC6->C6_PRCVEN ) + (((C6_QTDENT * SC6->C6_PRCVEN) * SB1->B1_IPI)/100))
	    ENDIF
	    
	dbSkip() 
End

dbSelectArea("SC6")
retindex()


dbSelectArea("SD2")        
dbSetOrder(5)  
dbGoTop()
cArqSD2 := CriaTrab( NIL,.F. )
cFilSD2 := "D2_FILIAL=='"+xFilial()+"'.And."
cFilSD2 += "DTOS(D2_EMISSAO)>='"+DTOS(mv_par01)+"'.And.DTOS(D2_EMISSAO)<='"+DTOS(mv_par02)+"'"
cFilSD2 += ".And.(D2_TES $'501/502/504/506/507/528/534/535/536/541/542/543/545/547/552/554/555/557/559/561/562/564')"  
IndRegua("SD2",cArqSD2,"D2_FILIAL+DTOS(D2_EMISSAO)",,cFilSD2,"Processando")
dbGoTop()

_nTotal  := 0  
_nTotGer := 0
SetRegua(RecCount())
While !Eof() 
	IncRegua()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
	_DEMISSAO := SD2->D2_EMISSAO  
	_nTotDia := 0
	
	WHILE !Eof() .AND. SD2->D2_EMISSAO == _DEMISSAO
		   	
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
		Endif
		     
		_nTotger  += SD2->D2_TOTAL + SD2->D2_VALIPI
		_nTotDia  += SD2->D2_TOTAL + SD2->D2_VALIPI
             //nLin := nLin + 1 	 // Avanca a linha de impressao
		dbSkip()             // Avanca o ponteiro do registro no arquivo
	End
//
// Imprime o Total do Dia
// 
	nLin := nLin + 1 	 // Avanca a linha de impressao
	@nLin,001 PSAY  _dEMISSAO
	@nLin,015 PSAY _nTotDia PICTURE "@E 99,999,999.99"
End

		
//
// Impreime Total Geral
//

nLin := nLin + 2   // Avanca a linha de impressao
@nLin,00 PSAY "TOTAL FATURADO: "
@nLin,30 PSAY _nTotger  PICTURE "@E 99,999,999.99"
nLin := nLin + 1   // Avanca a linha de impressao

@nLin,00 PSAY "PEDIDO A FATURAR: "
@nLin,30 PSAY  _nPedAberto  PICTURE "@E 99,999,999.99"
nLin := nLin + 1   // Avanca a linha de impressao


//@nLin,00 PSAY "PEDIDO FATURADO : "
//@nLin,30 PSAY  	_nPedFat PICTURE "@E 99,999,999.99"
//nLin := nLin + 1   // Avanca a linha de impressao

@nLin,00 PSAY "CARTEIRA TOTAL  : "
@nLin,30 PSAY   _nPedAberto + _nTotger PICTURE "@E 99,999,999.99"
nLin := nLin + 1   // Avanca a linha de impressao


dbSelectArea("SD2")
retindex()
//dbClearFilter()
//dbSetOrder(1)

dbSelectArea("SC6")
retindex()
//dbClearFilter()
//dbSetOrder(1)

dbSelectArea("SC5")
retindex()
//dbClearFilter()
//dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET PRINTER TO
OurSpool(wnrel)

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ValidPerg ³ Autor ³ Denilson Correa      ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida se existe as Perguntas no SX1                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

_cAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
_cPerg := PADR(_cPerg,10)
aRegs :={}

Aadd(aRegs,{_cPerg,"01","Data Faturamento de   ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"02","Data Faturamento Ate  ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"03","Data Ent. Pedido de   ?","","","mv_ch3","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"04","Data Ent. Pedido Ate  ?","","","mv_ch4","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
DbSelectArea(_cAlias)
Return

