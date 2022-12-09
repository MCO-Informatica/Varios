#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function XmlPar(cBuffer,_cPar,cAviso,cErro)

_cBuffer := XmlParser(cBuffer,_cPar,@cAviso,@cErro)

Return( _cBuffer )