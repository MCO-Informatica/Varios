#include 'totvs.ch' 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSDK29   �Autor  RENATO RUY           � Data �  14/12/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  RELATORIO MONITOR DO CHAT                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ServiceDesk - Certisign                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTSDK29()

Local bValid := {||valid() }
Local aPar 	 := {}

Private aRet 		:= {}

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Grupo"	,Space(2)	,"@!","","SU0","",30,.F.})
aAdd( aPar,{ 1  ,"Data de"	,dDataBase	,"@D","",""   ,"",50,.F.})
aAdd( aPar,{ 1  ,"Data Ate"	,dDataBase	,"@D","",""   ,"",50,.F.})


If ParamBox( aPar, 'Par�metros', @aRet, bValid, , , , , ,"CST028" , .T., .F. )
	Processa( {|| CTSDK29G() }, "Relat�rio Monitor Chat...")
Else
	Alert("Rotina Cancelada!")
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSDK29   �Autor  RENATO RUY           � Data �  25/07/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  RELATORIO MENSAL DO CHAT                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ServiceDesk - Certisign                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CTSDK29G()

Local cCabec 		:= ""
Local cDados 		:= ""
Local aTotOpe		:= {}
Local cNome  		:= ""
Local nQtdOpe		:= 0
Local cObsAtend 	:= ""
Local cOcorrencia 	:= ""
Local cCodAssunto	:= ""
Local cAssunto		:= ""
Local cAux			:= ""
Local cLinha		:= ""
Local nTamLinha		:= 0
Local nStartTag		:= 0
Local nEndTag		:= 0
Local cTag			:= ""
Local cValor		:= ""
Local aTag			:= {}
Local nLineCnt		:= 0

