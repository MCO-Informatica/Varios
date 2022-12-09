#INCLUDE 'Protheus.ch'    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GP010VALPE�Autor  �Mariella - Opvs     � Data �  14/08/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para checar os dados de inclus�o/alteracao ���
���          �de funcionarios.                                            ���
�������������������������������������������������������������������������͹��
���Uso       �RH_Certisign                                                ���
�������������������������������������������������������������������������͹��
���Melhoria  |Rafael Beghini - Totvs SM : 01/04/2014                      ���
���          |Inclusao de PE para preencher campo RA_SEGUROV              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function GP010VALPE()          

//�������������������������������������������������������������������������T�
//�Parametro para executar o PE relacionado ao cadastro no campo RA_SEGUROV�
//�������������������������������������������������������������������������T�
	Local lGPCADSE := GetMv("MV_GPCADSE")


// Nome:RA_XDESPRM Tipo:M Tamanho:80 
// Nome:RA_XDESPRC Tipo:C Tamanho:6    

_cTeste := M->RA_XDESPRM
_nTam := TamSX3("RA_XDESPRM")
_nTam1 := _nTam[1]          

MSMM(,_nTam1,,_cTeste,1,,,"SRA","RA_XDESPRC")


//Executa rotina para preencher campo RA_SEGUROV
If FindFunction("U_GpCadSeg") .And. lGPCADSE
	U_GpCadSeg()
EndIf     

Return (.T.)