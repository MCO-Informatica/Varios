#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fContSindºAutor  ³Jose Carlos Gouveia º Data ³  28/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo das Contribuições Sindicais                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 -                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlter. Por³ Data     ³      Alteracao                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºJ.CARLOS  ³12.09.06  ³Inclusao verificacao do valor minimo de desconto º±±
±±ºJ.CARLOS  ³26.03.08  ³Inclusao composicao de base de contribuicao      º±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fContSind()

//Inicia Variaveis
Local cMes_		:= ''
Local cMesDes_	:= ''
Local cVrb_		:= ''
Local cVrbC_	:= ''
Local cPer_		:= ''
Local nVlr_		:= 0
Local nDesc_	:= 0
Local cCalcS_	:= 0
Local nLimMax_	:= 0
Local nLimMin_	:= 0
Local nSal_		:= 0
Local nSalCat_	:= 0
Local nSalCalc_	:= 0
Local nPerDes_	:= 0
Local nX_		:= 0
Local lCalSind_	:= .F.
Local lCalTp1_	:= .F.
Local lCalTp2_	:= .F.
Local aSavRCE_	:= {}

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
		cPer_		:= RCE->RCE_PMSIND
		nDesc_		:= 0
		cCalcS_		:= RCE->RCE_CALMSI
		nLimMax_	:= RCE->RCE_VALMSI
		nLimMin_	:= RCE->RCE_VALMIS
		cVrbC_		:= ''

		//Base de Calculo
		If cPer_ == "V"			//Valor Fixo
			nDesc_ := nVlr_
		ElseIf cCalcS_ == "P" 	//Piso da Categoria
			nSalCalc_ := nSalCat_
		ElseIf cCalcS_ == "S" 	//Salario Base
			nSalCalc_ := nSal_
		Else                    //Composição de Salario
			// Separa Verbas
			For Nx_ := 1 to Len(AllTrim(RCE->RCE_VRBCS)) Step 3
			
				If nX_ == 1
					cVrbC_ := Subst(RCE->RCE_VRBCS,nX_,3)
				Else
					cVrbC_ += "," + Subst(RCE->RCE_VRBCS,nX_,3)
				Endif
			Next
					
			nSalCalc_	:= fBuscaPD(cVrbC_,"V")
		Endif			
		
		If cPer_ == "D" 		//Dias
			nDesc_ := (nSalCalc_ / 30) * nVlr_
		ElseIf cPer_ == "H" 	//Horas 
			nDesc_ := (nSalCal_ / SRA->RA_HRSMES) * nVlr_
		Else					//Percentual
			nDesc_ := nSalCal_ * (nVlr_ / 100)
		Endif

		//Verifica Limite Maximo de Desconto
		If (nLimMax_ > 0) .And. (nDesc_ > nLimMax_)
			nDesc_ := nLimMax_
		Endif                
			
		//Verifica Limite Mínimo de desconto			
		If (nLimMin_ > 0) .And. (nDesc_ < nLimMin_)
			nDesc_ := nLimMin_
		Endif				
		
		//Gera Verba
		If nDesc_ > 0
			fGeraVerba(cVrb_,nDesc_,nVlr_)
		Endif	
	
	Endif
	    
    If SRA->RA_CONTSI1 == "S" .And. lCalTp1_
		
		//Carrega Variaveis
		cVrb_		:= RCE->RCE_VRB1
		nVlr_		:= RCE->RCE_VALFI1
		cPer_		:= RCE->RCE_PERDE1
		nDesc_		:= 0
		cCalcS_		:= RCE->RCE_CALSO1
		nLimMax_	:= RCE->RCE_VALMA1
		nLimMin_	:= RCE->RCE_VALMI1
		nPerDes_	:= RCE->RCE_DESTP1
		cVrbC_		:= ''
        
		//Base de Calculo
		If cPer_ == "V"			//Valor Fixo
			nDesc_ := nVlr_
		ElseIf cCalcS_ == "P" 	//Piso da Categoria
			nSalCalc_ := nSalCat_
		ElseIf cCalcS_ == "S" 	//Salario Base
			nSalCalc_ := nSal_
		Else                    //Composição de Salario
			// Separa Verbas
			For Nx_ := 1 to Len(AllTrim(RCE->RCE_VRBC1)) Step 3
			
				If nX_ == 1
					cVrbC_ := Subst(RCE->RCE_VRBC1,nX_,3)
				Else
					cVrbC_ += "," + Subst(RCE->RCE_VRBC1,nX_,3)
				Endif
			Next
					
			nSalCalc_	:= fBuscaPD(cVrbC_,"V")
		Endif			
		
		If cPer_ == "D" 		//Dias
			nDesc_ := (nSalCalc_ / 30) * nVlr_
		ElseIf cPer_ == "H" 	//Horas 
			nDesc_ := (nSalCal_ / SRA->RA_HRSMES) * nVlr_
		Else					//Percentual
			nDesc_ := nSalCal_ * (nVlr_ / 100)
		Endif
			    
		//Verifica Limite Maximo de Desconto
		If (nLimMax_ > 0) .And. (nDesc_ > nLimMax_)
			nDesc_ := nLimMax_
		Endif	

		//Verifica Limite Mínimo de Desconto			
		If (nLimMin_ > 0) .And. (nDesc_ < nLimMin_)
			nDesc_ := nLimMin_
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
		fGeraVerba(cVrb_,nDesc_,nVlr_)
	Endif
	
	If SRA->RA_CONTSI2 == "S" .And. lCalTp2_
		
		//Carrega Variaveis
		cVrb_		:= RCE->RCE_VRB2
		nVlr_		:= RCE->RCE_VALFI2
		cPer_		:= RCE->RCE_PERDE2
		nDesc_		:= 0
		cCalcS_		:= RCE->RCE_CALSO2
		nLimMax_	:= RCE->RCE_VALMA2
		nLimMin_	:= RCE->RCE_VALMI2
		nPerDes_	:= RCE->RCE_DESTP2
		cVrbC_		:= ''

		//Base de Calculo
		If cPer_ == "V"			//Valor Fixo
			nDesc_ := nVlr_
		ElseIf cCalcS_ == "P" 	//Piso da Categoria
			nSalCalc_ := nSalCat_
		ElseIf cCalcS_ == "S" 	//Salario Base
			nSalCalc_ := nSal_
		Else                    //Composição de Salario
			// Separa Verbas
			For Nx_ := 1 to Len(AllTrim(RCE->RCE_VRBC2)) Step 3
			
				If nX_ == 1
					cVrbC_ := Subst(RCE->RCE_VRBC2,nX_,3)
				Else
					cVrbC_ += "," + Subst(RCE->RCE_VRBC2,nX_,3)
				Endif
			Next
					
			nSalCalc_	:= fBuscaPD(cVrbC_,"V")
		Endif			
		
		If cPer_ == "D" 		//Dias
			nDesc_ := (nSalCalc_ / 30) * nVlr_
		ElseIf cPer_ == "H" 	//Horas 
			nDesc_ := (nSalCal_ / SRA->RA_HRSMES) * nVlr_
		Else					//Percentual
			nDesc_ := nSalCal_ * (nVlr_ / 100)
		Endif
	
		//Verifica Limite Maximo de Desconto
		If (nLimMax_ > 0) .And. (nDesc_ > nLimMax_)
			nDesc_ := nLimMax_
		Endif	
				
		//Verifica Limite Mínimo de Desconto			
		If (nLimMin_ > 0) .And. (nDesc_ < nLimMin_)
			nDesc_ := nLimMin_
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
		fGeraVerba(cVrb_,nDesc_,nVlr_)
	Endif

Endif		
		
//Retorna Ambiente RCE
RCE->(RestArea(aSavRCE_))

Return	    		

//Fim da Rotina

//Fim do Programa