#Include "TOTVS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} PerxCli
Description

@Tela criada para permitir ao usuário relaizar a amarração 
	entre Personalização e Cliente
@return xRet Return Description
@author Oscar - oscar@totalsiga.com.br
@since 20/01/2012
/*/
//--------------------------------------------------------------

User Function PerxCli()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z02"

dbSelectArea("Z02")
dbSetOrder(1)

AxCadastro(cString,"Amarração de Person. x Cliente",cVldExc,cVldAlt)

Return lRet:= .T.

                            
/*User Function PerxCli()
Local oGet1
Local cGet1 := Space(6)
Local oGet2
Local cGet2 := Space(40)
Local oList1
Local nListBox1 := 1
Local oList2
Local aList2:={}
Local nListBox2 := 1
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSButton1
Local oSButton2

Static oDlg

PRIVATE oFont6  := NIL  
DEFINE FONT oFont6 NAME "ARIAL" BOLD

DbSelectArea("Z00")
DbSetOrder(1)

While Z00->(!EOF())
	AADD(aList2,{Z00->Z00_COD,Z00->Z00_DESC}) 
	Z00->(DbSkip())
End


  DEFINE MSDIALOG oDlg TITLE "Personalização dos Clientes" FROM 000, 000  TO 330, 500 COLORS 0, 16777215 PIXEL
	@ 004, 010 TO 165,240 LABEL "" OF oDlg PIXEL
    @ 051, 015 SAY oSay1 PROMPT "Cliente Desejado" SIZE 087, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 081, 015 SAY oSay3 PROMPT "Personalizações do Cliente" SIZE 076, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 011, 136 SAY oSay4 PROMPT "Personalizações Disponíveis" SIZE 076, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 052, 068 MSGET oGet1 VAR cGet1 SIZE 058, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SA1"  ON CHANGE ListCli(cGet1)
    @ 064, 015 MSGET oGet2 VAR cGet2 SIZE 111, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 095, 015 LISTBOX oList1 VAR nListBox1 ITEMS {} SIZE 112, 057 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 023, 135 LISTBOX oList2 VAR nListBox2 ITEMS {} SIZE 100, 129 OF oDlg COLORS 0, 16777215 PIXEL
    oList2 := TListBox():Create(oDlg,023,135,{|u|if(Pcount()>0,nListBox2:=u,nListBox2)},;
                          aList2,100,100,,,,,.T.)
     
    										
    //DEFINE SBUTTON oSButton1 FROM 027, 101 TYPE 10 OF oDlg ENABLE
    SButton():New( 027,101,17,{||Alert('SA1')},oDlg,.T.,,)
    @ 028, 061 SAY oSay2 PROMPT "Pesquisa" SIZE 040, 008 OF oDlg COLORS 0, 16777215 PIXEL
    //SButton():New( 051,040,04,{||Conpad1(,,,'SA1')},oDlg,.T.,,)
    @ 155,015 Say DtoC(Date()) + " - " + Time() Pixel Font oFont6 Color CLR_RED Of oDlg

  ACTIVATE MSDIALOG oDlg CENTERED

Return

Static function ListCli(cGet1)   

DbSelectArea("Z02")
DbSetOrder(1)
dbGoTop()

Z02->(dbSeek(xFilial("Z02")+cGet1) )
aList1 := {}
While Z02->(!EOF())   
    
	AADD(aList1,{Z02->Z02_CODCLI,Z02->Z02_CODPER}) 
	Z02->(DbSkip())
	
EndDo

if allTrim(cGet1)==""
	aList1:={}
	AADD(aList1, {"" , ""}  )
endIf 

 	oList1:SetArray(aList1)


  	oList1:bLine := {||  {aList1[oList1:nAt,1],;
							aList1[oList1:nAt,2]}}

oList1:Refresh()

Return

/*
User Function ListTot()

Local aList2:={}

DbSelectArea("Z00")
DbSetOrder(1)

While Z00->(!EOF())
	AADD(aList2,{Z00->Z00_COD,Z00->Z00_DESC}) 
	Z00->(DbSkip())
End

Return
*/



User Function PSDupl()
Local aArea := GetArea()

If Z02->(dbSetOrder(3), dbSeek(xFilial("Z02")+M->Z02_CODPER+M->Z02_CODCLI+M->Z02_LOJACL)) .And. INCLUI
	Alert("Atenção Já Existe Personalização Lançada para Este Cliente !")
	RestArea(aArea)
	Return .f.     
Endif

RestArea(aArea)
Return .t.
