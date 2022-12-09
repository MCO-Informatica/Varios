#Define STR0001  "Relacao de Recebiveis por Obra"
#Define STR0004  " Por Obra           "
#Define STR0007  "Relacao de Recebiveis"
#Define STR0029  "CANCELADO PELO OPERADOR"
#Define STR0033  "Total Geral "
#Define STR0062  "Relatorio de Recebiveis"
#Define STR0063  "Obra"
#Define STR0065  "Obra"

#INCLUDE "rwmake.ch"           
#Include "FIVEWIN.Ch"
#include 'TopConn.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN022   º Autor ³Mauro Nagata        º Data ³  13/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio de Recebiveis                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFIN022()
Private oReport
Private oSection1
Private oCell

//If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
//Else
//	MATR220R3()
//EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Mauro Nagata           ³ Data ³13/08/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(nReg)

//Local oReport 
//Local oSection1
//Local oCell         
Local cAliasCTT := GetNextAlias()
aOrdem	:= {}


PRIVATE cPerg := "RFIN022"
//AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("RFIN022",STR0007,"RFIN022", {|oReport| ReportPrint(oReport,cAliasCTT)},STR0001)  //relacao de recebiveis por obra
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)
Pergunte("RFIN022",.F.)
Aadd( aOrdem, STR0004 ) // "Por Obra"

oSection1 := TRSection():New(oReport,STR0062,{"CTT","SE1","SE2","SE5","SED" },aOrdem) //"Relacao de Recebiveis"
oSection1 :SetTotalInLine(.F.)

