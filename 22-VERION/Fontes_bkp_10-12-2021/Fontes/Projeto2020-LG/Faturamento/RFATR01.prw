#include "RwMake.ch"
#include "TopConn.ch"
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RFATR01   ∫Autor  ≥Fernando Macieira   ∫ Data ≥ 12/Mar/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Relatorio de NF's de Entradas e Saidas p/ Excel            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico Verion                                          ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function RFATR01()

Local aSays,aButtons,cTitulo,nOpc,cPerg,cNomRel,nAnaSin

aSays    := {}
aButtons := {}
nOpc     := 0
cPerg    := "FATR01    "
cNomRel  := "RFATR01"
cTitulo  := "Entradas e SaÌdas"

ValidPerg(@cPerg)
Pergunte(cPerg,.f.)

aAdd(aSays,"V E R I O N")
aAdd(aSays,"-------------------------------------------------------------------------------------")
aAdd(aSays,"Programa para exportar as notas fiscais de Entradas e SaÌdas em arquivo.")
aAdd(aSays,"")
aAdd(aSays,"AtenÁ„o:----------------------------------------------------------------------")
aAdd(aSays,"Arquivo: o caractere separador ser·:  ;  ")
aAdd(aSays,"Filtro CFOP: informe-os separandos-os com VÌrgula Simples")

aAdd(aButtons,{5,.t.,{|o|Pergunte(cPerg,.t.)}})
aAdd(aButtons,{1,.t.,{|o|nOpc:=1,o:oWnd:End()}})
aAdd(aButtons,{2,.t.,{|o|o:oWnd:End()}})
FormBatch(cTitulo,aSays,aButtons)

If nOpc == 1
	If msgBox("Confirma geraÁ„o do arquivo?","Confirma","YesNo")

		//Cria arquivo texto
		cDir := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",;
		OEMtoAnsi("Selecione o diretÛrio de gravaÁ„odo arquivo "+AllTrim(cNomRel)+".txt"),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)
		cDir := AllTrim(cDir)+cNomRel+".TXT"
		
		If At(".TXT",cDir) > 0
			nHdlText := fCreate(cDir)
		Else
			Aviso("Entradas/SaÌdas",;
			"N„o foi selecionado nenhum arquivo para gravar",;
			{"&Ok"},,;
			"Sem Arquivo")
		EndIf
		
		If MV_PAR19 == 2 // Analitico
			Processa({||ProcATXT(@nHdlText)},"Gerando Arquivo...")
		ElseIf MV_PAR19 == 1 // Sintetico
			Processa({||ProcSTXT(@nHdlText)},"Gerando Arquivo...")
		EndIf

	EndIf
EndIf

Return

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
Static Function ProcATXT(nHdlText)
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ

Local cTxt,nRegCount,cVend1,cVend2,cChave,nValLiq,nValBru,cQuery,cFilDe,cFilAte,cDocDe,cDocAte,cSerDe,cSerAte,cCliDe,cCliAte,cLjDe,cLjAte,cDtDe,cDtAte,cProdDe,cProdAte,cFiltro,cCFDe,cCFAte,nUsaFil,nAnaSin,cData,cRazao,cEstDe,cEstAte,cMun

cFilDe  := MV_PAR01
cFilAte := MV_PAR02
cDocDe  := MV_PAR03
cDocAte := MV_PAR04
cSerDe  := MV_PAR05
cSerAte := MV_PAR06
cCliDe  := MV_PAR07
cCliAte := MV_PAR08
cLjDe   := MV_PAR09
cLjAte  := MV_PAR10
cProdDe := MV_PAR11
cProdAte:= MV_PAR12
cDtDe   := MV_PAR13
cDtAte  := MV_PAR14
cCFDe   := MV_PAR15
cCFAte  := MV_PAR16
nUsaFil := MV_PAR17
cFiltro := MV_PAR18
//cAnaSin := MV_PAR19
cEstDe 	:= MV_PAR20
cEstAte	:= MV_PAR21
cMun	:= MV_PAR22

cTxt := ""          
cChave := ""
nRegCount := 0

If Select("WorkS") > 0
	WorkS->(dbCloseArea())
EndIf                    
                                                
cQuery := " SELECT D2_EMISSAO,D2_DOC,D2_SERIE,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_COD,D2_EST,D2_CF,D2_QUANT,D2_PRCVEN,D2_VALBRUT,D2_PICM,D2_BASEICM,D2_VALICM,D2_IPI,D2_BASEIPI,D2_VALIPI,D2_BASEISS,D2_VALISS,D2_ALQIMP5,D2_VALIMP5,D2_ALQIMP6,D2_VALIMP6 "
cQuery += " FROM " +RetSqlName("SD2") + " D2 " 

//If !empty(ALLTRIM(cMun))
//	cQuery += "Inner Join " + RetSqlName("SA1") + " A1 on D2_CLIENTE = A1_COD and D2_LOJA = A1_LOJA "
//	cQuery += " AND A1_MUN LIKE '%" + cMun + "%' AND A1.D_E_L_E_T_ = ' ' "
//endif

cQuery += " WHERE D2_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "
cQuery += " AND D2_DOC BETWEEN '"+cDocDe+"' AND '"+cDocAte+"' "
cQuery += " AND D2_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "
cQuery += " AND D2_CLIENTE BETWEEN '"+cCliDe+"' AND '"+cCliAte+"' "
cQuery += " AND D2_LOJA BETWEEN '"+cLjDe+"' AND '"+cLjAte+"' "
cQuery += " AND D2_EMISSAO BETWEEN '"+DtoS(cDtDe)+"' AND '"+DtoS(cDtAte)+"' "
cQuery += " AND D2_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "
Iif((nUsaFil)==2,cQuery += " AND D2_CF BETWEEN '"+cCFDe+"' AND '"+cCFAte+"' ",)  // Utiliza Filtro? (NAO)
Iif((nUsaFil)==1,cQuery += " AND D2_CF IN ("+AllTrim(cFiltro)+") ",) // Utiliza Filtro? (SIM)
cQuery += " AND D2_EST BETWEEN '"+cEstDe+"' AND '"+cEstAte+"' "
cQuery += " AND D2.D_E_L_E_T_=' ' "

tcQuery cQuery New Alias "WorkS"

If Select("WorkE") > 0
	WorkE->(dbCloseArea())
EndIf

cQuery := " SELECT D1_DTDIGIT,D1_DOC,D1_SERIE,D1_TIPO,D1_FORNECE,D1_LOJA,D1_COD,D1_CF,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_PICM,D1_BASEICM,D1_VALICM,D1_IPI,D1_BASEIPI,D1_VALIPI,D1_BASEISS,D1_VALISS,((D1_TOTAL+D1_VALIPI)-D1_VALICM-D1_VALIPI-D1_VALISS),D1_ALQIMP5,D1_VALIMP5,D1_ALQIMP6,D1_VALIMP6,D1_NFORI,D1_SERIORI "
cQuery += " FROM " +RetSqlName("SD1") + " D1 " 

//	cQuery += "Inner Join " + RetSqlName("SA1") + " A1 on D1_FORNECE = A1_COD and D1_LOJA = A1_LOJA "
//	cQuery += " AND A1.D_E_L_E_T_ = ' '  "
//	cQuery += " AND A1_EST BETWEEN '"+cEstDe+"' AND '"+cEstAte+"' "
//If !empty(ALLTRIM(cMun))
//	cQuery += " AND A1_MUN LIKE '%" + cMun + "%' "
//endif

