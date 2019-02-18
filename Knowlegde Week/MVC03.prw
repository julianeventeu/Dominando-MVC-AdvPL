#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC03
Exemplo de validações e manipulação de dados no model

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC03()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC03' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC03' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC03' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC03' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC03' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC03' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef() 
Local oModel 
Local oStruZB5 := FWFormStruct(1,"ZB5") 
Local oStruZB6 := FWFormStruct(1,"ZB6") 

    oModel := MPFormModel():New("MD_TURMA_ALUNO", {|oModel| MdlPreValid(oModel)}, {|oModel| MdlPosValid(oModel)})  
    oModel:SetDescription("Cadastro de Turma x Aluno x Nota")    
    
    oModel:addFields('MASTERZB5',,oStruZB5,{|oField,cAction,cIDField| TurmaPreValid(oField,cAction,cIDField)},{|oFieldZB5| TurmaPosValid(oFieldZB5)})  
    oModel:addGrid('DETAILZB6','MASTERZB5',oStruZB6,;
					{|oGrid,nLine,cAction,cIDField,xValueNew,xValueOld| LinePreAluno(oGrid,nLine,cAction,cIDField,xValueNew,xValueOld)},{|oGrid,nLine| LinePosAluno(oGrid,nLine)},;
					{|oGrid,nLine,cAction,cIDField| AlunoPreValid(oGrid,nLine,cAction,cIDField)}, {|oGrid| AlunoPosValid(oGrid)})  
 
    oModel:getModel('MASTERZB5'):SetDescription('Dados da Turma')  
    oModel:getModel('DETAILZB6'):SetDescription('Dados do Aluno')  

    oModel:SetRelation("DETAILZB6", ;       
 					{{"ZB6_FILIAL",'xFilial("ZB6")'},;        
 						{"ZB6_CODTUR","ZB5_CODTUR"  }}, ;       
 						ZB6->(IndexKey(1)))
Return oModel 

Static Function ViewDef() 
Local oModel := ModelDef() 
Local oView 
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6')

    oStrZB6:RemoveField('ZB6_CODTUR')
	
	oView := FWFormView():New()  
	oView:SetModel(oModel)    
	
    oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')  	

	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 20)  
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 80)  
	
 	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')  
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')    	
	
Return oView 

Static Function MdlPreValid(oModel)
Local lValid := .T.
Return lValid

Static Function MdlPosValid(oModel)
Local lValid := .T.
Return lValid

Static Function TurmaPreValid(oField,cAction,cIDField)
Local lValid := .T.
Return lValid

Static Function TurmaPosValid(oField) 
Local lValid := .T. 
Local cDescr := oField:GetValue("ZB5_DESTUR") 
 
    If "TURMA" $ Upper(cDescr)   
 	    Help( ,, 'HELP',, 'A descrição da turma não pode conter o nome "TURMA".', 1, 0)   
 	    lValid := .F.  
    EndIf

Return lValid 
 
Static Function LinePreAluno(oGrid,nLine,cAction,cIDField,xValueNew,xValueOld) 
Local lValid := .T.    
	
	If cAction == "UNDELETE"   
		Help( ,, 'HELP',, 'Não é possivel desfazer a deleção de um Aluno da turma.', 1, 0)   
		lValid := .F.  
	EndIf    
Return lValid  

Static Function LinePosAluno(oGrid,nLine) 
Local lValid := .T. 
Local cRA := oGrid:GetValue("ZB6_RA") 
 
 If IsAlpha(cRA)   
 	Help( ,, 'HELP',, 'O RA do aluno não pode iniciar com uma letra.', 1, 0)   
 	lValid := .F.  
 EndIf 
 
Return lValid  

Static Function AlunoPreValid(oGrid,nLine,cAction,cIDField)
Local lValid := .T.
Return lValid

Static Function AlunoPosValid(oGrid)
Local lValid := .T.
Local nX

	For nX:= 1 to oGrid:Length()
		If !oGrid:IsDeleted(nX)
			If 'TESTE' $ oGrid:GetValue('ZB6_NOME',nX)
				Help( ,, 'HELP',, 'O nome do aluno não pode iniciar conter a palavra TESTE.', 1, 0)   
				lValid := .F.
				exit
			EndIf
		EndIf
	Next
	
Return lValid