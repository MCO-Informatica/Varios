#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} CSFAT100
//Rotina para manutenção de valores de ISS divergentes
//entre PMSP x Protheus
//	Possibilita dois métodos para processamento do arquivo:
//	Um campo Memo cujas informações inseridas devem seguir o padrão Chave + Valor, sendo Chave = Número da NF e Valor = Valor ISS PMSP
//	Um campo Arquivo que conterá o caminho para o qual está salvo o arquivo a ser processado, no mesmo padrão Chave + Valor.
//	Indiferente da origem, os dados devem ser inseridos com layout: 000000000;00.00
//	Ou seja, número da NF e valor ISS PMSP, separados por ponto-e-vírgula
@author yuri.volpe
@since 13/07/2020
@version 1.0

@type function
/*/
User Function CSFAT100()

	Local aPergs 	:= {}
	Local cCodRec 	:= space(08)
	Local lRet
	
	Private aNotas 	:= {}
	Private aRet 	:= {}
	Private cPedIn	:= ""
	
	aAdd( aPergs ,{6 ,"Arquivo Ajuste ISS" 	,Space(70)	,""	  ,"","",50,.F.,"Arquivos .CSV |*.CSV"}) //Arquivo CSV no formato 000000000;00.00
	
	If !ParamBox(aPergs ,"Parametros ",aRet)
		Alert("O processamento foi cancelado!")
		Return
	EndIf

	//Prioriza a execução por arquivo
	If !Empty(aRet[1])
		Processa( {|| CSFAT100B() }, "Executando ajuste...")
		Alert("Processamento concluído.")
	Else
		Alert("Nenhum arquivo foi selecionado")
	EndIf

Return

/*/{Protheus.doc} CSFAT100B
//Processamento do arquivo para alteração do valor de ISS na NF e nos Livros Fiscais
@author yuri.volpe
@since 13/07/2020
@version 1.0