TRCell():New(oSection1,"CTT_CUSTO"  ,"CTT",STR0065/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Obra"
TRCell():New(oSection1,"CTT_DESC01" ,"CTT","Nome Obra" /*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  //descricao da obra                        
TRCell():New(oSection1,"CTT_XMUN"   ,"CTT","Municipio" /*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   //municipio
TRCell():New(oSection1,"cStObra"    ,"   ","Status da Obra" /*Titulo*/,"@S12!"/*Picture*/,/*Tamanho*/,/*lPixel*/, {|| DescrStObra(CTT->CTT_STOBRA)} /*{|| code-block de impressao }*/)   //status da obra
TRCell():New(oSection1,"CTT_XVLR"   ,"CTT","Valor Contrato" /*Titulo*/,"@RE 999,999,999" /*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  //valor do contrato
TRCell():New(oSection1,"nVlrRec"    ,"   ","Recebido" /*Titulo*/,"@RE 999,999,999"/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)    //recebido
TRCell():New(oSection1,"nVlrPag"    ,"   ","Gasto/Pago" /*Titulo*/,"@RE 999,999,999"/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)    //gasto/pago
TRCell():New(oSection1,"nVlrARec","   ","A Receber Liq" /*Titulo*/,"@RE 999,999,999"/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)    //a receber   
TRCell():New(oSection1,"nVlrAPag"  ,"   ","Gastar/Pagar" /*Titulo*/,"@RE 999,999,999"/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)    //gastar/pagar
TRCell():New(oSection1,"nVlrRes"    ,"   ","Resultado" /*Titulo*/,"@RE 999,999,999"/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)    //resultado
                                                 
oSection1:Cell("CTT_XVLR"):SetHeaderAlign("RIGHT")            
oSection1:Cell("cStObra"):SetHeaderAlign("CENTER")
oSection1:Cell("nVlrRec"):SetHeaderAlign("RIGHT") 
oSection1:Cell("nVlrARec"):SetHeaderAlign("RIGHT") 
oSection1:Cell("nVlrPag"):SetHeaderAlign("RIGHT") 
oSection1:Cell("nVlrAPag"):SetHeaderAlign("RIGHT") 
oSection1:Cell("nVlrRes"):SetHeaderAlign("RIGHT")
oSection1 :SetTotalText(STR0033) //"Total Geral "
                                                                                                                 
TRFunction():New(oSection1:Cell("CTT_CUSTO"),NIL,"COUNT",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.) 
//TRFunction():New(oSection1:Cell("CTT_XVLR"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.) 
TRFunction():New(oSection1:Cell("nVlrRes"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.) 

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Mauro Nagata          ³ Data ³ 13/08/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local nTamRef  	 := Val(Substr(GetMv("MV_MASCGRD"),1,2))
Local lRet       := .F.
Local cProdRef	 := ""
Local lSkip		 := .F.    
Local cSerie	 := ""

#IFNDEF TOP
	Local cCondicao := ""
	Local cKey 		:= ""
	Local cIndexSD2 := ""
#ELSE	
	Local cWhere := ""
#ENDIF      
Local nVlrCusto 
Private nTotPrvDep := 0        

oReport:Section(1):Cell("CTT_CUSTO" 	):SetBlock({|| CTT->CTT_CUSTO			})
oReport:Section(1):Cell("CTT_DESC01"	):SetBlock({|| CTT->CTT_DESC01			})
oReport:Section(1):Cell("CTT_XMUN"  	):SetBlock({|| CTT->CTT_XMUN			})
//oReport:Section(1):Cell("cStObra"   	):SetBlock({|| cStObra		    		})
oReport:Section(1):Cell("cStObra"   	):SetBlock({|| cDescStOb	    		})
oReport:Section(1):Cell("CTT_XVLR"		):SetBlock({|| Round(CTT->CTT_XVLR,0) 	})
oReport:Section(1):Cell("nVlrRec"   	):SetBlock({|| Round(nVlrRec,0)	   	})
oReport:Section(1):Cell("nVlrPag"   	):SetBlock({|| Round(nVlrPag,0)	 	})
oReport:Section(1):Cell("nVlrAPag"   	):SetBlock({|| Round(nVlrAPag,0)   	}) 
oReport:Section(1):Cell("nVlrARec"  	):SetBlock({|| Round(nVlrARec,0) 	})
oReport:Section(1):Cell("nVlrRes"   	):SetBlock({|| Round(nVlrRes,0)	 	})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//TRPosition():New(ExpO1,/*ExpC2*/,/*ExpX3*/,{|| /*ExpX4*/})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AMESES := {}
a_pdados := {}
a_rdados := {}

AMESES := ARRAY(12)
AMESES := {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
If Day(dDataBase + 1) == 1
	if MONTH(dDataBase) == 12
		Mes1 := 1
	else
		Mes1:= MONTH(dDataBase) + 1
	Endif
else
	Mes1:= MONTH(dDataBase)
Endif
if Mes1 == 12
	Mes2 := 1
else
	Mes2:= Mes1 + 1
endif

if Mes2 == 12
	Mes3 := 1
else
	Mes3:= Mes2 + 1
endif

Private cString := "CTT"
dbSelectArea("CTT")
dbSetOrder(1)

a_saldo := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}


dbSelectArea("CTT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SetMeter(RecCount())
oReport:Section(1):Init()

nTotObra  := CTT->(RecCount())
nContObra := 0

dbSetOrder(1) //CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_
DbSeek(xFilial('CTT')+MV_PAR01,.T.)

Do While !oReport:Cancel() .And. CTT->CTT_CUSTO <= MV_PAR02 .And. !Eof()
    oReport:IncMeter()                   
    nContObra++
	If MV_PAR05 = 2
		If CTT->CTT_MSBLQL != '2'
			CTT->(DbSkip())
			Loop
		EndIf
	EndIf 
	                                    
	cStObra   := CTT->CTT_STOBRA   
	cDescStOb := If(cStObra="A","Andamento",If(cStObra="P","Paralisada",If(cStObra="N","Nao Liberada",If(cStObra="L","Liberada","Concluida"))))
	nVlrCtr   := CTT->CTT_XVLR       
	nFatDir   := CTT->CTT_XFATD
    If (MV_PAR04 = 1.And.cStObra != "A").Or.(MV_PAR04 = 2.And.cStObra != "P").Or.(MV_PAR04 = 3.And.!(cStObra $ "A.P"))
	   CTT->(DbSkip())
	   Loop	
	EndIf
	                         
	DbSelectArea('AF8')
	DbSetOrder(8) //AF8_FILIAL, AF8_CODOBR, R_E_C_N_O_, D_E_L_E_T_
	nVlrCusto := 0
	
	If DbSeek(xFilial('AF8')+CTT->CTT_CUSTO)		
		lIpAF8 := .T.                             
		cDtPrj := Ctod("")
		While AF8->AF8_CODOBR = CTT->CTT_CUSTO
			nVlrCusto += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
			If lIpAF8 
			   lIpAF8 := .F.
			   cDtPrj := Dtoc(AF8->AF8_DATA)         
			EndIf
			AF8->(DbSkip())
		EndDo
	EndIf                    
	                               
//	nRecCTT := CTT->(Recno())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Acumulado no periodo                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess := MsNewProcess():New({|lEnd| U_RFIN022a(oProcess,CTT->CTT_CUSTO, MV_PAR03,,"A")},"Processando informações da Obra "+Str((nContObra/nTotObra)*100,3)+"%","Preparando . . .",.F.)  
	oProcess:Activate()
	              
	nVlrRec := 0  //valor recebido
	DbSelectArea('TRAB')
	DbSeek("010")
	Do While !Eof() .And. TRAB->TRB_GRPO = "010"
	   nVlrRec += TRAB->TRB_TOT - TRAB->TRB_ABER - TRAB->TRB_VENC
	   DbSkip()
	EndDo         
	  
	nVlrPag := 0  //valor gasto/pago
	DbSelectArea('TRAB')
	DbSeek("028")
//	Do While !Eof() .And. TRAB->TRB_GRPO = "028"
	   //nVlrPag += TRAB->TRB_TOT + TRAB->TRB_REAL
	   nVlrPag += TRAB->TRB_TOT 
//	   DbSkip()
//	EndDo         
	
	//nVlrAPag   := nVlrCusto - nVlrPag                    
	nVlrAPag   := nVlrCusto - nTotPrvDep
	
	nVlrARec := Round( (nVlrCtr - nVlrRec - nFatDir)*.86,2)
	nVlrRes     := nVlrARec - (nVlrAPag*If(nVlrAPag < 0,-1,1))
	
	oReport:Section(1):PrintLine()
	                          
//	CTT->(DbGoTo(nRecCTT))                                                              
    DbSelectArea("CTT")
	DbSkip() // Avanca o ponteiro do registro no arquivo
	
EndDo
oReport:Section(1):Finish()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN022a  ºAutor  ³Alexandre Sousa     º Data ³  10/18/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o arquivo temporario para impressao do relatorio.      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFIN022a(oObj, c_Obra, c_anoref, l_competencia,c_periodo)

Local c_query   := ''
Local c_EOL		:= chr(13)+chr(10)
Local a_separar := {}
Local n_totCRA  := 0
Local n_totDA	:= 0
Local a_fatdir	:= {}     
Local nTotPrvRec := 0
//Local nTotPrvDep := 0

Private cNomeArq

oObj:SetRegua1(9)
oObj:IncRegua1("Criando arquivo de trabalho (1)")
                             
dPerIni := Ctod("01/01/"+c_anoref)
dPerFin := Ctod("31/12/"+c_anoref)
cMesIni := "01" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o arquivo de trabalho temporario                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oObj:SetRegua2(16)                                       
oObj:IncRegua2("Criando Matriz de trabalho . . .")
aStruct := {}
AAdd( aStruct, { "TRB_GRPO", "C", 03, 0 } )
AAdd( aStruct, { "TRB_NAT" , "C", 10, 0 } )
AAdd( aStruct, { "TRB_DESC", "C", 40, 0 } )
AAdd( aStruct, { "TRB_ANT" , "N", 14, 2 } )
oObj:SetRegua2(12)
For n_x := 1 to 12
	AAdd( aStruct, { "TRB_M"+strzero(n_x,2), "N", 14, 2 } )
	oObj:IncRegua2("Criando variaveis de trabalho . . .")
Next
AAdd( aStruct, { "TRB_VENC", "N", 14, 2 } )
AAdd( aStruct, { "TRB_TOT" , "N", 14, 2 } )
AAdd( aStruct, { "TRB_REAL", "N", 14, 2 } )
AAdd( aStruct, { "TRB_ABER", "N", 14, 2 } )

If Select("TRAB") > 0
	DbSelectArea("TRAB")
	DbCloseArea()
EndIf                                                    
oObj:IncRegua2("Criando Tabela de trabalho . . .")
cArqTrab := CriaTrab( aStruct, .T. )
dbUseArea(.T.,,cArqTrab,"TRAB",.F.,.F.)         
oObj:IncRegua2("Criando Indice de trabalho . . .")
Index On TRB_GRPO+TRB_NAT to (cArqTrab)           
oObj:IncRegua2("Finalizando Criacao da Tabela de trabalho . . .")

TRAB->(DbSetOrder(1))
dbSelectArea("TRAB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query para buscar informaceos do contas a pagar                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oObj:IncRegua1("Selecionando Registros CP (2)")
oObj:SetRegua2(3)

c_query := "select E2_XCC, E2_NATUREZ, E2_VALOR, E2_VENCREA, E2_SALDO, "
c_query += "E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_DECRESC, E2_EMISSAO, IsNull(EZ_PERC,1) AS EZ_PERC, IsNull(EV_PERC,1) AS EV_PERC "
c_query += "from (" + c_EOL
c_query += "select E2_BAIXA, E2_VALOR as VALORI, E2_SALDO, E2_VENCREA, isnull(EV_NATUREZ, E2_NATUREZ) as E2_NATUREZ, isnull(EZ_CCUSTO, E2_XCC) as E2_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E2_VALOR)) as E2_VALOR, " + c_EOL
c_query += "E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_DECRESC, E2_EMISSAO, IsNull(EZ_PERC,1) AS EZ_PERC, IsNull(EV_PERC,1) AS EV_PERC  "
c_query += "from SE2010 " + c_EOL
c_query += "left join SEV010" + c_EOL
c_query += "     on EV_FILIAL   = E2_FILIAL" + c_EOL
c_query += "        and       EV_PREFIXO  = E2_PREFIXO" + c_EOL
c_query += "        and       EV_NUM      = E2_NUM" + c_EOL
c_query += "        and       EV_PARCELA  = E2_PARCELA" + c_EOL
c_query += "        and       EV_TIPO     = E2_TIPO" + c_EOL
c_query += "        and       EV_CLIFOR   = E2_FORNECE" + c_EOL
c_query += "        and       EV_LOJA     = E2_LOJA" + c_EOL
c_query += "        and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "left join SEZ010" + c_EOL
c_query += "     on EZ_FILIAL   = EV_FILIAL" + c_EOL
c_query += "        and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
c_query += "        and       EZ_NUM      = EV_NUM" + c_EOL
c_query += "        and       EZ_PARCELA  = EV_PARCELA" + c_EOL
c_query += "        and       EZ_TIPO     = EV_TIPO" + c_EOL
c_query += "        and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
c_query += "        and       EZ_LOJA     = EV_LOJA" + c_EOL
c_query += "        and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
c_query += "        and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "where     SE2010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "and       E2_SALDO  = 0	" + c_EOL
c_query += "and       E2_DTFATUR = '' " + c_EOL        //somente titulos nao faturados [Mauro Nagata, Actual Trend, 10/01/2011]
c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
c_query += ") A       where E2_XCC = '"+c_Obra+"'" + c_EOL

c_query += "union all " + c_EOL

c_query += "SELECT E2_XCC, E2_NATUREZ, E2_VALOR, E2_VENCREA, E2_SALDO, "
c_query += "E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_DECRESC, E2_EMISSAO, IsNull(EZ_PERC,1) AS EZ_PERC, IsNull(EV_PERC,1) AS EV_PERC  "
c_query += "FROM ( " + c_EOL
c_query += "       SELECT E2_BAIXA, E2_VALOR as VALORI, isnull(EZ_VALOR,isnull(EV_VALOR, E2_SALDO)) as E2_SALDO, E2_VENCREA, isnull(EV_NATUREZ, E2_NATUREZ) as E2_NATUREZ, isnull(EZ_CCUSTO, E2_XCC) as E2_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E2_VALOR)) as E2_VALOR, " + c_EOL
c_query += "              E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_DECRESC, E2_EMISSAO, IsNull(EZ_PERC,1) AS EZ_PERC, IsNull(EV_PERC,1) AS EV_PERC  "
c_query += "       FROM SE2010 " + c_EOL
c_query += "       LEFT JOIN SEV010" + c_EOL
c_query += "            ON EV_FILIAL   = E2_FILIAL" + c_EOL
c_query += "               AND EV_PREFIXO  = E2_PREFIXO" + c_EOL
c_query += "               AND EV_NUM      = E2_NUM" + c_EOL
c_query += "               AND EV_PARCELA  = E2_PARCELA" + c_EOL
c_query += "               AND EV_TIPO     = E2_TIPO" + c_EOL
c_query += "               AND EV_CLIFOR   = E2_FORNECE" + c_EOL
c_query += "               AND EV_LOJA     = E2_LOJA" + c_EOL
c_query += "               AND SEV010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "       LEFT JOIN SEZ010" + c_EOL
c_query += "            ON EZ_FILIAL   = EV_FILIAL" + c_EOL
c_query += "               AND EZ_PREFIXO  = EV_PREFIXO" + c_EOL
c_query += "               AND EZ_NUM      = EV_NUM" + c_EOL
c_query += "               AND EZ_PARCELA  = EV_PARCELA" + c_EOL
c_query += "               AND EZ_TIPO     = EV_TIPO" + c_EOL
c_query += "               AND EZ_CLIFOR   = EV_CLIFOR" + c_EOL
c_query += "               AND EZ_LOJA     = EV_LOJA" + c_EOL
c_query += "               AND EZ_NATUREZ  = EV_NATUREZ" + c_EOL
c_query += "               AND SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "       WHERE SE2010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "             AND E2_SALDO  <> 0	" + c_EOL
c_query += "             AND E2_DTFATUR = '' " + c_EOL       
c_query += "         AND SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
c_query += ") A       WHERE E2_XCC = '"+c_Obra+"'" + c_EOL
c_query += "ORDER BY E2_NATUREZ, E2_VENCREA " + c_EOL
                                           
oObj:IncRegua2("Gerando Tabela Contas a Pagar . . .")
memoWrite('RFIN022a.sql', c_query)

If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
EndIf                                           
oObj:IncRegua2("Processando Registros CP . . .")
TcQuery c_Query New Alias "QRY"                 
oObj:IncRegua2("Finalizando Registros CP . . .")
                       

n_tregcp := 0
DbEVal({|| n_tregcp++})
                   
/*
n_tregcp := 0
QRY->(DbGotop())
While QRY->(!EOF())
	n_tregcp++
	QRY->(DbSkip())
EndDo
*/
QRY->(DbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query para buscar informaceos do contas a receber                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oObj:IncRegua1("Selecionando Registros CR (3)")
oObj:SetRegua2(3)
c_query := ''
c_query += "SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VALOR, E1_VENCREA, " + c_EOL
c_query += "       Round(sum(E1_SALDO),2) as E1_SALDO, E1_EMISSAO, E1_BAIXA, E1_FILIAL, E1_DECRESC " + c_EOL
c_query += "FROM (" + c_EOL
c_query += "      SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_BAIXA, E1_EMISSAO, E1_VALOR as VALORI, " + c_EOL
c_query += "             Round((E1_SALDO*isnull(EZ_PERC,1)*isnull(EV_PERC,1)),2) as E1_SALDO, E1_VENCREA, isnull(EV_NATUREZ, E1_NATUREZ) as E1_NATUREZ, EV_PERC, " + c_EOL
c_query += "             E1_FILIAL, isnull(EZ_CCUSTO, E1_XCC) as E1_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E1_VALOR)) as E1_VALOR, EZ_PERC, " + c_EOL
c_query += "             E1_DECRESC " + c_EOL
c_query += "      FROM SE1010 " + c_EOL
c_query += "      LEFT JOIN SEV010" + c_EOL
c_query += "           ON EV_FILIAL   = E1_FILIAL" + c_EOL
c_query += "              and       EV_PREFIXO  = E1_PREFIXO" + c_EOL
c_query += "              and       EV_NUM      = E1_NUM" + c_EOL
c_query += "              and       EV_PARCELA  = E1_PARCELA" + c_EOL
c_query += "              and       EV_TIPO     = E1_TIPO" + c_EOL
c_query += "              and       EV_CLIFOR   = E1_CLIENTE" + c_EOL
c_query += "              and       EV_LOJA     = E1_LOJA" + c_EOL
c_query += "              and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "      LEFT JOIN SEZ010" + c_EOL
c_query += "           ON EZ_FILIAL   = EV_FILIAL" + c_EOL
c_query += "              and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
c_query += "              and       EZ_NUM      = EV_NUM" + c_EOL
c_query += "              and       EZ_PARCELA  = EV_PARCELA" + c_EOL
c_query += "              and       EZ_TIPO     = EV_TIPO" + c_EOL
c_query += "              and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
c_query += "              and       EZ_LOJA     = EV_LOJA" + c_EOL
c_query += "              and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
c_query += "              and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL   
c_query += "      WHERE SE1010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "              and       E1_SALDO  = 0	" + c_EOL
c_query += "      ) A " + c_EOL
c_query += "WHERE E1_XCC = '"+c_Obra+"'" + c_EOL
c_query += "GROUP BY E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VENCREA, E1_EMISSAO, E1_BAIXA, E1_VALOR, E1_DECRESC " + c_EOL

c_query += "UNION ALL " + c_EOL

c_query += "SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VALOR, E1_VENCREA, " + c_EOL
c_query += "       Round(SUM(E1_SALDO),2) as E1_SALDO, E1_EMISSAO, E1_BAIXA, E1_FILIAL, E1_DECRESC " + c_EOL
c_query += "FROM (" + c_EOL
c_query += "      SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_BAIXA, E1_VALOR as VALORI, " + c_EOL
c_query += "             Round((E1_SALDO*isnull(EZ_PERC,1)*isnull(EV_PERC,1)),2) as E1_SALDO, E1_VENCREA, isnull(EV_NATUREZ, E1_NATUREZ) as E1_NATUREZ, EV_PERC, E1_FILIAL, " + c_EOL
c_query += "             isnull(EZ_CCUSTO, E1_XCC) as E1_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E1_VALOR)) as E1_VALOR, EZ_PERC, " + c_EOL
c_query += "             E1_DECRESC " + c_EOL
c_query += "      FROM SE1010 " + c_EOL
c_query += "      LEFT JOIN SEV010" + c_EOL
c_query += "           ON EV_FILIAL   = E1_FILIAL" + c_EOL
c_query += "              and       EV_PREFIXO  = E1_PREFIXO" + c_EOL
c_query += "              and       EV_NUM      = E1_NUM" + c_EOL
c_query += "              and       EV_PARCELA  = E1_PARCELA" + c_EOL
c_query += "              and       EV_TIPO     = E1_TIPO" + c_EOL
c_query += "              and       EV_CLIFOR   = E1_CLIENTE" + c_EOL
c_query += "              and       EV_LOJA     = E1_LOJA" + c_EOL
c_query += "              and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "      LEFT JOIN SEZ010" + c_EOL
c_query += "           ON EZ_FILIAL   = EV_FILIAL" + c_EOL
c_query += "              and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
c_query += "              and       EZ_NUM      = EV_NUM" + c_EOL
c_query += "              and       EZ_PARCELA  = EV_PARCELA" + c_EOL
c_query += "              and       EZ_TIPO     = EV_TIPO" + c_EOL
c_query += "              and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
c_query += "              and       EZ_LOJA     = EV_LOJA" + c_EOL
c_query += "              and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
c_query += "              and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "      WHERE SE1010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "            AND E1_SALDO  <> 0	" + c_EOL
c_query += "     ) A" + c_EOL
c_query += "WHERE E1_XCC = '"+c_Obra+"'" + c_EOL
c_query += "GROUP BY  E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VENCREA, E1_EMISSAO, E1_BAIXA, E1_VALOR, E1_DECRESC " + c_EOL
c_query += "ORDER BY  E1_NATUREZ, E1_VENCREA " + c_EOL
                                          
oObj:IncRegua2("Gerando Tabela Contas a Receber . . . CR")
memoWrite('RFIN022b.sql', c_query)

If Select("QRX") > 0
	DbSelectArea("QRX")
	DbCloseArea()
EndIf

oObj:IncRegua2("Processando Registros CR . . .")
TcQuery c_Query New Alias "QRX"                 
oObj:IncRegua2("Finalizando Registros CR . . .")

                         
n_tregcr := 0
DbEVal({|| n_tregcr++})
                
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes do CONTAS A RECEBER                                              ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
oObj:IncRegua1("Contas a Receber (4)")
oObj:SetRegua2(n_tregcr)
c_grprec := '010' //Grupo de Receitas
QRX->(DbGoTop())

nVlrImpAA	:= 0
nVlrImp		:= 0  //valores dos impostos
a_rdados	:= {}

Do While QRX->(!EOF())
	lIp			:= .F.
	c_vencrea	:= QRX->E1_VENCREA
	oObj:IncRegua2("Processando Contas a Receber . . .")
	
	c_natureza := Substr(QRX->E1_NATUREZ,1,6)       //
	DbSelectArea('SED')
	DbSetOrder(1) //ED_FILIAL, ED_CODIGO, R_E_C_N_O_, D_E_L_E_T_
	If DbSeek(xFilial('SED')+c_natureza)
		If !Empty(SED->ED_NATENTR)
			c_natureza := If(SED->ED_NATENTR!=SED->ED_CODIGO,Substr(SED->ED_NATENTR,1,4),SED->ED_NATENTR)
		EndIf
	EndIf
	                    
	DbSelectArea("QRX")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para situacoes de competencia.                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l_competencia
		If TRAB->(DbSeek(c_grprec+c_natureza))
			RecLock('TRAB', .F.)
		Else               
		   DbSelectArea("TRAB")
			RecLock('TRAB', .T.)
			TRAB->TRB_GRPO	:= c_grprec
			TRAB->TRB_NAT	:= c_natureza
			TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,18)+" Orc."+Transform(cVlrQRF,"@RE 999,999.9")
			DbSelectArea("QRX")
		EndIf
		If MV_PAR02 = SubStr(QRX->E1_EMISSAO, 1,4)
			If !(ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF')
				TRAB->&("TRB_M"+SubStr(QRX->E1_EMISSAO, 5,2)) += (QRX->E1_VALOR)
			EndIf
		EndIf
		
		TRAB->(MsUnLock())
		QRX->(DbSkip())
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para situacoes futuras...                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SubStr(c_vencrea, 1,4) > c_anoref .and. (Empty(QRX->E1_BAIXA) .or. SubStr(QRX->E1_BAIXA, 1,4) > c_anoref)
		QRX->(DbSkip())
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para RA's                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SE5')
	DbSetOrder(7) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	
	cTipoAux := QRX->E1_TIPO    

	If TRAB->(DbSeek(c_grprec+c_natureza))
		RecLock('TRAB', .F.)
	Else
		RecLock('TRAB', .T.)
		TRAB->TRB_GRPO	:= c_grprec
		TRAB->TRB_NAT	:= c_natureza
		TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
	EndIf                  
	               
	Do Case                                                       
	   Case QRX->E1_TIPO = "RA"                          
	        Do Case 
		      Case QRX->E1_SALDO > 0
		           Do Case
		              Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_EMISSAO,1,6)		                   
		                   TRAB->TRB_ANT += QRX->E1_SALDO
		              Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_EMISSAO,1,6) 
		                   TRAB->TRB_REAL += QRX->E1_SALDO
				        Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_EMISSAO,1,6)   
				             If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_EMISSAO,1,4)   
		                      TRAB->&("TRB_M"+SubStr(QRX->E1_EMISSAO, 5,2)) += QRX->E1_SALDO
		                   EndIf                                               
		           EndCase               
		       Case QRX->E1_SALDO = 0    
		           Do Case
		              Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_EMISSAO,1,6)		                   
		                   TRAB->TRB_ANT += QRX->E1_VALOR 
		              Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_EMISSAO,1,6)     
		                   TRAB->TRB_REAL += QRX->E1_VALOR 
				      Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_EMISSAO,1,6)     
				           If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_EMISSAO,1,4)     
		                      TRAB->&("TRB_M"+SubStr(QRX->E1_EMISSAO, 5,2)) += QRX->E1_VALOR	
		                   EndIf                                             
		           EndCase   
		    EndCase                                                                                                        
	   Case .f..And.ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'    //qdo for um titulo de impostos
	       dDtEmis := Stod(QRX->E1_EMISSAO)
	       nMesImp := Month(dDtEmis)+1
	       cMesImp := StrZero(If(nMesImp > 12,1,nMesImp),2)
	       cAnoImp := StrZero(If(cMesImp ="01",Year(dDtEmis)+1,Year(dDtEmis)),4)
	       cDtImp  := Dtos(Ctod("01/"+cMesImp+"/"+cAnoImp)) 
	       cAnoAnt := Str(Val(c_AnoRef)-1,4)
		   Do Case 
		      Case QRX->E1_SALDO = QRX->E1_VALOR .AND. QRX->E1_SALDO > 0
		           nVlrImp += QRX->E1_SALDO  //valor dos impostos     
		           Do Case
		              Case Substr(Dtos(dPerIni),1,6) > Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= c_anoref+"02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
		                   TRAB->TRB_ANT -= QRX->E1_SALDO
		              Case Substr(Dtos(dDataBase),1,6) = Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= c_anoref+"02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
		                   TRAB->TRB_REAL -= QRX->E1_SALDO
				      Case Substr(Dtos(dDataBase),1,6) != Substr(cDtImp,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= "02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))				      
				           If Substr(Dtos(dPerIni),1,4) = Substr(cDtImp,1,4)
		                      TRAB->&("TRB_M"+SubStr(cDtImp, 5,2)) -= QRX->E1_SALDO
		                   EndIf  
		           EndCase               
		       Case QRX->E1_SALDO = 0    
		            nVlrImp += QRX->E1_VALOR  //valor dos impostos     
		            Do Case
		               Case Substr(Dtos(dPerIni),1,6) > Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= c_anoref+"02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
		                    TRAB->TRB_ANT -= QRX->E1_VALOR 
		               Case Substr(Dtos(dDataBase),1,6) = Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= c_anoref+"02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
		                    TRAB->TRB_REAL -= QRX->E1_VALOR 
				         Case Substr(Dtos(dDataBase),1,6) != Substr(cDtImp,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= "02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
				              If Substr(Dtos(dPerIni),1,4) = Substr(cDtImp,1,4)
		                       TRAB->&("TRB_M"+SubStr(cDtImp, 5,2)) -= QRX->E1_VALOR	
		                    EndIf                                              
		            EndCase   
		                       
		    EndCase                                       
	   Case !(ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF')  //qdo nao for um titulo de impostos
	        Do Case
		        Case QRX->E1_SALDO = QRX->E1_VALOR .AND. QRX->E1_SALDO > 0   //titulo com valor totalmente em aberto
		             Do Case 
		                Case Substr(Dtos(dDataBase),1,6) > Substr(QRX->E1_VENCREA,1,6)
		                     TRAB->TRB_VENC += QRX->E1_VALOR - QRX->E1_DECRESC
			            	Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_VENCREA,1,6)
  			                  If Dtos(dDataBase) <= QRX->E1_VENCREA
			                     TRAB->TRB_ABER += QRX->E1_VALOR  - QRX->E1_DECRESC
			                  Else
			                     TRAB->TRB_VENC += QRX->E1_VALOR  - QRX->E1_DECRESC
			                  EndIf      
			             Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_VENCREA,1,4)
			                  If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_VENCREA,1,4)
				                  If Dtos(dDataBase) <= QRX->E1_VENCREA
			                         TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += QRX->E1_VALOR - QRX->E1_DECRESC 						
			                     Else
			                        TRAB->TRB_VENC += QRX->E1_VALOR - QRX->E1_DECRESC
			                     EndIf                                                
			                  EndIf                                               
		             EndCase
	           Case QRX->E1_SALDO < QRX->E1_VALOR .And. QRX->E1_SALDO > 0  //titulo com valor parcialmente em aberto	   
	                Do Case 
		                Case Substr(Dtos(dDataBase),1,6) > Substr(QRX->E1_VENCREA,1,6)
		                     TRAB->TRB_VENC += QRX->E1_SALDO - QRX->E1_DECRESC
		                Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_VENCREA,1,6)
			                  TRAB->TRB_ABER += QRX->E1_SALDO - QRX->E1_DECRESC  //MES ATUAL EM ABERTO
	  		             Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_VENCREA,1,6)
		  		               If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_VENCREA,1,4)  //dentro do ano de competencia
			                     TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += QRX->E1_SALDO - QRX->E1_DECRESC
			                  EndIf 
		            EndCase      
		       Case QRX->E1_SALDO = 0          
		            DbSelectArea("SE1")
		            nAbatim	 := SomaAbat(QRX->E1_PREFIXO,QRX->E1_NUM,QRX->E1_PARCELA,"R",1,,QRX->E1_CLIENTE,QRX->E1_LOJA,QRX->E1_FILIAL)  //impostos
		            
		            DbSelectArea("QRX")
		            Do Case 
		               Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_VENCREA,1,6)
		                    TRAB->TRB_ANT += nAbatim  - QRX->E1_DECRESC//QRX->IMPOSTOS
		               Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_VENCREA,1,6)
			                TRAB->TRB_REAL += nAbatim  - QRX->E1_DECRESC// QRX->IMPOSTOS  //MES ATUAL EM ABERTO
	  		           Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_VENCREA,1,6)
	  		                If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_VENCREA,1,4)  //dentro do ano de competencia
		                      TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += nAbatim - QRX->E1_DECRESC // QRX->IMPOSTOS
		                   EndIf 
		            EndCase      
	       EndCase	
	        
           DbSelectArea("SE1")
           DbSeek(QRX->E1_FILIAL+QRX->E1_PREFIXO+QRX->E1_NUM+QRX->E1_PARCELA+QRX->E1_TIPO)
	       U_FC040()        
	       
	       cRetEmis := Ctod("")
	       
	       DbSelectArea("cNomeArq")
	       DbGoTop()
	       Do While !Eof()
	                 
	          cRetEmis := Dtos(cNomeArq->DATAX)
	          
	          nSinal := If(cNomeArq->OK = 1.Or.(cNomeArq->OK = 2 .And.cNomeArq->MOTIVO = "NOR".And.cNomeArq->TIPODOC="VL"),1,If(cNomeArq->OK = 2,-1,0))
	          
	          If cNomeArq->MOTIVO = "CMP"		          
	             aAreaCMP := GetArea()
                     cChave := SubStr(cNomeArq->DOCUMENTO,1,3) // Prefixo
                     cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO, 4,6), substr(cNomeArq->DOCUMENTO, 5,9))//Numero
                     cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO,10,1), substr(cNomeArq->DOCUMENTO,15,2))//Parcela
                     cChave += 'RA'
                     
                     DbSelectArea('SE1')
                     DbSetOrder(1) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
                     If DbSeek(cNomeArq->Filial+cChave)   
                        If SE1->E1_SALDO = 0
                           DbSelectArea("cNomeArq")
                           DbSkip()
                           Loop
                        EndIf   
             	        cRetEmis := Dtos(SE1->E1_EMISSAO)
                     EndIf               
                     c_natureza := Substr(SE1->E1_NATUREZ,1,6) //
				      If TRAB->(DbSeek(c_grprec+c_natureza))
					   	 RecLock('TRAB', .F.)
			          Else
						 RecLock('TRAB', .T.)
						 TRAB->TRB_GRPO	:= c_grprec
						 TRAB->TRB_NAT	:= c_natureza
					  	 TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
					  EndIf    
		             RestArea(aAreaCMP)
		      Else
		         c_natureza := Substr(cNomeArq->NATUREZ,1,6)   //
			      If TRAB->(DbSeek(c_grprec+c_natureza))
				   	 RecLock('TRAB', .F.)
		          Else
					 RecLock('TRAB', .T.)
					 TRAB->TRB_GRPO	:= c_grprec
					 TRAB->TRB_NAT	:= c_natureza
				  	 TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
				  EndIf                                      
		          
	          EndIf       
	          
	          nPercRat := 1
	          DbSelectArea("SEV")
	          DbSetOrder(1)
	          If DbSeek(xFilial("SEV")+QRX->E1_PREFIXO+QRX->E1_NUM+QRX->E1_PARCELA+QRX->E1_TIPO+QRX->E1_CLIENTE+QRX->E1_LOJA+c_natureza)
	             If SEV->EV_RATEICC = "1"   
	                DbSelectArea("SEZ")
	                If DbSeek(xFilial("SEZ")+QRX->E1_PREFIXO+QRX->E1_NUM+QRX->E1_PARCELA+QRX->E1_TIPO+QRX->E1_CLIENTE+QRX->E1_LOJA+SEV->EV_NATUREZ+c_obra)
	                   nPercRat := SEV->EV_PERC*SEZ->EZ_PERC
	                Else
	                   nPercRat := 0   
	                EndIf   	             
	             Else
	                nPercRat := SEV->EV_PERC
	             EndIf      
	          EndIf   
	                                                                                                               
	          nVlrRec := cNomeArq->VALORRECEB
	          Do Case
	             Case cNomeArq->TIPODOC $ "MTüM2"
	                  nVlrRec := cNomeArq->MULTA*(-1)
	             Case cNomeArq->TIPODOC$"CMüC2|VM|CX"     
	                  nVlrRec := cNomeArq->CORRECAO*(-1)
	             Case cNomeArq->TIPODOC $ "JRüJ2"     
	                  nVlrRec := cNomeArq->JUROS*(-1)
	             Case cNomeArq->TIPODOC $ "DCüD2"     
	                  nVlrRec := cNomeArq->DESCONTOS
	          EndCase        
	          	               
	          Do Case 
	               Case Substr(Dtos(dPerIni),1,6) > Substr(cRetEmis,1,6)
	                    TRAB->TRB_ANT += Round(nVlrRec * nSinal*nPercRat,2)
	               Case Substr(Dtos(dDataBase),1,6) = Substr(cRetEmis,1,6)
		                TRAB->TRB_REAL += Round(nVlrRec * nSinal*nPercRat,2) //MES ATUAL EM ABERTO
  		           Case Substr(Dtos(dDataBase),1,6) != Substr(cRetEmis,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cRetEmis,1,6)   
  		                If Substr(Dtos(dPerIni),1,4) = Substr(cRetEmis,1,4)   //dentro do ano de competencia
	                      TRAB->&("TRB_M"+SubStr(cRetEmis, 5,2)) += Round((nVlrRec * nSinal)*nPercRat,2)
	                   EndIf 
	          EndCase               
	            
	          DbSelectArea("cNomeArq")  
	          DbSkip()
	       EndDo
	       If Select("cNomeArq") > 0
			  DbSelectArea("cNomeArq")
			  Use
			  Ferase(cNomearq+GetDBExtension())
			  Ferase(cNomeArq+OrdBagExt())
		   EndIf
	EndCase	
	
	TRAB->(MsUnLock())
	QRX->(DbSkip())
