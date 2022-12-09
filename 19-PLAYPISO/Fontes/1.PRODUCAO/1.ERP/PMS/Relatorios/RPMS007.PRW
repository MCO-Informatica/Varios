#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPMS007  º Autor ³ Mauro Nagata       º Data ³ 31/08/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Requisição de Material                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda/PlayPiso www.actualtrend.com.br                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RPMS007()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio  "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Requisição de Material                              "
Local cPict          := ""
Local titulo         := "Relatório de Requisição de Material"
Local nLin           := 80

Local Cabec1         := "     Codigo          Descricao                                UM     Qtde.          Qtde.em     Qtde.      Saldo"
Local Cabec2         := "     Produto         Produto                                         Requisitada    Pedido      Faturada   Nao Faturado"
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RPMS007" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RPMS007"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnfrel        := "RPMS007" // Coloque aqui o nome do arquivo usado para impressao em disco

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
Local cQuery   := ""                   
Local cAtPed   := ""
Local cFasePrj := ""
//Local cFilaux := If(cFilAnt $ "04.03","04",cFilAnt)       ACTUAL 23/09/2016
Local cFilaux := If(cFilAnt $ "04.03","01",cFilAnt)
Local nTamAP 
Local nTamFase

nTamAP := Len(AllTrim(MV_PAR12))
For nI := 1 To nTamAP
    cAtPed += "'"+Substr(MV_PAR12,nI,1)+"'"
    If nTamAp != nI
       cAtPed += "," 
    EndIf
Next              
nTamFase := Len(AllTrim(MV_PAR16))/2
For nI := 1 To nTamFase
    cFasePrj += "'"+Substr(MV_PAR16,((nI-1)*2)+1,2)+"'"
    If nTamFase != nI
       cFasePrj += "," 
    EndIf
Next              
                 
If MV_PAR11 = 2   //atendimento do pedido parcial com saldo a faturar
   cQuery := "SELECT * "
   cQuery += "FROM ( "
