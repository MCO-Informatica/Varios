#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFAT009  º Autor ³ Mauro Nagata       º Data ³ 18/05/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Remessa de Material por Obra                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda www.actualtrend.com.br                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT009()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Remessa de Material por Obra                                "
Local cPict          := ""
Local titulo         := "Relatório de Remessa de Material por Obra"
Local nLin           := 80

Local Cabec1         := "      Local     Emissao  Produto          Pedido      Descricao                            Total          Total           Diferenca        Preco          Custo         Quantidade"
Local Cabec2         := "                                                                                          Documento      C.Standart                       Unitario       Standart"
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFAT009" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RFAT009"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFAT009" // Coloque aqui o nome do arquivo usado para impressao em disco

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

Do Case
   Case MV_PAR05 = 1
        Cabec1  := "                                                      Total          Total     "
        Cabec2  := "                                                      Documento      C.Standart"
        Limite  := 80
        tamanho := "P" 
   Case MV_PAR05 = 2
        Cabec1  := "Documento/Serie                                     Total          Total     "
        Cabec2  := "                                                    Documento      C.Standart"
        Limite  := 80
        tamanho := "P"
   Case MV_PAR05 = 3
        Cabec1  := "      Local     Emissao  Produto         Pedido                    Descricao                                Total          Total        Diferenca       Preco          Custo    Quantidade"
        Cabec2  := "                                                                                                          Documento      C.Standart                    Unitario       Standart   Documento"
        Limite  := 220
        tamanho := "G"                
EndCase              

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

cQuery := "SELECT D2_TOTAL AS TOTDOC  , D2_PRCVEN         AS PRUNIT, D2_QUANT   AS QUANT, "
cQuery += "       B1_CUSTD AS CUSTOSTD, B1_CUSTD*D2_QUANT AS TOTSTD, D2_EMISSAO AS EMISSAO, "
cQuery += "       D2_DOC   AS DOC     , D2_SERIE          AS SERIE , D2_PEDIDO  AS PEDIDO," 
cQuery += "       B1_DESC  AS DESCPRD , D2_COD            AS CODPRD, D2_CCUSTO  AS OBRA  , "
cQuery += "       ROUND(CAST ((D2_TOTAL-(B1_CUSTD*D2_QUANT)) AS decimal (14,2)),2) AS DIF, "
/*
cQuery += "       CASE WHEN D2_FILIAL = '02' THEN 'PlayPiso  ' "
cQuery += "            WHEN D2_FILIAL = '03' THEN 'Lisonda RJ' "
cQuery += "            WHEN D2_FILIAL = '04' THEN 'Lisonda SP' "
*/
//substituido bloco acima pelo abaixo [Mauro Nagata, Actual Trend, 20161004]
cQuery += "       CASE WHEN D2_FILIAL = '02' THEN 'PlayPiso  ' "
cQuery += "            WHEN D2_FILIAL = '03' THEN 'Lisonda RJ' "
cQuery += "            WHEN D2_FILIAL = '04' THEN 'Lisonda SP' "           
//fim bloco [Mauro Nagata, Actual Trend, 20161004]

cQuery += "       ELSE 'INDEFINIDA' "
cQuery += "       END AS FILIAL "
cQuery += "FROM  SD2010 AS D2 "
cQuery += "INNER JOIN SF4010 AS F4 "
cQuery += "      ON F4_CODIGO = D2_TES "
cQuery += "         AND F4_DUPLIC <> 'S' " 
cQuery += "         AND F4.D_E_L_E_T_ = '' " 
cQuery += "INNER JOIN SB1010 AS B1 "
cQuery += "      ON B1_COD = D2_COD "  
//  adicionado expressao para filtrar MATERIAL (1) ou EQUIPAMENTO (2) - luiz henrique 25/05/2015
If Mv_Par12 == 1
	cQuery += " AND (B1_TIPO <> 'AT' OR B1_TIPO <> 'MQ') "  //MATERIAL
Else
	cQuery += " AND (B1_TIPO  = 'AT' OR B1_TIPO  = 'MQ') " //EQUIPAMENTO
