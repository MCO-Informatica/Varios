#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMS110CD  �Autor  �Felipe Valenca      � Data �  20/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na gera��o do projeto para gravar o campo  ���
���          �AF1_XSITE na tabela AF8                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PMS110CD
    Local cReturn

    cReturn := UPPER(MV_PAR01)

    AF8_SITE	:= 	AF1->AF1_XSITE
    AF8_CEP		:= 	AF1->AF1_CEP
    AF8_MUN		:=	AF1->AF1_MUN
    AF8_END		:=	AF1->AF1_END
    AF8_BAIRRO	:=	AF1->AF1_BAIRRO
    AF8_EST		:=	AF1->AF1_EST
    AF8_CODMUN	:=	AF1->AF1_CODMUN

//AF9_XFATMA	:=	AF2->AF2_XFATMA
//AF9_XPERMA	:=	AF2->AF2_XPERMA

Return cReturn
