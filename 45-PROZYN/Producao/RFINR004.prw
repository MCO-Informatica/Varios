#Include "Rwmake.ch"             
#Include "Protheus.ch"             
#Include "topconn.ch"                                                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFINR004  บAutor  ณIsaque O Silva	     บ Data ณ  21/12/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio Saldos financeiros				   				 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Protheus 11   - Prozyn                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFINR004()

oFont2     := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
oFont4     := TFont():New( "Courier New",,08,,.f.,,,,,.f. ) 
                                                                
Private oDlg
Private aCA       :={OemToAnsi("Confirma"),OemToAnsi("Abandona")} // "Confirma", "Abandona"
Private cCadastro := OemToAnsi("Imprime Saldos Financeiro")
Private aSays:={}, aButtons:={}
Private nOpca     := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis tipo Private padrao de todos os relatorios         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aReturn    := {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 } // ###
Private nLastKey   := 0
Private cPerg      := "RFINR004" 

ValidPerg()

Pergunte(cPerg,.F.)

//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AADD(aSays,OemToAnsi( "  Este programa ira imprimir o Relat Saldos Financeiro "))
AADD(aSays,OemToAnsi( "obedecendo os parametros escolhidos pelo cliente."))

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
If nOpca == 1
	Processa( { |lEnd| Imprel() })
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMREL     บAutor  ณHigor Emanuel              ณ  06/02/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao da Ficha de Ativo - Sitetico                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso                                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Imprel()

Local nHeight:=15
Local lBold:= .F.
Local lUnderLine:= .F.
Local lPixel:= .T.
Local lPrint:=.F.	
Local nPag:=0
Local nLin:= 0

Local _x
Private _nItens:=0 
Private lContinua 	:= .T.
Private oExcel    	:= FWMSEXCEL():New()  
Private _cTitulo1 	:= "Saldos Financeiro com Data referencia : "+DTOC(MV_PAR01)
Private _cSheet1  	:= "Saldos" 
Private _cFile 
Private _nCole    	:= 0 
Private _aCol     	:= {}  
Private _aCol1     	:= {}  
Private _cAlias0	:= "SE8T"
Private _cAlias1	:= "SE5T"
Private _cAlias2	:= "SE1T"
Private _cAlias3	:= "SE1T1" 
Private _dData 		:= ""
Private aDados		:={}
private _cTipo
Private _nSldSE8	:=0
Private _nSldInv	:=0
Private _nTSld		:=0
Private _cNomeBco	:=""
Private _cAgencia	:=""		
Private _cConta		:=""		
Private _cBanco		:=""		
Private _nEntrN		:=0		
Private _nTEntrN	:=0		
Private _nEntrE		:=0		
Private _nTEntrE	:=0		
Private _nEntrO		:=0	
Private _nTEntrO	:=0	
Private _nEntrBl	:=0
Private _nCobrN		:=0		
Private _nTCobrN	:=0		
Private _nCobrE		:=0		
Private _nTCobrE	:=0		
Private _nCobrO		:=0	
Private _nTCobrO	:=0	
Private _ntAVencN	:=0		
Private _nAVencN	:=0		
Private _nAVencE	:=0		
Private _nTAVencE	:=0		
Private _nAVencO	:=0	
Private _nTAVencO	:=0	

// Descri็ใo de campos 	
nHeight    := 15
lBold      := .F.
lUnderLine := .F.
lPixel     := .T.
lPrint     := .F.
nSedex     := 1

// crio uma tabela temporaria

