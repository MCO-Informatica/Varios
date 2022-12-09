#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#INCLUDE "APDR010.CH"

#DEFINE CHRCOMP If(aReturn[4]==1,15,18)


User Function aval001()

Local oReport
Local aArea := GetArea()

//-> Verifica as perguntas selecionadas.
APDR04X1()	
pergunte("APDR04",.F.)

oReport := ReportDef()
oReport:PrintDialog()	

RestArea( aArea )
	
Return

Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3	
Local oSection4


oReport:=TReport():New("APDR010",STR0001,"APD10R",{|oReport| PrintReport(oReport)},STR0024)	//"Resultado Global"#"Será impresso de acordo com os parametros solicitados pelo usuario"
Pergunte("APD10R",.F.) 
oReport:SetTotalInLine(.F.) //Totaliza em linha

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Primeira Secao: Avaliacao.
oSection1 := TRSection():New(oReport,STR0004,{"RDD","RD6","RD5","RD3","RDK"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Avaliacao"
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderBreak(.T.)  
oSection1:SetAutoSize()		  //Ajuste Automatico do Tamanho do Cabecalho da Secao

TRCell():New(oSection1,"RDD_CODAVA","RDD",STR0004)	//Codigo da Avaliacao
TRCell():New(oSection1,"RD6_DESC"  ,"RD6","",, 30)	//Descricao da Avaliacao
TRCell():New(oSection1,"RDD_CODTIP","RDD",STR0021)	//Codigo do Tipo da Avaliacao
TRCell():New(oSection1,"RD5_DESC"  ,"RD5","", ,30)	//Descricao do Tipo da Avaliacao
TRCell():New(oSection1,"RD6_CODMOD","RD6",STR0022)	//Codigo do Modelo de Avaliacao
TRCell():New(oSection1,"RD3_DESC"  ,"RD3","", ,30)	//Descricao do Modelo de Avaliacao  
TRCell():New(oSection1,"RD6_CODVIS","RD6",STR0006)	//Codigo da Visao Padrao
TRCell():New(oSection1,"RDK_DESC"  ,"RDK","", ,30) 	//Descricao da Visao Padrao
TRCell():New(oSection1,"RD6_DTINI" ,"RD6",STR0008)	//Data Inicio
TRCell():New(oSection1,"RD6_DTFIM" ,"RD6",STR0009)	//Data Fim

TRPosition():New(oSection1,"RD6",1,{|| xFilial("RD6") + RDD->RDD_CODAVA+RDD->RDD_CODTIP}) 
TRPosition():New(oSection1,"RD5",1,{|| xFilial("RD5") + RDD->RDD_CODTIP}) 
TRPosition():New(oSection1,"RD3",1,{|| xFilial("RD3") + RD6->RD6_CODMOD})
TRPosition():New(oSection1,"RDK",1,{|| xFilial("RDK") + RD6->RD6_CODVIS})

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Segunda Secao: Avaliado.
oSection2 := TRSection():New(oSection1,STR0011,{"RDD","RD9","RD0","RDN"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Avaliado"
oSection2:SetTotalInLine(.F.) 
oSection2:SetHeaderBreak(.T.)    
oSection2:SetLeftMargin(1)	//Identacao da Secao

TRCell():New(oSection2,"RD9_CODADO","RD9"        ) //Codigo do Avaliado 
TRCell():New(oSection2,"RD0_NOME"  ,"RD0",""     ) //Nome do Avaliado
TRCell():New(oSection2,"RDD_CODPRO","RDD",STR0010) //Codigo do Projeto
TRCell():New(oSection2,"RDN_DESC"  ,"RDN",""     ) //Descricao do Projeto
TRCell():New(oSection2,"RDN_DTIPRO","RDN"        ) //Data Inicio do Projeto    
TRCell():New(oSection2,"RDN_DTFPRO","RDN"        ) //Data Fim do Projeto     

TRPosition():New(oSection2,"RD9",1,{|| xFilial("RD9") + RDD->RDD_CODAVA+RDD->RDD_CODADO+RDD->(DTOS(RDD_DTIAVA)) })	
TRPosition():New(oSection2,"RD0",1,{|| xFilial("RD0") + RD9->RD9_CODADO})	
TRPosition():New(oSection2,"RDN",1,{|| xFilial("RDN") + RDD->RDD_CODPRO})

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Terceira Secao: Competencia.
oSection3 := TRSection():New(oSection2,STR0007,{"RDD","RDM"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Competencia"
oSection3:SetTotalInLine(.F.) 
oSection3:SetHeaderBreak(.T.)    
oSection3:SetLeftMargin(2)	//Identacao da Secao
  
TRCell():New(oSection3,"RDD_CODCOM","RDD"   ) //Codigo da Competencia
TRCell():New(oSection3,"RDM_DESC"  ,"RDM","") //Descricao da Competencia

TRPosition():New(oSection3,"RDM",1,{|| xFilial("RDM") + RDD->RDD_CODCOM})

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Quarta Secao: Item de Competencia.
oSection4 := TRSection():New(oSection3,STR0012,{"RDD","RD2","RD1","RBL"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Item de Competencia"	
oSection4:SetTotalInLine(.F.)  
oSection4:SetHeaderBreak(.T.)    
oSection4:SetLeftMargin(3)	//Identacao da Secao

TRCell():New(oSection4,"RDD_ITECOM","RDD"                                                            ) //Codigo do Item de Competencia
TRCell():New(oSection4,"RD2_DESC"  ,"RD2",""                                                         ) //Descricao do Item de Competencia 
TRCell():New(oSection4,"RDD_CODNET","RDD",STR0013                                                    ) //Codigo da Rede
TRCell():New(oSection4,"RD1_DESC"  ,"RD1","",,,,{|| If (RDD->RDD_TIPOAV = "3",STR0023,RD1->RD1_DESC)}) //Descricao da Rede
TRCell():New(oSection4,"RBL_VALOR" ,"RBL",STR0014,"@R 999.99",,,{|| Ap010Grau() }                    ) //Valor do Grau de Importancia (Impacto)
TRCell():New(oSection4,"VALOR1"    ,"RBL","Escala","@R 999.99",,,{|| VlrQuest() }                    ) //Escala      
TRCell():New(oSection4,"RDD_RESOBT","RDD","Grau de Orientacao"                                       ) //Resultado Obtido

TRPosition():New(oSection4,"RD2",1,{|| xFilial("RD2") + RDD->RDD_CODCOM+RDD->RDD_ITECOM})
TRPosition():New(oSection4,"RD1",1,{|| xFilial("RD1") + RDD->RDD_CODNET})


Return oReport


Static Function APDR04X1()             

Local aRegs		:= {} 
Local cPerg		:= "APDR04"  
Local aHelp		:= {}
Local cHelp		:= ""             
Local aHelpE	:= {}
Local aHelpI	:= {}   

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Aadd(aRegs,{cPerg	,"01"	,"Filial     ?"	  		,"¿Sucursal ?"     		,"Branch ?"				,"mv_ch1"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par01"	,""				,""				,""				,"RDD_FILIAL"			,""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"XM0",""    ,"S"  ,""      ,""      ,""     ,cHelp})

aHelp := {	"Informe intervalo de Filial que deseja considerar paraimpressao do relatorio." }
aHelpE:= {	"Informe intervalo de Rama que desea considerar para impresion del informe." }
aHelpI:= {	"Enter the Branch range to be considered to print report." }

cHelp := ".APDR0401."     

PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"02"	,"Avaliacao   ?"		,"¿Evaluacion ?"   		,"Evaluation ?"	 		,"mv_ch2"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par02"	,"" 	 	    ,""				,""				,"RDD_CODAVA"			,""		,""				,""				,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RD6"	,""   ,"S"	,aHelp  ,aHelpI   ,aHelpE  ,cHelp})

aHelp := {	"Informe intervalo de Avaliacao que deseja considerar para impressao do relatorio." }
aHelpE:= {	"Informe intervalo de Evaluacion que desea considerar para impresion del informe." }
aHelpI:= {	"Enter the Evaluation range to be considered to print report." }

cHelp := ".APDR0402."     

PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"03"	,"Avaliado   ?"  		,"¿Evaluado ?"     		,"Evaluated ?"			,"mv_ch3"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par03"	,"" 	 	    ,""				,""				,"RDD_CODADO"			,""		,""				,""				,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RD0"	,""   ,"S"	,aHelp  ,aHelpI   ,aHelpE  ,cHelp})

aHelp := {	"Informe intervalo de Avaliado que deseja considerar para impressao do relatorio." }
aHelpE:= {	"Informe intervalo del Medido que desea considerar para impresion del informe." }
aHelpI:= {	"Enter the Measured range to be considered to print report." }

cHelp := ".APDR0403."     

PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"04"	,"Projeto   ?"  		,"¿Diseno ?"     		,"Project ?"			,"mv_ch4"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par04"	,"" 	 	    ,""				,""				,"RDD_CODPRO"			,""		,""				,""				,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RDN"	,""   ,"S"	,aHelp  ,aHelpI   ,aHelpE  ,cHelp})

aHelp := {	"Informe intervalo do Projeto que deseja considerar para impressao do relatorio." }
aHelpE:= {	"Informe intervalo del Diseno que desea considerar para impresion del informe." }
aHelpI:= {	"Enter the Project range to be considered to print report." }

cHelp := ".APDR0404."     

PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"05"	,"Competencia   ?"	,"¿Competencia ?"		,"Competence ?"			,"mv_ch5"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par05"	 ,"" 	 	     ,""			,""				,"RDD_CODCOM"	,""		,""		,""				  ,""	 ,""	,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""     ,""		,""		 ,""	,""	 ,"RDM"	 ,""   ,"S"	,aHelp  ,aHelpI   ,aHelpE  ,cHelp})
                                                                                                                                                                                                                                                                                          
aHelp := {	"Informe intervalo de Competencia que deseja considerar para impressao do relatorio." }
aHelpE:= {	"Informe intervalo de Atribucion que desea considerar para impresion del informe." }
aHelpI:= {	"Enter the Competence Iten range to be considered to print report." }

cHelp := ".APDR0405."     

PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//³          Grupo  Ordem 	Pergunta Portugues      Pergunta Espanhol        Pergunta Ingles     Variavel 	Tipo  	Tamanho  Decimal  Presel     GSC   	 Valid       Var01       Def01           DefSPA1        DefEng1      	Cnt01            Var02  Def02   DefSpa2  DefEng2  Cnt02  Var03 	Def03   DefSpa3    	DefEng3  	Cnt03  	Var04  	Def04   DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05   DefSpa5	DefEng5  Cnt05  XF3  GrgSxg  cPyme	aHelpPor aHelpEng	aHelpSpa    cHelp            ³
Aadd(aRegs,{cPerg	,"06"	,"Somente Consenso ?"	,"¿Unico Consenso ?"	,"Only Consensus ?"	,"mv_ch6"  	,"C"	,01			,0		,2		,"C"	,"NaoVazio"	,"mv_par06"	 ,"Sim" 	 	 ,"Si"			,"Yes"			,"RDD_CODCOM"	 ,""	,"Nao"	,"No"	 ,"Not"	  ,""	 ,""	,""		,""			,""			,""		,""		,""		,""			,""			,""		,""     ,""		,""		,""		 ,""	,""	 ,""     ,"S"	,aHelp   ,aHelpI   ,aHelpE     ,cHelp})

aHelp := {	"Informe se deseja visualizar apenas avaliações com consenso." }
aHelpE:= {	"Indique si desea ver solo comentarios con el consenso." }
aHelpI:= {	"Indicate whether you want to view only reviews with consensus." }

cHelp := ".APDR0406."     

PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ValidPerg(aRegs,cPerg)

Return Nil
