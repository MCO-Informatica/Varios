
#include "RwMake.ch"
#include "TopConn.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?RFATR02   ?Autor  ?Fernando Macieira   ? Data ? 20/Mar/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Relatorio de NF's de Saidas com Desconto Verion p/ Excel.  ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Especifico Verion                                          ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function RFATR02()

Local aSays,aButtons,cTitulo,nOpc,cPerg,cNomRel,nAnaSin

aSays    := {}
aButtons := {}
nOpc     := 0
cPerg    := "FATR02    "
cNomRel  := "RFATR02"
cTitulo  := "Sa?das"

ValidPerg(@cPerg)
Pergunte(cPerg,.f.)

aAdd(aSays,"V E R I O N")
aAdd(aSays,"-------------------------------------------------------------------------------------")
aAdd(aSays,"Programa para exportar as notas fiscais de Sa?das em arquivo, com o Desconto Verion.")
aAdd(aSays,"Aten??o:----------------------------------------------------------------------")
aAdd(aSays,"Arquivo: o caractere separador ser?:  ;  ")
aAdd(aSays,"Filtro CFOP: informe-os separandos-os com V?rgula Simples")
aAdd(aSays,"D?lar: o sistema far? 5 tentativas caso n?o encontre a taxa na emiss?o da NF")

aAdd(aButtons,{5,.t.,{|o|Pergunte(cPerg,.t.)}})
aAdd(aButtons,{1,.t.,{|o|nOpc:=1,o:oWnd:End()}})
aAdd(aButtons,{2,.t.,{|o|o:oWnd:End()}})
FormBatch(cTitulo,aSays,aButtons)

If nOpc == 1
	If msgBox("Confirma gera??o do arquivo?","Confirma","YesNo")

		//Cria arquivo texto
		cDir := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",;
		OEMtoAnsi("Selecione o diret?rio de grava??odo arquivo "+AllTrim(cNomRel)+".txt"),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)
		cDir := AllTrim(cDir)+cNomRel+".TXT"
		
		If At(".TXT",cDir) > 0
			nHdlText := fCreate(cDir)
		Else
			Aviso("Sa?das",;
			"N?o foi selecionado nenhum arquivo para gravar",;
			{"&Ok"},,;
			"Sem Arquivo")
		EndIf
		
		Processa({||ProcTXT(@nHdlText)},"Gerando Arquivo...")

	EndIf
EndIf

Return

//????????????????????????????????
Static Function ProcTXT(nHdlText)
//????????????????????????????????

Local cTxt,nRegCount,cChave,nValLiq,nValBru,cQuery,cFilDe,cFilAte,cDocDe,cDocAte,cSerDe,cSerAte,cCliDe,cCliAte,cLjDe,cLjAte,cDtDe,cDtAte,cProdDe,cProdAte,cFiltro,cCFDe,cCFAte,nUsaFil,nAnaSin,cData,cRazao,cDescV,cTpMoeda,cTxMoeda,dDataTx

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

cTxt := ""          
cChave := ""
nRegCount := 0

If Select("WorkS") > 0
	WorkS->(dbCloseArea())
EndIf                    
                                                
cQuery := " SELECT D2_EMISSAO,D2_DOC,D2_SERIE,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_COD,D2_EST,D2_CF,D2_QUANT,D2_PRCVEN,D2_VALBRUT,D2_PICM,D2_BASEICM,D2_VALICM,D2_IPI,D2_BASEIPI,D2_VALIPI,D2_BASEISS,D2_VALISS,D2_ALQIMP5,D2_VALIMP5,D2_ALQIMP6,D2_VALIMP6,D2_PEDIDO,D2_ITEMPV "
cQuery += " FROM " +RetSqlName("SD2") 
cQuery += " WHERE D2_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "
cQuery += " AND D2_DOC BETWEEN '"+cDocDe+"' AND '"+cDocAte+"' "
cQuery += " AND D2_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "
cQuery += " AND D2_CLIENTE BETWEEN '"+cCliDe+"' AND '"+cCliAte+"' "
cQuery += " AND D2_LOJA BETWEEN '"+cLjDe+"' AND '"+cLjAte+"' "
cQuery += " AND D2_EMISSAO BETWEEN '"+DtoS(cDtDe)+"' AND '"+DtoS(cDtAte)+"' "
cQuery += " AND D2_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "
Iif((nUsaFil)==2,cQuery += " AND D2_CF BETWEEN '"+cCFDe+"' AND '"+cCFAte+"' ",)  // Utiliza Filtro? (NAO)
Iif((nUsaFil)==1,cQuery += " AND D2_CF IN ("+AllTrim(cFiltro)+") ",) // Utiliza Filtro? (SIM)
cQuery += " AND D_E_L_E_T_=' ' "

