function deleteitem(id){
    $.ajax({
        url: '/pack/item' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};