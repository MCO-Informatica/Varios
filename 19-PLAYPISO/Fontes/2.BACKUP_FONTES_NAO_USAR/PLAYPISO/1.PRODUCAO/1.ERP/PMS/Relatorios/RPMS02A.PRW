#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH"    

#define DMPAPER_LETTER    1  // Letter 8 1/2 x 11 in
#define DMPAPER_LETTERSMALL  2   // Letter Small 8 1/2 x 11 in
#define DMPAPER_TABLOID   3 // Tabloid 11 x 17 in
#define DMPAPER_LEDGER   4 // Ledger 17 x 11 in                                          
#define DMPAPER_LEGAL   5 // Legal 8 1/2 x 14 in
#define DMPAPER_EXECUTIVE  7 // Executive 7 1/4 x 10 1/2 in                                                	
#define DMPAPER_A3    8 // A3 297 x 420 mm
#define DMPAPER_A4    9 // A4 210 x 297 mm
#define DMPAPER_A4SMALL   10 // A4 Small 210 x 297 mm
#define DMPAPER_A5    11 // A5 148 x 210 mm
#define DMPAPER_B4    12 // B4 250 x 354
#define DMPAPER_B5    13 // B5 182 x 257 mm
#define DMPAPER_FOLIO   14 // Folio 8 1/2 x 13 in
#define DMPAPER_NOTE   18 // Note 8 1/2 x 11 in
#define DMPAPER_ENV_10   20 // Envelope #10 4 1/8 x 9 1/2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMSR260   ºAutor  ³Bruno S. Parreira   º Data ³  03/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de detalhamento de orçamentos                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RPMS02A(cArquivo,aCampos,cCompTit) 
	Local cDesc1 	:= "Este relatório tem o objetivo de mostrar a estrutura dos projetos."
	Local cDesc2 	:= ''
	Local cDesc3 	:= ''
	Local cString	:= "AFC"     

	Private tamanho	:= "P"

	Private cpTitulo := "Estrutura do Projeto"    
	Private cProgram := "RPMS02A"

	Private aOrd      := {}

	Private opFont1   := TFont():New( "Times New Roman",,17,,.T.,,,,,.F.)
	Private opFont2   := TFont():New( "Courier New"    ,,15,,.F.,,,,,.F.)
	Private opFont3   := TFont():New( "Tahoma"         ,,12,,.F.,,,,,.F.) 
	Private oFont08   := TFont():New( "Tahoma"         ,,08,,.F.,,,,,.F.)
	Private oFont10   := TFont():New( "Tahoma"         ,,10,,.F.,,,,,.F.) 
	Private oFont12n  := TFont():New( "Tahoma"         ,,12,,.T.,,,,,.F.)
	Private oFont14n  := TFont():New( "Tahoma"         ,,14,,.T.,,,,,.F.)  

	Private aReturn := {"Zebrado",1,"Administracao", 2, 2, 1, "",0 }   

	Private li		  := 80, limite:=132, lRodape:=.F.  
	Private titulo 	  := "Estrutura do Projeto"          

	Private nLin 	:= 100
	Private	nfim    := 2300     
	Private nCol 	:= 50
	Private nPula 	:= 30  
	Private a_nvcod := {0,10,20,30,40,60,70}
	Private a_nvdesc:= {0,25,50,75,100,125,150} 
	Private aColTit := {25,200,630,1190,1470,1820,2030}
	Private	aCols   := {25,175,400,1160,1460,1810,2000}
	Private n_cont  := 0

	Private cCodPrj := ''
	Private cEdtPai := ''   

	Private clPerg  := 'XRPMS02A'

	oprn:=TMSPrinter():New(cpTitulo)
      
	clPerg := PADR(clPerg,10) 

	AjustSX1(clPerg)

	Pergunte(clPerg, .T.)


   	wnrel:=SetPrint(cString,cProgram,clPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)


	c_MV_PAR01 := MV_PAR01 //AF8->AF8_DATA
	c_MV_PAR02 := MV_PAR02 //AF8->AF8_DATA
	c_MV_PAR03 := MV_PAR03 //AF8->AF8_PROJET

   	If nLastKey == 27
 		Return
 	Endif
	
   	SetDefault(aReturn,cString)

	Processa({||ImpRel()}, titulo, "Gerando Relatorio, aguarde...")
	 
	If ( aReturn[5] == 1 ) //1-Disco, 2-Impressora
		oPrn:Preview()
	Else           
		oPrn:Print() 
		MS_FLUSH()
	EndIf
	
