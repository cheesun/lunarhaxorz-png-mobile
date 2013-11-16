(($) ->

  logError = (err) ->
    console.log(err)

  patients = {
    init: () ->
      db = window.openDatabase('test', '1.0', 'test', 200000)
      db.transaction((tx) ->
        tx.executeSql('drop table patients')
        tx.executeSql('create table if not exists patients (id unique, name)')
        tx.executeSql('insert into patients (id, name) values (1, "david")')
        tx.executeSql('insert into patients (id, name) values (2, "zhao")')
        tx.executeSql('insert into patients (id, name) values (3, "chees")')
        tx.executeSql('insert into patients (id, name) values (4, "ping")')
        tx.executeSql('insert into patients (id, name) values (5, "alistair")')
        tx.executeSql('insert into patients (id, name) values (6, "cyb")')
      , logError
      )

    getAll: (callback) ->
      db = window.openDatabase('test', '1.0', 'test', 200000)
      db.transaction((tx) ->
        tx.executeSql('select * from patients', [],
          (tx, results) ->
            callback(results)
          logError
        )
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

  buildTable = () ->
    source = $("#patient-template").html()
    template = Handlebars.compile(source)
    patients.getAll((results) ->
      for i in [0..results.rows.length]
        value = results.rows.item(i)
        $('#patients-table tbody').append(template({ id: value.id, name: value.name}))
    )
    $('#patients-table').sieve()

  patients.init()
  buildTable()


) jQuery
