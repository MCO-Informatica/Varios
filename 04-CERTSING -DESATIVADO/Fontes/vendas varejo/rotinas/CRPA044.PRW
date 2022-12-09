#Include "totvs.ch"

//Renato Ruy - 03/10/2017
//Manipula os dados do aCols de títulos a pagar
//Gera Fatura para IT's

Static lOk		:= .T.
Static nXParc	:= 0
Static aFatura	:= {}

User Function MTCOLSE2

Local aLinha := aClone(ParamIXB[1][1])
Local aSE2	 := {}
Local cPedido:= ""
Local nCusto := AScan( aHeader, {|e| AllTrim(e[2])=="D1_CC" 	})
Local nPedido:= AScan( aHeader, {|e| AllTrim(e[2])=="D1_PEDIDO" })

//Renato Ruy - 20/12/2017
//Gera data de vencimento para o WF.
U_CSFA780D(aLinha[2]) 

//Somente Continua na rotina se o Centro de Custos Pertence a remuneracao
If nCusto == 0 .Or. GetNewPar("MV_XREMIT", "2") == "2" // 1- Gera ou 2-Não gera
	Return ParamIXB[1]
ElseIf RTrim(aCols[1,nCusto]) <> "80000000"
	Return ParamIXB[1]
Endif

//Busca o Pedido na base de Fechamento de Remuneracao
cPedido := aCols[1,nPedido]
lOk		:= .T.
nXParc	:= 0
aFatura	:= {}

//Busca dados adicionais do pedido
Beginsql Alias "TMPZZ6"
	SELECT  ZZ6_CODENT,
	        ZZ6_DESENT,
	        ZZ6_PERIOD,
	        ZZ6_COMTOT,
	        ZZ6_VALAR,
	        ZZ6_VALCAM
	FROM %TABLE:ZZ6%
	WHERE
	ZZ6_FILIAL = ' ' AND
	(ZZ6_PEDIDO = %Exp:cPedido% OR
	 ZZ6_PEDID2 = %Exp:cPedido% OR
	 ZZ6_PEDID3 = %Exp:cPedido%) AND
	%NOTDEL%
Endsql

//Se nao encontrar o pedido na base de remuneracao, retorna o padrao
If Empty(TMPZZ6->ZZ6_CODENT)
	TMPZZ6->(DbCloseArea())
	Return ParamIXB[1]
Else 
	Beginsql Alias "TMPSZ3"
		SELECT  COUNT(*) CONTAGEM
		FROM %TABLE:SZ3%
		WHERE
		Z3_FILIAL = ' ' AND
		Z3_CODCCR = %Exp:TMPZZ6->ZZ6_CODENT% AND
		Z3_QUEBRA = '2' AND
		%NOTDEL%
	Endsql
	
	//Se não tem quebra mantém os dados atuais
	If TMPSZ3->CONTAGEM == 0
		TMPZZ6->(DbCloseArea())
		TMPSZ3->(DbCloseArea())
		Return ParamIXB[1]
	Endif
	
Endif

//Busca dados para geracao de remuneracao das IT's
Beginsql Alias "TMPFAT"
	SELECT CODENT, DESENT, TIPENT, CODFOR, SUM(Z6_VALCOM) COMISSAO FROM
	(SELECT '0' Z6_PEDGAR,
          %Exp:TMPZZ6->ZZ6_CODENT% CODENT,
          (SELECT Z3_DESENT FROM SZ3010 WHERE Z3_FILIAL = ' ' AND Z3_CODENT = %Exp:TMPZZ6->ZZ6_CODENT% AND D_E_L_E_T_ = ' ')       DESENT,
          '9'       TIPENT,
          (SELECT Z3_CODFOR FROM SZ3010 WHERE Z3_FILIAL = ' ' AND Z3_CODENT = %Exp:TMPZZ6->ZZ6_CODENT% AND D_E_L_E_T_ = ' ')       CODFOR,
          0 Z6_VALCOM
     FROM DUAL
	 UNION ALL
	 SELECT Z6_PEDGAR, 
			CASE 
			WHEN SZ3.Z3_QUEBRA = '2' AND SZ3.Z3_GRUPOIT > '0' THEN SZ3.Z3_GRUPOIT 
			WHEN SZ3.Z3_QUEBRA = '2' AND SZ3.Z3_GRUPOIT = ' ' THEN SZ3.Z3_CODENT 
			ELSE SZ32.Z3_CODENT 
			END CODENT,
			CASE 
			WHEN SZ3.Z3_QUEBRA = '2' AND SZ3.Z3_GRUPOIT > '0' THEN SZ33.Z3_DESENT 
			WHEN SZ3.Z3_QUEBRA = '2' AND SZ3.Z3_GRUPOIT = ' ' THEN SZ3.Z3_DESENT 
			ELSE SZ32.Z3_DESENT 
			END DESENT,
			DECODE(SZ3.Z3_QUEBRA,'2','4','9') TIPENT,
			CASE 
			WHEN SZ3.Z3_QUEBRA = '2' AND SZ3.Z3_GRUPOIT > '0' THEN SZ33.Z3_CODFOR 
			WHEN SZ3.Z3_QUEBRA = '2' AND SZ3.Z3_GRUPOIT = ' ' THEN SZ3.Z3_CODFOR 
			ELSE SZ32.Z3_CODFOR 
			END CODFOR,
			Z6_VALCOM
	FROM %TABLE:SZ6% SZ6
	JOIN %TABLE:SZ3% SZ3 ON SZ3.Z3_FILIAL = %XFILIAL:SZ3% AND SZ3.Z3_CODENT = Z6_CODENT AND SZ3.%NOTDEL%
	JOIN %TABLE:SZ3% SZ32 ON SZ32.Z3_FILIAL = %XFILIAL:SZ3% AND SZ32.Z3_CODENT = Z6_CODCCR AND SZ32.%NOTDEL%
	LEFT JOIN %TABLE:SZ3% SZ33 ON SZ33.Z3_FILIAL = %XFILIAL:SZ3% AND SZ33.Z3_CODENT = SZ3.Z3_GRUPOIT AND SZ33.%NOTDEL%
	WHERE
	Z6_FILIAL = %XFILIAL:SZ6% AND
	Z6_PERIODO = %Exp:TMPZZ6->ZZ6_PERIOD% AND
	Z6_TPENTID = '4' AND
	Z6_CODCCR = %Exp:TMPZZ6->ZZ6_CODENT% AND
	SZ6.%NOTDEL%)
	GROUP BY CODENT, DESENT, TIPENT, CODFOR
	ORDER BY TIPENT DESC
