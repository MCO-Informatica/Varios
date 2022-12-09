#Include "Rwmake.ch"             
#Include "Protheus.ch"             
#Include "topconn.ch"                                                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFINR005  บAutor  ณIsaque O Silva	     บ Data ณ  21/12/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio cOMISSOES				   				 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Protheus 11   - Prozyn                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFINR005()

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
Private cPerg      := "RFINR005" 

ValidPerg()

Pergunte(cPerg,.F.)

//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AADD(aSays,OemToAnsi( "  Este programa ira imprimir o Relat๓rio de comiss๕es "))
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
Private _cTitulo1 	:= "Comiss๕es : "+DTOC(MV_PAR01)
Private _cSheet1  	:= "Comiss๕es" 
Private _cFile 
Private _nCole    	:= 0 
Private _aCol     	:= {}  
Private _aCol1     	:= {}  
Private _cAlias0	:= "TMP"
Private _dData 		:= ""
Private _nTMeta 	:= 0
Private _nTBruta 	:= 0
Private _nTLiquida 	:= 0
Private _nMEfici 	:= 0
Private _nTBreak 	:= 0
Private _nTDevol 	:= 0
Private _nTDebito 	:= 0
Private _nTCredito 	:= 0
Private _nTMargem 	:= 0
Private _nTConf 	:= 0
Private _nTPercen 	:= 0
Private _nTComis 	:= 0
Private _nCont		:= 0
Private _nRanking	:= 0
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
AADD(_aStru1,{"TM_RANKING"	   	,"N",03,0})
AADD(_aStru1,{"TM_VEND"	   		,"C",06,0})
AADD(_aStru1,{"TM_GC"	   		,"C",15,0})
AADD(_aStru1,{"TM_META"		   	,"N",16,2})
AADD(_aStru1,{"TM_BRUTA"	   	,"N",16,2})
AADD(_aStru1,{"TM_LIQUIDA" 		,"N",16,2}) 
AADD(_aStru1,{"TM_EFICI"   		,"N",05,2})
AADD(_aStru1,{"TM_BEP	"   	,"N",16,2})
AADD(_aStru1,{"TM_DEVOLU"   	,"N",16,2})
AADD(_aStru1,{"TM_DEBITO"   	,"N",16,2})
AADD(_aStru1,{"TM_CREDITO"  	,"N",16,2})
AADD(_aStru1,{"TM_MARGEM"       ,"N",16,2})
AADD(_aStru1,{"TM_CONFERE"      ,"N",16,2})
AADD(_aStru1,{"TM_PERCEN"     	,"N",6,2})
AADD(_aStru1,{"TM_COMIS"    	,"N",16,2})

_cArq2 := CriaTRAb(_aStru1,.T.)                  
dbUseArea(.T.,,_cArq2,"TRM",.F.,.F.)
//IndRegua("TRM",_cArq2,"TM_BRUTA","D",,"Criando Arquivo Temporario")
   

