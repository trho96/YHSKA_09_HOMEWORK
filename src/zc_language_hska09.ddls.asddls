@EndUserText.label: 'Language projection view - Processor'
@AccessControl.authorizationCheck: #CHECK
@UI: {
    headerInfo: { typeName: 'Programming Language', typeNamePlural: 'Programming Languages', title: { type: #STANDARD, value: 'listing_id' } }
}
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_LANGUAGE_HSKA09
  as projection on ZI_LANGUAGE_HSKA09
{
      @UI.facet: [ { id:              'Language',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Details',
                     position:        10 },
                   { id: 'idHeader' ,
                     type: #DATAPOINT_REFERENCE ,
                     position: 10,
                     label: 'Header' ,
                     purpose: #HEADER ,
                     targetQualifier: 'Rating' },
                   { id: 'idHeader' ,
                     type: #DATAPOINT_REFERENCE ,
                     position: 20,
                     purpose: #HEADER ,
                     targetQualifier: 'popularity' } ]
  @UI.hidden: true
  key listing_id,
  
      @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } , { position: 10, type: #AS_DATAPOINT } ],
          identification: [ { position: 10, label: 'Programming Language' } ] 
      }
      @Search.defaultSearchElement: true
      @UI.dataPoint:{title:'Programming Language', targetValueElement: 'name'}
      name,
      
      @UI: {
          lineItem:       [ { position: 20, type: #AS_DATAPOINT} ],
          identification: [ { position: 20, label: 'Popularity' } ]
      }
      @UI.dataPoint:{title:'Popularity in %',visualization:#PROGRESS, targetValueElement: 'popularity', targetValue: 100}
      popularity,
      
      @UI: {
          lineItem:       [ { position: 30, importance: #HIGH } ],
          identification: [ { position: 30, label: 'Trend' } ]
      }
      trend,
      
      @UI: {
          lineItem:       [ { position: 40, importance: #HIGH } ],
          identification: [ { position: 40, label: 'Region' } ]
      }
      region,

      @UI: {
          lineItem:[ { position: 50, type: #AS_DATAPOINT } ],
          identification: [ { position: 50, label: 'Rating' } ]
      }
      @UI.dataPoint:{title:'Rating',visualization:#RATING,targetValue:5}
      Rating,
      
      @UI: {
          lineItem:       [ { position: 60, importance: #HIGH,criticality: 'Criticality' },
                            { type: #FOR_ACTION, dataAction: 'acceptBlacklisted', label: 'Set Blacklisted' } ],
          identification: [ { position: 60, label: 'BlackListed' } ] 
      }
      @UI.dataPoint:{title:'Blacklisted', targetValueElement: 'Blacklisted'}
      Blacklisted,
      
      @UI: {
          identification: [ { position: 70, label: 'Developer' } ] 
      }
      Developer,
      
      @UI: {
          identification: [ { position: 80, label: 'Publishing Year' } ] 
      }
      Publishing_Year,
      
      @UI: {
          lineItem:[ { position: 90, importance: #HIGH }],
          identification: [ { position: 90, label: 'Language ID' } ]
      }
      language_id,
      
      Criticality

}
