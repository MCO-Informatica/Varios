#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT008   º Autor ³ Mauro Nagata       º Data ³  02/05/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de requisicao de material                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT008


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de Requisição de Material"
Local cPict          := ""
Local titulo         := "Relatório de Requisição de Material"
//Local nLin           := 80

Local Cabec1         := "    Codigo            Descricao do                           UM  Quantidade"
Local Cabec2         := "    Produto           Produto                                    Requisitada"
Local imprime        := .T.
Private aOrd         := {"Nro.Requisicao","Obra","Projeto","Dt.Necessidade+Obra"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RFAT008" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RFAT008"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFAT008" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ7"

dbSelectArea("SZ7")
dbSetOrder(1)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Mauro Nagata       º Data ³  02/05/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo)

Local nOrdem
Local lIp       := .T.
Local cAliasSZ7 := "R008Trb"
Local aStruSZ7  :=  SZ7->(DbStruct())

dbSelectArea(cString)

nOrdem := aReturn[8]
//dbSetOrder(nOrdem)


cQuery := "SELECT *, CTT_DESC01, AF8_DESCRI, A1_NOME "
cQuery += "FROM SZ7010 SZ7 "
cQuery += "INNER JOIN AF8010 AF8 "
cQuery += "      ON AF8.D_E_L_E_T_ = '' "
cQuery += "         AND Z7_PROJETO   = AF8_PROJET "
cQuery += "INNER JOIN CTT010 CTT "
cQuery += "      ON CTT.D_E_L_E_T_ = '' "
cQuery += "         AND Z7_OBRA = CTT_CUSTO "
cQuery += "INNER JOIN SA1010 SA1 "
cQuery += "      ON SA1.D_E_L_E_T_ = '' "
cQuery += "         AND Z7_CLIENTE+Z7_LOJA = A1_COD+A1_LOJA "
cQuery += "WHERE SZ7.D_E_L_E_T_ = '' "
cQuery += "      AND Z7_CODIGO  BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += "      AND Z7_OBRA    BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += "      AND Z7_PROJETO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += "      AND Z7_CLIENTE+Z7_LOJA >= '" + MV_PAR07 + MV_PAR08 + "' "
cQuery += "      AND Z7_CLIENTE+Z7_LOJA <= '" + MV_PAR09 + MV_PAR10 + "' "
cQuery += "      AND Z7_NECESS  BETWEEN '" + Dtos(MV_PAR11) + "' AND '" + Dtos(MV_PAR12) + "' "
If !Empty(MV_PAR13)
	cQuery += "      AND Z7_STATUS           = '" + MV_PAR13 + "' "
EndIf
Do Case
	Case nOrdem = 1
		cQuery += "ORDER BY Z7_CODIGO "
		Titulo += " [Nro.Requisicao]"
	Case nOrdem = 2
		cQuery += "ORDER BY Z7_OBRA "
		Titulo += " [Codigo da Obra]"
	Case nOrdem = 3
		cQuery += "ORDER BY Z7_PROJETO "
		Titulo += " [Codigo do Projeto]"
	Case nOrdem = 4
		cQuery += "ORDER BY Z7_NECESS,Z7_OBRA "
		Titulo += " [Dt.Necessidade+Cod.Obra]"
EndCase

cQuery := ChangeQuery(cQuery)

Memowrite("RFAT008.SQL",cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZ7,.T.,.T.)

For nX := 1 To Len(aStruSZ7)
	If ( aStruSZ7[nX][2] <> "C" )
		TcSetField(cAliasSZ7,aStruSZ7[nX][1],aStruSZ7[nX][2],aStruSZ7[nX][3],aStruSZ7[nX][4])
	EndIf
Next nX


If MV_PAR14 = 2     //tipo de relatorio sintetico
	Cabec1 := Cabec2 := ""
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(-1)

