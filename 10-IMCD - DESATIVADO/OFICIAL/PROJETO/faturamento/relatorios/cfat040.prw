#include "PROTHEUS.CH"
#include "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CFAT040  บAutor  ณ Giane / Fernando   บ Data ณ  07/15/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta de Faturamento. Mostra todos os clientes que      บฑฑ
ฑฑบ          ณ compraram o produto ou o produtos do grupo mes a mes.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Makeni                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CFAT040()
Local aArea := GetArea()
Local cPerg := "CFAT040"

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "CFAT040" , __cUserID )					

Private cTemp := CriaTrab(Nil,.F.)   
Private cGrpAcesso:="" 
Private lGerente  := .f.
Private lVendedor := .f.
Private cSegResp  := ""  
Private cExprGer  := "" 
Private oTmpTable
Private cArqTrab 
    

Private cMVpar01, cMVpar02, cMVpar03, cMVpar04, cMVpar05, cMVpar06, cMVpar07, cMVpar08, cMVpar09, cMVpar10
Private cMVpar11, cMVpar12, cMVpar13, cMVpar14, cMVpar15, cMVpar16, cMVpar17, cMVpar18, cMVpar19

If Pergunte(cPerg,.T.)

    //foi necessario salvar os parametros em variaveis privates, pois os valores estavam sendo perdidos dos mv-par
    cMVpar01 := mv_par01 
    cMVpar02 := mv_par02
    cMVpar03 := mv_par03
    cMVpar04 := mv_par04	
    cMVpar05 := mv_par05
    cMVpar06 := mv_par06
    cMVpar07 := mv_par07
    cMVpar08 := mv_par08
    cMVpar09 := mv_par09
    cMVpar10 := mv_par10
    cMVpar11 := mv_par11
    cMVpar12 := mv_par12
    cMVpar13 := mv_par13
    cMVpar14 := mv_par14
    cMVpar15 := mv_par15
    cMVpar16 := mv_par16
    cMVpar17 := mv_par17  
    cMVpar18 := mv_par18 
    cMVpar19 := mv_par19  
	                                                                                              
	//=========== Regra de Confidencialidade =====================================  
	//aConf := U_Chkcfg(__cUserId)
	//cGrpAcesso:= aConf[1]   

	//If Empty(cGrpAcesso)  
	//   MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Aten็ใo!") 
	//   RestArea( aArea )
	//   Return 
	//Endif 

	//lGerente := aConf[2] 
	//cSegResp := aConf[3]
	//lVendedor := aConf[4] 
	
	//cExprGer := U_fSqlGer( cMVpar11, cMVpar04, cMVpar05 ) //monta o filtro para o gerente, verificando preenchimento dos parametros  
	//============================================================================

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Funcao que realiza o filtro dos movimentos baseado nas perguntas acima, caso tenha dados, abre a tela de visualizacaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  

	RunView()
EndIf

If oTmpTable <> Nil
	oTmpTable:Delete()
	oTmpTable := Nil
Endif

If Select("TSD2") > 0
	TSD2->( dbCloseArea() )
EndIf

If Select(cArqTrab) > 0
	(cArqTrab)->(dbCloseArea())
EndIf


If File(cTemp+GetDBExtension())
	FErase(cTemp+GetDBExtension())
EndIf

If File(cTemp+OrdBagExt())
	FErase(cTemp+OrdBagExt())
EndIf
  
SBM->(DbClearFilter())
SB1->(DbClearFilter())

RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunQuery  บAutor  ณFernando            บ Data ณ  07/15/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta dados a serem exibidos                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunQuery(oGet)
Local lRet    := .T.			//Retorno da Funcao
Local cQry  := ""				//Filtro dos registros
Local nCliPos := 0				//Posicao do cliente
Local nPos    := 0				//Var Auxiliar    
Local nCont   := 0
//Private cAlias := "TSD2" 

