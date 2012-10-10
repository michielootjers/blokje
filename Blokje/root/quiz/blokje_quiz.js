$( document ).bind('pageshow', function() {
    waitForState();
});

function getState() {
    $.getJSON(
        '/quiz',
        function(data) {
            var state = data.json;
            handleState(state);
        }
    );
}

function waitForState() {
    if (!$.mobile.activePage || !$.mobile.activePage.hasClass('initialized')) {
        $.mobile.changePage('#page6');
    }
    setTimeout("getState()", 5000);
}

function handleState(state) {
    if (!state.team) {
        console.log('Team not set, handle team');
        handleTeam(state);
        return true;
    }

    if (!state.question) {
        console.log('Question not set, show nothing');
        // Moet niks worden
        $('div#niks').addClass('initialized');
        $.mobile.changePage('#niks');
        waitForState();
    }

    if (state.question) {
        loadQuestion(state);
    }
}

function handleTeam(state) {
    if ($.mobile.activePage.attr('id') == 'page1') {
        return true;
    }

    $('div#page1').addClass('initialized');
    $.mobile.changePage('#page1');

    $('div#page1 input[name="Teamnaam"]').val(state.team);

    $('div#page1 a').click(function() {
        registerTeam(
            $('div#page1 input[name="Teamnaam"]').val()
        );

        return false;
    });
}

function registerTeam(name) {
    $.getJSON(
        '/quiz/team/update',
        {
            name: name
        },
        function(data) {
            var state = data.json;

            console.log('getState, register');
            setTimeout("getState()", 500);
        }
    );
}


function loadQuestion(state) {
    if (
        $.mobile.activePage.attr('id') == 'page2' &&
        $('#page2 [data-role="content"] h3').html() &&
        $('#page2 [data-role="content"] h3').html() == state.question.question
    ) {
        console.log('wait for state, no question');
        waitForState();
        return true;
    }

    /* Check if current question is active */
    $('#page2 [data-role="content"] h3').html(state.question.question);

    $('#page2 input[type="radio"]').each(function() {
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

        $('#page2 fieldset[data-role="controlgroup"]').append(radio);
        $('#page2 fieldset[data-role="controlgroup"]').append(label);

    });

    $('div#page2 [data-role="button"]').click(function() {
        answerQuestion(
            $('#page2 [data-role="content"] h3').html(),
            $('#page2 input[type="radio"]:checked').val()
        );

        return false;
    });

    $('#page2 input[type="radio"]').checkboxradio();
    $('#page2').trigger('create');
    console.log('wait for state, question refresh');
    $('div#page2').addClass('initialized');
    $.mobile.changePage('#page2');
}

function answerQuestion(question, answer) {
    $.getJSON(
        '/quiz/answer/update',
        {
            question: question,
            answer: answer
        },
        function(data) {
            var state = data.json;

            console.log('getState, answerQuestion');

            if (state.result) {
                console.log('Answer: done');
                $('div#page3').addClass('initialized');
                $.mobile.changePage('#page3');
            } else {
                setTimeout("getState()", 500);
            }
        }
    );
}
