#Include "PROTHEUS.CH"   
#Include "RWMAKE.CH"
#Include "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  03/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FisTrfNfe()

Aadd( aRotina, { "Espelho GAR", "U_GARA160", 0, 2, 0, Nil } )   
Aadd( aRotina, { "Insc.Estadual", "U_ALTINSC", 0, 2, 0, Nil } )      

Return(.T.)          

/* ----------------------------------------------------------------------------
Funcao executada pelo ponto de entrada onde sera utilizado para alterar o campo
A1_INSCR  - DEVIDO PROBLEMA COM NOTA FISCAIS NA SEFAZ *RENE LOPES*
---------------------------------------------------------------------------- */

User Function ALTINSC( )    

Local  aArea   := GetArea() 
Local  aCont   := {" ", "SIM", "NAO"}	
Local  cSelect 
Local  cEsc 
Local  nRecF2  := 0
Local  cClient := SF2->F2_CLIENTE
Local  cLoja   := SF2->F2_LOJA  
Local  oGet1
Local  cImp	   := " " 
Public cGet1   := SPACE(18) 
Static oDlg 
Public lOpcao := .F. 

 If SF2->F2_FIMP <> "S"

	RECLOCK("SF2",.F.)

   		SF2->F2_FIMP := cImp //Limpa o estado antigo da transmissão realizado automaticamente.

	MSUNLOCK("SF2") 
 EndIf

DBSELECTAREA("SA1")
DBSETORDER(1) //FILIAL+COD+LOJA
DBSEEK(xFilial("SA1")+cClient+cLoja)

 DEFINE FONT oBold NAME "Arial" SIZE 0, -10 BOLD
 DEFINE MSDIALOG oDlg TITLE "DIGITE A INSCRIÇÃO ESTADUAL" FROM 000,000 TO 160,370 COLORS 100,300 PIXEL 
    @ 008,010 SAY "Razão Social"  FONT oBold  Size 035,015 OF oDlg COLORS 0,16777215 PIXEL 
 	@ 008,045 SAY  Alltrim(SA1->A1_NOME)  SIZE 150,150 OF oDlg COLORS 0,16777215 PIXEL  
 	@ 022,010 SAY "CNPJ" FONT oBold Size 035,015 OF oDlg COLORS 0,16777215 PIXEL 
 	@ 022,027 MSGET Alltrim(SA1->A1_CGC) SIZE 060,010 OF oDlg COLORS 0,16777215 PIXEL PICTURE "@R 99.999.999/9999-99"
    @ 036,050 MSGET oGet1 VAR cGet1 SIZE 060,010 OF oDlg PIXEL
    @ 038,120 SAY IE PROMPT "Contrib." Font oBold Size 050,050 of oDlg Colors 0,16777215 PIXEL   
    @ 036,140 COMBOBOX cSelect Items aCont SIZE 030,012 OF oDlg PIXEL
    @ 038,010 SAY IE PROMPT "Insc.Estadual"  FONT oBold  SIZE 050,050 OF oDlg COLORS 0,16777215 PIXEL  
    @ 058,050 BUTTON OK PROMPT "OK" SIZE 037,012 OF oDlg PIXEL Action (lOpcao:=.T.,Close(oDlg))//Valid EXISTCPO("SZ3",cGet1)
    @ 058,098 BUTTON Cancelar PROMPT "Cancelar" SIZE 037,012 OF oDlg PIXEL Action (lOpcao:=.F.,Close(oDlg)) Cancel Of oDlg
 ACTIVATE MSDIALOG oDlg CENTERED 

