#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TOPCONN.CH"

user function MATA256()
 Local aParam := PARAMIXB
    Local xRet := .T.
    Local oObj := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid := .F.
    Local nLinha := 0
    Local nQtdLinhas := 0
    Local cMsg := ""
 
    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
 
        If cIdPonto == "MODELPOS"
            cMsg := "Chamada na validação total do modelo." + CRLF
            cMsg += "ID " + cIdModel + CRLF
 
//            xRet := ApMsgYesNo(cMsg + "Continua?")

        ElseIf cIdPonto == "FORMPOS"
            
/*            cMsg := "Chamada na validação total do formulário." + CRLF
            cMsg += "ID " + cIdModel + CRLF
 
            If lIsGrid
                cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
                cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
            Else
                cMsg += "É um FORMFIELD" + CRLF
            EndIf
 
            xRet := ApMsgYesNo(cMsg + "Continua?")
            
  */         
        ElseIf cIdPonto == "FORMLINEPRE"
            
/*            If aParam[5] == "DELETE"
                cMsg := "Chamada na pré validação da linha do formulário. " + CRLF
                cMsg += "Onde esta se tentando deletar a linha" + CRLF
                cMsg += "ID " + cIdModel + CRLF
                cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
                cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
                xRet := ApMsgYesNo(cMsg + " Continua?")
            EndIf
  */          
        ElseIf cIdPonto == "FORMLINEPOS"
            
/*            cMsg := "Chamada na validação da linha do formulário." + CRLF
            cMsg += "ID " + cIdModel + CRLF
            cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
            cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
            xRet := ApMsgYesNo(cMsg + " Continua?")
  */          
        ElseIf cIdPonto == "MODELCOMMITTTS"
//           ApMsgInfo("Chamada após a gravação total do modelo e dentro da transação.")
 
            cGrOpc := oobj:aallsubmodels[1]:adatamodel[1][1][2] //SGA->GA_GROPC

			oProcess := MsNewProcess():New( { || fEstruPerc(cGrOpc) } , 'Atualizando Estruturas...' , "Aguarde..." , .F. )
		    oProcess:Activate()

        ElseIf cIdPonto == "MODELCOMMITNTTS"
//            ApMsgInfo("Chamada após a gravação total do modelo e fora da transação.")
 
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
//            ApMsgInfo("Chamada após a gravação da tabela do formulário.")
 
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
//            ApMsgInfo("Chamada após a gravação da tabela do formulário.")

        ElseIf cIdPonto == "MODELCANCEL"
        ElseIf cIdPonto == "BUTTONBAR"
        EndIf
    EndIf
Return xRet


Static Function fEstruPerc(cGrOpc)
Local aArea := GetArea()

oProcess:SetRegua1(0) //Alimenta a primeira barra de progresso
If SGA->(dbSetOrder(1), dbSeek(xFilial("SGA")+cGrOpc))
   	While SGA->(!Eof()) .And. SGA->GA_FILIAL == xFilial("SGA") .And. SGA->GA_GROPC == cGrOpc
   		cOpcional := SGA->GA_OPC
   		nPercentu := SGA->GA_PERC

   		oProcess:IncRegua1("Grupo " + cGrOpc + " Opcional " + cOpcional)
	
   		cQuery := 	 " SELECT R_E_C_N_O_ SG1REG "
   		cQuery +=	 " FROM " + RetSqlName("SG1") + " SG1 (NOLOCK) "
   		cQuery +=	 " WHERE  G1_FILIAL = '" + xFilial("SG1") + "' "
   		cQuery +=	 " AND SG1.D_E_L_E_T_ = '' "      
   		cQuery +=	 " AND SG1.G1_GROPC = '" + cGrOpc + "' "
   		cQuery +=	 " AND SG1.G1_OPC = '" + cOpcional + "' "
						
   		TCQUERY cQuery NEW ALIAS "CHK1"
   		
   		Count To nReg
   		
   		CHK1->(dbGoTop())
			
		oProcess:SetRegua2(nReg) //Alimenta a primeira barra de progresso
   		While CHK1->(!Eof())
   			SG1->(dbGoTo(CHK1->SG1REG))
						
			oProcess:IncRegua2(" PA: " + AllTrim(SG1->G1_COD) + " (%): " + TransForm(nPercentu,'@E 999.99') )
            		
   			If RecLock("SG1",.F.)
   				SG1->G1_PERC	:=	nPercentu
   				SG1->(MsUnlock())
   			Endif
						
   			CHK1->(dbSkip(1))
   		Enddo
					
   		CHK1->(dbCloseArea())
					
   		SGA->(dbSkip(1))
   	Enddo
Endif

RestArea(aArea)
Return Nil 