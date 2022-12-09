#INCLUDE 'TOTVS.CH'
#Include "rwmake.ch"
#Include 'FWMVCDef.ch'

/*
=====================================================================================
Programa.:              UPDCLASS
Autor....:              Alcouto
Data.....:              27/01/2021
Descricao / Objetivo:   Rotina para atualização do Indice conforme classe
Doc. Origem:            GAP
Solicitante:            Cliente
Uso......:              Renova Energia          
=====================================================================================
*/
User function UPDCLASS ()

    Local aArea := {GetArea()}
	Local cQ := ""
	Local cAliasTrb := GetNextAlias()
    Local nIndice   := CN7->CN7_VLREAL
    Local nXindic   := CN7->CN7_XINDCE
    

If !fDigSenha()
    Return
Endif        
//---------------Criar a Dialog com os criterios-------------------


If CN7->CN7_DATA >= dDataBase 
		cQ := "SELECT R_E_C_N_O_ SE2_RECNO "
		cQ += "FROM "+RetSqlName("SE2")+" SE2 "
		cQ += "WHERE SE2.D_E_L_E_T_ = ' ' "
		cQ += "AND E2_FILIAL = '"+xFilial("SE2")+"' "
		cQ += "AND E2_XCLASS = '"+CN7->CN7_XCLASS+"' "
        cQ += "AND E2_SALDO > 0 
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
            While (cAliasTrb)->(!Eof())
                  SE2->(dbGoto((cAliasTrb)->SE2_RECNO))
                   If SE2->(Recno()) == (cAliasTrb)->SE2_RECNO 
                        SE2->(RecLock("SE2",.F.))
                        SE2->E2_PORCJUR := nIndice+nXindic
                        SE2->(MsUnLock())
                   Endif
                  (cAliasTrb)->(dbSkip())
            Enddo	
   (cAliasTrb)->(dbCloseArea())
   aEval(aArea,{|x| RestArea(x)})
   MsgInfo("Indice atualizado com Sucesso!!!")  
   else  
   MsgInfo("A data deve ser maior ou igual a: "+dDateBase+"!!!")

EndIf	
Return() 

/*/{Protheus.doc} fDigSenha
Função fDigSenha
@author Alcouto
@obs Funcao para solicitar a senha para acessar a rotina.
---------------------------------------------------------/*/

Static Function fDigSenha()
Private cSenha   := Space(10)         
Private cSenhAce := "AGCRJ21"
Private _lReturn

@ 067,020 To 169,312 Dialog Senhadlg Title OemToAnsi("Liberação de Acesso")
@ 015,005 Say OemToAnsi("Informe a senha para o acesso ?") Size 80,8
@ 015,089 Get cSenha Size 50,10 Password
@ 037,106 BmpButton Type 1 Action fOK()
@ 037,055 BmpButton Type 2 Action Close(Senhadlg)
Activate Dialog Senhadlg CENTERED
Return(_lReturn)                     
/*----------------------------------------------------------
//{Protheus.doc} fOK
//Função fOK
//@obs Funcao para validar a senha digitada
*///----------------------------------------------------------
Static Function fOK()

If ALLTRIM(cSenha)<> cSenhAce
   MsgStop("Senha não Confere !!!")
   cSenha  := Space(10)
   dlgRefresh(Senhadlg)
Else
   _lReturn  := .T.
   Close(Senhadlg)
Endif
Return



