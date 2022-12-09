#INCLUDE "Totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSCOM001  บ Autor ณ Renato Ruy	     บ Data ณ  02/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela para cadastro de aprovadores Solicita็ใo de Compras.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSCOM001()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
                                                           

Private cCadastro := "Cadastro de Aprovadores - Solicita็ใo de Compras"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Novo","U_CSCOM1A",0,3} ,;
             {"Alterar","U_CSCOM1B",0,4} ,;
             {"Excluir","U_CSCOM1C"   ,0,5} }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta array com os campos para o Browse                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aCampos := { {"CENTRO DE CUSTOS","AI_XCC","C",9,00,"@!"} ,;
           {"COD.APROVADOR","AI_XAPROV","",06,00,"@!"} ,;
           {"NOME","AI_USRNAME","",50,00,"@!"} ,;
           {"E-MAIL APROV.","AI_XMAIL","",150,00,"@!"} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString 	:= "SAI"
Private cFiltra		:= "AI_FILIAL == '"+xFilial('SAI')+"' .And. AI_XCC <> ' '"
Private aIndexSAI 	:= {}
Private bFiltraBrw	:= { || FilBrowse(cString,@aIndexSAI,@cFiltra) }

Eval(bFiltraBrw)
dbSelectArea("SAI")
dbSetOrder(4)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,aCampos,)

Return

User Function CSCOM1A()

	Local _aArea 	:= GetArea()
	Local _lRet 	:= .F.   
	Local _nOpc	 	:= 0

	Private _cCodCC		:= SPACE(9)  
	Private _cCodAprv	:= SPACE(6) 
	Private _cXmail 	:= SPACE(150)
	
	Private oDlg

			
		DEFINE MSDIALOG oDlg TITLE "Informe os dados :" FROM 0,0 TO 230,250 OF oMainWnd PIXEL FONT oMainWnd:oFont
	   
		@008,20 Say " Centro de Custos: " 	PIXEL SIZE 80,07 OF oDlg
		@015,20 MsGet _cCodCC   VALID NaoVazio(_cCodCC)   PIXEL SIZE 65,09 F3 "CTT" OF oDlg

		@030,20 Say " C๓d. Aprovador: " PIXEL SIZE 80,07 OF oDlg
		@040,20 MsGet _cCodAprv VALID NaoVazio(_cCodAprv) PIXEL SIZE 65,09 F3 "US4" OF oDlg
		
		@055,20 Say " E-Mail: " 		PIXEL SIZE 80,07 OF oDlg
		@065,20 MsGet _cXmail VALID NaoVazio(_cXmail)     PIXEL SIZE 65,09 F3 "US4" OF oDlg WHEN .F.
					
		DEFINE SBUTTON FROM 100,40 TYPE  1 ENABLE OF oDlg ACTION (_nOpc := 1, oDlg:End())
		DEFINE SBUTTON FROM 100,70 TYPE  2 ENABLE OF oDlg ACTION (_nOpc := 2, oDlg:End())
			
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If _nOpc == 1 
			_lRet := .T.
		Endif		                                        

If _lRet
	
	If Select("TMPCOM1") > 0
		DbSelectArea("TMPCOM1")
		DbCloseArea()
	EndIf
	
	BeginSql Alias "TMPCOM1"
	
		Select *
		From %Table:SAI%
		where
		AI_FILIAL 	= %Exp:xFilial("SAI")% And
		AI_GRUSER	= '******' 			And
		AI_USER		= %Exp:_cCodAprv% 	And
		AI_PRODUTO 	= '               ' And
		AI_GRUPO	= '    ' 			And
		AI_XCC      = %Exp:_cCodCC% 	And
		AI_XAPROV   = %Exp:_cCodAprv% 	And
		D_E_L_E_T_ = ' '
	
	EndSql
	
	DbSelectArea("TMPCOM1")
	
	If TMPCOM1->R_E_C_N_O_ <> 0
		MsgInfo("Jแ existe o cadastro para o Centro de Custos x Aprovador de Solicita็ใo de Compras")
		Return
	EndIf
	
	If Select("TMPCOM2") > 0
		DbSelectArea("TMPCOM2")
		DbCloseArea()
	EndIf	
	
	BeginSql Alias "TMPCOM2"
	
		Select Nvl(Max(AI_ITEM)+1,1) ITEM
		From %Table:SAI%
		where
		AI_FILIAL 	= %Exp:xFilial("SAI")% 	And
		AI_GRUSER	= '******' 				And
		AI_USER		= %Exp:_cCodAprv% 		And
		AI_PRODUTO 	= '               ' 	And
		AI_GRUPO	= '    ' 				And
		D_E_L_E_T_ = ' '
	
	EndSql
	
	DbSelectArea("TMPCOM2")
	
	RecLock("SAI",.T.)
		AI_FILIAL 	:= xFilial("SAI")
		AI_GRUSER	:= "******"
		AI_USER		:= _cCodAprv
		AI_PRODUTO 	:= "               "
		AI_GRUPO	:= "    "
		AI_ITEM		:= StrZero(TMPCOM2->ITEM,2)
		AI_XCC      := _cCodCC   
		AI_XAPROV   := _cCodAprv
		AI_XMAIL    := _cXmail
	SAI->(MsUnlock())
EndIf

RestArea(_aArea)
Return()

User Function CSCOM1B()

	Local _aArea 	:= GetArea()
	Local _lRet 	:= .F.   
	Local _nOpc	 	:= 0 
	Private _cCodCC		:= SAI->AI_XCC  
	Private _cCodAprv	:= SAI->AI_XAPROV
	Private _cXmail 	:= SAI->AI_XMAIL
	
	Private oDlg

			
		DEFINE MSDIALOG oDlg TITLE "Informe os dados :" FROM 0,0 TO 230,250 OF oMainWnd PIXEL FONT oMainWnd:oFont
	   
		@008,20 Say " Centro de Custos: " 	PIXEL SIZE 80,07 OF oDlg
		@015,20 MsGet _cCodCC   PIXEL SIZE 65,09 F3 "CTT" When .F. OF oDlg

		@030,20 Say " C๓d. Aprovador: " PIXEL SIZE 80,07 OF oDlg
		@040,20 MsGet _cCodAprv VALID NaoVazio(_cCodAprv) PIXEL SIZE 65,09 F3 "US4" OF oDlg
		
		@055,20 Say " E-Mail: " 		PIXEL SIZE 80,07 OF oDlg
		@065,20 MsGet _cXmail VALID NaoVazio(_cXmail)     PIXEL SIZE 65,09 F3 "US4" OF oDlg WHEN .F.
					
		DEFINE SBUTTON FROM 100,40 TYPE  1 ENABLE OF oDlg ACTION (_nOpc := 1, oDlg:End())
		DEFINE SBUTTON FROM 100,70 TYPE  2 ENABLE OF oDlg ACTION (_nOpc := 2, oDlg:End())
			
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If _nOpc == 1 
			_lRet := .T.
		Endif		                                        

If _lRet
	
	RecLock("SAI",.F.)
		AI_USER		:= _cCodAprv
		AI_XAPROV   := _cCodAprv
		AI_XMAIL    := _cXmail
	SAI->(MsUnlock())     
	
EndIf

RestArea(_aArea)
Return()

User Function CSCOM1C()

If MsgYesNo("Voc๊ realmente deseja excluir o cadastro")
	SAI->( RecLock("SAI",.F.) )
	SAI->( DbDelete() )
	SAI->( MsUnLock() )
EndIf

Return()
