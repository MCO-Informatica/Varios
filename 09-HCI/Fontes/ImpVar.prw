#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  ImpVar  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 02.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Programa de Importacao de Variaveis para a Tabela SRC       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data     ³              Alteracao                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 21.06.05 ³Acrescentado opcao para incluir na tabela de Valores Extras ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ImpVar() 

SetPrvt("aVerb_,aSay_,aButt_,cVerb_,cCad_,cPerg_,cArq_,cBuf_,cFil,cMat_,nOpc_,nLin_,nX_,nVez_,nPos_")
SetPrvt("cVal_,nVal_,lCont_,nChoice_,nLanc_,cSem_,nDem_,nSeq_")

//Inicia Variaveis
aVerb_ 		:= {}
aSay_		:= {}
aButt_		:= {}
cVerb_		:= ""
cCad_		:= ""
cPerg_		:= "" 
cArq_		:= ""
cBuf_		:= ""
cFil_		:= ""
cMat_ 		:= ""
cVal_		:= ""
cSem_		:= ""
nOpc_		:= 0
nChoice_	:= 1
nLin_ 		:= 1
nVez_		:= 1
nPos_		:= 0 
nVal_		:= 0
nX_			:= 0 
nLanc_		:= 0
nDem_		:= 0
nSeq_		:= 0	
lCont_		:= .T. 
                
//Processamento
cCad_		:= "Importacao de Variaveis"
cPerg_		:= "IMPSRC"

aAdd( aSay_, "Esta rotina ira importar valores variaveis de um arquivo" )
aAdd( aSay_, " texto com formatacao especifica para as tabelas SRC ou SR1" )

aAdd( aButt_, { 5,.T.,{|| Pergunte(cPerg_,.T.)    }})
aAdd( aButt_, { 1,.T.,{|| FechaBatch(),nOpc_ := 1 }})
aAdd( aButt_, { 2,.T.,{|| FechaBatch()            }})

//Verifica Perguntas
fCriaSx1(cPerg_)
Pergunte(cPerg_,.F.)
                    
//Monta Tela Inicial
FormBatch( cCad_, aSay_, aButt_ )

If nOpc_ == 1
	Processa( {|| ImpSRC() }, "Processando..." )
Endif
        
Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  ImpSRC  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 02.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Importacao de Variaveis para a Tabela SRC e SR1   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpSRC() 

//Variaveis da pergunta
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ mv_par01    Nome do Arquivo       Drive, path e nome do arquivo      ³
//³ mv_par02    Lancamento Existente  Opcao se lancamento ja existe      ³
//³ mv_par03    Lancar                Valores Mensais/Valores Extras     ³
//³ mv_par04    Semana (Val.Extras)   Numero da Semana de Valores Extras ³
//³ mv_par05    Data Pgto Val.Extras  Data de Pagamento Valores Extras   ³
//³ mv_par06    Importar Demitidos    Importar Demitidos                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArq_		:= mv_par01
nChoice_	:= mv_par02
nLanc_		:= mv_par03
cSem_		:= mv_par04
dData_		:= If(Empty(mv_par05),dDataBase,mv_par05)
nDem_		:= mv_par06

//Verifica existencia do arquivo
If !File(cArq_)
   MsgAlert("Arquivo texto " + AllTrim(cArq_) + " nao localizado",cCad_)
   Return
