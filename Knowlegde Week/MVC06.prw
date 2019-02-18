#Include 'Protheus.ch'
#Include 'fwmvcdef.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC06
Exemplo de setOnlyView, SetInylQuery, Load no Grid, Seek Line
e SetFieldAction

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC06()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC06' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC06' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC06' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC06' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC06' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC06' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef() 
Local oModel := FWLoadModel("MVC05")
Local oStrMedia := getMdlMediaStr()
Local aAux  
Local oStruZB7 := oModel:GetModel("DETAILZB7"):GetStruct()

    oStruZB7:DeActivate()

    aAux := FwStruTrigger( "ZB7_NOTA"     ,; // Campo Dominio       
    "ZB7_NOTA"     ,; // Campo de Contradominio        
    "u_UpdMedia()") // Regra de Preenchimento     
    
    oStruZB7:AddTrigger( ;   
                    aAux[1]  , ;    // [01] Id do campo de origem   
                    aAux[2]  , ;    // [02] Id do campo de destino   
                    aAux[3]  , ;    // [03] Bloco de codigo de validação da execução do gatilho   
                    aAux[4]  )      // [04] Bloco de codigo de execução do gatilho 
    oStruZB7:Activate()     

    oModel:AddGrid('MEDIA','DETAILZB6',oStrMedia,,,,,{|oMdl,x,y,z| loadMedia(oMdl,x,y,z)})    
    oModel:SetRelation("MEDIA",{{"MEDIA",'ZB6_RA'}},"CODDIS")  
    oModel:GetModel("MEDIA"):SetOnlyQuery(.T.) 
    oModel:GetModel("MEDIA"):SetOptional(.T.)

    oModel:GetModel("DETAILZB7"):SetLPre({|oGrid,nLine,cAction,cIDField,xValueNew,xValueOld| LinePre(oGrid,nLine,cAction,cIDField,xValueNew,xValueOld)})
    
    //Bloqueia edição totalmente
    //oModel:GetModel("MEDIA"):SetOnlyView(.T.) 

    oModel:GetModel("MEDIA"):SetNoDeleteLine(.T.) 
    oModel:GetModel("MEDIA"):SetNoInsertLine(.T.) 
    oModel:GetModel("MEDIA"):SetNoUpdateLine(.T.) 

Return oModel

Static Function ViewDef() 
Local oModel := ModelDef() 
Local oView 
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6')
Local oStruZB7:= FWFormStruct(2, 'ZB7')
Local oStrMdlMedia := oModel:GetModel("MEDIA"):GetStruct()
Local oStruMedia := getViewMediaStr(oStrMdlMedia)
    
    oStrZB6:RemoveField('ZB6_CODTUR')

    oStruZB7:RemoveField('ZB7_CODTUR')
    oStruZB7:RemoveField('ZB7_RA')

	oView := FWFormView():New()  
	oView:SetModel(oModel)    

	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')  
	oView:AddGrid('FORM_NOTA' , oStruZB7,'DETAILZB7')     
    oView:AddGrid('FORM_MEDIA' , oStruMedia,'MEDIA')
		
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 20)  
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 30)  
	oView:CreateHorizontalBox( 'BOX_FORM_NOTA', 30)   
    oView:CreateHorizontalBox( 'BOX_FORM_MEDIA', 20)   
		
 	oView:SetOwnerView('FORM_NOTA','BOX_FORM_NOTA')  
 	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')  
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA') 	
    oView:SetOwnerView('FORM_MEDIA','BOX_FORM_MEDIA') 	
	
    oView:SetFieldAction( 'ZB7_NOTA', { |oView, cIDView, cField, xValue| GatilhoView( oView, cIDView, cField, xValue ) } )
Return oView 
 
Static Function getMdlMediaStr()
Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('MEDIA',{'CODDIS'},'MEDIA')
oStruct:AddField('Codigo da Disciplina','' , 'RA', 'C', 4, 0,, , {})
oStruct:AddField('Codigo da Disciplina','' , 'CODDIS', 'C', 3, 0,, , {})
oStruct:AddField('Codigo da Disciplina','' , 'DESDIS', 'C', 40, 0,, , {})
oStruct:AddField('Media Anual','' , 'MEDIA', 'N', 10, 2,, , {})
return oStruct

Static Function getViewMediaStr(oStrModel)
Local oStruct := FWFormViewStruct():New()    
    oStruct:AddField( 'CODDIS','1',oStrModel:GetProperty("CODDIS",MODEL_FIELD_TITULO),oStrModel:GetProperty("CODDIS",MODEL_FIELD_TITULO),, 'Get' ,,,,,,,,,,,, )
    oStruct:AddField( 'DESDIS','2',oStrModel:GetProperty("DESDIS",MODEL_FIELD_TITULO),oStrModel:GetProperty("DESDIS",MODEL_FIELD_TITULO),, 'Get' ,,,,,,,,,,,, )
    oStruct:AddField( 'MEDIA','3',oStrModel:GetProperty("MEDIA",MODEL_FIELD_TITULO),oStrModel:GetProperty("MEDIA",MODEL_FIELD_TITULO),, 'Get' ,,,,,,,,,,,, )