EndIf      
cQuery += "      SELECT Z7_OBRA OBRA,Z8_PRODUTO PRODUTO,Z8_DESCPRD DESCR,B1_UM UM, "
cQuery += "             SUM(Z8_QTDSOL) AS QRM,IsNull(SUM(C6_QTDVEN),0) AS QPD, "
cQuery += "             IsNull(SUM(D2_QUANT),0) AS QFT,SUM(Z8_QTDEXT) AS QEX, "  
cQuery += "             AF8_CODF1 FISC1,AF8_CODF2 FISC2, "					+Chr(13)+Chr(10)
cQuery += "             AF8_FASE AS FASE "										+Chr(13)+Chr(10)
cQuery += "      FROM SZ7010 Z7 "													+Chr(13)+Chr(10)
cQuery += "      LEFT JOIN SZ8010 Z8 "												+Chr(13)+Chr(10)
cQuery += "           ON Z8.D_E_L_E_T_<>'*' "									+Chr(13)+Chr(10)
cQuery += "              AND Z7_CODIGO = Z8_CODIGO "							+Chr(13)+Chr(10)
cQuery += "      LEFT JOIN SB1010 B1 "												+Chr(13)+Chr(10)
cQuery += "           ON B1.D_E_L_E_T_<>'*' "									+Chr(13)+Chr(10)
cQuery += "              AND Z8_PRODUTO = B1_COD "    						+Chr(13)+Chr(10)
cQuery += "              AND B1_FILIAL = '"+xFilial("SB1")+"' "			+Chr(13)+Chr(10)
cQuery += "      LEFT JOIN SC6010 C6 "												+Chr(13)+Chr(10)
cQuery += "           ON C6.D_E_L_E_T_<>'*' "									+Chr(13)+Chr(10)
cQuery += "              AND C6_FILIAL = '"+cFilAux+"' "						+Chr(13)+Chr(10)
cQuery += "              AND C6_NUM     = Z7_PEDIDO "							+Chr(13)+Chr(10)
cQuery += "              AND C6_PRODUTO = Z8_PRODUTO "						+Chr(13)+Chr(10)
cQuery += "              AND C6_PEDCLI  = Z7_CODIGO "							+Chr(13)+Chr(10)
cQuery += "              AND C6_CCUSTO  = Z7_OBRA " 							+Chr(13)+Chr(10)
cQuery += "              AND C6_TASKPMS = Z8_TAREFA "   						+Chr(13)+Chr(10)
cQuery += "      LEFT JOIN AF8010 AF8 "											+Chr(13)+Chr(10)
cQuery += "           ON AF8.D_E_L_E_T_ <> '*' "								+Chr(13)+Chr(10)
cQuery += "              AND AF8.AF8_PROJET = C6_PROJPMS " 	  				+Chr(13)+Chr(10)
cQuery += "              AND AF8.AF8_FILIAL = '"+xFilial("AF8")+"' "  	+Chr(13)+Chr(10)
cQuery += "              AND AF8.AF8_FASE   IN ("+cFasePrj+") "         +Chr(13)+Chr(10)
cQuery += "      LEFT JOIN SD2010 D2 "												+Chr(13)+Chr(10)
cQuery += "            ON D2.D_E_L_E_T_<>'*' "									+Chr(13)+Chr(10)
cQuery += "               AND D2_FILIAL = '"+cFilAux+"' "					+Chr(13)+Chr(10)
cQuery += "	              AND D2_PEDIDO = C6_NUM "								+Chr(13)+Chr(10)
cQuery += "	              AND D2_ITEMPV = C6_ITEM "							+Chr(13)+Chr(10)
cQuery += "               AND D2_DOC    = C6_NOTA "   						+Chr(13)+Chr(10)
cQuery += "               AND D2_COD    = C6_PRODUTO "						+Chr(13)+Chr(10)
cQuery += "       WHERE Z7.D_E_L_E_T_<>'*' "										+Chr(13)+Chr(10)
cQuery += "             AND Z7_OBRA BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "    +Chr(13)+Chr(10)
cQuery += "             AND Z7_STATUS IN ("+cAtPed+") " 										+Chr(13)+Chr(10)                              //('G','P','E','S','R','A') "     
cQuery += "             AND Z7_CODIGO  BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " +Chr(13)+Chr(10)   
cQuery += "             AND Z8_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " +Chr(13)+Chr(10)
cQuery += "             AND Z7_PEDIDO  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " +Chr(13)+Chr(10)
cQuery += "             AND Z7_NECESS  BETWEEN '"+Dtos(MV_PAR09)+"' AND '"+Dtos(MV_PAR10)+"' "    +Chr(13)+Chr(10)
cQuery += "             AND ( ( ( SUBSTRING(Z7_OBRA,3,1) = 'P' OR SUBSTRING(Z7_OBRA,3,1) NOT IN ('L','R') ) AND '"+cFilAux+"' = '02' ) OR ( ( SUBSTRING(Z7_OBRA,3,1) IN ('L','R') OR SUBSTRING(Z7_OBRA,3,1) <> 'P' ) AND '"+cFilAux+"' IN ('03','04') )) "+Chr(13)+Chr(10)
cQuery += "       GROUP BY Z8_PRODUTO,Z7_OBRA,Z8_DESCPRD,B1_UM,AF8_CODF1,AF8_CODF2,AF8_FASE  "+Chr(13)+Chr(10)
If MV_PAR11 = 2  //atendimento da requisicao parcial, faturado parcialmente o pedido 
   cQuery += "      ) AS x "			+Chr(13)+Chr(10)
   cQuery += "WHERE QRM > QFT "		+Chr(13)+Chr(10)
   cQuery += "ORDER BY OBRA,DESCR "	+Chr(13)+Chr(10)