@type function
/*/
Static Function CSFAT100B

Local cLin 			:= ""
Local cNotaFiscal	:= ""
Local cHeader		:= ""
Local cFileLog		:= "C:\DATA\AjusteISS\log\processamento_" + DTOS(dDataBase) + StrTran(Time(),":","") + ".csv"
Local nI			:= 0
Local Nx			:= 0
Local nDiferenca 	:= 0
Local nValISS		:= 0 
Local nTotRec		:= 0
Local nSomaISS		:= 0
Local nHdlLog		:= 0
Local nRecAtu		:= 0
Local aAreaSD2 		:= {}
Local aLog			:= {}

Private cEOL    := "CHR(13)+CHR(10)"
Private cArq    := ""
Private nHdl    := 0

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Tenta abrir o arquivo
nHdl    := fOpen(aRet[1],68)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
Endif

FT_FUSE(aRet[1])

nTotRec := FT_FLASTREC()

FT_FGOTOP()

//Abre as tabelas necessárias para processamento.
dbSelectArea("SF3")
dbSelectArea("SFT")
dbSelectArea("SF2")
dbSelectArea("SD2")

//Abre índices de acordo com a necessidade de processamento.
SF3->(dbSetOrder(6)) //F3_FILIAL + F3_NFISCAL + F3_SERIE
SFT->(dbSetOrder(6)) //FT_FILIAL + FT_TIPOMOV + FT_NFISCAL + FT_SERIE
SF2->(dbSetOrder(1)) //F2_FILIAL + F2_DOC + F2_SERIE
SD2->(dbSetOrder(3)) //D2_FILIAL + D2_DOC + D2_SERIE

While !FT_FEOF()
	
	IncProc( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
	ProcessMessage()

	//Carrega linha do arquivo
	xBuff	:= alltrim(FT_FREADLN())
	aLin 	:= StrTokArr(xBuff,";")
	
	cNotaFiscal	:= Iif(Len(aLin)>0,aLin[1],"")	   						//aLin[1] = Nota Fiscal Protheus
	nValISS		:= Val(StrTran(Iif(Len(aLin)>1,aLin[2],"0"),",","."))	//aLin[2] = Valor ISS na Prefeitura
	
	//Registra informações para gravação de log
	aAdd(aLog, {cNotaFiscal, nValISS, {}})
	
	//Opera somente se houver NF
	If !Empty(cNotaFiscal)
	
		cNotaFiscal := PADR(cNotaFiscal,TamSX3("F2_DOC")[1]," ")
	
		//Posiciona para alterar Livro Fiscal - RP2 Serviço
		If SF3->(dbSeek(xFilial("SF3") + cNotaFiscal + "RP2"))
			
			//Loga valor anterior da SF3
			aAdd(aTail(aLog)[3],{"F3_VALICM", SF3->F3_VALICM})
			
			//Faz alteração apenas se os valores forem divergentes
			If SF3->F3_VALICM != nValISS
				RecLock("SF3",.F.)
					SF3->F3_VALICM := nValISS
				SF3->(MsUnlock())
			EndIf
			
		EndIf
		
		//Posiciona o item do livro fiscal para verificar se há divergência
		//de valores. É alterado sempre o primeiro item ordenado.
		nSomaISS := 0
		nDiferenca := 0
		If SFT->(dbSeek(xFilial("SFT") + "S" + cNotaFiscal + "RP2"))
		
			aAdd(aTail(aLog)[3],{"FT_VALICM", SFT->FT_VALICM})
			
			//Efetua a somatória dos itens dos livros fiscais para verificação
			aAreaSFT := SFT->(GetArea())
			While SFT->(!EoF()) .And. SFT->FT_NFISCAL == cNotaFiscal .And. SFT->FT_SERIE == "RP2"
				nSomaISS += SFT->FT_VALICM
				SFT->(dbSkip())
			EndDo
			RestArea(aAreaSFT)
			
			//Verifica se a soma do ISS dos itens é diferente do total informado
			If nSomaISS <> nValISS
				nDiferenca := nValISS - nSomaISS
				RecLock("SFT",.F.)
					SFT->FT_VALICM := SFT->FT_VALICM + nDiferenca
				SFT->(MsUnlock())
			EndIf
			
		EndIf
		
		//Posiciona no Documento de Saída para correção
		If SF2->(dbSeek(xFilial("SF2") + cNotaFiscal + "RP2"))
			
			aAdd(aTail(aLog)[3],{"F2_VALISS", SF2->F2_VALISS})
			
			If SF2->F2_VALISS <> nValIss
				RecLock("SF2",.F.)
					SF2->F2_VALISS := nValIss
				SF2->(MsUnlock())
			EndIf
		EndIf
		
		nSomaISS := 0
		nDiferenca := 0
		If SD2->(dbSeek(xFilial("SD2") + cNotaFiscal + "RP2"))
			
			aAdd(aTail(aLog)[3],{"D2_VALISS", SD2->D2_VALISS})
			
			aAreaSD2 := SD2->(GetArea())
			While SD2->(!EoF()) .And. SD2->D2_DOC == cNotaFiscal .And. SD2->D2_SERIE == "RP2"
				nSomaISS += SD2->D2_VALISS
				SD2->(dbSkip())
			EndDo
			RestArea(aAreaSD2)
			
			If nSomaISS <> nValISS
				nDiferenca := nValISS - nSomaISS
				RecLock("SD2",.F.)
					SD2->D2_VALISS := SD2->D2_VALISS + nDiferenca
				SD2->(MsUnlock())
			EndIf
			
		EndIf
		
	EndIf
		
	FT_FSKIP()
	
Enddo

FT_FUSE()
fClose(nHdl)

//Cria arquivo de log e exibe na tela
nHdlLog := fCreate(cFileLog)
If nHdlLog > 0

	cHeader := "Nota Fiscal; Valor ISS Anterior; F3_VALICM; FT_VALICM; F2_VALISS; D2_VALISS" + CHR(13)+CHR(10)
	fWrite(nHdlLog, cHeader)

	cLin := ""
	For Ni := 1 To Len(aLog)
		cLin += aLog[Ni][1] + ";" + cValToChar(aLog[Ni][2]) + ";"
		For Nx := 1 To Len(aLog[Ni][3])
			cLin += cValToChar(aLog[Ni][3][Nx][2]) + ";"
		Next
		cLin += CHR(13) + CHR(10)
	Next

	fWrite(nHdlLog, cLin)
EndIf

fClose(nHdlLog)

//Abre o excel com os dados
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cFileLog)
oExcelApp:SetVisible(.T.)

Return   

/*/{Protheus.doc} CSFAT100A
//Salva as informações digitadas no campo Memo em arquivo na pasta Temp do usuário
//E chama a função CSFAT100B para processamento do arquivo temporário.
@author yuri.volpe
@since 13/07/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function CSFAT100A()