return oStruct

Static Function loadMedia(oGrid,lCopy)
Local aLoad := {}
Local cRA := oGrid:GetModel():GetValue("DETAILZB6","ZB6_RA")
Local cCodTur := oGrid:GetModel():GetValue("MASTERZB5","ZB5_CODTUR")
Local cAlias := GetNextAlias()

    BeginSql Alias cAlias	
        SELECT ZB7_CODDIS COD, ZB3_DESCRI DESCRICAO, AVG(ZB7_NOTA) MEDIA FROM %table:ZB7% ZB7
        INNER JOIN %table:ZB3% ON ZB3_FILIAL = %xFilial:ZB3% AND ZB3_CODIGO = ZB7_CODDIS
        WHERE ZB7_FILIAL = %xFilial:ZB7%
        AND ZB7_CODTUR = %Exp:cCodTur%
        AND ZB7_RA = %Exp:cRA%
        AND ZB7.%NotDel%
        GROUP BY ZB7_CODDIS, ZB3_DESCRI       
        ORDER BY ZB7_CODDIS, ZB3_DESCRI        
    EndSql

    If (cAlias)->(!EOF())
        While (cAlias)->(!EOF())
            aAdd(aLoad,{0 /*RECNO*/,{cRA,(cAlias)->COD,(cAlias)->DESCRICAO, (cAlias)->MEDIA}})    
            (cAlias)->(DbSkip())
        EndDo
    Else
        aAdd(aLoad,{0 /*RECNO*/,{cRA,"", "", 0}})
    EndIf

    (cAlias)->(DbCloseArea())
	
Return aLoad

User Function UpdMedia(nValor,lSum)
Local oModel := FWModelActive()
Local cCodDis
Local oGridZB7
Local oGridMedia
Local nLine

Default nValor := 0

    If oModel:GetID() == "MD_TURMA_ALUNO" .And. oModel:IsActive()
        oGridZB7 := oModel:GetModel("DETAILZB7")
        cCodDis := oGridZB7:GetValue("ZB7_CODDIS")
        
        If !Empty(cCodDis)
            oGridMedia := oModel:GetModel("MEDIA")
            oModel:GetModel("MEDIA"):SetNoDeleteLine(.F.) 
            oModel:GetModel("MEDIA"):SetNoInsertLine(.F.) 
            oModel:GetModel("MEDIA"):SetNoUpdateLine(.F.)
        
            nLine := oGridMedia:GetLine()

            If !oGridMedia:SeekLine( {{"CODDIS",cCodDis}}, .F./*lDeleted*/, .T. /*lLocate*/ )
                
                If (oGridMedia:Length() == 1 .And. oGridMedia:IsUpdated())
                    oGridMedia:AddLine()
                EndIf

                oGridMedia:LoadValue("CODDIS",cCodDis)
                oGridMedia:LoadValue("DESDIS",oGridZB7:GetValue("ZB7_DESDIS"))
            EndIf            
            
            oGridMedia:LoadValue("MEDIA",getAvg(oGridZB7,cCodDis,nValor,lSum))

            oModel:GetModel("MEDIA"):SetNoDeleteLine(.T.) 
            oModel:GetModel("MEDIA"):SetNoInsertLine(.T.) 
            oModel:GetModel("MEDIA"):SetNoUpdateLine(.T.)
            
            oGridMedia:GoLine(nLine)
        EndIf
        
    EndIf

Return oModel:GetValue("DETAILZB7","ZB7_NOTA")

Static Function getAvg(oGrid,cCodDis,nValor,lSum)
Local nLine := oGrid:GetLine()
Local nX
Local nCount := 0
Local nSum := 0
Local nAvg := 0

    If oGrid:SeekLine( {{"ZB7_CODDIS",cCodDis}}, .F./*lDeleted*/, .T. /*lLocate*/ )
        For nX:=oGrid:GetLine() to oGrid:Length()
            If !oGrid:IsDeleted(nX)
                If oGrid:GetValue("ZB7_CODDIS",nX) == cCodDis
                    nSum += oGrid:GetValue("ZB7_NOTA",nX)
                    nCount++                
                EndIf
            EndIf
        Next nX

        If nValor > 0
            If lSum
                nAvg := (nSum+nValor)/(nCount+1)
            Else
                nAvg := (nSum-nValor)/(nCount-1)
            EndIf
        Else
            nAvg := nSum/nCount
        EndIf

        oGrid:GoLine(nLine)
    EndIf

Return nAvg

Static Function GatilhoView( oView, cIDView, cField, xValue )
    oView:Refresh("FORM_MEDIA")
Return

Static Function LinePre(oGrid,nLine,cAction,cIDField,xValueNew,xValueOld)
    If cAction == "DELETE" 
        u_UpdMedia(oGrid:GetValue("ZB7_NOTA"),.F.)
    ElseIf cAction == "UNDELETE"
        u_UpdMedia(oGrid:GetValue("ZB7_NOTA"),.T.)
    EndIf

Return .T.