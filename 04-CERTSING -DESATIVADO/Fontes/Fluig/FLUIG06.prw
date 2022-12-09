#Include "Totvs.ch"
#Include "Topconn.ch"
#INCLUDE "PROTHEUS.CH"

//Fonte descontinuado - UTILIZAR O FLUIG06A.PRW
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �FLUIG06 �Autor  �Renato Ruy Bernardo    � Data �  25/04/2017���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de Remunera��o de Parceiros.			          ���
���          �* Postos                                                    ���
���          �* AC	                                                      ���
���          �* CANAL                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign - Faturamento		                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function FLUIG06()
	msgAlert("Rotina descontinuada."+CRLF+"Utilizar a rotina: Relat�rios -> Novos Relat�rios -> Treinamentos Pendentes", "Descontinuado")
return

/*
User Function FLUIG06()
Local nVarLen := SetVarNameLen(100)
Local oReport

Private aPergs  := {}
Private aAreas  := {}
Private cDBOra  := GetNewPar("MV_FLUIGB","ORACLE/FLUIG_PRD")
Private cSrvOra := GetNewPar("MV_FLUIGT", "10.0.14.172")
Private cPerg	:= "FLUIG06"
Private aRet	:= {}
Private nHndOra	:= 0

If Select("TMPGRU") > 0
	DbSelectArea("TMPGRU")
	TMPGRU->(DbCloseArea())
Endif

//Fa�o Conex�o com o banco do Fluig.
TCConType("TCPIP")
nHndOra := TcLink(cDbOra,cSrvOra,7890)

Beginsql Alias "TMPGRU"
	SELECT AREA
	FROM RNC
	GROUP BY AREA
	ORDER BY AREA
Endsql

AADD(aAreas,"Todos")
While !TMPGRU->(EOF())
	AADD(aAreas,RTrim(TMPGRU->AREA))
	TMPGRU->(DbSkip())
Enddo

aAdd( aPergs ,{2,"Departamento" ,"Todos" , aAreas           ,100,'.T.',.T.})
aAdd( aPergs ,{2,"Somente Ativo","2"     , {"1=Sim","2=N�o"}, 50,'.T.',.T.})
If !ParamBox(aPergs ,"Parametros ",aRet)
	Alert("Rotina Cancelada!")
	Return
Endif

oReport := ReportDef()
oReport:PrintDialog()
SetVarNameLen(nVarLen)

//Desconecta da base de dados do fluig
TcUnlink(nHndOra)

Return
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ReportDef �Autor  �Renato Ruy Bernardo	  � Data �  25/04/2017���
�������������������������������������������������������������������������͹��
���Desc.     � Defini��es do Relat�rio                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
Static Function ReportDef()
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
      cDescricao	+=	"Dados das N�o Conformidades."
//Objeto do Relat�rio
oReport	:=	TReport():New("FLUIG06","Relatorio de RNC", "", {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

//Se��es Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "Qualidade"	, {"FLUIG"})

//Celulas de Impress�o - SZ6 - Movimentos de Remunera��o

TRCell():New(oSection, "PROCESSO"	, "FLUIG06", "C�digo RNC"		, ,10)
TRCell():New(oSection, "DTREGISTRO"	, "FLUIG06", "Data Registro"	, ,10)
TRCell():New(oSection, "DTOCORRE"	, "FLUIG06", "Data Ocorr�ncia"	, ,10)
TRCell():New(oSection, "OCORRE"		, "FLUIG06", "Ocorr�ncia"		, ,30)
TRCell():New(oSection, "AREA"		, "FLUIG06", "�rea Destino"		, ,30)
TRCell():New(oSection, "TITULO"		, "FLUIG06", "T�tulo"			, ,30)
TRCell():New(oSection, "PRAZO"		, "FLUIG06", "Prazo"			, ,30)

oSection:SetHeaderPage(.F.)

Return oReport
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  PrintReport�Autor  �Renato Ruy Bernardo� Data � 25/04/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     � Dados a serem impressos                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
Static Function PrintReport(oReport)
Local oSection		:= oReport:Section(1)
Local oBreak        := Nil
Local cCpoBreak		:= ""
Local cDescBreak	:= ""
Local nOrdem		:= oSection:GetOrder()
Local cWhere		:= "% %"

If aRet[1] != "Todos"
	cWhere := "% WHERE AREA = '"+aRet[1]+Iif(aRet[2]=="2","' %","' AND LOG_ATIV = 1 %")
Elseif aRet[2] == "1"
	cWhere := "% WHERE LOG_ATIV = 1 %
Endif

//Transforma par�metros do tipo Range em express�o SQL para ser utilizadana query.
MakeSqlExpr(cPerg)

oSection:BeginQuery()                                    

If Select("FLUIG06") > 0
	DbSelectArea("FLUIG06")
	FLUIG06->(DbCloseArea())
Endif

Beginsql Alias "FLUIG06"

	SELECT	PROCESSO,
			DTREGISTRO,
			DTOCORRE,
			OCORRE,
			AREA,
			TITULO,
			CASE 
			WHEN LOG_ATIV = 0 THEN 'ENCERRADO'
			ELSE
				(SELECT 
				CASE
				WHEN TO_CHAR(MAX(DAT_MOVTO), 'DD/MM/YY') > TO_CHAR(SYSDATE, 'DD/MM/YY')
				THEN 'FORA DO PRAZO'
				ELSE
				'DENTRO DO PRAZO'
				END
				 DATA
				FROM HISTOR_PROCES HP
				JOIN ESTADO_PROCES EP 
				ON NUM_SEQ = NUM_SEQ_ESTADO AND NUM_VERS = (SELECT MAX(NUM_VERS) FROM ESTADO_PROCES WHERE COD_DEF_PROCES = EP.COD_DEF_PROCES)
				WHERE
				NUM_SEQ_MOVTO = (SELECT MAX(NUM_SEQ_MOVTO) FROM HISTOR_PROCES
									WHERE
									NUM_PROCES = PROCESSO) AND
				COD_DEF_PROCES IN ('ecm_kgq_ro_2','ecm_kgq_ro') AND
				NUM_PROCES = PROCESSO)
			END PRAZO		
	FROM RNC
    %Exp:cWhere%
Endsql

oSection:EndQuery()

//Imprime
oSection:Print() 

Return
*/