DbGoTop()
Do While !EOF()
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@ Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If MV_PAR14 = 1 //tipo de relatorio analitico
		lIp := .T.
	EndIf
	
	If Prow() > 55.Or.lIp  // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		lIp := .F.
	Endif
	
	cStatus := (cAliasSZ7)->Z7_STATUS
	Do Case
		Case cStatus = "S"
			cStatus := "Requisitada"
		Case cStatus = "P"
			cStatus := "Aguardando analise"
		Case cStatus = "A"
			cStatus := "Requisicao aprovada"
		Case cStatus = "R"
			cStatus := "Requisicao reprovada"
		Case cStatus = "G"
			cStatus := "Gerado o pedido de vendas"
		Case cStatus = "E"
			cStatus := "Pedido de vendas estornado"
		Otherwise
			cStatus := "INDEFINIDO"
	EndCase
	
	@ Prow()+1,00      PSay "Obra         : " + (cAliasSZ7)->Z7_OBRA + "  ["+ AllTrim((cAliasSZ7)->CTT_DESC01)+"]"
	@ Prow(),101       PSay "Requisicao : " + Transform((cAliasSZ7)->Z7_CODIGO,"@R 999.999")
	@ Prow()+1,00      PSay "Projeto      : " + (cAliasSZ7)->Z7_PROJETO + " ["+ AllTrim(Substr((cAliasSZ7)->AF8_DESCRI,1,70)) +"]"
	@ Prow(),101       PSay "Revisao    : " + (cAliasSZ7)->Z7_REVISAO
	@ Prow()+1,00      PSay "Cliente      : " + Transform((cAliasSZ7)->Z7_CLIENTE,"@R 999.999")+"/"+(cAliasSZ7)->Z7_LOJA + " [" + AllTrim((cAliasSZ7)->A1_NOME) + "]"
	@ Prow()+1,00      PSay "Necessidade  : "  + Dtoc((cAliasSZ7)->Z7_NECESS)
	@ Prow(),101       PSay "Data       : " + Dtoc((cAliasSZ7)->Z7_DATA)
	@ Prow()+1,00      PSay "Status       : " + (cAliasSZ7)->Z7_STATUS + " [" + AllTrim(cStatus) + "]"
	@ Prow(),101       PSay "Pedido     : " + Transform((cAliasSZ7)->Z7_PEDIDO,"@R 999.999") + " [" + Dtoc((cAliasSZ7)->Z7_GERADOP) + "]"
	@ Prow()+1,00      PSay "Requisitante : " + (cAliasSZ7)->Z7_FISCAL
	@ Prow(),101       PSay "Usuario    : "  + (cAliasSZ7)->Z7_NOMUSER
	
	If MV_PAR14 = 2  //tipo de relatorio sintetico
		@ Prow()+1,00 PSay Replicate("-",132)
		@ Prow()+1,00 PSay ""
	EndIf
	
	DbSelectArea("SZ8")
	DbSetOrder(1)
	DbSeek(xFilial("SZ8")+(cAliasSZ7)->Z7_CODIGO)
	Do While !Eof().And.SZ8->Z8_CODIGO = (cAliasSZ7)->Z7_CODIGO
		If Prow() > 50  // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Endif
		
		cTarefa := SZ8->Z8_TAREFA
		cEdt    := Substr(cTarefa,1,RAt(".",cTarefa)-1)
		
		If MV_PAR14 = 1   //tipo de relatorio analitico
			DbSelectArea("AFC")
			DbSetOrder(1)
			DbSeek(xFilial("AFC")+(cAliasSZ7)->Z7_PROJETO+(cAliasSZ7)->Z7_REVISAO+cEdt)
			cDescEDT  := AFC_DESCRI
			@ Prow()+1,00 PSay Replicate("=",132)
			@ Prow()+1,00 PSay "EDT    : "+ cEdt + "           [" + AllTrim(cDescEdt)+"]"
			@ Prow()+1,00 PSay Replicate("=",132)
		EndIf
		
		DbSelectArea("SZ8")
		Do While !Eof().And.SZ8->Z8_CODIGO = (cAliasSZ7)->Z7_CODIGO.And.cEdt = Substr(cTarefa,1,RAt(".",cTarefa)-1)
			
			If Prow() > 55  // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			Endif
			
			cTarefa := SZ8->Z8_TAREFA
			If MV_PAR14 = 1   //tipo de relatorio analitico
				@ Prow()+1,00 PSay "TAREFA : " + cTarefa + " [" + AllTrim(SZ8->Z8_DESCTAR) + "]"
				@ Prow()+1,00 PSay Replicate("-",132)
			EndIf
			Do While !Eof().And.SZ8->Z8_CODIGO = (cAliasSZ7)->Z7_CODIGO.And.SZ8->Z8_TAREFA = cTarefa
				If Prow() > 55  // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				Endif
				If MV_PAR14 = 1   //tipo de relatorio analitico
					@ Prow()+1,05     PSay Z8_PRODUTO
					@ Prow(),Pcol()+1 PSay Z8_DESCPRD
					@ Prow(),Pcol()+1 PSay GetAdvFVal("SB1","B1_UM",xFilial("SB1")+SZ8->Z8_PRODUTO,1,"Nao encontrado")
					@ Prow(),Pcol()+1 PSay Z8_QTDSOL Picture "@RE 999,999.99"
				EndIf
				
				DbSelectArea("SZ8")
				DbSkip()
			EndDo
		EndDo
	EndDo
	DbSelectArea(cAliasSZ7)
	DbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

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