cQuery += " WHERE D1_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "
cQuery += " AND D1_DOC BETWEEN '"+cDocDe+"' AND '"+cDocAte+"' "
cQuery += " AND D1_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "
cQuery += " AND D1_FORNECE BETWEEN '"+cCliDe+"' AND '"+cCliAte+"' "
cQuery += " AND D1_LOJA BETWEEN '"+cLjDe+"' AND '"+cLjAte+"' "
cQuery += " AND D1_DTDIGIT BETWEEN '"+DtoS(cDtDe)+"' AND '"+DtoS(cDtAte)+"' "
cQuery += " AND D1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "
Iif((nUsaFil)==2,cQuery += " AND D1_CF BETWEEN '"+cCFDe+"' AND '"+cCFAte+"' ",)  // Utiliza Filtro? (NAO)
Iif((nUsaFil)==1,cQuery += " AND D1_CF IN ("+AllTrim(cFiltro)+") ",) // Utiliza Filtro? (SIM)
cQuery += " AND D1.D_E_L_E_T_=' ' "

tcQuery cQuery New Alias "WorkE"

cTxt := "E_S"+";"+"DATA"+";"+"NOTA"+";"+"SERIE"+";"+"CLI_FOR"+";"+"NOME_CLI_FOR"+";"+"PRODUTO"+";"+"DESC_PROD"+";"
cTxt += "CLAS_IPI"+";"+"UF"+";"+"MUNICIP"+";"+"CFOP"+";"+"QTD"+";"+"VLR_UNIT"+";"+"VLR_BRUT"+";"+"ALIQ_ICMS"+";"+"BASE_ICM"+";"+"VLR_ICM"+";"
cTxt += "ALIQ_IPI"+";"+"BASE_IPI"+";"+"VLR_IPI"+";"+"BASE_ISS"+";"+"VLR_ISS"+";"+"ALIQ_COFINS"+";"
cTxt += "VLR_COFINS"+";"+"ALIQ_PIS"+";"+"VLR_PIS"+";"+"VLR_LIQ"+";"+"VEND"+";"+"NOME_VEND"+";"+"REPR"+";"+"NOME_REPR"
fWrite(nHdlText,cTxt+Chr(13)+Chr(10))

ProcRegua(0)

dbSelectArea("WorkS")
WorkS->(dbGoTop())
Do While WorkS->(!EOF())
	IncProc("Processados " +Chr(32)+AllTrim(Str(nRegCount+1))+ " registros (SaÌda)")

	cVend1 := Posicione("SF2",1,xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA,"F2_VEND1")
	cVend2 := Posicione("SF2",1,xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA,"F2_VEND2")
	//nValLiq:=WorkS->(D2_VALBRUT-D2_VALICM-D2_VALIPI-D2_VALISS)
	nValLiq:=WorkS->(D2_VALBRUT-D2_VALICM-D2_VALIPI-D2_VALISS-D2_VALIMP5-D2_VALIMP6)
	cData  := Right(D2_EMISSAO,2)+"/"+Substr(D2_EMISSAO,5,2)+"/"+Left(D2_EMISSAO,4)
	cRazao  := Iif(WorkS->D2_TIPO$"BD",Posicione("SA2",1,xFilial("SA2")+D2_CLIENTE+D2_LOJA,"A2_NOME"),Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_NOME"))
    cMunic  := Iif(WorkS->D2_TIPO$"BD",Posicione("SA2",1,xFilial("SA2")+D2_CLIENTE+D2_LOJA,"A2_MUN"),Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_MUN"))

    IF  (WorkS->D2_TIPO$"BD" .and. SA2->A2_EST >= cEstDe .and. SA2->A2_EST <= cEstAte .and.  iif(Empty(alltrim(cMun)),.t.,cMun $ SA2->A2_MUN )) ;
         .or.(!WorkS->D2_TIPO$"BD" .and. SA1->A1_EST >= cEstDe .and. SA1->A1_EST <= cEstAte .and.  iif(Empty(alltrim(cMun)),.t.,cMun $ SA1->A1_MUN )) 
        
  
	cTxt := ""
	cTxt += "S"+";"+cData+";"+D2_DOC+";"+D2_SERIE+";"+D2_CLIENTE+";"+cRazao+";"
	cTxt += D2_COD+";"+Posicione("SB1",1,xFilial("SD2")+D2_COD,"B1_DESC")+";"+Posicione("SB1",1,xFilial("SD2")+D2_COD,"B1_POSIPI")+";"+D2_EST+";"+cMunic+";"+D2_CF+";"
	cTxt += Iif(Left(Stuff(Str(D2_QUANT),Rat(".",Str(D2_QUANT)),1,","),1)==",",Str(D2_QUANT),Stuff(Str(D2_QUANT),Rat(".",Str(D2_QUANT)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_PRCVEN),Rat(".",Str(D2_PRCVEN)),1,","),1)==",",Str(D2_PRCVEN),Stuff(Str(D2_PRCVEN),Rat(".",Str(D2_PRCVEN)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALBRUT),Rat(".",Str(D2_VALBRUT)),1,","),1)==",",Str(D2_VALBRUT),Stuff(Str(D2_VALBRUT),Rat(".",Str(D2_VALBRUT)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_PICM),Rat(".",Str(D2_PICM)),1,","),1)==",",Str(D2_PICM),Stuff(Str(D2_PICM),Rat(".",Str(D2_PICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_BASEICM),Rat(".",Str(D2_BASEICM)),1,","),1)==",",Str(D2_BASEICM),Stuff(Str(D2_BASEICM),Rat(".",Str(D2_BASEICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALICM),Rat(".",Str(D2_VALICM)),1,","),1)==",",Str(D2_VALICM),Stuff(Str(D2_VALICM),Rat(".",Str(D2_VALICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_IPI),Rat(".",Str(D2_IPI)),1,","),1)==",",Str(D2_IPI),Stuff(Str(D2_IPI),Rat(".",Str(D2_IPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_BASEIPI),Rat(".",Str(D2_BASEIPI)),1,","),1)==",",Str(D2_BASEIPI),Stuff(Str(D2_BASEIPI),Rat(".",Str(D2_BASEIPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALIPI),Rat(".",Str(D2_VALIPI)),1,","),1)==",",Str(D2_VALIPI),Stuff(Str(D2_VALIPI),Rat(".",Str(D2_VALIPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_BASEISS),Rat(".",Str(D2_BASEISS)),1,","),1)==",",Str(D2_BASEISS),Stuff(Str(D2_BASEISS),Rat(".",Str(D2_BASEISS)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALISS),Rat(".",Str(D2_VALISS)),1,","),1)==",",Str(D2_VALISS),Stuff(Str(D2_VALISS),Rat(".",Str(D2_VALISS)),1,","))+";"
	//cTxt += Iif(Left(Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","),1)==",",Str(nValLiq),Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_ALQIMP5),Rat(".",Str(D2_ALQIMP5)),1,","),1)==",",Str(D2_ALQIMP5),Stuff(Str(D2_ALQIMP5),Rat(".",Str(D2_ALQIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALIMP5),Rat(".",Str(D2_VALIMP5)),1,","),1)==",",Str(D2_VALIMP5),Stuff(Str(D2_VALIMP5),Rat(".",Str(D2_VALIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_ALQIMP6),Rat(".",Str(D2_ALQIMP6)),1,","),1)==",",Str(D2_ALQIMP6),Stuff(Str(D2_ALQIMP6),Rat(".",Str(D2_ALQIMP6)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALIMP6),Rat(".",Str(D2_VALIMP6)),1,","),1)==",",Str(D2_VALIMP6),Stuff(Str(D2_VALIMP6),Rat(".",Str(D2_VALIMP6)),1,","))+";"
	
	cTxt += Iif(Left(Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","),1)==",",Str(nValLiq),Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","))+";"
	
	cTxt += cVend1+";"+Posicione("SA3",1,xFilial("SA3")+cVend1,"A3_NOME")+";"+cVend2+";"+Posicione("SA3",1,xFilial("SA3")+cVend2,"A3_NOME")

	
	fWrite(nHdlText,ctxt+Chr(13)+Chr(10))


    Endif
	WorkS->(dbSkip())
	nRegCount++
