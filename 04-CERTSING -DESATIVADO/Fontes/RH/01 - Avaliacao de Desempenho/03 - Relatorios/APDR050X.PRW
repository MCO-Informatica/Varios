#include "Protheus.ch"
#include "APDR050.CH"

/*+---------------------------------------------------------------------------------------------------------------------+
  | Função .: APDR050x() | Adaptacao do programa original APDR050 para emissao do Relatorio de Pendencia de Avaliacoes  |
  +----------------------+----------------------------------------------------------------------------------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN                                                                              |
  +---------------------------------------------------------------------------------------------------------------------+
*/
User Function APDR050x()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	//-> Verifica as perguntas selecionadas
	Pergunte("APD50R",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	u_APDR05R3()	
EndIf  

RestArea( aArea )

Return Nil

/*+----------------------------------------------------------------------------+
  | Função .: ReportDef()| Definicao do Componente de Impressao do Relatorio.  |
  +----------------------+-----------------------------------------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN                                     |
  +----------------------------------------------------------------------------+
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2   

#IFNDEF TOP                 
	Local cAliasQry := "RDC"
#ELSE	
	Local cAliasQry := GetNextAlias()
#ENDIF 	

/*
Criacao do componente de impressao                                      
TReport():New                                                           
ExpC1 : Nome do relatorio                                               
ExpC2 : Titulo                                                          
ExpC3 : Pergunte                                                        
ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  
ExpC5 : Descricao                                                       
*/

oReport:=TReport():New("APDR050",STR0001,"APD50R",{|oReport| PrintReport(oReport,cAliasQry)},STR0002+" "+STR0003)	//"Relatorio de Status de Avaliacoes"#"Será impresso de acordo com os parametros solicitados pelo usuario"
oReport:SetTotalInLine(.F.) 
Pergunte("APD50R",.F.)

/*
Criacao da celulas da secao do relatorio                                ³
TRCell():New                                                            ³
ExpO1 : Objeto TSection que a secao pertence                            ³
ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
ExpC3 : Nome da tabela de referencia da celula                          ³
ExpC4 : Titulo da celula                                                ³
        Default : X3Titulo()                                            ³
ExpC5 : Picture                                                         ³
        Default : X3_PICTURE                                            ³
ExpC6 : Tamanho                                                         ³
        Default : X3_TAMANHO                                            ³
ExpL7 : Informe se o tamanho esta em pixel                              ³
        Default : False                                                 ³
ExpB8 : Bloco de código para impressao.                                 ³
        Default : ExpC2                                                 ³

*/

//-------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Primeira Secao
oSection1 := TRSection():New(oReport,STR0006,{"RDC","RD6"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)		//Avaliacao
oSection1:SetTotalInLine(.F.) 
oSection1:SetHeaderBreak(.T.)  

TRCell():New(oSection1,"RDC_CODAVA","RDC")				//Avaliacao
TRCell():New(oSection1,"RD6_DESC","RD6","")			    //Descricao da Avaliacao 
TRCell():New(oSection1,"RDC_DTIAVA","RDC",STR0018)		//Data Inicio da Avaliacao

#IFNDEF TOP    
	TRPosition():New(oSection1,"RD6",1,{|| RhFilial("RD6",RDC->RDC_FILIAL) + RDC->RDC_CODAVA}) 
#ENDIF     

//-------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Segunda Secao:
oSection2 := TRSection():New(oSection1,STR0025,{"RDC","RD0"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//Avaliados	
oSection2:SetTotalInLine(.F.) 
oSection2:SetHeaderBreak(.T.)  
oSection2:SetLeftMargin(2)	//Identacao da Secao

TRCell():New(oSection2,"RDC_CODADO","RDC")				//Codigo da Avaliado
TRCell():New(oSection2,"RD0_NOME","RD0","")			    //Nome do Avaliado 
TRCell():New(oSection2,"RDC_CODDOR","RDC")				//Codigo da Avaliador
TRCell():New(oSection2,"RD0_NOME","RD0","",,,,{|| Fdesc("RD0",(cAliasQry)->RDC_CODDOR,"RD0_NOME",30) })	//Nome do Avaliador
TRCell():New(oSection2,"RDC_TIPOAV","RDC",STR0016)		//Tipo Avaliador
TRCell():New(oSection2,"RDC_DATENV","RDC",STR0019)		//Data de Envio 
TRCell():New(oSection2,"RDC_DATRET","RDC",STR0020)		//Data de Resposta
TRCell():New(oSection2,"RDC_DTLIMR","RDC",STR0021)	   	//Data Limite 
TRCell():New(oSection2,"ATRASO"	,"   ",STR0022,,10,,{|| Ap50rAtraso(cAliasQry) })  	//Dias Atraso
TRCell():New(oSection2,"TRANSACAO"	,"   ",STR0023,,,,{|| Ap50rTransa(cAliasQry) })	//Transacao
TRCell():New(oSection2,"STATUS"	,"   ",STR0024,,7,,{||  Ap50rStatus(cAliasQry) }) 		//Status

#IFNDEF TOP   
	TRPosition():New(oSection2,"RD0",1,{|| RhFilial("RD0",RDC->RDC_FILIAL) + RDC->RDC_CODADO}) 
#ENDIF 
//-------------------------------------------------------------------------------------------------------------------------------------------
       
Return oReport


/*+---------------------------------------------------+
  | Função .: PrintReport()| Impressao do Relatorio.  |
  +----------------------+----------------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN            |
  +---------------------------------------------------+*/
Static Function PrintReport(oReport,cAliasQry)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  

#IFDEF TOP
	Local lQuery    := .F. 
	Local cWhere	:= ""
	Local i := 0
	Local cSitQuery := ""
	Local cOrder	:= ""
	Local cFilRD6 	:= ""  
	Local cFilRD0 	:= ""  
#ELSE
	Local cFiltro   := ""
#ENDIF

/*
Variaveis utilizadas para parametros                                          
mv_par01        //  Filial?                                                  
mv_par02        //  Avaliacao ?                                               
mv_par03        //  Data de Inicio?                                           
mv_par04        //  Avaliado?                                                 
mv_par05        //  Tipo Avaliador? 1-Avaliador; 2-Auto Avaliação; 3-Consenso 
mv_par06        //  Transacao? 1-Pendente; 2-Enviado; 3-Retornado             
mv_par07        //  Status? 1-Aberto; 2-Fehcado                               
*/

#IFNDEF TOP

	//-> Transforma parametros Range em expressao (intervalo) 
	MakeAdvplExpr("APD50R")	                                  
	
	If !Empty(mv_par01)	//RDC_FILIAL
		cFiltro:= mv_par01 
	EndIf  
	
	If !Empty(mv_par02)	//RDC_CODAVA
		cFiltro += Iif(!Empty(cFiltro)," .And. ","")
		cFiltro += mv_par02 
	EndIf  
	
	If !Empty(mv_par03) //RDC_DTIAVA
		cFiltro += Iif(!Empty(cFiltro)," .And. ","")
		cFiltro += mv_par03
	EndIf
	
	If !Empty(mv_par04) //RDC_CODDOR 
		cFiltro += Iif(!Empty(cFiltro)," .And. ","")
		cFiltro += mv_par04 
	EndIf              
	
	If !Empty(cFiltro) 
		cFiltro += '.And. RDC_TIPOAV $ "' + mv_par05 + '" .And. RDC_TIPO $ "' + mv_par06 + '"'
	Else
		cFiltro += 'RDC_TIPOAV $ "' + mv_par05 + '" .And. RDC_TIPO $ "' + mv_par06 + '"'   
	EndIf	             
	
	oSection1:SetFilter(cFiltro)      

	oSection2:SetLineCondition({|| If(Empty(RDC_DATRET),"1" $ mv_par07,"2" $ mv_par07) })	//Status da Avaliacao

	oSection2:SetParentFilter({|cParam| RDC->RDC_CODAVA == cParam},{|| RDC->RDC_CODAVA})	
                             
	oReport:SetMeter(RDC->(LastRec()))	
	
	oSection1:Print() //Imprimir  
	
#ELSE	

	//-> Transforma parametros Range em expressao SQL 
	MakeSqlExpr("APD50R")    
	
	//-- Filtragem do relatório
	//-- Query do relatório da secao 1
	lQuery := .T.         
	cOrder := "%RDC_FILIAL,RDC_CODAVA,RDC_CODADO%"	

	//-> Tipo Avaliador 
	mv_par05 := Alltrim(mv_par05)	
	For i:= 1 to Len(mv_par05)
		cSitQuery += "'"+Subs(mv_par05,i,1)+"'"
		If ( i+1 ) <= Len(mv_par05)
			cSitQuery += "," 
		Endif
	Next i    
	
	If !Empty(cSitQuery)
		cSitQuery := "RDC.RDC_TIPOAV IN (" + cSitQuery + ")"
	Else
		cSitQuery := "RDC.RDC_TIPOAV <>''"
	EndIf
	cSitQuery := "%" + cSitQuery + "%"    
	  
	i:= 0

	//-> Transacao 
	mv_par06 := Alltrim(mv_par06)
	For i:= 1 to Len(mv_par06)
	cWhere += "'"+Subs(mv_par06,i,1)+"'"
	If ( i+1 ) <= Len(mv_par06)
		cWhere += "," 
	Endif
	Next i 
	
	If !Empty(cWhere)
		cWhere := "RDC.RDC_TIPO IN (" + cWhere + ")"
	ELSE
		cWhere := "RDC.RDC_TIPO <> ''"
	EndIf
	cWhere	:= "%" + cWhere + "%" 	
		
	oReport:Section(1):BeginQuery()	

	cFilRD6 := If (RD6->(xFilial()) == Space(FWGETTAMFILIAL),"%AND RD6.RD6_FILIAL = '" + Space(FWGETTAMFILIAL) +"'%","%AND RD6.RD6_FILIAL = RDC.RDC_FILIAL%")
	cFilRD0 := If (RD0->(xFilial()) == Space(FWGETTAMFILIAL),"%AND RD0.RD0_FILIAL = '" + Space(FWGETTAMFILIAL) +"'%","%AND RD0.RD0_FILIAL = RDC.RDC_FILIAL%")
	
	BeginSql Alias cAliasQry
			
		SELECT	RDC.RDC_CODAVA,;
		        (SELECT RD6_DESC FROM %table:RD6% RD6 
		         WHERE RD6.RD6_FILIAL = %xFilial:RD6%
			       AND RD6.RD6_CODIGO = RDC.RDC_CODAVA
			       AND RD6.%NotDel%
			       %exp:cFilRD6%) RD6_DESC,; 
		        RDC.RDC_DTIAVA,;
		        RDC.RDC_CODADO,;
		        RDC.RDC_CODDOR,;
		        (SELECT RD0_NOME FROM %table:RD0% RD0 
                 WHERE RD0.RD0_FILIAL = %xFilial:RD0%
                   AND RD0.RD0_CODIGO = RDC.RDC_CODADO
                   AND RD0.%NotDel%   
                   %exp:cFilRD0%) RD0_NOME,;
		        RDC.RDC_TIPOAV,;
		        RDC.RDC_DATENV,;
		        RDC.RDC_DATRET,;
		        RDC.RDC_DTLIMR,;
		        RDC.RDC_TIPO
				
		FROM 	%table:RDC% RDC  

		WHERE 
			%exp:Upper(cSitQuery)% AND
			%exp:Upper(cWhere)% AND
			RDC.%NotDel%   													
		ORDER BY %Exp:cOrder%                 		
		
	EndSql
	
    /*+---------------------------------------------------+
      | Metodo EndQuery ( Classe TRSection )              |
      | Prepara o relatório para executar o Embedded SQL. |
      | ExpA1 : Array com os parametros do tipo Range     |
      +---------------------------------------------------+*/
    
    If !Empty(mv_par01)	//RDC_FILIAL
       mv_par01 := If( SX2->(dbSeek("RDC") ) .And. SX2->X2_MODO = "E", &mv_par01, "(RDC_FILIAL IN('  '))" )
    EndIf

	oReport:Section(1):EndQuery({mv_par01,mv_par02,mv_par03,mv_par04})	/*Array com os parametros do tipo Range*/

	//-> Inicio da impressao do fluxo do relatório 
 	oReport:SetMeter(RDC->(LastRec()))

	//-> Utiliza a query do Pai  
	oSection2:SetParentQuery()
	
	//-> Condicao para Impressao   
	oSection2:SetParentFilter( { |cParam| (cAliasQry)->RDC_CODAVA == cParam },{ || (cAliasQry)->RDC_CODAVA })
	oSection2:SetLineCondition({|| If(Empty(RDC_DATRET),"1" $ mv_par07,"2" $ mv_par07) })	//Status da Avaliacao
	
	oSection1:Print()	 //Imprimir
#ENDIF

Return Nil

/*+-------------------------------------------+
  | Função .: Ap50rAtraso()| Dias de Atraso.  |
  +----------------------+--------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN    |
  +-------------------------------------------+*/
Static Function Ap50rAtraso(cAliasQry)

Local nAtraso 	:= 0
Local cSvAlias 	:= Alias()  

If !Empty( (cAliasQry)->RDC_DTLIMR )
	If Empty( (cAliasQry)->RDC_DATRET)
		nAtraso := If(dDataBase > (cAliasQry)->RDC_DTLIMR, dDataBase - (cAliasQry)->RDC_DTLIMR, 0)
	Else
		nAtraso	:= If( (cAliasQry)->RDC_DATRET > (cAliasQry)->RDC_DTLIMR, (cAliasQry)->RDC_DATRET - (cAliasQry)->RDC_DTLIMR, 0)
	EndIf
EndIf

DbSelectArea(cSvAlias)

Return nAtraso

/*+----------------------------------------+
  | Função .: Ap50rTransa()| Transacao.    |
  +----------------------+-----------------+
  | Autor.: Alexandre A. Silva - CERTISIGN |
  +----------------------------------------+*/
Static Function Ap50rTransa(cAliasQry)


Local cTransac := Space(15)
Local cSvAlias 	:= Alias()

If (cAliasQry)->RDC_TIPO == "1"
	cTransac := STR0011+Space(15-Len(STR0011))	//"Pendente"	
ElseIf (cAliasQry)->RDC_TIPO == "2"
	cTransac := STR0012+Space(15-Len(STR0012))	//"Enviado"		
ElseIf (cAliasQry)->RDC_TIPO == "3"
	cTransac := STR0013+Space(15-Len(STR0013))	//"Retornado"		
EndIf 

DbSelectArea(cSvAlias)

Return cTransac
	
/*+-----------------------------------------------+
  | Função .: Ap50rStatus()| Status da Avaliacao. |
  +----------------------+------------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN        |
  +-----------------------------------------------+*/
Static Function Ap50rStatus(cAliasQry)

Local cStatus := Space(15)
Local cSvAlias 	:= Alias()

If Empty( (cAliasQry)->RDC_DATRET )
	cStatus := STR0014+Space(15-Len(STR0014))	//"Aberto"		
Else
	cStatus := STR0015+Space(15-Len(STR0015))	//"Fechado"
EndIf

DbSelectArea(cSvAlias)

Return cStatus
	
/*+--------------------------------------------+
  | Função .: APDR05R3()| Status da Avaliacao. |
  +----------------------+---------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN     |
  +--------------------------------------------+*/
User Function APDR05R3()

Local cDesc1	:= STR0001 //"Relatorio de Status de Avaliacoes"
Local cDesc2	:= STR0002 //"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  	:= STR0003 //"usu rio."
Local cString 	:= "RDC"  			             		//-- alias do arquivo principal (Base)

//-> Define Variaveis (Basicas)                                   
Private aReturn  := { STR0004,1,STR0005,2,2,1,"",1 } //"Zebrado"###"Administra‡„o"
Private NomeProg := "APDR050"
Private nLastKey := 0
Private cPerg    := "APDR50"
Private lEnd     := .F.
Private wCabec0  := 1
Private wCabec1  := STR0007	//" Avaliado                               Avaliador                              Tipo Avaliador     Data Envio  Dt.Resposta Data Limite Dias/Atraso Transacao        Status"
Private wCabec2  := ""
Private wCabec3  := ""
Private Colunas  := 220
Private at_Prg   := "APDR050"
Private Contfl   := 1
Private Li       := 0
Private nPag     := 0
Private nTamanho := "G"
Private nChar	 := 15
Private cTit     := STR0001 //"Relatorio de Status de Avaliacoes"

//-> Verifica as perguntas selecionadas                           
pergunte("APDR50",.F.)

Titulo  := STR0001	//"Relatorio de Status de Avaliacoes"


/*
Variaveis utilizadas para parametros                         
mv_par01        //  Filial  De                               
mv_par02        //  Filial  Ate                              
mv_par03        //  Avaliacao De                             
mv_par04        //  Avaliacao Ate                            
mv_par05        //  Data Inicio De	                       	 
mv_par06        //  Data Inicio Ate	                         
mv_par07        //  Avaliado De		                         
mv_par08        //  Avaliado Ate		                     
mv_par09        //  Tipo Avaliador 		                     
mv_par10        //  Transacao                              	 
mv_par11        //  Status                               	 
*/

//-> Envia controle para a funcao SETPRINT                        
WnRel :="APDR050"	//-- Nome Default do relatorio em Disco.
WnRel :=SetPrint(cString,WnRel,cPerg,@cTit,cDesc1,cDesc2,cDesc3,.F.,,.F., nTamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Apd05Rlt(@lEnd,wnRel,cString)},cTit)

Return Nil

/*+-----------------------------------------------------------------+
  | Função .: Apd05Rlt() | Funcao principal do Relatorio de Cursos. |
  +----------------------+------------------------------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN                          |
  +-----------------------------------------------------------------+*/
Static Function Apd05Rlt()

Local cFil		:= ""
Local cAcessaRDC:= &("{ || " + ChkRH(FunName(),"RDC","2") + "}")
Local cAvaliacao:= ""
Local lFirst 	:= .T.
Local cDuracao  := "" 
Local cHoras    := ""

dbSelectArea("RDC")
dbSetOrder(1)
cFil := Iif(xFilial("RDC") == Space(FWGETTAMFILIAL), Space(FWGETTAMFILIAL), mv_par01)
dbSeek(cFil+mv_par03+mv_par07,.T.) 										// Filial + Avaliacao + Avaliado
While !Eof() .And. RDC->RDC_CODAVA <= mv_par04							//Avaliacao
	
	If !Eval(cAcessaRDC)
		dbSkip()
		Loop
	EndIf
	
	If 	(RDC->RDC_FILIAL > mv_par02) .Or.;							//Filial
		(RDC->RDC_CODADO < mv_par07) .Or.;							//Avaliado
		(RDC->RDC_CODADO > mv_par08) .Or.;							//Avaliado
		( !(RDC->RDC_TIPOAV $ mv_par09) ) .Or.;					//Tipo Avaliador
		( !(RDC->RDC_TIPO $ mv_par10) ) .Or.;						//Transacao
		(Dtos(RDC->RDC_DTIAVA) 	< Dtos(mv_par05) ) .Or. (Dtos(RDC->RDC_DTIAVA) > Dtos(mv_par06) ) //Dt.Ini
		dbSkip()
		Loop
	EndIf

	//Salta parametro "Em Aberto"
	If EMPTY(RDC->RDC_DATRET) .And. !"1" $ mv_par11 //EM ABERTO NAO CONSTA NO PARAMETRO
		dbSkip()
		Loop
	EndIf

	//Salta parametro "Fechado"
	If !EMPTY(RDC->RDC_DATRET) .And. !"2" $ mv_par11 //FECHADO NAO CONSTA NO PARAMETRO
		dbSkip()
		Loop
	EndIf
	
	// Avaliacao
	If cAvaliacao != RDC->RDC_CODAVA
		If lFirst
			lFirst := .F.
		Else
			IMPR(__PrtThinLine(),"C")
		EndIf
		
		DET := STR0006 + ": " + RDC->RDC_CODAVA+" - "+FDesc("RD6",RDC->RDC_CODAVA,"RD6->RD6_DESC") 	//"Avaliacao: "  
		IMPR(DET,"C")
		DET := STR0018+": "+Dtoc(RDC->RDC_DTIAVA) 												//"Dt.Inicio: "
		IMPR(DET,"C")
		IMPR("","C")
		cAvaliacao := RDC->RDC_CODAVA
	EndIf
	
	//Tipo Avaliador 
	cTipoAval 	:= Space(15)
	If RDC->RDC_TIPOAV == "1"
		cTipoAval 	:= STR0009+Space(15-Len(STR0009))	//"Avaliador"
		
	ElseIf RDC->RDC_TIPOAV == "2"
		cTipoAval 	:= STR0008+Space(15-Len(STR0008))	//"Auto-Avaliacao"		
		
	ElseIf RDC->RDC_TIPOAV == "3"
		cTipoAval 	:= STR0010+Space(15-Len(STR0010))	//"Consenso"
		
	EndIf
   
	// Dias Atraso
	nAtraso 	:= 0	
	If !Empty(RDC->RDC_DTLIMR)
		If Empty(RDC->RDC_DATRET)
			nAtraso := If(dDataBase > RDC->RDC_DTLIMR, dDataBase - RDC->RDC_DTLIMR, 0)
		Else
			nAtraso	:= If(RDC->RDC_DATRET > RDC->RDC_DTLIMR, RDC->RDC_DATRET - RDC->RDC_DTLIMR, 0)
		EndIf
	EndIf
	
	
	//Transacao
	cTransac := Space(15)
	If RDC->RDC_TIPO == "1"
		cTransac := STR0011+Space(15-Len(STR0011))	//"Pendente"
		
	ElseIf RDC->RDC_TIPO == "2"
		cTransac := STR0012+Space(15-Len(STR0012))	//"Enviado"
		
	ElseIf RDC->RDC_TIPO == "3"
		cTransac := STR0013+Space(15-Len(STR0013))	//"Retornado"
		
	EndIf
	
	//Status
	cStatus := Space(15)
	If EMPTY(RDC->RDC_DATRET)
		cStatus := STR0014+Space(15-Len(STR0014))	//"Aberto"
		
	Else
		cStatus := STR0015+Space(15-Len(STR0015))	//"Fechado"
		
	EndIf
	
	//" Avaliado                               Avaliador                              Tipo Avaliador     Data Envio  Dt.Resposta Data Limite Dias/Atraso Transacao        Status"
	DET := Space(1)+RDC->RDC_CODADO+"-"+Fdesc("RD0",RDC_CODADO,"RD0_NOME",30)+Space(2)
	DET += RDC->RDC_CODDOR+"-"+Fdesc("RD0",RDC_CODDOR,"RD0_NOME",30)+Space(2)
	DET += RDC->RDC_TIPOAV+"-"+cTipoAval+Space(2)
	DET += If(__SetCentury(),Dtoc(RDC->RDC_DATENV),Dtoc(RDC->RDC_DATENV)+Space(2)) +Space(2)
	DET += If(__SetCentury(),Dtoc(RDC->RDC_DATRET),Dtoc(RDC->RDC_DATRET)+Space(2)) +Space(2)
	DET += If(__SetCentury(),Dtoc(RDC->RDC_DTLIMR),Dtoc(RDC->RDC_DTLIMR)+Space(2)) +Space(2)
	DET += Str(nAtraso,10,0)+Space(2)
	DET += cTransac+Space(2)
	DET += cStatus
	
	IMPR(DET,"C")
	
	
	dbSelectArea("RDC")
	dbSkip()
EndDo

//-> Termino do Relatorio                                         
IMPR(__PrtThinLine(),"C")       
IMPR("","F")

dbSelectArea("RDC") 
dbSetOrder(1)

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil


/*+---------------------------------------------------------+
  | Função .: ApdTipoAv() | Selecionar Tipo de Avaliadores. |
  +-----------------------+---------------------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN                  |
  +---------------------------------------------------------+*/
Static Function ApdTipoAv(l1Elem)

Local cTitulo	:= ""
Local MvPar		:= ""
Local MvParDef	:= ""
Local oWnd

Local aTipo	:= {}
l1Elem := If (l1Elem = Nil , .F. , .T.)

oWnd := GetWndDefault()

cAlias 	:= Alias() 					 // Salva Alias Anterior
MvPar	:= &(Alltrim(ReadVar()))	 // Carrega Nome da Variavel do Get em Questao
mvRet	:= Alltrim(ReadVar())		 // Iguala Nome da Variavel ao Nome variavel de Retorno

aTipo:={STR0009, STR0008, STR0010}	//"Avaliador", "Auto-Avaliacao" , "Consenso"
MvParDef:="123"
cTitulo := STR0016	//"Tipo Avaliador"

f_Opcoes(@MvPar,cTitulo,aTipo,MvParDef,12,49,l1Elem) 	// Chama funcao f_Opcoes
&MvRet := mvpar										 	// Devolve Resultado
dbSelectArea(cAlias) 								 	// Retorna Alias

If oWnd != Nil
	GetdRefresh()
Endif

Return .T.

/*+---------------------------------------------------------+
  | Função .: ApdTransa() | Selecionar Tipo de Avaliadores. |
  +-----------------------+---------------------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN                  |
  +---------------------------------------------------------+*/
Static Function ApdTransa(l1Elem)

Local cTitulo	:= ""
Local MvPar		:= ""
Local MvParDef	:= ""
Local oWnd

Local aTipo	:= {}
l1Elem := If (l1Elem = Nil , .F. , .T.)

oWnd := GetWndDefault()

cAlias 	:= Alias() 					// Salva Alias Anterior
MvPar	:= &(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
mvRet	:= Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno
     
aTipo	:= {	STR0011,;			//"Pendente"
				STR0012,;			//"Enviado"
				STR0013}			//"Retornado"

MvParDef:= "123"
cTitulo := STR0017	//"Status da Avaliacao"

f_Opcoes(@MvPar,cTitulo,aTipo,MvParDef,12,49,l1Elem) 	// Chama funcao f_Opcoes
&MvRet := mvpar										 	// Devolve Resultado
dbSelectArea(cAlias) 								 	// Retorna Alias

If oWnd != Nil
	GetdRefresh()
Endif

Return .T.


/*+-----------------------------------------------------------+
  | Função .: ApdStatus() | Selecionar Status de Avaliadores. |
  +-----------------------+-----------------------------------+
  | Autor.: Alexandre A. Silva - CERTISIGN                    |
  +-----------------------------------------------------------+*/
Static Function ApdStatus(l1Elem)

Local cTitulo	:= ""
Local MvPar		:= ""
Local MvParDef	:= ""
Local oWnd

Local aTipo	:= {}
l1Elem := If (l1Elem = Nil , .F. , .T.)

oWnd := GetWndDefault()

cAlias 	:= Alias() 					// Salva Alias Anterior
MvPar	:= &(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
mvRet	:= Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno
     
aTipo	:= {	STR0014,;			//"Aberto"
				STR0015}			//"Fechado"  
		
MvParDef:= "123"
cTitulo := STR0017	//"Status da Avaliacao"

f_Opcoes(@MvPar,cTitulo,aTipo,MvParDef,12,49,l1Elem) 	// Chama funcao f_Opcoes
&MvRet := mvpar										 	// Devolve Resultado
dbSelectArea(cAlias) 								 	// Retorna Alias

If oWnd != Nil
	GetdRefresh()
Endif

Return .T.