EndDo

oObj:IncRegua1("Contas a Receber TRAB . . .(5)")                        
oObj:SetRegua2(TRAB->(RecCount()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebra de linha                                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbselectArea('TRAB')
DbSeek('010')  //receitas
a_Totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
n_TotalN := 0                                                 

Do While TRAB->(!EOF()) .And. TRAB->TRB_GRPO = '010'
    oObj:IncRegua2("Processando Contas a Receber")
	n_TotalN := 0
	For n_x := 1 to 12
		a_Totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
		n_TotalN      += TRAB->&("TRB_M"+StrZero(n_x,2))
	Next
	a_Totais[13] += TRAB->TRB_ANT
	a_Totais[14] += TRAB->TRB_REAL
	a_Totais[15] += TRAB->TRB_ABER
	a_Totais[16] += TRAB->TRB_VENC
	
	RecLock('TRAB', .F.)
	TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + TRAB->TRB_ABER + n_TotalN 
	MsUnLock()
	
	a_Totais[17] += TRAB->TRB_TOT      
	
	If !(AllTrim(TRAB->TRB_NAT) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF')
	   nTotPrvRec += TRAB->TRB_TOT
	EndIf
	TRAB->(DbSkip())
EndDo

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totaliza a linha                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c_grprec := '011' //Grupo de Receitas - subgrupo total de receitas
RecLock('TRAB', .T.)              

oObj:IncRegua1("Contas a Receber Totalizando . . .(6)")                        
oObj:SetRegua2(TRAB->(RecCount()))

TRAB->TRB_GRPO	:= c_grprec
TRAB->TRB_DESC	:= "TOTAL CONTAS A RECEBER NO MES        [a]"
For n_x := 1 to 12                                
    oObj:IncRegua2("Processando Contas a Receber")
	TRAB->&("TRB_M"+StrZero(n_x,2)) := a_totais[n_x]
Next
TRAB->TRB_ANT	:= a_totais[13]
TRAB->TRB_REAL	:= a_totais[14]
TRAB->TRB_ABER	:= a_totais[15]
TRAB->TRB_VENC	:= a_totais[16]
TRAB->TRB_TOT	:= a_totais[17]    
n_Atrasados     := TRAB->TRB_VENC     
nTotPrvRec      += n_Atrasados       
*/  

TRAB->(MsUnLock())



//Aadd(a_separar, {'012','-'})
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes do faturamento direto                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************

oObj:IncRegua1("Faturamento Direto (7)")
oObj:SetRegua2(2)
c_grprec := '015' //Grupo de Receitas - Sub-Grupo FATURAMENTO DIRETO

c_query := " SELECT Sum(D1_TOTAL+(C7_VALIPI*(D1_QUANT/C7_QUANT))+D1_VALFRE+D1_DESPESA+D1_SEGURO-D1_VALDESC) as VALOR, C7_DATPRF, D1_TES,"

c_query += "        Sum((C7_QUANT-C7_QUJE)*C7_PRECO + (((C7_QUANT-C7_QUJE)/C7_QUANT)*D1_VALIPI * (D1_QUANT/C7_QUANT))) as VLRAB "
c_query += " FROM SC7010 C7 "
c_query += "      LEFT OUTER JOIN SD1010 D1 "
c_query += "           ON  D1.D_E_L_E_T_='' "
c_query += "           AND D1_PEDIDO = C7_NUM "
c_query += "           AND D1_ITEMPC = C7_ITEM "
c_query += "           AND D1_COD    = C7_PRODUTO "
c_query += "           AND D1_TES    <> '' "
c_query += "      INNER JOIN SB1010 B1 "
c_query += "            ON  B1.D_E_L_E_T_='' "
c_query += "            AND B1.B1_FILIAL  ='"+xFilial("SB1")+"' "  
c_query += "            AND B1_COD = C7_PRODUTO "
c_query += "      INNER JOIN CTT010 CTT "
c_query += "            ON  CTT.D_E_L_E_T_='' "
c_query += "            AND CTT_XLFATD = 'S' "
c_query += "            AND CTT_CUSTO = C7_XCCFTD "
c_query += " WHERE C7_XCCFTD = '"+c_Obra+"'"
c_query += "       AND       SUBSTRING(C7_DATPRF,1,4) <= '"+c_anoref+"'" + c_EOL
c_query += "       AND C7_XCCFTD <> '' "
c_query += "       AND C7_XFATD = 'S' "
c_query += "       AND C7.D_E_L_E_T_ = '' "
c_query += " GROUP BY C7_DATPRF, D1_TES"
                                                 
oObj:IncRegua2("Gerando Selecao Faturamento Direto . . .")
MemoWrite("RFIN022_FATD",c_query)

If Select("QRX") > 0
	DbSelectArea("QRX")
	DbCloseArea()
EndIf
TcQuery c_Query New Alias "QRX"

n_tregfd := 0
DbEVal({|| n_tregfd++})

RecLock('TRAB', .T.)
TRAB->TRB_GRPO	:= c_grprec
TRAB->TRB_DESC	:= "FATURAMENTO DIRETO                   [b]"

oObj:SetRegua2(n_tregfd)  
QRX->(DbGoTop())
While QRX->(!EOF())                                
    oObj:IncRegua2("Processando Faturamento Direto . . .")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o material foi direto para obra, nesse caso acumula array para atualizar despesas      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QRX->D1_TES = '330' .and. len(a_fatdir)=0
		a_fatdir := {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	EndIf
	
	If SubStr(QRX->C7_DATPRF, 1,4) < AllTrim(c_anoref)
		TRAB->TRB_ANT += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)   //ANO ANTERIOR
		If QRX->D1_TES = '330'
			a_fatdir[13] += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)    //ANO ANTERIOR
		EndIf
	ElseIf SubStr(QRX->C7_DATPRF, 5,2) = SubStr(DtoS(dDataBase), 5, 2) .And. Substr(QRX->C7_DATPRF,1,4) == c_anoref .And. SubStr(DtoS(dDataBase), 1,4) == c_anoref
		If Stod(QRX->C7_DATPRF) > dDataBase
			TRAB->TRB_ABER += Round(QRX->VALOR,2) + Round(QRX->VLRAB,2)     //MES ATUAL EM ABERTO
			If QRX->D1_TES = '330'
				a_fatdir[15] += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)
			EndIf
		Else
			TRAB->TRB_REAL += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)     //MES ATUAL REALIZADO
			If QRX->D1_TES = '330'
				a_fatdir[14] += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)
			EndIf
		EndIf
	Else
		TRAB->&("TRB_M"+SubStr(QRX->C7_DATPRF, 5,2)) += Round(QRX->VALOR,2) //Outros meses normais
		If QRX->D1_TES = '330'
			a_fatdir[val(SubStr(QRX->C7_DATPRF, 5,2))] += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)
		EndIf
	EndIf
	QRX->(DbSkip())
