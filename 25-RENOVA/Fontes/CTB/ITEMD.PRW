#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ITEMD     ºAutor  ³lEANDRO dUARTE      º Data ³  11/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina paa carregar o campo de projeto ja preenchido confor º±±
±±º          ³me regra da tabela SZ3 (EMPRESA+FILIAL)                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function ITEMD()
Local aArea 	:= GETAREA()
Local cRet		:= SPACE(TAMSX3("Z3_ITEM")[1])

// Solicitação de compras
If ALLTRIM(FUNNAME()) = "MATA110"   
    nPosEmp := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "C1_FILDEST" })   
    nPosClv := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "C1_CLVL" })   
    _cEmpSC1 := CEMPANT+aCols[n,nPosEmp]    
     cRet := u_ItemSZ3(_cEmpSC1,"SC1")   
     // Alimenta classe de valor
    aCols[n,nPosClv] := Substr(cRet,1,2)
Endif    

// Contas a pagar
If ALLTRIM(FUNNAME()) = "FINA050"   
    _cEmpSE2 := CEMPANT+CFILANT       
    cRet := u_ItemSZ3(_cEmpSE2,"SE2")
    // Alimenta classe de valor
     M->E2_CLVLDB := Substr(cRet,1,2)
Endif      

//LANÇAMENTOS PCO - AKD
If ALLTRIM(FUNNAME()) = "PCOA050"
	nPosEmp := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "AKD_OPER" })
	nPosClv := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "AKD_CLVLR" })
	_cEmpAKD := CEMPANT+aCols[n,nPosEmp]
    cRet := u_ItemSZ3(ALLTRIM(_cEmpAKD),"AKD")   
	// Alimenta classe de valor
    aCols[n,nPosClv] := Substr(cRet,1,2)
Endif      

Restarea(aArea)
RETURN(cRet)


User Function ItemSZ3(_cEmpresa,cAreaSav)
Local _cItemRet := SPACE(TAMSX3("Z3_ITEM")[1])
_cAreasZ3 := GetArea("SZ3")
_cAreaPos := GetArea(cAreaSav)
DbSelectArea("SZ3")
IF SZ3->(DbSeek(xFilial("SZ3")+_cEmpresa))
	_cItemRet := SZ3->Z3_ITEM  
	_lAltProj := SZ3->Z3_ALTPROJ 
	//lPermAlt := iif(_lAltProj = "F",.F.,.T.)  
	lPermAlt := _lAltProj	
Else
	ShowHelpDlg("ITEMSZ3", {"Não localizado item contábil para empresa "+_cEmpresa,""},3,{"Verifique amarrações SZ3 - Empresa x Projeto.",""},3)
Endif

RestArea(_cAreasZ3)
RestArea(_cAreaPos)
Return(_cItemRet)