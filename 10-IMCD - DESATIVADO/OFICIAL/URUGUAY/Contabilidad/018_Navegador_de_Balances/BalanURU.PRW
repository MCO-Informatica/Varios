#INCLUDE "rwmake.ch"
#Include "PROTHEUS.Ch"
#Include "TCBrowse.ch"
#INCLUDE "DBINFO.CH"

Static cAliasTMP := ""

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Balance  ³ Autor ³ Urudata SA				   ³ Data ³ 20/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balance Contable                                                  ³±±
±±³          ³                          										 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function BalanURU


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracion de Variables                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cArqTmp	:= ""

Private cPerg   := "BALANCE"
Private cCadastro := "Balance Contable"

PRIVATE cIndTMP1 := CriaTrab(Nil,.f.)
PRIVATE cIndTMP2 := CriaTrab(Nil,.f.)

cAliasTMP := GetNextAlias()

//AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
EndIf
//Aca se va a ejecutar la funcion que genera los datos de acuerdo a los datos pasados por el usuario y arma la tabla temporal.
//Funcion para barra de progreso

dbSelectArea("CTO")
dbSetOrder(1)
If Empty( mv_par05 ) .OR. !dbSeek(xFilial("CTO")+mv_par05,.F.)
    Help(" ",1,"NOMOEDA")
	Return(.F.)
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | GenBalance(@cArqTmp)},"Generando Balance Contable","Balance Contable")
EndIf

If ((cAliasTMP)->(Eof()))
	MsgAlert("No hay datos")
Else
	BrwBalance(@cArqTmp)
EndIf

dbSelectArea(cAliasTMP)
Set Filter To
dbCloseArea() 
If Select(cAliasTMP) == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF

Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GenBalance³ Autor ³ Urudata SA				   ³ Data ³ 12/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Balance Contable                                                  ³±±
±±³          ³                          										 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GenBalance(cArqTmp)

Local oMeter
Local oText
Local oDlg

//Parametros que recibe la rutina CTGerPlan
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ mv_par01				// Data Inicial                  	  		  ³
//³ mv_par02				// Data Final                        		  ³
//³ mv_par03				// Conta Inicial                         	  ³
//³ mv_par04				// Conta Final  							  ³
//³ mv_par05				// Imprime Contas: Sintet/Analit/Ambas   	  ³
//³ mv_par06				// Set Of Books				    		      ³
//³ mv_par07				// Saldos Zerados?			     		      ³
//³ mv_par08				// Moeda?          			     		      ³
//³ mv_par09				// Pagina Inicial  		     		    	  ³
//³ mv_par10				// Saldos? Reais / Orcados	/Gerenciais   	  ³
//³ mv_par11				// Quebra por Grupo Contabil?		    	  ³
//³ mv_par12				// Filtra Segmento?					    	  ³
//³ mv_par13				// Conteudo Inicial Segmento?		   		  ³
//³ mv_par14				// Conteudo Final Segmento?		    		  ³
//³ mv_par15				// Conteudo Contido em?				    	  ³
//³ mv_par16				// Imprime Coluna Mov ?				    	  ³
//³ mv_par17				// Salta linha sintetica ?			    	  ³
//³ mv_par18				// Imprime valor 0.00    ?			    	  ³
//³ mv_par19				// Imprimir Codigo? Normal / Reduzido  		  ³
//³ mv_par20				// Divide por ?                   			  ³
//³ mv_par21				// Imprimir Ate o segmento?			   		  ³
//³ mv_par22				// Posicao Ant. L/P? Sim / Nao         		  ³
//³ mv_par23				// Data Lucros/Perdas?                 		  ³
//³ mv_par24				// Imprime Quadros Contábeis?				  ³		
//³ mv_par25				// Rec./Desp. Anterior Zeradas?				  ³		
//³ mv_par26				// Grupo Receitas/Despesas?      			  ³		
//³ mv_par27				// Data de Zeramento Receita/Despesas?		  ³		
//³ mv_par28                // Num.linhas p/ o Balancete Modelo 1		  ³ 
//³ mv_par29				// Descricao na moeda?						  ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aSetOfBook := CTBSetOf("")

//Cualquier duda sobre los parametros consultar fuente CTBR040 linea 413
// Consultar CTBXSAL linea 1334
U_CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,mv_par06,mv_par07,mv_par08,mv_par09,mv_par10,mv_par11,mv_par05,;
				"1",aSetOfBook,"","","","",;
				.F.,.F.,2,,.F.,mv_par01,1,.T.,,,,,,,,,,,,,,.T.,,.T.,;
				"",,,,,,,,"01")

IndRegua(cAliasTMP,cIndTMP1,"Conta",,,"",.F.)
IndRegua(cAliasTMP,cIndTMP2,"Desccta",,,"",.F.)

dbClearIndex()

dbSelectArea(cAliasTMP)
dbSetIndex(cIndTMP1+OrdBagExt())
dbSetIndex(cIndTMP2+OrdBagExt())
dbSetOrder(1)

((cAliasTMP)->(dbGoTop()))

While !((cAliasTMP)->(EOF()))
	If (cAliasTMP)->(Normal) == "1" //.OR. SUBSTR(((cAliasTMP)->(Conta)),1,1) == "3"
	   	RecLock(cAliasTMP, .F.)
		(cAliasTMP)->(SaldoAtu) := ((cAliasTMP)->(SaldoAtu)) * -1		
		MsUnLock()
	EndIf
	DbSkip()
EndDo

((cAliasTMP)->(dbGoTop()))
		

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³BrwBalance ³ Autor ³ Urudata SA				   ³ Data ³ 12/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balance Contable para browse                                                 ³±±
±±³          ³                          										 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function BrwBalance(cArqTmp)   

LOCAL nAlias
Local oDlg,oBrw,oCOl,oComboInd,oGetInd,oBtnInd
Local aBrowse:={},ni, aCpos, nCpo
Local aSize		:= MsAdvSize(,.F.,430)
Local aSizeAut 	:= MsAdvSize()						

Local aObjects	:= {	{ 500,  70, .T., .T. },;
						{ 200, 950, .T., .T., .T. },;						
						{ 100, 100, .T., .T. }	}
						
Local aInfo   		:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 } 
Local aPosObj 		:= MsObjSize( aInfo, aObjects, .T. ) 
Local aArea 		:= GetArea()
Local cPictVal  	:= PesqPict("CT2","CT2_VALOR")
Local nX			:= 0
Local aButtons		:= {}
Local aIndTMP		:= {"1-Codigo","2-Descripcion"}
Local cInd			:= "1"
Local cChave		:= Space(30)

aadd(aButtons,{"S4WB005N",     {|| (CT1->(dbSeek(xFilial("CT1")+(cAliasTMP)->CONTA)) , U_MayorURU()) }					    ,"Generar Mayor","Mayor"})

aCpos := ((cAliasTMP)->(DbStruct()))

nAlias 	:= Select(cAliasTMP)
   				
aBrowse := {	{"Cuenta Contable"	,"CONTA" },;
				{"Descripción"		,"DESCCTA" },;
				{"Total Debito"		,"SALDOATUDB" },;
				{"Total Credito"	,"SALDOATUCR" },;
   				{"Saldo"			,"SALDOATU" }	}

dbSelectArea(cAliasTMP)
((cAliasTMP)->(DbSetOrder(1)))
((cAliasTMP)->(dbGoTop()))

DEFINE 	MSDIALOG oDlg TITLE cCadastro;
		From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

@ 15,4 COLUMN BROWSE oBrw SIZE 	aPosObj[2][3],aPosObj[2][4] PIXEL OF oDlg
oBrw:lMChange := .T.  // Permitir o ajuste do tamanho dos campos
For ni := 1 to Len(aBrowse)
	nCpo := Ascan(aCpos, { |x| x[1] = aBrowse[ni][2]})
	If aCpos[nCpo][2] != "N"
		nSize := CalcFieldSize(aCpos[nCpo][2],aCpos[nCpo][3],aCpos[nCpo][4],"",aBrowse[ni][1]) - If(aCpos[nCpo][2] = "D", 7, 0)
		If aBrowse[ni][2] == "DESCCTA"
			nSize := nSize*2
		EndIf
		DEFINE COLUMN oCol DATA FieldWBlock(aBrowse[ni][2], nAlias);
		HEADER aBrowse[ni][1];
		SIZE nSize
	Else
		DEFINE COLUMN oCol DATA FieldWBlock(aBrowse[ni][2], nAlias) PICTURE cPictVal;
		HEADER aBrowse[ni][1];
		SIZE CalcFieldSize(aCpos[nCpo][2],aCpos[nCpo][3],aCpos[nCpo][4],cPictVal,aBrowse[ni][1]) RIGHT
	Endif
	oBrw:ADDCOLUMN(oCol)
Next ni

//Boton de busqueda
@ aPosObj[3][1],010 COMBOBOX oComboInd VAR cInd ITEMS aIndTMP ON CHANGE ( (cAliasTMP)->(DbSetOrder(Val(cInd))) , oBrw:Refresh()) SIZE 50,08 OF oDlg PIXEL
@ aPosObj[3][1],075 MSGET oGetInd VAR cChave SIZE 80,08 PIXEL
@ aPosObj[3][1],170 BUTTON oBtnInd PROMPT "&Buscar" SIZE 40,10 PIXEL ACTION ((cAliasTMP)->(DbSeek(cChave)))

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons)

