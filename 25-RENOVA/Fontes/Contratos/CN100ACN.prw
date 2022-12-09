#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CN100ACN  � Autor � TOTVS                � Data �12/01/2015���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � PE PARA CRIAR TELA NO ADIANTAMENTO EM CONJUNTO COM O PE    ���
���Descri�ao � CN100ADI                                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CN100ACN                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RENOVA                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function CN100ACN()  

Local aArea      := GetArea()
Local ExpC1      := PARAMIXB[1]
Local ExpC2      := PARAMIXB[2]
Local ExpC3      := PARAMIXB[3]
Local ExpC4      := PARAMIXB[4]
Local ExpC5      := PARAMIXB[5]
Local ExpC6      := PARAMIXB[6]
Local ExpC7      := PARAMIXB[7]
Local ExpC8      := PARAMIXB[8]
Local ExpC9      := PARAMIXB[9]
Local ExpC10     := PARAMIXB[10]   
Local ExpC11     := PARAMIXB[11]
Local ExpL1      := .T.//Valida��es do usu�rio       

Public _cContCRE    := Space(TamSX3("CT1_CONTA")[1])
Public _cCCustoRE   := Space(TamSX3("CTT_CUSTO")[1])
Public _cItemCRE    := Space(TamSX3("CTD_ITEM")[1])
Public _cClasseVRE  := Space(TamSX3("CTH_CLVL")[1])
Public _cClasseCV0  := Space(TamSX3("CV0_CODIGO")[1])

//����������������������������������������Ŀ
//� Cria dialog para      �
//������������������������������������������

DEFINE MSDIALOG oDlg TITLE "Contabilidade" FROM 0,0 TO 250,410 OF oMainWnd PIXEL 
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
	
@ 03, 40 SAY "Dados Cont�beis" FONT oBold PIXEL
@ 14, 30 TO 16 ,400 LABEL '' OF oDlg   PIXEL

@ 30, 040 Say "Item cont�bil" Size 60,8 PIXEL //FAZ UM GATILHO PARA PEGAR O SUBSTR E JOGA NO CTH
@ 29, 100 MsGet _cItemCRE SIZE 55,8 F3 "CTD" Valid Vazio(_cItemCRE) .Or. ExistCpo("CTD",_cItemCRE) PIXEL

@ 44, 040 Say "Classe de valor" Size 60,8 PIXEL //TRAVA N�O DIGITA
@ 45, 100 MsGet Substr(_cItemCRE,1,2) WHEN .F.  SIZE 55,8  PIXEL   

@ 59, 040 Say "Centro de custo" Size 60,8 PIXEL 
@ 58, 100 MsGet _cCCustoRE SIZE 55,8 F3 "CTT" Valid Vazio(_cCCustoRE) .Or. ExistCpo("CTT",_cCCustoRE) PIXEL

@ 74, 040 Say "Classe Or�ament�ria" Size 60,8 PIXEL //COLOCA A CONSULTA PADRAO CTHESP
@ 73, 100 MsGet _cClasseCV0 SIZE 55,8 F3 "CTHESP" Valid ValCTH(_cClasseCV0) PIXEL
//@ 73, 100 MsGet _cClasseCV0 SIZE 55,8 F3 "CTHESP"  PIXEL

@ 89, 040 Say "Conta Cont�bil " Size 60,8 PIXEL //TRAVA N�O DIGITA, RECEBE A CONTA CONT�BIL ATRELADA A CV0_XCONTA


@ 88, 100 MsGet _cContCRE WHEN .F.  Size 55,8   PIXEL
                                      
DEFINE SBUTTON FROM 110,145 TYPE 1;
  		ACTION If(Empty(_cContCRE) .Or. Empty(_cCCustoRE) .Or. Empty(_cItemCRE) .Or. Empty(_cClasseVRE) .Or. Empty(_cClasseCV0) ,; //-- Valida preenchimento dos dados
               Alert("Selecione uma Conta Contabil/Centro de Custo/Item/Classe de valor/Classe or�ament�ria"),;	
			   (oDlg:End(),nOpcA := 1)) ENABLE OF oDlg 
			   
DEFINE SBUTTON FROM 110,175 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg
	                                                                                                            
ACTIVATE MSDIALOG oDlg CENTERED   
            
RestArea(aArea)

Return ExpL1

Static function ValCTH(_cClasseCV0)
_lRet:= .T.
DbSelectArea("CV0")
DbSetOrder(2)
If !Dbseek(Xfilial("CV0")+_cClasseCV0)
   MsgAlert("Classe de Valor inexistente!","Aten��o")
   _lRet:=.F.  
Else
	_cContCRE := CV0->CV0_XCONTA    	
Endif

Return(_lRet)