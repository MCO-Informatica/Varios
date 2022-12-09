#include "TOTVS.CH"     
#INCLUDE "PROTHEUS.CH" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ NBFCI001 ³ Autor ³ Daniel Paulo        ³ Data ³ 18/07/2017 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Atualização dos dados FCI no SB1 ABA FCI	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
  

User Function NBFCI001()
	
	Local aArea 	 := GetArea()
	Local oDlg		 := Nil
	Local oPanel	 := Nil
	Local oFWLayer := Nil
	Local oColUp	 := Nil
	Local oColDown := Nil
	Local oLayUp 	 := Nil
	Local oLayDown := Nil
	Local oDlgUp	 := Nil
	Local oDlgdown := Nil
	Local oMemo	 := Nil
	Local oGet		 := Nil
	Local dGet		 := DTOc(dDatabase)  
	local oData:= NIl
	Local oRetGet	 := Nil
	Local cRetGet	 := Space(60)
	Local lRet	 := .F.
	Local cMemo	 := ""
	Local  oFont := TFont():New('Courier new',,6,.T.)
	
	oDlg := FWDialogModal():New()
	
	oDlg:SetBackground( .T. )
	oDlg:SetEscClose( .T. )
	oDlg:SetSize( 100, 120 ) //cria a tela maximizada (chamar sempre antes do CreateDialog)
	oDlg:EnableFormBar( .T. )
	
	oDlg:CreateDialog()
  //	oDlg:AddYesNoButton()    
	oDlg:addButtons({{,"Gerar",{||lRet := FWMsgRun(, {|oDlg| GRVSB1FCI(dGet3,oDlg) }, "Processando", "Atualizando os Dados FCI dos Produtos...")},,,,.T.,}}) 
	If lRet  
	{||odlg:DeActivate() }
	EndIf
	oPanel := oDlg:GetPanelMain()
	
	//-------------------------------------------------
	// Cria o painel superior do motivo
	//-------------------------------------------------
	oFWLayer := FWLayer():New()
	oFWLayer:Init( oPanel, .F. )
	oFWLayer:AddLine( "UP_BOX", 100, .T. )
	oFWLayer:AddCollumn( "COLLUP_BOX", 120, .T., "UP_BOX" )
	
	oColUp	  := oFWLayer:GetColPanel( "COLLUP_BOX", "UP_BOX" )
	
	oLayUp := FWLayer():New()
	oLayUp:Init( oColUp, .F. )
	oLayUp:AddCollumn( "COLL1", 100, .T., "LINE1" )
	oLayUp:AddWindow( "COLL1", "WIN1", "Calculo  FCI" , 100, .F., .F.,,"LINE1" )
	
	oDlgUp := oLayUp:GetWinPanel( "COLL1", "WIN1", "LINE1" )
	
	//-------------------------------------------------

        oSay1:= tSay():New(03,006,{||"Periodo de Calculo"},oDlgUp,,,,,,.T.,CLR_BLACK,CLR_WHITE,120,30) 
  		dGet3 := Date()
		oGet3 := TGet():New( 015, 009, { | u | If( PCount() == 0, dGet3, dGet3 := u ) },oDlgUp, ;
     	060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet3",,,,.T.  )		        

	oDlg:Activate()
	

	
Return     
//------------------------------------------------------------------------------
/*/{Protheus.doc} GRVSB1FCI

Funçao para Gravaçao da FCI no cadastro do Produto

@sample		GRVSB1FCI
@Reciver		expD  dGet3 - Data para o Calculo   / expO oDlg Objeto FwDialogMOdel 


@author		Ronaldo Robes 	
@since		09/03/2017
@version	12
/*/
//------------------------------------------------------------------------------  

Static Function GRVSB1FCI(dGet3,oDlg)
Local cQry := ""  
Local cDate := ""

cDate := Substr(DTOS(dGet3),5,2) + Substr(DTOS(dGet3),1,4) 

If SELECT("QryCFD")>0 
	DbSelectArea("QryCFD")
	DbCloseArea()
EndIF             

cQry := " SELECT * FROM   " +RETSQLNAME("CFD")+ " Where D_E_L_E_T_ = '' AND CFD_PERVEN = '"+cDate+"'
 
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),"QryCFD", .F., .T.)            

QryCFD->(DbGoTop()) 

DbSelectArea("SB1")
DbSetOrder(1)


While !QryCFD->(EOF()) 



	If DbSeek(xFilial("SB1") + QryCFD->CFD_COD)   
		RecLock("SB1",.F.)
		SB1->B1_XFCICOD := QryCFD->CFD_FCICOD
		SB1->B1_XORIFCI := QryCFD->CFD_ORIGEM
		SB1->B1_XPERCAL := QryCFD->CFD_PERCAL
		SB1->B1_XPERVEN := QryCFD->CFD_PERVEN
		msUnlock() 
	EndIf          
						

	QryCFD->(DbSkip())    

EnDDo
 

AVISO("Termino", "Atualizaçao Finalizada", { "OK" }, 1)      

Return .T.