Beginsql Alias "TMCHAT"

	%NOPARSER%

	SELECT ZM_NOMEOP,
		  	GROUPID,
			ZM_PROTOCO,
			DETAILED,
			TO_DATE(TO_CHAR(START_Q,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') START_Q,
			SUBSTR(TO_CHAR(START_Q,'DD/MM/YYYY HH24:MI:SS'),12,8) HORAI_Q,
			TO_DATE(TO_CHAR(STOP_Q,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') STOP_Q,
			SUBSTR(TO_CHAR(STOP_Q,'DD/MM/YYYY HH24:MI:SS'),12,8) HORAF_Q,
			TO_DATE(TO_CHAR(START_C,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') START_C,
			SUBSTR(TO_CHAR(START_C,'DD/MM/YYYY HH24:MI:SS'),12,8) HORAI_C,
			TO_DATE(TO_CHAR(STOP_C,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') STOP_C,
			SUBSTR(TO_CHAR(STOP_C,'DD/MM/YYYY HH24:MI:SS'),12,8) HORAF_C,
			SUBSTR(TO_CHAR(STOP_Q-START_Q,'DD/MM/YYYY HH24:MI:SS'),12,8) TME,
			SUBSTR(TO_CHAR(STOP_C-START_C,'DD/MM/YYYY HH24:MI:SS'),12,8) TMA		
	FROM WEBCHAT.CHAT_HISTORY
	JOIN WEBCHAT.CHAT_EVENT_TYPE
	ON EVENT = EXIT_EVENT
	left JOIN SZM010 SZM ON ZM_FILIAL = ' ' AND TRIM(ZM_SESSAO) = ROOM AND SZM.%notDel%
	WHERE 
	DAY BETWEEN TO_DATE(%Exp:DtoS(aRet[2])%, 'YYYYMMDD') AND  TO_DATE(%Exp:DtoS(aRet[3])%, 'YYYYMMDD')
	AND GROUPID = %Exp:aRet[1]%
	ORDER BY ZM_NOMEOP


Endsql

dbSelectArea("ADE")
ADE->(dbSetOrder(1))

dbSelectArea("ADF")
ADF->(dbSetOrder(1))

cCabec := "Nome do analista;"										
cCabec += "C�digo do Atendimento;"
cCabec += "Data recebimento;"
cCabec += "Hor�rio de recebimento;"
cCabec += "Data de in�cio;"
cCabec += "Hor�rio de in�cio;"
cCabec += "Data do fim;"
cCabec += "Hor�rio de fim;"
cCabec += "Motivo de encerramento;"
cCabec += "TME (Tempo m�dio de espera);"
cCabec += "TMA (Tempo m�dio de atendimento);"
//cCabec += "Question�rio da Conversa;"
cCabec += "Ocorr�ncia;"
cCabec += "Assunto;"
cCabec += "Nome do Usu�rio;"
cCabec += "CPF (XXX.XXX.XXX-XX);"
cCabec += "Qual seu E-mail?;"	
cCabec += "Qual seu Telefone?;"	
cCabec += "Nome AR / Ponto de Atendimento;"	
cCabec += "Nome da Rede;"		

cNome := TMCHAT->ZM_NOMEOP 

ProcRegua(TMCHAT->(RecCount()))

While !TMCHAT->(EOF())

	IncProc()

	//Localizo o atendimento na ADE
	If ADE->(dbSeek(xFilial("ADE")+TMCHAT->ZM_PROTOCO))
		cCodAssunto := ADE->ADE_ASSUNT
		cAssunto	:= Iif(!Empty(cCodAssunto),GetAdvFVal('SX5', 'X5_DESCRI', xFilial('SX5') + "T1" + cCodAssunto, 1),"")
		
		//Localizo as ocorrencias na ADF e realizo itera��o para verificar os itens.
		If ADF->(dbSeek(xFilial("ADF")+ADE->ADE_CODIGO))		
			While ADF->(!EoF()) .And. ADF->ADF_FILIAL + ADF->ADF_CODIGO == ADE->ADE_FILIAL + TMCHAT->ZM_PROTOCO
			
				cOcorrencia	:= Iif(!Empty(cCodAssunto),AllTrim(GetAdvFVal('SU9', 'U9_DESC', xFilial('SU9') + ADF->ADF_CODSU9, 2)),"")
				cObsAtend	:= Iif(!Empty(ADF->ADF_CODOBS),MSMM(ADF->ADF_CODOBS),"")
		
				cAux 	  := cObsAtend //Carrego a auxiliar para capturar os valores do campo Memo, dentro dos colchetes.
				Ni 		  := 1	//Variavel de controle para carga da linha
				nTamLinha := 0	//Auxiliar para controle do tamanho da linha 
	
				aTag := {} //Carrego "tags" e seus valores no array
				
				//La�o para tratar os valores entre []
				While Ni <= Len(cObsAtend)
					//Pega a linha completa, inclusive com CRLF
					cLinha := Substr(cAux,1,at(CHR(13)+CHR(10), cAux)+1)
				
					nTamLinha := Len(cLinha)
					
					nStartTag := at("[", cLinha) 	//Recupera o primeiro colchete indicador da abertura da TAG
					nEndTag := at("]", cLinha) 		//Recupera o colchete de fechamento da TAG
					
					//Recupera TAG
					cTag := Substr(cLinha, nStartTag+1, nEndTag-2)
					
					//Somente se houver tag e se registro da conversa
					If nStartTag > 0 .And. nEndTag > 0 .And. !(":" $ cTag)
						
						cValor := Substr(cLinha, nEndTag+1, nTamLinha )
						
						//Removo o tra�o, se houver
						If " - " $ cValor  
							cValor := Substr(cValor,at(" - ", cValor)+3)
						EndIf
						
						//Removo os caracteres CarriageReturn LineFeed 
						If at(CHR(13)+CHR(10), cValor) > 0
							cValor := Substr(cValor,1,Len(cValor)-2) 
						EndIf
						
						//Adiciono as Tags para relatorio dinamico
						aAdd(aTag,{cTag,cValor})
						
					EndIf
					
					//Corto a string auxiliar excluindo a linha processada.
					cAux := substr(cAux,nTamLinha+1)
					//Adiciono ao tamanho processado
					Ni += nTamLinha
					
				EndDo
			
				//Caso nenhuma tag tenha sido retornada, entendo que a linha n�o tem observa��es pertinentes e pulo.
				//23.07.18 - Desconsidero o pulo, conforme solicita��o na OTRS 2018051510001777 
				/*If Len(aTag) == 0 .And. nLineCnt > 0
					ADF->(dbSkip())
					Exit
				EndIf*/
				
				//Carrego dados para impress�o
				nPNomeUser 	:= aScan(aTag,{|z| AllTrim(z[1]) == "Nome do Usu�rio"})
				nPCPF		:= aScan(aTag,{|z| AllTrim(z[1]) == "CPF (XXX.XXX.XXX-XX)"})
				nPEmail		:= aScan(aTag,{|z| AllTrim(z[1]) == "Qual seu E-mail?"})	
				nPTel		:= aScan(aTag,{|z| AllTrim(z[1]) == "Qual seu Telefone?"})
				nPNomeAR	:= aScan(aTag,{|z| AllTrim(z[1]) == "Nome AR / Ponto de Atendimento"})
				NPNomeRede	:= aScan(aTag,{|z| AllTrim(z[1]) == "Nome da Rede"})
				
				cDados += Iif(Empty(TMCHAT->ZM_NOMEOP),"Sem Analista Vinculado",TMCHAT->ZM_NOMEOP) + ";"	// "Nome do analista;"																				
				cDados += TMCHAT->ZM_PROTOCO + ";"		//"C�digo do Atendimento;"
				cDados += DtoC(TMCHAT->START_Q) + ";" 	//"Data recebimento;"
				cDados += TMCHAT->HORAI_Q + ";"			//"Hor�rio de recebimento;"
				cDados += DtoC(TMCHAT->START_C) + ";" 	//"Data de in�cio;"
				cDados += TMCHAT->HORAI_C + ";" 		//"Hor�rio de in�cio;"
				cDados += DtoC(TMCHAT->STOP_C) + ";" 	//"Data do fim;"
				cDados += TMCHAT->HORAF_C + ";" 		//"Hor�rio de fim;"
				cDados += TMCHAT->DETAILED + ";" 		//"Motivo de encerramento;"
				cDados += TMCHAT->TME + ";" 			//"TME (Tempo m�dio de espera);"
				cDados += TMCHAT->TMA + ";" 			//"TMA (Tempo m�dio de atendimento);"
				//cDados += ";"							//"Question�rio do Atendimento;" 
				cDados += cOcorrencia + ";"				//"Ocorr�ncia"
				cDados += AllTrim(cAssunto) + ";" 		//"Assunto;"
				cDados += Iif(nPNomeUser> 0,	aTag[nPNomeUser][2]	, "") + ";"	//"Nome do Usu�rio;"
				cDados += Iif(nPCPF    	> 0, 	"'"+aTag[nPCPF][2]	, "") + ";"	//"CPF (XXX.XXX.XXX-XX);"
				cDados += Iif(nPEmail  	> 0,	aTag[nPEmail][2]	, "") + ";"	//"Qual seu E-mail?;"
				cDados += Iif(nPTel    	> 0,	aTag[nPTel][2]		, "") + ";"	//"Qual seu Telefone?;"
				cDados += Iif(nPNomeAR 	> 0,	aTag[nPNomeAR][2]	, "") + ";"	//"Nome AR / Ponto de Atendimento;"
				cDados += Iif(NPNomeRede> 0,	aTag[NPNomeRede][2]	, "") + ";"	//"Nome da Rede;"
			
				cDados += CHR(13)+CHR(10)
				
				nLineCnt++
				nQtdOpe++
				
				ADF->(dbSkip())
			EndDo
		EndIf
	Else
		cDados += Iif(Empty(TMCHAT->ZM_NOMEOP),"Sem Analista Vinculado",TMCHAT->ZM_NOMEOP) + ";"	// "Nome do analista;"																				
		cDados += TMCHAT->ZM_PROTOCO + ";"		//"C�digo do Atendimento;"
		cDados += DtoC(TMCHAT->START_Q) + ";" 	//"Data recebimento;"
		cDados += TMCHAT->HORAI_Q + ";"			//"Hor�rio de recebimento;"
		cDados += DtoC(TMCHAT->START_C) + ";" 	//"Data de in�cio;"
		cDados += TMCHAT->HORAI_C + ";" 		//"Hor�rio de in�cio;"
		cDados += DtoC(TMCHAT->STOP_C) + ";" 	//"Data do fim;"
		cDados += TMCHAT->HORAF_C + ";" 		//"Hor�rio de fim;"
		cDados += TMCHAT->DETAILED + ";" 		//"Motivo de encerramento;"
		cDados += TMCHAT->TME + ";" 			//"TME (Tempo m�dio de espera);"
		cDados += TMCHAT->TMA + ";" 			//"TMA (Tempo m�dio de atendimento);"
		cDados += ";"	//"Question�rio do Atendimento;"
		cDados += ";"	//"Ocorr�ncia;" 
		cDados += ";" 	//"Assunto;"
		cDados += ";"	//"Nome do Usu�rio;"
		cDados += ";"	//"CPF (XXX.XXX.XXX-XX);"
		cDados += ";"	//"Qual seu E-mail?;"
		cDados += ";"	//"Qual seu Telefone?;"
		cDados += ";"	//"Nome AR / Ponto de Atendimento;"
		cDados += ";"	//"Nome da Rede;"
	
		cDados += CHR(13)+CHR(10)
	EndIf
	
	If cNome <> TMCHAT->ZM_NOMEOP .Or. TMCHAT->(EOF())
		AADD(aTotOpe,{cNome,nQtdOpe})
		cNome  := TMCHAT->ZM_NOMEOP
		nQtdOpe:= 0
	Endif
	
	nLineCnt  := 0
	TMCHAT->(DbSkip())
	
Enddo

//Grava totalizadores
cDados += CHR(13)+CHR(10)
cDados += CHR(13)+CHR(10)
cDados += "Produtividade;"										
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------;"
cDados += "-------------"+CHR(13)+CHR(10)

//Adiciona os totais x analista
For nX := 1 To Len(aTotOpe)
	//Grava totalizador por analista
	cDados += Iif(Empty(aTotOpe[nX,1]),"Sem Analista Vinculado",aTotOpe[nX,1])+";"										
	cDados += Str(aTotOpe[nX,2])+CHR(13)+CHR(10)
Next

//Exporta para o excel e abre arquivo
ExpRel(cCabec, cDados)

TMCHAT->(DbCloseArea())
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ExpRel   � Autor � RENATO RUY BERNARDO  � Data � 22/06/17  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera o arquivo em CSV									  ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function ExpRel(cCabec, cItens)

Local cArqLog := GetTempPath()+"Monitor.csv"

nHandle := fCreate(cArqLog)

//Caso n�o seja possivel criar o arquivo, o sistema aborta o processo.
If nHandle == -1
	Alert("O arquivo do relat�rio n�o pode ser gerado!")
	Return
Endif

FWrite(nHandle, cCabec+CHR(13)+CHR(10)+cItens)

fclose(nHandle)           // Fecha arquivo

//Abre o excel com os dados
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cArqLog)
oExcelApp:SetVisible(.T.)

Return

//Renato Ruy - 26/07/2017
//Valida��es parambox
Static Function valid()

Local lRet := .T.

If aRet[2] > aRet[3]
	lRet := .F.
	Alert("A data inicial deve ser menor ou igual a data final!")
Endif

Return lRet