Return

Static Function ImpRel() 
	oprn:setPortrait() 
  	oprn:setPaperSize(DMPAPER_A4)
	
 	clAlias3 := RPMSQL3()
 	
 	DbSelectArea(clAlias3)
	(clAlias3)->(DbGoTop())
 	
	NPAG := 1
	CabecNF("000001") 
					
    PLTRLTCORP(clAlias3)   
Return

//ÚÄÄÄÄÄÄÄÄÄÄ¿                                             
//³PERGUNTAS.³
//ÀÄÄÄÄÄÄÄÄÄÄÙ 

Static Function AjustSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aHelp		:= {} 
Local cTamSX1	:= Len(SX1->X1_GRUPO)
Local cPesPerg	:= ""    
                                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os títulos e Help das perguntas                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aHelp,{ {	"Data inical do projeto"	," "	," " },{""}, {""} } )
aAdd(aHelp,{ {	"Data final do projeto"		," "	," " },{""}, {""} } )  
aAdd(aHelp,{ {	"Código do Projeto"	   		," "	," " },{""}, {""} } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava as perguntas no arquivo SX1                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		cGrupo 	cOrde 	cDesPor			cDesSpa			cDesEng			cVar	 	cTipo 	cTamanho	cDecimal	nPreSel		cGSC	cValid	cF3	cGrpSXG	cPyme	cVar01		cDef1Por	cDef1Spa	cDef1Eng	cCnt01	cDef2Por	cDef2Spa	cDef2Eng	cDef3Por	cDef3Spa	cDef3Eng	cDef4Por	cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
                                                                       	//log
PutSx1(cPerg	,"01"	,"De Data?"  	,"De Data?"     ,"De Data?"     ,"mv_ch1"  	,"D" 	,8          ,0         	,       	,"G"    ,""     ,""	,       ,""    	,"mv_par01" ,""			,""			,""			,""		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,aHelp[01,1]		,aHelp[01,2]		,aHelp[01,3]		,"" )
PutSx1(cPerg	,"02"	,"Ate Data?"   	,"Ate Data?"    ,"Ate Data?"    ,"mv_ch2"  	,"D" 	,8          ,0         	,       	,"G"    ,""     ,""	,       ,""    	,"mv_par02" ,""			,""			,""			,""		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,aHelp[02,1]		,aHelp[02,2]		,aHelp[02,3]		,"" )
PutSx1(cPerg	,"03"	,"Qual Projeto?","Qual Projeto?","Qual Projeto?","mv_ch3"  	,"C" 	,10         ,0         	,       	,"G"    ,""     ,""	,       ,""    	,"mv_par03" ,""			,""			,""			,""		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,aHelp[03,1]		,aHelp[03,2]		,aHelp[03,3]		,"" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva as áreas originais                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    

RestArea( aAreaSX1 )
RestArea( aAreaAtu )
                                                                                                                                                                                                                                                                                                                                                                                                          
Return( Nil )  

   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPMS001   ºAutor  ³Bruno S. Parreira   º Data ³  03/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PLTFCABECA()
Local nlLin := 50
Local nlCol := 30

oPrn:Say ( (nlLin*2),(nlCol*30),"Estrutura do Projeto",opFont2,,) 
oPrn:Say ( (nlLin*4),(nlCol*05),"Tarefa",opFont2,,)
oPrn:Say ( (nlLin*4),(nlCol*15),"Descricao",opFont2,,)   
                                                                       
Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPMS001   ºAutor  ³Bruno S. Parreira   º Data ³  03/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PLTRLTCORP(clAlias)
clprj	 := (clAlias3)->AF8_PROJET
c_fase   := ''
n_totc   := 0
n_totbdi := 0 
n_custo  := 0

While (clAlias3)->(!EOF())
    if clprj != (clAlias3)->AF8_PROJET
    	n_cont := 50
    EndIf
	
	If n_cont > 40
		CabecNF("000001")
		n_cont := 0
	EndIf
	
	nLin += nPula
	
	oPrn:Box(nLin-10,50,nLin+50,nfim)
	oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,2*(nfim-(50))/10)

	oPrn:Box(nLin-10,50,nLin+50,5.3*(nfim-(50))/10)

	oPrn:Box(nLin-10,50,nLin+50,6.5*(nfim-(50))/10)

	oPrn:Box(nLin-10,50,nLin+50,8*(nfim-(50))/10)

	oPrn:Box(nLin-10,50,nLin+50,9*(nfim-(50))/10)
	
	cCodPrj := (clAlias3)->AF8_PROJET
    cEdtPai := (clAlias3)->AF8_PROJET
    
    EdtFirst()   
   
    Tarefas()
    
    EdtsTar()
	
  	n_cont++          

  	clData := (clAlias3)->AF8_DATA
  	clprj  := (clAlias3)->AF8_PROJET 

	(clAlias3)->(DBSKIP())
EndDo     

	If ( aReturn[5] == 1 )
		dbCommitAll()
	EndIf   

Return     

Static Function CabecNF(c_cod)

Local aArea := GetArea()
Local cTxt := ""
nLin	:= 100
nCol	:= 60
nPula	:= 60

oPrn:EndPage()

If Li > 55
	
	oPrn:Say(nLin,nCol+750,Titulo,oFont14n,100)
	oPrn:Box(50,50,200,nfim)
	oPrn:Box(50,50,200,nfim-360)
	
	oPrn:Say(080,1950,"Folha....: " + str(NPAG),oFont10,100)
	oPrn:Say(120,1950,"DT.Emiss.: " + dtoc(date()),oFont10,100)
	
	nLin += nPula
	nLin += nPula
	nLin += nPula
	
	oPrn:Box(nLin-10,50,nLin+50,nfim)
	oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,2*(nfim-(50))/10)

	oPrn:Box(nLin-10,50,nLin+50,5.3*(nfim-(50))/10)

	oPrn:Box(nLin-10,50,nLin+50,6.5*(nfim-(50))/10)

	oPrn:Box(nLin-10,50,nLin+50,8*(nfim-(50))/10)

	oPrn:Box(nLin-10,50,nLin+50,9*(nfim-(50))/10)
	
	c_imp := "DATA"
	oPrn:Say(nLin,nCol+aColTit[1],c_imp,oFont12n,100)
	
	c_imp := "TAREFA"
	oPrn:Say(nLin,nCol+aColTit[2],c_imp,oFont12n,100)
	
	c_imp := "DESCRIÇÃO"
	oPrn:Say(nLin,nCol+aColTit[3],c_imp,oFont12n,100)
	
	c_imp := "CUSTO"
	oPrn:Say(nLin,nCol+aColTit[4],c_imp,oFont12n,100)

	c_imp := "MARKUP"
	oPrn:Say(nLin,nCol+aColTit[5],c_imp,oFont12n,100)

	c_imp := "%"
	oPrn:Say(nLin,nCol+aColTit[6],c_imp,oFont12n,100)

	c_imp := "TOTAL"
	oPrn:Say(nLin,nCol+aColTit[7],c_imp,oFont12n,100)
 
	nLin += nPula
	imprp	:= .T.
	