_aStru1 := {}    
AADD(_aStru1,{"TM_FILIAL" 		,"C",02,0})
AADD(_aStru1,{"TM_INVEST"	   	,"C",01,0})
AADD(_aStru1,{"TM_AGENC"	   	,"C",05,0})
AADD(_aStru1,{"TM_BANCO"	   	,"C",03,0})
AADD(_aStru1,{"TM_CONTA"	   	,"C",10,0})
AADD(_aStru1,{"TM_NOMEBCO" 		,"C",40,0}) 
AADD(_aStru1,{"TM_SALDO"   		,"N",16,2})
AADD(_aStru1,{"TM_ENTRN	"   	,"N",16,2})
AADD(_aStru1,{"TM_ENTRE	"   	,"N",16,2})
AADD(_aStru1,{"TM_ENTRO	"   	,"N",16,2})
AADD(_aStru1,{"TM_ENTRBL"   	,"N",16,2})
AADD(_aStru1,{"TM_COBRN"	    ,"N",16,2})
AADD(_aStru1,{"TM_COBRE"	   	,"N",16,2})
AADD(_aStru1,{"TM_COBRO"     	,"N",16,2})
AADD(_aStru1,{"TM_VENCERN"     	,"N",16,2})
AADD(_aStru1,{"TM_VENCERE"     	,"N",16,2})
AADD(_aStru1,{"TM_VENCERO"     	,"N",16,2})

_cArq2 := CriaTRAb(_aStru1,.T.)                  
dbUseArea(.T.,,_cArq2,"TRM",.F.,.F.)
IndRegua("TRM",_cArq2,"TM_BANCO+TM_AGENC+TM_CONTA",,,"Criando Arquivo Temporario")

   
// Busco os bancos com fluxo de caixa flagado 
cQuery0 := "Select (IIF(SA6.A6_NOME LIKE '%APLIC%','S','N')) AS [INVESTIMENTO], SA6.A6_NOME, SE8.E8_BANCO, SE8.E8_AGENCIA, SE8.E8_CONTA, MAX(SE8.E8_DTSALAT) AS DATA_ATU FROM " +RetSqlName("SE8") + " SE8 "
cQuery0 += " INNER JOIN " +RetSqlName("SA6") + " SA6  ON SA6.A6_COD = SE8.E8_BANCO "
cQuery0 += " AND SA6.A6_AGENCIA = SE8.E8_AGENCIA "
cQuery0 += " AND SA6.A6_FLUXCAI ='S' "
cQuery0 += " AND SA6.A6_BLOCKED='2' "
cQuery0 += " AND SE8.E8_DTSALAT <='" + DTOS(MV_PAR01) + "'"
cQuery0 += " AND SE8.D_E_L_E_T_='' "
cQuery0 += " GROUP BY SE8.E8_BANCO,SE8.E8_AGENCIA, SE8.E8_CONTA, SA6.A6_NOME"
cQuery0 += " ORDER BY INVESTIMENTO,SE8.E8_BANCO, SE8.E8_AGENCIA, SE8.E8_CONTA, DATA_ATU "


cQuery0 := ChangeQuery(cQuery0)  // padroniza com o banco existente ChangeQuery
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery0),_cAlias0,.T.,.F.)	