DbSelectArea(cAliasSZ7)
DbCloseArea(cAliasSZ7)

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

Aadd(aPerg, {"01","Da Requisicao ?"     ,"?","?","mv_ch1","C",6 ,"G","mv_par01","","","","","","","",0,"SZ7"})
Aadd(aPerg, {"02","Ate a Requisicao ?"  ,"?","?","mv_ch2","C",6 ,"G","mv_par02","","","","","","","",0,"SZ7"})
Aadd(aPerg, {"03","Da Obra ?"           ,"?","?","mv_ch3","C",9 ,"G","mv_par03","","","","","","","",0,"CTT"})
Aadd(aPerg, {"04","Ate a Obra ?"        ,"?","?","mv_ch4","C",9 ,"G","mv_par04","","","","","","","",0,"CTT"})
Aadd(aPerg, {"05","Do Projeto ?"        ,"?","?","mv_ch5","C",10,"G","mv_par05","","","","","","","",0,"AF8"})
Aadd(aPerg, {"06","Ate o Projeto ?"     ,"?","?","mv_ch6","C",10,"G","mv_par06","","","","","","","",0,"AF8"})
Aadd(aPerg, {"07","Do Cliente ?"        ,"?","?","mv_ch7","C",6 ,"G","mv_par07","","","","","","","",0,"SA1"})
Aadd(aPerg, {"08","Da Loja ?"           ,"?","?","mv_ch8","C",2 ,"G","mv_par08","","","","","","","",0,""})
Aadd(aPerg, {"09","Ate o Cliente ?"     ,"?","?","mv_ch9","C",6 ,"G","mv_par09","","","","","","","",0,"SA1"})
Aadd(aPerg, {"10","Ate a Loja ?"        ,"?","?","mv_cha","C",2 ,"G","mv_par10","","","","","","","",0,""})
Aadd(aPerg, {"11","Da Necessidade ?"    ,"?","?","mv_chb","D",8 ,"G","mv_par11","","","","","","","",0,""})
Aadd(aPerg, {"12","Ate a Necessidade ?" ,"?","?","mv_chc","D",8 ,"G","mv_par12","","","","","","","",0,""})
Aadd(aPerg, {"13","Status ?"            ,"?","?","mv_chd","C",1 ,"G","mv_par13","","","","","","","",0,""})
Aadd(aPerg, {"14","Tipo Relatorio ?"    ,"?","?","mv_che","N",1 ,"C","mv_par14","Analitico","","","","Sintetico","","",1,""})

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




