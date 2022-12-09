#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fAssMed  ºAutor  ³Jose Carlos Gouveia º Data ³  17/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo da Assistencia Médica por Idade                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10 - Varient                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlterado Por³ Data   ³      Alteracao                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º            ³        ³                                                 º±±
±±º            ³        ³                                                 º±±
±±º            ³        ³                                                 º±±
±±º            ³        ³                                                 º±±
±±º            ³        ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fAssMed()

//Inicia Variaveis
Local aDataC_	:= {}
Local aSavRCC_	:= {}
Local aSavSRB_	:= {}
Local nValorE_	:= 0
Local nValorC_	:= 0
Local nDepen_	:= 0
Local nX_		:= 0

//Salva Ambiente RCC e SRB
aSavRCC_ :=  RCC->(GetArea())
aSavSRB_ :=  SRB->(GetArea())

//Posiciona Ordem
RCC->(dbSetOrder(1))
SRB->(dbSetOrder(1))

//Processamento 
//Busca Tabela U001 - Assistencia Medica
If !Empty(SRA->RA_ASMEDIC)
	If RCC->(dbSeek(xFilial("RCC") + "U001"))

		//Localiza Assistencia Médica e Carrega Array aDataC_
		While (RCC->RCC_CODIGO == "U001") .And. RCC->(!Eof())
			aAdd(aDataC_,{Subst(RCC->RCC_CONTEU,1,2),Val(Subst(RCC->RCC_CONTEU,28,2)),Val(Subst(RCC->RCC_CONTEU,30,12)),Val(Subst(RCC->RCC_CONTEU,42,6)), ;
		       Val(Subst(RCC->RCC_CONTEU,48,6)) } )
			Rcc->(dbSkip())
		Enddo

	Else	//Nao Localizou Tabela

		//Retorna Ambiente
		RCC->(RestArea(aSavRCC_))
		SRB->(RestArea(aSavSRB_))
		
		Return(" ")
	
	Endif
	
	//Busca Valor de Desconto
	//Idade do Funcionario
	nIdade_ := Int((dDataBase - SRA->RA_NASC)/365)

	For nX_ := 1 to Len(aDataC_)
		If	SRA->RA_ASMEDIC	== aDataC_[nX_,1] .And. aDataC_[nX_,2] >= nIdade_
		        
	  		//Valor do Funcionário
			nValorC_ += aDataC_[nX_,3] * aDataC_[nX_,4]/100
			nValorE_ += aDataC_[nX_,3] * (100 - aDataC_[nX_,4])/100
										
			Exit
		Endif
	Next
				
    //Busca Dependente
	If SRB->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT))
	
		While SRB->RB_FILIAL + SRB->RB_MAT == SRA->RA_FILIAL + SRA->RA_MAT

			If SRB->RB_TPDEPAM == "1" //Dependente
				//Idade do Dependente
				nIdade_ := Int((dDataBase - SRB->RB_DTNASC)/365)
				    
				//Pesquisa Idade no Array
				For nX_ := 1 to Len(aDataC_)
					If	SRA->RA_ASMEDIC	== aDataC_[nX_,1] .And. aDataC_[nX_,2] >= nIdade_
		        
				  		//Valor do Dependente
						nValorC_ += aDataC_[nX_,3] * aDataC_[nX_,5]/100
						nValorE_ += aDataC_[nX_,3] * (100 - aDataC_[nX_,5])/100

						nDepen_	+= 1
						
						Exit
					Endif
				Next
								
			Endif
			
			SRB->(dbSkip())
			
		Enddo					
		
	Endif
	
	//Gera Verba
	//Empresa
	If nValorE_ > 0
		fGeraVerba(aCodFol[213,1],nValorE_,,,,,,,,,.T.)
	Endif
	
	//Funcionario
	If nValorC_ > 0
		fGeraVerba(aCodFol[049,1],nValorC_,nDepen_,,,,,,,,.T.)
	Endif
		
Endif

//Retorna Ambiente
RCC->(RestArea(aSavRCC_))
SRB->(RestArea(aSavSRB_))

Return(" ")

//Fim da Rotina
