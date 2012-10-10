$( document ).bind('pageshow', function() {
    if (
        $.mobile.activePage &&
        $.mobile.activePage.attr('id') == 'vragen'
    ) {
        loadVragen();
        return true;
    }

    if (
        $.mobile.activePage &&
        $.mobile.activePage.attr('id') == 'teamlist'
    ) {
        loadTeams();
        return true;
    }

    if ($.mobile.activePage && $.mobile.activePage.hasClass('initialized')) {
        return true;
    }

    $.mobile.changePage('#home');
});

function loadVragen() {
    $.getJSON(
        '/quiz/master',
        function(data) {
            var state = data.json.master;

            var ulelem = $('#vragen ul[data-role="listview"]');

            $('#vragen ul[data-role="listview"] li').remove();

            $.each(state.questions, function(index,value) {
                var lielem = $('<li data-theme="c"><a href="#" data-transition="slide">'
                    + value + '</a></li>'
                );

                console.log('append');
                ulelem.append(lielem);

                lielem.find('a').click(function() {
                    loadQuestion($(this).html());
                    return false;
                });
            });

            ulelem.listview('refresh');
        }
    );
}

function loadTeams() {
    $.getJSON(
        '/quiz/master',
        function(data) {
            var state = data.json.master;

            var ulelem = $('#teamlist ul[data-role="listview"]');

            $('#teamlist ul[data-role="listview"] li').remove();

            $.each(state.questions, function(index,value) {
                var lielem = $('<li data-theme="c"><a href="#" data-transition="slide">'
                    + value + '</a></li>'
                );

                console.log('append');
                ulelem.append(lielem);

                lielem.find('a').click(function() {
                    loadQuestion($(this).html());
                    return false;
                });
            });

            ulelem.listview('refresh');
        }
    );
}

function loadQuestion(name) {
    $.getJSON(
        '/quiz/master/question',
        {
            question: name,
        },
        function(data) {
            var state = data.json.master;

            $('div#vraag').addClass('initialized');
            $.mobile.changePage('#vraag');

            $('#vraag [data-role="content"] h2').html(state.question.question);

            $('#vraag input[type="radio"]').each(function() {
                $('label[for="' + $(this).attr('id') + '"]').remove();
                $(this).remove();
            });

            $.each(state.question.options, function(index,value) {
                var radio = $(
                    '<input type="radio" id="radio_'
                    + index
                    + '" name="answer" value="' + value + '">'
                );
                var label = $('<label for="radio_' + index + '">' + value + '</label>');

                $('#vraag fieldset[data-role="controlgroup"]').append(radio);
                $('#vraag fieldset[data-role="controlgroup"]').append(label);
            });

            $('#vraag .activeer').click(function() {
                activateQuestion(state.question.question);
                return false;
            });

            //$('#vraag input[type="radio"]').checkboxradio();
            //$('#vraag fieldset[data-role="controlgroup"]').controlgroup('refresh');

            $('#vraag').trigger('create');

        }
    );
}

function activateQuestion(name) {
    $.getJSON(
        '/quiz/master/question/activate',
        {
            question: name,
        },
        function(data) {
            var state = data.json.master;

            var ulelem = $('#teams ul[data-role="listview"]');

            $('div#teams').addClass('initialized');
            $.mobile.changePage('#teams');

            $('#teams div[data-role="content"] li').each(function() {
                $(this).remove();
            });

            $.each(state.question.teams, function(index,value) {
                var lielem = $('<li data-theme="c">'
                    + index + '</li>'
                );

                ulelem.append(lielem);

                if (value.correct) {
                    lielem.addClass('ok');
                } else if (value.answer) {
                    lielem.addClass('fail');
                } else {
                    lielem.addClass('pending');
                }

            });

            ulelem.listview('refresh');
        }
    );
}