Endif

RestArea(aArea)
Return    

//ÚÄÄÄÄÄÄ¿
//³Querry³
//ÀÄÄÄÄÄÄÙ

Static Function RPMSQL()
Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	
	    select * from %Table:AFC% AFC
		where AFC_FILIAL=%EXP:xFilial('AFC')% AND %NotDel% 
		AND AFC_PROJET=%EXP:(clAlias3)->AF8_PROJET% AND AFC_NIVEL <> '001'
		order by AFC_PROJET, AFC_EDT
		
	EndSql 
	
Return(clAliasSql)

Static Function RPMSQL2()      
Local clAliasSql2 := GetNextAlias()

	BeginSql Alias clAliasSql2 
	    
		select * from %Table:AF9% AF9
		where AF9_FILIAL=%EXP:xFilial('AF9')% AND %NotDel% 
		AND AF9_PROJET=%EXP:cCodPrj% AND AF9_EDTPAI=%EXP:cEdtPai%
		order by AF9_PROJET, AF9_TAREFA

	EndSql 
	
Return(clAliasSql2) 

Static Function RPMSQL3()
Local clAliasSql3 := GetNextAlias()

	BeginSql Alias clAliasSql3 
	    
		select * from %Table:AF8% AF8
		where AF8_FILIAL=%EXP:xFilial('AF8')% AND %NotDel% 
	    AND AF8_DATA Between %Exp:c_MV_PAR01% and %Exp:c_MV_PAR02% AND AF8_PROJET=%EXP:c_MV_PAR03%
		order by AF8_PROJET

	EndSql 
	
