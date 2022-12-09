#include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFAT008   �Autor  �Richard Nahas Cabral� Data �  18/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Reimpressao dos cerfiticados de analise pela NF de saida    ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MFAT008()

Local aCores := {}

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MFAT008" , __cUserID )

Private aRotina := {	{"Pesquisar" 		, "AxPesqui"	, 0, 1, 0, .F.},;	// Pesquisar
{"Imp.Certificado"  , "U_MFAT008I()", 0, 2, 0, NIL},;	// Impressao do Certificado de Analise
{"Legenda"   		, "U_MFAT008L()", 0, 5, 0, NIL} }	// Legenda

Private cCadastro := "Impress�o Certificado de An�lise pela NF Sa�da"

aCores := {	{'F2_TIPO=="N"'	 , 'DISABLE'   },;	// NF Normal
{'F2_TIPO=="P"'	 , 'BR_AZUL'   },;	// NF de Compl. IPI
{'F2_TIPO=="I"'	 , 'BR_MARRON' },;	// NF de Compl. ICMS
{'F2_TIPO=="C"'	 , 'BR_PINK'   },;	// NF de Compl. Preco/Frete
{'F2_TIPO=="B"'	 , 'BR_CINZA'  },;	// NF de Beneficiamento
{'F2_TIPO=="D"'  , 'BR_AMARELO'}}	// NF de Devolucao

mBrowse( 6, 1, 22, 75, "SF2", , , , , , aCores )

Return( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFAT008I  �Autor  �Richard Nahas Cabral� Data �  18/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Reimpressao dos cerfiticados de analise pela NF de saida    ���
���          �Chama funcao para impressao dos certificados                ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MFAT008I(cAlias,nReg,nOpc)

Local aAlias    := GetArea()
Local aAliasSD2 := GetArea("SD2")
Local aAliasSF2 := GetArea("SF2")

//����������������������������������������������������Ŀ
//�Chama fun��o para impressao certificado de analise  �
//������������������������������������������������������

Processa({|| U_CertAnalis()},"Verificando Necessidade impress�o dos Certificados de An�lise")

SD2->(RestArea(aAliasSD2))
SF2->(RestArea(aAliasSF2))
RestArea(aAlias)

Return (.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFAT008L  �Autor  �Richard Nahas Cabral� Data �  18/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Reimpressao dos cerfiticados de analise pela NF de saida    ���
���          �Legenda                                                     ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MFAT008L()

BrwLegenda(cCadastro,"Legenda",{	{"DISABLE"   , "NF Normal"                },;
{"BR_AZUL"   , "NF de Compl. IPI"         },;
{"BR_MARRON" , "NF de Compl. ICMS"        },;
{"BR_PINK"   , "NF de Compl. Preco/Frete" },;
{"BR_CINZA"  , "NF de Beneficiamento"     },;
{"BR_AMARELO", "NF de Devolucao"          }})
Return .T.

