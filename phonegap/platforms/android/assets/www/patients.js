(function() {
  (function($) {
    var buildTable;
    $('#add-patient').click(function(event) {
      $$.Patient.create();
      return buildTable();
    });
    $('#reset-database').click(function(event) {
      $$.Database.reset($$.Models);
      return buildTable();
    });
    $('#erase-database').click(function(event) {
      $$.Database.erase($$.Models);
      return buildTable();
    });
    buildTable = function() {
      var template;
      template = Handlebars.compile($("#patient-template").html());
      return $$.Patient.getAllWithName(function(results) {
        var i, value, _i, _ref, _results;
        console.log(results.rows);
        $('#patients-table tbody').empty();
        _results = [];
        for (i = _i = 0, _ref = results.rows.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          value = results.rows.item(i);
          console.log(value);
          _results.push($('#patients-table tbody').append(template({
            id: value.id,
            name: value.name
          })));
        }
        return _results;
      });
    };
    buildTable();
    return $('#patients-table').sieve();
  })(jQuery);

}).call(this);