EndDo

nRegCount := 0

dbSelectArea("WorkE")
WorkE->(dbGoTop())
Do While WorkE->(!EOF())
	IncProc("Processados " +Chr(32)+AllTrim(Str(nRegCount+1))+ " registros (Entradas)")

	cVend1 := Posicione("SF2",1,xFilial("SD1")+WorkE->D1_NFORI+WorkE->D1_SERIORI+WorkE->D1_FORNECE+WorkE->D1_LOJA,"F2_VEND1")
	cVend2 := Posicione("SF2",1,xFilial("SD1")+WorkE->D1_NFORI+WorkE->D1_SERIORI+WorkE->D1_FORNECE+WorkE->D1_LOJA,"F2_VEND2")
	nValBru:=WorkE->(WorkE->D1_TOTAL+WorkE->D1_VALIPI)
	nValLiq:=WorkE->((WorkE->D1_TOTAL+WorkE->D1_VALIPI)-WorkE->D1_VALICM-WorkE->D1_VALIPI-WorkE->D1_VALISS)
	cData  := Right(WorkE->D1_DTDIGIT,2)+"/"+Substr(WorkE->D1_DTDIGIT,5,2)+"/"+Left(WorkE->D1_DTDIGIT,4)
	cRazao  := Iif(WorkE->D1_TIPO$"BD",Posicione("SA1",1,xFilial("SA1")+WorkE->D1_FORNECE+WorkE->D1_LOJA,"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+WorkE->D1_FORNECE+WorkE->D1_LOJA,"A2_NOME"))
    cMunic  := Iif(WorkE->D1_TIPO$"BD",	,Posicione("SA2",1,xFilial("SA2")+WorkE->D1_FORNECE+WorkE->D1_LOJA,"A2_MUN"))
  	
   IF  (WorkS->D2_TIPO$"BD" .and. SA1->A1_EST >= cEstDe .and. SA1->A1_EST <= cEstAte .and.  iif(Empty(alltrim(cMun)),.t.,cMun $ SA1->A1_MUN )) ;
         .or.(!WorkS->D2_TIPO$"BD" .and. SA2->A2_EST >= cEstDe .and. SA2->A2_EST <= cEstAte .and.  iif(Empty(alltrim(cMun)),.t.,cMun $ SA2->A2_MUN )) 


	cTxt := ""
	cTxt += "E"+";"+cData+";"+WorkE->D1_DOC+";"+WorkE->D1_SERIE+";"+WorkE->D1_FORNECE+";"+cRazao+";"
	cTxt += WorkE->D1_COD+";"+Posicione("SB1",1,xFilial("SD1")+WorkE->D1_COD,"B1_DESC")+";"+Posicione("SB1",1,xFilial("SD1")+WorkE->D1_COD,"B1_POSIPI")+";"+Posicione("SF1",1,xFilial("SD1")+WorkE->D1_DOC+WorkE->D1_SERIE+WorkE->D1_FORNECE+WorkE->D1_LOJA,"F1_EST")+";"+cMunic+";"+WorkE->D1_CF+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_QUANT),Rat(".",Str(WorkE->D1_QUANT)),1,","),1)==",",Str(WorkE->D1_QUANT),Stuff(Str(WorkE->D1_QUANT),Rat(".",Str(WorkE->D1_QUANT)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VUNIT),Rat(".",Str(WorkE->D1_VUNIT)),1,","),1)==",",Str(WorkE->D1_VUNIT),Stuff(Str(WorkE->D1_VUNIT),Rat(".",Str(WorkE->D1_VUNIT)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(nValBru),Rat(".",Str(nValBru)),1,","),1)==",",Str(nValBru),Stuff(Str(nValBru),Rat(".",Str(nValBru)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_PICM),Rat(".",Str(WorkE->D1_PICM)),1,","),1)==",",Str(WorkE->D1_PICM),Stuff(Str(WorkE->D1_PICM),Rat(".",Str(WorkE->D1_PICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_BASEICM),Rat(".",Str(WorkE->D1_BASEICM)),1,","),1)==",",Str(WorkE->D1_BASEICM),Stuff(Str(WorkE->D1_BASEICM),Rat(".",Str(WorkE->D1_BASEICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALICM),Rat(".",Str(WorkE->D1_VALICM)),1,","),1)==",",Str(WorkE->D1_VALICM),Stuff(Str(WorkE->D1_VALICM),Rat(".",Str(WorkE->D1_VALICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_IPI),Rat(".",Str(WorkE->D1_IPI)),1,","),1)==",",Str(WorkE->D1_IPI),Stuff(Str(WorkE->D1_IPI),Rat(".",Str(WorkE->D1_IPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_BASEIPI),Rat(".",Str(WorkE->D1_BASEIPI)),1,","),1)==",",Str(WorkE->D1_BASEIPI),Stuff(Str(WorkE->D1_BASEIPI),Rat(".",Str(WorkE->D1_BASEIPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALIPI),Rat(".",Str(WorkE->D1_VALIPI)),1,","),1)==",",Str(WorkE->D1_VALIPI),Stuff(Str(WorkE->D1_VALIPI),Rat(".",Str(WorkE->D1_VALIPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_BASEISS),Rat(".",Str(WorkE->D1_BASEISS)),1,","),1)==",",Str(WorkE->D1_BASEISS),Stuff(Str(WorkE->D1_BASEISS),Rat(".",Str(WorkE->D1_BASEISS)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALISS),Rat(".",Str(WorkE->D1_VALISS)),1,","),1)==",",Str(WorkE->D1_VALISS),Stuff(Str(WorkE->D1_VALISS),Rat(".",Str(WorkE->D1_VALISS)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","),1)==",",Str(nValLiq),Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_ALQIMP5),Rat(".",Str(WorkE->D1_ALQIMP5)),1,","),1)==",",Str(WorkE->D1_ALQIMP5),Stuff(Str(WorkE->D1_ALQIMP5),Rat(".",Str(WorkE->D1_ALQIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALIMP5),Rat(".",Str(WorkE->D1_VALIMP5)),1,","),1)==",",Str(WorkE->D1_VALIMP5),Stuff(Str(WorkE->D1_VALIMP5),Rat(".",Str(WorkE->D1_VALIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_ALQIMP6),Rat(".",Str(WorkE->D1_ALQIMP6)),1,","),1)==",",Str(WorkE->D1_ALQIMP6),Stuff(Str(WorkE->D1_ALQIMP6),Rat(".",Str(WorkE->D1_ALQIMP6)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALIMP6),Rat(".",Str(WorkE->D1_VALIMP6)),1,","),1)==",",Str(WorkE->D1_VALIMP6),Stuff(Str(WorkE->D1_VALIMP6),Rat(".",Str(WorkE->D1_VALIMP6)),1,","))+";"
	cTxt += cVend1+";"+Posicione("SA3",1,xFilial("SA3")+cVend1,"A3_NOME")+";"+cVend2+";"+Posicione("SA3",1,xFilial("SA3")+cVend2,"A3_NOME")

	fWrite(nHdlText,ctxt+Chr(13)+Chr(10))

    Endif

	WorkE->(dbSkip())
	nRegCount++
