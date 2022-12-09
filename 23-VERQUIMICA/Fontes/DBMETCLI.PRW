#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH"     
#INCLUDE "RwMake.ch"

/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: DBMETCLI | Autor: Danilo Alves Del Busso      | Data: 20/06/2017 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: |      														   |||
|||			   |      														   |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       | Verquimica                                                    |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/    

User Function DBMETCLI(_codCli, _lojCli)       
Private _cVQAlias 	:=  GetNextAlias()
Private _cVQAli2 	:=  GetNextAlias()
DBCONMETC(_codCli, _lojCli)                   
Return                       

Static Function DBCONMETC(_codCli, _lojCli) 
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
	AADD(_struct,{"CT_DOC"   	,"C"	,TamSX3("CT_DOC")[1]		,0		})
	AADD(_struct,{"CT_SEQUEN"	,"C"	,TamSX3("CT_SEQUEN")[1]		,0		})   
	AADD(_struct,{"CT_DATA"		,"C"	,TamSX3("CT_DATA")[1]		,0		})
	AADD(_struct,{"CT_REGIAO"	,"C"	,TamSX3("CT_REGIAO")[1]		,0		})
	AADD(_struct,{"CT_GRPCLI"   ,"C"	,TamSX3("CT_GRPCLI")[1]		,0		})
	AADD(_struct,{"CT_GRUPO"  	,"C"	,TamSX3("CT_GRUPO")[1]		,2		})
	AADD(_struct,{"CT_PRODUTO"	,"C"	,TamSX3("CT_PRODUTO")[1]	,0		})
	AADD(_struct,{"CT_QUANT" 	,"N"	,TamSX3("CT_QUANT")[1]		,0		})
	AADD(_struct,{"CT_VEND" 	,"C"	,TamSX3("CT_VEND")[1]		,0		})
	
	cArq:=Criatrab(_struct,.T.)
                                                                                                                                                                            	
	DBUSEAREA(.t.,,carq,_cVQAli2)            

	cQuery := " SELECT " + CRLF
	cQuery += " CT_DOC " + CRLF
	cQuery += " ,CT_SEQUEN 	" + CRLF
	cQuery += " ,CT_DATA 	" + CRLF
	cQuery += " ,CT_REGIAO 	" + CRLF
	cQuery += " ,CT_GRPCLI 	" + CRLF
	cQuery += " ,CT_GRUPO 	" + CRLF
	cQuery += " ,CT_PRODUTO " + CRLF
	cQuery += " ,CT_QUANT 	" + CRLF
	cQuery += " ,CT_VEND 	" + CRLF
	cQuery += " FROM SCT010 " + CRLF
	cQuery += " 	WHERE  	" + CRLF
	cQuery += " 	D_E_L_E_T_ <> '*' " + CRLF
	cQuery += " 	AND CT_CLIENTE 	= '" + _codCli + "' " + CRLF
	cQuery += " 	AND CT_LOJA 	= '" + _lojCli + "' " + CRLF

    If Select(_cVQAlias) > 0
		_cVQAlias->(DbCloseArea())
	EndIf     
	
  	TcQuery cQuery New Alias _cVQAlias 
  	  
	While !_cVQAlias->(Eof())     
		DbSelectArea(_cVQAli2)	
		RecLock(_cVQAli2,.T.)		
		(_cVQAli2)->CT_DOC     := _cVQAlias->CT_DOC
		(_cVQAli2)->CT_SEQUEN  := _cVQAlias->CT_SEQUEN
		(_cVQAli2)->CT_DATA    := _cVQAlias->CT_DATA
		(_cVQAli2)->CT_REGIAO  := _cVQAlias->CT_REGIAO
		(_cVQAli2)->CT_GRPCLI  := _cVQAlias->CT_GRPCLI
		(_cVQAli2)->CT_GRUPO   := _cVQAlias->CT_GRUPO
		(_cVQAli2)->CT_PRODUTO := _cVQAlias->CT_PRODUTO
		(_cVQAli2)->CT_QUANT   := _cVQAlias->CT_QUANT
		(_cVQAli2)->CT_VEND    := _cVQAlias->CT_VEND
		MsunLock()	
		_cVQAlias->(DbSkip())
	EndDo           
            

	CpoBro := {{ "OK"		,, "Mark"       ,"@!"},;
			{ "CT_DOC"		,, "Documento" ,"@!"},;  
			{ "CT_SEQUEN"	,, "Sequencia"    ,"@!"},;  
			{ "CT_DATA"		,, "Data"     ,"@!"},;  
			{ "CT_REGIAO"	,, "Regiao"    ,"@!"},;  			
			{ "CT_GRPCLI"	,, "Divisao","@!"},;
			{ "CT_GRUPO"	,, "Grupo Produto" ,"@!"},;
			{ "CT_PRODUTO"	,, "Produto"   ,"@!"},;
			{ "CT_QUANT"	,, "Quantidade"  ,"@E 9,999,999,999,999.99"},;
			{ "CT_VEND"		,, "Vendedor","@!"}}
	
	DEFINE MSDIALOG oDlg TITLE "Metas Cliente" From 1,1 To 650,900 Of oMainWnd PIXEL 

		DbSelectArea(_cVQAli2)
  		DbGotop()	
  		
	    oMark := MsSelect():New(_cVQAli2,"OK","",CpoBro,@lInverte,@cMark,{17,1,350,700},,,,,)      
		oMark:bMark := {| | selec()}  
		oMark:oBrowse:bAllMark := {| | selecAll()}           
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| DBGRVMET()},{|| oDlg:End()},,@aButtons) 
		
		(_cVQAli2)->(DbCloseArea())       
		_cVQAlias->(DbCloseArea())
   		Iif(File(cArq + GetDBExtendsion()),FErase(cArq  + GetDBExtension()) ,Nil)      

Return

Static Function selec()

RecLock((_cVQAli2),.F.)
If Marked("OK")	
	(_cVQAli2)->OK := cMark   
Else	
	(_cVQAli2)->OK := ""
Endif             
MSUNLOCK()

oMark:oBrowse:Refresh()   

Return()   

Static Function selecAll()  
	DbSelectArea(_cVQAli2)
	DbGotop()
	While !(_cVQAli2)->(EoF())	   
		If !Empty((_cVQAli2)->OK) 
			RecLock((_cVQAli2),.F.)
				(_cVQAli2)->OK :=  ""    
   			MsUnlock()   
   		Else
   			RecLock((_cVQAli2),.F.)
				(_cVQAli2)->OK :=  cMark 
   			MsUnlock() 
  		EndIf             
 		(_cVQAli2)->(DbSkip())
	EndDo  
	DbGotop() 
	
Return()     

Static Function DBGRVMET()
 MsgInfo("Gravar Alteracoes")
Return()    