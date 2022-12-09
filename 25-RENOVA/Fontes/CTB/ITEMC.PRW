#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ITEMC     ºAutor  ³Leandro Duarte      º Data ³  11/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para identificar se permite a edição do Campo Projetoº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ITEMC()
Local 	lRet 	  := .T.
Local 	_cRetFunc := ""
Private _cRetFunc := ''
Private lPermAlt  := .T.

// Solicitação de compras
If ALLTRIM(FUNNAME()) = "MATA110"
	nPosEmp := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "C1_FILDEST" })
	nPosClv := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "C1_CLVL" })
	_cEmpSC1 := CEMPANT+aCols[n,nPosEmp]
	cRetItem := u_ItemSZ3(_cEmpSC1,"SC1")
Endif                                                  

// Contas a pagar
If ALLTRIM(FUNNAME()) = "FINA050"
	_cEmpSE2 := CEMPANT+CFILANT
	cRetItem := u_ItemSZ3(_cEmpSE2,"SE2")
Endif

// Contratos
If ALLTRIM(FUNNAME()) = "CNTA120"
	If ! CN1->CN1_ESPCTR="2"    // Se for contrato de vendas permite alterar o Projeto 
		 nPosEmp := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "CNE_ITEMCT" })
	     If nPosEmp <> 0   //Encerramento da medição   
			_cEmpCNE := aCols[n,nPosEmp] 
			_cEmpCNE := CEMPANT+CFILANT
			cRetItem := u_ItemSZ3(_cEmpCNE,"CNE")    
		EndIf	
	EndIf
Endif   

// Pedido de Compras
If ALLTRIM(FUNNAME()) = "MATA121"  
	//Necessário esse trecho apenas para chamar a função e setar a variável "lPermAlt"
	_cEmpSC7 := CEMPANT+CfilAnt
	cRetItem := u_ItemSZ3(_cEmpSC7,"SC7")
EndIf

//LANÇAMENTOS PCO - AKD
If ALLTRIM(FUNNAME()) = "PCOA050"
	nPosEmp := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "AKD_OPER" })
	nPosClv := ASCAN(AHEADER,{|Z| ALLTRIM(Z[2]) == "AKD_CLVLR" })
	_cEmpAKD := CEMPANT+aCols[n,nPosEmp]
	cRetItem := u_ItemSZ3(ALLTRIM(_cEmpAKD),"AKD")
Endif        

If ! lPermAlt
	alert("Não é permitida a alteração para a empresa/Filial Selecionada")
	lRet := .F.
Else
	If ALLTRIM(FUNNAME()) = "MATA110"
		// Alimenta classe de valor
		aCols[n,nPosClv] := Substr(cRetItem,1,2)
	ElseIf ALLTRIM(FUNNAME()) = "FINA050" 
		// Alimenta classe de valor
		M->E2_CLVLDB := Substr(cRetItem,1,2) 
	Endif
Endif
return(lRet)