Else
    
	//Abertura do Arquivo
	FT_FUSE(cArq_)
	FT_FGOTOP()
	
	ProcRegua(FT_FLASTREC())

	While !FT_FEOF() .And. lCont_
	
		//Incrementa Regua		
		IncProc()

		cBuf_ := FT_FREADLN()

		 //Lendo Header do Arquivo		
		If nLin_ == 1
			//Carrega array com verbas
			While Len(cBuf_) > 1

				//Isolar Verbas a partir da 2a Coluna
				If nVez_ > 2                             
				
					If At(";",cBuf_) > 0
						nPos_ := At(";",cBuf_) - 1
					Else
						nPos_ := Len(AllTrim(cBuf_))
					Endif
						
					cVerb_ := fVerZero(AllTrim(Subst(cBuf_,1,nPos_)),3)
					aAdd(aVerb_,cVerb_)
					
				Endif
				nVez_ += 1 

				If At(";",cBuf_) > 0
					cBuf_ := Subst(cBuf_,At(";",cBuf_) + 1)	
				Else
					cBuf_ := ""
				Endif		

			Enddo
			nLin_ += 1
			FT_FSKIP()
						
			Loop
		Endif	

		//Filial
		//Verifica se filial vazia
		If Len(Subst(cBuf_,1,At(";",cBuf_) - 1)) = 0
			lCont_ := .F.
			Loop
		Endif
					
		cFil_ := fVerZero(Subst(cBuf_,1,At(";",cBuf_) - 1),2)

		cBuf_ := Subst(cBuf_,At(";",cBuf_) + 1)		

		//Matricula
		cMat_ := fVerZero(Subst(cBuf_,1,At(";",cBuf_) - 1),6)
		
		cBuf_ := Subst(cBuf_,At(";",cBuf_) + 1)				
				
		//Verifica Existencia de Funcionario
		If Empty(Posicione("SRA",1,cFil_ + cMat_ ,"RA_MAT"))
			FT_FSKIP()
			Loop
		Endif
		
		//Verifica Demitidos
		If nDem_ == 2
			If SRA->RA_SITFOLH == "D"
				FT_FSKIP()
				Loop
			Endif
		Endif	

		//Separa Valores
		For nX_ := 1 to Len(aVerb_)
		
			If !Empty(Posicione("SRV",1,xFilial("SRV") + aVerb_[nX_] ,"RV_COD"))
			
				If At(";",cBuf_) > 0
					nPos_ := At(";",cBuf_) - 1
				Else
					nPos_ := Len(AllTrim(cBuf_))
				Endif
				
				cVal_ := fVerNum(Subst(cBuf_,1,nPos_))
				
				nVal_ := Val(cVal_)

				If nVal_ > 0
				
					If nLanc_ == 1 //Valores Mensais
					
						If SRC->(dbSeek(cFil_ + cMat_ + aVerb_[nX_]))
							
								//Carrega Sequencia
								nSeq_	:= Val(SRC->RC_SEQ)
					    
							//nChoice_ == 4 Manter o Registro
						
							If nChoice_ == 1 //Sobrepor
								If RecLock("SRC",.F.)
									SRC->RC_HORAS	:= Iif(SRV->RV_TIPO $ "H*D",nVal_,0)
									SRC->RC_VALOR	:= Iif(SRV->RV_TIPO == "V",nVal_,0)
									SRC->RC_SEQ		:= AllTrim(Str(nSeq_ + 1))
								Endif
							ElseIf nChoice_ == 2 //Somar
								If RecLock("SRC",.F.)
									SRC->RC_HORAS	+= Iif(SRV->RV_TIPO $ "H*D",nVal_,0)
									SRC->RC_VALOR	+= Iif(SRV->RV_TIPO == "V",nVal_,0)
									SRC->RC_SEQ		:= AllTrim(Str(nSeq_ + 1))
								Endif
							ElseIf nChoice_ == 3 //Incluir Novo Lançamento	
								If RecLock("SRC",.T.)			        
									SRC->RC_FILIAL	:= cFil_
									SRC->RC_MAT		:= cMat_ 
									SRC->RC_PD		:= aVerb_[nX_]
									SRC->RC_HORAS	:= Iif(SRV->RV_TIPO $ "H*D",nVal_,0)
									SRC->RC_VALOR	:= Iif(SRV->RV_TIPO == "V",nVal_,0)
									SRC->RC_CC		:= SRA->RA_CC
									SRC->RC_TIPO1	:= SRV->RV_TIPO
									SRC->RC_TIPO2	:= "G"
									SRC->RC_SEQ		:= AllTrim(Str(nSeq_ + 1))
								Endif			
								msUnlock()
							Endif	
						Else
							If RecLock("SRC",.T.)			        
								SRC->RC_FILIAL	:= cFil_
								SRC->RC_MAT		:= cMat_ 
								SRC->RC_PD		:= aVerb_[nX_]
								SRC->RC_HORAS	:= Iif(SRV->RV_TIPO $ "H*D",nVal_,0)
								SRC->RC_VALOR	:= Iif(SRV->RV_TIPO == "V",nVal_,0)
								SRC->RC_CC		:= SRA->RA_CC
								SRC->RC_TIPO1	:= SRV->RV_TIPO
								SRC->RC_TIPO2	:= "G"
								SRC->RC_SEQ		:= AllTrim(Str(nSeq_ + 1))
							Endif
							msUnlock()
						Endif	
					ElseIf nLanc_ == 2 //Valores Extras
					
						If SR1->(dbSeek(cFil_ + cMat_ + cSem_ + aVerb_[nX_]))
					    
							//nChoice_ == 4 Manter o Registro
						
							If nChoice_ == 1 //Sobrepor
								If RecLock("SRC",.F.)
									SR1->R1_HORAS	:= Iif(SRV->RV_TIPO $ "H*D",nVal_,0)
									SR1->R1_VALOR	:= Iif(SRV->RV_TIPO == "V",nVal_,0)
									SR1->R1_SEQ		:= AllTrim(Str(nSeq_ + 1))
								Endif
							ElseIf nChoice_ == 2 //Somar
								If RecLock("SR1",.F.)
									SR1->R1_HORAS	+= Iif(SRV->RV_TIPO $ "H*D",nVal_,0)
									SR1->R1_VALOR	+= Iif(SRV->RV_TIPO == "V",nVal_,0)
									SR1->R1_SEQ		:= AllTrim(Str(nSeq_ + 1))
								Endif
							ElseIf nChoice_ == 3 //Incluir Novo Lançamento	
								If RecLock("SR1",.T.)			        
									SR1->R1_FILIAL	:= cFil_
									SR1->R1_MAT		:= cMat_ 
									SR1->R1_PD		:= aVerb_[nX_]
									SR1->R1_HORAS	:= Iif(SRV->RV_TIPO $ "H*D",nVal_,0)
									SR1->R1_VALOR	:= Iif(SRV->RV_TIPO == "V",nVal_,0)
									SR1->R1_CC		:= SRA->RA_CC
									SR1->R1_TIPO1	:= SRV->RV_TIPO
									SR1->R1_TIPO2	:= "G"
									SR1->R1_SEMANA	:= cSem_
									SR1->R1_DATA	:= dData_
									SR1->R1_SEQ		:= AllTrim(Str(nSeq_ + 1))
								Endif			
								msUnlock()
							Endif	
						Else
							If RecLock("SR1",.T.)			        
								SR1->R1_FILIAL	:= cFil_
								SR1->R1_MAT		:= cMat_ 
								SR1->R1_PD		:= aVerb_[nX_]
								SR1->R1_HORAS	:= Iif(SRV->RV_TIPO $ "H*D",nVal_,0)
								SR1->R1_VALOR	:= Iif(SRV->RV_TIPO == "V",nVal_,0)
								SR1->R1_CC		:= SRA->RA_CC
								SR1->R1_TIPO1	:= SRV->RV_TIPO
								SR1->R1_TIPO2	:= "G"
								SR1->R1_SEMANA	:= cSem_
								SR1->R1_DATA	:= dData_
								SR1->R1_SEQ		:= AllTrim(Str(nSeq_ + 1))
							Endif
							msUnlock()
						Endif	
					
					Endif
	
				Endif	

			Endif
			
			cBuf_ := Subst(cBuf_,At(";",cBuf_) + 1)
									
		Next									

		FT_FSKIP()    	
		
    Enddo   
    
