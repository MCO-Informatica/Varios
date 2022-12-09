#include "protheus.ch"
////////////////////////////////////////////////////////////////////////////////////////////////////
//+----------------------------------------------------------------------------------------------+//
//|Programa  | MAX_002          | Autor | Ewerton F Brasiliano           | Data | 18/06/2015     |//
//+----------------------------------------------------------------------------------------------+//
//|Descricao | Rotina para gerar Tabela simples para aCols e preencheimento de Zk5.              |//
//+----------------------------------------------------------------------------------------------+//
//|Uso       | MAXLOVE                                                                           |//
//+----------------------------------------------------------------------------------------------+//
//|Inf.Compl.| Mcinfotec                                                                         |//
//+----------------------------------------------------------------------------------------------+//
//|Data      |Consultor    |Descricao da Alteracao                     |Solicitante    |Cod.Mod  |//
//+----------------------------------------------------------------------------------------------+//
////////////////////////////////////////////////////////////////////////////////////////////////////

User Function MAX_002()

Local cAlias    := "ZK5"
Local nUsado    := 0 
Local nParcelas := 0
Local nAct      := 0 
Local aRet      := {}
Local aParamBox := {}
Local lRet      := .T.
Local cTitAcols := "Altera Display Max Love"
Local nI,oDlg,oGetEF3   
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE   
Local cCodigo	 := Space(06)
Local cEdit1	 := Space(50)
Local cEdit2	 := CTOD('  /  /    ')
Local oCodigo
Local oEdit1
Local oEdit2 
Local Nx1,Nx2,Nx3,Nx4 
Local ol:=1
Public aCols:={}
Public aDadosX1:={}
Public aHeader:={}
PUBLIC N1,N2,N3,N4
public Nx1,Nx2,Nx3,Nx4 
PUBLIC cCodigo
Public TRB1		:= GetNextAlias()	
Public TRB2		:= GetNextAlias()	
                                                
	
	cCodigo:=cvaltochar(ZK7->ZK7_CODIGO)	 
    	
    cQuery := "SELECT ZK5_CODIGO,ZK5_DESC,ZK5_DVAL,ZK5_CODPRO,ZK5_DPROD,ZK5_QUANT,ZK5_PRVEND FROM"  + RetSqlName("ZK5")  
	cQuery += " WHERE ZK5_CODIGO='"+cCodigo+"' AND D_E_L_E_T_ = ''"
 
 	cQuery := ChangeQuery(cQuery)                                                                                            
	
	If Select("QRY") > 0
 		QRY->(dbCloseArea())
	EndIf                                                 

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'QRY', .F., .T.)
	 
      While QRY->(!EOF()) 	
	QRY->(aAdd(aDadosX1,{ 	ZK5_CODIGO,ZK5_DESC,ZK5_DVAL,ZK5_CODPRO,ZK5_DPROD,ZK5_QUANT,ZK5_PRVEND}))
	QRY->(DbSkip())
	  End
	       
//-- [Inicio] Montagem de aHeader para aCols
nUsado:= faHeader(cAlias)
//-- [Fim] Montagem de aHeader para aCols
//-- [Inicio] Montagem do aCols
faCols(nUsado)
//-- [Fim] Montagem do aCols
	
DEFINE MSDIALOG oDlg TITLE cTitAcols FROM 00,00 TO 345,840 PIXEL   
cCodigo:=cvaltochar(ZK7->ZK7_CODIGO)

//dbselectarea("ZK5") 
//dbsetorder(3)
//dbseek(CVALTOCHAR(cCodigo))
//ZK5->(Dbgotop())

cedit1:=ZK7->ZK7_DESC
cedit2:=ZK7->ZK7_DVAL

    @ C(004),C(006) Say "Codigo :" Size C(016),C(008) COLOR CLR_BLACK PIXEL OF oDlg
  	@ C(004),C(025) MsGet oCodigo Var cCodigo Size C(020),C(009) COLOR CLR_BLACK PIXEL OF oDlg //PIXEL WHEN .F. 
	@ C(004),C(065) Say "Descrição:" Size C(021),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(004),C(095) MsGet oEdit1 Var cEdit1 Size C(125),C(009) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(004),C(230) Say "Vigência:" Size C(024),C(008) COLOR CLR_BLACK PIXEL OF oDlg   
	@ C(004),C(255) MsGet oEdit2 Var cEdit2 Size C(60),C(009) COLOR CLR_BLACK PIXEL OF oDlg

	// Chamadas das ListBox do Sistema

