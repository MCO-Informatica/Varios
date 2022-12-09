/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MGER004   �Autor  �Daniel Gondran      � Data �  18/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para chamar o certificado de analise baseado na NF  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MAKENI                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
#include "PROTHEUS.CH"
#include "TBICONN.CH"

User Function MGER004()
	Local nOpcA       := 0
	Local aSays       := {}
	Local aButtons    := {}
	Local cCadastro   := "Impressao do Certificado de Analise a partir da NF Saida"
	Local cPerg       := "MGER04"

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MGER004" , __cUserID )
	Pergunte( cPerg, .F.)

	aAdd( aSays, "Essa rotina efetua a impressao do certificado de" )
	aAdd( aSays, "an�lise com base na Nota Fiscal de Sa�da." )

	aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
	aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
	aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1
		Processa( { || U_MGER4Proc() }, "Gerando Certificado..." )
	Endif

Return                                                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MGER4PROC �Autor  �Daniel Gondran      � Data �  18/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para emitir o certificado de analise baseado na NF  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MAKENI                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MGER4PROC

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(xFilial("SF2") + MV_PAR01 + MV_PAR02)

	Processa({|| U_CertAnalis()},"Verificando Necessidade impress�o dos Certificados de An�lise")

Return