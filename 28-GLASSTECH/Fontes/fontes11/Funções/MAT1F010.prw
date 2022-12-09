#Include 'Protheus.ch'

/*
	Fernando Sancho
	
	fernando.sancho@gmail.com

	Fun��o � para ser usado como gatilho no campo B1_ITEMCC da tabela SB1

	caso a condi��o seja verdadeira seta campos relacionados para Sim caso contrario
	seta campos para N�o
	
	-- Solicita��o do Sidnei --
*/
User Function MAT1F010()
	if M->B1_TIPO == 'PA' .and. M->B1_GRUPO <> 'BLNK' .and. M->B1_ITEMCC $ "AMT AML OMT OML MMT MML CMT CML"
		M->B1_PIS	:= '1'
		M->B1_COFINS	:= '1'
		M->B1_RETOPER	:= '1'
	endif
Return