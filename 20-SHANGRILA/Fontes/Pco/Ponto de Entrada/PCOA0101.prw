#Include 'Protheus.ch'

#Define ENTER Chr(13) + Chr(10)

/*
* Funcao		:	PCOA0101
* Autor			:	Jo�o Zabotto
* Data			: 	24/03/2014
* Descricao		:	Sincroniza Vis�o gerencial com a conta or�ament�ria
* Retorno		: 	
*/
User Function PCOA0101
	Local aRet := {}

	aadd(aRet,{'Sinc. Vis�o','U_ZSINCVIS()' , 0 , 3,0,NIL})

Return  aRet
		
/*
* Funcao		:	ZSINCVIS
* Autor			:	Jo�o Zabotto
* Data			: 	24/03/2014
* Descricao		:	Executa a sincroniza��o
* Retorno		: 	
*/
User Function ZSINCVIS()
	local cCodPla := PadR(Alltrim(SuperGetMv('ZZ_CODVIS',.F.,'100')),TamSx3('CTS_CODPLA')[1])
	
	CTS->(DbSetOrder(1))
	If CTS->(DbSeek(xFilial('CTS') + cCodPla))
	
		While !CTS->(Eof()) .And. CTS->CTS_CODPLA == cCodPla
	
			AK5->(DbSetOrder(1))
			If AK5->(DbSeek(xFilial('AK5') + PADR(CTS->CTS_CONTAG,TamSX3('CTS_CONTAG')[1])))
				RecLock('AK5',.F.)
			Else
				RecLock('AK5',.T.)
			EndIf
			
			
			AK5->AK5_CODIGO := CTS->CTS_CONTAG
			AK5->AK5_DESCRI := CTS->CTS_DESCCG
			AK5->AK5_TIPO	:= CTS->CTS_CLASSE
			AK5->AK5_DEBCRE	:= CTS->CTS_NORMAL
			AK5->AK5_DTINC 	:= DdataBase
			AK5->AK5_DTINI	:= CTOD('01/01/1980')
			AK5->AK5_COSUP	:= CTS->CTS_CTASUP
			
			AK5->(MsUnlock())
			
			CTS->(DbSkip())
		EndDo
	
	EndIf


Return

	
