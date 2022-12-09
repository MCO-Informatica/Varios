#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA039  º Autor ³ Renato Ruy Bernardo  º Data ³ 13/07/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Job tratamento da Base de Dados						      º±±
±±º          ³ 1 - Importa o Cadastro de Postos						      º±±
±±º          ³ 2 - Verifica as validacoes para gravar o posto correto.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function CRPA039(cEmpP,cFilP)

Local   cData 	:= ""
Local   cPosto	:= ""
Local   cDescVal:= ""
Local   cDescVer:= ""
Local   nDiv	:= ""
Local	nX		:= 0
Local	nI		:= 0

Default cEmpP := "01"
Default cFilP := "02"

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv(cEmpP,cFilP)

ConOut("CRPA039 - "+DtoC(dDatabase)+" - "+Time()+" - Iniciou Programa de Importacao de Postos")

//Tratamento posto diario
ConOut("CRPA039 - Importa dados dos postos")
SZ3->(DbSetOrder(6)) //Filial + Tipo Entidade
SZ3->(DbSeek(xFilial("SZ3")+"4"))
While !SZ3->(EOF()) .And.  SZ3->Z3_TIPENT == "4"
	If !Empty(SZ3->Z3_CODGAR)
		StaticCall(CRPA020,CRPA020Q,SZ3->Z3_CODGAR,.F.)
	Endif
	SZ3->(DbSkip())
Enddo

//Tratamento para problemas de revalicao
ConOut("CRPA039 - Importa dados das notificacoes de validacao")
cData := DtoS(dDataBase-1)

//Busca na GTIN as validacoes do dia anterior
Beginsql Alias "TMPREV"
	SELECT GT_PEDGAR PEDGAR FROM GTIN GT
	WHERE
	GT_TYPE = 'E' AND
	UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM, 2000,1)) LIKE '%GETVLDGAR%' AND
	GT_DATE >= %EXP:CDATA%
	GROUP BY GT_PEDGAR
Endsql

While !TMPREV->(EOF())
	
	//busco posto que efetuou a ultima validacao antes da data de verificacao.
	Beginsql Alias "TMPPED"
		SELECT GT_DATE||GT_TIME DATAHORA, UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM, 2000,1)) TXTXML FROM GTIN GT
		WHERE
		GT_DATE <= (SELECT MIN(GT_DATE) FROM GTIN
		                     WHERE
		                     GT_PEDGAR = %EXP:TMPREV->PEDGAR% AND
		                     UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM, 2000,1)) LIKE '%GETVERGAR%' AND
		                     GT_TYPE = 'E') AND
		GT_PEDGAR = %EXP:TMPREV->PEDGAR% AND
		UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM, 2000,1)) LIKE '%GETVLDGAR%' AND
		GT_TYPE = 'E'
		ORDER BY GT_DATE||GT_TIME DESC
	Endsql
	
	If !Empty(TMPPED->TXTXML)
		
		//Busca o codigo do posto no XML
		cPosto := Substr(TMPPED->TXTXML,at("<Z5CODPOS>",TMPPED->TXTXML)+10,at("</Z5CODPOS>",TMPPED->TXTXML)-(at("<Z5CODPOS>",TMPPED->TXTXML)+10))
		
		SZ5->(DbSetOrder(1)) // Filial + Pedido
		//caso esteja posicionado na SZ5 e o codigo do posto seja diferente, grava e desmarca para recalcular o pedido.
		If SZ5->(DbSeek(xFilial("SZ5")+TMPREV->PEDGAR)) .And. cPosto <> AllTrim(SZ5->Z5_CODPOS)
			If Reclock("SZ5",.F.)
				SZ5->Z5_CODPOS := cPosto
				SZ5->Z5_COMISS := ""
				SZ5->(MsUnlock())
			Endif
		Endif
	Endif
	
	TMPPED->(DbCloseArea())
	TMPREV->(DbSkip())
Enddo

//Renato Ruy - 21/07/2017
//Ajustar os postos dos pedidos de renovacao
ConOut("CRPA039 - Importa dados da trilha de auditoria")
Beginsql Alias "TMPRRN"
	SELECT 	Z5_PEDGAR PEDGAR, 
			Z5_CODPOS CODPOS,
			Z5_PEDGANT PEDANT, 
			R_E_C_N_O_ RECNOZ5 
	FROM %TABLE:SZ5%
	WHERE
	Z5_FILIAL = %XFILIAL:SZ5% AND
	Z5_DATEMIS >= %EXP:CDATA% AND
	Z5_PEDGANT > ' ' AND
	%NOTDEL%

Endsql

While !TMPRRN->(EOF())
    
	cDescVal := ""
	cDescVer := ""
	nDiv	 := 0
	
	oWSObj := WSIntegracaoGARERPImplService():New()
	IF oWSObj:listarTrilhasDeAuditoriaParaIdPedido("erp","password123",Val(TMPRRN->PEDANT))

		//Ação
		//RRG - VALIDAR
		//REM - VERIFICAR
		//EMI - EMISSAO
		//RVD - REVALIDAR

	    //Analiso todas as linhas da trilha e gravo.
		For nX := 1 to Len(oWSObj:oWSauditoriaInfo)


			If ValType(oWSObj:oWSauditoriaInfo[nX]:cacao) <> "U"

				//Armazeno a descricao do posto de validacao ate que tenha uma aprovacao
				If AllTrim(oWSObj:oWSauditoriaInfo[nX]:cacao) == "RRG"
					//Renato Ruy - 24/07/2017
					//Solicitante: Valquiria Oliveira
					//Não atualizar o posto caso seja da Central de Verificação.
					If !("CENTRAL DE VERIFICACAO" $ Upper(oWSObj:OWSAUDITORIAINFO[nX]:cposto))
						cDescVal := oWSObj:OWSAUDITORIAINFO[nX]:cposto
					Endif
				ElseIf AllTrim(oWSObj:oWSauditoriaInfo[nX]:cacao) == "REM"
					cDescVer := oWSObj:OWSAUDITORIAINFO[nX]:cposto
				EndIf

				//Se eu ja tenho a informacao necessaria, finalizo loop.
				If !Empty(cDescVer)
					nX := Len(oWSObj:oWSauditoriaInfo)
				EndIf
			EndIf

		Next
		
		//Busco a ultima posicao que tem a divisão
		//Para obter a descricao correta do posto no gar
		//Isto porque o conteudo apresentado e a Descricao + Cidade
		For nI := 1 To Len(cDescVal)
			If Substr(cDescVal,nI,1) == "-"
				nDiv := nI
			Endif
		Next
		
		//Armazena o conteudo sem o nome da cidade
		cDescVal := Substr(cDescVal,1,nDiv-2)
		
		SZ3->(DbSetOrder(7))
		If SZ3->(DbSeek(xFilial("SZ3")+"4"+cDescVal))
			
			//Se o codigo do posto esta incorreto, grava o correto
			If TMPRRN->CODPOS != SZ3->Z3_CODGAR
				SZ5->(DbGoTo(TMPRRN->RECNOZ5))
				Reclock("SZ5",.F.)
					SZ5->Z5_CODPOS := SZ3->Z3_CODGAR
					SZ5->Z5_COMISS := " "
				SZ5->(MsUnlock())
			Endif
		
		Endif
		
	Endif
	TMPRRN->(DbSkip())
Enddo

ConOut("CRPA039 - "+DtoC(dDatabase)+" - "+Time()+" - Finalizou o Programa de Importacao de Postos")
TMPRRN->(DbCloseArea())
TMPREV->(DbCloseArea())
Return