EndDo
TRAB->(MsUnLock())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totaliza a linha                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbselectArea('TRAB')                    

oObj:IncRegua1("Totalizando Faturamento Direto . . . (8)")
oObj:SetRegua2(24) 

If DbSeek('015',.t.)  //faturamento direto
	n_TotalN := 0
	For n_x := 1 to 12        
	    oObj:IncRegua2("Processando Faturamento Direto . . .")
		n_TotalN += TRAB->&("TRB_M"+StrZero(n_x,2))
	Next
	RecLock('TRAB', .F.)
	TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + TRAB->TRB_ABER  + n_TotalN
	nTotPrvRec += TRAB->TRB_TOT
	MsUnLock()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebra de linha                                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
DbselectArea('TRAB')
DbSeek('011',.t.)
a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '015'
	For n_x := 1 to 12
    	oObj:IncRegua2("Processando Faturamento Direto . . .")
		a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
	Next
	a_totais[13] += TRAB->TRB_ANT
	a_totais[14] += TRAB->TRB_REAL
	a_totais[15] += TRAB->TRB_ABER
	a_totais[16] += TRAB->TRB_VENC
	a_totais[17] += TRAB->TRB_TOT
	TRAB->(DbSkip())
EndDo
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totaliza a linha                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Aadd(a_separar, {'016','-'})

