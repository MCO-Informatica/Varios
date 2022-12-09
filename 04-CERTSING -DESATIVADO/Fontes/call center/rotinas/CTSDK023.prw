#Include 'Protheus.ch'

/*/{Protheus.doc} CTSDK023
Rotina de controle de abertura de tela de monitor de chat
@type function
@author david.oliveira
@since 17/06/2016
@version 1.0
@return return , nil
/*/
User Function CTSDK023()
	Local aRet	:= {}
	Local aPBox	:= {}
	Local cGrpMonit := GetNewPar("MV_XGCHATM", "97,28,99,9V")
	Local cLinkMonit:= GetNewPar("MV_XLCHATM", "http://edipo.certintra.com.br:8020/chatmonitor")
	Local aGrpMonit := StrTokArr(cGrpMonit,",")
	Local aGrpPar	:= {}
	Local cGrpSel	:= ""
	
	SetCss("QRadioButtonw { width: 18px; height: 18px; }")

	aEval(aGrpMonit, {|x|  aadd(aGrpPar, x+"-"+Posicione("SU0",1,xFilial("SU0")+x,"U0_NOME"))  } )

	AAdd( aPBox,{ 3, 'Grupo', 1, aGrpPar, 100, ".T.", .T., ".T." } )

	While ParamBox(aPBox,'Grupos Chat', @aRet,,,,,,,,.T.,.T.)
		cGrpSel := aGrpMonit[aRet[1]]

		shellExecute( "Open", cLinkMonit+"/?grupo="+cGrpSel, "", "C:\", 1 )

	EndDo

Return(nil)

/*/{Protheus.doc} CTSDK23J
Rotina de geração de dados em formato json para alimentar painéis de monitor de chat
@type function
@author david.oliveira
@since 17/06/2016
@version 1.0
@param aParSCH, array, Array com empresa e filial a ser aberta para obter dados do monitor
@return return, sem retorno
/*/
User Function CTSDK23J(aParSCH)

	Local _lJob 	:= (Select('SX6')==0)
	Local cGrpMonit := ""
	Local cCtdArq	:= ""
	Local cCtdArq1	:= ""
	Local aGrpMonit	:= {}
	Local cGrpProc	:= ""
	Local nI		:= 0

	Default aParSch	:= {}

	If Len( aParSch ) == 0
		aParSch := { "01", "02" }
	EndIf

	If _lJob
		RpcSetType( 3 )
		RpcSetEnv( aParSch[ 1 ], aParSch[ 2 ] )
	EndIf

	cGrpMonit := GetNewPar("MV_XGCHATM", "97,28,99,9V")
	aGrpMonit := StrTokArr(cGrpMonit,",")

	If !ExistDir( "\chatmonitor" )
		MakeDir("\chatmonitor")
	Endif

	If !ExistDir( "\chatmonitor\data" )
		MakeDir("\chatmonitor\data")
	Endif

	For nI:=1 to Len(aGrpMonit)

		cGrpProc := aGrpMonit[nI]

		If !ExistDir( "\chatmonitor\data\"+cGrpProc )
			MakeDir("\chatmonitor\data\"+cGrpProc)
		Endif

		BeginSql Alias "CHAT1"
			SELECT
			  GRUPO,
			  NOME,
			  SUM(OPERADORES) OPERAD,
			  SUM(JANELAS) JANELAS,
			  SUM(PAUSA) PAUSA,
			  SUM(CONVERSAS_ATIVAS) ATIVA,
			  SUM(CONVERSAS_FINALIZADAS) FINALIZADA
			FROM
			  (

			  SELECT
			    	ZN_GRUPO GRUPO,
			    	U0_NOME NOME,
			    	CASE
		      		WHEN ZN_GRUPO IS NOT NULL THEN 1
		            ELSE 0
		          	END OPERADORES,
		          	CASE
	            	WHEN ZN_PAUSA = '1' THEN 0
	            	ELSE ZN_DISP
		            END JANELAS,
				    0 PAUSA,
				    0 CONVERSAS_ATIVAS,
				    0 CONVERSAS_FINALIZADAS
			  FROM
			    %Table:SU0% SU0 LEFT JOIN %Table:SZN% SZN ON
			      U0_FILIAL = %Exp:xFilial("SU0")% AND
			      ZN_FILIAL = %Exp:xFilial("SZN")% AND
			      U0_CODIGO = ZN_GRUPO AND
			      SUBSTR(ZN_PIN,1,8)= %Exp:DtoC(Date())% AND
			      SU0.%NotDel% AND
			      SZN.%NotDel%
			  WHERE
			  	U0_CODIGO = %Exp:cGrpProc%
			  UNION ALL
			  SELECT
			    U0_CODIGO GRUPO,
			    U0_NOME NOME,
			    0 OPERADORES,
			    0 JANELAS,
			    CASE
	      		WHEN ZN_GRUPO IS NOT NULL  AND ZN_PAUSA  = '1' THEN 1
	            ELSE 0
	            END  PAUSA,
			    0 CONVERSAS_ATIVAS,
			    0 CONVERSAS_FINALIZADAS
			  FROM
			    %Table:SU0% SU0 LEFT JOIN %Table:SZN% SZN ON
			      U0_FILIAL = %Exp:xFilial("SU0")% AND
			      ZN_FILIAL = %Exp:xFilial("SZN")% AND
			      U0_CODIGO = ZN_GRUPO AND
			      ZN_PAUSA = '1' AND
			      SUBSTR(ZN_PIN,1,8)= %Exp:DtoC(Date())% AND
			      SU0.%NotDel% AND
			      SZN.%NotDel%
			  WHERE
			  	U0_CODIGO = %Exp:cGrpProc%
			  UNION ALL
			  SELECT
			    U0_CODIGO GRUPO,
			    U0_NOME NOME,
			    0 OPERADORES,
			    0 JANELAS,
			    0 PAUSA,
			    CASE
	              WHEN ZM_GRUPO IS NOT NULL  AND ZM_STATUS = 'OPEN' THEN 1
	              ELSE 0
	            END  CONVERSAS_ATIVAS,
			    0
			  FROM
			    %Table:SU0% SU0 LEFT JOIN %Table:SZM% SZM ON
			      U0_FILIAL = %Exp:xFilial("SU0")% AND
			      ZM_FILIAL = %Exp:xFilial("SZM")% AND
			      U0_CODIGO = ZM_GRUPO AND
			      ZM_STATUS = 'OPEN' AND
			      ZM_DATA = %Exp:DtoS(Date())% AND
			      SU0.%NotDel% AND
			      SZM.%NotDel%
			  WHERE
			  	U0_CODIGO = %Exp:cGrpProc%
			  UNION ALL
			  SELECT
			    U0_CODIGO GRUPO,
			    U0_NOME NOME,
			    0 OPERADORES,
			    0 JANELAS,
			    0 PAUSA,
			    0 CONVERSAS_ATIVAS,
			    CASE
	              WHEN ZM_GRUPO IS NOT NULL  AND ZM_STATUS = 'CLOSED' THEN 1
	              ELSE 0
	            END
			  FROM
			    %Table:SU0% SU0 LEFT JOIN %Table:SZM% SZM ON
			      U0_FILIAL = %Exp:xFilial("SU0")% AND
			      ZM_FILIAL = %Exp:xFilial("SZM")% AND
			      U0_CODIGO = ZM_GRUPO AND
			      ZM_STATUS = 'CLOSED' AND
			      SUBSTR(ZM_PIN,1,8)= %Exp:DtoC(Date())% AND
			      SU0.%NotDel% AND
			      SZM.%NotDel%
			   WHERE
			  	U0_CODIGO = %Exp:cGrpProc%
			    ) X
			WHERE
				GRUPO > ' '
			GROUP BY
			  GRUPO,
			  NOME
		EndSql

		cCtdArq := '{'
		cCtdArq += '"data": [ '

		CHAT1->( DbEval( {|| 	cCtdArq +=	 '{ "fila": "'+MemoRead("FILACHAT"+Alltrim(CHAT1->GRUPO))+'",',;
								cCtdArq +=	 '"operadores": "'+Alltrim(Str(CHAT1->OPERAD))+'",',;
								cCtdArq +=	 '"janelas": "'+Alltrim(Str(CHAT1->JANELAS))+'",',;
								cCtdArq +=	 '"pausa": "'+Alltrim(Str(CHAT1->PAUSA))+'",',;
								cCtdArq +=	 '"ativas": "'+Alltrim(Str(CHAT1->ATIVA))+'",',;
								cCtdArq +=	 '"finalizadas": "'+Alltrim(Str(CHAT1->FINALIZADA))+'"},' } ) )

		cCtdArq := SubStr(cCtdArq,1,Len(cCtdArq)-1)
		cCtdArq += ']'
		cCtdArq += '}'

		CHAT1->(DbCloseArea())

		MemoWrite("\chatmonitor\data\"+cGrpProc+"\disponibilidade.txt",cCtdArq)

		BeginSql Alias "CHAT2"
		
			%NoParser%
		    
			//Renato Ruy - 18/11/16
			//Retornar dados de pausa no painel
			WITH PAUSAS AS
	        (select zk_operado,
	               sum(decode(zk_tppsa,'001   ',HORAS,0)) PAUSA1,
	               sum(decode(zk_tppsa,'001   ',1,0))     QTDE1,
	               sum(decode(zk_tppsa,'002   ',HORAS,0)) PAUSA2,
	               sum(decode(zk_tppsa,'002   ',1,0))     QTDE2,
	               sum(decode(zk_tppsa,'003   ',HORAS,0)) PAUSA3,
	               sum(decode(zk_tppsa,'003   ',1,0))     QTDE3,
	               sum(decode(zk_tppsa,'004   ',HORAS,0)) PAUSA4,
	               sum(decode(zk_tppsa,'004   ',1,0))     QTDE4,
	               sum(decode(zk_tppsa,'005   ',HORAS,0)) PAUSA5,
	               sum(decode(zk_tppsa,'005   ',1,0))     QTDE5,
	               sum(decode(zk_tppsa,'006   ',HORAS,0)) PAUSA6,
	               sum(decode(zk_tppsa,'006   ',1,0))     QTDE6 from
	        (select zk_operado,
	        zk_tppsa,
	        trunc((to_date(%Exp:DtoC(Date())%||' '||ZK_HRFIM||':00','DD/MM/RRRR HH24:MI:SS') -to_date(%Exp:DtoC(Date())%||' '||ZK_HRINI||':00','DD/MM/RRRR HH24:MI:SS')) * 1440,0)  HORAS from %Table:SZK%
	        where
	        zk_filial = %XFilial:SZK% and
	        zk_dtini = %Exp:DtoS(Date())% and
	        zk_dtfim > ' ' and
	        %NotDel%)
	        group by zk_operado)

			SELECT
				ZN_GRUPO,
				U0_NOME,
				U7_NOME,
				(SELECT MIN(ZN_PIN) FROM %Table:SZN% WHERE ZN_FILIAL = ' ' AND ZN_CODOP = SZN.ZN_CODOP AND SUBSTR(zn_pin,1,8) = %Exp:DtoC(Date())%) ZN_PIN,
  				DECODE(min(SZN.D_E_L_E_T_),' ',' ',(SELECT MAX(ZN_LOGOUT) FROM %Table:SZN% WHERE ZN_FILIAL = ' ' AND SUBSTR(zn_pin,1,8) = %Exp:DtoC(Date())% AND ZN_CODOP = SZN.ZN_CODOP)) ZN_LOGOUT,
  				U7_XJCHAT,
  				DECODE(min(SZN.D_E_L_E_T_),' ',(SELECT MIN(ZN_DISP) FROM %Table:SZN% WHERE ZN_FILIAL = ' ' AND ZN_CODOP = SZN.ZN_CODOP AND SUBSTR(zn_pin,1,8) = %Exp:DtoC(Date())% AND %NotDel%),0) ZN_DISP,
	     		(select COUNT(*) from %Table:SZM% where ZM_FILIAL = ' ' and ZM_CODOP = U7_COD AND substr(zm_pin,1,8) = %Exp:DtoC(Date())% and %NotDel% ) ATENDIMENTO,
	     		DECODE(min(SZN.D_E_L_E_T_),' ',(SELECT MIN(ZN_PAUSA) FROM %Table:SZN% WHERE ZN_FILIAL = ' ' AND ZN_CODOP = SZN.ZN_CODOP AND SUBSTR(zn_pin,1,8) = %Exp:DtoC(Date())% AND %NotDel%),0) ZN_PAUSA,
				MIN(SZN.D_E_L_E_T_) DELET,
		        PAUSA1,
		        QTDE1,
		        PAUSA2,
		        QTDE2,
		        PAUSA3,
		        QTDE3,
		        PAUSA4,
		        QTDE4,
		        PAUSA5,
		        QTDE5,
		        PAUSA6,
		        QTDE6
				FROM
					%Table:SZN% SZN 
					INNER JOIN %Table:SU0% SU0 ON
													ZN_FILIAL = %XFilial:SZN% AND
													U0_FILIAL = %XFilial:SU0% AND
													ZN_GRUPO = U0_CODIGO AND
													SU0.%NotDel% 
					INNER JOIN %Table:SU7% SU7 ON
													U7_FILIAL = %XFilial:SU7% AND
													U7_COD = ZN_CODOP AND
													SU7.%NotDel%
		     		LEFT JOIN PAUSAS ON ZK_OPERADO = U7_COD
				WHERE
					SUBSTR(ZN_PIN,1,8)= %Exp:DtoC(Date())% AND
					ZN_GRUPO = %Exp:cGrpProc%
				GROUP BY
						ZN_GRUPO,
						ZN_CODOP,
						U0_NOME,
						U7_COD,
						U7_NOME,
						U7_XJCHAT,
						PAUSA1,
						QTDE1,
						PAUSA2,
						QTDE2,
						PAUSA3,
						QTDE3,
						PAUSA4,
						QTDE4,
						PAUSA5,
						QTDE5,
						PAUSA6,
						QTDE6
				ORDER BY
					  ZN_GRUPO,
					  U7_NOME,
					  ZN_PIN,
					  ZN_LOGOUT

		EndSql

		cCtdArq := '{'
		cCtdArq += '"data": [ '

		cCtdArq1 := '{'
		cCtdArq1 += '"data": [ '

		While !CHAT2->(Eof())

			If Empty(DELET)
				cCtdArq += '{ "operador": "'+SubStr(Alltrim(CHAT2->U7_NOME),1,18)+'",'
		 		cCtdArq += '"entrada": "'+DtoC(CtoD(SubStr(CHAT2->ZN_PIN,1,8)))+" "+SubStr(CHAT2->ZN_PIN,9)+'",'
		 		cCtdArq += '"disponivel": "'+Alltrim(Str(CHAT2->ZN_DISP))+'",' 
		 		
		 		//Renato Ruy - 18/11/16
		 		//Dados de pausa e atendimento
		 		cCtdArq += '"realizado": "'+Alltrim(Str(CHAT2->ATENDIMENTO))+'",'
		 		
		 		cCtdArq += '"pausa1": "'+CTSDK23F(CHAT2->PAUSA1)+'",'
		 		cCtdArq += '"quantpausa1": "'+Alltrim(Str(CHAT2->QTDE1))+'",'
		 		
				cCtdArq += '"pausa2": "'+CTSDK23F(CHAT2->PAUSA2)+'",'
		 		cCtdArq += '"quantpausa2": "'+Alltrim(Str(CHAT2->QTDE2))+'",'
		 		
		 		cCtdArq += '"pausa3": "'+CTSDK23F(CHAT2->PAUSA3)+'",'
		 		cCtdArq += '"quantpausa3": "'+Alltrim(Str(CHAT2->QTDE3))+'",'
		 		
		 		cCtdArq += '"pausa4": "'+CTSDK23F(CHAT2->PAUSA4)+'",'
		 		cCtdArq += '"quantpausa4": "'+Alltrim(Str(CHAT2->QTDE4))+'",'
		 		
		 		cCtdArq += '"pausa5": "'+CTSDK23F(CHAT2->PAUSA5)+'",'
		 		cCtdArq += '"quantpausa5": "'+Alltrim(Str(CHAT2->QTDE5))+'",'
		 		
		 		cCtdArq += '"pausa6": "'+CTSDK23F(CHAT2->PAUSA6)+'",'
		 		cCtdArq += '"quantpausa6": "'+Alltrim(Str(CHAT2->QTDE6))+'",'
		 		
		 		If CHAT2->ZN_PAUSA <> '0'
		 			cCtdArq += '"pausa": "'+"<img src='img/br_vermelho.png'>"+'"},'
		 		ElseIf Val(CHAT2->U7_XJCHAT) <> CHAT2->ZN_DISP
		 			cCtdArq += '"pausa": "'+"<img src='img/br_amarelo.png'>"+'"},'
		 		Else
		 			cCtdArq += '"pausa": "'+"<img src='img/br_verde.png'>"+'"},'
		 		EndIf
		 		
		 	Else
		 		cCtdArq1 += '{ "operador": "'+Alltrim(CHAT2->U7_NOME)+'",'
		 		cCtdArq1 += '"entrada": "'+DtoC(CtoD(SubStr(CHAT2->ZN_PIN,1,8)))+" "+SubStr(CHAT2->ZN_PIN,9)+'",'
		 		cCtdArq1 += '"saida": "'+DtoC(CtoD(SubStr(CHAT2->ZN_LOGOUT,1,8)))+" "+SubStr(CHAT2->ZN_LOGOUT,9)+'",'
		 		
		 		//Renato Ruy - 18/11/16
		 		//Dados de pausa e atendimento
		 		cCtdArq1 += '"realizado": "'+Alltrim(Str(CHAT2->ATENDIMENTO))+'",'
		 		
		 		cCtdArq1 += '"pausa1": "'+CTSDK23F(CHAT2->PAUSA1)+'",'
		 		cCtdArq1 += '"quantpausa1": "'+Alltrim(Str(CHAT2->QTDE1))+'",'
		 		
				cCtdArq1 += '"pausa2": "'+CTSDK23F(CHAT2->PAUSA2)+'",'
		 		cCtdArq1 += '"quantpausa2": "'+Alltrim(Str(CHAT2->QTDE2))+'",'
		 		
		 		cCtdArq1 += '"pausa3": "'+CTSDK23F(CHAT2->PAUSA3)+'",'
		 		cCtdArq1 += '"quantpausa3": "'+Alltrim(Str(CHAT2->QTDE3))+'",'
		 		
		 		cCtdArq1 += '"pausa4": "'+CTSDK23F(CHAT2->PAUSA4)+'",'
		 		cCtdArq1 += '"quantpausa4": "'+Alltrim(Str(CHAT2->QTDE4))+'",'
		 		
		 		cCtdArq1 += '"pausa5": "'+CTSDK23F(CHAT2->PAUSA5)+'",'
		 		cCtdArq1 += '"quantpausa5": "'+Alltrim(Str(CHAT2->QTDE5))+'",'
		 		
		 		cCtdArq1 += '"pausa6": "'+CTSDK23F(CHAT2->PAUSA6)+'",'
		 		cCtdArq1 += '"quantpausa6": "'+Alltrim(Str(CHAT2->QTDE6))+'"},'
		 	EndIf

		 	CHAT2->(DbSkip())

		EndDo

		cCtdArq := SubStr(cCtdArq,1,Len(cCtdArq)-1)
		cCtdArq += ']'
		cCtdArq += '}'

		cCtdArq1 := SubStr(cCtdArq1,1,Len(cCtdArq1)-1)
		cCtdArq1 += ']'
		cCtdArq1 += '}'

		CHAT2->(DbCloseArea())

		MemoWrite("\chatmonitor\data\"+cGrpProc+"\online.txt",cCtdArq)

		MemoWrite("\chatmonitor\data\"+cGrpProc+"\offline.txt",cCtdArq1)

		BeginSql Alias "CHAT3"

			SELECT
			  A.GROUPID GRUPO,
			  SU0.U0_NOME NOME,
			  B.NAME TIPO,
			  COUNT(*) QTD
			FROM
			  WEBCHAT.CHAT_HISTORY A INNER JOIN WEBCHAT.CHAT_EVENT_TYPE B ON
			    A.EXIT_EVENT = B.EVENT INNER JOIN %Table:SU0% SU0 ON
			      SU0.U0_FILIAL = %XFilial:SU0% AND
			      A.GROUPID = U0_CODIGO AND
			      SU0.D_E_L_E_T_ = ' '
			WHERE
			  DAY = TO_DATE(%Exp:DtoS(Date())%, 'YYYYMMDD') AND
			  U0_CODIGO = %Exp:cGrpProc%
			GROUP BY
			  A.GROUPID,
			  SU0.U0_NOME,
			  B.NAME
		EndSql

		cCtdArq := '{'
		cCtdArq += '"data": [ '

		CHAT3->( DbEval( {|| 	cCtdArq +=	 '{ "tipo": "'+Alltrim(CHAT3->TIPO)+'",',;
								cCtdArq +=	 '"quantidade": '+Alltrim(Str(CHAT3->QTD))+'},' } ) )

		cCtdArq := SubStr(cCtdArq,1,Len(cCtdArq)-1)
		cCtdArq += ']'
		cCtdArq += '}'

		CHAT3->(DbCloseArea())

		MemoWrite("\chatmonitor\data\"+cGrpProc+"\encerramento.txt",cCtdArq)

		BeginSql Alias "CHAT4"
			SELECT GROUPID GRUPO,
		       U0_NOME NOME,
		       COUNT(*) QTD_CONV,
		       TO_CHAR(TO_DATE('01/01/2013 00:00:00','DD/MM/YYYY HH24:MI:SS') + MIN(STOP_Q-START_Q),'HH24:MI:SS') MENOR_FILA,
		       TO_CHAR(TO_DATE('01/01/2013 00:00:00','DD/MM/YYYY HH24:MI:SS') + MAX(STOP_Q-START_Q),'HH24:MI:SS') MAIOR_FILA,
		       TO_CHAR(TO_DATE('01/01/2013 00:00:00','DD/MM/YYYY HH24:MI:SS') + MIN(STOP_C-START_C),'HH24:MI:SS') MENOR_CONV,
		       TO_CHAR(TO_DATE('01/01/2013 00:00:00','DD/MM/YYYY HH24:MI:SS') + MAX(STOP_C-START_C),'HH24:MI:SS') MAIOR_CONV,
		       TO_CHAR(TO_DATE('01/01/2013 00:00:00','DD/MM/YYYY HH24:MI:SS') + (AVG(24*60*60*(STOP_Q_ANBAND-START_Q_ANBAND)))/(24*60*60),'HH24:MI:SS') MEDIA_ABAN,
   			   TO_CHAR(TO_DATE('01/01/2013 00:00:00','DD/MM/YYYY HH24:MI:SS') + (AVG(24*60*60*(STOP_Q_ATEND-START_Q_ATEND)))/(24*60*60),'HH24:MI:SS') MEDIA_ATEN,
		       TO_CHAR(TO_DATE('01/01/2013 00:00:00','DD/MM/YYYY HH24:MI:SS') + (AVG(24*60*60*(STOP_Q-START_Q)))/(24*60*60),'HH24:MI:SS') MEDIA_FILA,
		       TO_CHAR(TO_DATE('01/01/2013 00:00:00','DD/MM/YYYY HH24:MI:SS') + (AVG(24*60*60*(STOP_C-START_C)))/(24*60*60),'HH24:MI:SS') MEDIA_CONV
			FROM
			  ( SELECT GROUPID,
			          TO_DATE(TO_CHAR(STOP_Q,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') STOP_Q,
			          TO_DATE(TO_CHAR(START_Q,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') START_Q,
			          TO_DATE(TO_CHAR(STOP_C,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') STOP_C,
			          TO_DATE(TO_CHAR(START_C,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') START_C,
				      CASE
				        WHEN START_C IS NULL THEN TO_DATE(TO_CHAR(START_Q,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS')
				        ELSE NULL
				      END START_Q_ANBAND,
				      CASE
				        WHEN START_C IS NULL THEN TO_DATE(TO_CHAR(STOP_Q,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS')
				        ELSE NULL
				      END STOP_Q_ANBAND,
				      CASE
				        WHEN START_C IS NOT NULL THEN TO_DATE(TO_CHAR(START_Q,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS')
				        ELSE NULL
				      END START_Q_ATEND,
				      CASE
				        WHEN START_C IS NOT NULL THEN TO_DATE(TO_CHAR(STOP_Q,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS')
				        ELSE NULL
				      END STOP_Q_ATEND
			   FROM WEBCHAT.CHAT_HISTORY
			   WHERE DAY = TO_DATE(%Exp:DtoS(Date())%, 'YYYYMMDD') ) X
				INNER JOIN SU0010 SU0 ON U0_FILIAL = %XFilial:SU0%
				AND U0_CODIGO = GROUPID
				AND SU0.%NotDel%
			WHERE
				U0_CODIGO = %Exp:cGrpProc%
			GROUP BY GROUPID,
			         U0_NOME
		EndSql

		cCtdArq := '{'
		cCtdArq += '"data": [ '

		CHAT4->( DbEval( {|| 	cCtdArq +=	 '{ "tmpfila": "'+Alltrim(CHAT4->MEDIA_FILA)+'",',;
								cCtdArq +=	 '"tmpaband": "'+Alltrim(CHAT4->MEDIA_ABAN)+'",',;
								cCtdArq +=	 '"tmpatend": "'+Alltrim(CHAT4->MEDIA_ATEN)+'"},' } ) )

		cCtdArq := SubStr(cCtdArq,1,Len(cCtdArq)-1)
		cCtdArq += ']'
		cCtdArq += '}'

		CHAT4->(DbCloseArea())

		MemoWrite("\chatmonitor\data\"+cGrpProc+"\tmpatend.txt",cCtdArq)
		
		BeginSql Alias "CHAT5" 
			SELECT
			   U7_COD,
			   U7_NOME,
			   MAX(INICIADAS) INICIADAS 
			FROM
			    %Table:SZN% SZN   
			INNER JOIN
			    %Table:SU7% SU7         
			      ON U7_FILIAL =  %XFilial:SU7%          
			      AND U7_COD = ZN_CODOP         
			      AND SU7.%NotDel%  
			LEFT JOIN
			   (
			      SELECT
			         ZK_OPERADO,
			         COUNT(*) INICIADAS   
			      FROM
			         %Table:SZK% SZK  
			      WHERE
			         ZK_FILIAL = %XFilial:SZK%   
			         AND  ZK_DTINI = %Exp:DtoS(Date())%  
			         AND  SZK.%NotDel%    
			      GROUP BY
			         ZK_OPERADO  
			   ) 
			      ON ZK_OPERADO = U7_COD  
			WHERE
			   SUBSTR(ZN_PIN,1,8)=  %Exp:DtoC(Date())%      
			   AND ZN_GRUPO =  %Exp:cGrpProc%   
			GROUP BY
			   U7_COD,
			   U7_NOME
		EndSql
		
		cCtdArq := '{'
		cCtdArq += '"data": [ '

		CHAT5->( DbEval( {|| 	cCtdArq +=	 '{ "operador": "'+Alltrim(CHAT5->U7_NOME)+'",',;
								cCtdArq +=	 '"pausas": "'+Alltrim(STR(CHAT5->INICIADAS))+'"},' } ) )

		cCtdArq := SubStr(cCtdArq,1,Len(cCtdArq)-1)
		cCtdArq += ']'
		cCtdArq += '}'

		CHAT5->(DbCloseArea())

		MemoWrite("\chatmonitor\data\"+cGrpProc+"\operpausa.txt",cCtdArq)

		BeginSql Alias "CHAT6" 
			SELECT
			   U7_COD,
			   U7_NOME,
			   ZK_HRINI,
			   ZK_HRFIM,
			   ZK_TPPSA
			FROM
			    %Table:SZN% SZN   
			INNER JOIN
			   %Table:SU7% SU7         
			      ON U7_FILIAL =  %XFilial:SU7%          
			      AND U7_COD = ZN_CODOP         
			      AND SU7.%NotDel%  
			INNER JOIN 
				%Table:SZK% SZK
			      ON ZK_FILIAL = %XFilial:SZK%   
			         AND ZK_OPERADO = U7_COD
			         AND ZK_DTINI = %Exp:DtoS(Date())%  
			         AND SZK.%NotDel%    
			WHERE
			   SUBSTR(ZN_PIN,1,8)=  %Exp:DtoC(Date())%      
			   AND ZN_GRUPO =  %Exp:cGrpProc% 
			GROUP BY
			   U7_COD,
			   U7_NOME,
			   ZK_HRINI,
			   ZK_HRFIM,
			   ZK_TPPSA
			ORDER BY
			  U7_COD,
			  U7_NOME,
			  ZK_HRINI,
			  ZK_HRFIM
		EndSql
		
		cCtdArq := '{'
		cCtdArq += '"data": [ '

		CHAT6->( DbEval( {|| 	cCtdArq += '{ "operador": "'+Alltrim(CHAT6->U7_NOME)+'",',;
								cCtdArq += '"hrini": "'+CHAT6->ZK_HRINI+'",',;
								cCtdArq += '"hrfim": "'+CHAT6->ZK_HRFIM+'",',;
								cCtdArq += IIf( !Empty(CHAT6->ZK_HRFIM), '"tmppausa": "'+SubStr(ElapTime(CHAT6->ZK_HRINI+":00",CHAT6->ZK_HRFIM+":00"),1,5)+'",','"tmppausa": "'+SubStr(ElapTime(CHAT6->ZK_HRINI+":00",Time()),1,5)+'",'),;
								cCtdArq +=	 '"motivo": "'+Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z0"+CHAT6->ZK_TPPSA, "X5_DESCRI"))+'"},' } ) )

		cCtdArq := SubStr(cCtdArq,1,Len(cCtdArq)-1)
		cCtdArq += ']'
		cCtdArq += '}'

		CHAT6->(DbCloseArea())

		MemoWrite("\chatmonitor\data\"+cGrpProc+"\motpausa.txt",cCtdArq)
		
		// Renato Ruy - 05/12/2016
		// Retorna interacoes dos operadores
		BeginSql Alias "CHAT7" 
			
			%NoParser%
		
			WITH TEMPOS AS
			(SELECT ZM_CODOP OPERADOR, MIN(TEMPO) TEMPO FROM
			(SELECT  ZM_CODOP,
			SUBSTR(TO_CHAR(cast(sysdate as timestamp) - 
			TO_TIMESTAMP(SUBSTR(ADE_DATA,7,2)||'/'||SUBSTR(ADE_DATA,5,2)||'/'||SUBSTR(ADE_DATA,1,4)||'/'||' '|| ADE_HORA,'dd/mm/RRRR hh24:mi:ss')),12,8) TEMPO,
			ZM_STATUS
			FROM %Table:SZM% SZM
			JOIN %Table:ADE% ADE ON ADE_FILIAL = '02' AND ADE_CODIGO = ZM_PROTOCO AND ADE.D_E_L_E_T_ = ' '
			WHERE
			ZM_FILIAL = ' ' AND
			SUBSTR(ZM_PIN,1,8) = %Exp:DtoC(Date())%  AND
			ZM_GRUPO = %Exp:cGrpProc%
			ORDER BY ZM_CODOP)
			GROUP BY ZM_CODOP),
			
			PAUSAS AS
			(SELECT ZK_OPERADO OPER, trim(ZK_TPPSA) MOTPAUSA, SUBSTR(TO_CHAR(cast(sysdate as timestamp) - 
			TO_TIMESTAMP(SUBSTR(ZK_DTINI,7,2)||'/'||SUBSTR(ZK_DTINI,5,2)||'/'||SUBSTR(ZK_DTINI,1,4)||'/'||' '|| ZK_HRINI,'dd/mm/RRRR hh24:mi:ss')),12,8) PAUSA FROM %Table:SZK%
			WHERE
			ZK_FILIAL = ' ' AND
			ZK_DTINI = %Exp:DtoS(Date())%  AND
			ZK_DTFIM = ' ' AND
			D_E_L_E_T_ = ' ')
			
			SELECT  U7_NOME, 
			        U0_NOME, 
			        'LOGADO' STATUS, 
			        U7_XJCHAT - ZN_DISP ATEND, 
			        ZN_DISP, 
			        U7_XJCHAT,
			        CASE WHEN U7_XJCHAT > ZN_DISP THEN  TEMPO ELSE '00:00:00' END ATIVO,
			        CASE WHEN U7_XJCHAT = ZN_DISP THEN  TEMPO ELSE '00:00:00' END INATIVO,
			        Nvl(PAUSA,'00:00:00') PAUSA,
			        DECODE(MOTPAUSA,'001','PAUSA 10',
			                        '002','Feedback',
			                        '003','Almoco',
			                        '005','Particular',
			                        '006','Reuniao',
			                        'Ativo') MOTIVO
			FROM %Table:SZN% SZN
			JOIN %Table:SU7% SU7 ON U7_FILIAL = ' ' AND U7_COD = ZN_CODOP AND SU7.D_E_L_E_T_ = ' '
			JOIN %Table:SU0% SU0 ON U0_FILIAL = ' ' AND U0_CODIGO = ZN_GRUPO AND SZN.D_E_L_E_T_ = ' '
			LEFT JOIN TEMPOS ON OPERADOR = ZN_CODOP
			LEFT JOIN PAUSAS ON OPER = ZN_CODOP
			WHERE
			ZN_FILIAL = ' ' AND
			SUBSTR(ZN_PIN,1,8) = %Exp:DtoC(Date())% AND
			ZN_GRUPO = %Exp:cGrpProc% AND
			SZN.D_E_L_E_T_ = ' '
		Endsql
		
		cCtdArq := '{'
		cCtdArq += '"data": [ '
		
		While !CHAT7->(Eof())

			cCtdArq += '{ "operador": "'	+Alltrim(CHAT7->U7_NOME)+'",'
	 		cCtdArq += '"grupo": "'			+Alltrim(CHAT7->U0_NOME)+'",'
	 		cCtdArq += '"status": "'		+CHAT7->STATUS+'",' 
	 		cCtdArq += '"atendimento": "'	+AllTrim(Str(CHAT7->ATEND))+'",' 
	 		cCtdArq += '"disponivel": "'	+AllTrim(Str(CHAT7->ZN_DISP))+'",' 
	 		cCtdArq += '"janelas": "'  		+CHAT7->U7_XJCHAT+'",' 
	 		cCtdArq += '"ativo": "'  		+CHAT7->ATIVO+'",' 
	 		cCtdArq += '"inativo": "'  		+CHAT7->INATIVO+'",' 
	 		cCtdArq += '"tempo": "'  		+CHAT7->PAUSA+'",' 
	 		cCtdArq += '"pausa": "'  		+CHAT7->MOTIVO+'"},' 

		 	CHAT7->(DbSkip())

		EndDo

		cCtdArq := SubStr(cCtdArq,1,Len(cCtdArq)-1)
		cCtdArq += ']'
		cCtdArq += '}'
		
		CHAT7->(DbCloseArea())
		
		MemoWrite("\chatmonitor\data\"+cGrpProc+"\operador.txt",cCtdArq)
		
		//Renato Ruy - 12/12/16
		//Controle de qualidade no atendimento
		BeginSql Alias "CHAT8" 
			
			%NoParser%
			
			SELECT  ENTRADA_FILA,
			        SUM(FILA_20Q) FILA_20Q,
			        SUM(FILA_MAIS20Q) FILA_MAIS20Q,
			        SUM(CONVERSA_ATE20C) CONVERSA_ATE20C,
			        SUM(CONVERSA_MAIS20C) CONVERSA_MAIS20C,
			        ROUND(AVG(TEMPO_FILA),0) TEMPO_FILA,
			        ROUND(AVG(TEMPO_CONVERSA),0) TEMPO_CONVERSA
			FROM
			(SELECT  ENTRADA_FILA,
			        to_number(SubStr(TEMPO_FILA,1,2))*3600+to_number(SubStr(TEMPO_FILA,4,2))*60+to_number(SubStr(TEMPO_FILA,7,2)) TEMPO_FILA,
			        to_number(SubStr(TEMPO_CONVERSA,1,2))*3600+to_number(SubStr(TEMPO_CONVERSA,4,2))*60+to_number(SubStr(TEMPO_CONVERSA,7,2)) TEMPO_CONVERSA,
			        FILA_20Q,
			        FILA_MAIS20Q,
			        CONVERSA_ATE20C,
			        CONVERSA_MAIS20C
			FROM
			(SELECT SUBSTR(TO_CHAR(START_Q,'hh24:mi:ss'),1,2) ENTRADA_FILA, 
			        NVL(SubStr(TO_CHAR((STOP_Q - START_Q),'hh:mi:ss'),12,8),'00:00:00') TEMPO_FILA, 
			        NVL(SubStr(TO_CHAR((STOP_C - START_C),'hh:mi:ss'),12,8),'00:00:00') TEMPO_CONVERSA,
			        CASE WHEN SUBSTR(STOP_Q - START_Q,12,8) <= '00:00:20' THEN 1 ELSE 0 END FILA_20Q,
			        CASE WHEN SUBSTR(STOP_Q - START_Q,12,8) > '00:00:20' THEN 1 ELSE 0 END FILA_MAIS20Q,
			        CASE WHEN SUBSTR(STOP_C - START_C,12,8) <= '00:00:20' THEN 1 ELSE 0 END CONVERSA_ATE20C,
			        CASE WHEN SUBSTR(STOP_C - START_C,12,8) > '00:00:20' THEN 1 ELSE 0 END CONVERSA_MAIS20C
			        
			FROM WEBCHAT.chat_history CHAT
			WHERE
			GROUPID = %Exp:cGrpProc% AND
			DAY = TO_DATE(%Exp:DtoS(Date())%, 'YYYYMMDD') 
			//DAY >= TO_DATE('20160709', 'YYYYMMDD') 
			
			ORDER BY ENTRADA_FILA))
			WHERE ENTRADA_FILA > ' '
			GROUP BY ENTRADA_FILA
			ORDER BY ENTRADA_FILA
			
		Endsql
		
		cCtdArq := '{'
		cCtdArq += '"data": [ '
		
		While !CHAT8->(Eof())

			cCtdArq += '{ "horario": "'	+AllTrim(CHAT8->ENTRADA_FILA)+'",'
	 		cCtdArq += '"fila1": "'		+AllTrim(Transform(CHAT8->FILA_20Q,"@E 999,999"))+'",'
	 		cCtdArq += '"fila2": "'		+AllTrim(Transform(CHAT8->FILA_MAIS20Q,"@E 999,999"))+'",'
	 		cCtdArq += '"conversa1": "'	+AllTrim(Transform(CHAT8->CONVERSA_ATE20C,"@E 999,999"))+'",'
	 		cCtdArq += '"conversa2": "'	+AllTrim(Transform(CHAT8->CONVERSA_MAIS20C,"@E 999,999"))+'",'
	 		cCtdArq += '"total": "'		+AllTrim(Transform(CHAT8->CONVERSA_ATE20C+CHAT8->CONVERSA_MAIS20C,"@E 999,999"))+'",'
	 		cCtdArq += '"servico": "'	+AllTrim(Str(ROUND((CHAT8->FILA_20Q/(CHAT8->FILA_20Q+CHAT8->FILA_MAIS20Q))*100,0)))+"%"+'",'
	 		cCtdArq += '"mediafila": "'	+"00:"+CTSDK23F(CHAT8->TEMPO_FILA)+'",'
	 		cCtdArq += '"mediaconv": "'	+"00:"+CTSDK23F(CHAT8->TEMPO_CONVERSA)+'"},' 

		 	CHAT8->(DbSkip())

		EndDo

		cCtdArq := SubStr(cCtdArq,1,Len(cCtdArq)-1)
		cCtdArq += ']'
		cCtdArq += '}'
		
		CHAT8->(DbCloseArea())
		
		MemoWrite("\chatmonitor\data\"+cGrpProc+"\qualidade.txt",cCtdArq)
		
	Next

Return(nil)

//Renato Ruy - 24/11/16
//Formata a hora das pausas
Static Function CTSDK23F(nHora)

Local cHoraRet := ""
Local cHoraFmt := ""

default nHora := 0  

cHoraFmt := StrTran(PadL(AllTrim(transform(nHora / 60,"@E 99.99")),5,"0"),",",":")

cHoraRet := SubStr(cHoraFmt,1,3)
cHoraRet += StrZero(Val(SubStr(cHoraFmt,4,2))*0.6,2)

Return cHoraRet