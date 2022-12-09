/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA040GRV  �utor  � S�rgio Santana     � Data �  30/04/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta rotina tem a finalidade de incluir os RAs no aplicati ���
���          � vo GESTOQ                                                  ���
�������������������������������������������������������������������������͹��
���Uso       �Glasstech                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA040GRV()
    
    LOCAL _aResult := {}  

	If SE1->E1_TIPO == 'RA '

       _aResult := TCSPExec("f300SE5Adt"        ,;
	                        SA6->A6_IDCONTA     ,;
	                        Val(SE1->E1_CLIENTE),;
	                        SE5->E5_DTDISPO     ,;
	                        SE5->E5_VALOR       ,;
	                        rTrim( SE1->E1_NUM ) + '/' +SE1->E1_PARCELA + ' ' +rTrim( SE1->E1_NOMCLI ),;
	                        cUserName           ,;
	                        SE5->E5_NUMERO + SE5->E5_PARCELA,;
	                        'C'            ,;
	                        SE5->E5_FILORIG,;
	                        'A'            ,;
	                        0              ,;
	                        0			   ,;
	                        SE1->E1_ORIGBD ,;
                               0,;
                               0,;
                               "")

       If ValType( _aResult ) = 'A'

          RecLock( 'SE1', .F. )
	      SE1->E1_IDBOLET := _aResult[ 2 ]
	      SE1->E1_MSEXP   := DTOS(DATE())
          SE1->( MSUnLock() )       

       EndIf
    
    ElseIf SE1->E1_TIPO == 'NCC'

       _aResult := TCSPExec("f300SE5Adt"        ,;
	                        0     				,;
	                        Val(SE1->E1_CLIENTE),;
	                        SE1->E1_EMISSAO     ,;
	                        SE1->E1_VALOR       ,;
	                        rTrim( SE1->E1_NUM ) + '/' +SE1->E1_PARCELA + ' ' +rTrim( SE1->E1_NOMCLI ),;
	                        cUserName           ,;
	                        SE1->E1_NUM + SE1->E1_PARCELA,;
	                        'C'            ,;
	                        SE1->E1_FILORIG,;
	                        'A'            ,;
	                        0              ,;
	                        0			   ,;
	                        SE1->E1_ORIGBD ,;
                               0,;
                               0,;
                               "")

       If ValType( _aResult ) = 'A'

          RecLock( 'SE1', .F. )
	      SE1->E1_IDBOLET := _aResult[ 2 ]
	      SE1->E1_MSEXP   := DTOS(DATE())
          SE1->( MSUnLock() )       
       EndIf
    EndIf

Return( NIL )