Return(clAliasSql3)  

Static Function RPMSQL4()      
Local clAliasSql4 := GetNextAlias()

	BeginSql Alias clAliasSql4 
	    
		select * from %Table:AFC% AFC
		where AFC_FILIAL=%EXP:xFilial('AFC')% AND %NotDel% 
		AND AFC_PROJET=%EXP:cCodPrj% AND AFC_NIVEL='001'
		order by AFC_PROJET, AFC_EDT

	EndSql 
	
Return(clAliasSql4)    

Static Function Tarefas()
	clAlias2 := RPMSQL2()  
    (clAlias2)->(DbGoTop())
    if (clAlias2)->(!EOF())     
    	while (clAlias2)->(!EOF())
			If n_cont > 40
				CabecNF("000001")
				n_cont := 0
			EndIf        
			nLin += nPula
			oPrn:Box(nLin-10,50,nLin+50,nfim)

			oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)
			oPrn:Box(nLin-10,50,nLin+50,2*(nfim-(50))/10)

			oPrn:Box(nLin-10,50,nLin+50,5.3*(nfim-(50))/10)
			oPrn:Box(nLin-10,50,nLin+50,6.5*(nfim-(50))/10)
			oPrn:Box(nLin-10,50,nLin+50,8*(nfim-(50))/10)
			oPrn:Box(nLin-10,50,nLin+50,9*(nfim-(50))/10)


			c_imp := DtoC(stod((clAlias3)->AF8_DATA))
			oPrn:Say(nLin,nCol+aCols[1],c_imp,oFont08,100)
	
			c_imp := (clAlias2)->AF9_TAREFA
			oPrn:Say(nLin,nCol+aCols[2]+a_NvCod[val((clAlias2)->AF9_NIVEL)],c_imp,oFont08,100)

			c_imp := SubStr((clAlias2)->AF9_DESCRI, 1,35)
			oPrn:Say(nLin,nCol+aCols[3]+a_NvDesc[val((clAlias2)->AF9_NIVEL)],c_imp,oFont08,100)  
            
			c_imp := Transform((clAlias2)->AF9_CUSTO, "@E 999,999,999.99")
			oPrn:Say(nLin,nCol+aCols[4],c_imp,oFont08,100)  

			c_imp := Transform((clAlias2)->AF9_VALBDI, "@E 999,999,999.99")
			oPrn:Say(nLin,nCol+aCols[5],c_imp,oFont08,100)  

			c_imp := Transform(((clAlias2)->AF9_VALBDI/(clAlias2)->AF9_CUSTO)*100, "@E 999.99")
			oPrn:Say(nLin,nCol+aCols[6],c_imp,oFont08,100)  

			c_imp := Transform((clAlias2)->AF9_TOTAL, "@E 999,999,999.99")
			oPrn:Say(nLin,nCol+aCols[7],c_imp,oFont08,100)  

   			n_cont++
   			(clAlias2)->(DBSKIP())
		EndDo
	EndIf   
Return    

