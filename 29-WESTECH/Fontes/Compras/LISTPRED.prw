#INCLUDE "TOTVS.CH"                         
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'
#include "rwmake.ch"

/*
User Function ZZZZZ()

Local _lRet 	:= .T.
Local aArea 	:= GetArea()
Local nPosCta	:= aScan(aHeader,{ |x| Alltrim(x[2]) == "D1_CONTA" })

Local nPosICta	:= aScan(aHeader,{ |x| Alltrim(x[2]) == "D1_ITEMCTA" })


IF aCols[n,nPosICta] = "ADMINISTRACAO"  //EMPTY(aCols[n,nPosCta])
	cConta:= U_ListPRed()
	aCols[n,nPosCta]:=cConta

ENDIF                                                
//While SD1->( ! EOF() ) .and. EMPTY (SD1->D1_CONTA )
  
//	If EMPTY (SD1->D1_CONTA )
 //		RecLock("SD1",.T.)            
    
        	   //SD1->D1_CONTA:= cConta
//				M->D1_CONTA:= cConta	
	   
//		MsUnlock()  
//	EndIf 
	
//	SD1->( dbSkip() )

//EndDo

Return(.T.)
*/
//************************************************************************
User Function ListPRed()

Public cConta := ""
Private oDlg
Private oLbx1,oLbx2,oLbx3, oLbx4
Private oFld
Private oBtn  
Private oFont1     := TFont():New( "Calibri",0,16,,.T.,0,,700,.T.,.F.,,,,,, )  
Private oFont2		 := TFont():New( "Arial",0,24,,.T.,,,,.F.,.F.,,,,,, )   

Private aTitles		:= {"Classificação"}//,"Descrição"}
//Private aPlContas	:= {{"",""}}
Private aPlContas	:= {"",""}

 
oDlg := MsDialog():New(000,000,550,950,"Classificação",,,.F.,,,,,,.T.,,,.T.) 


oFld := tFolder():New(025,005,aTitles,{},oDlg,,,,.T.,.F.,468,228)

fCarregaDados() 

//===================================================================== Folder 1 - Cliente ======================================================================
@ 005,005 LISTBOX oLbx1 FIELDS HEADER 	"Classificação","Descrição" SIZE 456,205 PIXEL OF oFld:aDialogs[1]
oLbx1:SetArray(aPlContas)
oLbx1:bLine := { || {	aPlContas[oLbx1:nAt,01] ,	aPlContas[oLbx1:nAt,02]}  }

			

oBtn := tButton():New(258,435,"Sair",oDlg,{||Sair()},036,012,,,,.T.,,"",,,,.F.)
oBtn := tButton():New(258,380,"OK",oDlg,{||fOK()},036,012,,,,.T.,,"",,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED


Return(cConta)

//******************************************************************************************************

Static Function fCarregaDados() 


Local cAliasPlContas := GetNextAlias()  
Local cSql      := ""
//Local cAliasProd := GetNextAlias()                                     
nRegistro:=0
cCliLoja :=""
cGet3    :=""                                            
// 1º  Folder pl. contas

dbSelectArea("CT1")
CT1->( dbSetOrder(1) )
CT1->( dbGoTop())

aPlContas := {}


// 2º  Folder Fornecedor   


cSql :=" Select CT1_CONTA,   "
cSql +="	   CT1_DESC01   "
cSql +=" FROM CT1010" 
cSql +="  WHERE CT1_CONTA BETWEEN '6' AND '691010007'AND CT1_CLASSE = '2' AND D_E_L_E_T_ = ' '   "     
cSql +=" ORDER BY CT1_CONTA "

cSql := ChangeQuery(cSql)
                            
If SELECT("TMX") > 0
	TMX->( dbCloseArea() )
Endif

dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cSql),("TMX"),.T.,.T.)//(cAliasPlContas), .F., .T.)

While ! TMX ->( EOF() )
//nRegistro := TMX->REGISTRO                            
cCliLoja  :=  TMX->CT1_CONTA
cGet3     :=  TMX->CT1_DESC01

/*
If Select( cAliasPlContas ) == 0
	(cAliasPlContas)->( dbCloseArea() )
EndIf	
*/
//If nRegistro == 0 
//   MsgStop("Problemas com Relacionamento da tabela, avise ao Administrador do sistema!")
//   Return 
//EndIf

 

AADD (aPlContas,{ cCliLoja,;
				  cGet3 	}) 

TMX->(dbSkip())   

EndDo

TMX->( dbCloseArea() ) 

Return


//******************************************************************************************************

Static Function Sair()
	
	if empty(cConta)
		msginfo ( "Selecione Classificação." )
	else
		oDlg:END()	
	end if
	

Return( NIL )

//******************************************************************************************************


Static Function fOK()


	
	// MsgInfo(aCliente[oLbx1:nAt,01],	aCliente[oLbx1:nAt,02],	aCliente[oLbx1:nAt,03])	
	
	if oFld:nOption == 1
		
		cConta:= (aPlContas[oLbx1:nAt,01])

	//	MsgInfo(aPlContas[oLbx1:nAt,01],	aPlContas[oLbx1:nAt,02])	
	endif

	oDlg:END()

Return (cConta)
               

//******************************************************************************************************





