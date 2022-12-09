/* 
 José Orfeu Gaino Pinheiro - 22/11/2011

 Valida a conta contabil no cadastro de clientes e fornecedores x plano de contas:

*/

#include "topconn.ch"

User Function VldCCtb()
 
 If MsgYesNo("Ajuste Conta Contabil. Confirma")
 
    Processa({|| AjustaCCtb()})
  
 EndIf 
 
Return(Nil)

Static Function AjustaCCtb()
 Local cMsgInfo   := "", cCliFor := "1"
 Local cAliasOld  := Alias()
 Local cSql       := 0
 Local nRecTot    := 0
 Local cCliCntCtb := "112001"
 Local cForCntCtb := "211001"
 Local cCabCliCnt := "SELECT Count(SA1.A1_FILIAL+SA1.A1_COD) nRecCnt "
 Local cCabCliSql := "SELECT '1' CLIFOR, SA1.A1_FILIAL FILIAL, SA1.A1_COD COD, SA1.A1_NOME NOME, SA1.A1_CONTA CONTA, SA1.R_E_C_N_O_ RECNO "
 Local cSqlCli    := "FROM " + RetSqlName("SA1") + " SA1 " + ;
                     "WHERE SA1.D_E_L_E_T_ <> '*' AND " + ;
                           "(SA1.A1_CONTA <> '" + cCliCntCtb + "' + SA1.A1_COD OR " + ;
                            "NOT EXISTS (SELECT CT1_CONTA " + ; 
                            "FROM " + RetSqlName("CT1") + " CT1 " + ;
                            "WHERE CT1.D_E_L_E_T_ <> '*' AND CT1.CT1_CONTA = SA1.A1_CONTA))"
                            
 Local cCabForCnt := StrTran(cCabCliCnt, "A1", "A2")
 Local cCabForSql := StrTran(cCabCliSql, "A1", "A2")
 Local cSqlFor    := StrTran(cSqlCli   , RetSqlName("SA1"), RetSqlName("SA2"))
 
 cCabForSql := StrTran(cCabForSql, "'1'", "'2'")
 cSqlFor    := StrTran(cSqlFor, "A1", "A2")
 cSqlFor    := StrTran(cSqlFor, cCliCntCtb, cForCntCtb)

 cSql := cCabCliCnt + cSqlCli + " UNION ALL " + cCabForCnt + cSqlFor
 
 TCQuery cSql New Alias "VLDCTB"
 
 // Conta registros
 While !Eof()
  nRecTot += VLDCTB->nRecCnt
 
  DBSkip()
 End 
 
 VLDCTB->(DbCloseArea())
 
 cSql := cCabCliSql + cSqlCli + " UNION ALL " + cCabForSql + cSqlFor
 
 TCQuery cSql New Alias "VLDCTB"
     
 ProcRegua(nRecTot)
    
 cMsgInfo := "Alterações no cadastro de clientes:"
 
 cCliFor  := "1"
 
 DbSelectArea("VLDCTB")
 While !Eof()
    IncProc("Verificando conta contabil")
    
    DBSelectArea(IIf(VLDCTB->CLIFOR == "1", "SA1", "SA2"))
    DBGoTo(VLDCTB->RECNO)
    
    If VLDCTB->CLIFOR <> cCliFor
     cCliFor := VLDCTB->CLIFOR
     cMsgInfo += Chr(13) + Chr(10) + Replicate("-", 50) 
     cMsgInfo += Chr(13) + Chr(10) + "Alterações no cadastro de fornecedores:"
    EndIf
    
    cMsgInfo += Chr(13) + Chr(10) + "Codigo " + VLDCTB->COD + ""
    cMsgINfo += Chr(13) + Chr(10) + "Conta  "
                                      
    If IIf(VLDCTB->CLIFOR == "1", SA1->A1_CONTA <> cCliCntCtb + VLDCTB->COD, SA2->A2_CONTA <> cForCntCtb + VLDCTB->COD)
       cMsgInfo += "alterada de " + AllTrim(IIf(VLDCTB->CLIFOR == "1", SA1->A1_CONTA, SA2->A2_CONTA)) + " para " + ;
                                    AllTrim(IIf(VLDCTB->CLIFOR == "1", cCliCntCtb   , cForCntCtb) + VLDCTB->COD)
     
       RecLock(IIf(VLDCTB->CLIFOR == "1", "SA1", "SA2"), .F.)
          If VLDCTB->CLIFOR == "1"
             SA1->A1_CONTA := cCliCntCtb + VLDCTB->COD
          Else
             SA2->A2_CONTA := cForCntCtb + VLDCTB->COD
          EndIf 
       MsUnLock()
    
    Else
       cMsgInfo += "Ok"
     
    EndIf
    
    // Valida conta contabil no plano de contas
    cMsgInfo += Chr(13) + Chr(10) + "CT1    "
    
    If U_IncCCtb(IIf(VLDCTB->CLIFOR == "1", cCliCntCtb, cForCntCtb) + VLDCTB->COD, VLDCTB->NOME, VLDCTB->CLIFOR)
       cMsgInfo += "Inclusão"
       
    Else
       cMsgInfo += "Alteração"
       
    EndIf
    
    cMsgInfo += Chr(13) + Chr(10)
    
    DbSelectArea("VLDCTB")
    DbSkip()
 End
 
 HS_MsgInf(cMsgInfo, "Atenção", "Validação Conta Contabil")
 
 VLDCTB->(DbCloseArea())
 
 DbSelectArea(cAliasOld)
Return(Nil)
/* 
 Incluir conta contabil
 
 Parametros:
  - cCntCtb - Codigo da conta contabil
  - cNormal - Quando Cliente informar "1" quando fornecedor "2"
*/

User Function IncCCtb(cCntCtb, cNome, cNormal)
 Local aArea   := GetArea()
 Local cCtaSup := SubStr(cCntCtb, 1, 6) 
 Local lIncReg := .T.
 
 DbSelectArea("CT1")
 DbSetOrder(1)
 
 If lIncReg := !DbSeek(xFilial("CT1") + cCntCtb)
    RecLock("CT1", .T.)
       CT1->CT1_CONTA  := cCntCtb
	    CT1->CT1_DESC01 := cNome
	    CT1->CT1_CLASSE := "2"
	    CT1->CT1_NORMAL := cNormal
	    CT1->CT1_RES    := ""
	    CT1->CT1_BLOQ   := "2"
	    CT1->CT1_DC     := ""
	    CT1->CT1_CVD02  := "1"
	    CT1->CT1_CVD03  := "1"
	    CT1->CT1_CVD04  := "1"
	    CT1->CT1_CVD05  := "1"
	    CT1->CT1_CVC02  := "1"
	    CT1->CT1_CVC03  := "1"
	    CT1->CT1_CVC04  := "1"
	    CT1->CT1_CVC05  := "1"
	    CT1->CT1_CTASUP := cCtaSup
	    CT1->CT1_ACITEM := "2"
	    CT1->CT1_ACCUST := "2"
	    CT1->CT1_ACCLVL := "2"
	    CT1->CT1_DTEXIS := CToD('01/01/1980') //dDataBase
	    CT1->CT1_AGLSLD := "2"
	    CT1->CT1_CCOBRG := "2"
	    CT1->CT1_ITOBRG := "2"
	    CT1->CT1_CLOBRG := "2"
	    CT1->CT1_LALUR  := "0"
	    CT1->CT1_CTLALU := cCtaSup
	 MsUnLock()
	 
 Else
    RecLock("CT1", .F.)
       CT1->CT1_DESC01 := cNome
    MsUnLock()
    
 EndIf	
Return(lIncReg)