DbSelectArea(_cAlias0)
While !eof()
	
	_cNomeBco := POSICIONE("SA6", 1, xFilial("SA6") +(_cAlias0)->E8_BANCO+(_cAlias0)->E8_AGENCIA+(_cAlias0)->E8_CONTA,"A6_NOME")
	_cTipo		:=(_cAlias0)->INVESTIMENTO

	dbSelectArea("SE8")
	dbSetOrder(1)
	dbSeek(xFilial("SE8")+(_cAlias0)->E8_BANCO+(_cAlias0)->E8_AGENCIA+(_cAlias0)->E8_CONTA+(_cAlias0)->DATA_ATU )
	
		_nSldSE8 	:= SE8->E8_SALATUA
		_cBanco		:= SE8->E8_BANCO
		_cAgencia	:= SE8->E8_AGENCIA
		_cConta		:= SE8->E8_CONTA

		RECLOCK("TRM",.T.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_INVEST	:=_cTipo
			TM_NOMEBCO	:=_cNomeBco
			TM_AGENC	:=_cAgencia
			TM_BANCO	:=_cBanco
			TM_CONTA	:=_cConta
			TM_SALDO	:=_nSldSE8
		MSUNLOCK()   

		If (_cAlias0)->INVESTIMENTO ="S"

			_nSldInv += SE8->E8_SALATUA

		Elseif (_cAlias0)->INVESTIMENTO ="N"
		
			_nTSld +=SE8->E8_SALATUA 
		
		Endif		
	DbSelectArea(_cAlias0)	 
	DbSkip()


EndDo



//busco os recebidoss nos bancos com fluxo de caixa flagado 

cQuery1 := "SELECT SE5.E5_AGENCIA, SE5.E5_CONTA, SE5.E5_BANCO,SED.ED_TIPOOPE, SUM(SE5.E5_VALOR) AS [ENTRADA] FROM " +RetSqlName("SE5") + " SE5 "
cQuery1 += " INNER JOIN " +RetSqlName("SA6") + " SA6 ON SA6.A6_COD = SE5.E5_BANCO "
cQuery1 += " INNER JOIN " +RetSqlName("SED") + " SED ON SED.ED_CODIGO = SE5.E5_NATUREZ "
cQuery1 += " AND SA6.A6_AGENCIA = SE5.E5_AGENCIA "
cQuery1 += " AND SA6.A6_NUMCON = SE5.E5_CONTA "
cQuery1 += " AND SA6.A6_FLUXCAI ='S' "
cQuery1 += " AND SA6.A6_BLOCKED='2' "
cQuery1 += " AND SE5.E5_SITUACA NOT IN('C','E','X') "
cQuery1 += " AND SE5.D_E_L_E_T_='' "
cQuery1 += " AND SE5.E5_DTDISPO = '" + DTOS(MV_PAR01) + "'"
cQuery1 += " AND E5_MOTBX IN ('NOR','DEB','') "
cQuery1 += " AND E5_RECPAG='R' "
cQuery1 += " AND E5_TIPODOC NOT IN('DC','D2','J2','TL','MT','M2','CM','C2','TR','TE','ES','CH','EC')"
cQuery1 += " GROUP BY SE5.E5_AGENCIA, SE5.E5_CONTA, SE5.E5_BANCO, SED.ED_TIPOOPE "

cQuery1 := ChangeQuery(cQuery1)  // padroniza com o banco existente ChangeQuery
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),_cAlias1,.T.,.F.)	  

dbselectarea(_cAlias1)
While !eof()
		
	dbSelectArea("TRM")
	DBSEEK((_cAlias1)->E5_BANCO+(_cAlias1)->E5_AGENCIA+(_cAlias1)->E5_CONTA)
			
		if (_cAlias1)->ED_TIPOOPE=="E"
			_nEntrE:= (_cAlias1)->ENTRADA
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_ENTRE 	:= _nEntrE
			MSUNLOCK()
			_nTEntrE 	+=(_cAlias1)->ENTRADA	
		
		Elseif (_cAlias1)->ED_TIPOOPE=="I"
			_nEntrN:= (_cAlias1)->ENTRADA
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_ENTRN 	:= _nEntrN
			MSUNLOCK()
			_nTEntrN 	+=(_cAlias1)->ENTRADA	

		Elseif (_cAlias1)->ED_TIPOOPE=="O"
			_nEntrO:= (_cAlias1)->ENTRADA
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_ENTRO 	:= _nEntrO
			MSUNLOCK()
			_nTEntrO 	+=(_cAlias1)->ENTRADA

	  	EndIf		

	dbselectarea(_cAlias1)
	DbSkip()

EndDo


//busco os recebimentos para o dia nos bancos com fluxo de caixa flagado
cQuery2 := "SELECT SE1.E1_AGEDEP, SE1.E1_CONTA, SE1.E1_PORTADO, SED.ED_TIPOOPE, SUM(SE1.E1_VLCRUZ) AS[VALOR] FROM " +RetSqlName("SE1") + " SE1 "
cQuery2 += " INNER JOIN " +RetSqlName("SED") + " SED ON SED.ED_CODIGO = SE1.E1_NATUREZ "
cQuery2 += " INNER JOIN " +RetSqlName("SA6") + " SA6 ON SA6.A6_COD = SE1.E1_PORTADO "
cQuery2 += " AND SA6.A6_AGENCIA = SE1.E1_AGEDEP "
cQuery2 += " AND SA6.A6_NUMCON = SE1.E1_CONTA "
cQuery2 += " AND SA6.A6_FLUXCAI ='S' "
cQuery2 += " AND SA6.A6_BLOCKED='2' "
cQuery2 += " AND SE1.D_E_L_E_T_='' "
cQuery2 += " AND SE1.E1_VENCREA < '" + DTOS(MV_PAR01) + "'"
cQuery2 += " AND SE1.E1_BAIXA =''"
cQuery2 += " AND SE1.E1_STATUS='A' "
cQuery2 += " AND SE1.E1_TIPO NOT IN ('RA','NCC') "
cQuery2 += " GROUP BY SE1.E1_AGEDEP, SE1.E1_CONTA, SE1.E1_PORTADO, SED.ED_TIPOOPE "