/*
c_GrpRec := '018' //Grupo de Receitas - subgrupo total GERAL de receitas
RecLock('TRAB', .T.)
TRAB->TRB_GRPO	:= c_grprec
TRAB->TRB_DESC	:= "TOTAL CTAS A RECEBER ACUMULADO [a+b]=[c]"
n_TotAcm 		:= a_Totais[13]   //anterior ao periodo atual
TRAB->TRB_ANT	:= n_TotAcm
oObj:IncRegua1("Totalizando Contas a Receber Acumulado . . . (9)")
oObj:SetRegua2(12) 

For n_x := 1 To 12                                        
    oObj:IncRegua2("Processandoo Contas a Receber Acumulado . . .")
	If n_x = val(Substr(Dtos(ddatabase),5,2)).And.Substr(Dtos(ddatabase),1,4) = AllTrim(MV_PAR03)

		TRAB->TRB_REAL	:= a_Totais[14]   //realizado
				
		TRAB->TRB_ABER	:= a_Totais[15]  //aberto
	EndIf
	n_TotAcm += a_Totais[n_x]
	TRAB->&("TRB_M"+StrZero(n_x,2)) := n_TotAcm
Next

TRAB->TRB_TOT := n_TotAcm + n_Atrasados
n_TotCRA	  := n_TotAcm + n_Atrasados
*/