EndDo

fClose(nHdlText)
msgInfo("Arquivo gerado com sucesso!")

oExcelApp := msExcel():New()
oExcelApp:SetVisible(.t.)

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
Static Function ProcSTXT(nHdlText)
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ

Local cTxt,nRegCount,cVend1,cVend2,cChave,nValLiq,nValBru,cQuery,cFilDe,cFilAte,cDocDe,cDocAte,cSerDe,cSerAte,cCliDe,cCliAte,cLjDe,cLjAte,cDtDe,cDtAte,cProdDe,cProdAte,cFiltro,cCFDe,cCFAte,nUsaFil,nAnaSin,cData,cRazao

cFilDe  := MV_PAR01
cFilAte := MV_PAR02
cDocDe  := MV_PAR03
cDocAte := MV_PAR04
cSerDe  := MV_PAR05
cSerAte := MV_PAR06
cCliDe  := MV_PAR07
cCliAte := MV_PAR08
cLjDe   := MV_PAR09
cLjAte  := MV_PAR10
cProdDe := MV_PAR11
cProdAte:= MV_PAR12
cDtDe   := MV_PAR13
cDtAte  := MV_PAR14
cCFDe   := MV_PAR15
cCFAte  := MV_PAR16
nUsaFil := MV_PAR17
cFiltro := MV_PAR18
//cAnaSin := MV_PAR19
cEstDe 	:= MV_PAR20
cEstAte	:= MV_PAR21
cMun	:= MV_PAR22

nTSVlBr :=nTEVlBr :=0
nTSPicm :=nTEPicm :=0
nTSBsIcm:=nTEBsIcm:=0
nTSVlIcm:=nTEVlIcm:=0
nTSIPI  :=nTEIPI  :=0
nTSBsIPI:=nTEBsIPI:=0
nTSVlIPI:=nTEVlIPI:=0
nTSBsIss:=nTEBsIss:=0
nTSVlIss:=nTEVlIss:=0
nTSVlLiq:=nTEVlLiq:=0
nTSAlIm5:=nTEAlIm5:=0
nTSVlIm5:=nTEVlIm5:=0
nTSAlIm6:=nTEAlIm6:=0
nTSVlIm6:=nTEVlIm6:=0

cTxt := ""          
cChave := ""
nRegCount := 0

If Select("WorkS") > 0
	WorkS->(dbCloseArea())
EndIf                    
                                                
cQuery := " SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_CF,SUM(D2_VALBRUT)D2_VALBRUT,SUM(D2_PICM)D2_PICM,SUM(D2_BASEICM)D2_BASEICM,SUM(D2_VALICM)D2_VALICM,SUM(D2_IPI)D2_IPI,SUM(D2_BASEIPI)D2_BASEIPI,SUM(D2_VALIPI)D2_VALIPI,SUM(D2_BASEISS)D2_BASEISS,SUM(D2_VALISS)D2_VALISS,SUM(D2_ALQIMP5)D2_ALQIMP5,SUM(D2_VALIMP5)D2_VALIMP5,SUM(D2_ALQIMP6)D2_ALQIMP6,SUM(D2_VALIMP6)D2_VALIMP6 "
cQuery += " FROM " +RetSqlName("SD2") + " D2 " 

//If !empty(ALLTRIM(cMun))
//	cQuery += "Inner Join " + RetSqlName("SA1") + " A1 on D2_CLIENTE = A1_COD and D2_LOJA = A1_LOJA "
//	cQuery += " AND A1_MUN LIKE '%" + cMun + "%' AND A1.D_E_L_E_T_ = ' ' "
//endif

cQuery += " WHERE D2_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "
cQuery += " AND D2_DOC BETWEEN '"+cDocDe+"' AND '"+cDocAte+"' "
cQuery += " AND D2_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "
cQuery += " AND D2_CLIENTE BETWEEN '"+cCliDe+"' AND '"+cCliAte+"' "
cQuery += " AND D2_LOJA BETWEEN '"+cLjDe+"' AND '"+cLjAte+"' "
cQuery += " AND D2_EMISSAO BETWEEN '"+DtoS(cDtDe)+"' AND '"+DtoS(cDtAte)+"' "
Iif((nUsaFil)==2,cQuery += " AND D2_CF BETWEEN '"+cCFDe+"' AND '"+cCFAte+"' ",)  // Utiliza Filtro? (NAO)
Iif((nUsaFil)==1,cQuery += " AND D2_CF IN ("+AllTrim(cFiltro)+") ",) // Utiliza Filtro? (SIM)
cQuery += " AND D2_EST BETWEEN '"+cEstDe+"' AND '"+cEstAte+"' "
cQuery += " AND D2.D_E_L_E_T_=' ' "
cQuery += " GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_CF "
cQuery += " ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_CF "

tcQuery cQuery New Alias "WorkS"

If Select("WorkE") > 0
	WorkE->(dbCloseArea())
EndIf

cQuery := " SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_TIPO,D1_FORNECE,D1_LOJA,D1_CF,SUM(D1_TOTAL)D1_TOTAL,SUM(D1_VALIPI)D1_VALIPI,SUM(D1_PICM)D1_PICM,SUM(D1_BASEICM)D1_BASEICM,SUM(D1_VALICM)D1_VALICM,SUM(D1_IPI)D1_IPI,SUM(D1_BASEIPI)D1_BASEIPI,SUM(D1_VALIPI)D1_VALIPI,SUM(D1_BASEISS)D1_BASEISS,SUM(D1_VALISS)D1_VALISS,SUM(D1_ALQIMP5)D1_ALQIMP5,SUM(D1_VALIMP5)D1_VALIMP5,SUM(D1_ALQIMP6)D1_ALQIMP6,SUM(D1_VALIMP6)D1_VALIMP6 "
cQuery += " FROM " +RetSqlName("SD1") + " D1 "
//	cQuery += "Inner Join " + RetSqlName("SA1") + " A1 on D1_FORNECE = A1_COD and D1_LOJA = A1_LOJA "
//	cQuery += " AND A1.D_E_L_E_T_ = ' '  "
//	cQuery += " AND A1_EST BETWEEN '"+cEstDe+"' AND '"+cEstAte+"' "
//If !empty(ALLTRIM(cMun))
//	cQuery += " AND A1_MUN LIKE '%" + cMun + "%' AND A2.D_E_L_E_T_ = ' ' "
//endif
cQuery += " WHERE D1_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "
cQuery += " AND D1_DOC BETWEEN '"+cDocDe+"' AND '"+cDocAte+"' "
cQuery += " AND D1_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "
cQuery += " AND D1_FORNECE BETWEEN '"+cCliDe+"' AND '"+cCliAte+"' "
cQuery += " AND D1_LOJA BETWEEN '"+cLjDe+"' AND '"+cLjAte+"' "
cQuery += " AND D1_DTDIGIT BETWEEN '"+DtoS(cDtDe)+"' AND '"+DtoS(cDtAte)+"' "
Iif((nUsaFil)==2,cQuery += " AND D1_CF BETWEEN '"+cCFDe+"' AND '"+cCFAte+"' ",)  // Utiliza Filtro? (NAO)
Iif((nUsaFil)==1,cQuery += " AND D1_CF IN ("+AllTrim(cFiltro)+") ",) // Utiliza Filtro? (SIM)
cQuery += " AND D1.D_E_L_E_T_=' ' "
cQuery += " GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_TIPO,D1_FORNECE,D1_LOJA,D1_CF "
cQuery += " ORDER BY D1_FILIAL,D1_DOC,D1_SERIE,D1_TIPO,D1_FORNECE,D1_LOJA,D1_CF "