oGet:aCols := {{"",0,0,0,0,0,0,0,0,0,0,0,0,.F.}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona registros do item da nota para aglutinacao por clienteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
 nCliPos := aScan( oGet:aHeader,{|x| AllTrim(Upper(x[2])) == "CNREDUZ"})

MontaQry("A","TSD2")

If !Eof()
	oGet:aCols := {}
EndIf

Do While !Eof()   
   
    If TSD2->D2_TOTAL > 0
		If (nPos := aScan(oGet:aCols,{|x| x[nCliPos] == TSD2->A1_NREDUZ}  )) <= 0
			AAdd( oGet:aCols,{TSD2->A1_NREDUZ,0,0,0,0,0,0,0,0,0,0,0,0,.F.})
			nPos := Len(oGet:aCols)
		EndIf           
	
		oGet:aCols[nPos,VAL(TSD2->D2_EMISSAO)+1] := TSD2->D2_TOTAL
	
	    nCont++
	Endif

	dbSkip()
EndDo

oGet:oBrowse:Refresh()
	
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunView   บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta tela do dialog                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunView()
Local oDlg						//Dialogo Principal
Local oGet						//GetDados Principal
Local oPanel					//Painel para escolha do produto
Local aHeader  := {}			//Header do sistema
Local aCols    := {}			//aCols do Sistema
Local aButtons := {}			//Botoes da EnchoiceBar
Local bExcel   := {||}    
Local cFiltro := ""                                             

Private oSayPro					//Objeto do Codigo do produto
Private oSayNom					//Objeto do Nome do produto
Private cSayPro  := Space(15)     //Texto do Codigo do produto
Private cSayNom  := SPACE( TamSX3("B1_DESC")[1] )		//Objeto do Nome do produto 
Private oSayGru					//Objeto do Codigo do grupo do produto
Private oSayDes					//Objeto da descricao do grupo
Private cSayGru  := Space(06)     //Texto do Codigo do grupo do produto
Private cSayDes  := SPACE( TamSX3("BM_GRUPO")[1] )		//Objeto da descricao do grupo

Private cCadastro := "Consulta Faturamento Mensal por Produto/Grupo"  

If cMVpar17 == 1   
   cCadastro += "    -    Demonstrativo por Valores Faturados (R$)"
Else   
   cCadastro += "    -    Demonstrativo por Volume Faturado (KG/L)"
Endif

//Exportacao para o Excel  
If cMVpar10 == 1 //produto
   bExcel   := {||DlgToExcel( {{"ARRAY","Produto",{"Codigo Produto","Descri็ใo"},{{(cArqTrab)->B1_COD,(cArqTrab)->B1_DESC}}},{"GETDADOS","Movimentos",oGet:aHeader,oGet:aCols} }) }
Else 
   //por grupo de produto
     bExcel   := {||DlgToExcel( {{"ARRAY","Grupo Produto",{"Grupo Produto"},{{(cArqTrab)->BM_DESC}}},{"GETDADOS","Movimentos",oGet:aHeader,oGet:aCols} }) }
Endif

AAdd(aHeader,{"Cliente"   , "cNREDUZ" ,"" ,TamSX3("A1_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

AAdd(aHeader,{"Janeiro"   , "nJan"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Fevereiro" , "nFev"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Mar็o"     , "nMar"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Abril"     , "nAbr"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Maio"      , "nMai"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Junho"     , "nJun"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Julho"     , "nJul"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Agosto"    , "nAgo"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Setembro"  , "nSet"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Outubro"   , "nOut"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Novembro"  , "nNov"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
AAdd(aHeader,{"Dezembro"  , "nDez"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})

aCols := {{"",0,0,0,0,0,0,0,0,0,0,0,0,.F.}}

//Definicao de Size da Tela
aSize := MsAdvSize()

//Botoes que complementarao a EnchoiceBar      
If cMVpar10 == 1
	aAdd(aButtons,{'TRILEFT' ,{ || LeftCli(oGet) }  , "Anterior", "Anterior"})
	aAdd(aButtons,{'TRIRIGHT',{ || RightCli(oGet) } , "Pr๓ximo", "Pr๓ximo"})	
Else
    aAdd(aButtons,{'TRILEFT' ,{ || LeftCli(oGet) }  , "Anterior", "Anterior"})
   	aAdd(aButtons,{'TRIRIGHT',{ || RightCli(oGet) } , "Pr๓ximo", "Pr๓ximo"})    
Endif

AAdd(aButtons,{PmsBExcel()[1], bExcel, "Exp.Tela", "Exp.Tela" } ) 
aadd(aButtons,{PmsBExcel()[1],{||Processa( {|lEnd| MontaExcel()}, "Aguarde...","Processando Dados no Excel", .T. ) },"Exp.Todos"}) 

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

oDlg:lMaximized := .T.

@ 500,500 MSPANEL oPanel PROMPT "" SIZE 500,500 OF oDlg RAISED

@013,005 SAY "Produto" PIXEL OF oPanel
@010,030 MSGET oSayPro VAR cSayPro SIZE 60, 10 VALID VldPro(oGet) WHEN cMVpar10 == 1 PIXEL OF oPanel HASBUTTON
@010,095 MSGET oSayNom VAR cSayNom SIZE 170, 10 PIXEL OF oPanel READONLY 

@033,005 SAY "Grupo" PIXEL OF oPanel
@030,030 MSGET oSayGru VAR cSayGru SIZE 60, 10 VALID VldGru(oGet) WHEN cMVpar10 == 2 PIXEL OF oPanel HASBUTTON
@030,095 MSGET oSayDes VAR cSayDes SIZE 100, 10 PIXEL OF oPanel READONLY 

oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

if cMVpar12 == 2 //traz todos os produtos/grupos, com ou sem faturamento  
   
   If cMVpar10 == 2 
      //ver grupo de produtos
      
     // If !lGerente
	      dbSelectArea("SBM")  
    	  dbSetOrder(1)
	      dbSeek( xFilial("SBM") )
	      cFiltro := "BM_GRUPO >= '" + cMVpar08 + "' .AND. BM_GRUPO <= '" + cMVpar09 + "' " 
	      //ChkFile("SBM",.f., "cArqTrab")
      
     /* Else //filtrar os grupos de produtos, cujos produtos sejam do seu segto de responsabilidade
	      cQry := "SELECT DISTINCT SBM.BM_FILIAL, SBM.BM_GRUPO, SBM.BM_DESC FROM "+RetSQLName("SBM")+" SBM "
	      cQry += "INNER JOIN " + RetSQLName("SB1")+" SB1 "  
	      cQry += "  ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
	      cQry += "  AND SB1.B1_GRUPO = SBM.BM_GRUPO " 
	      cQry += "  AND SB1.D_E_L_E_T_ = ' ' "
	      cQry += "WHERE "
	      cQry += "  SBM.BM_GRUPO >= '" + cMVpar08 + "' AND SBM.BM_GRUPO <= '" + cMVpar09 + "' "
	      cQry += "  AND SB1.B1_SEGMENT = '" + cSegResp + "' "		      
          cQry += "  AND SBM.D_E_L_E_T_ = ' ' "
          cQry := ChangeQuery(cQry)
           
          MEMOWRITE("C:\CFAT040.SQL",CQRY)
          
		  cIndice := "BM_FILIAL+BM_GRUPO" 
		  
          If Select("TPRO") > 0
			TPRO->( dbCloseArea() )
		  EndIf

		  TcQuery cQry ALIAS "TPRO" NEW
		  dbGotop()
		  COPY TO &(cTemp)
		  TPRO->( dbCloseArea() )

		  USE &(cTemp) ALIAS "cArqTrab" NEW
		  IndRegua("cArqTrab",cTemp,cIndice)
		  dbGotop()
	  Endif	
	  */
   Else
      //ver produtos
      dbSelectArea("SB1")  
      dbSeek( xFilial("SB1") )
      
  	  cFiltro := "B1_GRUPO >= '" + cMVpar08 + "' .AND. B1_GRUPO <= '" + cMVpar09 + "' " 
      cFiltro += "  .AND. B1_COD >= '"+cMVpar06+"' .AND. B1_COD <= '"+cMVpar07+"' "  	   
	    //if lGerente 			   
	    //   cFiltro += "   .AND. B1_SEGMENT == '" + cSegResp + "' "	
	    //Endif 
	  
	    //OBS: NAO TEM COMO filtrar o segmento no cadastro do produto, para o gerente, pois isso nใo vai trazer os produtos que nao sao do seu
	    //segto responsavel mas que foram vendidos para os clientes do seu segto de vendas.		
 
	    //ChkFile("SB1",.f., "cArqTrab")
    Endif    
    
    (cArqTrab)->( MsFilter( cFiltro))      
   
Else
	//Funcao para criar um temporario para o Cadastro de Produtos/Grupo     
	MsgRun("Processando parโmetros, aguarde...","",{|| CriaProMov() })
	
Endif  

DbSetOrder(1)

If cMVpar10 == 1
	cSayPro := (cArqTrab)->B1_COD
	oSayPro:Refresh()

	cSayNom := (cArqTrab)->B1_DESC
	oSayNom:Refresh()
Else 
	cSayGru := (cArqTrab)->BM_GRUPO
	oSayGru:Refresh()

	cSayDes := (cArqTrab)->BM_DESC
	oSayDes:Refresh()
Endif	

AlignObject( oDlg, {oPanel,oGet:oBrowse}, 1, 2, {100,100} ) 
ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},,aButtons),RunQuery(oGet))

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLeftCli   บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no produto/grupo anterior e monta consulta para   บฑฑ
ฑฑบ          ณeste produto/grupo                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeftCli(oGet)

(cArqTrab)->( dbSkip(-1) )  

If cMVpar10 == 1
	cSayPro := (cArqTrab)->B1_COD
	oSayPro:Refresh()

	cSayNom := (cArqTrab)->B1_DESC
	oSayNom:Refresh()
Else
	cSayGru := (cArqTrab)->BM_GRUPO
	oSayGru:Refresh()

	cSayDes := (cArqTrab)->BM_DESC
	oSayDes:Refresh()
Endif

RunQuery(oGet)          
oGet:oBrowse:SetFocus() 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRightCli  บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no pr๓ximo produto/grupo e monta a consulta para  บฑฑ
ฑฑบ          ณeste produto/grupo                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RightCli(oGet)

(cArqTrab)->( dbSkip() )

If cMVpar10 == 1
	cSayPro := (cArqTrab)->B1_COD
	oSayPro:Refresh()

	cSayNom := (cArqTrab)->B1_DESC
	oSayNom:Refresh() 
Else
	cSayGru := (cArqTrab)->BM_GRUPO
	oSayGru:Refresh()

	cSayDes := (cArqTrab)->BM_DESC
	oSayDes:Refresh()
Endif

RunQuery(oGet)
oGet:oBrowse:SetFocus() 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldPro    บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no produto que o usuario digitar na caixa de      บฑฑ
ฑฑบ          ณ   texto e monta a consulta para este produto               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldPro(oGet)
Local lRet := .T.

(cArqTrab)->( dbSetOrder(1) )
(cArqTrab)->( dbSeek( xFilial("SB1")+cSayPro ))
   	 	
If (cArqTrab)->(Found())		
	cSayPro := (cArqTrab)->B1_COD
	oSayPro:Refresh()	
		
	cSayNom := (cArqTrab)->B1_DESC
	oSayNom:Refresh()
		
	RunQuery(oGet)
	oGet:oBrowse:SetFocus() 
Else
	Help(" ",1,"REGNOIS")
	lRet := .F.
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldGru    บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no grupo do produto que usuแrio digitar na caixa  บฑฑ
ฑฑบ          ณde texto e monta a consulta para este grupo                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldGru(oGet)
Local lRet := .T.

(cArqTrab)->( dbSetOrder(1) )
(cArqTrab)->( dbSeek( xFilial("SBM")+cSayGru ))
   	 	
If (cArqTrab)->(Found())		
	cSayGru := (cArqTrab)->BM_GRUPO
	oSayGru:Refresh()	
		
	cSayDes := (cArqTrab)->BM_DESC
	oSayDes:Refresh()
		
	RunQuery(oGet)
	oGet:oBrowse:SetFocus() 	
Else
	Help(" ",1,"REGNOIS")
	lRet := .F.
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaProMovบAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria um arquivo temporario somente com os produtos/grupos   บฑฑ
ฑฑบ          ณque possuem faturamento                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaProMov()   
Local cQry := ""
Local cIndice     
Local nCont := 0   
Local cAliasInd:= "ITRB"
Local cFile //:= CriaTrab(Nil,.F.)
Local aStru  := {}
Local cTmpAlias := getNextAlias()

If cMVpar10 == 2 
   //============================ POR GRUPO DO PRODUTO ========================================================
  
	cQry := "SELECT DISTINCT "
	cQry += "  SBM.BM_FILIAL, B1_GRUPO BM_GRUPO, SBM.BM_DESC "
	cQry += "FROM "
	cQry += " ( " 	
	cQry += "  SELECT "
	cQry += "    XFAT.B1_GRUPO, XFAT.A1_NREDUZ, XFAT.D2_EMISSAO, SUM(XFAT.D2_TOTAL) D2_TOTAL "
	cQry += "  FROM "
	cQry += "    (
	cQry += "     SELECT "
	cQry += "       SB1.B1_GRUPO, SA1.A1_NREDUZ,SUBSTR(D2_EMISSAO,5,2) AS D2_EMISSAO, "  	
	If cMVpar17 == 1
		cQry += "   SUM(SD2.D2_VALBRUT) AS D2_TOTAL "
	Else
		cQry += "   SUM(SD2.D2_QUANT) AS D2_TOTAL "
	Endif
	cQry += "     FROM "+RetSQLName("SD2")+" SD2 "
	cQry += "      INNER JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQry += "        SF4.F4_FILIAL = D2_FILIAL AND "	//'" + xFilial("SF4") + "' AND "   //JUNIOR 22/06/2018
	cQry += "        SD2.D2_TES = SF4.F4_CODIGO AND "
	cQry += "        SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' AND "  //somente notas fiscais que geram duplicatas e nao de SERVIวO
	cQry += "        SF4.D_E_L_E_T_ = ' ' "
	cQry += "      INNER JOIN "+RetSQLName("SB1")+" SB1 "
	cQry += "        ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	cQry += "        AND SB1.B1_COD = SD2.D2_COD "
	cQry += "        AND SB1.B1_GRUPO BETWEEN '" + cMVpar08 + "' AND '" + cMVpar09 + "' "
	cQry += "        AND SB1.D_E_L_E_T_ = ' ' "
	cQry += "      LEFT JOIN "
	cQry += "       (SELECT DISTINCT A3_FILIAL, A3_CODUSR FROM " + RetSqlName("SA3") + " SA3 "
	cQry += "        WHERE SA3.D_E_L_E_T_ = ' ' ) "
	cQry += "        ON A3_FILIAL = '" + xFilial("SA3") + "' "
	//cQry += "        AND A3_CODUSR = '" + __cUserId + "' "
	cQry += "      INNER JOIN "+RetSQLName("SF2")+" SF2 "
	cQry += "        ON SF2.F2_FILIAL = D2_FILIAL "// '"+xFilial("SF2")+"' "
	cQry += "        AND SF2.F2_DOC = SD2.D2_DOC "
	cQry += "        AND SF2.F2_SERIE = SD2.D2_SERIE "
	cQry += "        AND SF2.F2_VEND1 BETWEEN '"+cMVpar02+"' AND '"+cMVpar03+"' "
	cQry += "        AND SF2.D_E_L_E_T_ = ' ' "
	cQry += "      INNER JOIN "+RetSQLName("SA1")+" SA1 "
	cQry += "        ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cQry += "        AND SA1.A1_COD    = SD2.D2_CLIENTE "
	cQry += "        AND SA1.A1_LOJA   = SD2.D2_LOJA "
	cQry += "        AND SA1.A1_COD BETWEEN '" + cMVpar13 + "' AND '" + cMVpar15 + "' "
	cQry += "        AND SA1.A1_LOJA BETWEEN '" + cMVpar14 + "' AND '" + cMVpar16 + "' "
	cQry += "        AND SA1.A1_GRPVEN BETWEEN '"+cMVpar04+"' AND '"+cMVpar05+"' "
	cQry += "        AND SA1.D_E_L_E_T_ = ' ' "
	cQry += "     WHERE D2_FILIAL BETWEEN '"+cMVpar18+"' AND '"+cMVpar19+"' "  // = '"+xFilial("SD2")+"' "
	cQry += "       AND D2_COD BETWEEN '"+cMVpar06+"' AND '"+cMVpar07+"' "
	cQry += "       AND SD2.D2_TIPO IN ('N','C','I','P') "
	cQry += "       AND SD2.D_E_L_E_T_ = ' ' "
//	If lVendedor .Or. (lGerente .And. Empty(cMVPAR11))
//		cQry += "   AND SA1.A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/")
//	Endif
	
	If !Empty(cMVPAR11)
		cQry += "   AND SB1.B1_SEGMENT = '" + cMVPAR11 + "' "
//		If lGerente
//			cQry += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")
//		Endif
	Endif
	
	cQry += "       AND SUBSTR(D2_EMISSAO,1,4) = '"+cMVpar01+"' "
	cQry += "     GROUP BY B1_GRUPO, A1_NREDUZ, SUBSTR(D2_EMISSAO,5,2) "
	//cQry += "    ORDER BY B1_GRUPO, A1_NREDUZ, D2_EMISSAO "  
	
	cQry += "     UNION ALL "
	//DEVOLUCOES 
	
	cQry += "     SELECT "  + CHR(13) + CHR(10)
	cQry += "       SB1.B1_GRUPO, SA1.A1_NREDUZ,SUBSTR(SD1.D1_DTDIGIT,5,2) AS D2_EMISSAO, "  		
	If cMVpar17 == 1
		cQry += "   SUM((SD1.D1_TOTAL + SD1.D1_VALIPI)* -1) AS D2_TOTAL"  + CHR(13) + CHR(10)	
	Else         
		cQry += "   SUM(SD1.D1_QUANT * -1) AS D2_TOTAL "	 + CHR(13) + CHR(10)
	Endif	
	cQry += "     FROM "  + CHR(13) + CHR(10)
	cQry += "     " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SD2") + " SD2 ON "  + CHR(13) + CHR(10)
	cQry += "        SD2.D2_FILIAL = SD1.D1_FILIAL AND "  + CHR(13) + CHR(10)
	cQry += "        SD1.D1_NFORI = SD2.D2_DOC AND "  + CHR(13) + CHR(10)
	cQry += "        SD1.D1_SERIORI = SD2.D2_SERIE AND "  + CHR(13) + CHR(10)
	cQry += "        SD1.D1_ITEMORI = SD2.D2_ITEM AND "  + CHR(13) + CHR(10)
	cQry += "        SD2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "      JOIN " + RetSqlName("SF2") + " SF2 ON "  + CHR(13) + CHR(10)
	cQry += "        SF2.F2_FILIAL = D1_FILIAL AND " //'"+xFilial("SF2")+"' AND "  + CHR(13) + CHR(10)
	cQry += "        SD1.D1_NFORI = SF2.F2_DOC AND "  + CHR(13) + CHR(10)
	cQry += "        SD1.D1_SERIORI = SF2.F2_SERIE AND "  + CHR(13) + CHR(10)
	cQry += "        SF2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "      JOIN " + RetSqlName("SB1") + " SB1 ON "  + CHR(13) + CHR(10)
	cQry += "        SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "  + CHR(13) +CHR(10)
	cQry += "    	 SD1.D1_COD = SB1.B1_COD AND "  + CHR(13) + CHR(10)
	cQry += "    	 SB1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "      JOIN " + RetSqlName("SA1") + " SA1 ON "  + CHR(13) + CHR(10)
	cQry += "        SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "  + CHR(13) + CHR(10)
	cQry += "        SD1.D1_FORNECE = SA1.A1_COD AND "  + CHR(13) + CHR(10)
	cQry += "        SD1.D1_LOJA = SA1.A1_LOJA AND "  + CHR(13) + CHR(10)
	cQry += "        SA1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "      JOIN " + RetSqlName("SF4") + " SF4 ON "  + CHR(13) + CHR(10)
	cQry += "        SF4.F4_FILIAL = D1_FILIAL AND " //'"+xFilial("SF4")+"' AND "  + CHR(13) + CHR(10)
	cQry += "        SF4.D_E_L_E_T_ = ' ' AND "  + CHR(13) + CHR(10)
	cQry += "        SD1.D1_TES = SF4.F4_CODIGO "  + CHR(13) + CHR(10)
	cQry += "      LEFT JOIN "+RetSQLName("SBM")+" SBM " + CHR(13) + CHR(10)
	cQry += "        ON SBM.BM_FILIAL = '"+xFilial("SBM")+"' "  + CHR(13) + CHR(10)
	cQry += "        AND SB1.B1_GRUPO = SBM.BM_GRUPO "  + CHR(13) + CHR(10)
	cQry += "        AND SBM.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)	
	cQry += "    WHERE "  + CHR(13) + CHR(10)
    cQry += "      SUBSTR(SD1.D1_DTDIGIT,1,4) = '" + cMVpar01 + "' "   + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_FORNECE BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR15 + "' "  + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_LOJA BETWEEN '" + cMVPAR14 + "' AND '" + cMVPAR16 + "' "   + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_FILIAL BETWEEN '"+cMVpar18+"' AND '"+cMVpar19+"' " // = '" + xFilial("SD1") + "' "  + CHR(13) + CHR(10)
	cQry += "      AND SD1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "      AND SF2.F2_VEND1 BETWEEN '"+cMVpar02+"' AND '"+cMVpar03+"' "  + CHR(13) + CHR(10)
	cQry += "      AND SB1.B1_GRUPO BETWEEN '" + cMVpar08 + "' AND '" + cMVpar09 + "' "  + CHR(13) + CHR(10)
	cQry += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S'  "  + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_TIPO = 'D'  "  + CHR(13) + CHR(10)
	cQry += "      AND SA1.A1_GRPVEN BETWEEN '"+cMVpar04+"' AND '"+cMVpar05+"' "  + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_COD BETWEEN '"+cMVpar06+"' AND '"+cMVpar07+"' "  + CHR(13) + CHR(10)
//	If lVendedor .Or. (lGerente .And. Empty(cMVPAR11))
//		cQry += "  AND SA1.A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/")  + CHR(13) + CHR(10)
//	Endif
  
   If !Empty(cMVPAR11)  
      cQry += "    AND SB1.B1_SEGMENT = '" + cMVPAR11 + "' "  + CHR(13) + CHR(10)
//		If lGerente
//			cQry += " AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")  + CHR(13) + CHR(10)
//		Endif
	Endif 
	cQry += "    GROUP BY B1_GRUPO, A1_NREDUZ, SUBSTR(D1_DTDIGIT,5,2) "		
	cQry += "   ) XFAT " 
	cQry += "  WHERE D2_TOTAL > 0	
	cQry += "  GROUP BY B1_GRUPO, A1_NREDUZ, D2_EMISSAO " 
	cQry += "   ) "
	cQry += " INNER JOIN SBM010 SBM ON "
	cQry += " SBM.BM_FILIAL = '  ' AND B1_GRUPO = SBM.BM_GRUPO AND SBM.D_E_L_E_T_ = ' ' "
	cQry += " ORDER BY B1_GRUPO "  	
		
	cIndice := "BM_FILIAL"
	cIndice1 := "BM_GRUPO"
		
Else 
   //============================ POR PRODUTO ========================================================
	
	cQry := "SELECT DISTINCT "
	cQry += "  X.B1_FILIAL, X.B1_COD,	X.B1_DESC "
	cQry += "FROM "   
	cQry += "  ( "                
	
	cQry += "   SELECT "
	cQry += "     XFAT.B1_FILIAL, XFAT.B1_COD, XFAT.B1_DESC, XFAT.A1_NREDUZ, XFAT.D2_EMISSAO, SUM(XFAT.D2_TOTAL) D2_TOTAL "
	cQry += "   FROM "
	cQry += "     ( "
	cQry += "      SELECT
	cQry += "        SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_DESC, SA1.A1_NREDUZ, SUBSTR(D2_EMISSAO,5,2) AS D2_EMISSAO, "
	If cMVpar17 == 1
		cQry += "    SUM(SD2.D2_VALBRUT) AS D2_TOTAL "
	Else
		cQry += "    SUM(SD2.D2_QUANT) AS D2_TOTAL "
	Endif
	cQry += "  	   FROM " + RetSQLName("SD2")+ " SD2 "
	cQry += "	     INNER JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQry += "    	   SF4.F4_FILIAL = D2_FILIAL "  //= '" + xFilial("SF4") + "' "
	cQry += "		   AND SD2.D2_TES = SF4.F4_CODIGO "
	cQry += "		   AND SF4.F4_DUPLIC = 'S' "
	cQry += "		   AND SF4.F4_ISS <> 'S' "
	cQry += "	       AND SF4.D_E_L_E_T_ = ' ' "
	cQry += "	     INNER JOIN " + RetSqlName("SB1") + " SB1 ON  "
	cQry += "		   SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQry += "		   AND SB1.B1_COD = SD2.D2_COD "
	cQry += "		   AND SB1.B1_GRUPO BETWEEN '" + cMVpar08 + "' AND '" + cMVpar09 + "' "
	cQry += "		   AND SB1.D_E_L_E_T_ = ' ' "
//	cQry += "	     LEFT JOIN (SELECT DISTINCT A3_FILIAL, A3_CODUSR FROM "  + RetSqlName("SA3") + " SA3 WHERE SA3.D_E_L_E_T_ = ' ' ) ON "
//	cQry += "		   A3_FILIAL = '  ' AND A3_CODUSR = '" + __cUserId + "' "
	cQry += "	   	 INNER JOIN " + RetSqlName("SF2") + " SF2 ON "
	cQry += "		   SF2.F2_FILIAL  = D2_FILIAL " //'" + xFilial("SF2") + "' "
	cQry += "		   AND SF2.F2_DOC = SD2.D2_DOC "
	cQry += "		   AND SF2.F2_SERIE = SD2.D2_SERIE "
	cQry += "		   AND SF2.D_E_L_E_T_ = ' ' "
	cQry += "		   AND SF2.F2_VEND1 BETWEEN '"+cMVpar02+"' AND '"+cMVpar03+"' "
	cQry += "		 INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQry += "		   SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cQry += "		   AND SA1.A1_COD = SD2.D2_CLIENTE "
	cQry += "		   AND SA1.A1_LOJA = SD2.D2_LOJA "
	cQry += "		   AND SA1.A1_COD BETWEEN '" + cMVpar13 + "' AND '" + cMVpar15 + "' "
	cQry += "		   AND SA1.A1_LOJA BETWEEN '" + cMVpar14 + "' AND '" + cMVpar16 + "' "
	cQry += "		   AND SA1.D_E_L_E_T_ = ' ' "
	cQry += "		   AND SA1.A1_GRPVEN BETWEEN '"+cMVpar04+"' AND '"+cMVpar05+"' "
	cQry += "		 LEFT JOIN " + RetSqlName("SD1") + " SD1 ON "
	cQry += "		   SD1.D1_FILIAL = D2_FILIAL " //'" + xFilial("SD1") + "' "
	cQry += "		   AND SD1.D1_NFORI = SD2.D2_DOC "
	cQry += "		   AND SD1.D1_SERIORI = SD2.D2_SERIE "
	cQry += "          AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_TIPO = 'D' "
	cQry += "		   AND SD1.D_E_L_E_T_ = ' ' "
	cQry += "	   WHERE "
	cQry += "	     D2_FILIAL BETWEEN '"+cMVpar18+"' AND '"+cMVpar19+"' " //= '" + xFilial("SD2") + "' "
	cQry += "	     AND D2_COD BETWEEN '"+cMVpar06+"' AND '"+cMVpar07+"' "
	cQry += "		 AND SD2.D2_TIPO IN ('N','C','I','P') "
	cQry += "		 AND SD2.D_E_L_E_T_ = ' ' "
//	If lVendedor .Or. (lGerente .And. Empty(cMVPAR11))
//		cQry += "    AND SA1.A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/")
//	Endif
	
	If !Empty(cMVPAR11)
		cQry += "    AND SB1.B1_SEGMENT = '" + cMVPAR11 + "' "
//		If lGerente
//			cQry += " AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")
//		Endif
	Endif	
	cQry += "        AND SUBSTR(D2_EMISSAO,1,4) = '"+cMVpar01+"' "
   //	cQry += "      HAVING "
   //	cQry += "	      SUM(SD2.D2_QUANT) > 0  "
	cQry += "      GROUP BY B1_FILIAL, B1_COD, B1_DESC, A1_NREDUZ,SUBSTR(D2_EMISSAO,5,2) "   

	cQry += "      UNION ALL "
	//DEVOLUCOES 
	
	cQry += "      SELECT "  + CHR(13) + CHR(10)
	cQry += "        SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_DESC, SA1.A1_NREDUZ, SUBSTR(D1_DTDIGIT,5,2) AS D2_EMISSAO, "
	If cMVpar17 == 1
		cQry += "    SUM((SD1.D1_TOTAL + SD1.D1_VALIPI)* -1) AS D2_TOTAL"  + CHR(13) + CHR(10)	
	Else         
		cQry += "	 SUM(SD1.D1_QUANT * -1) AS D2_TOTAL "	 + CHR(13) + CHR(10)
	Endif	
	cQry += "      FROM "  + CHR(13) + CHR(10)
	cQry += "     " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SD2") + " SD2 ON "  + CHR(13) + CHR(10)
	cQry += "          SD2.D2_FILIAL = SD1.D1_FILIAL AND "  + CHR(13) + CHR(10)
	cQry += "          SD1.D1_NFORI = SD2.D2_DOC AND "  + CHR(13) + CHR(10)
	cQry += "          SD1.D1_SERIORI = SD2.D2_SERIE AND "  + CHR(13) + CHR(10)
	cQry += "          SD1.D1_ITEMORI = SD2.D2_ITEM AND "  + CHR(13) + CHR(10)
	cQry += "          SD2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "        JOIN " + RetSqlName("SF2") + " SF2 ON "  + CHR(13) + CHR(10)
	cQry += "          SF2.F2_FILIAL = D1_FILIAL " //'"+xFilial("SF2")+"' AND "  + CHR(13) + CHR(10)
	cQry += "          AND SD1.D1_NFORI = SF2.F2_DOC "  + CHR(13) + CHR(10)
	cQry += "          AND SD1.D1_SERIORI = SF2.F2_SERIE "  + CHR(13) + CHR(10)
	cQry += "          AND SF2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "   	  JOIN " + RetSqlName("SB1") + " SB1 ON "  + CHR(13) + CHR(10)
	cQry += "   	    SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "  + CHR(13) + CHR(10)
	cQry += "    	    SD1.D1_COD = SB1.B1_COD AND "  + CHR(13) + CHR(10)
	cQry += "    	    SB1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "        JOIN " + RetSqlName("SA1") + " SA1 ON "  + CHR(13) + CHR(10)
	cQry += "    	    SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "  + CHR(13) + CHR(10)
	cQry += "          SD1.D1_FORNECE = SA1.A1_COD AND "  + CHR(13) + CHR(10)
	cQry += "          SD1.D1_LOJA = SA1.A1_LOJA AND "  + CHR(13) + CHR(10)
	cQry += "          SA1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "        JOIN " + RetSqlName("SF4") + " SF4 ON "  + CHR(13) + CHR(10)
	cQry += "          SF4.F4_FILIAL = D1_FILIAL "//'"+xFilial("SF4")+"' AND "  + CHR(13) + CHR(10)
	cQry += "          AND SF4.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "          AND SD1.D1_TES = SF4.F4_CODIGO "  + CHR(13) + CHR(10)
	cQry += "        LEFT JOIN "+RetSQLName("SBM")+" SBM " + CHR(13) + CHR(10)
	cQry += "          ON SBM.BM_FILIAL = '"+xFilial("SBM")+"' "  + CHR(13) + CHR(10)
	cQry += "          AND SB1.B1_GRUPO = SBM.BM_GRUPO "  + CHR(13) + CHR(10)
	cQry += "          AND SBM.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)	
	cQry += "      WHERE "  + CHR(13) + CHR(10)
    cQry += "         SUBSTR(SD1.D1_DTDIGIT,1,4) = '" + cMVpar01 + "' "   + CHR(13) + CHR(10)
	cQry += "         AND SD1.D1_FORNECE BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR15 + "' "  + CHR(13) + CHR(10)
	cQry += "         AND SD1.D1_LOJA BETWEEN '" + cMVPAR14 + "' AND '" + cMVPAR16 + "' "   + CHR(13) + CHR(10)
	cQry += "         AND SD1.D1_FILIAL BETWEEN '"+cMVpar18+"' AND '"+cMVpar19+"' " //= '" + xFilial("SD1") + "' "  + CHR(13) + CHR(10)
	cQry += "         AND SD1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "         AND SF2.F2_VEND1 BETWEEN '"+cMVpar02+"' AND '"+cMVpar03+"' "  + CHR(13) + CHR(10)
	cQry += "         AND SB1.B1_GRUPO BETWEEN '" + cMVpar08 + "' AND '" + cMVpar09 + "' "  + CHR(13) + CHR(10)
	cQry += "         AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S'  "  + CHR(13) + CHR(10)
	cQry += "         AND SD1.D1_TIPO = 'D'  "  + CHR(13) + CHR(10)
	cQry += "         AND SA1.A1_GRPVEN BETWEEN '"+cMVpar04+"' AND '"+cMVpar05+"' "  + CHR(13) + CHR(10)
	cQry += "         AND SD1.D1_COD BETWEEN '"+cMVpar06+"' AND '"+cMVpar07+"' "  + CHR(13) + CHR(10)
 //	If lVendedor .Or. (lGerente .And. Empty(cMVPAR11))
 //		cQry += "     AND SA1.A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/")  + CHR(13) + CHR(10)
 //	Endif
  
   If !Empty(cMVPAR11)  
      cQry += "       AND SB1.B1_SEGMENT = '" + cMVPAR11 + "' "  + CHR(13) + CHR(10)
 //		If lGerente
 //			cQry += " AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")  + CHR(13) + CHR(10)
 //		Endif
	Endif 
	cQry += "      GROUP BY B1_FILIAL, B1_COD, B1_DESC,	A1_NREDUZ,SUBSTR(D1_DTDIGIT,5,2) "   			
	cQry += "   ) XFAT "
	cQry += "   WHERE D2_TOTAL > 0 "      
    cQry += "   GROUP BY B1_FILIAL, B1_COD, B1_DESC, A1_NREDUZ, D2_EMISSAO	"
	cQry += " )X "
	cQry += "ORDER BY X.B1_FILIAL, X.B1_COD "
	
	cIndice := "B1_FILIAL"
	cIndice1 := "B1_COD" 
Endif

cQry := ChangeQuery(cQry)

memowrite('c:\CFAT040.sql',cqry)

DbUseArea(.T., "TOPCONN", TcGenQry( , , cQry ), cTmpAlias, .T., .f.)

//dbGotop()

If oTmpTable <> Nil
	oTmpTable:Delete()
	oTmpTable := Nil
Endif

cArqTrab := GetNextAlias()
aStru    := (cTmpAlias)->(DBSTRUCT())	
(cTmpAlias)->(dbCloseArea())

oTmpTable := FWTemporaryTable():New( cArqTrab )  
oTmpTable:SetFields(aStru) 
oTmpTable:AddIndex("1", {cIndice , cIndice1})


//------------------
//Criacao da tabela temporaria
//------------------

oTmpTable:Create()  

Processa({||SqlToTrb(cQry, aStru, cArqTrab)})

//COPY TO &(cTemp) VIA __LocalDriver
//TPRO->( dbCloseArea() )
 
//USE &(cTemp) ALIAS "cArqTrab" NEW  VIA  __LocalDriver                                  
//dbUseArea( .T. , __LocalDriver, cTemp+GetDBExtension() , "cArqTrab" , .f. ,.F. )   
//If File(cTemp+OrdBagExt())
//   FErase(cTemp+OrdBagExt())
//Endif

//DbSelectArea("cArqTrab")
//IndRegua("cArqTrab",cTemp,cIndice,,,"Aguarde Indexando...")      

//DbGotop()

Return Nil            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaExcelบAutor  ณGiane               บ Data ณ  20/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o arquivo excel com todos os registros referente aos  บฑฑ
ฑฑบ          ณparametros digitados pelo usuแrio.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaExcel()  

Local cQry := ""    
Local nHandle   := 0
Local cArquivo  := CriaTrab(,.F.) 
Local cDirDocs  := MsDocPath()  
Local cPath     := AllTrim(GetTempPath())    
Local cTipo := ""  
Local cDescr1
Local aCabec := {}
Local cBuffer
Local cCliente
Local cProduto
Local cTipo   
Local cDescr
Local cLinha
Local nQtdReg := 0   
Local aVlrMeses 
Local nX := 0
Local i := 0 
Private cQry := ""    
Private cAlias := "TCON"   

cArquivo += ".CSV"
	
nHandle := FCreate(cDirDocs + "\" + cArquivo)
	
If nHandle == -1
	MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema") 
	Return
EndIf

MontaQry("T","TCON") //monta query com todos os produtos/grupos, para exportar para o excel
COUNT TO nQtdReg                        
ProcRegua(nQtdReg)	

dbGotop()                      
 
If cMVpar10 == 1
   cDescr1 := "Produto"   
else 
   cDescr1 := "Grupo do Produto" 
Endif     
                                                                               
Acabec := {cDescr1,"Cliente","Janeiro","Fevereiro","Mar็o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

FWrite(nHandle, cCadastro) //imprime titulo do relatorio
FWrite(nHandle, CRLF)
FWrite(nHandle, CRLF) 

//imprime subtitulos
FWrite(nHandle, "PRODUTO;; M E S E S " )
FWrite(nHandle, CRLF)
FWrite(nHandle, CRLF) 

cBuffer := "" 
//imprime o cabecalho
For nx := 1 To Len(aCabec)
	If nx == Len(aCabec)
		cBuffer += aCabec[nx]
	Else
		cBuffer += aCabec[nx] + ";"
	EndIf
Next nx

FWrite(nHandle, cBuffer)
FWrite(nHandle, CRLF)   

If cMVpar10 == 1
   cProduto := TCON->B1_COD
Else
   cProduto := TCON->BM_GRUPO
Endif 
cCliente := TCON->A1_NREDUZ

cBuffer := ""     

aVlrMeses := array(12)
aFill(aVlrMeses,0)

Do While !Eof() 
    IncProc()     
    
	If cMVpar10 == 1
		cTipo := TCON->B1_COD
	Else
		cTipo := TCON->BM_GRUPO
	Endif
	
	Do While !Eof() .and. cTipo + TCON->A1_NREDUZ  == cProduto + cCliente    
		aVlrMeses[val(TCON->D2_EMISSAO)] += TCON->D2_TOTAL
		Dbskip()
		If cMVpar10 == 1
			cTipo := TCON->B1_COD
		Else
			cTipo := TCON->BM_GRUPO
		Endif	   
	Enddo	
	
	If cMVpar10 == 1
		cDescr := Posicione("SB1",1,xFilial("SB1") + cProduto , "B1_DESC")
	Else
		cDescr := Posicione("SBM",1,xFilial("SBM") + cProduto, "BM_DESC")
	Endif
	
	FWrite(nHandle, CRLF)
	
	cLinha := cDescr + ";" + cCliente + ";"
	
	For i := 1 to len(aVlrMeses)
		cBuffer += ToXlsFormat(aVlrMeses[i])  + ";"
	Next
	
	FWrite(nHandle, cLinha + cBuffer)  //imprime a linha completa do Item
	
//	If cProduto <> cTipo
//		FWrite(nHandle, CRLF) //caso mude o produto ou grupo do produto, pular uma linha em branco
//	endif
	
	cBuffer := ""
	If cMVpar10 == 1
		cProduto := TCON->B1_COD
	Else
		cProduto := TCON->BM_GRUPO
	Endif
	
	cCliente := TCON->A1_NREDUZ
	aVlrMeses := array(12)
	afill(aVlrMeses,0)
	       
EndDo  

FClose(nHandle)

// copia o arquivo do servidor para o remote
CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)
	
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPath + cArquivo)
oExcelApp:SetVisible(.T.)
oExcelApp:Destroy()
	
If Select("TCON") > 0
	TCON->( dbCloseArea() )
EndIf 

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaQry  บAutor  ณGiane               บ Data ณ  21/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta a query de acordo com os parametros informados        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                              
Static Function MontaQry(cTipo,cAlias)  
Local cQry := ""

If cMVpar10 == 2 // a consulta deverแ ser agrupada pelo grupo de produto e nใo pelo produto
    
    cQry := "SELECT "
    cQry += "  XFAT.BM_GRUPO, XFAT.A1_NREDUZ, XFAT.D2_EMISSAO, SUM(XFAT.D2_TOTAL) D2_TOTAL "
    cQry += "FROM "
    cQry += "  ( "
	cQry += "   SELECT "
	cQry += "     SB1.B1_GRUPO BM_GRUPO, SA1.A1_NREDUZ,SUBSTR(D2_EMISSAO,5,2) AS D2_EMISSAO, "
	
	If cMVpar17 == 1
		cQry += " SUM(SD2.D2_VALBRUT) AS D2_TOTAL "
	Else
		cQry += " SUM(SD2.D2_QUANT) AS D2_TOTAL "
	Endif
	cQry += "   FROM "+RetSQLName("SD2")+" SD2 "
	cQry += "     INNER JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQry += "      SF4.F4_FILIAL = SD2.D2_FILIAL " //'" + xFilial("SF4") + "' AND "
	cQry += "      AND SF4.F4_CODIGO = SD2.D2_TES "
	cQry += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVIวO
	cQry += "      AND SF4.D_E_L_E_T_ = ' ' "
	cQry += "     INNER JOIN "+RetSQLName("SB1")+" SB1 "
	cQry += "      ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	cQry += "      AND SB1.B1_COD = SD2.D2_COD "
	cQry += "      AND SB1.B1_GRUPO BETWEEN '" + cMVpar08 + "' AND '" + cMVpar09 + "' "
	If cTipo <> "T"
		cQry += "  AND SB1.B1_GRUPO = '"+(cArqTrab)->BM_GRUPO + "' "//codigo do GRUPO igual ao que estแ posicionado na tabela de GRUPOS
	Endif
	cQry += "      AND SB1.D_E_L_E_T_ = ' ' "
 //	cQry += "     LEFT JOIN "                                            // CUIDADO COM ESSA PARTE
 //	cQry += "      (SELECT DISTINCT A3_FILIAL, A3_CODUSR FROM " + RetSqlName("SA3") + " SA3 "
 //	cQry += "      WHERE SA3.D_E_L_E_T_ = ' ' ) "
 //	cQry += "      ON A3_FILIAL = '" + xFilial("SA3") + "' "
 //	cQry += "      AND A3_CODUSR = '" + __cUserId + "' "
	cQry += "     INNER JOIN "+RetSQLName("SF2")+" SF2 "
	cQry += "      ON SF2.F2_FILIAL = SD2.D2_FILIAL " //= '"+xFilial("SF2")+"' "
	cQry += "      AND SF2.F2_DOC = SD2.D2_DOC "
	cQry += "      AND SF2.F2_SERIE = SD2.D2_SERIE "
	cQry += "      AND SF2.F2_VEND1 BETWEEN '"+cMVpar02+"' AND '"+cMVpar03+"' "
	cQry += "      AND SF2.D_E_L_E_T_ = ' ' "
	cQry += "     INNER JOIN "+RetSQLName("SA1")+" SA1 "
	cQry += "      ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cQry += "      AND SA1.A1_COD    = SD2.D2_CLIENTE "
	cQry += "      AND SA1.A1_LOJA   = SD2.D2_LOJA "
	cQry += "      AND SA1.A1_COD BETWEEN '" + cMVpar13 + "' AND '" + cMVpar15 + "' "
	cQry += "      AND SA1.A1_LOJA BETWEEN '" + cMVpar14 + "' AND '" + cMVpar16 + "' "
	cQry += "      AND SA1.A1_GRPVEN BETWEEN '"+cMVpar04+"' AND '"+cMVpar05+"' "
	cQry += "      AND SA1.D_E_L_E_T_ = ' ' "
	cQry += "   WHERE D2_FILIAL BETWEEN '"+cMVpar18+"' AND '"+cMVpar19+"' " //= '"+xFilial("SD2")+"' "
	cQry += "     AND D2_COD BETWEEN '"+cMVpar06+"' AND '"+cMVpar07+"' "
	cQry += "     AND SD2.D2_TIPO IN ('N','C','I','P') "
	cQry += "     AND SD2.D_E_L_E_T_ = ' ' "
//	If lVendedor .Or. (lGerente .And. Empty(cMVPAR11))
//		cQry += " AND SA1.A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/")
//	Endif
	
	If !Empty(cMVPAR11)
		cQry += " AND SB1.B1_SEGMENT = '" + cMVPAR11 + "' "
		If lGerente
			cQry += " AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")
		Endif
	Endif
	
	cQry += "     AND SUBSTR(D2_EMISSAO,1,4) = '"+cMVpar01+"' "
	cQry += "   GROUP BY B1_GRUPO, SA1.A1_NREDUZ, SUBSTR(D2_EMISSAO,5,2) "
	
	cQry += "   UNION ALL "
	//DEVOLUCOES 
	
	cQry += "   SELECT "  + CHR(13) + CHR(10)
	cQry += "     SB1.B1_GRUPO BM_GRUPO, SA1.A1_NREDUZ,SUBSTR(SD1.D1_DTDIGIT,5,2) AS D2_EMISSAO, "  		
	If cMVpar17 == 1
		cQry += " SUM((SD1.D1_TOTAL + SD1.D1_VALIPI)* -1) AS D2_TOTAL"  + CHR(13) + CHR(10)	
	Else         
		cQry += " SUM(SD1.D1_QUANT * -1) AS D2_TOTAL "	 + CHR(13) + CHR(10)
	Endif	
	cQry += "   FROM "  + CHR(13) + CHR(10)
	cQry += "     " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SD2") + " SD2 ON "  + CHR(13) + CHR(10)
	cQry += "        SD2.D2_FILIAL = SD1.D1_FILIAL AND "  + CHR(13) + CHR(10)
	cQry += "        SD2.D2_DOC = SD1.D1_NFORI AND "  + CHR(13) + CHR(10)
	cQry += "        SD2.D2_SERIE = SD1.D1_SERIORI AND "  + CHR(13) + CHR(10)
	cQry += "        SD2.D2_ITEM = SD1.D1_ITEMORI AND "  + CHR(13) + CHR(10)
	cQry += "        SD2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     JOIN " + RetSqlName("SF2") + " SF2 ON "  + CHR(13) + CHR(10)
	cQry += "        SF2.F2_FILIAL = SD1.D1_FILIAL " //= '"+xFilial("SF2")+"' AND "  + CHR(13) + CHR(10)
	cQry += "        AND SF2.F2_DOC = SD1.D1_NFORI "  + CHR(13) + CHR(10)
	cQry += "        AND SF2.F2_SERIE = SD1.D1_SERIORI "  + CHR(13) + CHR(10)
	cQry += "        AND SF2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     JOIN " + RetSqlName("SB1") + " SB1 ON "  + CHR(13) + CHR(10)
	cQry += "        SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "  + CHR(13) +CHR(10)
	cQry += "    	 SB1.B1_COD = SD1.D1_COD AND "  + CHR(13) + CHR(10)
	cQry += "    	 SB1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     JOIN " + RetSqlName("SA1") + " SA1 ON "  + CHR(13) + CHR(10)
	cQry += "        SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "  + CHR(13) + CHR(10)
	cQry += "        SA1.A1_COD = SD1.D1_FORNECE AND "  + CHR(13) + CHR(10)
	cQry += "        SA1.A1_LOJA = SD1.D1_LOJA AND "  + CHR(13) + CHR(10)
	cQry += "        SA1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     JOIN " + RetSqlName("SF4") + " SF4 ON "  + CHR(13) + CHR(10)
	cQry += "        SF4.F4_FILIAL = D1_FILIAL " //'"+xFilial("SF4")+"' AND "  + CHR(13) + CHR(10)
	cQry += "        AND SF4.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "        AND SF4.F4_CODIGO = SD1.D1_TES "  + CHR(13) + CHR(10)
	cQry += "      LEFT JOIN "+RetSQLName("SBM")+" SBM " + CHR(13) + CHR(10)
	cQry += "        ON SBM.BM_FILIAL = '"+xFilial("SBM")+"' "  + CHR(13) + CHR(10)
	cQry += "        AND SB1.B1_GRUPO = SBM.BM_GRUPO "  + CHR(13) + CHR(10)
	cQry += "        AND SBM.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)	
	cQry += "    WHERE "  + CHR(13) + CHR(10)
    cQry += "      SUBSTR(SD1.D1_DTDIGIT,1,4) = '" + cMVpar01 + "' "   + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_FORNECE BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR15 + "' "  + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_LOJA BETWEEN '" + cMVPAR14 + "' AND '" + cMVPAR16 + "' "   + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_FILIAL BETWEEN '"+cMVpar18+"' AND '"+cMVpar19+"' " //= '" + xFilial("SD1") + "' "  + CHR(13) + CHR(10)
	cQry += "      AND SD1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "      AND SF2.F2_VEND1 BETWEEN '"+cMVpar02+"' AND '"+cMVpar03+"' "  + CHR(13) + CHR(10)
	cQry += "      AND SB1.B1_GRUPO BETWEEN '" + cMVpar08 + "' AND '" + cMVpar09 + "' "  + CHR(13) + CHR(10) 
	If cTipo <> "T"
		cQry += "  AND SB1.B1_GRUPO = '"+(cArqTrab)->BM_GRUPO + "' "//codigo do GRUPO igual ao que estแ posicionado na tabela de GRUPOS
	Endif	
	cQry += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S'  "  + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_TIPO = 'D'  "  + CHR(13) + CHR(10)
	cQry += "      AND SA1.A1_GRPVEN BETWEEN '"+cMVpar04+"' AND '"+cMVpar05+"' "  + CHR(13) + CHR(10)
	cQry += "      AND SD1.D1_COD BETWEEN '"+cMVpar06+"' AND '"+cMVpar07+"' "  + CHR(13) + CHR(10)
//	If lVendedor .Or. (lGerente .And. Empty(cMVPAR11))
//		cQry += "  AND SA1.A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/")  + CHR(13) + CHR(10)
//	Endif
  
   If !Empty(cMVPAR11)  
      cQry += "    AND SB1.B1_SEGMENT = '" + cMVPAR11 + "' "  + CHR(13) + CHR(10)
//		If lGerente
//			cQry += " AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")  + CHR(13) + CHR(10)
//		Endif
	Endif 
	cQry += "    GROUP BY B1_GRUPO, A1_NREDUZ, SUBSTR(D1_DTDIGIT,5,2) "		
	cQry += "  ) XFAT "
	cQry += " GROUP BY BM_GRUPO, A1_NREDUZ, D2_EMISSAO "			
	cQry += " ORDER BY BM_GRUPO, A1_NREDUZ, D2_EMISSAO "	
   //	cQry += " ORDER BY B1_GRUPO, A1_NREDUZ, D2_EMISSAO "
	
Else //agrupa pelo produto (b1_cod) 
    cQry := "SELECT "
    cQry += "  XFAT.B1_COD, XFAT.A1_NREDUZ, XFAT.D2_EMISSAO, SUM(XFAT.D2_TOTAL) D2_TOTAL "
    cQry += "FROM "
    cQry += "  ( " 
	cQry += "   SELECT "
	cQry += "     SB1.B1_COD, SA1.A1_NREDUZ, SUBSTR(D2_EMISSAO,5,2) AS D2_EMISSAO, "
	If cMVpar17 == 1
		cQry += " SUM(SD2.D2_VALBRUT) AS D2_TOTAL "
	Else
		cQry += " SUM(SD2.D2_QUANT) AS D2_TOTAL "
	Endif
	cQry += "   FROM "+RetSQLName("SD2")+" SD2 "
	cQry += "    INNER JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQry += "      SD2.D2_FILIAL = SF4.F4_FILIAL " //'" + xFilial("SF4") + "' AND "
	cQry += "      AND SD2.D2_TES = SF4.F4_CODIGO "
	cQry += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVIวO
	cQry += "      AND SF4.D_E_L_E_T_ = ' ' "
	cQry += "    INNER JOIN "+RetSQLName("SB1")+" SB1 "
	cQry += "      ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	cQry += "      AND SB1.B1_COD = SD2.D2_COD "
	cQry += "      AND SB1.B1_GRUPO BETWEEN '" + cMVpar08 + "' AND '" + cMVpar09 + "' "
	cQry += "      AND SB1.D_E_L_E_T_ = ' ' "
//	cQry += "    LEFT JOIN "
//	cQry += "      (SELECT DISTINCT A3_FILIAL, A3_CODUSR FROM " + RetSqlName("SA3") + " SA3 "
//	cQry += "       WHERE SA3.D_E_L_E_T_ = ' ' ) "
//	cQry += "      ON A3_FILIAL = '" + xFilial("SA3") + "' "
//	cQry += "      AND A3_CODUSR = '" + __cUserId + "' "
	cQry += "    INNER JOIN "+RetSQLName("SF2")+" SF2 "
	cQry += "      ON SF2.F2_FILIAL = SD2.D2_FILIAL " //= '"+xFilial("SF2")+"' "
	cQry += "      AND SF2.F2_DOC = SD2.D2_DOC "
	cQry += "      AND SF2.F2_SERIE = SD2.D2_SERIE "
	cQry += "      AND SF2.F2_VEND1 BETWEEN '"+cMVpar02+"' AND '"+cMVpar03+"' "
	cQry += "      AND SF2.D_E_L_E_T_ = ' ' "
	cQry += "    INNER JOIN "+RetSQLName("SA1")+" SA1 "
	cQry += "      ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cQry += "      AND SA1.A1_COD    = SD2.D2_CLIENTE "
	cQry += "      AND SA1.A1_LOJA   = SD2.D2_LOJA "
	cQry += "      AND SA1.A1_COD BETWEEN '" + cMVpar13 + "' AND '" + cMVpar15 + "' "
	cQry += "      AND SA1.A1_LOJA BETWEEN '" + cMVpar14 + "' AND '" + cMVpar16 + "' "
	cQry += "      AND SA1.A1_GRPVEN BETWEEN '"+cMVpar04+"' AND '"+cMVpar05+"' "
	cQry += "      AND SA1.D_E_L_E_T_ = ' ' "
	cQry += "    LEFT JOIN "+RetSQLName("SD1")+" SD1 "
	cQry += "      ON SD1.D1_FILIAL = SD2.D2_FILIAL " //= '"+xFilial("SD1")+"' "
	cQry += "      AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE "
	cQry += "      AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_TIPO = 'D' "
	cQry += "      AND SD1.D_E_L_E_T_ = ' ' "
	cQry += "   WHERE SD2.D2_FILIAL BETWEEN '"+cMVpar18+"' AND '"+cMVpar19+"' " //= '"+xFilial("SD2")+"' "
	cQry += "     AND SD2.D2_COD BETWEEN '"+cMVpar06+"' AND '"+cMVpar07+"' "
	cQry += "     AND SD2.D2_TIPO IN ('N','C','I','P') "
	cQry += "     AND SD2.D_E_L_E_T_ = ' ' "
 //	If lVendedor .Or. (lGerente .And. Empty(cMVPAR11))
 //		cQry += " AND SA1.A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/")
 //	Endif
	
	If !Empty(cMVPAR11)
		cQry += " AND SB1.B1_SEGMENT = '" + cMVPAR11 + "' "
//		If lGerente
//			cQry += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")
//		Endif
	Endif
	
	If cTipo <> "T"
		cQry += " AND D2_COD = '"+(cArqTrab)->B1_COD+"' "
	Endif
	cQry += "     AND SUBSTR(D2_EMISSAO,1,4) = '"+cMVpar01+"' "
	cQry += "   GROUP BY B1_COD, A1_NREDUZ, SUBSTR(D2_EMISSAO,5,2) "
	cQry += "   UNION ALL "
	//DEVOLUCOES 
	
	cQry += "   SELECT "  + CHR(13) + CHR(10)
	cQry += "     SB1.B1_COD, SA1.A1_NREDUZ, SUBSTR(D1_DTDIGIT,5,2) AS D2_EMISSAO, "
	If cMVpar17 == 1
		cQry += " SUM((SD1.D1_TOTAL + SD1.D1_VALIPI)* -1) AS D2_TOTAL"  + CHR(13) + CHR(10)	
	Else         
		cQry += " SUM(SD1.D1_QUANT * -1) AS D2_TOTAL "	 + CHR(13) + CHR(10)
	Endif	
	cQry += "   FROM "  + CHR(13) + CHR(10)
	cQry += "     " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SD2") + " SD2 ON "  + CHR(13) + CHR(10)
	cQry += "       SD2.D2_FILIAL = SD1.D1_FILIAL AND "  + CHR(13) + CHR(10)
	cQry += "       SD2.D2_DOC = SD1.D1_NFORI AND "  + CHR(13) + CHR(10)
	cQry += "       SD2.D2_SERIE = SD1.D1_SERIORI AND "  + CHR(13) + CHR(10)
	cQry += "       SD2.D2_ITEM = SD1.D1_ITEMORI AND "  + CHR(13) + CHR(10)
	cQry += "       SD2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     JOIN " + RetSqlName("SF2") + " SF2 ON "  + CHR(13) + CHR(10)
	cQry += "       SF2.F2_FILIAL = SD1.D1_FILIAL " //'"+xFilial("SF2")+"' AND "  + CHR(13) + CHR(10)
	cQry += "       AND SF2.F2_DOC = SD1.D1_NFORI "  + CHR(13) + CHR(10)
	cQry += "       AND SF2.F2_SERIE = SD1.D1_SERIORI "  + CHR(13) + CHR(10)
	cQry += "       AND SF2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     JOIN " + RetSqlName("SB1") + " SB1 ON "  + CHR(13) + CHR(10)
	cQry += "       SB1.B1_FILIAL = '"+xFilial("SB1")+"' "  + CHR(13) + CHR(10)
	cQry += "       AND SD1.D1_COD = SB1.B1_COD "  + CHR(13) + CHR(10)
	cQry += "       AND SB1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     JOIN " + RetSqlName("SA1") + " SA1 ON "  + CHR(13) + CHR(10)
	cQry += "       SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "  + CHR(13) + CHR(10)
	cQry += "       SD1.D1_FORNECE = SA1.A1_COD AND "  + CHR(13) + CHR(10)
	cQry += "       SD1.D1_LOJA = SA1.A1_LOJA AND "  + CHR(13) + CHR(10)
	cQry += "       SA1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     JOIN " + RetSqlName("SF4") + " SF4 ON "  + CHR(13) + CHR(10)
	cQry += "       SF4.F4_FILIAL = D1_FILIAL AND " //'"+xFilial("SF4")+"' AND "  + CHR(13) + CHR(10)
	cQry += "       SF4.D_E_L_E_T_ = ' ' AND "  + CHR(13) + CHR(10)
	cQry += "       SD1.D1_TES = SF4.F4_CODIGO "  + CHR(13) + CHR(10)
	cQry += "     LEFT JOIN "+RetSQLName("SBM")+" SBM " + CHR(13) + CHR(10)
	cQry += "       ON SBM.BM_FILIAL = '"+xFilial("SBM")+"' "  + CHR(13) + CHR(10)
	cQry += "       AND SB1.B1_GRUPO = SBM.BM_GRUPO "  + CHR(13) + CHR(10)
	cQry += "       AND SBM.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)	
	cQry += "   WHERE "  + CHR(13) + CHR(10)
    cQry += "     SUBSTR(SD1.D1_DTDIGIT,1,4) = '" + cMVpar01 + "' "   + CHR(13) + CHR(10)
	cQry += "     AND SD1.D1_FORNECE BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR15 + "' "  + CHR(13) + CHR(10)
	cQry += "     AND SD1.D1_LOJA BETWEEN '" + cMVPAR14 + "' AND '" + cMVPAR16 + "' "   + CHR(13) + CHR(10)
	cQry += "     AND SD1.D1_FILIAL BETWEEN '"+cMVpar18+"' AND '"+cMVpar19+"' " // '" + xFilial("SD1") + "' "  + CHR(13) + CHR(10)
	cQry += "     AND SD1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQry += "     AND SF2.F2_VEND1 BETWEEN '"+cMVpar02+"' AND '"+cMVpar03+"' "  + CHR(13) + CHR(10)
	cQry += "     AND SB1.B1_GRUPO BETWEEN '" + cMVpar08 + "' AND '" + cMVpar09 + "' "  + CHR(13) + CHR(10)
	cQry += "     AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S'  "  + CHR(13) + CHR(10)
	cQry += "     AND SD1.D1_TIPO = 'D'  "  + CHR(13) + CHR(10)
	cQry += "     AND SA1.A1_GRPVEN BETWEEN '"+cMVpar04+"' AND '"+cMVpar05+"' "  + CHR(13) + CHR(10)
	cQry += "     AND SD1.D1_COD BETWEEN '"+cMVpar06+"' AND '"+cMVpar07+"' "  + CHR(13) + CHR(10)
//	If lVendedor .Or. (lGerente .And. Empty(cMVPAR11))
//		cQry += " AND SA1.A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/")  + CHR(13) + CHR(10)
//	Endif
  
   If !Empty(cMVPAR11)  
      cQry += "   AND SB1.B1_SEGMENT = '" + cMVPAR11 + "' "  + CHR(13) + CHR(10)
//		If lGerente
//			cQry += " AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")  + CHR(13) + CHR(10)
//		Endif
	Endif 
	
	If cTipo <> "T"
		cQry += " AND D1_COD = '"+(cArqTrab)->B1_COD+"' "
	Endif	
	cQry += "   GROUP BY B1_COD, A1_NREDUZ, SUBSTR(D1_DTDIGIT,5,2) "	
	cQry += " ) XFAT "
	cQry += " GROUP BY B1_COD, A1_NREDUZ, D2_EMISSAO "
	cQry += " ORDER BY B1_COD, A1_NREDUZ, D2_EMISSAO "
	    
Endif

cQry := ChangeQuery(cQry)    

memowrite("c:\MSIGA\CFAT040.sql",cqry)

If Select(cAlias) > 0
	(cAlias)->( dbCloseArea() )
EndIf

TcQuery cQry ALIAS (cAlias) NEW

dbGotop()

Return    

