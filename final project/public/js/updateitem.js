function updateitem(id){
    $.ajax({
        url: '/pack/' + id,
        type: 'PUT',
        data: $('#update-item').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};