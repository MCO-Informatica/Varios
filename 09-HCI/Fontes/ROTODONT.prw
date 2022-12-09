#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ROTODONT � Autor � Eduardo Porto         � Data � 21.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria Verba de Desconto da Ass. Odontologica                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RDMake ( DOS e Windows )                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para HCI                                        ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Nagy       �15/06/07�      �Desconsidera calculo quando funcionario   ���
���            �        �      �esta sem Assistencia Odont. no cadastro   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function ROTODONT()

//Montando Variaveis de Trabalho
nVlrFunc  := 0
nVlrEmp   := 0
VlrDesc1_ := 0
nAgreg1_  := 0
_nVAgr1 := 0
aTAssMed := {}               
cAssMed := " "
cVerba    := "  "
cVerbaEmp := "765"
nPartEmp := 0
nQtdeFunc := 0  
nQtde	  := 0  
cDescPlan:=" " 
cprocura:=" "
nIdadecalc_ := 0
lRet := .T.
//Processamento

// CALCULO DA ASSISTENCIA ODONTOL�GICA PARA O FUNCIONARIO

		If !Empty(SRA->RA_ASSODO_)
			//Localiza Parametros
			U_CVAssOdont(SRA->RA_ASSODO_)

                 If (nPos := Ascan(aTAssMed,{ |X| X[1] = cVerba })) > 0
                 	aTAssMed[nPos,2] := aTAssMed[npos,2] + 1 
                 	aTAssMed[nPos,3] := aTAssMed[nPos,3] + (VlrDesc1_-nPartEmp)
                 	aTAssMed[nPos,4] := aTAssMed[nPos,4] + nPartEmp
                 Else
                    Aadd(aTAssMed,{cVerba,1,(VlrDesc1_-nPartEmp),nPartEmp})
                 Endif   	
                 nQtdeFunc := 1
//		End    - Nagy / 15/06/07

			// CALCULO DA ASSISTENCIA MEDICA PARA OS DEPENDENTES DO FUNCIONARIO

			dBSelectArea("SRB")
			dBSetOrder(1)
			
			SRB->(dbSetOrder(1))
			
			//Pesquisa Dependente
			SRB->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT))
			
			If SRB->(Found())
				While SRA->RA_FILIAL+SRA->RA_MAT == SRB->RB_FILIAL+SRB->RB_MAT
				
					// Se Agregado de Ass. Medica 
					If !empty(SRB->RB_ASSODO_)
						
					
						//Localiza Parametros
						U_CVAssOdont(SRB->RB_ASSODO_)
			
				                 If (nPos := Ascan(aTAssMed,{ |X| X[1] = cVerba })) > 0
				                 	aTAssMed[nPos,2] := aTAssMed[npos,2] + 1 
				                 	aTAssMed[nPos,3] := aTAssMed[nPos,3] + VlrDesc1_
				                 Else
				                    Aadd(aTAssMed,{cVerba,1,VlrDesc1_})
				                 Endif   	
			
					End       
			
			        SRB->(dbSkip())
				End
			End
			 
			//Calculo
			
			
			  If len(aTAssMed) > 0
			
			                /* POSIC�ES DO ARRAY ATASSMED
			                 	aTAssMed[nPos,1] := C�digo da verba a ser descontado
			                 	aTAssMed[nPos,2] := Quantidade de Dependentes
			                 	aTAssMed[nPos,3] := Valor total do desconto do Funcion�rio
			                 	aTAssMed[nPos,4] := Valor total da parte da empresa
			                 */
			        For x:=1 to len(aTAssMed)
			        
				        // valor do desconto do funcion�rio
			  		    fGeraVerba(aTAssMed[x,1],aTAssMed[x,3],aTAssMed[x,2],,,,,,,,.T.)
			
						nVlrEmp   := nVlrEmp + aTAssMed[x,4]
						nQtde     := nQtde + aTAssMed[x,2]
			
			        Next
			
			
			        If nVlrEmp > 0
				        // valor da parte da empresa
			  		    fGeraVerba(cVerbaEmp,nVlrEmp,nQtdeFunc,,,,,,,,.T.)
			        Endif
					
			
			 Endif 
 
Endif	// Nagy - 15/06/07

Return(" ")


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ROTODONT  �Autor  �Microsiga           � Data �  06/15/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CVAssOdont(cAssMed) 

dBSelectArea("RCC")
dBSetOrder(1)

MsSeek(Space(2) + "U001" +Space(8) + "0" + cAssMed + cAssMed)

	If RCC->(Found())
        
		cDescPlan := Substr(RCC_CONTEU,3,30)        
        VlrDesc1_ := Val(Substr(RCC_CONTEU,33,10))
		cVerba    := Substr(RCC_CONTEU,43,3)        
		nPartEmp  := Val(Substr(RCC_CONTEU,46,10)) 
 
	End          

Return(VlrDesc1_,cVerba,nPartEmp,cDescPlan)





