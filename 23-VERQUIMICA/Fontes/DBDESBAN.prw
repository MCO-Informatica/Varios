#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH"     
#include "RwMake.ch"

/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: DBDESBAN | Autor: Danilo Alves Del Busso      | Data: 30/05/2016 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: | Responsavel pela alteracao da data de baixa das despesas      |||
|||			   |bancarias retornadas pelo CNAB                                 |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       | Verquimica                                                    |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/    

User Function DBDESBAN()

	If Pergunte("DBDESPESAS", .T.)
	    dbTituls()
	EndIf
	                               
Return                       

Static Function dbTituls() 
	Local _struct:={}
	Local aCpoBro := {}
	Local oDlg
    Local cQuery         
    Local aProdutos := {}   
    Local aButtons := {}     
    
    Private nTotalT := 0 // total dos titulos selecionados
    
	Private lInverte := .F.
	Private cMark   := GetMark()   
	Private oMark     
                              

	Aadd( aButtons, {"ALTERARDATA", {|| u_UPDATDES()}, "Alterar data para...", "Alterar data para..." , {|| .T.}} )  
               
	AADD(_struct,{"OK"     		,"C"	,2		,0		})
	AADD(_struct,{"E5_DATA"   	,"D"	,8		,0		})
	AADD(_struct,{"E5_PREFIXO"	,"C"	,3		,0		})   
	AADD(_struct,{"E5_NUMERO"	,"C"	,9		,0		})
	AADD(_struct,{"E5_PARCELA"	,"C"	,2		,0		})
	AADD(_struct,{"E5_TIPO"   	,"C"	,3		,0		})
	AADD(_struct,{"E5_VALOR"  	,"N"	,16		,2		})
	AADD(_struct,{"E5_NATUREZ"	,"C"	,10		,0		})
	AADD(_struct,{"E5_HISTOR" 	,"C"	,40		,0		})
	AADD(_struct,{"E5_TIPODOC" 	,"C"	,3		,0		})    
	AADD(_struct,{"DT_ANTALT", "D", 8, 0 })
	
	cArq:=Criatrab(_struct,.T.)

	DBUSEAREA(.t.,,carq,"TTMPSE5")  
	
	cQuery := "SELECT E5_DATA,E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_VALOR, E5_NATUREZ, E5_HISTOR, E5_TIPODOC FROM SE5010 "
    cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
    cQuery += " ((E5_HISTOR LIKE '%DESP%CART%' AND  E5_TIPODOC = 'DB' ) OR E5_HISTOR LIKE '%DESP%CART%') AND "
    cQuery += " E5_DATA BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "'"  
    cQuery += "ORDER BY E5_DATA, E5_NUMERO, E5_PARCELA"
    
    If Select("TMPSE5") > 0
		TMPSE5->(DbCloseArea())
	EndIf     
	
  	TcQuery cQuery New Alias "TMPSE5"
	  
	While !TMPSE5->(Eof())     
		DbSelectArea("TTMPSE5")	
		RecLock("TTMPSE5",.T.)		
		TTMPSE5->E5_DATA   	:=  Stod(TMPSE5->E5_DATA)		
		TTMPSE5->E5_PREFIXO    	:=  TMPSE5->E5_PREFIXO		
		TTMPSE5->E5_NUMERO    	:=  TMPSE5->E5_NUMERO		
		TTMPSE5->E5_PARCELA    	:=  TMPSE5->E5_PARCELA		
		TTMPSE5->E5_TIPO    	:=  TMPSE5->E5_TIPO		                         
		TTMPSE5->E5_VALOR   	:=  TMPSE5->E5_VALOR		
		TTMPSE5->E5_NATUREZ 	:=  TMPSE5->E5_NATUREZ		
		TTMPSE5->E5_HISTOR		:=  TMPSE5->E5_HISTOR		
		TTMPSE5->E5_TIPODOC  	:= 	TMPSE5->E5_TIPODOC     
		TTMPSE5->DT_ANTALT		:= 	Stod(TMPSE5->E5_DATA)
		MsunLock()	
		TMPSE5->(DbSkip())
	EndDo           

	CpoBro := {{ "OK"			,, "Mark"           ,"@!"},;
			{ "E5_DATA"			,, "DT Movimen"         ,"@!"},;  
			{ "E5_PREFIXO"		,, "Prefixo"         ,"@!"},;  
			{ "E5_NUMERO"		,, "Titulo"         ,"@!"},;  
			{ "E5_PARCELA"		,, "Parcela"        ,"@!"},;  			
			{ "E5_TIPO"	   		,, "Tipo Titulo"           ,"@!"},;
			{ "E5_VALOR"		,, "Vlr.Movim."           ,"@E 9,999,999,999,999.99"},;
			{ "E5_NATUREZ"		,, "Natureza"   ,"@!"},;
			{ "E5_HISTOR"		,, "Historico"   ,"@!"},;
			{ "E5_TIPODOC"		,, "Tipo do Doc."       ,"@!"}}
	
	DEFINE MSDIALOG oDlg TITLE "Titulos Despesas de Cartorio" From 1,1 To 650,900 Of oMainWnd PIXEL 

		DbSelectArea("TTMPSE5")
  		DbGotop()	
  		
	    oMark := MsSelect():New("TTMPSE5","OK","",CpoBro,@lInverte,@cMark,{17,1,215,600},,,,,)
		oMark:bMark := {| | Disp()}  
		oMark:oBrowse:bAllMark := {| | DispAll()}           
		
		
		@ 230, 10 Say "Total dos Titulos Selecionados:"       Of oDlg Pixel
		@ 230, 90 Get nTotalT Picture "@E 999,999,999.99" Size 060,006 When .F. Object oTotalT
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| u_DBGRAVDES()},{|| oDlg:End()},,@aButtons)
		
		TTMPSE5->(DbCloseArea())      
   		Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

