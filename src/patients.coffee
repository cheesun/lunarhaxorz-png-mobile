(($) ->

  logError = (err) ->
    console.log(err)

  patients = {
    init: () ->
      db = window.openDatabase('test', '1.0', 'test', 200000)
      db.transaction((tx) ->
        tx.executeSql('create table if not exists patients (id, name)'),
        logError
      )

    getAll: () ->
      db = window.openDatabase('test', '1.0', 'test', 200000)
      db.transaction((tx) ->
        tx.executeSql('select * from patients'),
        logError
      )
  }

  searcher = {
    bind: (inputId, buttonId) ->
      @input = $(id)
      @button = $(button)
      @button.click( () =>
        @search(@input.value)
      )
  }



) jQuery