Return NIL

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSX1 ³ Autor ³ Urudata SA				   ³ Data ³ 12/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grupo de preguntas para elegir Asientos Contables                                                  ³±±
±±³          ³                          										 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local aPergs	:= {}
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe fecha inicial" )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "01","De Fecha ?","De Fecha ?","De Fecha ?","mv_ch1","D", 8, 0, 0,"G","","","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR02--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe fecha final" )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "02","Hasta Fecha ?","Hasta Fecha ?","Hasta Fecha ?","mv_ch2","D", 8, 0, 0,"G","","","","S","mv_par02","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR03--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe la Cuenta inicial para          " )
Aadd( aHelpPor, "impresion                               " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "03","De Cuenta ?","De Cuenta ?","De Cuenta ?","mv_ch3","C",20, 0, 0,"G","","CT1","","S","mv_par03","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR04--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe la cuenta final para            " )
Aadd( aHelpPor, "impresion                               " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "04","Hasta Cuenta ?","Hasta Cuenta ?","Hasta Cuenta ?","mv_ch4","C",20, 0, 0,"G","","CT1","","S","mv_par04","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR05--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe la Moneda para impresion        " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "05","Moneda ?","Moneda ?","Moneda ?","mv_ch5","C",2, 0, 0,"G","","","","S","mv_par05","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

////////////////------------------------------

/*-----------------------MV_PAR06--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe el Centro de Costo para          " )
Aadd( aHelpPor, "impresion                               " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "06","De Centro de Costo ?","De Centro de Costo ?","De Centro de Costo ?","mv_ch6","C",TAMSX3("CTT_CUSTO")[1], 0, 0,"G","","CTT","","S","mv_par06","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR07--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe el Centro Costo final para            " )
Aadd( aHelpPor, "impresion                               " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "07","Hasta Centro de Costo ?","Hasta Centro de Costo ?","Hasta Centro de Costo ?","mv_ch7","C",TAMSX3("CTT_CUSTO")[1], 0, 0,"G","","CTT","","S","mv_par07","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR08--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe la Clase Valor para          " )
Aadd( aHelpPor, "impresion                               " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "08","De Clase Valor ?","De Clase Valor ?","De Clase Valor ?","mv_ch8","C",TAMSX3("CTH_CLVL")[1], 0, 0,"G","","CTH","","S","mv_par08","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR09--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe la Clase Valor para            " )
Aadd( aHelpPor, "impresion                               " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "09","Hasta Clase Valor ?","Hasta Clase Valor ?","Hasta Clase Valor ?","mv_ch9","C",TAMSX3("CTH_CLVL")[1], 0, 0,"G","","CTH","","S","mv_par09","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR10--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe Item Contable para          " )
Aadd( aHelpPor, "impresion                               " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "10","De Item Contable ?","De Item Contable ?","De Item Contable ?","mv_cha","C",TAMSX3("CTD_ITEM")[1], 0, 0,"G","","CTD","","S","mv_par10","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

/*-----------------------MV_PAR11--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Informe Item Contable para            " )
Aadd( aHelpPor, "impresion                               " )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
aAdd(aPergs, {cPerg, "11","Hasta Item Contable ?","Hasta Item Contable ?","Hasta Item Contable ?","mv_chb","C",TAMSX3("CTD_ITEM")[1], 0, 0,"G","","CTD","","S","mv_par11","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa})

U_UyPutSx1(aPergs)

Return NIL
 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtGerPlan ³ Autor ³ Simone Mie Sato       ³ Data ³ 25.08.01          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 01-oMeter      = Controle da regua                                  ³±±
±±³          ³ 02-oText       = Controle da regua                                  ³±±
±±³          ³ 03-oDlg        = Janela                                             ³±±
±±³          ³ 04-lEnd        = Controle da regua -> finalizar                     ³±±
±±³          ³ 05-cArqTmp     = Arquivo temporario                                 ³±±
±±³          ³ 06-dDataIni    = Data Inicial de Processamento                      ³±±
±±³          ³ 07-dDataFim    = Data Final de Processamento                        ³±±
±±³          ³ 08-cAlias      = Alias do Arquivo                                   ³±±
±±³          ³ 09-cIdent      = Identificador do arquivo a ser processado          ³±±
±±³          ³ 10-cContaIni   = Conta Inicial                                      ³±±
±±³          ³ 11-cContaFim	= Conta Final                                          ³±±
±±³          ³ 12-cCCIni      = Centro de Custo Inicial                            ³±±
±±³          ³ 13-cCCFim      = Centro de Custo Final                              ³±±
±±³          ³ 14-cItemIni    = Item Inicial                                       ³±±
±±³          ³ 15-cItemFim    = Item Final                                         ³±±
±±³          ³ 16-cClvlIni    = Classe de Valor Inicial                            ³±±
±±³          ³ 17-cClvlFim    = Classe de Valor Final                              ³±±
±±³          ³ 18-cMoeda      = Moeda	                                            ³±±
±±³          ³ 19-cSaldos     = Tipos de Saldo a serem processados                 ³±±
±±³          ³ 20-aSetOfBook  = Matriz de configuracao de livros                   ³±±
±±³          ³ 21-cSegmento   = Indica qual o segmento sera filtrado               ³±±
±±³          ³ 22-cSegIni     = Conteudo Inicial do segmento                       ³±±
±±³          ³ 23-cSegFim     = Conteudo Final do segmento                         ³±±
±±³          ³ 24-cFiltSegm   = Filtra por Segmento   		                       ³±±
±±³          ³ 25-lNImpMov    = Se Imprime Entidade sem movimento                  ³±±
±±³          ³ 26-lImpConta   = Se Imprime Conta                                   ³±±
±±³          ³ 27-nGrupo      = Grupo                                              ³±±
±±³          ³ 28-cHeader     = Identifica qual a Entidade Principal               ³±±
±±³          ³ 29-lImpAntLP   = Se imprime lancamentos Lucros e Perdas             ³±±
±±³          ³ 30-dDataLP     = Data da ultima Apuracao de Lucros e Perdas         ³±±
±±³          ³ 31-nDivide     = Divide valores por (100,1000,1000000)              ³±±
±±³          ³ 32-lVlrZerado  = Grava ou nao valores zerados no arq temporario     ³±±
±±³          ³ 33-cFiltroEnt  = Entidade Gerencial que servira de filtro dentro    ³±±
±±³          ³                  de outra Entidade Gerencial. Ex.: Centro de Custo  ³±±
±±³          ³                  sendo filtrado por Item Contabil (CTH)             ³±±
±±³          ³ 34-cCodFilEnt  = Codigo da Entidade Gerencial utilizada como filtro ³±±
±±³          ³ 35-cSegmentoG  = Filtra por Segmento Gerencial (CC/Item ou ClVl)    ³±±
±±³          ³ 36-cSegIniG    = Segmento Gerencial Inicial                         ³±±
±±³          ³ 37-cSegFimG    = Segmento Gerencial Final                           ³±±
±±³          ³ 38-cFiltSegmG  = Segmento Gerencial Contido em                      ³±±
±±³          ³ 39-lUsGaap     = Se e Balancete de Conversao de moeda               ³±±
±±³          ³ 40-cMoedConv   = Moeda para a qual buscara o criterio de conversao  ³±±
±±³          ³                  no Pl.Contas                                       ³±±
±±³          ³ 41-cConsCrit   = Criterio de conversao utilizado: 1-Diario, 2-Medio,³±±
±±³          ³                  3-Mensal, 4-Informada, 5-Plano de Contas           ³±±
±±³          ³ 42-dDataConv   = Data de Conversao                                  ³±±
±±³          ³ 43-nTaxaConv   = Taxa de Conversao                                  ³±±
±±³          ³ 44-aGeren      = Matriz que armazena os compositores do Pl. Ger.    ³±±
±±³          ³ 			        para efetuar o filtro de relatorio.                ³±±
±±³          ³ 45-lImpMov     = Nao utilizado                                      ³±±
±±³          ³ 46-lImpSint    = Se atualiza sinteticas                             ³±±
±±³          ³ 47-cFilUSU     = Filtro informado pelo usuario                      ³±±
±±³          ³ 48-lRecDesp0   = Se imprime saldo anterior do periodo anterior      ³±±
±±³          ³                  zerado                                             ³±±
±±³          ³ 49-cRecDesp    = Grupo de receitas e despesas                       ³±±
±±³          ³ 50-dDtZeraRD   = Data de zeramento de receitas e despesas           ³±±
±±³          ³ 51-lImp3Ent    = Se e Balancete C.Custo / Conta / Item              ³±±
±±³          ³ 52-lImp4Ent    = Se e Balancete por CC x Cta x Item x Cl.Valor      ³±±
±±³          ³ 53-lImpEntGer  = Se e Balancete de Entidade (C.Custo/Item/Cl.Vlr    ³±±
±±³          ³                  por Entid. Gerencial)                              ³±±
±±³          ³ 54-lFiltraCC   = Se considera o filtro das perguntas para C.Custo   ³±±
±±³          ³ 55-lFiltraIt   = Se considera o filtro das perguntas para Item      ³±±
±±³          ³ 56-lFiltraCV   = Se considera o filtro das perguntas para Cl.Valor  ³±±
±±³          ³ 57-cMoedaDsc   = Codigo da moeda para descricao das entidades       ³±±
±±³          ³ 58-lMovPeriodo = Se imprime movimento do periodo anterior           ³±±
±±³          ³ 59-aSelFil     = Array de filiais                                   ³±±
±±³          ³ 60-dDtCorte    = Data de Corte para calculo do saldo anterior       ³±±
±±³          ³ 61-lPlGerSint  = Imprime visao gerencial sintetica? Padrao .F.      ³±±
±±³          ³ 62-lConsSaldo  = Consolida saldo ? Padrao .F.                       ³±±
±±³          ³ 63-lCompEnt    = Consolida saldo entre entidades? Padrao .F.        ³±±
±±³          ³ 64-cAliasTMP     = Arquivo auxiliar permitindo a recursividade        ³±±
±±³          ³ 65-lUsaNmVis   = Usa nome da visao gerencial ? Padrao .F.           ³±±
±±³          ³ 66-cNomeVis    = Nome da visao gerencial (retorno, passar por ref.) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTGerPlan(oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,;
						cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,;
						cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,;
						cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,;
						nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,;
						cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,lUsGaap,cMoedConv,;
						cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
						cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent,lImpEntGer,lFiltraCC,lFiltraIt,lFiltraCV,cMoedaDsc,;
						lMovPeriodo,aSelFil,dDtCorte,lPlGerSint,lConsSaldo,lCompEnt,lUsaNmVis,cNomeVis)

Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamItem  	:= TAMSX3("CTD_ITEM")
Local aTamItRes 	:= TAMSX3("CTD_RES")    
Local aTamClVl  	:= TAMSX3("CTH_CLVL")
Local aTamCvRes 	:= TAMSX3("CTH_RES")
Local aTamVal		:= TAMSX3("CT2_VALOR")

Local aCtbMoeda		:= {}
Local aSaveArea 	:= GetArea()
Local aCampos
Local cChave
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
Local nTamItem		:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
Local nTamClVl		:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
Local nDecimais		:= 0
Local cCodigo		:= ""
Local cCodGer		:= ""
Local cEntidIni		:= ""
Local cEntidFim		:= ""           
Local cEntidIni1	:= ""
Local cEntidFim1	:= ""
Local cEntidIni2	:= ""
Local cEntidFim2	:= ""
Local cArqTmp1		:= ""
Local cMascaraG 	:= ""
Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor 
Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.) 
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local nInicio		:= Val(cMoeda)
Local nFinal		:= Val(cMoeda)
Local nCampoLP		:= 0
Local cFilDe		:= xFilial(cAlias)
Local cFilAte		:= xFilial(cAlias), nOrdem := 1
Local cCodMasc		:= ""
Local cMensagem		:= OemToAnsi("A")// O plano gerencial ainda nao esta disponivel nesse relatorio. 
Local nPos			:= 0
Local nCont			:= 0 
Local lTemQuery		:= .F.
Local nX
Local lCriaInd		:= .F.
Local nTamFilial 	:= 2
Local lCT1EXDTFIM	:= CtbExDtFim("CT1")
Local lCTTEXDTFIM	:= CtbExDtFim("CTT")
Local lCTDEXDTFIM	:= CtbExDtFim("CTD")
Local lCTHEXDTFIM	:= CtbExDtFim("CTH")

Local nSlAntGap		:= 0	// Saldo Anterior
Local nSlAntGapD	:= 0	// Saldo anterior debito
Local nSlAntGapC	:= 0	// Saldo anterior credito	
Local nSlAtuGap		:= 0	// Saldo Atual           
Local nSlAtuGapD	:= 0	// Saldo Atual debito
Local nSlAtuGapC	:= 0	// Saldo Atual credito
Local nSlDebGap		:= 0	// Saldo Debito
Local nSlCrdGap		:= 0	// Saldo Credito

#IFDEF TOP
	Local aStruTmp		:= {}
	Local lTemQry		:= .F.
	Local nTrb			:= 0	                              
#ENDIF

Local nDigitos		:= 0
Local nMeter		:= 0
Local nPosG			:= 0
Local nDigitosG		:= 0 

//Variaveis para atualizar a regua desde as rotinas de geracao do arquivo temporario
Private oMeter1 		:= oMeter
Private oText1 		:= oText

DEFAULT lConsSaldo   := .F.
DEFAULT lPlGerSint   := .F.
DEFAULT cSegmentoG 	:= ""
DEFAULT lUsGaap		:=.F.
DEFAULT cMoedConv	:= ""
DEFAULT	cConsCrit	:= ""
DEFAULT dDataConv	:= CTOD("  /  /  ")
DEFAULT nTaxaConv	:= 0
DEFAULT lImpSint	:= .T.                                              
DEFAULT lImpMov		:= .T.
DEFAULT cSegmento	:= ""
DEFAULT cFilUsu		:= ".T."
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""                
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")
DEFAULT lImp3Ent	:= .F.
DEFAULT lImp4Ent	:= .F.
DEFAULT lImpEntGer	:= .F.
DEFAULT lImpConta	:= .T.
DEFAULT lFiltraCC	:= .F.
DEFAULT lFiltraIt	:= .F.
DEFAULT lFiltraCV	:= .F.
DEFAULT cMoedaDsc	:= '01'
DEFAULT lMovPeriodo := .F.
DEFAULT aSelFil 	:= {}
DEFAULT dDtCorte 	:= CTOD("  /  /  ")
DEFAULT lCompEnt	:= .F.
DEFAULT cArqTmp 	:= Nil
DEFAULT lUsaNmVis	:= .F.

__aTmpTCFil	:=	{}

If lRecDesp0 .And. ( Empty(cRecDesp) .Or. Empty(dDtZeraRD) )
	lRecDesp0 := .F.
EndIf

If FindFunction( "IsCtbJob" ) .And. IsCtbJob()
	DbSelectArea("CVO")
	CTBJobsStart()
	CheckCVO()
Endif

cIdent		:=	Iif(cIdent == Nil,'',cIdent)
nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)                                                 
cHeader		:= Iif(cHeader == Nil,'',cHeader)
cFiltroEnt	:= Iif(cFiltroEnt == Nil,"",cFiltroEnt)
cCodFilEnt	:= Iif(cCodFilEnt == Nil,"",cCodFilEnt)
Private nMin			:= 0
Private nMax			:= 0 

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
dMinData := CTOD("")


If ExistBlock("ESPGERPLAN")
	ExecBlock("ESPGERPLAN",.F.,.F.,{oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,;
									cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,;
									cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,;
									cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,lUsGaap,cMoedConv,;
									cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
									cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent,lImpEntGer,lFiltraCC,lFiltraIt,lFiltraCV,aSelFil,dDtCorte})

	Return(cArqTmp)
EndIf

If cAlias == 'CTY'	//Se for Balancete de 2 Entidades filtrando pela 3a Entidade.
	aCampos := {{ "ENTID1"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "ENTRES1"	, "C", aTamCtaRes[1],0 },;  			// Codigo Reduzido da Conta
				 { "DESCENT1"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
	 			 { "TIPOENT1"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico				 
 				 { "ENTSUP1"	, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
	   	         { "ENTID2"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "ENTRES2"	, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "DESCENT2"	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
				 { "TIPOENT2"	, "C", 01			, 0 },;				// Item Analitica / Sintetica			 
				 { "ENTSUP2"	, "C", aTamItem[1]	, 0 },; 			// Codigo do Item Superior
		 		 { "NORMAL"		, "C", 01			, 0 },;				// Situacao
				 { "SALDOANT"	, "N", aTamVal[1]+2, nDecimais},; 		// Saldo Anterior
	 		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
			 	 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
			 	 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+2, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
			     { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
		    	 { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
			  	 { "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se 
														 				// eh de nivel 1 -> usado como
ElseIf cAlias == 'CVY'	//Se for Balancete por cubo contabil

	aCampos := { { "ECX"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "ECXSUP"		, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "ECXNORMAL"	, "C", 01			, 0 },;				// Situacao
				 { "ECXRES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
				 { "ECXDESC"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
				 { "ECY"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "ECYSUP"		, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "ECYNORMAL"	, "C", 01			, 0 },;				// Situacao
				 { "ECYRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "ECYDESC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
				 { "SALDOANT"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior
	   		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
 				 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
				 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+1	, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
				 { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "TIPOECX"	, "C", 01			, 0 },;				// Conta Analitica / Sintetica           
 				 { "TIPOECY"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
			     { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
   			     { "ESTOUR" 	, "C", 01			, 0 },;			 	//Define se a conta esta estourada ou nao
				 { "NIVEL1"		, "L", 01			, 0 },; 
			 	 { "NATCTA"     , "C", 02           , 0 }}             //NATCTA -campo de natureza da conta para relatorio CTBR047					 

																		// totalizador do relatorio
Else
	aCampos := { { "CONTA"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "SUPERIOR"	, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "NORMAL"		, "C", 01			, 0 },;				// Situacao
				 { "CTARES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
				 { "DESCCTA"	, "C", nTamCta		, 0 },;  			// Descricao da Conta        
				 { "CUSTO"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "CCRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "DESCCC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
		         { "ITEM"		, "C", aTamItem[1]	, 0 },; 	 		// Codigo do Item          
				 { "ITEMRES" 	, "C", aTamItRes[1], 0 },;  			// Codigo Reduzido do Item
				 { "DESCITEM" 	, "C", nTamItem		, 0 },;  			// Descricao do Item
	             { "CLVL"		, "C", aTamClVl[1]	, 0 },; 	 		// Codigo da Classe de Valor
    	         { "CLVLRES"	, "C", aTamCVRes[1], 0 },; 		 	// Cod. Red. Classe de Valor
				 { "DESCCLVL"   , "C", nTamClVl		, 0 },;  			// Descricao da Classe de Valor
				 { "SALDOANT"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior
	   		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
 				 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
				 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+1	, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
				 { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "TIPOCONTA"	, "C", 01			, 0 },;				// Conta Analitica / Sintetica           
 				 { "TIPOCC"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
	 			 { "TIPOITEM"	, "C", 01			, 0 },;				// Item Analitica / Sintetica			 
 				 { "TIPOCLVL"	, "C", 01			, 0 },;				// Classe de Valor Analitica / Sintetica			 
	 			 { "CCSUP"		, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
				 { "ITSUP"		, "C", aTamItem[1]	, 0 },;				// Codigo do Item Superior
	 			 { "CLSUP"	    , "C", aTamClVl[1] , 0 },;				// Codigo da Classe de Valor Superior
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
			     { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
   			     { "ESTOUR" 	, "C", 01			, 0 },;			 	//Define se a conta esta estourada ou nao
				 { "NIVEL1"		, "L", 01			, 0 },; 
			 	 { "NATCTA"     , "C", 02           , 0 }}             //NATCTA -campo de natureza da conta para relatorio CTBR047					 
					                                                 	// Logico para identificar se 
																		// eh de nivel 1 -> usado como
	   		                                                           // totalizador do relatorio]

// Usado no mutacoes de patrimonio liquido inclui campo que alem da descricao da entidade
// Que esta no DESCCTA tem tambem a descricao da conta inicial CTS_CT1INI   
	If 	Type("lTRegCts") # "U" .And. ValType(lTRegCts) = "L" .And. lTRegCts
		Aadd(aCampos, { "DESCORIG"	, "C", nTamCta		, 0 } )	// Descricao da Origem do Valor
	Endif
EndIf

Aadd(aCampos, { "FILIAL"	, "C", nTamFilial, 0 } )	// Cria Filial do Sistema
If CTS->(FieldPos("CTS_COLUNA")) > 0
	Aadd(aCampos, { "COLUNA"   	, "N", 01			, 0 })
Endif
If 	Type("dSemestre") # "U" .And. ValType(dSemestre) = "D"
	Aadd(aCampos, { "SALDOSEM"	, "N", 17		, nDecimais }) 	// Saldo semestre
Endif

If Type("dPeriodo0") # "U" .And. ValType(dPeriodo0) = "D"
	Aadd(aCampos, { "SALDOPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
	Aadd(aCampos, { "MOVIMPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
Endif

If Type("lComNivel") # "U" .And. ValType(lComNivel) = "L"
	Aadd(aCampos, { "NIVEL"   	, "N", 01			, 0 })		// Nivel hieraquirco - Quanto maior mais analitico
Endif

If ( cAlias = "CT7" .And. SuperGetMv("MV_CTASUP") = "S" ) .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTT" .And. GetNewPar("MV_CCSUP","")  == "S")  .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTD" .And. GetNewPar("MV_ITSUP","") == "S") .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTH" .And. GetNewPar("MV_CLSUP","") == "S") 
	Aadd(aCampos, { "ORDEMPRN" 	, "N", 06			, 0 })		// Ordem para impressao
Endif

If lMovPeriodo
	Aadd(aCampos, { "MOVPERANT"		, "N" , 17			, nDecimais }) 	// Saldo Periodo Anterior
EndIf
     
///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
	dIniRep := ctod("")
  	If Need2Reproc(dDataFim,cMoeda,cSaldos,@dIniRep) 
		//Chama Rotina de Atualizacao de Saldos Basicos.
		oProcess := MsNewProcess():New({|lEnd|	CTBA190(.T.,dIniRep,dDataFim,cFilAnt,cFilAnt,cSaldos,.T.,cMoeda) },"","",.F.)
		oProcess:Activate()						
	EndIf
Endif	

//// TRATAMENTO PARA ATUALIZAÇÃO DE SALDOS COMPOSTOS ANTES DE EXECUTAR A QUERY DE FILTRAGEM
Do Case
Case cAlias == 'CTU'
	//Verificar se tem algum saldo a ser atualizado por entidade
	If cIdent == "CTT"
		cOrigem := 	'CT3'
	ElseIf cIdent == "CTD"
		cOrigem := 	'CT4'
	ElseIf cIdent == "CTH"
		cOrigem := 	'CTI'		
	Else
		cOrigem := 	'CTI'		
	Endif
Case cAlias == 'CTV'
	cOrigem := "CT4"
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTW'			
	cOrigem		:= 'CTI'	/// HEADER POR CLASSE DE VALORES
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTX'			
	cOrigem		:= 'CTI'		
EndCase	
              
IF cAlias$("CTU/CTV/CTW/CTX")
	Ct360Data(cOrigem,cAlias,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
		oProcess:Activate()	
	Else		//Se nao atualiza os saldos compostos, somente da mensagem
		If !Empty(dMinData)
			cMensagem	:= "A"
			cMensagem	+= "A"		
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
			Return							//atraves da rotina de saldos compostos	
		EndIf    
	EndIf	
Endif

Do Case
//************************************
// Consulta saldo pelo cubo contabil *
//************************************
Case cAlias  == "CVY"
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	cCodMasc		:= aSetOfBook[2]
	cChave := "ECX+ECY"

	#IFDEF TOP   
		If TcSrvType() != "AS/400"                     			
			//Se nao tiver plano gerencial. 
			If Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				If cFilUsu == ".T."
					cFilUsu := ""
				EndIf
				CtbRunCube(dDataIni,dDataFim,cAlias,cEntidIni,cEntidFim,cCCIni,cCCFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUsu,cMoedaDsc,aSelFil,dDtCorte)
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif						
				lTemQuery := .T.
			Endif
		EndIf
	#ENDIF

Case cAlias  == "CT7"            
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	cCodMasc		:= aSetOfBook[2]
	If nGrupo == 2
		cChave := "CONTA"
	Else									// Indice por Grupo -> Totaliza por grupo
		cChave := "CONTA+GRUPO"
	EndIf

	#IFDEF TOP   
		If TcSrvType() != "AS/400"                     			
			//Se nao tiver plano gerencial. 
			If Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				If cFilUsu == ".T."
					cFilUsu := ""
				EndIf
				CT7BlnQry(dDataIni,dDataFim,cAlias,cEntidIni,cEntidFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUsu,cMoedaDsc,aSelFil,dDtCorte)
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif						
				lTemQuery := .T.
			Endif
		EndIf
	#ENDIF

Case cAlias == 'CT3'    
	cEntidIni	:= cCCIni
	cEntidFim	:= cCCFim

	If lImpConta	
		If cHeader == "CT1"
			cChave		:= "CONTA+CUSTO"
			cCodMasc	:= aSetOfBook[2]				
		Else
			If nGrupo == 2
				cChave   := "CUSTO+CONTA"                      
			Else									// Indice por Grupo -> Totaliza por grupo
				cChave := "CUSTO+CONTA+GRUPO"
			EndIf	
			cCodMasc	:= aSetOfBook[2]					
			cMascaraG	:= aSetOfBook[6]			
		Endif
	Else		//Balancete de Centro de Custo (filtrando por conta) 
		cChave	:= "CUSTO"
		cCodMasc:= aSetOfBook[6]
	EndIf

	#IFDEF TOP
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			If lImpConta
				IF !lCompEnt
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT3BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil)						
				Else
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT3BlnQryC(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil)
				Endif
			Else
				Ct3Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
					cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
							lRecDesp0,cRecDesp,dDtZeraRD,aSelFil)									
			EndIf						
			lTemQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif												
		EndIf
	#ENDIF		

Case cAlias =='CT4' 
	If lImp3Ent	//Balancete CC / Conta / Item
		If cHeader == "CTT"
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT4Bln3Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil)
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif	
				EndIf
			#ENDIF		
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cChave		:= "CUSTO+CONTA+ITEM"
			cCodMasc	:= aSetOfBook[2]
		EndIf	
	Else
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim
		If lImpConta
			If cHeader == "CT1"	//Se for for Balancete Conta x Item
				cChave	:= "CONTA+ITEM"
				cCodMasc		:= aSetOfBook[4]			
			Else
				cChave   := "ITEM+CONTA"	
				cCodMasc		:= aSetOfBook[2]					
			EndIf	
		Else	//Balancete de Item filtrando por conta
			cChave		:= "ITEM"
			cCodMasc	:= aSetOfBook[7]
		EndIf
		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			If lImpConta
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				CT4BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cItemIni,cItemFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil)						
			Else
				Ct4Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
							cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
							lRecDesp0,cRecDesp,dDtZeraRD,aSelFil)																										
			EndIf
			lTemQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif												
			EndIf
		#ENDIF	
	EndIf
Case cAlias == 'CTI'     
	If lImp4Ent	//Balancete CC x Cta x Item x Cl.Valor
		If cHeader == "CTT"             
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5]) .and. !lImpAntLP
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CTIBln4Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
								cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,aSelFil)						
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF				
			cChave		:= "CUSTO+CONTA+ITEM+CLVL"
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cCodMasc	:= aSetOfBook[2]			
		EndIf	
	Else
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim
	
		If lImpConta
			If cHeader == "CT1"
				cChave		:= "CONTA+CLVL"
				cCodMasc	:= aSetOfBook[2]				
			Else		
				cChave   := "CLVL+CONTA"
			EndIf     
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])							
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CTIBlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cClVlIni,cClVlFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil)						
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF							
		Else	//Balancete de Cl.Valor filtrando por conta
			cChave   := "CLVL"
			cCodMasc := aSetOfBook[8]	
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])			
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					CtIBln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
					cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
					lRecDesp0,cRecDesp,dDtZeraRD,aSelFil)													
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF							
		EndIf
	EndIf
Case cAlias == 'CTU'
	If cIdent == 'CTT'
		cEntidIni	:= cCCIni
		cEntidFim	:= cCCFim	
		cChave		:= "CUSTO"
		cCodMasc		:= aSetOfBook[6]		
	ElseIf cIdent == 'CTD'
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim		
		cChave   := "ITEM"
		cCodMasc		:= aSetOfBook[7]		
	ElseIf cIdent == 'CTH'
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim		
		cChave   := "CLVL"
		cCodMasc		:= aSetOfBook[8]		
	Endif
	#IFDEF TOP  
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			CTUBlnQry(dDataIni,dDataFim,cAlias,cIdent,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,aSelFil)						
			lTEmQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif								
		EndIf
	#ENDIF	
Case cAlias == 'CTV'           
	If cHeader == 'CTT'
		cChave   := "CUSTO+ITEM"	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD'
		cChave   := "ITEM+CUSTO"	
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim
	EndIf
Case cAlias == 'CTW'
	If cHeader	== 'CTT'
		cChave   := "CUSTO+CLVL"			
		cEntidIni1	:=	cCCIni
		cEntidFim1	:=	cCCFim 	            		
		cEntidIni2	:=	cClVlIni
		cEntidFim2	:=	cClVlFim		
	ElseIf cHeader == 'CTH'                
		cChave   := "CLVL+CUSTO"			
		cEntidIni1	:=	cClVlIni
		cEntidFim1	:=	cClVlFim
		cEntidIni2	:=	cCCIni
		cEntidFim2	:=	cCCFim 	
	EndIf	
Case cAlias == 'CTX'
	If cHeader == 'CTD'
		cChave  	 := "ITEM+CLVL"			
		cEntidIni1	:= 	cItemIni
		cEntidFim1	:= 	cItemFim
		cEntidIni2	:= 	cClVlIni
		cEntidFim2	:= 	cClVlFim		
	ElseIf cHeader == 'CTH'
		cChave  	 := "CLVL+ITEM"			
		cEntidIni1	:= 	cClVlIni
		cEntidFim1	:= 	cClVlFim			
		cEntidIni2	:= 	cItemIni 	
		cEntidFim2	:= 	cItemFim 	
	EndIf                                
Case cAlias	== 'CTY'
	cChave			:="ENTID1+ENTID2"
	If cHeader == 'CTT' .And. cFiltroEnt == 'CTD'	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cClVlIni
		cEntidFim2	:= cClvlFim
	ElseIf cHeader == 'CTT' .And. cFiltroEnt == 'CTH'
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTT'
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cClVlIni
		cEntidFim2	:= cClVlFim	
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTH'
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTT'
		cEntidIni1	:= cClVlIni
		cEntidFim1	:= cClVlFim	
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTD'
		cEntidIni1	:= cClVlIni
		cEntidFim1	:= cClVlFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim					
	EndIf		
EndCase

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	If cAlias $ "CT3/CT4/CTI"		//Se for Balancete Entidade/Entidade Gerencial
		Do Case
		Case cAlias == "CT3"
			cChave	:= "CUSTO+CONTA"			
		Case cAlias == "CT4"
			cChave	:= "ITEM+CONTA"						
		Case cAlias == "CTI"
			cChave	:= "CLVL+CONTA"						
		EndCase		
	ElseIf cAlias = 'CTU'
		Do Case
		Case cIdent = 'CTT'
			cChave	:= "CUSTO"		
		Case cIdent = 'CTD'
			cChave	:= "ITEM"		
		Case cIdent = 'CTH'
			cChave	:= "CLVL"		
		EndCase	
	Else
	   cChave	:= "CONTA"
	EndIf	   
Endif


If Empty( aCampos )
	ConOut("Erro na criacao da tabela temporaria")
	Return .F.
EndIf

cArqTmp := CriaTrab(aCampos, .T.)
dbUseArea( .T.,, cArqTmp, cAliasTMP, .F., .F. )
lCriaInd := .T.

DbSelectarea(cAliasTMP)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCriaInd
	cArqInd	:= CriaTrab(Nil, .F.)
	IndRegua(cAliasTMP,cArqInd,cChave,,,OemToAnsi("A"))  //"Selecionando Registros..."

	If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
		cArqTmp1 := CriaTrab(, .F.)
		IndRegua(cAliasTMP,cArqTmp1,"ORDEM",,,OemToAnsi("A"))  //"Selecionando Registros..."
	Endif	
	
	dbSelectArea(cAliasTMP)
	DbClearIndex()
	dbSetIndex(cArqInd+OrdBagExt())
	
	If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
		dbSetIndex(cArqTmp1+OrdBagExt())
	Endif
Endif
#IFDEF TOP
	If FunName() <> "CTBR195" .or. (FunName() == "CTBR195" .and. !lImpAntLP)
		//// SE FOR DEFINIÇÃO TOP 
		If TcSrvType() != "AS/400" .and. lTemQuery .and. Select("TRBTMP") > 0 	/// E O ALIAS TRBTMP ESTIVER ABERTO (INDICANDO QUE A QUERY FOI EXECUTADA)							
			If !Empty(cSegmento)
				If Len(aSetOfBook) == 0 .or. Empty(aSetOfBook[1])
					Help("CTN_CODIGO")
					Return(cArqTmp)
				Endif
				dbSelectArea("CTM")
				dbSetOrder(1)
				If MsSeek(xFilial()+cCodMasc)
					While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
						nPos += Val(CTM->CTM_DIGITO)
						If CTM->CTM_SEGMEN == strzero(val(cSegmento),2)
							nPos -= Val(CTM->CTM_DIGITO)
							nPos ++
							nDigitos := Val(CTM->CTM_DIGITO)      
							Exit
						EndIf	
						dbSkip()
					EndDo	
				Else
					Help("CTM_CODIGO")
					Return(cArqTmp)
				EndIf	
			EndIf	
			
			If cAlias == "CT3" .And. cHeader == "CTT" .And. !Empty(cMascaraG)
				If !Empty(cSegmentoG)
					dbSelectArea("CTM")
					dbSetOrder(1)
					If MsSeek(xFilial()+cMascaraG)
						While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascaraG
							nPosG += Val(CTM->CTM_DIGITO)
							If CTM->CTM_SEGMEN == cSegmentoG
								nPosG -= Val(CTM->CTM_DIGITO)
								nPosG ++
								nDigitosG := Val(CTM->CTM_DIGITO)      
								Exit
							EndIf	
							dbSkip()
						EndDo	
					EndIf	
				EndIf		
			EndIf	
			
  			dbSelectArea("TRBTMP")
			aStruTMP := dbStruct()			/// OBTEM A ESTRUTURA DO TMP

			nCampoLP	 := Ascan(aStruTMP,{|x| x[1]=="SLDLPANTDB"})
			dbSelectArea("TRBTMP")
			If ValType(oMeter) == "O"				
				oMeter:SetTotal(TRBTMP->(RecCount()))
				oMeter:Set(0)
			EndIf

			dbGoTop()						/// POSICIONA NO 1º REGISTRO DO TMP
			While TRBTMP->(!Eof())			/// REPLICA OS DADOS DA QUERY (TRBTMP) PARA P/ O TEMPORARIO EM DISCO
		
				//Se nao considera apuracao de L/P sera verificado na propria query
				dbSelectArea("TRBTMP")								
				If !lVlrZerado .And. lImpAntLP
					If TRBTMP->((SALDOANTDB - SLDLPANTDB) - (SALDOANTCR - SLDLPANTCR)) == 0 .And. ;
						TRBTMP->(SALDODEB-MOVLPDEB) == 0 .And. TRBTMP->(SALDOCRD-MOVLPCRD) == 0					
						dbSkip()
						Loop  				
					EndIf				
				ElseIf !lVlrZerado
					If TRBTMP->(SALDOANTDB - SALDOANTCR) == 0 .And. TRBTMP->SALDODEB == 0 .And. TRBTMP->SALDOCRD == 0
						dbSkip()
						Loop				
					EndIf								
				EndIf					

				//Verificacao da  Data Final de Existencia da Entidade somente se imprime saldo zerado 
				// e se realemten nao tiver saldo e movimento para a entidade. Caso tenha algum movimento
				//ou saldo devera imprimir.  												
				If lVlrZerado 
					If lImpAntLP 					
						If ((SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
							(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0)
							//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
							//relatorio for maior, nao ira imprimir a entidade. 
							If  cAlias $ "CT7/CT3/CT4/CTI" 
							lType := iif(type( 'TRBTMP->CT1DTEXSF' ) # 'U',.t.,.f.)
								If lCT1EXDTFIM .AND. lType
									IF !Empty(TRBTMP->CT1DTEXSF) .And. (dDataIni > TRBTMP->CT1DTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
								EndIf
							Endif
							
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
								lType := iif(type( 'TRBTMP->CTTDTEXSF' ) # 'U',.t.,.f.)
								If lCTTEXDTFIM .and. lType
									If !Empty(TRBTMP->CTTDTEXSF) .And. (dDataIni > TRBTMP->CTTDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf                     
								Endif
							EndIf                               
					
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								lType := iif(type( 'TRBTMP->CTDDTEXSF' ) # 'U',.t.,.f.)
								If lCTDEXDTFIM .AND. lType
									IF !Empty(TRBTMP->CTDDTEXSF) .And. (dDataIni > TRBTMP->CTDDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
			                    EndIf                           
			      			Endif

							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
							lType := iif(type( 'TRBTMP->CTHDTEXSF' ) # 'U',.t.,.f.)
								If lCTHEXDTFIM .AND. lType
									If !Empty(TRBTMP->CTHDTEXSF) .And. (dDataIni > TRBTMP->CTHDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									Endif
								EndIf
							EndIf 										
						EndIf
					Else                            
						If (SALDOANTDB  == 0 .And. SALDOANTCR  == 0 .And. SALDODEB == 0 .And. SALDOCRD == 0) 
							If cAlias $ "CT7/CT3/CT4/CTI" .AND. type( 'TRBTMP->CT1DTEXSF' ) # 'U'
				 				If lCT1EXDTFIM .AND. !Empty(TRBTMP->CT1DTEXSF) .And. (dDataIni > TRBTMP->CT1DTEXSF)  
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop													
								EndIf																								
							EndIf                                                               																
							
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								lType := iif(type( 'TRBTMP->CTTDTEXSF' ) # 'U',.t.,.f.)
								If lCTTEXDTFIM .AND. lType
									IF !Empty(TRBTMP->CTTDTEXSF) .And. (dDataIni > TRBTMP->CTTDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									Endif
								EndIf							
							EndIf														
						
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
					 			If lCTDEXDTFIM .AND. type( 'TRBTMP->CTDDTEXSF' ) # 'U'
					 				IF !Empty(TRBTMP->CTDDTEXSF) .And. (dDataIni > TRBTMP->CTDDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop
									EndIf   
								Endif
		                    EndIf                           
		
							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
							lType := iif(type( 'TRBTMP->CTHDTEXSF' ) # 'U',.t.,.f.)
					 			If lCTHEXDTFIM .AND. lType
					 				IF !Empty(TRBTMP->CTHDTEXSF) .And. (dDataIni > TRBTMP->CTHDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
								Endif
							EndIf	                    								
						EndIf
					EndIf
				EndIf
			
				If cAlias == "CTU"              
					Do Case
					Case cIdent	== "CTT"
						cCodigo	:= TRBTMP->CUSTO
					Case cIdent	== "CTD"
						cCodigo	:= TRBTMP->ITEM
					Case cIdent	== "CTH"
						cCodigo	:= TRBTMP->CLVL					
					EndCase                   
				Else
					If lImpConta .Or. cAlias == "CT7"
						cCodigo	:= TRBTMP->CONTA
					Else
						If cAlias == "CT3"
							cCodigo	:= TRBTMP->CUSTO							
						ElseIf cAlias == "CT4"
							cCodigo	:= TRBTMP->ITEM							
						ElseIf cAlias == "CTI"
							cCodigo	:= TRBTMP->CLVL												
						EndIf
					EndIf
					If cAlias == "CT3" .And. cHeader == "CTT"
						cCodGer	:= TRBTMP->CUSTO						
					EndIf
				EndIf
			
				If !Empty(cSegmento)
					If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
						If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) ) 
							dbSkip()
							Loop
						EndIf	
					Else
						If Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
							Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
							dbSkip()
							Loop
						EndIf	
					Endif
				EndIf		

				//Caso faca filtragem por segmento gerencial,verifico se esta dentro 
				//da solicitacao feita pelo usuario. 
				If cAlias == "CT3" .And. cHeader == "CTT"
					If !Empty(cSegmentoG)
						If Empty(cSegIniG) .And. Empty(cSegFimG) .And. !Empty(cFiltSegmG)
							If  !(Substr(cCodGer,nPosG,nDigitosG) $ (cFiltSegmG) ) 
								dbSkip()
								Loop
							EndIf	
						Else
		 					If Substr(cCodGer,nPosG,nDigitosG) < Alltrim(cSegIniG) .Or. ;
								Substr(cCodGer,nPosG,nDigitosG) > Alltrim(cSegFimG)
								dbSkip()
								Loop
							EndIf	
						Endif
					EndIf						
				EndIf
									
				If &("TRBTMP->("+cFILUSU+")")				
					RecLock(cAliasTMP,.T.)   
					
					For nTRB := 1 to Len(aStruTMP)
						Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])			
						If Subs(aStruTmp[nTRB][1],1,6) $ "SALDODEB/SALDOCRD/SALDOANTDB/SALDOANTCR/SLDLPANTCR/SLDLPANTDB/MOVLPDEB/MOVLPCRD" .And. nDivide > 0 
							Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide                   
						EndIf										
					Next                    
					(cAliasTMP)->FILIAL	:= cFilAnt 
			
					If cAlias	== "CTU"            
						Do Case
						Case cIdent	== "CTT"
						    If Empty(TRBTMP->DESCCC)
								(cAliasTMP)->DESCCC		:= TRBTMP->DESCCC01
						    EndIf						    
						Case cIdent == "CTD"
							If Empty(TRBTMP->DESCITEM)
								(cAliasTMP)->DESCITEM	:= TRBTMP->DESCIT01							
							EndIf						
						Case cIdent == "CTH"
							If Empty(TRBTMP->DESCCLVL)							
								(cAliasTMP)->DESCCLVL	:= TRBTMP->DESCCV01							
							EndIf						
						EndCase					
					Else
						If lImpConta .or. cAlias == "CT7"
							If Empty(TRBTMP->DESCCTA) .AND. Valtype( TRBTMP->DESCCTA01 ) # "U"
								(cAliasTMP)->DESCCTA	:= TRBTMP->DESCCTA01
							EndIf
						EndIf
			             
						If cAlias == "CT4"            
							If !lImp3Ent 
								If cMoeda <> '01' .And. Empty(TRBTMP->DESCITEM)
									(cAliasTMP)->DESCITEM	:= TRBTMP->DESCIT01
								EndIf    
							EndIf    
								
							If lImp3Ent	//Balancete CC / Conta / Item								             
								If Empty(TRBTMP->DESCCC)
									(cAliasTMP)->DESCCC	:= TRBTMP->DESCCC01
								EndIf        								
								
								If TRBTMP->ALIAS == 'CT4'
									If Empty(TRBTMP->DESCITEM)
										(cAliasTMP)->DESCITEM	:= TRBTMP->DESCIT01																			
								    EndIf
								EndIf
							EndIf
						EndIf
						
						If cAlias == "CTI" .And. lImp4Ent
							If !Empty(CLVL)
								If Empty(TRBTMP->DESCCLVL)							
									(cAliasTMP)->DESCCLVL	:= TRBTMP->DESCCV01							
								EndIf						
							EndiF
							
						    If !Empty(ITEM)
								If Empty(TRBTMP->DESCITEM)
									(cAliasTMP)->DESCITEM	:= TRBTMP->DESCIT01
								EndIf
							Endif
							                           
							If !Empty(CUSTO)
							    If Empty(TRBTMP->DESCCC)
									(cAliasTMP)->DESCCC		:= TRBTMP->DESCCC01													    
							    EndIf						    
							EndIf					
						EndIf
					EndIf
					
							//Se for Relatorio US Gaap
					If lUsGaap
					
						nSlAntGap	:= TRBTMP->(SALDOANTDB - SALDOANTCR)	// Saldo Anterior
						nSlAntGapD	:= TRBTMP->(SALDOANTDB)					// Saldo anterior debito
						nSlAntGapC	:= TRBTMP->(SALDOANTCR)					// Saldo anterior credito	
						nSlAtuGap	:= TRBTMP->((SALDOANTDB+SALDODEB)- (SALDOANTCR+SALDOCRD))	// Saldo Atual           
						nSlAtuGapD	:= TRBTMP->(SALDOANTDB+SALDODEB)					// Saldo Atual debito
						nSlAtuGapC	:= TRBTMP->(SALDOANTCR+SALDOCRD)					// Saldo Atual credito
						
			            nSlDebGap	:= TRBTMP->((SALDOANTDB+SALDODEB) - SALDOANTDB)		// Saldo Debito
			            nSlCrdGap	:= TRBTMP->((SALDOANTCR+SALDOCRD) - SALDOANTCR)		// Saldo Credito
					
						If cConsCrit == "5"	//Se for Criterio do Plano de Contas
							cCritPlCta	:= Ctr045Med(cMoedConv)
						EndIf
			
						If cConsCrit $ "123" .Or. (cConsCrit == "5" .And. cCritPlCta $ "123")
							If cConsCrit == "5"					
								(cAliasTMP)->SALDOANT	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGap)					
								(cAliasTMP)->SALDOANTDB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapD)										
								(cAliasTMP)->SALDOANTCR	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)					
								(cAliasTMP)->SALDOATU	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGap)					
								(cAliasTMP)->SALDOATUDB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGapD)					
								(cAliasTMP)->SALDOATUCR	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)									
								(cAliasTMP)->SALDODEB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlDebGap)									
								(cAliasTMP)->SALDOCRD	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlCrdGap)														
							Else
								(cAliasTMP)->SALDOANT	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGap)					
								(cAliasTMP)->SALDOANTDB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapD)										
								(cAliasTMP)->SALDOANTCR	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)					
								(cAliasTMP)->SALDOATU	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGap)					
								(cAliasTMP)->SALDOATUDB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGapD)					
								(cAliasTMP)->SALDOATUCR	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)									
								(cAliasTMP)->SALDODEB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlDebGap)									
								(cAliasTMP)->SALDOCRD	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlCrdGap)													
							EndIf        
						ElseIf cConsCrit == "4" .Or. (cConsCrit == "5" .And. cCritPlCta == "4")	
							(cAliasTMP)->SALDOANT	:= nSlAntGap/nTaxaConv
							(cAliasTMP)->SALDOANTDB	:= nSlAntGapD/nTaxaConv 
							(cAliasTMP)->SALDOANTCR	:= nSlAntGapC/nTaxaConv 
							(cAliasTMP)->SALDOATU	:= nSlAtuGap/nTaxaConv 
							(cAliasTMP)->SALDOATUDB	:= nSlAtuGapD/nTaxaConv 
							(cAliasTMP)->SALDOATUCR	:= nSlAtuGapC/nTaxaConv  
							(cAliasTMP)->SALDODEB	:= nSlDebGap/nTaxaConv
							(cAliasTMP)->SALDOCRD	:= nSlCrdGap/nTaxaConv			
						EndIf			
					EndIf		        		
				
					If Empty( dDtCorte )
						If nCampoLP > 0 
							(cAliasTMP)->SALDOANTDB	:= SALDOANTDB - SLDLPANTDB
							(cAliasTMP)->SALDOANTCR	:= SALDOANTCR - SLDLPANTCR
							(cAliasTMP)->SALDODEB	:= SALDODEB - MOVLPDEB
							(cAliasTMP)->SALDOCRD	:= SALDOCRD - MOVLPCRD
						EndIf					
				 		
				 		(cAliasTMP)->SALDOANT	:= SALDOANTCR - SALDOANTDB
						(cAliasTMP)->SALDOATUDB	:= SALDOANTDB + SALDODEB
						(cAliasTMP)->SALDOATUCR	:= SALDOANTCR + SALDOCRD 				 	
						(cAliasTMP)->SALDOATU	:= SALDOATUCR - SALDOATUDB			
						(cAliasTMP)->MOVIMENTO	:= SALDOCRD   - SALDODEB			
					Else 
						nSaldoCrt := 0

						If lImpAntLP .And. nCampoLP > 0  
							IF Type( "(cAliasTMP)->SLLPATCTDB" ) # "U" .AND.Type( "(cAliasTMP)->SLLPATCTCR" ) # "U" 
								nSaldoCrt := ((cAliasTMP)->SLLPATCTDB - (cAliasTMP)->SLLPATCTCR)
							Endif

							(cAliasTMP)->SALDOANTDB	:= (SALDOANTDB - SLDLPANTDB ) + iif( nSaldoCrt > 0 , Abs( nSaldoCrt ) , 0 ) 
							(cAliasTMP)->SALDOANTCR	:= (SALDOANTCR - SLDLPANTCR ) + iif( nSaldoCrt < 0 , Abs( nSaldoCrt ) , 0 ) 
							(cAliasTMP)->SALDODEB	:= SALDODEB - MOVLPDEB
							(cAliasTMP)->SALDOCRD	:= SALDOCRD - MOVLPCRD
						Else
							IF Type( "(cAliasTMP)->SLDANTCTDB" ) # "U" .AND.Type( "(cAliasTMP)->SLDANTCTCR" ) # "U" 
								nSaldoCrt := ((cAliasTMP)->SLDANTCTDB - (cAliasTMP)->SLDANTCTCR)
							Endif

							(cAliasTMP)->SALDOANTDB	:= SALDOANTDB + iif( nSaldoCrt > 0 , Abs( nSaldoCrt ) , 0 ) 
							(cAliasTMP)->SALDOANTCR	:= SALDOANTCR + iif( nSaldoCrt < 0 , Abs( nSaldoCrt ) , 0 ) 
						EndIf					
				 		
				 		(cAliasTMP)->SALDOANT	:= SALDOANTCR - SALDOANTDB
						(cAliasTMP)->SALDOATUDB	:= SALDOANTDB + SALDODEB
						(cAliasTMP)->SALDOATUCR	:= SALDOANTCR + SALDOCRD 				 	
						(cAliasTMP)->SALDOATU	:= SALDOATUCR - SALDOATUDB			
						(cAliasTMP)->MOVIMENTO	:= SALDOCRD   - SALDODEB			    
					
					Endif
					
					
				    //Se imprime saldo anterior do periodo anterior zerado, verificar o saldo atual da data de zeramento.                
					If ( lImpConta .Or. cAlias == "CT7") .And. lRecDesp0 .And. Subs(TRBTMP->CONTA,1,1) $ cRecDesp		
					
						If cAlias == "CT7"
							aSldRecDes	:= SaldoCT7Fil(TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.,nil,aSelFil)		
						ElseIf cAlias == "CT3" .And. cHeader == "CTT"
							aSldRecDes	:= SaldoCT3Fil(TRBTMP->CONTA,TRBTMP->CUSTO,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.,Nil,aSelFil)									
						ElseIf cAlias == "CT4" .And. cHeader == "CTD"
							cCusIni		:= ""
							cCusFim		:= Repl("Z",aTamCC[1])
							aSldRecDes	:= SaldTotCT4(TRBTMP->ITEM,TRBTMP->ITEM,cCusIni,cCusFim,TRBTMP->CONTA,TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,aSelFil)																								
						Elseif cAlias == "CTI" .And. cHeader == "CTH"
							cCusIni		:= ""
							cCusFim		:= Repl("Z",aTamCC[1])
							
							cItIni  	:= ""
							cItFim   	:= Repl("z",aTamItem[1])
					
							aSldRecDes := SaldTotCTI(TRBTMP->CLVL,TRBTMP->CLVL,cItIni,cItFim,cCusIni,cCusFim,;
							TRBTMP->CONTA,TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,aSelFil)
						EndIf                        

						If nDivide > 1
							For nCont := 1 To Len(aSldRecDes)
								aSldRecDes[nCont] := Round(NoRound((aSldRecDes[nCont]/nDivide),3),2)
							Next nCont		
						EndIf								

						nSldRDAtuD	:=	aSldRecDes[4] 
						nSldRDAtuC	:=	aSldRecDes[5]
						nSldAtuRD	:= nSldRDAtuC - nSldRDAtuD			
                                                
						(cAliasTMP)->SALDOANT		-= nSldAtuRD
						(cAliasTMP)->SALDOANTDB	-= nSldRDAtuD
						(cAliasTMP)->SALDOANTCR	-= nSldRDAtuC 	
						(cAliasTMP)->SALDOATU		-= nSldAtuRD
						(cAliasTMP)->SALDOATUDB	-= nSldRDAtuD
						(cAliasTMP)->SALDOATUCR	-= nSldRdAtuC			
					EndIf                        

					IF (cAliasTMP)->( FieldPos( "NATCTA" ) ) > 0
						(cAliasTMP)->NATCTA := NATCTA   // Faz retorno do campo CT1_NATCTA
					Endif

					(cAliasTMP)->(MsUnlock())
				EndIf					
				TRBTMP->(dbSkip())     
				If ValType(oMeter) == "O"					
					nMeter++
			    	oMeter:Set(nMeter)				
			  	EndIf
			Enddo

			dbSelectArea("TRBTMP")
			dbCloseArea()					/// FECHA O TRBTMP (RETORNADO DA QUERY)
			lTemQry := .T.
		Endif
	EndIf
#ENDIF


dbSelectArea(cAliasTMP)
dbSetOrder(1)

If cAlias $ 'CT3/CT4/CTI' //Se imprime CONTA+ ENTIDADE
	If !Empty(aSetOfBook[5])
		If !lImpConta	//Se for balancete de 1 entidade filtrada por conta
			If cAlias == "CT3"
				cIdent	:= "CTT"
			ElseIf cAlias == "CT4"
				cIdent	:= "CTD"			
			ElseIf cAlias == "CTI"
				cIdent 	:= "CTH"
			EndIf
			// Monta Arquivo Lendo Plano Gerencial                                   
			// Neste caso a filtragem de entidades contabeis é desprezada!
			CtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,"CTU",;
						cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren,lImpSint,lRecDesp0,cRecDesp,dDtZeraRD,,cSaldos,lPlGerSint,lConsSaldo,,lUsaNmVis,@cNomeVis)
			dbSetOrder(2)
		Else	
			If lImpEntGer	//Se for balancete de Entidade (C.Custo/Item/Cl.Vlr por Entid. Gerencial)
			 	CtPlEntGer(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,cHeader,;
						lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,cContaIni,cContaFim,;         
						cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,lImpSint,;
						lRecDesp0,cRecDesp,dDtZeraRD,nDivide,lFiltraCC,lFiltraIt,lFiltraCV, cSaldos )
			Else		
				MsgAlert(cMensagem)	
				Return
			EndIf
		EndIf
	Else
		If cHeader == "CT1"	//Se for Balancete Conta/Entidade
			#IFNDEF TOP	//Se for top connect, atualiza sinteticas
				// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
				CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
							cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,lNImpMov)	                       
			#ELSE
				If TcSrvType() == "AS/400"                     					
					// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
					CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
							cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,lNImpMov)	                       
				
				EndIf
			#ENDIF
			//Atualizacao de sinteticas para codebase e topconnect			
			If lImpSint	//Se atualiza sinteticas
		 		CtCtEntSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda)							
		    EndIf			
		Else
			If !lImp3Ent	.And. !lImp4Ent //Se não for Balancete CC / Conta / Item
				If lImpConta
					#IFNDEF TOP			    
						// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE				
						CtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)     
					#ELSE														
						If TcSrvType() == "AS/400"
							CtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)     					
						EndIf
					#ENDIF					
					
					If lImpSint	//Se atualiza sinteticas
						If cAlias == 'CT3' .And. FunName() == 'CTBR180'
					 		CtEntCtSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,,cEntidIni,cEntidFim)
					 	Else	
					 		CtEntCtSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda)
					 	EndIf	
				 	EndIf
					
				Else
					#IFNDEF TOP				
						CtbSo1Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
								cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cEntidIni,;
								cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
								cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
								lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
								nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
								lRecDesp0,cRecDesp,dDtZeraRD)          							     										
					#ELSE
						If TcSrvType() == "AS/400"                     														
							CtbSo1Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cEntidIni,;
									cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)          							     																
						EndIf					
					#ENDIF		 
					
					If lImpSint                                               
						If cAlias == "CT3"
							cIdent := "CTT"
						ElseIf cAlias == "CT4"
							cIdent := "CTD"						
						ElseIf cAlias == "CTI"
							cIdent := "CTH"						
						EndIf					
						CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)				
					EndIf						
							
				EndIf
			Else	//Se for Balancete CC / Conta / Item				
				If lImp3Ent
					#IFNDEF TOP
						CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
									cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
									lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado)				
					#ELSE
						If TcSrvType() == "AS/400"                     									
							CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
										cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
										cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
										lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
										nDivide,lVlrZerado)
					    EndIf
					#ENDIF
					If lImpSint
				 		Ctb3CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)							
				    Endif			
				 ElseIf cAlias == "CTI" .And. lImp4Ent .And. cHeader == "CTT"
					#IFNDEF TOP
						CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
									cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
									lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado)				
					#ELSE
						If TcSrvType() == "AS/400" .or. lImpAntLP
							CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
										cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
										cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
										lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
										nDivide,lVlrZerado)
					    EndIf
					#ENDIF	
					If lImpSint
				 		Ctb4CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)							
				    Endif						
				 EndIf				 
			EndIf
		EndIf
	EndIf
Else	
	If cAlias $ 'CTU/CT7' .Or. (!Empty(aSetOfBook[5]) .And. Empty(cAlias))		//So Imprime Entidade ou demonstrativos
		If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
			// Monta Arquivo Lendo Plano Gerencial                                   
			// Neste caso a filtragem de entidades contabeis é desprezada!
			CtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,;
						cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren,lImpSint,lRecDesp0,cRecDesp,dDtZeraRD,;
						lMovPeriodo,cSaldos,lPlGerSint,lConsSaldo, cAliasTMP, lUsaNmVis,@cNomeVis )
			dbSetOrder(2)
		Else
			//Se nao for for Top Connect
			#IFNDEF TOP 			
				CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
					cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
					lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
					dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
					cRecDesp,dDtZeraRD,cMoedaDsc)					
			#ELSE
				If TcSrvType() == "AS/400"                     								
					CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
						cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
						lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
						dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
						cRecDesp,dDtZeraRD,cMoedaDsc)
				EndIf				
			#ENDIF			  
			     
			If lImpSint	//Se atualiza sinteticas			
				Do Case
				Case cAlias =="CT7"
					//Atualizacao de sinteticas para codebase e topconnect			        	
			 		U_CtContaSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cMoedaDsc)									 									
				Case cAlias == "CTU"			    		
					U_CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)
				EndCase
			EndIf

			dbSelectArea(cAliasTMP)
			
			If FieldPos("ORDEMPRN") > 0
				If lCriaInd
				dbSelectArea(cAliasTMP)
				IndRegua(cAliasTMP,Left(cArqInd, 7) + "A","ORDEMPRN",,,OemToAnsi("A"))  //"Selecionando Registros..."
				If cAlias == "CT7"
					IndRegua(cAliasTMP,Left(cArqInd, 7) + "B","SUPERIOR+CONTA",,,OemToAnsi("A"))  //"Selecionando Registros..."
				ElseIf cAlias == "CTU"
					If cIdent == "CTT"
						IndRegua(cAliasTMP,Left(cArqInd, 7) + "B","CCSUP+CUSTO",,,OemToAnsi("A"))  //"Selecionando Registros..."					
					ElseIf cIdent == "CTD"
						IndRegua(cAliasTMP,Left(cArqInd, 7) + "B","ITSUP+ITEM",,,OemToAnsi("A"))  //"Selecionando Registros..."					
					ElseIf cIdent == "CTH"
						IndRegua(cAliasTMP,Left(cArqInd, 7) + "B","CLSUP+CLVL",,,OemToAnsi("A"))  //"Selecionando Registros..."					
					EndIf				
				EndIf
				DbClearIndex()
				dbSetIndex(cArqInd+OrdBagExt())
				dbSetIndex(Left(cArqInd,7)+"A"+OrdBagExt())
				dbSetIndex(Left(cArqInd,7)+"B"+OrdBagExt())
				Endif	
				
				DbSetOrder(1)
				DbGoTop()
				While ! Eof()
					If cAlias == "CT7"
						If Empty(SUPERIOR)					
							CtGerSup(CONTA, @nOrdem, cAlias)
						EndIf
					ElseIf cAlias == "CTU"						
						If cIdent == "CTT"
							If Empty(CCSUP)								
								CtGerSup(CUSTO, @nOrdem,"CTU","CTT")						
							EndIf
						ElseIf cIdent == "CTD"
							If Empty(ITSUP)
								CtGerSup(ITEM, @nOrdem,"CTU","CTD")						
							EndIf
						ElseIf cIdent == "CTH"
							If Empty(CLSUP)
								CtGerSup(CLVL, @nOrdem,"CTU","CTH")						
							Endif
						EndIf						
					EndIf
					DbSkip()
				Enddo
				DbSetOrder(2)
			Endif
		EndIf
	Else    	//Imprime Relatorios com 2 Entidades 
		If !Empty(aSetOfBook[5])
			MsgAlert(cMensagem)			
			Return
		Else
			If cAlias == 'CTY'		//Se for Relatorio de 2 Entidades filtrado pela 3a Entidade
				Ct2EntFil(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt)			
        	ElseIf  cAlias <> 'CVY'
				CtEntComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,cFilUsu)
			EndIf
		EndIf
	Endif
EndIf

#IFDEF TOP                           
  	CTDelTmpFil()
#ENDIF

RestArea(aSaveArea)

Return cArqTmp



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtContaSup ³Autor  ³ Simone Mie Sato       ³ Data ³ 22.08.03 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizacao de sinteticas de conta =>relatorios             			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtContaSup()															 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lNImpMov = Se imprime entidades sem movimento		               	 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtContaSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cMoedaDsc)							
		
Local aSaveArea	:= GetArea()				
Local cContaSup	:= ""
Local cDesc		:= ""
Local nSaldoAnt	:= 0
Local nSaldoAtu	:= 0
Local nSaldoDeb	:= 0
Local nSaldoCrd	:= 0
Local nMovimento:= 0
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nsaldoAtuC:= 0
Local nReg   	:= 0
Local nRegTmp	:= 0
Local nMeter	:= 0
Local lSemestre 	:= FieldPos("SALDOSEM") > 0		// Saldo por semestre
Local lPeriodo0		:= FieldPos("SALDOPER") > 0		// Saldo dois periodos anteriores
Local cNatCta	:= "" 

DEFAULT cMoedaDsc	:= '01'

nSaldoAnt	:= SALDOANT
nSaldoAtu	:= SALDOATU
nSaldoDeb	:= SALDODEB
nSaldoCrd	:= SALDOCRD
nMovimento	:= MOVIMENTO			
		
nSaldoAtuD	:= SALDOATUDB
nSaldoAtuC	:= SALDOATUCR


// Grava sinteticas
dbSelectArea(cAliasTMP)	
dbGoTop()  
If ValType(oMeter) == "O"
	oMeter:SetTotal((cAliasTMP)->(RecCount()))
	oMeter:Set(0)
EndIf

While !Eof()

	If (cAliasTMP)->TIPOCONTA == "1"
		dbSkip()
		Loop
	EndIf
	
	nRegTmp	:= Recno()
	nSaldoAnt	:= SALDOANT
	nSaldoAtu	:= SALDOATU
	nSaldoDeb	:= SALDODEB
	nSaldoCrd	:= SALDOCRD
	nMovimento	:= MOVIMENTO					
	nSaldoAtuD	:= SALDOATUDB
	nSaldoAtuC	:= SALDOATUCR

	dbSelectArea("CT1")
	dbSetOrder(1)
		
	cContaSup := (cAliasTMP)->SUPERIOR  

	If Empty(cContaSup)
		dbSelectArea(cAliasTMP)
		Replace NIVEL1 With .T.
		dbSelectArea("CT1")
	EndIf		
	MsSeek(xFilial()+cContaSup)
		
	While !Eof() .And. CT1->CT1_FILIAL == xFilial()

		If Empty(cMoedaDsc)
			cDesc := &("CT1->CT1_DESC"+cMoeda)
		Else
			cDesc := &("CT1->CT1_DESC"+cMoedaDsc)
		EndIf
		
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc := CT1->CT1_DESC01
		Endif

   		dbSelectArea(cAliasTMP)
		dbSetOrder(1) 

		IF (cAliasTMP)->( FieldPos( "NATCTA" ) ) > 0
			cNatCta := (cAliasTMP)->NATCTA
		Endif

		If !MsSeek(cContaSup)
			dbAppend()
			Replace CONTA		With cContaSup
			Replace SUPERIOR	With CT1->CT1_CTASUP
			Replace DESCCTA		With cDesc
			Replace TIPOCONTA	With CT1->CT1_CLASSE
			Replace CTARES    	With CT1->CT1_RES
			Replace NORMAL   	With CT1->CT1_NORMAL
			Replace GRUPO		With CT1->CT1_GRUPO 

			IF (cAliasTMP)->( FieldPos( "NATCTA" ) ) > 0
				Replace NATCTA		With cNatCta
			Endif
		EndIf    

		Replace	SALDOANT 	With SALDOANT 	+ nSaldoAnt
		Replace SALDOANTDB  With SALDOANTDB + nSaldoAntD
		Replace SALDOANTCR	With SALDOANTCR + nSaldoAntC
		Replace SALDOATU 	With SALDOATU 	+ nSaldoAtu
		Replace SALDOATUDB	With SALDOATUDB	+ nSaldoAtuD
		Replace SALDOATUCR	With SALDOATUCR + nsaldoAtuC
		Replace SALDODEB 	With SALDODEB 	+ nSaldoDeb
		Replace SALDOCRD 	With SALDOCRD 	+ nSaldoCrd

		If !lNImpMov
			Replace MOVIMENTO With MOVIMENTO + nMovimento
		Endif

		If lSemestre		// Saldo por semestre
			Replace SALDOSEM With SALDOSEM 	+ nSaldoSEM
		Endif

   		If lPeriodo0		// Saldo dois periodos anteriores
			Replace SALDOPER With SALDOPER 	+ nSaldoSEM
		Endif
		
		dbSelectArea("CT1")
		cContaSup := CT1->CT1_CTASUP
		If Empty(CT1->CT1_CTASUP)
			dbSelectArea(cAliasTMP)
			Replace NIVEL1 With .T.
			dbSelectArea("CT1")
			Exit
		EndIf		
		MsSeek(xFilial()+cContaSup)
	EndDo
	dbSelectArea(cAliasTMP)
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"	
		nMeter++
   		oMeter:Set(nMeter)						
  	EndIF
EndDo
	
    	
RestArea(aSaveArea)

Return