tcQuery cQuery New Alias "WorkE"

cTxt := "E_S"+";"+"DATA"+";"+"NOTA"+";"+"SERIE"+";"+"CLI_FOR"+";"+"NOME_CLI_FOR"+";"
cTxt += "UF"+";"+"CFOP"+";"+"VLR_BRUT"+";"+"ICMS"+";"+"BASE_ICM"+";"+"VLR_ICM"+";"
cTxt += "IPI"+";"+"BASE_IPI"+";"+"VLR_IPI"+";"+"BASE_ISS"+";"+"VLR_ISS"+";"+"VLR_LIQ"+";"+"COFINS"+";"
cTxt += "VLR_COF"+";"+"PIS"+";"+"VLR_PIS"
fWrite(nHdlText,cTxt+Chr(13)+Chr(10))

ProcRegua(0)

dbSelectArea("WorkS")
WorkS->(dbGoTop())
Do While WorkS->(!EOF())
	IncProc("Processados " +Chr(32)+AllTrim(Str(nRegCount+1))+ " registros (SaÌda)")

	//TI2029
	cVend1 := Posicione("SF2",1,xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA,"F2_VEND1")
	cVend2 := Posicione("SF2",1,xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA,"F2_VEND2")
	//

	nValLiq :=WorkS->(D2_VALBRUT-D2_VALICM-D2_VALIPI-D2_VALISS)
	cData   := Posicione("SF2",1,xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA,"F2_EMISSAO")
	cUF     := Posicione("SF2",1,xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA,"F2_EST")
	cRazao  := Iif(WorkS->D2_TIPO$"BD",Posicione("SA2",1,xFilial("SA2")+D2_CLIENTE+D2_LOJA,"A2_NOME"),Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_NOME"))

	 IF  (WorkS->D2_TIPO$"BD" .and. SA2->A2_EST >= cEstDe .and. SA2->A2_EST <= cEstAte .and.  iif(Empty(alltrim(cMun)),.t.,SA2->cMun $ A2_MUN )) ;
         .or.(!WorkS->D2_TIPO$"BD" .and. SA1->A1_EST >= cEstDe .and. SA1->A1_EST <= cEstAte .and.  iif(Empty(alltrim(cMun)),.t.,cMun $ SA1->A1_MUN )) 
   
	nTSVlBr +=D2_VALBRUT
	nTSPicm +=D2_PICM
	nTSBsIcm+=D2_BASEICM
	nTSVlIcm+=D2_VALICM
	nTSIPI  +=D2_IPI
	nTSBsIPI+=D2_BASEIPI
	nTSVlIPI+=D2_VALIPI
	nTSBsIss+=D2_BASEISS
	nTSVlIss+=D2_VALISS
	nTSVlLiq+=nValLiq
	nTSAlIm5+=D2_ALQIMP5
	nTSVlIm5+=D2_VALIMP5
	nTSAlIm6+=D2_ALQIMP6
	nTSVlIm6+=D2_VALIMP6

	cTxt := ""
	cTxt += "S"+";"+DtoC(cData)+";"+D2_DOC+";"+D2_SERIE+";"+D2_CLIENTE+";"+cRazao+";"+cUF+";"+D2_CF+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALBRUT),Rat(".",Str(D2_VALBRUT)),1,","),1)==",",Str(D2_VALBRUT),Stuff(Str(D2_VALBRUT),Rat(".",Str(D2_VALBRUT)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_PICM),Rat(".",Str(D2_PICM)),1,","),1)==",",Str(D2_PICM),Stuff(Str(D2_PICM),Rat(".",Str(D2_PICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_BASEICM),Rat(".",Str(D2_BASEICM)),1,","),1)==",",Str(D2_BASEICM),Stuff(Str(D2_BASEICM),Rat(".",Str(D2_BASEICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALICM),Rat(".",Str(D2_VALICM)),1,","),1)==",",Str(D2_VALICM),Stuff(Str(D2_VALICM),Rat(".",Str(D2_VALICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_IPI),Rat(".",Str(D2_IPI)),1,","),1)==",",Str(D2_IPI),Stuff(Str(D2_IPI),Rat(".",Str(D2_IPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_BASEIPI),Rat(".",Str(D2_BASEIPI)),1,","),1)==",",Str(D2_BASEIPI),Stuff(Str(D2_BASEIPI),Rat(".",Str(D2_BASEIPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALIPI),Rat(".",Str(D2_VALIPI)),1,","),1)==",",Str(D2_VALIPI),Stuff(Str(D2_VALIPI),Rat(".",Str(D2_VALIPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_BASEISS),Rat(".",Str(D2_BASEISS)),1,","),1)==",",Str(D2_BASEISS),Stuff(Str(D2_BASEISS),Rat(".",Str(D2_BASEISS)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALISS),Rat(".",Str(D2_VALISS)),1,","),1)==",",Str(D2_VALISS),Stuff(Str(D2_VALISS),Rat(".",Str(D2_VALISS)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","),1)==",",Str(nValLiq),Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_ALQIMP5),Rat(".",Str(D2_ALQIMP5)),1,","),1)==",",Str(D2_ALQIMP5),Stuff(Str(D2_ALQIMP5),Rat(".",Str(D2_ALQIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALIMP5),Rat(".",Str(D2_VALIMP5)),1,","),1)==",",Str(D2_VALIMP5),Stuff(Str(D2_VALIMP5),Rat(".",Str(D2_VALIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_ALQIMP6),Rat(".",Str(D2_ALQIMP6)),1,","),1)==",",Str(D2_ALQIMP6),Stuff(Str(D2_ALQIMP6),Rat(".",Str(D2_ALQIMP6)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALIMP6),Rat(".",Str(D2_VALIMP6)),1,","),1)==",",Str(D2_VALIMP6),Stuff(Str(D2_VALIMP6),Rat(".",Str(D2_VALIMP6)),1,","))+";"
	//TI2029
	cTxt += cVend1+";"+Posicione("SA3",1,xFilial("SA3")+cVend1,"A3_NOME")+";"+cVend2+";"+Posicione("SA3",1,xFilial("SA3")+cVend2,"A3_NOME")	
	//

	Endif
	
	fWrite(nHdlText,ctxt+Chr(13)+Chr(10))

	WorkS->(dbSkip())
	nRegCount++
