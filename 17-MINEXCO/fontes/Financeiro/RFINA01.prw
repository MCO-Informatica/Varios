#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"

User Function RFINA01()




Local oEdit1
Local oEdit2
Local oEdit3
Local oEdit4

Private _oDlg
Private INCLUI := .F.
Private cEdit1	 := Space(6)
Private cEdit2	 := Space(20)
Private cEdit3	 := Space(9)

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Contas a Pagar - Alteração de Emissão") FROM C(315),C(400) TO C(582),C(686) PIXEL
                                                                                       
	// Cria Componentes Padroes do Sistema
	@ C(050),C(010) Say "Cód. Fornec.:" Size C(050),C(010) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(050),C(070) MsGet oEdit1 Var cEdit1 F3 "SA2" Valid BuscaFornec() Size C(065),C(010) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(060),C(010) Say "Fornecedor:" Size C(050),C(010) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(060),C(070) MsGet oEdit2 Var cEdit2 Size C(065),C(010) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(080),C(010) Say "Titulo"  Size C(050),C(010) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(080),C(070) MsGet oEdit3 Var cEdit3 Size C(065),C(010) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(120),C(055) Button OemtoAnsi("Confirma") Action Grava() Size C(040),C(012) PIXEL OF _oDlg
ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Norbert Waage Junior  ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         
If "MP8" $ oApp:cVersion                                                        
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
  //³Tratamento para tema "Flat"³                                               
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf                                                                           
Return Int(nTam)                                                                


Static Function BuscaFornec()

DbSelectArea("SA2")
DbSetOrder(1)
If DbSeek(xFilial("SA2")+Alltrim(cEdit1)+"01",.f.)
   cEdit2    := SA2->A2_NREDUZ
   _lRetorno := .t.
Else
    MsgBox("O código digitado não existe no Cadastro de Fornecedores. Informe um código válido.","Valida Fornecedor","Stop")
    _lRetorno := .f.
EndIF

SysRefresh()

Return(_lRetorno)



Static Function Grava()

_Query	:=	"UPDATE SE2010 SET E2_EMISSAO = E2_VENCTO, E2_EMIS1 = E2_VENCTO "
_Query	+=	"WHERE E2_FORNECE = '"+cEdit1+"' AND E2_LOJA = '01' AND E2_PREFIXO = '"+Subs(cEdit3,1,3)+"' AND E2_NUM = '"+Subs(cEdit3,4,6)+"' "
_Query	+=	"AND E2_SALDO > 0 AND D_E_L_E_T_ = ''"

TCSQLEXEC(_Query)

MsgBox("Alteração efetuada com sucesso.","Emissão Alterada","Info")

Close(_oDlg)

Return