Endif

FT_FUSE()

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  fVerZero    ³ Autor ³Jose Carlos Gouveia³ Data ³ 01.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica e Preenche Zeros a Esquerda                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVerZero(cStr,nQtd)

//Retira espacos
cStr := AllTrim(cStr) 
                          
While Len(cStr) < nQtd

	cStr := "0" + cStr
	
Enddo

Return(cStr)

//Fim da Rotina	


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³   fVerNum    ³ Autor ³Jose Carlos Gouveia³ Data ³ 01.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica e Numero Trocando , por . e Retirando .           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVerNum(cStr)

//Retira espacos
cStr := AllTrim(cStr)

//Verifica se há vírgula na String
If At(",",cStr) = 0

	Return(cStr)

Endif

//Retira Ponto
While At(".",cStr) > 0

	cStr := Subst(cStr,1,At(".",cStr) - 1) + Subst(cStr,At(".",cStr) + 1)

Enddo

//Troca Virgula por Ponto
While At(",",cStr) > 0

	cStr := Subst(cStr,1,At(",",cStr) - 1) + "." +Subst(cStr,At(",",cStr) + 1)

Enddo
	           
Return(cStr)
	                     
//Fim da Rotina	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³   fGetPath   ³ Autor ³Jose Carlos Gouveia³ Data ³ 01.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Localiza Arquivo e Diretorio                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGetPath() 