EndIf
// fim da expressao - luiz henrique 25/05/2015
//cQuery += "         AND B1_TIPO NOT IN ('AT','MQ') "   substituida pelo bloco IF acima, para filtrar ou equipamento ou material - luiz henrique 25/05/2015
cQuery += "         AND B1.D_E_L_E_T_ = '' "
cQuery += "WHERE D2_CCUSTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "      AND D2_COD NOT LIKE 'AT%' "
cQuery += "      AND D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "  
cQuery += "      AND D2_COD     BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "  // inserido para filtrar por produto     - Luiz Henrique     20/08/2012
cQuery += "      AND D2_DOC     BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' " // inserido para filtrar por nota fiscal  - Luiz Henrique     20/08/2012
cQuery += "      AND D2_PEDIDO  BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' " // inserido para filtrar por numero de pedido - Luiz Henrique 20/08/2012
cQuery += "      AND D2.D_E_L_E_T_ = '' "
cQuery += "ORDER BY  D2_EMISSAO,D2_CCUSTO, D2_PEDIDO, D2_DOC, D2_SERIE "

MemoWrite('C:\RFAT009.sql', cQuery)

If Select("QRA") > 0
	DbSelectArea("QRA")
	DbCloseArea()
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
nGerDoc := 0 //total geral por documento
nGerStd := 0 //total geral por custo standart
DbGoTop()
Do While !Eof()
	cObra   := QRA->OBRA    //codigo da obra
	nObrDoc := 0            //total obra por documento
	nObrStd := 0            //total obra por custo standart
	If Prow() > 55.Or.lIp
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		lIp := .F.
	Endif
	@ Prow()+2,00   PSay "Obra :"+ QRA->OBRA
	@ Prow(),Pcol() PSay "["
	@ Prow(),Pcol() PSay If(MV_PAR05=1,Substr(AllTrim(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+cObra,1,"")),1,30),AllTrim(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+cObra,1,"")))
	@ Prow(),Pcol() PSay "]"
	Do While !Eof().And.QRA->OBRA = cObra
		cDoc    := QRA->DOC+QRA->SERIE   //documento 
		nTotDoc := 0                   //total por documento
		nTotStd := 0                   //total por custo standart
		If Prow() > 55
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Endif
		If MV_PAR05 > 1 
		   @ Prow()+1,03 PSay "Documento ["+QRA->DOC+"/"+QRA->SERIE+"]"
		EndIf    
		Do While !Eof().And.QRA->OBRA = cObra.And.QRA->DOC+QRA->SERIE = cDoc
			If lAbortPrint  //verifica o cancelamento pelo usuario...
				@ Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			If Prow() > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			Endif
			IncRegua()
			
			If MV_PAR05 = 3       //tipo de relatorio item
				@ Prow()+1,05     PSay QRA->FILIAL
				@ Prow(),Pcol()+1 PSay Stod(QRA->EMISSAO) Picture "@D"
				@ Prow(),Pcol()+1 PSay QRA->CODPRD
				@ Prow(),Pcol()+1 PSay QRA->PEDIDO                                      //inserido para imprimir o numero do pedido - Luiz Henrique 20/08/2012
				@ Prow(),Pcol()+1 PSay QRA->DESCPRD
				@ Prow(),Pcol()+1 PSay QRA->TOTDOC   Picture "@RE 999,999,999.99"       //total por item do documento
				@ Prow(),Pcol()+1 PSay QRA->TOTSTD   Picture "@RE 999,999,999.99"       //total por custo standart
				@ Prow(),Pcol()+3 PSay QRA->DIF      Picture "@RE 999,999.99"           //diferenca entre total do doc por total do custo
				@ Prow(),Pcol()+1 PSay QRA->PRUNIT   Picture "@RE 999,999,999.99"       //preco unitario do documento
				@ Prow(),Pcol()+1 PSay QRA->CUSTOSTD Picture "@RE 999,999,999.99"       //preco untiario do custo standart
				@ Prow(),Pcol()+2 PSay QRA->QUANT    Picture "@RE 99,999.99"            //quantidade do item do documento
			EndIf
			
			nTotDoc += QRA->TOTDOC
			nTotStd += QRA->TOTSTD
			nObrDoc += QRA->TOTDOC
			nObrStd += QRA->TOTSTD
			nGerDoc += QRA->TOTDOC
			nGerStd += QRA->TOTSTD
			
			DbSkip() // Avanca o ponteiro do registro no arquivo
		EndDo
		//totaliza por origem : faturamento ou financeiro
		If MV_PAR05 = 3    //tipo de relatorio item
			@ Prow()+1,03 PSay Replicate("-",172)
			@ Prow()+1,05 PSay "Total " + cDoc
			@ Prow()  ,092 PSay nTotDoc Picture "@RE 999,999,999.99"
			@ Prow()  ,107 PSay nTotStd Picture "@RE 999,999,999.99"
		ElseIf MV_PAR05 = 2               //tipo de relatorio documento
			@ Prow()  ,50 PSay nTotDoc Picture "@RE 999,999,999.99"
			@ Prow()  ,66 PSay nTotStd Picture "@RE 999,999,999.99"
		EndIf
	EndDo
	//totaliza por obra    
	Do Case
	   Case MV_PAR05 = 3
	        @ Prow()+1,00 PSay "Total "+ cObra
	        @ Prow()  ,092 PSay nObrDoc Picture "@RE 999,999,999.99"
	        @ Prow()  ,107 PSay nObrStd Picture "@RE 999,999,999.99"
   	        @ Prow()+1,00 PSay Replicate("-",175)
	   Case MV_PAR05 = 2
	        @ Prow()+1,00 PSay "Total "+ cObra
	        @ Prow()  ,50 PSay nObrDoc Picture "@RE 999,999,999.99"
	        @ Prow()  ,66 PSay nObrStd Picture "@RE 999,999,999.99"
   	        @ Prow()+1,00 PSay Replicate("-",80)
    Otherwise
	        @ Prow()  ,50 PSay nObrDoc Picture "@RE 999,999,999.99"
	        @ Prow()  ,66 PSay nObrStd Picture "@RE 999,999,999.99"
	EndCase
