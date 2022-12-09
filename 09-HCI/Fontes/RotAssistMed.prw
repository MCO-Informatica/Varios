#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RotAssistMed ³ Autor ³ Eduardo Porto         ³ Data ³ 08.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria Verba de Desconto da Ass. Medica                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMake ( DOS e Windows )                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para HCI                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                             ³±±
±±³            ³        ³      ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RotAssistMed()

//Montando Variaveis de Trabalho
nVlrFunc  := 0
nVlrEmp   := 0
VlrDesc1_ := 0
aTAssMed := {}               
cAssMed := " "
cD_AssMed := " "
cVerba    := "565"
cVerbaEmp := "799"
nPartEmp := 0
nPerc := 0
nQtdeFunc := 0  
nQtde	  := 0  
cDescPlan:=" " 
lRet := .T.     
cD_DescPlan := " " 
nD_vlrDesc1_ := 0
nD_Perc     := 0
//Processamento
 
cD_AssMed := Posicione("SRJ",1, SRA->RA_FILIAL + SRA->RA_CODFUNC, "RJ_ASSMED_")

// CALCULO DA ASSISTENCIA MEDICA PARA O FUNCIONARIO

		If !Empty(SRA->RA_ASMEDIC)
			//Localiza Parametros
			U_CVAssMed(SRA->RA_ASMEDIC)
			U_D_CVAssMed(cD_AssMed)

                 If (nPos := Ascan(aTAssMed,{ |X| X[1] = cVerba })) > 0
                 	aTAssMed[nPos,2] := aTAssMed[npos,2] + 1 
                 	aTAssMed[nPos,3] := aTAssMed[nPos,3] + (VlrDesc1_ - nD_vlrDesc1_)
                 	aTAssMed[nPos,4] := aTAssMed[nPos,4] + nD_vlrDesc1_
                 Else
                    Aadd(aTAssMed,{cVerba,1,(VlrDesc1_ - nD_vlrDesc1_),nD_vlrDesc1_})
                 Endif   	
                 nQtdeFunc := 1
		End       

// CALCULO DA ASSISTENCIA MEDICA PARA OS DEPENDENTES DO FUNCIONARIO

dBSelectArea("SRB")
dBSetOrder(1)

SRB->(dbSetOrder(1))

//Pesquisa Dependente
SRB->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT))

If SRB->(Found())
	While SRA->RA_FILIAL+SRA->RA_MAT == SRB->RB_FILIAL+SRB->RB_MAT
	
		// Se Agregado de Ass. Medica 
		If !empty(SRB->RB_ASSMED_)
			
		
			//Localiza Parametros
			U_CVAssMed(SRB->RB_ASSMED_)

	                 If (nPos := Ascan(aTAssMed,{ |X| X[1] = cVerba })) > 0
	                 	aTAssMed[nPos,2] := aTAssMed[npos,2] + 1 
	                 	If SRB->RB_GRAUPAR = "C" .And. SRB->RB_SEXO = "M"
	                 		aTAssMed[nPos,3] := aTAssMed[nPos,3] + VlrDesc1_ 
	                 		aTAssMed[nPos,2] := aTAssMed[npos,2] - 1 
	                 	Else
	                 	   	aTAssMed[nPos,3] := aTAssMed[nPos,3] + (VlrDesc1_ - nD_vlrDesc1_) + ((nD_vlrDesc1_*nPerc)/100)
	                 	   	aTAssMed[nPos,4] := aTAssMed[nPos,4] + (nD_vlrDesc1_ - ((nD_vlrDesc1_*nPerc)/100))
	                 	EndIf
	                 Else
	                 	If SRB->RB_GRAUPAR = "C" .And. SRB->RB_SEXO = "M"
	                 		Aadd(aTAssMed,{cVerba,0,VlrDesc1_})
	                 	Else
	                 	    Aadd(aTAssMed,{cVerba,1,(VlrDesc1_ - nD_vlrDesc1_) + ((nD_vlrDesc1_*nPerc)/100),(nD_vlrDesc1_ - ((nD_vlrDesc1_*nPerc)/100))})
	                 	EndIf
	                 Endif   	

		End       

        SRB->(dbSkip())
	End
End
 
//Calculo


  If len(aTAssMed) > 0

                /* POSICÕES DO ARRAY ATASSMED
                 	aTAssMed[nPos,1] := Código da verba a ser descontado
                 	aTAssMed[nPos,2] := Quantidade de Dependentes
                 	aTAssMed[nPos,3] := Valor total do desconto do Funcionário
                 	aTAssMed[nPos,4] := Valor total da parte da empresa
                 */
        For x:=1 to len(aTAssMed)
        
	        // valor do desconto do funcionário
  		    fGeraVerba(aTAssMed[x,1],aTAssMed[x,3],aTAssMed[x,2],,,,,,,,.T.)

			nVlrEmp   := nVlrEmp + aTAssMed[x,4]
			nQtde     := nQtde + aTAssMed[x,2]

        Next


        If nVlrEmp > 0
	        // valor da parte da empresa
  		    fGeraVerba(cVerbaEmp,nVlrEmp,nQtde,,,,,,,,.T.)
        Endif
		

 Endif 

Return(" ")



User Function CVAssMed(cAssMed) 

dBSelectArea("RCC")
dBSetOrder(1)
MsSeek(Space(2) + "U003" +Space(8) + "0" + cAssMed + cAssMed)

If RCC->(Found())
        
		cDescPlan := Substr(RCC_CONTEU,3,30)        
        VlrDesc1_ := Val(Substr(RCC_CONTEU,33,10))
		nPerc  	  := Val(Substr(RCC_CONTEU,43,10)) 
 
End          

Return(VlrDesc1_,cDescPlan,nPerc)   

User Function D_CVAssMed(cD_AssMed) 

dBSelectArea("RCC")
dBSetOrder(1)

MsSeek(Space(2) + "U003" +Space(8) + "0" + cD_AssMed + cD_AssMed)


If RCC->(Found())
        
		cD_DescPlan := Substr(RCC_CONTEU,3,30)        
        nD_vlrDesc1_ := Val(Substr(RCC_CONTEU,33,10))
		nD_Perc     := Val(Substr(RCC_CONTEU,43,10)) 
 
End          

Return(nD_vlrDesc1_,cD_DescPlan,nD_Perc)