EndDo

cTxt := "Total Saidas"+";"
cTxt += +""+";"+""+";"+""+";"+""+";"+""+";"+""+";"+""+";"
cTxt += Iif(Left(Stuff(Str(nTSVlBr),Rat(".",Str(nTSVlBr)),1,","),1)==",",Str(nTSVlBr),Stuff(Str(nTSVlBr),Rat(".",Str(nTSVlBr)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSPicm),Rat(".",Str(nTSPicm)),1,","),1)==",",Str(nTSPicm),Stuff(Str(nTSPicm),Rat(".",Str(nTSPicm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSBsIcm),Rat(".",Str(nTSBsIcm)),1,","),1)==",",Str(nTSBsIcm),Stuff(Str(nTSBsIcm),Rat(".",Str(nTSBsIcm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSVlIcm),Rat(".",Str(nTSVlIcm)),1,","),1)==",",Str(nTSVlIcm),Stuff(Str(nTSVlIcm),Rat(".",Str(nTSVlIcm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSIPI),Rat(".",Str(nTSIPI)),1,","),1)==",",Str(nTSIPI),Stuff(Str(nTSIPI),Rat(".",Str(nTSIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSBsIPI),Rat(".",Str(nTSBsIPI)),1,","),1)==",",Str(nTSBsIPI),Stuff(Str(nTSBsIPI),Rat(".",Str(nTSBsIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSVlIPI),Rat(".",Str(nTSVlIPI)),1,","),1)==",",Str(nTSVlIPI),Stuff(Str(nTSVlIPI),Rat(".",Str(nTSVlIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSBsIss),Rat(".",Str(nTSBsIss)),1,","),1)==",",Str(nTSBsIss),Stuff(Str(nTSBsIss),Rat(".",Str(nTSBsIss)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSVlIss),Rat(".",Str(nTSVlIss)),1,","),1)==",",Str(nTSVlIss),Stuff(Str(nTSVlIss),Rat(".",Str(nTSVlIss)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSVlLiq),Rat(".",Str(nTSVlLiq)),1,","),1)==",",Str(nTSVlLiq),Stuff(Str(nTSVlLiq),Rat(".",Str(nTSVlLiq)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSAlIm5),Rat(".",Str(nTSAlIm5)),1,","),1)==",",Str(nTSAlIm5),Stuff(Str(nTSAlIm5),Rat(".",Str(nTSAlIm5)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSVlIm5),Rat(".",Str(nTSVlIm5)),1,","),1)==",",Str(nTSVlIm5),Stuff(Str(nTSVlIm5),Rat(".",Str(nTSVlIm5)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSAlIm6),Rat(".",Str(nTSAlIm6)),1,","),1)==",",Str(nTSAlIm6),Stuff(Str(nTSAlIm6),Rat(".",Str(nTSAlIm6)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTSVlIm6),Rat(".",Str(nTSVlIm6)),1,","),1)==",",Str(nTSVlIm6),Stuff(Str(nTSVlIm6),Rat(".",Str(nTSVlIm6)),1,","))
fWrite(nHdlText,ctxt+Chr(13)+Chr(10))

nRegCount := 0

dbSelectArea("WorkE")
WorkE->(dbGoTop())
Do While WorkE->(!EOF())
	IncProc("Processados " +Chr(32)+AllTrim(Str(nRegCount+1))+ " registros (Entradas)")

	nValBru := WorkE->(WorkE->D1_TOTAL+WorkE->D1_VALIPI)
	nValLiq := WorkE->((WorkE->D1_TOTAL+WorkE->D1_VALIPI)-WorkE->D1_VALICM-WorkE->D1_VALIPI-WorkE->D1_VALISS)
	cData   := Posicione("SF1",1,xFilial("SD1")+WorkE->D1_DOC+WorkE->D1_SERIE+WorkE->D1_FORNECE+WorkE->D1_LOJA,"F1_DTDIGIT")
	cUF     := Posicione("SF1",1,xFilial("SD1")+WorkE->D1_DOC+WorkE->D1_SERIE+WorkE->D1_FORNECE+WorkE->D1_LOJA,"F1_EST")
	cRazao  := Iif(WorkE->D1_TIPO$"BD",Posicione("SA1",1,xFilial("SA1")+WorkE->D1_FORNECE+WorkE->D1_LOJA,"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+WorkE->D1_FORNECE+WorkE->D1_LOJA,"A2_NOME"))
    cMunic  := Iif(WorkE->D1_TIPO$"BD",Posicione("SA1",1,xFilial("SA1")+WorkE->D1_FORNECE+WorkE->D1_LOJA,"A1_MUN"),Posicione("SA2",1,xFilial("SA2")+WorkE->D1_FORNECE+WorkE->D1_LOJA,"A1_MUN"))
 	
   IF  (WorkS->D2_TIPO$"BD" .and. SA1->A1_EST >= cEstDe .and. SA1->A1_EST <= cEstAte .and.  iif(Empty(alltrim(cMun)),.t.,cMun $ SA1->A1_MUN )) ;
         .or.(!WorkS->D2_TIPO$"BD" .and. SA2->A2_EST >= cEstDe .and. SA2->A2_EST <= cEstAte .and.  iif(Empty(alltrim(cMun)),.t.,cMun $ SA2->A2_MUN )) 
   
	nTEVlBr +=nValBru   
	nTEPicm +=WorkE->D1_PICM
	nTEBsIcm+=WorkE->D1_BASEICM
	nTEVlIcm+=WorkE->D1_VALICM
	nTEIPI  +=WorkE->D1_IPI
	nTEBsIPI+=WorkE->D1_BASEIPI
	nTEVlIPI+=WorkE->D1_VALIPI
	nTEBsIss+=WorkE->D1_BASEISS
	nTEVlIss+=WorkE->D1_VALISS
	nTEVlLiq+=nValLiq
	nTEAlIm5+=WorkE->D1_ALQIMP5
	nTEVlIm5+=WorkE->D1_VALIMP5
	nTEAlIm6+=WorkE->D1_ALQIMP6
	nTEVlIm6+=WorkE->D1_VALIMP6

	cTxt := ""
	cTxt += "E"+";"+DtoC(cData)+";"+WorkE->D1_DOC+";"+WorkE->D1_SERIE+";"+WorkE->D1_FORNECE+";"+cRazao+";"+cMunic+";"+cUF+";"+WorkE->D1_CF+";"
	cTxt += Iif(Left(Stuff(Str(nValBru),Rat(".",Str(nValBru)),1,","),1)==",",Str(nValBru),Stuff(Str(nValBru),Rat(".",Str(nValBru)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_PICM),Rat(".",Str(WorkE->D1_PICM)),1,","),1)==",",Str(WorkE->D1_PICM),Stuff(Str(WorkE->D1_PICM),Rat(".",Str(WorkE->D1_PICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_BASEICM),Rat(".",Str(WorkE->D1_BASEICM)),1,","),1)==",",Str(WorkE->D1_BASEICM),Stuff(Str(WorkE->D1_BASEICM),Rat(".",Str(WorkE->D1_BASEICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALICM),Rat(".",Str(WorkE->D1_VALICM)),1,","),1)==",",Str(WorkE->D1_VALICM),Stuff(Str(WorkE->D1_VALICM),Rat(".",Str(WorkE->D1_VALICM)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_IPI),Rat(".",Str(WorkE->D1_IPI)),1,","),1)==",",Str(WorkE->D1_IPI),Stuff(Str(WorkE->D1_IPI),Rat(".",Str(WorkE->D1_IPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_BASEIPI),Rat(".",Str(WorkE->D1_BASEIPI)),1,","),1)==",",Str(WorkE->D1_BASEIPI),Stuff(Str(WorkE->D1_BASEIPI),Rat(".",Str(WorkE->D1_BASEIPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALIPI),Rat(".",Str(WorkE->D1_VALIPI)),1,","),1)==",",Str(WorkE->D1_VALIPI),Stuff(Str(WorkE->D1_VALIPI),Rat(".",Str(WorkE->D1_VALIPI)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_BASEISS),Rat(".",Str(WorkE->D1_BASEISS)),1,","),1)==",",Str(WorkE->D1_BASEISS),Stuff(Str(WorkE->D1_BASEISS),Rat(".",Str(WorkE->D1_BASEISS)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALISS),Rat(".",Str(WorkE->D1_VALISS)),1,","),1)==",",Str(WorkE->D1_VALISS),Stuff(Str(WorkE->D1_VALISS),Rat(".",Str(WorkE->D1_VALISS)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","),1)==",",Str(nValLiq),Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_ALQIMP5),Rat(".",Str(WorkE->D1_ALQIMP5)),1,","),1)==",",Str(WorkE->D1_ALQIMP5),Stuff(Str(WorkE->D1_ALQIMP5),Rat(".",Str(WorkE->D1_ALQIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALIMP5),Rat(".",Str(WorkE->D1_VALIMP5)),1,","),1)==",",Str(WorkE->D1_VALIMP5),Stuff(Str(WorkE->D1_VALIMP5),Rat(".",Str(WorkE->D1_VALIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_ALQIMP6),Rat(".",Str(WorkE->D1_ALQIMP6)),1,","),1)==",",Str(WorkE->D1_ALQIMP6),Stuff(Str(WorkE->D1_ALQIMP6),Rat(".",Str(WorkE->D1_ALQIMP6)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(WorkE->D1_VALIMP6),Rat(".",Str(WorkE->D1_VALIMP6)),1,","),1)==",",Str(WorkE->D1_VALIMP6),Stuff(Str(WorkE->D1_VALIMP6),Rat(".",Str(WorkE->D1_VALIMP6)),1,","))
	//TI2029
	cTxt += Space(6)+";"+Space(30)+";"+Space(6)+";"+Space(30)	
	//
	fWrite(nHdlText,ctxt+Chr(13)+Chr(10))

    Endif
    
	WorkE->(dbSkip())
	nRegCount++