Static Function EdtsTar()
	clAlias := RPMSQL()  
    (clAlias)->(DbGoTop())
    if (clAlias)->(!EOF())         	
    	while (clAlias)->(!EOF())
    		If n_cont > 40
				CabecNF("000001")
				n_cont := 0
			EndIf   
			
			nLin += nPula
	
			oPrn:Box(nLin-10,50,nLin+50,nfim)
			oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)
			oPrn:Box(nLin-10,50,nLin+50,2*(nfim-(50))/10) 
			
			oPrn:Box(nLin-10,50,nLin+50,5.3*(nfim-(50))/10)
			oPrn:Box(nLin-10,50,nLin+50,6.5*(nfim-(50))/10)
			oPrn:Box(nLin-10,50,nLin+50,8*(nfim-(50))/10)
			oPrn:Box(nLin-10,50,nLin+50,9*(nfim-(50))/10)

			c_imp := DtoC(stod((clAlias3)->AF8_DATA))
			oPrn:Say(nLin,nCol+aCols[1],c_imp,oFont08,100)
		
			c_imp := (clAlias)->AFC_EDT
			oPrn:Say(nLin,nCol+aCols[2]+a_nvcod[val((clAlias)->AFC_NIVEL)],c_imp,oFont08,100)
	    	
			c_imp := SubStr((clAlias)->AFC_DESCRI, 1,35)
			oPrn:Say(nLin,nCol+aCols[3]+a_nvdesc[val((clAlias)->AFC_NIVEL)],c_imp,oFont08,100)
	
			c_imp := Transform((clAlias)->AFC_CUSTO, "@E 999,999,999.99")
			oPrn:Say(nLin,nCol+aCols[4],c_imp,oFont08,100)  
	
			c_imp := Transform((clAlias)->AFC_VALBDI, "@E 999,999,999.99")
			oPrn:Say(nLin,nCol+aCols[5],c_imp,oFont08,100)  
	
			c_imp := Transform(((clAlias)->AFC_VALBDI/(clAlias)->AFC_CUSTO)*100, "@E 999.99")
			oPrn:Say(nLin,nCol+aCols[6],c_imp,oFont08,100)  
	
			c_imp := Transform((clAlias)->AFC_TOTAL, "@E 999,999,999.99")
			oPrn:Say(nLin,nCol+aCols[7],c_imp,oFont08,100)  

           	cCodPrj := (clAlias)->AFC_PROJET
           	cEdtPai := (clAlias)->AFC_EDT
            	
           	Tarefas()

			n_cont++
   			(clAlias)->(DBSKIP())
    	EndDo
 	EndIf    
Return    

Static Function EdtFirst()
	clAlias4 := RPMSQL4()
 	
 	DbSelectArea(clAlias4)
	(clAlias4)->(DbGoTop())
    
    c_imp := DtoC(stod((clAlias3)->AF8_DATA))
	oPrn:Say(nLin,nCol+aCols[1],c_imp,oFont08,100)
	
	c_imp := (clAlias4)->AFC_PROJET
	oPrn:Say(nLin,nCol+aCols[2],c_imp,oFont08,100)
	
	c_imp := SubStr((clAlias4)->AFC_DESCRI, 1,35)
	oPrn:Say(nLin,nCol+aCols[3],c_imp,oFont08,100)  
	
	c_imp := Transform((clAlias4)->AFC_CUSTO, "@E 999,999,999.99")
	oPrn:Say(nLin,nCol+aCols[4],c_imp,oFont08,100)  
	
	c_imp := Transform((clAlias4)->AFC_VALBDI, "@E 999,999,999.99")
	oPrn:Say(nLin,nCol+aCols[5],c_imp,oFont08,100)  
	
	c_imp := Transform(((clAlias4)->AFC_VALBDI/(clAlias4)->AFC_CUSTO)*100, "@E 999.99")
	oPrn:Say(nLin,nCol+aCols[6],c_imp,oFont08,100)  
	
	c_imp := Transform((clAlias4)->AFC_TOTAL, "@E 999,999,999.99")
	oPrn:Say(nLin,nCol+aCols[7],c_imp,oFont08,100)  
Return                                       