Local cQuery 	:= ""
Local nI	 	:= 0
Local cNotasIn 	:= ""
Local cPath		:= GetTempPath()
Local cFileTmp	:= "ajusteiss_" + DTOS(dDataBase) + StrTran(Time(),":","")
Local nHdlTmp	:= 0

ProcRegua(Len(aNotas))

nHdlTmp := fCreate(cPath + cFileTmp)

If nHdlTmp > 0
	For Ni := 1 To Len(aNotas)
		fWrite(nHdlTmp, aNotas[Ni])
	Next
EndIf

fClose(nHdlTmp)

aRet[1] := cPath + cFileTmp

CSFAT100B()

fErase(aRet[1])

Return

/*For nI := 1 To Len(aNotas)
	IncProc("Elencando Notas")
	ProcessMessage()
	cNotasIn += "'" + aNotas[Ni] + "'" + Iif(Ni < Len(aNotas),",","")
Next

cQuery += "Declare " + CRLF
cQuery += "      Cursor c_cursor is " + CRLF
cQuery += "SELECT *  " + CRLF
cQuery += "FROM ( " + CRLF
//--Livro Fiscal - item
cQuery += "SELECT '1' AS TABELA, FT_NFISCAL AS NOTA, FT_VALCONT AS VALOR, FT_ALIQICM AS ALIQUOTA, FT_VALICM AS OLD_ISS, ROUND((FT_VALCONT * (FT_ALIQICM/100)),3) AS NEW_ISS, FT.R_E_C_N_O_ AS RECNO, " + CRLF
cQuery += "'FT_VALICM = NEW_ISS' AS EXECUTE " + CRLF
cQuery += "FROM SFT010 FT " + CRLF
cQuery += "WHERE FT.D_E_L_E_T_= ' ' " + CRLF
cQuery += "AND FT_FILIAL = '02' " + CRLF
cQuery += "AND FT_SERIE = 'RP2' " + CRLF
//-- --------------- 
cQuery += "UNION " + CRLF
//-- --------------- 
//--Livro Fiscal - cabeçalho
cQuery += "SELECT '2' AS TABELA, F3_NFISCAL AS NOTA, F3_VALCONT AS VALOR, F3_ALIQICM AS ALIQUOTA, F3_VALICM AS OLD_ISS, ROUND((F3_VALCONT * (F3_ALIQICM/100)),3) AS NEW_ISS, F3.R_E_C_N_O_ AS RECNO, " + CRLF
cQuery += "'F3_VALICM = NEW_ISS' AS EXECUTE " + CRLF
cQuery += "FROM SF3010 F3 " + CRLF
cQuery += "WHERE F3.D_E_L_E_T_= ' ' " + CRLF
cQuery += "AND F3_FILIAL = '02' " + CRLF
cQuery += "AND F3_SERIE = 'RP2' " + CRLF
//-- --------------- 
cQuery += "UNION " + CRLF
//-- ---------------
//--NF saída - item
cQuery += "SELECT '3' AS TABELA, D2_DOC AS NOTA, D2_TOTAL AS VALOR, D2_ALIQISS AS ALIQUOTA, D2_VALISS AS OLD_ISS, ROUND((D2_TOTAL * (D2_ALIQISS/100)),3) AS NEW_ISS, D2.R_E_C_N_O_ AS RECNO, " + CRLF
cQuery += "'D2_VALISS = NEW_ISS' AS EXECUTE " + CRLF
cQuery += "FROM SD2010 D2 " + CRLF
cQuery += "WHERE D2.D_E_L_E_T_= ' ' " + CRLF
cQuery += "AND D2_FILIAL = '02' " + CRLF
cQuery += "AND D2_SERIE = 'RP2' " + CRLF
//-- ---------------
cQuery += "UNION " + CRLF
//-- ---------------
//--NF saída - cabeçalho
cQuery += "SELECT '4' AS TABELA, F2_DOC AS NOTA, F2_VALBRUT AS VALOR, 2.9 AS ALIQUOTA, F2_VALISS AS OLD_ISS, ROUND((F2_VALBRUT * 0.0290),3) AS NEW_ISS, F2.R_E_C_N_O_ AS RECNO, " + CRLF
cQuery += "'F2_VALISS = NEW_ISS' AS EXECUTE " + CRLF
cQuery += "FROM SF2010 F2 " + CRLF
cQuery += "WHERE F2.D_E_L_E_T_= ' ' " + CRLF
cQuery += "AND F2_FILIAL = '02' " + CRLF
cQuery += "AND F2_SERIE = 'RP2') " + CRLF
cQuery += "WHERE  NOTA = ANY (" + CRLF
cQuery += cNotasIn + CRLF
cQuery += ") " + CRLF
//-- --------------
cQuery += "ORDER BY NOTA, TABELA;   " + CRLF
//-- ---
cQuery += "          j       number :=0;    " + CRLF
//-- ---  
cQuery += "Begin " + CRLF
cQuery += "      For v_registro in c_cursor " + CRLF
cQuery += "      Loop " + CRLF
cQuery += "if v_registro.TABELA = '1' then " + CRLF
cQuery += "update protheus.SFT010 set FT_VALICM = v_registro.NEW_ISS where R_E_C_N_O_ = v_registro.RECNO;     " + CRLF
cQuery += "elsif v_registro.TABELA = '2' then " + CRLF
cQuery += "update protheus.SF3010 set F3_VALICM = v_registro.NEW_ISS where R_E_C_N_O_ = v_registro.RECNO;     " + CRLF
cQuery += "elsif v_registro.TABELA = '3' then " + CRLF
cQuery += "update protheus.SD2010 set D2_VALISS = v_registro.NEW_ISS where R_E_C_N_O_ = v_registro.RECNO;     " + CRLF
cQuery += "elsif v_registro.TABELA = '4' then " + CRLF
cQuery += "update protheus.SF2010 set F2_VALISS = v_registro.NEW_ISS where R_E_C_N_O_ = v_registro.RECNO;     " + CRLF
cQuery += "end if; " + CRLF
cQuery += "          j := j +1; " + CRLF
cQuery += "          if mod(j,100)= 0 then " + CRLF
cQuery += "            commit; " + CRLF
cQuery += "          end if; " + CRLF
cQuery += "      End Loop; " + CRLF
cQuery += "          commit; " + CRLF
cQuery += " end; " + CRLF

MemoWrite("C:\DATA\SQL\SCRIPT_ATU_ISS.sql",cQuery)

//MsAguarde({|| nExec := TcSQLExec(cQuery)},"Executando Script de Atualização","Aguarde")

/*If nExec < 0
	MsgAlert(TcSQLError())
	Return
EndIf*/

//Alert("Processamento concluído.")
	
//Return

