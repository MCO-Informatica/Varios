
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050MCP   �Autor  �S�rgio Santana      � Data �  21/07/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta rotina tem a finalidade de incluir campos que podem so-���
���          �frer atualiza��o                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Glasstech                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function F050MCP()

    Local _aCols := ParamIxb

    aAdd( _aCols, "E2_DATAAGE" )
    aAdd( _aCols, "E2_EMISSAO" )
    aAdd( _aCols, "E2_FORBCO" )
    aAdd( _aCols, "E2_FORAGE" )
    aAdd( _aCols, "E2_FAGEDV" )
    aAdd( _aCols, "E2_FORCTA" )
    aAdd( _aCols, "E2_FCTADV" )    
    aAdd( _aCols, "E2_FORMPAG" )    
    aAdd( _aCols, "E2_CODRET" )    
    aAdd( _aCols, "E2_MULTA" )        
    aAdd( _aCols, "E2_JUROS" )    
    aAdd( _aCols, "E2_DESCONT" )    
        
Return _aCols