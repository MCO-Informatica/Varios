/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ZFATF02 ³ Autor ³                        ³ Data ³ 00/00/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³      			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "PRTOPDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function MT410INC
/*
Local aCabec	:= {}
Local aItem		:= {}
Local aItens	:= {}

aCabec := {	{"C5_NUM"     	,SC5->C5_NUM                                       		,Nil},;
			{"C5_TIPO"     	,SC5->C5_TIPO                              				,Nil},;
			{"C5_CLIENTE"  	,SC5->C5_CLIENTE						          		,Nil},;
			{"C5_LOJACLI"  	,SC5->C5_LOJACLI								   		,Nil},;
			{"C5_TRANSP"  	,SC5->C5_TRANSP									   		,Nil},;
			{"C5_CONDPAG"	,SC5->C5_CONDPAG										,Nil},;   
			{"C5_TABELA"	,SC5->C5_TABELA											,Nil},; 
			{"C5_VEND1"		,SC5->C5_VEND1											,Nil},;
			{"C5_COMIS1"	,SC5->C5_COMIS1											,Nil},; 
			{"C5_VEND2"		,SC5->C5_VEND2											,Nil},;
			{"C5_COMIS2"	,SC5->C5_COMIS2											,Nil},;
			{"C5_VEND3"		,SC5->C5_VEND3											,Nil},;
			{"C5_COMIS3"	,SC5->C5_COMIS3											,Nil},;
			{"C5_VEND4"		,SC5->C5_VEND4											,Nil},;
			{"C5_COMIS4"	,SC5->C5_COMIS4											,Nil},;
			{"C5_VEND5"		,SC5->C5_VEND5											,Nil},;
			{"C5_COMIS5"	,SC5->C5_COMIS5											,Nil},;  
			{"C5_DESC1"		,SC5->C5_DESC1											,Nil},;
			{"C5_DESC2"		,SC5->C5_DESC2											,Nil},;
			{"C5_DESC3"		,SC5->C5_DESC3											,Nil},;
			{"C5_DESC4"		,SC5->C5_DESC4											,Nil},; 
			{"C5_DESCFI"	,SC5->C5_DESCFI											,Nil},;  
			{"C5_EMISSAO"  	,dDataBase    	                     			        ,Nil},;
			{"C5_PARC1"		,SC5->C5_PARC1											,Nil},;
			{"C5_DATA1"		,SC5->C5_DATA1											,Nil},; 
			{"C5_PARC2"		,SC5->C5_PARC2											,Nil},;
			{"C5_DATA2"		,SC5->C5_DATA2											,Nil},;
			{"C5_PARC3"		,SC5->C5_PARC3											,Nil},;
			{"C5_DATA3"		,SC5->C5_DATA3											,Nil},;
			{"C5_PARC4"		,SC5->C5_PARC4											,Nil},;
			{"C5_DATA4"		,SC5->C5_DATA5											,Nil},;    
			{"C5_X_NOME"	,SC5->C5_X_NOME											,Nil},;
			{"C5_X_FPAGT"	,SC5->C5_X_FPAGT										,Nil},;
			{"C5_X_BON1"	,SC5->C5_X_BON1											,Nil},; 
			{"C5_X_BON2"	,SC5->C5_X_BON2											,Nil},;
			{"C5_PARC5"		,SC5->C5_PARC5											,Nil},;
			{"C5_DATA5"		,SC5->C5_DATA5											,Nil},;
			{"C5_X_TOTQT"	,SC5->C5_X_TOTQT										,Nil},;
			{"C5_PDEST1"	,SC5->C5_PDEST1											,Nil},;
			{"C5_PDEST2"	,SC5->C5_PDEST2											,Nil},;
			{"C5_PDEST3"	,SC5->C5_PDEST3											,Nil},;
			{"C5_PDEST4"	,SC5->C5_PDEST4											,Nil},;
			{"C5_PDEST5"	,SC5->C5_PDEST5											,Nil}}
				
For nCount := 1 to Len(aCols)

	aItem	 :=	 {	{"C6_ITEM"   	,aCols[nCount,01]               					,Nil},;
					{"C6_PRODUTO"	,aCols[nCount,02]	 				 				,Nil},;
					{"C6_QTDVEN"  	,aCols[nCount,05]  									,Nil},;
					{"C6_TES"    	,aCols[nCount,12]									,Nil},;
					{"C6_PRUNIT"  	,aCols[nCount,06]									,Nil},;     
					{"C6_DESCONT"  	,aCols[nCount,16]									,Nil}}
	
	AAdd(aItens ,aItem)
	
Next nCount	                               

Processa({|| ZFATF03(aCabec,aItens) } ,"Inclusao de Pedido!!!")

Return

Static Function ZFATF03(aCabec,aItens)
Local bRet 		:= Nil
Local nCount	:= 0

procregua(1)

While bRet == Nil          
	IF nCount > 0 .and. bRet == Nil
   		IncProc("Excedeu o numero de licencas. Tentativa: " + str(nCount))
 	Elseif bRet == .F.
 		Alert("Nao foi possivel incluir o pedido de forma automatica, verifique os cadastros e inclua manualmente")
 	Endif
   	bRet := StartJob("u_ZFATF02","TESTE",.t.,aCabec,aItens)
   	nCount++
Enddo
*/
Return