#include "protheus.ch"
#include "topconn.ch"

User FuncTion MTA700MNU()

aAdd(aRotina,{"Copia Previsao","U_ALTDTPREV()",  0 , 6, 0, nil})
aadd( aRotina,{"Atualizar Preço"     ,"U_UPDSC4",0,7,0, nil} )

Return


User FuncTion ALTDTPREV()
Private oProcess//incluído o parâmetro lEnd para controlar o cancelamento da 
lEnd := .F.
cPerg  := "ALTDTPREV1"
aPergs := {}
Aadd(aPergs,{"Data Inicial ?" ,"",""	,"mv_ch1","D",8,0,0 ,"G","","MV_PAR01","","","","01/01/00","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Data Final ?"   ,"",""	,"mv_ch2","D",8,0,0 ,"G","","MV_PAR02","","","","01/01/00","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Data Previsao ?","",""	,"mv_ch3","D",8,0,0 ,"G","","MV_PAR03","","","","01/01/00","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Documento ?"    ,"",""	,"mv_ch4","C",9,0,0 ,"G","","MV_PAR04","","","",""        ,"","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(cPerg, aPergs)

If ! Pergunte(cPerg, .T.)
	Return
EndIf           

// Processa( {|| AtuSC4() }, "Alterando Previsao para: " + Dtoc(MV_PAR03), "Processando, aguarde...", .F. )

 oProcess := MsNewProcess():New({|lEnd| AtuSC4(@oProcess, @lEnd) },"Processando","aguarde...",.T.) 
 oProcess:Activate()

Return
                
Static FuncTion AtuSC4()
nCnt := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criar aquivo temporario com as movimentacoes de SC4...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SC4")
	aStruTRB1 := dbStruct()
	
	cNomeArq:=CriaTrab( aStruTRB1, .T. )
	dbUseArea(.T.,,cNomeArq,"TRB1",.T.,.F.)
	//ADel( aStruTRB1, 26 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varrer o SC4 respeitando filtrando com base nas perguntas ³
//³ temporarias.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC4")
nCnt := 0
cQuery := "SELECT C4_FILIAL,C4_PRODUTO,C4_LOCAL,C4_DOC,C4_QUANT,C4_VALOR,C4_DATA,C4_OBS,C4_GERACAO,C4_NUMOP,C4_NIVEL,C4_OPC,C4_USERLGI,C4_USERLGA,C4_LOGENV,C4_LOGREC,C4_GRADE,C4_ITEMGRD,C4_REVISAO,C4_IDGRADE,C4_XREG,C4_XVEND,C4_QTDBUDG,C4_VLRBUDG,C4_PMVBUDG,isnull(C4_MOPC,'') [C4_MOPC],C4_QTDORIG,C4_PRCVEN,C4_LOGALT,C4_LOGALT2 FROM "+RetSQLName("SC4")+" " // SET C4_DATA = '" + Dtos(MV_PAR03) + "'"
cQuery += " WHERE C4_DATA BETWEEN '" + Dtos(MV_PAR01)+ "' AND '" + Dtos(MV_PAR02) + "' AND D_E_L_E_T_ = ' '"

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TRB"

DbEval( {|| nCnt++ })     

nCount2 := 0
oProcess:SetRegua1(nCnt)
ProcRegua(nCnt)

DbSelectArea("TRB")
TRB->(DbGoTop())
While ! TRB->(Eof()) 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravar campos no arquivo TRB, Registros temporarios...           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 oProcess:IncRegua1("Lendo Previsao: " + SC4->C4_PRODUTO)
	// IncProc()             	
	/*
	n_Reg := TRB->NREG
	dbSelectArea("SC4")
	dbGoTo(n_Reg)
	RecLock("SC4",.F.)
		SC4->C4_DATA := MV_PAR03
	MsUnLock()
	*/
	
	dbSelectArea("TRB1")
	RecLock("TRB1",.T.)
	For nI := 1 To FCount()
		cNomeCmp := FieldName(nI)
		If Alltrim(Upper(cNomeCmp)) <> "C4_MOPC"   
			nPosCpo := TRB1->(FieldPos(cNomeCmp)) //TRB1->(FieldPos(TRB1->(Field(nI))))
			nPosCpoB := TRB->(FieldPos(cNomeCmp)) //Adicionado para pegar o posicionamento do campo na consulta
			TRB1->( FieldPut( nPosCpo , TRB->( FieldGet(nPosCpoB) ) ) )
		EndIf
	Next nI
	TRB1->C4_DATA := MV_PAR03
	TRB1->C4_DOC  := MV_PAR04
	MsUnLock()
	
	         
	nCount2 ++
	dbSelectArea("TRB")		
	dbSkip()
EndDo
// Alert("Alteração Finalizada...")

oProcess:SetRegua2(nCount2)	

DbSelectArea("TRB1")
TRB1->(DbGoTop())
While ! TRB1->(Eof()) 

	oProcess:IncRegua2("Gravando previsao: "+TRB1->C4_PRODUTO +" - para: "+ Dtoc(TRB1->C4_DATA) )

	dbSelectArea("SC4")
	RecLock("SC4",.T.)
	For nI := 1 To FCount()
		cNomeCmp := FieldName(nI)
		If Alltrim(Upper(cNomeCmp)) <> "C4_MOPC"
			nPosCpo := SC4->(FieldPos(cNomeCmp)) //TRB1->(FieldPos(TRB1->(Field(nI))))
			nPosCpoB := TRB1->(FieldPos(cNomeCmp)) //Adiciona para pegar o posicionamento da tabela temporaria
			SC4->( FieldPut( nPosCpo , TRB1->( FieldGet(nPosCpoB) ) ) )
		EndIf
	Next nI
	MsUnLock()         

	dbSelectArea("TRB1")
	dbSkip()
EndDo
TRB1->(DbCloseArea())

 Alert("Copia Finalizada...")

Return


Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

Return