cQuery2 := ChangeQuery(cQuery2)  // padroniza com o banco existente ChangeQuery
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),_cAlias2,.T.,.F.)	 

dbselectarea(_cAlias2)
While !eof()
		
	dbSelectArea("TRM")
	DBSEEK((_cAlias2)->E1_PORTADO+(_cAlias2)->E1_AGEDEP+(_cAlias2)->E1_CONTA)
			
		if (_cAlias2)->ED_TIPOOPE=="E"
			_nCobrE	:= (_cAlias2)->VALOR
			
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_COBRE 	:= _nCobrE
			MSUNLOCK()
			_nTCobrE	+=(_cAlias2)->VALOR
				
		Elseif (_cAlias2)->ED_TIPOOPE=="I"
			_nCobrN		:= (_cAlias2)->VALOR
			
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_COBRN 	:= _nCobrN
			MSUNLOCK()
			_nTCobrN	+=(_cAlias2)->VALOR

		Elseif (_cAlias2)->ED_TIPOOPE=="O"
			_nCobrO		:= (_cAlias2)->VALOR
			
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_COBRO 	:=_nCobrO
			MSUNLOCK()
			_nTCobrO	+=(_cAlias2)->VALOR

	  	EndIf		

	dbselectarea(_cAlias2)
	DbSkip()
EndDo

//busco os recebimentos a vencer nos bancos com fluxo de caixa flagado

cQuery3 := "SELECT SE1.E1_AGEDEP, SE1.E1_CONTA, SE1.E1_PORTADO, SED.ED_TIPOOPE, SUM(SE1.E1_VLCRUZ) AS[VALOR] FROM " +RetSqlName("SE1") + " SE1 "
cQuery3 += " INNER JOIN " +RetSqlName("SED") + " SED ON SED.ED_CODIGO = SE1.E1_NATUREZ "
cQuery3 += " INNER JOIN " +RetSqlName("SA6") + " SA6 ON SA6.A6_COD = SE1.E1_PORTADO "
cQuery3 += " AND SA6.A6_AGENCIA = SE1.E1_AGEDEP "
cQuery3 += " AND SA6.A6_NUMCON = SE1.E1_CONTA "
cQuery3 += " AND SA6.A6_FLUXCAI ='S' "
cQuery3 += " AND SA6.A6_BLOCKED='2' "
cQuery3 += " AND SE1.D_E_L_E_T_='' "
cQuery3 += " AND SE1.E1_VENCREA >= '" + DTOS(MV_PAR01) + "'"
cQuery3 += " AND SE1.E1_BAIXA =''"
cQuery3 += " AND SE1.E1_STATUS='A' "
cQuery3 += " AND SE1.E1_TIPO NOT IN ('RA','NCC') "
cQuery3 += " GROUP BY SE1.E1_AGEDEP, SE1.E1_CONTA, SE1.E1_PORTADO, SED.ED_TIPOOPE "

cQuery3 := ChangeQuery(cQuery3)  // padroniza com o banco existente ChangeQuery
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),_cAlias3,.T.,.F.)	 