cQuery0 := "SELECT (CASE WHEN A3_META=0 THEN 0 ELSE VENDA_BRUTA/A3_META END) [EFICIENCIA],(VENDA_LIQUIDA-DEBITO+CREDITO+DEVOLUCAO) [CONFERENCIA],ROUND((case when (VENDA_LIQUIDA-DEBITO+CREDITO+DEVOLUCAO)=0 THEN 0 ELSE (COMISSAO*100)/(VENDA_LIQUIDA-DEBITO+CREDITO+DEVOLUCAO)  END),2) [PERCENTUAL],   * FROM "
//cQuery0 += "(SELECT A3_NREDUZ, A3_META,A3_COD, (SELECT ISNULL(SUM(F2_VALBRUT),0) FROM " +RetSqlName("SF2") + " SF2 WHERE SF2.D_E_L_E_T_='' AND SF2.F2_FILIAL='01' AND F2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " AND (SF2.F2_VEND1=A3_COD OR SF2.F2_VEND2=A3_COD)) [VENDA_BRUTA], "
cQuery0 += "(SELECT A3_NREDUZ, A3_META,A3_COD, (SELECT ISNULL(SUM(F2_VALBRUT),0) FROM " +RetSqlName("SF2") + " SF2 INNER JOIN " +RetSqlName("SE3") + " SE3 ON SE3.E3_NUM = SF2.F2_DOC AND SE3.E3_SERIE= SF2.F2_SERIE AND SF2.D_E_L_E_T_='' AND SF2.F2_FILIAL='01' AND SE3.E3_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " AND SE3.E3_VEND=A3_COD AND SE3.D_E_L_E_T_='') [VENDA_BRUTA], 
cQuery0 += "(SELECT ISNULL(SUM(F2_VALMERC),0) FROM " +RetSqlName("SF2") + " SF2 INNER JOIN " +RetSqlName("SE3") + " SE3 ON SE3.E3_NUM = SF2.F2_DOC AND SE3.E3_SERIE= SF2.F2_SERIE AND SF2.D_E_L_E_T_='' AND SF2.F2_FILIAL='01' AND SE3.E3_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " AND SE3.E3_VEND=A3_COD AND SE3.D_E_L_E_T_='') [VENDA_LIQUIDA], A3_BEP, 
//cQuery0 += "(SELECT ISNULL 	(SUM(F2_VALMERC),0) FROM " +RetSqlName("SF2") + " SF2 WHERE SF2.D_E_L_E_T_='' AND SF2.F2_FILIAL='01' AND F2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " AND (SF2.F2_VEND1=A3_COD OR SF2.F2_VEND2=A3_COD)) [VENDA_LIQUIDA], A3_BEP, " 
cQuery0	+= "(SELECT ISNULL 	(SUM(E3_BASE),0) FROM " +RetSqlName("SE3") + " SE3 WHERE SE3.D_E_L_E_T_='' AND SE3.E3_TIPO ='NCC' AND SE3.E3_VEND = SA3.A3_COD AND SE3.E3_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + ") [DEVOLUCAO], "
cQuery0 += "(SELECT ISNULL 	(SUM(E3_BASE),0) FROM " +RetSqlName("SE3") + " SE3 WHERE SE3.D_E_L_E_T_='' AND SE3.E3_PREFIXO ='REC' AND SE3.E3_VEND = SA3.A3_COD AND SE3.E3_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + ") [CREDITO],  "
cQuery0 += "(SELECT ISNULL 	(SUM(E3_BASE),0) FROM " +RetSqlName("SE3") + " SE3 WHERE SE3.D_E_L_E_T_='' AND SE3.E3_PREFIXO ='RET' AND SE3.E3_VEND = SA3.A3_COD AND SE3.E3_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + ") [DEBITO], "
cQuery0	+= "(select ISNULL 	(sum(E3_BASE),0) FROM " +RetSqlName("SE3") + " SE3 WHERE SE3.D_E_L_E_T_='' AND SE3.E3_VEND =SA3.A3_COD AND SE3.E3_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + ") [LIQUIDO], "
cQuery0 += "(select ISNULL (SUM(E3_COMIS),0) FROM " +RetSqlName("SE3") + " SE3 WHERE SE3.D_E_L_E_T_='' AND SE3.E3_VEND =SA3.A3_COD AND SE3.E3_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + ") [COMISSAO] "
cQuery0 += "FROM " +RetSqlName("SA3") + " SA3 "
cQuery0 += "WHERE SA3.D_E_L_E_T_='' "
cQuery0 += "AND SA3.A3_FILIAL='' "
cQuery0 += "AND SA3.A3_COD BETWEEN '" +MV_PAR03+ "' AND '" +MV_PAR04+ "')  TMP ORDER BY VENDA_BRUTA DESC "


cQuery0 := ChangeQuery(cQuery0)  // padroniza com o banco existente ChangeQuery
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery0),_cAlias0,.T.,.F.)	

DbSelectArea(_cAlias0)
While !eof()
	
	_nRanking ++ 
	_nTMeta 	+= (_cAlias0)->A3_META
 	_nTBruta 	+= (_cAlias0)->VENDA_BRUTA
 	_nTLiquida 	+= (_cAlias0)->VENDA_LIQUIDA
 	
 	If (_cAlias0)->EFICIENCIA > 0
 		_nMEfici 	+= (_cAlias0)->EFICIENCIA
 		_nCont ++	 
 	EndIf

	_nTBreak 	+= (_cAlias0)->A3_BEP
	_nTDevol 	+= (_cAlias0)->DEVOLUCAO
	_nTDebito 	+= (_cAlias0)->DEBITO
	_nTCredito 	+= (_cAlias0)->CREDITO
	_nTMargem 	+= 0
	_nTConf 	+= (_cAlias0)->CONFERENCIA
	_nTPercen 	+= (_cAlias0)->PERCENTUAL
	_nTComis 	+= (_cAlias0)->COMISSAO

	
	RECLOCK("TRM",.T.)   
	TM_FILIAL  	:= xFilial("TRM")
	TM_RANKING	:= _nRanking 
	TM_VEND		:=(_cAlias0)->A3_COD
	TM_GC		:=(_cAlias0)->A3_NREDUZ
	TM_META		:=(_cAlias0)->A3_META
	TM_BRUTA	:=(_cAlias0)->VENDA_BRUTA
	TM_LIQUIDA	:=(_cAlias0)->VENDA_LIQUIDA
	TM_EFICI	:=(_cAlias0)->EFICIENCIA
	TM_BEP		:=(_cAlias0)->A3_BEP
	TM_DEVOLU	:=(_cAlias0)->DEVOLUCAO
	TM_DEBITO	:=(_cAlias0)->DEBITO
	TM_CREDITO	:=(_cAlias0)->CREDITO
	TM_MARGEM	:=0
	TM_CONFERE	:=(_cAlias0)->CONFERENCIA
	TM_PERCEN	:=(_cAlias0)->PERCENTUAL
	TM_COMIS	:=(_cAlias0)->COMISSAO
	MSUNLOCK()    
				
	DbSelectArea(_cAlias0)	 
	DbSkip()