EndDo

cTxt := "Total Entradas"+";"
cTxt += +""+";"+""+";"+""+";"+""+";"+""+";"+""+";"+""+";"
cTxt += Iif(Left(Stuff(Str(nTEVlBr),Rat(".",Str(nTEVlBr)),1,","),1)==",",Str(nTEVlBr),Stuff(Str(nTEVlBr),Rat(".",Str(nTEVlBr)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEPicm),Rat(".",Str(nTEPicm)),1,","),1)==",",Str(nTEPicm),Stuff(Str(nTEPicm),Rat(".",Str(nTEPicm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEBsIcm),Rat(".",Str(nTEBsIcm)),1,","),1)==",",Str(nTEBsIcm),Stuff(Str(nTEBsIcm),Rat(".",Str(nTEBsIcm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEVlIcm),Rat(".",Str(nTEVlIcm)),1,","),1)==",",Str(nTEVlIcm),Stuff(Str(nTEVlIcm),Rat(".",Str(nTEVlIcm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEIPI),Rat(".",Str(nTEIPI)),1,","),1)==",",Str(nTEIPI),Stuff(Str(nTEIPI),Rat(".",Str(nTEIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEBsIPI),Rat(".",Str(nTEBsIPI)),1,","),1)==",",Str(nTEBsIPI),Stuff(Str(nTEBsIPI),Rat(".",Str(nTEBsIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEVlIPI),Rat(".",Str(nTEVlIPI)),1,","),1)==",",Str(nTEVlIPI),Stuff(Str(nTEVlIPI),Rat(".",Str(nTEVlIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEBsIss),Rat(".",Str(nTEBsIss)),1,","),1)==",",Str(nTEBsIss),Stuff(Str(nTEBsIss),Rat(".",Str(nTEBsIss)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEVlIss),Rat(".",Str(nTEVlIss)),1,","),1)==",",Str(nTEVlIss),Stuff(Str(nTEVlIss),Rat(".",Str(nTEVlIss)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEVlLiq),Rat(".",Str(nTEVlLiq)),1,","),1)==",",Str(nTEVlLiq),Stuff(Str(nTEVlLiq),Rat(".",Str(nTEVlLiq)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEAlIm5),Rat(".",Str(nTEAlIm5)),1,","),1)==",",Str(nTEAlIm5),Stuff(Str(nTEAlIm5),Rat(".",Str(nTEAlIm5)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEVlIm5),Rat(".",Str(nTEVlIm5)),1,","),1)==",",Str(nTEVlIm5),Stuff(Str(nTEVlIm5),Rat(".",Str(nTEVlIm5)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEAlIm6),Rat(".",Str(nTEAlIm6)),1,","),1)==",",Str(nTEAlIm6),Stuff(Str(nTEAlIm6),Rat(".",Str(nTEAlIm6)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTEVlIm6),Rat(".",Str(nTEVlIm6)),1,","),1)==",",Str(nTEVlIm6),Stuff(Str(nTEVlIm6),Rat(".",Str(nTEVlIm6)),1,","))
fWrite(nHdlText,ctxt+Chr(13)+Chr(10))

nTGVlBr :=nTSVlBr-nTEVlBr
nTGPicm :=nTSPicm-nTEPicm
nTGBsIcm:=nTSBsIcm-nTEBsIcm
nTGVlIcm:=nTSVlIcm-nTEVlIcm
nTGIPI  :=nTSIPI-nTEIPI  
nTGBsIPI:=nTSBsIPI-nTEBsIPI
nTGVlIPI:=nTSVlIPI-nTEVlIPI
nTGBsIss:=nTSBsIss-nTEBsIss
nTGVlIss:=nTSVlIss-nTEVlIss
nTGVlLiq:=nTSVlLiq-nTEVlLiq
nTGAlIm5:=nTSAlIm5-nTEAlIm5
nTGVlIm5:=nTSVlIm5-nTEVlIm5
nTGAlIm6:=nTSAlIm6-nTEAlIm6
nTGVlIm6:=nTSVlIm6-nTEVlIm6

