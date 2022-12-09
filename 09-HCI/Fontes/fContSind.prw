#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fContSindºAutor  ³Jose Carlos Gouveia º Data ³  28/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo das Contribuições Sindicais                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - TV Tribuna                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlter. Por³ Data     ³      Alteracao                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fContSind()

SetPrvt("nVlr_,nPer_,nDesc_,cCalcS_,nLinMax_,nSal_,nSalCat_,cMes_,cVrb_")
SetPrvt("aSavRCE_,nSalCalc_,nPerDes_,cMesDes_,lCalSind_,lCalTp1_,lCalTp2")

//Inicia Variaveis
cMes_		:= ''
cMesDes_	:= ''
cVrb_		:= ''
nVlr_		:= 0
nPer_		:= 0
nDesc_		:= 0
cCalcS_		:= 0
nLimMin_	:= 0
nLimMax_	:= 0
nSal_		:= 0
nSalCat_	:= 0
nSalCalc_	:= 0
nPerDes_	:= 0
lCalSind_	:= .F.
lCalTp1_	:= .F.
lCalTp2_	:= .F.
aSavRCE_	:= {}

//Processamento 
//Salva Ambiente RCE
aSavRCE_ :=  RCE->(GetArea())

//Posiciona Ordem
RCE->(dbSetOrder(1))

//Carrega Piso da Categoria
nSalCat_	:= RCE->RCE_PISCAT

//Carrega Salario Base
nSal_ 		:= Salario

//Carrega Mes de Desconto
cMesDes_	:= StrZero(Month(dData_Pgto),2)