TRAB->(MsUnLock())                          
                                   
 
 
 
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes do contas a pagar                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
oObj:IncRegua1("Contas a Pagar")
oObj:SetRegua2(n_tregcp)
c_grprec := '020' //Grupo de Despesas
If QRY->(!EOF())
   Do While QRY->(!EOF())
		oObj:IncRegua2("Processando CP . . .")
		If TRAB->(DbSeek(c_grprec+Substr(QRY->E2_NATUREZ,1,6))) //
			RecLock('TRAB', .F.)
		Else
			RecLock('TRAB', .T.)
			TRAB->TRB_GRPO	:= c_grprec
			TRAB->TRB_NAT	:= QRY->E2_NATUREZ
			TRAB->TRB_DESC	:= substr(QRY->E2_NATUREZ,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+QRY->E2_NATUREZ, 1, 'X'), 1,32)
		EndIf                             
		
		nPercNat := QRY->EV_PERC*QRY->EZ_PERC                            
		
		Do Case                                                       
           Case QRY->E2_TIPO = "PA"                          
                Do Case 
	               Case QRY->E2_SALDO > 0
	                    Do Case
	                       Case Substr(Dtos(dPerIni),1,6) > Substr(QRY->E2_EMISSAO,1,6)		                   
	                            TRAB->TRB_ANT += QRY->E2_SALDO*nPercNat
	                       Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_EMISSAO,1,6) 
	                            TRAB->TRB_REAL += QRY->E2_SALDO*nPercNat
			               Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_EMISSAO,1,6)     
	                            TRAB->&("TRB_M"+SubStr(QRY->E2_EMISSAO, 5,2)) += QRY->E2_SALDO*nPercNat
	                    EndCase               
	               Case QRY->E2_SALDO = 0    
	                    Do Case
	                       Case Substr(Dtos(dPerIni),1,6) > Substr(QRY->E2_EMISSAO,1,6)		                   
	                            TRAB->TRB_ANT += QRY->E2_VALOR*nPercNat
	                       Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_EMISSAO,1,6)     
	                            TRAB->TRB_REAL += QRY->E2_VALOR*nPercNat
			               Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_EMISSAO,1,6)     
	                            TRAB->&("TRB_M"+SubStr(QRY->E2_EMISSAO, 5,2)) += QRY->E2_VALOR*nPercNat
	                    EndCase   
	            EndCase                                       
           Case QRY->E2_SALDO = QRY->E2_VALOR .AND. QRY->E2_SALDO > 0   //titulo com valor totalmente em aberto
	            Do Case 
	               Case Substr(Dtos(dDataBase),1,6) > Substr(QRY->E2_VENCREA,1,6)
	                    TRAB->TRB_VENC += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
		           Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_VENCREA,1,6)
		                If Dtos(dDataBase) <= QRY->E2_VENCREA
		                   TRAB->TRB_ABER += QRY->E2_VALOR*nPercNat  - QRY->E2_DECRESC*nPercNat
		                Else
		                   TRAB->TRB_VENC += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
		                EndIf      
		           Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6)
		                If Dtos(dDataBase) <= QRY->E2_VENCREA
	                       TRAB->&("TRB_M"+SubStr(QRY->E2_VENCREA, 5,2)) += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
	                    Else
	                       TRAB->TRB_VENC += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
	                    EndIf   
	            EndCase
           Case QRY->E2_SALDO < QRY->E2_VALOR .And. QRY->E2_SALDO > 0  //titulo com valor parcialmente em aberto	   
                Do Case 
	               Case Substr(Dtos(dDataBase),1,6) > Substr(QRY->E2_VENCREA,1,6)
	                    TRAB->TRB_VENC += QRY->E2_SALDO*nPercNat - QRY->E2_DECRESC*nPercNat
	               Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_VENCREA,1,6)
		                TRAB->TRB_ABER += QRY->E2_SALDO*nPercNat - QRY->E2_DECRESC*nPercNat  //MES ATUAL EM ABERTO
  		           Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6)
	                    TRAB->&("TRB_M"+SubStr(QRY->E2_VENCREA, 5,2)) += QRY->E2_SALDO*nPercNat - QRY->E2_DECRESC*(nPercNat)
	            EndCase      
	       Case QRY->E2_SALDO = 0          
	            DbSelectArea("SE2")           
	            nAbatim	 := SomaAbat(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE,SE2->E2_LOJA)
	            
	            DbSelectArea("QRX")
	            Do Case 
	               Case Substr(Dtos(dPerIni),1,6) > Substr(QRY->E2_VENCREA,1,6)
	                    TRAB->TRB_ANT += nAbatim*nPercNat  - QRY->E2_DECRESC*nPercNat//QRX->IMPOSTOS
	               Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_VENCREA,1,6)
		                TRAB->TRB_REAL += nAbatim*nPercNat  - QRY->E2_DECRESC*nPercNat// QRX->IMPOSTOS  //MES ATUAL EM ABERTO
  		           Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6)
	                    TRAB->&("TRB_M"+SubStr(QRY->E2_VENCREA, 5,2)) += nAbatim*nPercNat - QRY->E2_DECRESC*nPercNat // QRX->IMPOSTOS
	            EndCase      
               
       EndCase	
        
       DbSelectArea("SE2")
       DbSeek(QRY->E2_FILIAL+QRY->E2_PREFIXO+QRY->E2_NUM+QRY->E2_PARCELA+QRY->E2_TIPO+QRY->E2_FORNECE+QRY->E2_LOJA)
        U_FC050()        
       
       cRetEmis := Ctod("")
       
       DbSelectArea("cNomeArq")
       DbGoTop()
       Do While !Eof()
          DbSelectArea("cNomeArq")
	      DbGoTop()
	      Do While !Eof()
	                 
	          cRetEmis := Dtos(cNomeArq->DATAX)
	          
	          nSinal   := If(cNomeArq->OK = 1.Or.(cNomeArq->OK = 2 .And.cNomeArq->MOTIVO = "NOR".And.cNomeArq->TIPODOC="VL"),1,If(cNomeArq->OK = 2,-1,0))
	          
	          If cNomeArq->MOTIVO = "CMP"		          
	             aAreaCMP := GetArea()
                 cChave := SubStr(cNomeArq->DOCUMENTO,1,3) // Prefixo
                 cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO, 4,6), substr(cNomeArq->DOCUMENTO, 5,9))//Numero
                 cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO,10,1), substr(cNomeArq->DOCUMENTO,15,2))//Parcela
                 cChave += substr(cNomeArq->DOCUMENTO,18,3)
                 //cChave += Substr(cNomeArq->DOCUMENTO,22,8)
                     
                 DbSelectArea('SE2')
                 DbSetOrder(1) //E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO,E2_FORNEC, E2_LOJA R_E_C_N_O_, D_E_L_E_T_
                 If DbSeek(cNomeArq->Filial+cChave)   
                    If SE2->E2_SALDO = 0
                       DbSelectArea("cNomeArq")
                       DbSkip()
                       Loop
                    EndIf   
             	    cRetEmis := Dtos(SE2->E2_EMISSAO)
                 EndIf               
                 c_natureza := Substr(SE2->E2_NATUREZ,1,6)     //
				 If TRAB->(DbSeek(c_grprec+c_natureza))
				  	 RecLock('TRAB', .F.)
			     Else
				    RecLock('TRAB', .T.)
				    TRAB->TRB_GRPO	:= c_grprec
				    TRAB->TRB_NAT	:= c_natureza
				    TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
			     EndIf    
		         RestArea(aAreaCMP)
		      
	          EndIf        
	                   	                                                                                                               
	          nVlrRec := cNomeArq->VALORPAGO*nPercNat
	          Do Case
	             Case cNomeArq->TIPODOC $ "MTüM2"
	                  nVlrRec := (cNomeArq->MULTA*(-1))*nPercNat
	             Case cNomeArq->TIPODOC$"CMüC2|VM|CX"     
	                  nVlrRec := (cNomeArq->CORRECAO*(-1))*nPercNat
	             Case cNomeArq->TIPODOC $ "JRüJ2"     
	                  nVlrRec := (cNomeArq->JUROS*(-1))*nPercNat
	             Case cNomeArq->TIPODOC $ "DCüD2"     
	                  nVlrRec := (cNomeArq->DESCONTOS)*nPercNat
	          EndCase        
	          	                            	          	               	  				          	               
	          Do Case 
	               Case Substr(Dtos(dPerIni),1,6) > Substr(cRetEmis,1,6)
	                    TRAB->TRB_ANT += (nVlrRec * nSinal)
	               Case Substr(Dtos(dDataBase),1,6) = Substr(cRetEmis,1,6)
		                TRAB->TRB_REAL += (nVlrRec * nSinal) //MES ATUAL EM ABERTO
  		           Case Substr(Dtos(dDataBase),1,6) != Substr(cRetEmis,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cRetEmis,1,6)
	                    TRAB->&("TRB_M"+SubStr(cRetEmis, 5,2)) += (nVlrRec * nSinal)
	          EndCase               
	            
	          DbSelectArea("cNomeArq")  
	          DbSkip()
	       EndDo   
	    EndDo
	    
	    If Select("cNomeArq") > 0
		   DbSelectArea("cNomeArq")
		   Use
		   Ferase(cNomearq+GetDBExtension())
		   Ferase(cNomeArq+OrdBagExt())
	    EndIf
	
		TRAB->(MsUnLock())		
		QRY->(DbSkip())
	EndDo
