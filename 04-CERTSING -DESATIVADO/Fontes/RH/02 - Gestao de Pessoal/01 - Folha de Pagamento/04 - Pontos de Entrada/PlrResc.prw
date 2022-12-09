#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PlrResc   ºAutor  ³Rafael Beghini-Totvsº Data ³  18/03/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera valor de PLR quando houver rescisao complementar.      º±±
±±º          ³Busca na SRC apos importacao da rotina de calculo da PLR.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Recursos Humanos                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PlrResc()

Local cMat     := SRG->RG_MAT
Local cVbPLR   := ''
Local cVbTxNeg := "617"
Local nVbPLR   := 0
Local nVbTxNeg := 0
Local aVbNeg   := {}

Private cAnoRef := Year(dDataBase)

cVbPLR   := aCodFol[0151,1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se for rescisao complementar executa a verificacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCompl == 'S'

    If SRC->( dbSeek(SRG->(RG_FILIAL+RG_MAT)+cVbPLR) ) .And. (SRG->(RG_FILIAL+RG_MAT)+cVbPLR) = SRC->(RC_FILIAL+RC_MAT+RC_PD)
       nVbPLR := SRC->RC_VALOR
    EndIf
    
    If SRC->( dbSeek(SRG->(RG_FILIAL+RG_MAT)+cVbTxNeg) ) .And. (SRG->(RG_FILIAL+RG_MAT)+cVbTxNeg) = SRC->(RC_FILIAL+RC_MAT+RC_PD)
       nVbTxNeg := SRC->RC_VALOR
    EndIf

	If nVbPLR > 0
		//Gera a verba 391 - PLR
		fGeraVerba('391', nVbPLR,,,,'V',,0,,, .T.)
	EndIf
	
	If nVbTxNeg > 0 
    	//Gera a verba 617 - Taxa Negocial
		fGeraVerba('617', nVbTxNeg,,,,'V',,0,,, .T.)
	EndIf
	
	FPLRIR(aCodFol,Nil,.T.) //-> Caçculo o IR sobre a PLR.
		
EndIf

Return(.T.)


Static Function FPLRIR(aCodFol,cSem,lDep)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FPLRIR   ºAutor  ³Alexandre AS - OPVS º Data ³  05/03/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Apura IR da PLR na Rescisao Complementar.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Recursos Humanos                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Local nAliq     := 0,nValPePLR := 0
Local aCodBenef := {}
Local nCntP,nPosP,nPosRed
Local nValDepLr               := 0.00
Local cDataIR     := If(Type(AnoMes(MV_PAR09))!='U',AnoMes(MV_PAR09),cFolMes)
 
aTabIrPlr := {}
 
CarIRPlr(aTabIrPlr,cDataIR)
 
cSem := If (cSem == Nil ,cSemana,cSem)
 
If aCodfol[151,1] # Space(3) .And. aCodFol[152,1] # Space(03) .And. !Empty(aTabIrPlr)
                nPos := Ascan(aPd, { |X| X[1] = aCodfol[151,1] .And. X[3] = cSem .And. X[9] # "D"})
                IF nPos > 0
                   //-> Busca os codigos de pensao definidos no cadastro beneficiario.
                   fBusCadBenef(@aCodBenef)
                              
                   nValPePLR := 0
                   For nCntP := 1 To Len(aCodBenef)
                       nPosP := Ascan(aPD , { |X| X[1] == aCodBenef[nCntP,8] .And. X[9] # "D" })
                       nValPePLR += IF(nPosP > 0 , aPd[nPosP,5] , 0)
                   Next nCntP
                              
                   nIr_b := aPd[nPos,5]
                   nIr   := 0.00

                   //-> Redutor da base de IR na participacao dos lucros.
                      nPosRed := Ascan(aPd, { |X| X[1] = aCodfol[411,1] .And. X[3] = cSem .And. X[9] # "D"})
                   If nPosRed > 0
                      nIr_b := Max( nIr_b - aPd[nPosRed,5], 0 )
                   EndIf
 
                   Calc_IrPLR(nIr_B , nValPePLR, @nIr , 0 ,@nValDepLr,, aTabIrPlr,,@nAliq)

                   BASE_INI := nIr_B  //-> Guarda o valor da base na variavel referente base IR de adiantamento.
 
                   //-> Gerar Ir Dist. Lucro                                                                                                                                                ³
                   FMatriz(aCodfol[152,1],nIr,nAliq,cSem,,,If(c__ROTEIRO=="ADI","A",NIL))
 
                   //-> Gerar Ded.Dep. Distr. Lucro.                                                                                                                            ³
                   If aCodFol[300,1] # Space(3)  .And. lDep .And. nValDepLr > 0
                      FMatriz(aCodfol[300,1],nValDepLr,Val(Sra->Ra_depir),cSem)

                      //->Zera o valor da variavel de dependente folha pois o valor do dependente sera pago na verba de PLR.
                      VAL_DEDDEP := 0
                   Endif
                              
                EndIf
EndIf     
 
IF Empty(aTabIrPlr)
   If aCodfol[151,1] # Space(3) .And. (nPos := Ascan(aPd, { |X| X[1] = aCodfol[151,1] .And. X[3] = cSem .And. X[9] # "D"}) > 0 )
           aHelpPor             := {}
      AADD(aHelpPor,'Cálculo de IR s/ PLR não foi realizado')
      AADD(aHelpPor,'devido a falta de informação na tabela.')
      PutHelp("PIRPLR",aHelpPor,aHelpPor,aHelpPor,.F.)  
                              
           aHelpPor             := {}
      AADD(aHelpPor,'Preencha a tabela S044 de acordo') 
      AADD(aHelpPor,'com o Mes/Ano do cálculo.')
      PutHelp("SIRPLR",aHelpPor,aHelpPor,aHelpPor,.F.)
                              
      Help("",1,"IRPLR")      
   Endif
Endif    
 
Return Nil