cTxt := "Saidas - Entradas"+";"
cTxt += +""+";"+""+";"+""+";"+""+";"+""+";"+""+";"+""+";"
cTxt += Iif(Left(Stuff(Str(nTGVlBr),Rat(".",Str(nTGVlBr)),1,","),1)==",",Str(nTGVlBr),Stuff(Str(nTGVlBr),Rat(".",Str(nTGVlBr)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGPicm),Rat(".",Str(nTGPicm)),1,","),1)==",",Str(nTGPicm),Stuff(Str(nTGPicm),Rat(".",Str(nTGPicm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGBsIcm),Rat(".",Str(nTGBsIcm)),1,","),1)==",",Str(nTGBsIcm),Stuff(Str(nTGBsIcm),Rat(".",Str(nTGBsIcm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGVlIcm),Rat(".",Str(nTGVlIcm)),1,","),1)==",",Str(nTGVlIcm),Stuff(Str(nTGVlIcm),Rat(".",Str(nTGVlIcm)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGIPI),Rat(".",Str(nTGIPI)),1,","),1)==",",Str(nTGIPI),Stuff(Str(nTGIPI),Rat(".",Str(nTGIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGBsIPI),Rat(".",Str(nTGBsIPI)),1,","),1)==",",Str(nTGBsIPI),Stuff(Str(nTGBsIPI),Rat(".",Str(nTGBsIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGVlIPI),Rat(".",Str(nTGVlIPI)),1,","),1)==",",Str(nTGVlIPI),Stuff(Str(nTGVlIPI),Rat(".",Str(nTGVlIPI)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGBsIss),Rat(".",Str(nTGBsIss)),1,","),1)==",",Str(nTGBsIss),Stuff(Str(nTGBsIss),Rat(".",Str(nTGBsIss)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGVlIss),Rat(".",Str(nTGVlIss)),1,","),1)==",",Str(nTGVlIss),Stuff(Str(nTGVlIss),Rat(".",Str(nTGVlIss)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGVlLiq),Rat(".",Str(nTGVlLiq)),1,","),1)==",",Str(nTGVlLiq),Stuff(Str(nTGVlLiq),Rat(".",Str(nTGVlLiq)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGAlIm5),Rat(".",Str(nTGAlIm5)),1,","),1)==",",Str(nTGAlIm5),Stuff(Str(nTGAlIm5),Rat(".",Str(nTGAlIm5)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGVlIm5),Rat(".",Str(nTGVlIm5)),1,","),1)==",",Str(nTGVlIm5),Stuff(Str(nTGVlIm5),Rat(".",Str(nTGVlIm5)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGAlIm6),Rat(".",Str(nTGAlIm6)),1,","),1)==",",Str(nTGAlIm6),Stuff(Str(nTGAlIm6),Rat(".",Str(nTGAlIm6)),1,","))+";"
cTxt += Iif(Left(Stuff(Str(nTGVlIm6),Rat(".",Str(nTGVlIm6)),1,","),1)==",",Str(nTGVlIm6),Stuff(Str(nTGVlIm6),Rat(".",Str(nTGVlIm6)),1,","))
fWrite(nHdlText,ctxt+Chr(13)+Chr(10))

fClose(nHdlText)
msgInfo("Arquivo gerado com sucesso!")

oExcelApp := msExcel():New()
oExcelApp:SetVisible(.t.)      


/*
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
Static Function CalcFin(cPrefixo,cNF,cCliFor,cCart)
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ


IF cCart = "E1"
*/


                                                  


//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
Static Function ValidPerg(cPerg)
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
Local _sAlias := Alias()
Local aRegs := {}
Local i,j
	
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)
	
aAdd(aRegs,{cPerg,"01"  ,"Da Filial                 "	,""      ,""     ,"MV_CH1","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"02"  ,"Ate Filial                "	,""      ,""     ,"MV_CH2","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"03"  ,"Da NF Entrada/SaÌda       "	,""      ,""     ,"MV_CH3","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""})
aAdd(aRegs,{cPerg,"04"  ,"Ate NF Entrada/SaÌda      "	,""      ,""     ,"MV_CH4","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR04",""         			,""      ,""      ,""   ,""         ,""            	    	,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""})
aAdd(aRegs,{cPerg,"05"  ,"Da Serie NF Entrada/SaÌda "	,""      ,""     ,"MV_CH5","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR05",""         			,""      ,""      ,""   ,""         ,""            		    ,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"06"  ,"Ate Serie NF Entrada/SaÌda"	,""      ,""     ,"MV_CH6","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR06",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"07"  ,"Do Fornecedor/Cliente     "	,""      ,""     ,"MV_CH7","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR07",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""})
aAdd(aRegs,{cPerg,"08"  ,"Ate Fornecedor/Cliente    "	,""      ,""     ,"MV_CH8","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR08",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""})
aAdd(aRegs,{cPerg,"09"  ,"Da Loja                   "	,""      ,""     ,"MV_CH9","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR09",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"10"  ,"Ate Loja                  "	,""      ,""     ,"MV_CHA","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR10",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""            	    ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"11"  ,"Do Produto                "	,""      ,""     ,"MV_CHB","C"    ,15      ,0       ,0     ,"G" ,""    ,"MV_PAR11",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SB1"})
aAdd(aRegs,{cPerg,"12"  ,"Ate Produto               "	,""      ,""     ,"MV_CHC","C"    ,15      ,0       ,0     ,"G" ,""    ,"MV_PAR12",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SB1"})
aAdd(aRegs,{cPerg,"13"  ,"Da DigitaÁ„o/Emiss„o      "	,""      ,""     ,"MV_CHD","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR13",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"14"  ,"Ate DigitaÁ„o/Emiss„o     "	,""      ,""     ,"MV_CHE","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR14",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"15"  ,"Da CFOP                   "	,""      ,""     ,"MV_CHF","C"    ,04      ,0       ,0     ,"G" ,""    ,"MV_PAR15",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"16"  ,"Ate CFOP                  "	,""      ,""     ,"MV_CHG","C"    ,04      ,0       ,0     ,"G" ,""    ,"MV_PAR16",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"17"  ,"Utiliza Filtro?           "	,""      ,""     ,"MV_CHH","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR17","Sim"      			,""      ,""      ,""   ,""         ,"N„o"             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"18"  ,"Filtro CFOP               "	,""      ,""     ,"MV_CHI","C"    ,99      ,0       ,0     ,"G" ,""    ,"MV_PAR18",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"19"  ,"AnalÌtico/SintÈtico       "	,""      ,""     ,"MV_CHJ","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR19","SintÈtico"        	,""      ,""      ,""   ,""         ,"AnalÌtico"         	,""      ,""      ,""    ,""        ,""                	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"20"  ,"Do Estado             	"	,""      ,""     ,"MV_CHK","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR20","" 			       	,""      ,""      ,""   ,""         ,""     		    	,""      ,""      ,""    ,""        ,""                	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"21"  ,"Ate Estado                "	,""      ,""     ,"MV_CHL","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR21","" 			       	,""      ,""      ,""   ,""         ,""     		    	,""      ,""      ,""    ,""        ,""                	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"22"  ,"Cidade			        "	,""      ,""     ,"MV_CHM","C"    ,35      ,0       ,0     ,"G" ,""    ,"MV_PAR22",""        			,""      ,""      ,""   ,""         ,""		        	 	,""      ,""      ,""    ,""        ,""                	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf
Next

DbSelectArea(_sAlias)
	
Return Nil                
