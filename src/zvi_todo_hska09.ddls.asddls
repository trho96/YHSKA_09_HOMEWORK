@AbapCatalog.sqlViewName: 'ZVI_TODO_HSKA09'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data model for todo'
define root view ZI_TODO_HSKA09 as select from yhska09_todo as todo {
     key language_id,
     name,
     @EndUserText.label: 'Todo'
     todo
}