Local cRet_  := Alltrim(ReadVar())
Local cPath_ := cArq_

oWnd := GetWndDefault()

While .T.
	If Empty(cPath_)
		cPath_ := cGetFile( "Arquivos de Exportacao *.CSV |*.CSV ",OemToAnsi("Selecione Diretorio/Arquivo"),,"")
	EndIf
	
	If Empty(cPath_)
		Return .F.
	EndIf    
	
	&cRet_ := cPath_
	Exit
EndDo

If oWnd != Nil
	GetdRefresh()
EndIf

Return .T.

//Fim da Rotina     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  fCriaSZ1    ³ Autor ³Jose Carlos Gouveia³ Data ³ 01.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica  as perguntas, Incluindo-as caso n„o existam      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCriaSX1()

Local aRegs     := {}

cPerg := Left(cPerg_,6)

//X1_GRUPO,X1_ORDEM,X1_PERGUNT,X1_PERSPA,X1_PERENG,X1_VARIAVL,X1_TIPO,X1_TAMANHO,X1_DECIMAL,X1_PRESEL,X1_GSC,X1_VALID,X1_VAR01,X1_DEF01,X1_DEFSPA1,X1_DEFENG1,X1_CNT01,X1_VAR02,X1_DEF02,X1_DEFSPA2,X1_DEFENG2,X1_CNT02,X1_VAR03,X1_DEF03,X1_DEFSPA3,X1_DEFENG3,X1_CNT03,X1_VAR04,X1_DEF04,X1_DEFSPA4,X1_DEFENG4,X1_CNT04,X1_VAR05,X1_DEF05,X1_DEFSPA5,X1_DEFENG5,X1_CNT05,X1_F3,X1_PYME,X1_GRPSXG,X1_HELP  
aAdd(aRegs,{cPerg_,"01","Nome do Arquivo     ?","Nome do Arquivo     ?","Nome do Arquivo     ?","mv_ch1","C",50,0,0,"G","fGetPath","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg_,"02","Lancamento Existente?","Lancamento Existente?","Lancamento Existente?","mv_ch2","N",1,0,0,"C","","mv_par02","Sobrepor","Sobrepor","Sobrepor","","","Somar","Somar","Somar","","","Incluir","Incluir","Incluir","","","Manter","Manter","Manter","","","","","","","","","",""})
aAdd(aRegs,{cPerg_,"03","Lancar              ?","Lancar              ?","Lancar              ?","mv_ch3","N",1,0,1,"C","","mv_par03","Valores Mensais","Valores Mensais","Valores Mensais","","","Valores Extras","Valores Extras","Valores Extras","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg_,"04","Semana (Val.Extras) ?","Semana (Val.Extras) ?","Semana (Val.Extras) ?","mv_ch4","C",2,0,1,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg_,"05","Data Pgto Val.Extras?","Data Pgto Val.Extras?","Data Pgto Val.Extras?","mv_ch5","D",8,0,0,"G","NaoVazio","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg_,"06","Importar Demitidos  ?","Importar Demitidos  ?","Importar Demitidos  ?","mv_ch6","N",1,0,2,"C","","mv_par06","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg_ ,.F.)

Return

// Fim da Rotina

//Fim do Programa