EndIf


//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Adiciona linha de faturamento direto que nao entrou na LISONDA, se houver                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
c_GrpRec := '021' //Grupo de Despesas - subgrupo Fat. Direto
If Len(a_FatDir) > 0
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "9999 - Faturamento Direto               "
	TRAB->TRB_ANT 	+= a_FatDir[13]
	TRAB->TRB_REAL  += a_FatDir[14]
	TRAB->TRB_ABER  += a_FatDir[15]
	For n_y := 1 to 12
		TRAB->&("TRB_M"+StrZero(n_y, 2)) := a_FatDir[n_y]
	Next
	TRAB->(MsUnLock())
EndIf



//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes de utilizacao de MAO DE OBRA                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
oObj:IncRegua1("Mao de Obra")            
oObj:IncRegua2(13)
oObj:IncRegua2("Processando mao de obra")

c_GrpRec := '022' //Grupo de Despesas - subgrupo MAO DE OBRA

RecLock('TRAB', .T.)
TRAB->TRB_GRPO	:= c_grprec
TRAB->TRB_DESC	:= " MÃO DE OBRA UTILIZADA                  "
TRAB->TRB_ANT	:= fBusMod(StrZero(VAL(c_anoref)-1,4))
For n_y := 1 to 12                       
    oObj:IncRegua2("Processando mao de obra")
	If strzero(n_y,2) = SubStr(DtoS(dDataBase), 5, 2)
		TRAB->TRB_REAL := fBusMod(c_anoref+StrZero(n_y,2))
	Else 
		TRAB->&("TRB_M"+StrZero(n_y, 2)) := fBusMod(c_anoref+StrZero(n_y,2))
	EndIf
Next
TRAB->(MsUnLock())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebra de linha                                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbselectArea('TRAB')
DbSeek('020',.t.)
a_totais   := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
n_totaln   := 0                                                             
nTotPrvDep := 0
oObj:IncRegua1("Totalizando CP")                                          
oObj:IncRegua2(14)

