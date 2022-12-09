User Function GATSE1()  
Local cRet :="BX COMPENSACAO CF AV."

BeginSql Alias "TRA"
	
	SELECT
	E5_NUMERO,
	E5_PARCELA,
	E5_PREFIXO,
	E5_DOCUMEN,
	E5_MOTBX,
	E5_TIPODOC
	FROM
	%table:SE5% SE5
	WHERE
		E5_FILIAL  = %xFilial:SE5%
	AND E5_NUMERO = %Exp:SE1->E1_NUM%
    AND E5_CLIFOR = %Exp:SE1->E1_CLIENTE%
	AND E5_LOJA   = %Exp:SE1->E1_LOJA%
	AND SE5.%notDel%
	order by E5_TIPODOC DESC
	
EndSql

While ! TRA->(EoF())
	
	IF ALLTRIM(TRA->E5_MOTBX) == "CMP"
		cRet += ALLTRIM(TRA->E5_DOCUMEN) + " / "
	ELSE
		cRet += ALLTRIM(TRA->E5_PREFIXO + TRA->E5_NUMERO + TRA->E5_PARCELA) + "/"
	ENDIF
    
    TRA->(DbSkip())
EndDo

cRet += " " + ALLTRIM(SA1->A1_NREDUZ) + "  "

TRA->(DbCloseArea())

Return(cRet)