EndDo
//totaliza geral
@ Prow()+1,00 PSay "Total Geral"
If MV_PAR05 < 3   
   @ Prow()  ,050 PSay nGerDoc Picture "@RE 999,999,999.99"
   @ Prow()  ,066 PSay nGerStd Picture "@RE 999,999,999.99"
Else
   @ Prow()  ,092 PSay nGerDoc Picture "@RE 999,999,999.99"
   @ Prow()  ,107 PSay nGerStd Picture "@RE 999,999,999.99"
EndIf   

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

Aadd(aPerg, {"01","Da Emissao ?"         ,"?","?","mv_ch1","D",8 ,"G","mv_par01","","","","","","","","","","",0,""})
Aadd(aPerg, {"02","Ate a Emissao ?"      ,"?","?","mv_ch2","D",8 ,"G","mv_par02","","","","","","","","","","",0,""})
Aadd(aPerg, {"03","Da Obra ?"            ,"?","?","mv_ch3","C",9 ,"G","mv_par03","","","","","","","","","","",0,"CTT"})
Aadd(aPerg, {"04","Ate a Obra ?"         ,"?","?","mv_ch4","C",9 ,"G","mv_par04","","","","","","","","","","",0,"CTT"})
Aadd(aPerg, {"05","Tipo Relatorio por ?" ,"?","?","mv_ch5","N",1 ,"C","mv_par05","Obra","","","","Documento","","","Item Documento","","",1,""}) 
Aadd(aPerg, {"06","De Produto ?"         ,"?","?","mv_ch6","C",15,"G","mv_par06","","","","","","","","","","",0,"SB1"})  // inserido Luiz Henrique 20/08/2012
Aadd(aPerg, {"07","Ate Produto ?"        ,"?","?","mv_ch7","C",15,"G","mv_par07","","","","","","","","","","",0,"SB1"})  // inserido Luiz Henrique 20/08/2012
Aadd(aPerg, {"08","Da Nota Fiscal ?"     ,"?","?","mv_ch8","C",9 ,"G","mv_par08","","","","","","","","","","",0,""})     // inserido Luiz Henrique 20/08/2012
Aadd(aPerg, {"09","Ate Nota Fiscal ?"    ,"?","?","mv_ch9","C",9 ,"G","mv_par09","","","","","","","","","","",0,""})     // inserido Luiz Henrique 20/08/2012
Aadd(aPerg, {"10","Do Pedido ?"          ,"?","?","mv_ch10","C",6 ,"G","mv_par10","","","","","","","","","","",0,""})    // inserido Luiz Henrique 20/08/2012
Aadd(aPerg, {"11","Ate Pedido ?"         ,"?","?","mv_ch11","C",6 ,"G","mv_par11","","","","","","","","","","",0,""})    // inserido Luiz Henrique 20/08/2012
Aadd(aPerg, {"12","Tipo de Retorno ? "  , "?","?","Mv_ch12","N",1 ,"C","Mv_par12","Material","","",1,"Equipamento","","",2,"","","","",""})// inserido Luiz Henrique 25/05/2015
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
		Replace X1_DEF03	With aPerg[nI,17]
		Replace X1_DEFSPA3	With aPerg[nI,18]
		Replace X1_DEFENG3	With aPerg[nI,19]
		Replace X1_PRESEL 	With aPerg[nI,20]
		Replace X1_F3    	With aPerg[nI,21]
		
		MsUnlock()
	EndIf
Next

DbSelectArea(cAlias)

Return