Else  //atendimento total do pedido
   cQuery += "ORDER BY OBRA,DESCR " +Chr(13)+Chr(10)  
EndIf   


MemoWrite('RPMS007.sql', cQuery)

If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
EndIf
TcQuery cQuery New Alias "QRY"       
TcSetField("QRY","QRM","N",15,2) 
TcSetField("QRY","QPD","N",15,2) 
TcSetField("QRY","QFT","N",15,2) 

If QRY->(EOF())
	Return
EndIf

DbSelectArea("QRY")
DbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(-1)

lIp := .T.
DbGoTop()
Do While !Eof()
	cObra   := QRY->OBRA    //codigo da obra
	If Prow() > 55.Or.lIp
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//If MV_PAR15 = 2 .And. MV_PAR11 = 2  //tipo de relatorio sintetico e atendimento do pedido parcial
		If MV_PAR11 = 2  //atendimento do pedido parcial
		   @ Prow()+1,00 PSay "*** Requisicao de Material Pendente ***"
		Else   
		   @ Prow()+1,00 PSay "*** Requisicao de Material Faturado + Pendente ***"
		EndIf   
		lIp := .F.
	Endif
	//If (QRY->FISC1 $ MV_PAR13+"."+MV_PAR14.And. !Empty(AllTrim(QRY->FISC1))) .Or. (QRY->FISC2 $ MV_PAR13+"."+MV_PAR14.And. !Empty(AllTrim(QRY->FISC2)) .Or. Empty(AllTrim(QRY->FISC1+QRY->FISC2)))
   If !((QRY->FISC1 $ MV_PAR13+"."+MV_PAR14.And. !Empty(AllTrim(QRY->FISC1))).Or. (QRY->FISC2 $ MV_PAR13+"."+MV_PAR14.And. !Empty(AllTrim(QRY->FISC2))) .Or.Empty(QRY->FISC1+QRY->FISC2))
      DbSelectArea("QRY")	
	   DbSkip()      
	   Loop
	EndIf   
	cNomeF1 := AllTrim(GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"ZZ"+QRY->FISC1,1,""))
	cNomeF2 := AllTrim(GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"ZZ"+QRY->FISC2,1,""))
	@ Prow()+2,00      PSay "Obra:"+ QRY->OBRA
	@ Prow(),Pcol()    PSay "["
	@ Prow(),Pcol()    PSay AllTrim(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+cObra,1,""))
	@ Prow(),Pcol()    PSay "]"        
   @ Prow(),60        PSay "Fiscal: ["+cNomeF1+If(!Empty(cNomeF2),"/"+cNomeF2,"")+"]"
   @ Prow(),95			  PSay "Fase: ["+ AllTrim(GetAdvFVal("AEA","AEA_DESCRI",xFilial("AEA")+QRY->FASE,1,""))+"]"
   
	Do While !Eof().And.QRY->OBRA = cObra
		If Prow() > 55
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   //If MV_PAR15 = 2 .And. MV_PAR11 = 2  //tipo de relatorio sintetico e atendimento do pedido parcial
		   If MV_PAR11 = 2  //atendimento do pedido parcial
			   @ Prow()+1,00 PSay "*** Requisicao de Material com Atendimento Parcial ***"
			EndIf   
		Endif                                                                                                     
	   If lAbortPrint  //verifica o cancelamento pelo usuario...
			@ Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
			
		IncRegua()
		
		If MV_PAR15 = 2	//tipo de relatorio analitico
			@ Prow()+1,05     PSay QRY->PRODUTO                                 //codigo do produto
			@ Prow(),Pcol()+1 PSay QRY->DESCR                                   //descricao do produto
			@ Prow(),Pcol()+1 PSay QRY->UM                                      //unidade de medida
			@ Prow(),Pcol()+6 PSay QRY->QRM Picture "@RE 999,999.99"            //quantidade na requisicao de material
			@ Prow(),Pcol()+3 PSay QRY->QPD Picture "@RE 999,999.99"            //quantidade em pedido
			@ Prow(),Pcol()+1 PSay QRY->QFT Picture "@RE 999,999.99"            //quantidade faturada
			@ Prow(),Pcol()+1 PSay QRY->QRM-QRY->QFT Picture "@RE 999,999.99"  //saldo		
		EndIf
	
		DbSelectArea("QRY")	
		DbSkip() // Avanca o ponteiro do registro no arquivo
   EndDo
