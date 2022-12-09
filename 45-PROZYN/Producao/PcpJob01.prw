#include "tbiconn.ch"
#include "protheus.ch"
#include "topconn.ch"


/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �PCPJOB01  �Autor  �Henio Brasil           � Data �19/03/2018 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de Chamada de JOB - Projeto Prozyn                    ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Execucao de JOB para chamada da rotina de geracao de Previsao���
���          �de Vendas Automatico.                                        ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Empresa   �PROZYN                                                       ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function PCPJOB01()

Local nI 
Local aEmpresa 	:= {} 
Local aFiliais 	:= {} 
Local cFilDef	:= '01'		// cFilAnt
Local cEmpDef 	:= '99'		// cEmpAnt
Local cEmpAnt 	:= '99'	
Local cFiliais	:= '0101;0102' 
Local aAreaJob	:= GetArea() 
Local lDebug	:= .F. 
Local lSecond 	:= .F. 

/*  
����������������������������������������������������������������������������Ŀ
�Inicio Selecao dos titulos para geracao de Boletos Automaticos.             �
������������������������������������������������������������������������������*/  
ConOut("")
ConOut("#-------------------------------------------------------------------------")
ConOut(" Iniciando Job ==> PcpJob01.prw ==> " + Dtoc(Date()) + ' ' + Time())
ConOut("#-------------------------------------------------------------------------")
ConOut("")

If !lDebug	 
	PREPARE ENVIRONMENT EMPRESA cEmpDef FILIAL cFilDef TABLES "SC4","SZ2" MODULO "PCP" 
Endif 

/*  
����������������������������������������������������������������������������Ŀ
�Valida se e' a empresa que recebera a integracao de Previsao de Vendas      �
������������������������������������������������������������������������������*/  
If cEmpAnt <> '99' 	// '07' 
	ConOut("")
	ConOut("#-------------------------------------------------------------------------")
	ConOut("Esta empresa nao pode executar o processo de Previsao de Vendas           ")  
	ConOut("#-------------------------------------------------------------------------")
	ConOut("")
	Return 
Endif 

ConOut("")
ConOut("#-------------------------------------------------------------------------")
ConOut("# Iniciando Processo de Previsao de Vendas Automatico  ")    
ConOut("#-------------------------------------------------------------------------")
ConOut("")	 
// Return      	
/* 
����������������������������������������������������������������������������Ŀ
�Inicio do Processo, inicialmente habilitado para Empresa Matriz = 01        �
������������������������������������������������������������������������������*/ 
U_PcpPm01("PcpJob01") 

/* 
����������������������������������������������������������������������������Ŀ
�Final do Processo de JOB                                                    �
������������������������������������������������������������������������������*/ 
ConOut("")
ConOut("#-------------------------------------------------------------------------")
ConOut(" Finalizado Job ==> PCPJOB01 ==> " + Dtoc(Date()) + ' ' + Time())
ConOut("#-------------------------------------------------------------------------")
ConOut("")  

DbCloseArea()         
RestArea(aAreaJob)
Return(.T.) 