dbselectarea(_cAlias3)
While !eof()
		
	dbSelectArea("TRM")
	DBSEEK((_cAlias3)->E1_PORTADO+(_cAlias3)->E1_AGEDEP+(_cAlias3)->E1_CONTA)
			
		if (_cAlias3)->ED_TIPOOPE=="E"
			_nAVencE	:= (_cAlias3)->VALOR
			
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_VENCERE 	:= _nAVencE
			MSUNLOCK()
			_nTAVencE	+=(_cAlias3)->VALOR
				
		Elseif (_cAlias3)->ED_TIPOOPE=="I"
			_nAVencN	:= (_cAlias3)->VALOR
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_VENCERN 	:= _nAVencN
			MSUNLOCK()
			_ntAVencN	+=(_cAlias3)->VALOR

		Elseif (_cAlias3)->ED_TIPOOPE=="O"
			
			_nAVencO	:= (_cAlias3)->VALOR
			
			RECLOCK("TRM",.F.)   
			TM_FILIAL  	:= xFilial("TRM")
			TM_VENCERO 	:=_nAVencO
			MSUNLOCK()
			_nTAVencO	+=(_cAlias3)->VALOR

	  	EndIf		

	dbselectarea(_cAlias3)
	DbSkip()
EndDo


oExcel:AddworkSheet(_cSheet1)
oExcel:AddTable(_cSheet1,_cTitulo1)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Banco"   						,1,1,.F.)  
oExcel:AddColumn(_cSheet1,_cTitulo1,"Conta" 						,1,1,.F.) 			
oExcel:AddColumn(_cSheet1,_cTitulo1,"Saldo Inicial" 				,1,2,.F.) 			
oExcel:AddColumn(_cSheet1,_cTitulo1,"Entrada Nacional" 				,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Entrada Internacional" 		,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Entrada Outras" 				,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Entrada Bloqueada" 			,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Cobran็a Nacional" 			,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Cobran็a Internacional"		,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Cobran็a Outros"	 			,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Inadimplencia Nacional"	 	,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Inadimplencia Internacional"	,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Inadimplencia OUtros"	 		,1,2,.F.)


_nCoEle := 14 
_aCol   := {}
_cCont  := ""
_cCbas  := ""


	
DbSelectArea("TRM") 
DbGotop()  	
While !EOF() 
    
   		 _nPProd := Len(_aCol)+1
			AADD(_aCol,Array(_nCoEle))
			_aCol[_nPProd+00][01]       := TRM->TM_NOMEBCO     
			_aCol[_nPProd+00][02]       := TRM->TM_CONTA
			_aCol[_nPProd+00][03]       := TRM->TM_SALDO
			_aCol[_nPProd+00][04]       := TRM->TM_ENTRN
			_aCol[_nPProd+00][05]       := TRM->TM_ENTRE
			_aCol[_nPProd+00][06]       := TRM->TM_ENTRO
			_aCol[_nPProd+00][07]       := TRM->TM_ENTRBL     					
			_aCol[_nPProd+00][08]       := TRM->TM_VENCERN    					
			_aCol[_nPProd+00][09]       := TRM->TM_VENCERE   					
			_aCol[_nPProd+00][10]       := TRM->TM_VENCERO   					
			_aCol[_nPProd+00][11]       := TRM->TM_COBRN     					
			_aCol[_nPProd+00][12]       := TRM->TM_COBRE   					
			_aCol[_nPProd+00][13]       := TRM->TM_COBRO  					
			_aCol[_nPProd+00][14]       := TRM->TM_INVEST  					
//			aFill(_aCol[_nPProd+00],0,1,Len(_aCol[_nPProd+00])-10) 	
//			aFill(_aCol[_nPProd+00],0,15,Len(_aCol[_nPProd+00])-10) 	
				   							
	DbSelectArea("TRM") 
	DbSkip()    
Enddo
TRM->(DbCloseArea()) 
(_cAlias0)->(DbCloseArea())   	 
(_cAlias1)->(DbCloseArea())   	 
(_cAlias2)->(DbCloseArea())   	 
(_cAlias3)->(DbCloseArea())   	 

If Len(_aCol) > 0                                            
	_nItens  := 0  
	
	For _x   := 1 To Len(_aCol)
		If _aCol[_x] [14] =="N"
			_nItens++
			//oExcel:AddRow(_cSheet1, _cTitulo1, _aCol[_x])	
			oExcel:AddRow(_cSheet1, _cTitulo1,{_aCol[_x] [01],_aCol[_x] [02],_aCol[_x] [03],_aCol[_x] [04],_aCol[_x] [05],_aCol[_x] [06],_aCol[_x] [07],_aCol[_x] [08],_aCol[_x] [09],_aCol[_x] [10],_aCol[_x] [11],_aCol[_x] [12],_aCol[_x] [13]})	
		EndIf
	Next   
	
	oExcel:AddRow(_cSheet1,_cTitulo1,{,,,,,,,,,,,,})
	oExcel:AddRow(_cSheet1,_cTitulo1,{"Saldo Disponivel em C/C ",,_nTSld,_nTEntrN,_nTEntrE,_nTEntrO,,_ntAVencN,_nTAVencE,_nTAVencO,_nTCobrN,_nTCobrE,_nTCobrO})
	oExcel:AddRow(_cSheet1,_cTitulo1,{,,,,,,"APLICAวีES",,,,,,})
	
	For _x   := 1 To Len(_aCol)
		If _aCol[_x] [14] =="S"
			_nItens++
			//oExcel:AddRow(_cSheet1, _cTitulo1, _aCol[_x])	
			oExcel:AddRow(_cSheet1, _cTitulo1,{_aCol[_x] [01],_aCol[_x] [02],_aCol[_x] [03],_aCol[_x] [04],_aCol[_x] [05],_aCol[_x] [06],_aCol[_x] [07],_aCol[_x] [08],_aCol[_x] [09],_aCol[_x] [10],_aCol[_x] [11],_aCol[_x] [12],_aCol[_x] [13]})	
		EndIf
	Next   
	oExcel:AddRow(_cSheet1,_cTitulo1,{,,,,,,,,,,,,})
	oExcel:AddRow(_cSheet1,_cTitulo1,{"Saldos Aplicados em Fundos ",,_nSldInv,,,,,,,,,,})
	_nTSld	 := _nTSld +_nSldInv  
	oExcel:AddRow(_cSheet1,_cTitulo1,{,,,,,,,,,,,,})
	oExcel:AddRow(_cSheet1,_cTitulo1,{"Saldos Total ",,_nTSld,_nTEntrN,_nTEntrE,_nTEntrO,,_ntAVencN,_nTAVencE,_nTAVencO,_nTCobrN,_nTCobrE,_nTCobrO})

	If _nItens > 0
		oExcel:Activate()
		_cFile := (CriaTrab(NIL, .F.) + ".xml")
	
		While File(_cFile)
			_cFile := (CriaTrab(NIL, .F.) + ".xml")
		EndDo
	
		oExcel:GetXMLFile(_cFile)
		oExcel:DeActivate()
	
		If !(File(_cFile))
			_cFile := ""
			Break
		EndIf
	
		_cFileTMP := (GetTempPath() + _cFile)
	
		If !(__CopyFile(_cFile , _cFileTMP))
			fErase( _cFile )
			_cFile := ""
			Break
		EndIf
	
		fErase(_cFile)
		_cFile := _cFileTMP
	
		If !(File(_cFile))
			_cFile := ""
			Break
		EndIf			 
	Endif
Endif

oMsExcel := MsExcel():New()
oMsExcel:WorkBooks:Open(_cFile)
oMsExcel:SetVisible(.T.)
oMsExcel := oMsExcel:Destroy()
FreeObj(oExcel)
oExcel := NIL
        
Return(.T.) 

//-------------------------------------------------------------------
//  Valida Perguntas
//-------------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRATFR001  บAutor  ณ Higor Emanuel      บ Data ณ  06/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida as perguntas selecionadas.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProtheus 11                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()
Local i:=1
Local j:=1
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

//------------------------------------------------------------------------------------
//  Variaveis utilizadas para parametros
//------------------------------------------------------------------------------------

AADD(aRegs,{cPerg,"01","Data Base?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])                                      	
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				exit
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)

Return               