EndDo

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
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Mauro Nagata        ³Data³ 04/09/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()

Local cAlias := Alias(), aPerg := {}
Local nI, nPerg

Aadd(aPerg, {"01","Da Obra ?"            ,"?","?","mv_ch1" ,"C",9 ,"G","mv_par01","","","","","","","","","","",0,"CTT"})
Aadd(aPerg, {"02","Ate a Obra ?"         ,"?","?","mv_ch2" ,"C",9 ,"G","mv_par02","","","","ZZZZZZZZZ","","","","","","",0,"CTT"})  
Aadd(aPerg, {"03","De Produto ?"         ,"?","?","mv_ch3" ,"C",15,"G","mv_par03","","","","","","","","","","",0,"SB1"})  
Aadd(aPerg, {"04","Ate Produto ?"        ,"?","?","mv_ch4" ,"C",15,"G","mv_par04","","","","ZZZZZZZZZZZZZZZ","","","","","","",0,"SB1"})  
Aadd(aPerg, {"05","Do Cod.Req.Mat. ?"    ,"?","?","mv_ch5" ,"C",6 ,"G","mv_par05","","","","","","","","","","",0,"SZ7"})  
Aadd(aPerg, {"06","Ate Cod.Req.Mat ?"    ,"?","?","mv_ch6" ,"C",6 ,"G","mv_par06","","","","ZZZZZZ","","","","","","",0,"SZ7"})  
Aadd(aPerg, {"07","Do Pedido ?"          ,"?","?","mv_ch7" ,"C",6 ,"G","mv_par07","","","","","","","","","","",0,"SC5"})    
Aadd(aPerg, {"08","Ate Pedido ?"         ,"?","?","mv_ch8" ,"C",6 ,"G","mv_par08","","","","ZZZZZZ","","","","","","",0,"SC5"})    
Aadd(aPerg, {"09","Da Dt.Necessidade ?"  ,"?","?","mv_ch9" ,"D",8 ,"G","mv_par09","","","","","","","","","","",0,""})
Aadd(aPerg, {"10","Ate a Necessidade ?"  ,"?","?","mv_cha" ,"D",8 ,"G","mv_par10","","","","","","","","","","",0,""})
Aadd(aPerg, {"11","Saldo Requisicao ?"   ,"?","?","mv_chb" ,"N",1 ,"C","mv_par11","Faturado+Pendente","","","","Pendente","","","","","",1,""}) 
Aadd(aPerg, {"12","Status RM[SGPARE] ?"  ,"?","?","mv_chc" ,"C",6 ,"G","mv_par12","","","","SGPARE","","","","","","",0,""})       
Aadd(aPerg, {"13","Qual o Fiscal ?"      ,"?","?","mv_chd" ,"C",2 ,"G","mv_par13","","","","","","","","","","",0,"ZZ"})    
Aadd(aPerg, {"14","Qual o Fiscal ?"      ,"?","?","mv_chd" ,"C",2 ,"G","mv_par14","","","","","","","","","","",0,"ZZ"})           
Aadd(aPerg, {"15","Tipo de Relatório ?"  ,"?","?","mv_che" ,"N",1 ,"C","mv_par15","Sintetico","","","","Analitico","","","","","",1,""}) 
Aadd(aPerg, {"16","Fase do Projeto ?"    ,"?","?","mv_chf" ,"C",20,"G","mv_par16","","","","0102030405060708","","","","","","",0,"AEA"})    



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