If RCE->(dbSeek(xFilial("RCE") + SRA->RA_SINDICA))
	
	//Verifica Mes para Calculo Folha e 13 Salario
	//Mensalidade Sindical
	cMes_		:= RCE->RCE_MDEMSI
	If cMesDes_	$ cMes_ 
		lCalSind_	:= .T.
	Endif	

	//Se Calculo 13 salario
	If c__Roteiro $ "131-132" 
		If "13" $ cMes_
			lCalSind_	:= .T.
		Else
			lCalSind_	:= .F.
		Endif
	Endif
					
	//Contribuicao Tipo 01 
	cMes_		:= RCE->RCE_MDESC1
	If cMesDes_	$ cMes_ 
		lCalTp1_	:= .T.
	Endif	
	
	//Se Calculo 13 salario
	If c__Roteiro $ "131-132" 
		If "13" $ cMes_
			lCalTp1_	:= .T.
		Else
			lCalTp1_	:= .F.
		Endif
	Endif
	
	//Contribuicao Tipo 02
	cMes_		:= RCE->RCE_MDESC2
	If cMesDes_	$ cMes_ 
		lCalTp2_	:= .T.
	Endif	
	
	//Se Calculo 13 salario
	If c__Roteiro $ "131-132" 
		If "13" $ cMes_
			lCalTp2_	:= .T.
		Else
			lCalTp2_	:= .F.
		Endif
	Endif
					
	//Calcula Mensalidade Sindical
	If SRA->RA_MENSIN == "S" .And. lCalSind_
		
		//Carrega Variaveis
		cVrb_		:= RCE->RCE_VRBMSI
		nVlr_		:= RCE->RCE_VALFMS
		nPer_		:= RCE->RCE_PMSIND
		nDesc_		:= 0
		cCalcS_		:= RCE->RCE_CALMSI
		nLimMin_	:= RCE->RCE_VLMNSI
		nLimMax_	:= RCE->RCE_VALMSI

		If nVlr_ > 0
			nDesc_ := nVlr_
		Else	
			//Verifica Base de Calculo
			If cCalcS_ == "P" //Piso da Categoria
				nSalCalc_ := nSalCat_
			Else 			  //Salario Base
				nSalCalc_ := nSal_
			Endif			
		
			nDesc_ := Round(nSalCalc_ * nPer_/100,2)

			If (nLimMin_ > 0) .And. (nDesc_ < nLimMin_)
				nDesc_ := nLimMin_
			Endif	
			
			If (nLimMax_ > 0) .And. (nDesc_ > nLimMax_)
				nDesc_ := nLimMax_
			Endif	
		Endif
		
		//Gera Verba
		If nDesc_ > 0
			fGeraVerba(cVrb_,nDesc_,nPer_)
		Endif	
	
	Endif
	    
    If !Empty(SRA->RA_CONTSIN)
    	
    	If SRA->RA_CONTSIN == RCE->RCE_TIPCO1 .And. lCalTp1_
		
			//Carrega Variaveis
			cVrb_		:= RCE->RCE_VRB1
			nVlr_		:= RCE->RCE_VALFI1
			nPer_		:= RCE->RCE_PERDE1
			nDesc_		:= 0
			cCalcS_		:= RCE->RCE_CALSO1
			nLimMax_	:= RCE->RCE_VALMA1
			nLimMin_    := RCE->RCE_VALMI1
			nPerDes_	:= RCE->RCE_DESTP1

			If nVlr_ > 0
				nDesc_ := nVlr_
			Else	
				//Verifica Base de Calculo
				If cCalcS_ == "P" //Piso da Categoria
					nSalCalc_ := nSalCat_
				Else 			  //Salario Base
					nSalCalc_ := nSal_
				Endif			
		
				nDesc_ := Round(nSalCalc_ * nPer_/100,2)

				If (nLimMin_ > 0) .And. (nDesc_ < nLimMin_)
					nDesc_ := nLimMin_
				Endif	
				
				If (nLimMax_ > 0) .And. (nDesc_ > nLimMax_)
					nDesc_ := nLimMax_
				Endif	
			Endif
				
			//Desconto Se Socio do Sindicato
			If SRA->RA_MENSIN == "S"
				If nPerDes_ > 0
					nDesc_ := Round(nDesc_ * (100 - nPerDes_)/100,2)
				Endif
			Endif
		
			//Gera Verba
			If nDesc_ > 0
				fGeraVerba(cVrb_,nDesc_,nPer_)
			Endif

		Endif
		
		If SRA->RA_CONTSIN == RCE->RCE_TIPCO2 .And. lCalTp2_
		
			//Carrega Variaveis
			cVrb_		:= RCE->RCE_VRB2
			nVlr_		:= RCE->RCE_VALFI2
			nPer_		:= RCE->RCE_PERDE2
			nDesc_		:= 0
			cCalcS_		:= RCE->RCE_CALSO2 
			nLimMin_    := RCE->RCE_VALMI2
			nLimMax_	:= RCE->RCE_VALMA2
			nPerDes_	:= RCE->RCE_DESTP2

			If nVlr_ > 0
				nDesc_ := nVlr_
			Else	
				//Verifica Base de Calculo
				If cCalcS_ == "P" //Piso da Categoria
					nSalCalc_ := nSalCat_
				Else 			  //Salario Base
					nSalCalc_ := nSal_
				Endif			
		
				nDesc_ := Round(nSalCalc_ * nPer_/100,2)

				If (nLimMin_ > 0) .And. (nDesc_ < nLimMin_)
					nDesc_ := nLimMin_
				Endif	
				
				If (nLimMax_ > 0) .And. (nDesc_ > nLimMax_)
					nDesc_ := nLimMax_
				Endif	
			Endif
		
			//Desconto Se Socio do Sindicato
			If SRA->RA_MENSIN == "S"
				If nPerDes_ > 0
					nDesc_ := Round(nDesc_ * (100 - nPerDes_)/100,2)
				Endif
			Endif
						
			//Gera Verba
			If nDesc_ > 0
				fGeraVerba(cVrb_,nDesc_,nPer_)
			Endif

		Endif
	Endif	
Endif		
		
//Retorna Ambiente RCE
RCE->(RestArea(aSavRCE_))

Return("FIM")	    		

//Fim da Rotina

//Fim do Programa