#IFNDEF _FILDFLT_CH
	
	#DEFINE _FILDFLT_CH
	
	/*  
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	쿍egin Comando de Traducao para as Atualizacoes das  Variaveis?
	쿘v's. 														  ?
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?*/
	#xcommand DEFAULTFIL	<uVar1> := <uVal1> =>;
							<uVar1> := (;
										 __cSvFilAnt := IF( Type("__cSvFilAnt") == "U" , cFilAnt , __cSvFilAnt ),;
							  			 IF( <uVar1> == NIL .or. cFilStatic != __cSvFilAnt , <uVal1>, <uVar1> )	 ;
						 				)
	/*  
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	쿐nd  Comando  de Traducao para as Atualizacoes das  Variaveis?
	쿘v's. 														  ?
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?*/			 				

#ENDIF