Do While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '022'
	n_totaln := 0
	For n_x := 1 to 12
	    oObj:IncRegua2("Processando . . .")
		a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
		n_totaln      += TRAB->&("TRB_M"+StrZero(n_x,2))
	Next
	a_totais[13] += TRAB->TRB_ANT
	a_totais[14] += TRAB->TRB_REAL
	a_totais[15] += TRAB->TRB_ABER
	a_totais[16] += TRAB->TRB_VENC
	RecLock('TRAB', .F.)
	TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln + TRAB->TRB_ABER
	MsUnLock()
	a_totais[17] += TRAB->TRB_TOT
	nTotPrvDep   += TRAB->TRB_TOT 
	TRAB->(DbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totaliza a linha                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c_grprec := '023' //Grupo de Despesas - subgrupo total de despesas
RecLock('TRAB', .T.)
TRAB->TRB_GRPO	:= c_grprec
TRAB->TRB_DESC	:= "TOTAL CONTAS A PAGAR NO MÊS          [d]"
For n_x := 1 to 12                         
    oObj:IncRegua2("Processando . . .")
	TRAB->&("TRB_M"+StrZero(n_x,2)) := a_totais[n_x]
Next
TRAB->TRB_ANT	:= a_totais[13]
TRAB->TRB_REAL	:= a_totais[14]
TRAB->TRB_ABER	:= a_totais[15]
TRAB->TRB_VENC	:= a_totais[16]
TRAB->TRB_TOT	:= a_totais[17] 
n_Atrasados     := TRAB->TRB_VENC
nTotPrvDep      += n_Atrasados
TRAB->(MsUnLock())
 
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³ NOTAS FISCAIS DE REMESSA                                                                ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
oObj:IncRegua1("Notas de Remessa")
oObj:IncRegua2("Processando notas de remessa")
c_grprec := '025' //Grupo Notas de remessa

c_query := " SELECT SUM(D2_TOTAL) AS VALOR, SUM(B1_CUSTD)as CUTSD, D2_EMISSAO AS C7_DATPRF"
c_query += " FROM SD2010 "
c_query += " INNER JOIN SF4010 "
c_query += "       ON F4_CODIGO = D2_TES "
c_query += "          AND F4_DUPLIC <> 'S' "
c_query += "          AND SF4010.D_E_L_E_T_ <> '*' "
c_query += " INNER JOIN SB1010 "
c_query += "       ON B1_COD = D2_COD "
c_query += "          AND B1_TIPO NOT IN  ('AT','MQ') "
c_query += "          ANd SB1010.D_E_L_E_T_ = ' ' "
c_query += " WHERE D2_CCUSTO = '"+c_Obra+"'  "
c_query += "       AND D2_COD NOT LIKE 'AT%' "
c_query += "       AND SD2010.D_E_L_E_T_ <> '*' "
c_query += "       AND SUBSTRING(D2_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
c_query += " GROUP BY D2_EMISSAO "

If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
EndIf
TcQuery c_Query New Alias "QRY"

RecLock('TRAB', .T.)
TRAB->TRB_GRPO	:= c_grprec
TRAB->TRB_DESC	:= "NOTAS FISCAIS DE REMESSA (CUSTO)     [e]"

Do While QRY->(!EOF())
	If SubStr(QRY->C7_DATPRF, 1,4) < c_anoref
		TRAB->TRB_ANT += QRY->VALOR //ANO ANTERIOR
	Else
		If SubStr(QRY->C7_DATPRF, 5,2) = SubStr(DtoS(dDataBase), 5, 2)
			TRAB->TRB_REAL += QRY->VALOR  //MES ATUAL REALIZADO
		Else
			TRAB->&("TRB_M"+SubStr(QRY->C7_DATPRF, 5,2)) += QRY->VALOR
		EndIf
	EndIf
	
	QRY->(DbSkip())
EndDo
TRAB->(MsUnLock())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totaliza a linha                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbselectArea('TRAB')
If DbSeek('025')
	n_totaln := 0
	For n_x := 1 to 12
		n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
	Next
	RecLock('TRAB', .F.)
	TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln      
	nTotPrvDep += TRAB->TRB_TOT 
	MsUnLock()
EndIf
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³ NOTAS FISCAIS DE RETORNO DE REMESSA                                                     ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Retorno de Remessa")
//oObj:IncRegua2("Processando retorno de remessa")
c_grprec := '026' //Grupo Notas de remessa - sub grupo retorno

c_query := "SELECT SUM(D1_TOTAL) AS VALOR, D1_EMISSAO "
c_query += "FROM SD1010 D1 "
c_query += "LEFT JOIN SF4010 F4 "
c_query += "     ON F4.D_E_L_E_T_ = '' "
c_query += "        AND F4_CODIGO = D1_TES "
c_query += "        AND F4_DUPLIC <> 'S' "
c_query += "inner JOIN SB1010 B1 "
c_query += "     ON B1.D_E_L_E_T_='' "
c_query += "        AND B1.B1_COD = D1_COD "
c_query += "        AND B1_TIPO NOT IN  ('AT','MQ') "
c_query += "WHERE D1.D_E_L_E_T_ = '' "
c_query += "      AND D1_CC = '"+c_Obra+"' "
c_query += "      AND D1_TIPO = 'D' "
c_query += "      AND SUBSTRING(D1_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
c_query += "GROUP BY D1_EMISSAO "

If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
EndIf

TcQuery c_Query New Alias "QRY"

RecLock('TRAB', .T.)
TRAB->TRB_GRPO	:= c_grprec
TRAB->TRB_DESC	:= "RETORNO DE REMESSA (CUSTO)           [f]"

Do While QRY->(!EOF())
	If SubStr(QRY->D1_EMISSAO, 1,4) < c_anoref
		TRAB->TRB_ANT += QRY->VALOR //ANO ANTERIOR
	Else
		If SubStr(QRY->D1_EMISSAO, 5,2) = SubStr(DtoS(dDataBase), 5, 2)
			TRAB->TRB_REAL += QRY->VALOR  //MES ATUAL REALIZADO
		Else
			TRAB->&("TRB_M"+SubStr(QRY->D1_EMISSAO, 5,2)) += QRY->VALOR
		EndIf
	EndIf
	QRY->(DbSkip())
EndDo
TRAB->(MsUnLock())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totaliza a linha                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
DbselectArea('TRAB')
If DbSeek('026')
	n_totaln := 0
	For n_x := 1 to 12
		n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
		a_totais[n_x] -= TRAB->&("TRB_M"+StrZero(n_x,2))
	Next
	RecLock('TRAB', .F.)
	TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln
	nTotPrvDep    += TRAB->TRB_TOT + TRAB->TRB_VENC
	a_totais[13] -= TRAB->TRB_ANT
	a_totais[14] -= TRAB->TRB_REAL
	a_totais[15] -= TRAB->TRB_ABER
	a_totais[16] -= TRAB->TRB_VENC
	a_totais[17] -= TRAB->TRB_TOT
	MsUnLock()
EndIf
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³ TOTAIS E SALDOS                                                                         ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
DbselectArea('TRAB')
DbSeek('023')
While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '025'
	For n_x := 1 to 12
		a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
	Next
	a_totais[13] += TRAB->TRB_ANT
	a_totais[14] += TRAB->TRB_REAL
	a_totais[15] += TRAB->TRB_ABER
	a_totais[16] += TRAB->TRB_VENC
	a_totais[17] += TRAB->TRB_TOT
	TRAB->(DbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totaliza a linha TOTAL DE DESPESAS ACUMULADAS                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Aadd(a_separar, {'027','-'})
c_grprec := '028' //Grupo de Despesas - subgrupo total acumulado de despesas
RecLock('TRAB', .T.)
TRAB->TRB_GRPO	:= c_grprec
TRAB->TRB_DESC	:= "TOTAL DE DESPESAS ACUMULADAS [d+e-f]=[g]"
n_totacm 		:= a_totais[13]   //anterior ao periodo atual
TRAB->TRB_ANT	:= n_totacm
For n_x := 1 to 12
	If n_x = val(substr(dtos(ddatabase),5,2))
		n_totacm 		+= a_totais[14]   //realizado
		TRAB->TRB_REAL	:= n_totacm
		n_totacm 		+= a_totais[15]  //aberto
		TRAB->TRB_ABER	:= n_totacm
	EndIf
	n_totacm += a_totais[n_x]
	TRAB->&("TRB_M"+StrZero(n_x,2)) := n_totacm
Next

TRAB->TRB_TOT	:= n_totacm + n_atrasados
n_totDA			:= n_totacm + n_atrasados
TRAB->(MsUnLock())                    

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRetCusto ºAutor  ³Alexandre Sousa     º Data ³  11/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o custo do orcamento.                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRetCusto(c_prj, c_rev)

Local n_Ret := 0

c_query := " select * from "+RetSqlName('AFC')+" "
c_query += " where AFC_PROJET = '"+c_prj+"' "
c_query += " and   AFC_REVISA = '0001'"
c_query += " and   D_E_L_E_T_ <> '*' "
c_query += " and   AFC_NIVEL = '001' "
c_query += " and   AFC_FILIAL = '"+xFilial('AFC')+"' "

MemoWrite("RFIN022_CST",c_query)

If Select("TRP") > 0
	DbSelectArea("TRP")
	DbCloseArea()
EndIf

TcQuery c_Query New Alias "TRP"

If TRP->(!EOF())
	n_Ret := TRP->AFC_CUSTO
EndIf


Return n_Ret
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN011   ºAutor  ³Microsiga           º Data ³  10/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a data de emsissao do RA para compor o titulo.      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRetdtRA(c_vencrea)

Local a_Area := GetArea()
Local c_Ret := c_vencrea

c_chave := SubStr(SE5->E5_DOCUMEN,1,3) // Prefixo
c_chave += Iif(len(alltrim(SE5->E5_DOCUMEN))<= 15, substr(SE5->E5_DOCUMEN, 4,6), substr(SE5->E5_DOCUMEN, 4,9))//Numero
c_chave += Iif(len(alltrim(SE5->E5_DOCUMEN))<= 15, substr(SE5->E5_DOCUMEN,10,1), substr(SE5->E5_DOCUMEN,13,1))//Parcela
c_chave += 'RA'

DbSelectArea('SE1')
DbSetOrder(1) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
If DbSeek(xFilial('SE1')+c_chave)
	c_Ret := dtos(SE1->E1_EMISSAO)
EndIf

RestArea(a_Area)

Return c_Ret
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TrataSE5  ºAutor  ³Alexandre Sousa     º Data ³  12/15/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza o tratamento do se5 para titulos com baixa parcial  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TrataSE5(c_anoref)

Local c_EOL		:= chr(13)+chr(10)

c_query := " select * " + c_EOL
c_query += " from SE5010 " + c_EOL
c_query += " where     E5_FILIAL  = '"+xFilial('SE5')+"'" + c_EOL
c_query += " and       E5_PREFIXO = '" + QRX->E1_PREFIXO + "'" + c_EOL
c_query += " and       E5_NUMERO  = '" + QRX->E1_NUM + "'" + c_EOL
c_query += " and       E5_PARCELA = '" + QRX->E1_PARCELA + "'" + c_EOL
c_query += " and       E5_TIPO    = '" + QRX->E1_TIPO + "'" + c_EOL
c_query += " and       E5_CLIFOR  = '" + QRX->E1_CLIENTE + "'" + c_EOL
c_query += " and       E5_LOJA    = '" + QRX->E1_LOJA + "'" + c_EOL
//	c_query += " and       E5_RECONC  = 'x' " + c_EOL
c_query += " and       D_E_L_E_T_ <> '*' " + c_EOL

If Select("QRW") > 0
	DbSelectArea("QRW")
	DbCloseArea()
EndIf

TcQuery c_Query New Alias "QRW"

While QRW->(!EOF())
	
	c_vencrea := QRW->E5_DATA
	
	If TRAB->(DbSeek(c_grprec+c_natureza))
		RecLock('TRAB', .F.)
	Else
		RecLock('TRAB', .T.)
		TRAB->TRB_GRPO	:= c_grprec
		TRAB->TRB_NAT	:= c_natureza
		TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
	EndIf
	                        
	
	If SubStr(c_vencrea, 5,2) <> SubStr(DtoS(dDataBase), 5, 2)
		If .f..and.ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
			TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRW->E5_VALOR
			nVlrImp += QRW->E5_VALOR
		Else
			If QRW->E5_TIPODOC = 'MT'
				TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRW->E5_VALOR
			Else
				TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRW->E5_VALOR                             
			EndIf
		EndIf
	ElseIf SubStr(c_vencrea, 5,2) = SubStr(DtoS(dDataBase), 5, 2) .And.SubStr(c_vencrea, 1,4) = c_anoref
		If .f..and.ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
			TRAB->TRB_REAL -= QRW->E5_VALOR  //MES ATUAL REALIZADO
			nVlrImp += QRW->E5_VALOR  //valor dos impostos
		Else
			If QRW->E5_TIPODOC = 'MT'
				TRAB->TRB_REAL -= QRW->E5_VALOR  //MES ATUAL REALIZADO
			Else
				TRAB->TRB_REAL += QRW->E5_VALOR  //MES ATUAL REALIZADO
			EndIf
		EndIf
	EndIf                                                                                     
	
	
	TRAB->(MsUnLock())
	
	QRW->(DbSkip())
EndDo                              


Static Function DescrStObra(pStObra)
Local cStatus

Do Case
   Case pStObra = "A"
        cStatus := "Andamento"
   Case pStObra = "P"
        cStatus := "Paralisada"
   Case pStObra = "C"
        cStatus := "Concluida" 
   Case pStObra = "N"
        cStatus := "Nao Liberada"
   Case pStObra = "L"
        cStatus := "Liberada"
EndCase

Return(cStatus)                   
   
   
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN011   ºAutor  ³Alexandre Sousa     º Data ³  09/26/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os valores de mao de obra utilizadas no mes         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fBusMod(c_datalike)

n_Ret := 0
c_query := ''

c_query := " select     ZC_DATA, ZC_OBRA, ZC_RECURSO, AE8_CUSTOM, AE8_CUSTOM/22 as CUSTO_DIA"
c_query += " from       "+RetSqlName('SZC')+" as SZC"
c_query += " inner join "+RetSqlName('AE8')+" as AE8"
c_query += " on         ZC_RECURSO = AE8_RECURS"
c_query += " and        AE8.D_E_L_E_T_ <> '*'"
c_query += " where      ZC_OBRA = '"+CTT->CTT_CUSTO+"'"
c_query += " and        ZC_DATA like '"+c_datalike+"%'"
c_query += " and        SZC.D_E_L_E_T_ <> '*'"

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TcQuery c_Query New Alias "TMP"

While TMP->(!EOF())
	n_Ret += TMP->CUSTO_DIA
	TMP->(DbSkip())
EndDo

Return n_Ret   