EndDo


oExcel:AddworkSheet(_cSheet1)
oExcel:AddTable(_cSheet1,_cTitulo1)
oExcel:AddColumn(_cSheet1,_cTitulo1,"RANKING"   						,1,1,.F.)  
oExcel:AddColumn(_cSheet1,_cTitulo1,"Cod GC" 							,1,1,.F.) 			
oExcel:AddColumn(_cSheet1,_cTitulo1,"GC" 								,1,2,.F.) 			
oExcel:AddColumn(_cSheet1,_cTitulo1,"Meta Mensal" 						,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Venda Bruta" 						,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Venda Liquida" 					,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Efici๊ncia"			 			,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Break even point" 					,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Devolu็ใo"							,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"D้bitos"			 				,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Cr้ditos"						 	,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Margem Negativa"					,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Confer๊ncia"	 					,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Percentual"	 					,1,2,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"Comissใo"	 						,1,2,.F.)


_nCoEle := 15 
_aCol   := {}
_cCont  := ""
_cCbas  := ""


	
DbSelectArea("TRM") 
dbgotop()  	
While !EOF() 
    
   		 _nPProd := Len(_aCol)+1
			AADD(_aCol,Array(_nCoEle))
			_aCol[_nPProd+00][01]       := TRM->TM_RANKING     
			_aCol[_nPProd+00][02]       := TRM->TM_VEND
			_aCol[_nPProd+00][03]       := TRM->TM_GC
			_aCol[_nPProd+00][04]       := TRM->TM_META
			_aCol[_nPProd+00][05]       := TRM->TM_BRUTA
			_aCol[_nPProd+00][06]       := TRM->TM_LIQUIDA
			_aCol[_nPProd+00][07]       := TRM->TM_EFICI     					
			_aCol[_nPProd+00][08]       := TRM->TM_BEP    					
			_aCol[_nPProd+00][09]       := TRM->TM_DEVOLU   					
			_aCol[_nPProd+00][10]       := TRM->TM_DEBITO   					
			_aCol[_nPProd+00][11]       := TRM->TM_CREDITO    					
			_aCol[_nPProd+00][12]       := TRM->TM_MARGEM   					
			_aCol[_nPProd+00][13]       := TRM->TM_CONFERE  					
			_aCol[_nPProd+00][14]       := TRM->TM_PERCEN					
			_aCol[_nPProd+00][15]       := TRM->TM_COMIS 					
		  //	aFill(_aCol[_nPProd+00],0,15,Len(_aCol[_nPProd+00])-10) 	
				   							
	DbSelectArea("TRM") 
	DbSkip()    
Enddo
TRM->(DbCloseArea()) 
_nMEfici := _nMEfici / _nCont
_x:=1   	
If Len(_aCol) > 0                                            
	_nItens  := 0  
	
	For _x   := 1 To Len(_aCol)
		 

			_nItens++
			oExcel:AddRow(_cSheet1, _cTitulo1, _aCol[_x])	
	Next   
	_nTPercen := round((_nTComis /_nTConf),2)
	oExcel:AddRow(_cSheet1,_cTitulo1,{,,,,,,,,,,,,,,})
	oExcel:AddRow(_cSheet1,_cTitulo1,{"Totais",,,_nTMeta,_nTBruta,_nTLiquida,_nMEfici,_nTBreak,_nTDevol,_nTDebito,_nTCredito,_nTMargem,_nTConf,_nTPercen, _nTComis})
	

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

AADD(aRegs,{cPerg,"01","de Data?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","ate Data ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","de Vendedor?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","ate Vendedor?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
