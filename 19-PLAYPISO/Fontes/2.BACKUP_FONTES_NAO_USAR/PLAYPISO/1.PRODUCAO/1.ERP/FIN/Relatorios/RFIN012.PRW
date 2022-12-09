#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFIN012  º Autor ³ Mauro Nagata       º Data ³ 13/05/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio das remessas e contas a pagar da obra 3000 [Ma   º±±
±±º          ³ nutenca de Obra]                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda www.actualtrend.com.br                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFIN012()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "valores referentes a obra 3000 [Manute.Obra]"
Local cPict          := ""
Local titulo         := "Relatório da Manutencao de Obra"
Local nLin           := 80

Local Cabec1         := "      Local      Emissao  Docum/Serie   Codigo/Loja     Valor"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RFIN012" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RFIN012"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFIN012" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

//dbSelectArea("")
//dbSetOrder(1)

AjustaSX1()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  13/05/11   º±±
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

Local nOrdem
Local cQuery

Private cQry   	:= getNextAlias()

cQuery := "SELECT * "
cQuery += "FROM ( "

cQuery += "SELECT C6_XMNTOBR AS MANOBRA,D2_FILIAL AS FIL,D2_EMISSAO AS DATA,D2_DOC AS DOC,D2_SERIE AS SERIE,D2_CLIENTE AS COD, D2_LOJA AS LOJA, D2_TOTAL AS VALOR, 'REMESSA DE MATERIAL' AS ORIG "
cQuery += "FROM SD2010 D2 "
cQuery += "INNER JOIN SC6010 C6 "
cQuery += "      ON C6.D_E_L_E_T_='' "
cQuery += "         AND C6_FILIAL = D2_FILIAL "
cQuery += "         AND C6_NUM    = D2_PEDIDO "
cQuery += "         AND C6_ITEM   = D2_ITEMPV "
cQuery += "         AND C6_XMNTOBR BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "INNER JOIN SB1010 B1 "
cQuery += "      ON B1.D_E_L_E_T_='' "
cQuery += "         AND B1_COD = D2_COD "
cQuery += "         AND B1_TIPO NOT IN ('AT','MQ') "
cQuery += "WHERE D2.D_E_L_E_T_='' "
cQuery += "      AND D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
cQuery += "      AND D2_CCUSTO = '3000' "
//--ORDER BY C6_XMNTOBR,D2_FILIAL

cQuery += "UNION "

cQuery += "SELECT E2_XMNTOBR AS MANOBRA,E2_FILIAL AS FIL,E2_EMISSAO AS DATA,E2_NUM AS DOC,E2_PREFIXO AS SERIE,E2_FORNECE AS COD,E2_LOJA AS LOJA,SUM(E2_VALOR) AS VALOR, 'DESPESAS           ' AS ORIG "
cQuery += "FROM SE2010 E2 "
cQuery += "WHERE E2.D_E_L_E_T_='' "
cQuery += "      AND E2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
cQuery += "      AND E2_XCC = '3000' "
cQuery += "      AND E2_XMNTOBR BETWEEN '"+MV_PAR03+"'AND '"+MV_PAR04+"' "
cQuery += "GROUP BY E2_XMNTOBR,E2_FILIAL,E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA "
cQuery += " ) AS X "
cQuery += " ORDER BY MANOBRA,ORIG,DATA "

MemoWrite('C:\RFIN012.sql', cQuery)

If Select("QRA") > 0
	DbSelectArea("QRA")
	DbCloseArea()
EndIf

If MV_PAR06  == 1
	U_ExecXcel(cQuery,cQry,"RFIN012.xls")
	Return
EndIf

TcQuery cQuery New Alias "QRA"

If QRA->(EOF())
	Return
EndIf

DbSelectArea("QRA")
DbGoTop()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(-1)