tcQuery cQuery New Alias "WorkS"

cTxt := "DATA"+";"+"NOTA"+";"+"SERIE"+";"+"CLIENTE"+";"+"NOME"+";"+"PRODUTO"+";"+"DESC_PROD"+";"
cTxt += "CLAS_IPI"+";"+"UF"+";"+"CFOP"+";"+"QTD"+";"+"VLR_UNIT"+";"+"VLR_BRUT"+";"+"ALIQ_ICMS"+";"+"BASE_ICM"+";"+"VLR_ICM"+";"
cTxt += "ALIQ_IPI"+";"+"BASE_IPI"+";"+"VLR_IPI"+";"+"BASE_ISS"+";"+"VLR_ISS"+";"+"VLR_LIQ"+";"+"ALIQ_COFINS"+";"
cTxt += "VLR_COFINS"+";"+"ALIQ_PIS"+";"+"VLR_PIS"+";"+"%_DESC_VERION"+";"+"MOEDA"+";"+"TAXA_DOLAR"+";"+"DATA_TAXA"
fWrite(nHdlText,cTxt+Chr(13)+Chr(10))

ProcRegua(0)

dbSelectArea("WorkS")
WorkS->(dbGoTop())
Do While WorkS->(!EOF())
	IncProc("Processados " +Chr(32)+AllTrim(Str(nRegCount+1))+ " registros (Sa?da)")

	nValLiq   := WorkS->(D2_VALBRUT-D2_VALICM-D2_VALIPI-D2_VALISS)
	cData     := Right(D2_EMISSAO,2)+"/"+Substr(D2_EMISSAO,5,2)+"/"+Left(D2_EMISSAO,4)
	cRazao    := Iif(WorkS->D2_TIPO$"BD",Posicione("SA2",1,xFilial("SA2")+D2_CLIENTE+D2_LOJA,"A2_NOME"),Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_NOME"))
	cDescV    := Posicione("SC6",1,xFilial("SD2")+WorkS->(D2_PEDIDO+D2_ITEMPV+D2_COD),"C6_VRDESC")
	cTpMoeda  := Posicione("SB1",1,xFilial("SD2")+WorkS->D2_COD,"B1_TPMOEDA")
	cTxMoeda  := PegMoeda(WorkS->D2_EMISSAO)
	dDataTx   := SM2->M2_DATA

	cTxt := ""
	cTxt += cData+";"+D2_DOC+";"+D2_SERIE+";"+D2_CLIENTE+";"+cRazao+";"
	cTxt += D2_COD+";"+Posicione("SB1",1,xFilial("SD2")+D2_COD,"B1_DESC")+";"+Posicione("SB1",1,xFilial("SD2")+D2_COD,"B1_POSIPI")+";"+D2_EST+";"+D2_CF+";"
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
	cTxt += Iif(Left(Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","),1)==",",Str(nValLiq),Stuff(Str(nValLiq),Rat(".",Str(nValLiq)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_ALQIMP5),Rat(".",Str(D2_ALQIMP5)),1,","),1)==",",Str(D2_ALQIMP5),Stuff(Str(D2_ALQIMP5),Rat(".",Str(D2_ALQIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALIMP5),Rat(".",Str(D2_VALIMP5)),1,","),1)==",",Str(D2_VALIMP5),Stuff(Str(D2_VALIMP5),Rat(".",Str(D2_VALIMP5)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_ALQIMP6),Rat(".",Str(D2_ALQIMP6)),1,","),1)==",",Str(D2_ALQIMP6),Stuff(Str(D2_ALQIMP6),Rat(".",Str(D2_ALQIMP6)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(D2_VALIMP6),Rat(".",Str(D2_VALIMP6)),1,","),1)==",",Str(D2_VALIMP6),Stuff(Str(D2_VALIMP6),Rat(".",Str(D2_VALIMP6)),1,","))+";"
	cTxt += Iif(Left(Stuff(Str(cDescV),Rat(".",Str(cDescV)),1,","),1)==",",Str(cDescV),Stuff(Str(cDescV),Rat(".",Str(cDescV)),1,","))+";"
	cTxt += cTpMoeda+";"
	cTxt += Iif(Left(Stuff(Str(cTxMoeda),Rat(".",Str(cTxMoeda)),1,","),1)==",",Str(cTxMoeda),Stuff(Str(cTxMoeda),Rat(".",Str(cTxMoeda)),1,","))+";"
	cTxt += DtoC(dDataTx)

	fWrite(nHdlText,ctxt+Chr(13)+Chr(10))

	WorkS->(dbSkip())
	nRegCount++
