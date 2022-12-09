#INCLUDE "Protheus.ch"
#DEFINE X3_USADO_EMUSO "���������������"
#DEFINE X3_USADO_NAOUSADO "���������������"   
#DEFINE X3_OBRIGAT "��" 
#DEFINE X3_NAOOBRIGAT "��" 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � Lucas Pereira      � Data �  11/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � ponto de entrada meus pedidos novos cliestes importados    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MP_NOVOCLI
local cGrpTri 	:= alltrim(  iif( type("aResult:NOME_EXCECAO_FISCAL") <> 'U', aResult:NOME_EXCECAO_FISCAL,'') ) 	     
Local cCelular	
local cDDD

	//cTipo	:= iif(cGrpTri $ '|SLD|SIM|' .or. empty(cGrpTri) , "S" , "F" )
	// TRATATIVA PARA TIPO DE CLIENTE DE ACORDO COM A FILIAL
	if aParam[1] == '01'
		cTipo	:= 'S'
		cGrpTri := 'SLD'
	else
		cTipo	:= 'F'
		cGrpTri := 'CF1'
	endif

	//retira os espa�os se houver
	cTel	:= alltrim(cTel)
	ctel2	:= alltrim(cTel2)
	cTel3	:= alltrim(cTel3)

	//retira 0 quando vendedor digitar antes do ddd
	cTel	:= if(substr(cTel,1,1)=='0', substr(cTel,2,len(cTel)), cTel )
	ctel2	:= if(substr(cTel2,1,1)=='0', substr(cTel2,2,len(cTel2)), cTel2 )
	cTel3	:= if(substr(cTel3,1,1)=='0', substr(cTel3,2,len(cTel3)), cTel3 )


	//se o primeiro for celular (9 Digitos) grava no segundo
	if len(cTel) == 11 .or. len(cTel) == 9
		cCelular := cTel
		cTel 	 := ctel2
		ctel2	 := cCelular
	endif


	//atualzia ddd
	cDDD := substr(cTel,1,2)



	reclock("SA1",.F.)
		A1_DDD 		:= cDDD
		A1_TIPO 	:= cTipo
		A1_TEL		:= cTel
		A1_TELEX	:= ctel2
		A1_FAX		:= ctel3
	msunlock()







Return()