Endsql

//Customizações de usuário
While !TMPFAT->(EOF())
	If TMPFAT->COMISSAO > 0 .OR. TMPFAT->TIPENT=="9"
		
		nXParc++ //Contador de linhas
		
		//Efetua quebra de título por parcela 
		AADD(aSE2,aClone(aLinha))
		aSE2[nXParc,1] := Padl(AllTrim(Str(nXParc)),2,"0") 																	//Parcela Gerada 
		aSE2[nXParc,3] := Iif(TMPFAT->TIPENT=="9", TMPFAT->COMISSAO+TMPZZ6->ZZ6_VALAR+TMPZZ6->ZZ6_VALCAM,TMPFAT->COMISSAO)	//Valor da parcela 
		If Empty(TMPFAT->CODFOR)
			lOk := .F.
		Endif
		
		//Adiciona titulos que serao gerados fatura.
		If TMPFAT->TIPENT != "9"
			AADD(aFatura,{"   ",;			//Prefixo
						  CNFISCAL,;		//Titulo
						  aSE2[nXParc,1],;	//Parcela
						  TMPFAT->CODFOR,;	//Fornecedor Destino
						  TMPFAT->CODENT})	//Parceiro
		Endif
					  
	Endif
	TMPFAT->(DbSkip())
Enddo
TMPZZ6->(DbCloseArea())
TMPSZ3->(DbCloseArea())
TMPFAT->(DbCloseArea())
Return aSE2

//Renato Ruy - 04/10/2017
//Rotina chamada no OK, para validar se todos as entidades tem fornecedor vinculado
//Isto e para conseguir gerar as faturas corretamente
User Function CRPA044V()

If !lOk
	Alert("Não será possível gravar os títulos, pois uma ou mais IT's não tem fornecedor vinculado!","Remuneração de Parceiros")
Endif

Return lOk

//Renato Ruy - 05/10/2017
//Gera Faturas a pagar atraves dos titulos
User Function CRPA044F()
Local aArray	:={}
Local aTit 		:={}
Local lPosicao	:= .F.

Private lMsErroAuto := .F.

//Valida se gera faturas
If Len(aFatura) == 0
	Return
Endif

For nI := 1 To Len(aFatura)
	SE2->(DbSetOrder(1)) 	//Filial + 		Prefixo + 	  Titulo + 		Parcela + 	  Tipo
	lPosicao := SE2->(DbSeek(xFilial("SE2")+aFatura[nI,1]+aFatura[nI,2]))
	
	aadd(aTit,{ aFatura[nI,1],;	//Prefixo
				aFatura[nI,2],;	//Número  
				aFatura[nI,3],;	//Parcela 
				"NF ",;			//Tipo
				.f.})			//Título localizado na geração de fatura (lógico). Iniciar com falso
	
	aArray := { "REM",;				//Prefixo do titulo gerado
	 			"NF",;				//Tipo 
	 			"",;				//Numero da Fatura que sera gerado ou em branco para ser gerado pelo sistema
	 			SE2->E2_NATUREZ,;	//Natureza
	 			dDatabase,;			//Data de 
	 			dDatabase,;			//Data até
	 			SF1->F1_FORNECE,;	//Fornecedor 
	 			SF1->F1_LOJA,;		//Loja
	 			aFatura[nI,4],;		//Fornecedor para geração
	 			"01",;				//Loja do fornecedor para geração 
	 			SF1->F1_COND,;		//Condição de pagto  
	 			1,;					//Moeda 
	 			aTit,;				//array com os títulos da fatura
	 			0,;					//Valor de decréscimo
	 			0 }					//Valor de acréscimo
	 			  
	MsExecAuto( { |x,y| FINA290(x,y)},3,aArray,)
	
	If lMsErroAuto
		MostraErro()
	Endif
Next
Return