EndDo

fClose(nHdlText)
msgInfo("Arquivo gerado com sucesso!")

oExcelApp := msExcel():New()
oExcelApp:SetVisible(.t.)

//??????????????????????????????
Static Function ValidPerg(cPerg)
//??????????????????????????????
Local _sAlias := Alias()
Local aRegs := {}
Local i,j
	
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)
	
aAdd(aRegs,{cPerg,"01"  ,"Da Filial                 "	,""      ,""     ,"MV_CH1","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"02"  ,"Ate Filial                "	,""      ,""     ,"MV_CH2","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"03"  ,"Da NF Sa?da               "	,""      ,""     ,"MV_CH3","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""})
aAdd(aRegs,{cPerg,"04"  ,"Ate NF Sa?da              "	,""      ,""     ,"MV_CH4","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR04",""         			,""      ,""      ,""   ,""         ,""            	    	,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""})
aAdd(aRegs,{cPerg,"05"  ,"Da Serie NF Sa?da         "	,""      ,""     ,"MV_CH5","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR05",""         			,""      ,""      ,""   ,""         ,""            		    ,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"06"  ,"Ate Serie NF Sa?da        "	,""      ,""     ,"MV_CH6","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR06",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"07"  ,"Do Cliente                "	,""      ,""     ,"MV_CH7","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR07",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""})
aAdd(aRegs,{cPerg,"08"  ,"Ate Cliente               "	,""      ,""     ,"MV_CH8","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR08",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""})
aAdd(aRegs,{cPerg,"09"  ,"Da Loja                   "	,""      ,""     ,"MV_CH9","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR09",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"10"  ,"Ate Loja                  "	,""      ,""     ,"MV_CHA","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR10",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""            	    ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"11"  ,"Do Produto                "	,""      ,""     ,"MV_CHB","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR11",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SB1"})
aAdd(aRegs,{cPerg,"12"  ,"Ate Produto               "	,""      ,""     ,"MV_CHC","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR12",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SB1"})
aAdd(aRegs,{cPerg,"13"  ,"Da Emiss?o                "	,""      ,""     ,"MV_CHD","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR13",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"14"  ,"Ate Emiss?o               "	,""      ,""     ,"MV_CHE","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR14",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"15"  ,"Da CFOP                   "	,""      ,""     ,"MV_CHF","C"    ,04      ,0       ,0     ,"G" ,""    ,"MV_PAR15",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"16"  ,"Ate CFOP                  "	,""      ,""     ,"MV_CHG","C"    ,04      ,0       ,0     ,"G" ,""    ,"MV_PAR16",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"17"  ,"Utiliza Filtro?           "	,""      ,""     ,"MV_CHH","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR17","Sim"      			,""      ,""      ,""   ,""         ,"N?o"             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"18"  ,"Filtro CFOP               "	,""      ,""     ,"MV_CHI","C"    ,99      ,0       ,0     ,"G" ,""    ,"MV_PAR18",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })

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

//????????????????????????????????
Static Function PegMoeda(cDtMoeda)
//????????????????????????????????

Local aAreaAtu

aAreaAtu := GetArea()

dbSelectArea("SM2")
SM2->(dbSetOrder(1))
If SM2->(!dbSeek(cDtMoeda))
	For i:=1 to 5
		If SM2->(dbSeek(StoD(cDtMoeda)+i))
			Exit
		EndIf
	Next i
EndIf

RestArea(aAreaAtu)

Return SM2->M2_MOEDA2