If lOpcao == .T.    
    
	Do Case
		Case cSelect == "SIM"
				cEsc := "1"
		Case cSelect == "NAO"
				cEsc := "2"
		Case cSelect == " " 
				cEsc := " " 
	EndCase	

	IF Found() 
	
		RECLOCK("SA1", .F.) 
		
		SA1->A1_INSCR   := cGet1  
	    SA1->A1_CONTRIB := cEsc

		MsUnLock("SA1")  
		
				aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE," ")
				varinfo("aRetTrans -- ", aRetTrans) 
	         
	 If aRetTrans[2] == "000131" 
	 		//Sleep(10000) 
	 		
	 		DBSELECTAREA("SF3")
	 		DBSETORDER(6)
	 		DBSEEK(XFILIAL("SF3")+SF2->F2_DOC+SF2->F2_SERIE) //FILIAL+NF+SERIE
	 		
	 		cCodRSef := SF3->F3_CODRSEF
	 		
	 		IF cCodRSef == "100"	
				RECLOCK("SF2",.F.)
				cImp := "S"	
	     		SF2->F2_FIMP := cImp    
	     		MSUNLOCK("SF2")  
	     	Endif 
	 Endif
   
   Endif

Endif

Return( )                                                         


Static Function NewDlg1()
/*
A tag abaixo define a criação e ativação do novo diálogo. Você pode colocar esta tag
onde quer que deseje em seu código fonte. A linha exata onde esta tag se encontra, definirá
quando o diálogo será exibido ao usuário.
Nota: Todos os objetos definidos no diálogo serão declarados como Local no escopo da
função onde a tag se encontra no código fonte.
*/

//$BEGINDIALOGDEF_oDlg
/*/======================================================
// These information were generated automatically by AP  
// IDE. DO NOT change anything in these information under
// any circumstance. Otherwise, it can mean loss of data 
// or the dialog invalidation by the Totvs Development Studio
//-------------------------------------------------------
//$DIALOGINFO=312E30,383031,33383137383131363331,31373034,33353036373434343035
//======================================================/*/
//$DIALOGCODE=
4C6F63616C206F446C672C6F536179312C6F47657432
6F446C67203A3D204D534449414C4F4728293A43726561746528290D0A6F446C673A634E616D65203A3D20226F446C67220D0A6F446C673A6343617074696F6E203A3D20224469E16C6F676F220D0A6F446C673A6E4C656674203A3D20300D0A6F446C673A6E546F70203A3D20300D0A6F446C673A6E5769647468203A3D203430320D0A6F446C673A6E486569676874203A3D203137360D0A6F446C673A6C53686F7748696E74203A3D202E462E0D0A6F446C673A6C43656E7465726564203A3D202E462E0D0A
6F53617931203A3D205453415928293A437265617465286F446C67290D0A6F536179313A634E616D65203A3D20226F53617931220D0A6F536179313A6343617074696F6E203A3D20226F53617931220D0A6F536179313A6E4C656674203A3D2031350D0A6F536179313A6E546F70203A3D2031370D0A6F536179313A6E5769647468203A3D2036350D0A6F536179313A6E486569676874203A3D2031370D0A6F536179313A6C53686F7748696E74203A3D202E462E0D0A6F536179313A6C526561644F6E6C79203A3D202E462E0D0A6F536179313A416C69676E203A3D20300D0A6F536179313A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F536179313A6C576F726457726170203A3D202E462E0D0A6F536179313A6C5472616E73706172656E74203A3D202E462E0D0A
6F47657432203A3D205447455428293A437265617465286F446C67290D0A6F476574323A634E616D65203A3D20226F47657432220D0A6F476574323A6343617074696F6E203A3D20226F47657432220D0A6F476574323A6E4C656674203A3D2038390D0A6F476574323A6E546F70203A3D2031380D0A6F476574323A6E5769647468203A3D203132310D0A6F476574323A6E486569676874203A3D2032310D0A6F476574323A6C53686F7748696E74203A3D202E462E0D0A6F476574323A6C526561644F6E6C79203A3D202E462E0D0A6F476574323A416C69676E203A3D20300D0A6F476574323A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F476574323A6C50617373776F7264203A3D202E462E0D0A6F476574323A6C486173427574746F6E203A3D202E462E0D0A
6F446C673A41637469766174652829
//$ENDDIALOGDEF_oDlg
Return