Return

Static Function Disp()

RecLock("TTMPSE5",.F.)
If Marked("OK")	
	TTMPSE5->OK := cMark   
	nTotalT += TTMPSE5->E5_VALOR
Else	
	TTMPSE5->OK := ""
	nTotalT -= TTMPSE5->E5_VALOR
Endif             
MSUNLOCK()

oTotalT:Refresh()
oMark:oBrowse:Refresh()   

Return()   

Static Function DispAll()  
	DbSelectArea("TTMPSE5")
	DbGotop()
	While !TTMPSE5->(EoF())	   
		If !Empty(TTMPSE5->OK) 
			RecLock("TTMPSE5",.F.)
   				TTMPSE5->OK :=  ""    
   				nTotalT -= TTMPSE5->E5_VALOR
   			MsUnlock()   
   		Else
   			RecLock("TTMPSE5",.F.)
   				TTMPSE5->OK :=  cMark 
   				nTotalT += TTMPSE5->E5_VALOR
   			MsUnlock() 
  		EndIf             
 		TTMPSE5->(DbSkip())
	EndDo  
	DbGotop() 
oTotalT:Refresh()
	
Return()     

User Function DBGRAVDES()
	Local cTexto := ""   
	Local nTotal := 0
	DbSelectArea("TTMPSE5")
	DbGotop()
		
	While !TTMPSE5->(EoF())	   
		If !Empty(TTMPSE5->OK)
           	DbSelectArea("SE5") ; DbSetOrder(20)
			If SE5->(DbSeek(xFilial("SE5")+TTMPSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+DtoS(DT_ANTALT)+STR(E5_VALOR, 16, 2)))) 
				RecLock("SE5", .F.)
					SE5->E5_DATA 	:= TTMPSE5->E5_DATA
					SE5->E5_DTDISPO := TTMPSE5->E5_DATA
				MsUnlock()
				nTotal++
			EndIf           
  		EndIf             
 		TTMPSE5->(DbSkip())
	EndDo  
	TTMPSE5->(DbGotop())
	MsgInfo(cValToChar(nTotal) + " Foram alterados com sucesso!"    )
Return()    

User Function UPDATDES()
	If Pergunte("DBALTDESP", .T.) 
		DbSelectArea("TTMPSE5")
		DbGotop()
		While !TTMPSE5->(Eof())  
		  	If !Empty(TTMPSE5->OK) 
				RecLock("TTMPSE5",.F.)		
				TTMPSE5->E5_DATA   	:=  MV_PAR01		
				MsunLock()	
			EndIf
			TTMPSE5->(DbSkip())
   		EndDo   	             
		DbGotop()
		oMark:oBrowse:Refresh()
	EndIf
Return()       