lIp := .T.
nValGer := 0 //total geral
DbGoTop()
Do While !Eof()
	cObra   := QRA->MANOBRA  //manutencao obra/codigo da obra
	nValObr := 0             //total por obra
	If Prow() > 55.Or.lIp
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		lIp := .F.
	Endif
	@ Prow()+2,00   PSay "Obra :"+ QRA->MANOBRA
	@ Prow(),Pcol()+1 PSay "[ "
	@ Prow(),Pcol() PSay AllTrim(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+cObra,1,""))
	@ Prow(),Pcol()+1 PSay " ]"
	Do While !Eof().And.QRA->MANOBRA = cObra
		cOrig   := QRA->ORIG    //origem : faturamento / financeiro
		nValOri := 0            //total por origem : faturamento / financeiro
		@ Prow()+2,03 PSay QRA->ORIG
		Do While !Eof().And.QRA->MANOBRA = cObra.And.QRA->ORIG = cOrig
			If lAbortPrint  //verifica o cancelamento pelo usuario...
				@ Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			If Prow() > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			Endif
			IncRegua()
			
			If MV_PAR05 = 1
				cFilObr := If(QRA->FIL="02","PLAYPISO SP",If(QRA->FIL="03","LISONDA RJ ","LISONDA SP "))
				@ Prow()+1,05     PSay cFilObr
				@ Prow(),Pcol()+1 PSay Stod(QRA->DATA) Picture "@D"
				@ Prow(),Pcol()+1 PSay QRA->DOC
				@ Prow(),Pcol()   PSay "/"
				@ Prow(),Pcol()   PSay QRA->SERIE
				@ Prow(),Pcol()+1 PSay QRA->COD
				@ Prow(),Pcol()   PSay "/"
				@ Prow(),Pcol()   PSay QRA->LOJA
				@ Prow(),Pcol()+1 PSay QRA->VALOR Picture "@RE 999,999,999.99"
			EndIf
			
			nValOri += QRA->VALOR
			nValObr += QRA->VALOR
			nValGer += QRA->VALOR
			
			DbSkip() // Avanca o ponteiro do registro no arquivo
		EndDo
		//totaliza por origem : faturamento ou financeiro
		If MV_PAR05 = 1
			@ Prow()+1,03 PSay Replicate("-",62)
			@ Prow()+1,03 PSay "Total "+ cOrig
			@ Prow()  ,50 PSay nValOri Picture "@RE 999,999,999.99"
		Else
			@ Prow()  ,50 PSay nValOri Picture "@RE 999,999,999.99"
		EndIf
	EndDo
	//totaliza por obra
	@ Prow()+1,00 PSay "Total "+ cObra
	@ Prow()  ,50 PSay nValObr Picture "@RE 999,999,999.99"
	@ Prow()+1,00 PSay Replicate("-",80)
EndDo
//totaliza geral
@ Prow()+1,00 PSay "Total Geral"
@ Prow()  ,50 PSay nValGer Picture "@RE 999,999,999.99"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Set Device To Screen

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	DbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

Ms_Flush()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Mauro Nagata        ³Data³ 09/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()

Local cAlias := Alias(), aPerg := {}
Local nI, nPerg

Aadd(aPerg, {"01","Da Emissao ?"     ,"?","?","mv_ch1","D",8 ,"G","mv_par01","","","","","","","",0,""})
Aadd(aPerg, {"02","Ate a Emissao ?"  ,"?","?","mv_ch2","D",8 ,"G","mv_par02","","","","","","","",0,""})
Aadd(aPerg, {"03","Da Obra ?"        ,"?","?","mv_ch3","C",9 ,"G","mv_par03","","","","","","","",0,"CTT"})
Aadd(aPerg, {"04","Ate a Obra ?"     ,"?","?","mv_ch4","C",9 ,"G","mv_par04","","","","","","","",0,"CTT"})
Aadd(aPerg, {"05","Tipo Relatorio ?" ,"?","?","mv_ch5","N",1 ,"C","mv_par05","Analitico","","","","Sintetico","","",1,""})

nPerg := Len(aPerg)

DbSelectArea("SX1")
DbSetOrder(1)
For nI := 1 To nPerg
	If !DbSeek(Pad(cPerg,10)+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With cPerg
		Replace X1_ORDEM	With aPerg[nI,01]
		Replace X1_PERGUNT	With aPerg[nI,02]
		Replace X1_PERSPA	With aPerg[nI,03]
		Replace X1_PERENG	With aPerg[nI,04]
		Replace X1_VARIAVL	With aPerg[nI,05]
		Replace X1_TIPO		With aPerg[nI,06]
		Replace X1_TAMANHO	With aPerg[nI,07]
		Replace X1_GSC		With aPerg[nI,08]
		Replace X1_VAR01	With aPerg[nI,09]
		Replace X1_DEF01	With aPerg[nI,10]
		Replace X1_DEFSPA1	With aPerg[nI,11]
		Replace X1_DEFENG1	With aPerg[nI,12]
		Replace X1_CNT01	With aPerg[nI,13]
		Replace X1_DEF02	With aPerg[nI,14]
		Replace X1_DEFSPA2	With aPerg[nI,15]
		Replace X1_DEFENG2	With aPerg[nI,16]
		Replace X1_PRESEL 	With aPerg[nI,17]
		Replace X1_F3    	With aPerg[nI,18]
		
		MsUnlock()
	EndIf
Next

DbSelectArea(cAlias)

Return