oGetEF3    := MsNewGetDados():New(30, 04, 145, 420,nOpc,'AllwaysTrue()','AllwaysTrue()','',{"ZK5_PRVEND"},0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg,aHeader,aCols )
//    oGetEF3 := MsGetDados():New(05, 05, 145, 420,nOpc,"ALLWAYSTRUE","ALLWAYSTRUE","",.F.,{"ZK5_PRVEND"},, .T., len(aCols),"ALLWAYSTRUE", "",, /*"U_fDELOK*/, oDlg)
    oBtnTl  := tButton():New( 155, 05, "Confima",oDlg,{||nAct:=1,oDlg:end()},45,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    oBtnTl  := tButton():New( 155, 53, "Sair",oDlg,{||oDlg:end()},45,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    
  //	oBtn1      := TButton():New( 272,356,"Confirma",oDlg,{|| If(fAtuSD4(aDados),oDlg:End(),"") },049,012,,oFont,,.T.,,"",,,,.F. )
ACTIVATE MSDIALOG oDlg CENTERED
	
//-- Executar a inclusão rotina de gravação
If lRet .and. nAct = 1 
	MsgInfo("Efetuar gravação de informações...") 
    aItens:=oGetEF3:aCols
		
		
	        	RecLock("ZK7",.F.)
			    fl1:=XFILIAL('ZK7') 
			    ZK7->ZK7_FILIAL:=fl1
                ZK7->ZK7_CODIGO :=cCODIGO
                ZK7->ZK7_DESC   :=cEdit1
                ZK7->ZK7_DVAL   :=cEdit2
                MsUnlock("ZK7") 

dbselectarea("ZK5") 
Posicione("ZK5",2,XFILIAL("ZK5")+cCODIGO+aDadosX1[1,4],"ZK5_CODIGO")

//While ZK5->(!EoF())
//ol++  
FOR ol =1 TO len(aItens)

//////
/////
////  Acols Pedidos
//    

Nx1:=oGetEF3:aCols[ol,1]
Nx2:=oGetEF3:aCols[ol,2]
Nx3:=oGetEF3:aCols[ol,3]
Nx4:=oGetEF3:aCols[ol,4]
                             
                          
			     RecLock("ZK5",.F.)
			    fl1:=XFILIAL('ZK5') 
			    ZK5->ZK5_FILIAL:=fl1
                ZK5->ZK5_CODIGO :=cCODIGO
                ZK5->ZK5_DESC   :=cEdit1
                ZK5->ZK5_DVAL   :=cEdit2
                ZK5->ZK5_CODPRO :=Nx1
                ZK5->ZK5_DPROD  :=Nx2
                ZK5->ZK5_QUANT  :=Nx3
                ZK5->ZK5_PRVEND :=Nx4  
			    MsUnlock("ZK5")  
			    
 ZK5->(DbSkip())  
    NEXT
EndIf                                                                       
	
Return lRet                                 

//+-----------------------------------------------------------------------------+//
//| FUNÇÃO    | faHeader       | AUTOR | Ewerton F Brasiliano      | DATA | 18/06/2015 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Monatgem de aHeader                                             |//
//+-----------------------------------------------------------------------------+//
Static Function faHeader(cTabela)

Local nCampos := 0
aHeader:={}

DbSelectArea("SX3")
SX3->(DbSetOrder(1))
SX3->(DbSeek(cTabela))
While SX3->(!Eof()) .and. Alltrim(SX3->X3_ARQUIVO) == Alltrim(cTabela)
   If X3Uso(SX3->X3_USADO)  .and. cNivel >= SX3->X3_NIVEL        
          
     //IF SX3->X3_CAMPO $'ZK5_CODPRO#ZK5_DPROD#ZK5_QUANT#ZK5_PRVEND'
      nCampos++  
      aAdd(aHeader,{Trim(X3Titulo()),;                      
      					SX3->X3_CAMPO,;                      
      					SX3->X3_PICTURE,;                      
      					SX3->X3_TAMANHO,;                      
      					SX3->X3_DECIMAL,;                      
      					SX3->X3_VALID,;                      
      					"",;                      
      					SX3->X3_TIPO,;                      
      					"",;                      
      					"" })
      //aAdd(aCpsAlt,SX3->X3_CAMPO)   
      //ENDIF
   EndIf
   SX3->(DbSkip())
End             

Return nCampos

//+-----------------------------------------------------------------------------+//
//| FUNÇÃO    | faCols    AUTOR | Ewerton F Brasiliano      | DATA | 18/06/2015 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Montagem de aCols                                               |//
//+-----------------------------------------------------------------------------+//
Static Function faCols(nCpos)

Local nI    := 0
Local nJ    := 0
Local aArea := GetArea()
Local cAlias := "ZK5"   
Local QRY4

aCols:={}
   FOR nI=1 TO LEN(aDadosX1)
	aAdd(aCols,Array(nCpos+1))
aCols[nI][1]:= aDadosX1[nI][4]
aCols[nI][2]:= aDadosX1[nI][5]
aCols[nI][3]:= aDadosX1[nI][6]
aCols[nI][4]:= aDadosX1[nI][7] 
	aCols[Len(aCols)][nCpos+1] := .F.  

 Next
RestArea(aArea)

Return .T.
